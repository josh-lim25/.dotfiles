-- lua/settings/review.lua
--
-- Change-review helper. This is local config, not a lazy-managed plugin, so it
-- lives with the other settings modules and loads via a plain require from
-- init.lua (same as settings/diagnostics.lua). Do NOT put it under lua/plugins/,
-- that folder is imported by lazy and expects plugin specs, not modules.
--
-- Keymaps (registered at the bottom of this file, on load):
--   <leader>gm  : picker of git-modified files (fzf-lua git_status)
--   <leader>rc  : (visual) queue the current selection + a comment
--   <leader>rf  : flush the queue to the clipboard and ~/.cache/nvim-review-notes/<session>/ANNOTATIONS.md
--   <leader>re  : open the current session's file to edit by hand
--   <leader>rs  : show the queued notes in a scratch buffer
--   <leader>ru  : drop the last note
--   <leader>rx  : clear the queue

local M = {}

-- items: { file, l1, l2, comment, lines = {..}, ft }
M.queue = {}

-- Base directory for flushed notes. Each session writes to its own timestamped
-- subdirectory: <notes_dir>/<session>/ANNOTATIONS.md. The subdir is created on
-- write.
M.notes_dir = vim.fn.expand("~/.cache/nvim-review-notes")

-- A "session" is one batch of annotations. It starts the first time you
-- annotate an empty queue and ends when you flush or clear. session_ts is the
-- timestamp for the current session, or nil between sessions.
M.session_ts = nil

local function session_stamp()
  if not M.session_ts then
    M.session_ts = os.date("%Y-%m-%d_%H-%M-%S")
  end
  return M.session_ts
end

local function relpath()
  local p = vim.fn.expand("%:.")
  if p == "" then
    p = vim.fn.expand("%:p")
  end
  return p
end

-- Visual line range. Valid while visual mode is active, which it is when this
-- runs from an "x" mode mapping bound to a Lua function.
local function visual_range()
  local a = vim.fn.getpos("v")[2]
  local b = vim.fn.getpos(".")[2]
  if a > b then
    a, b = b, a
  end
  return a, b
end

function M.add_comment()
  local file = relpath()
  if file == "" then
    vim.notify("review: this buffer has no file", vim.log.levels.WARN)
    return
  end

  local l1, l2 = visual_range()
  local lines = vim.api.nvim_buf_get_lines(0, l1 - 1, l2, false)
  local ft = vim.bo.filetype

  -- Leave visual mode, then prompt on the next tick so the pending <Esc>
  -- does not cancel the input prompt.
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

  vim.schedule(function()
    local label = string.format("%s:%d-%d", file, l1, l2)
    vim.ui.input({ prompt = "Comment for " .. label .. " > " }, function(comment)
      if comment == nil or comment == "" then
        vim.notify("review: skipped (no comment)", vim.log.levels.INFO)
        return
      end
      session_stamp() -- starts a session on the first note; no-op afterwards
      table.insert(M.queue, { file = file, l1 = l1, l2 = l2, comment = comment, lines = lines, ft = ft })
      vim.notify(string.format("review: queued %s (%d total)", label, #M.queue))
    end)
  end)
end

local function build_prompt()
  local out = {}
  table.insert(out, "Please review these changes and make targeted fixes.")
  table.insert(out, "Each item lists a file with a line range, my comment, and the exact lines I selected.")
  table.insert(out, "Line numbers may shift as you edit, so match each region by its content.")
  table.insert(out, "Make edits to files from the bottom up to preserve line number integrity where possible.")

  -- Group items by file, keeping files in the order each was first annotated.
  -- Within a file, order by start line so the bottom-up edit order is clear
  -- even when selections were captured out of order or across files.
  local order = {} -- files, first-seen order
  local groups = {} -- file -> items
  for _, it in ipairs(M.queue) do
    if not groups[it.file] then
      groups[it.file] = {}
      table.insert(order, it.file)
    end
    table.insert(groups[it.file], it)
  end

  local n = 0
  for _, file in ipairs(order) do
    local items = groups[file]
    table.sort(items, function(a, b)
      return a.l1 < b.l1
    end)
    for _, it in ipairs(items) do
      n = n + 1
      table.insert(out, string.format("%d. %s:%d-%d", n, it.file, it.l1, it.l2))
      table.insert(out, it.comment)
      table.insert(out, "```" .. (it.ft ~= "" and it.ft or ""))
      for _, line in ipairs(it.lines) do
        table.insert(out, line)
      end
      table.insert(out, "```")
      table.insert(out, "")
    end
  end

  return table.concat(out, "\n")
end

-- Absolute path of the current session's annotations file.
local function session_file()
  return M.notes_dir .. "/" .. session_stamp() .. "/ANNOTATIONS.md"
end

-- Write text to path, creating the parent directory first. Returns the path on
-- success, or nil (after notifying) on failure.
local function write_file(path, text)
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    pcall(vim.fn.mkdir, dir, "p")
  end
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("review: could not create " .. dir, vim.log.levels.ERROR)
    return nil
  end
  local fh = io.open(path, "w")
  if not fh then
    vim.notify("review: could not open " .. path, vim.log.levels.ERROR)
    return nil
  end
  fh:write(text)
  fh:close()
  return path
end

-- opts.file : explicit path to write, or false to skip the file. Default is
--             <notes_dir>/<session>/ANNOTATIONS.md.
-- opts.keep : true to keep the queue (and the session) after flushing.
--             Default clears both.
function M.flush(opts)
  opts = opts or {}
  if #M.queue == 0 then
    vim.notify("review: queue is empty", vim.log.levels.WARN)
    return
  end

  local text = build_prompt()
  -- '+' respects your clipboard config (system clipboard locally, OSC 52 over
  -- SSH); '"' means a plain `p` pastes it too.
  vim.fn.setreg("+", text)
  vim.fn.setreg('"', text)

  local wrote_path = nil
  if opts.file ~= false then
    -- Each session lands in its own timestamped subdirectory.
    wrote_path = write_file(opts.file or session_file(), text)
  end

  local n = #M.queue
  if opts.keep ~= true then
    M.queue = {}
    M.session_ts = nil -- end the session; the next annotation starts a new one
  end

  if wrote_path then
    vim.notify(string.format("review: flushed %d note(s) to clipboard and %s", n, vim.fn.fnamemodify(wrote_path, ":~")))
  else
    vim.notify(string.format("review: flushed %d note(s) to clipboard", n))
  end
end

-- Open the current session's annotations file in a split to edit by hand. If it
-- does not exist yet, it is seeded with the current queue (the header plus any
-- notes). A flush regenerates this file from the queue and overwrites hand
-- edits, so once you edit here, send this file rather than flushing again.
function M.edit()
  local path = session_file()
  if vim.fn.filereadable(path) == 0 then
    if not write_file(path, build_prompt()) then
      return
    end
  end
  -- Focus an existing window showing the file, otherwise open a bottom split.
  local bufnr = vim.fn.bufnr(path)
  local win = (bufnr ~= -1) and vim.fn.bufwinid(bufnr) or -1
  if win ~= -1 then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd("botright split " .. vim.fn.fnameescape(path))
  end
end

function M.show()
  if #M.queue == 0 then
    vim.notify("review: queue is empty", vim.log.levels.INFO)
    return
  end
  vim.cmd("botright new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(build_prompt(), "\n"))
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
end

function M.undo()
  if #M.queue == 0 then
    vim.notify("review: queue is empty", vim.log.levels.INFO)
    return
  end
  local it = table.remove(M.queue)
  if #M.queue == 0 then
    M.session_ts = nil -- emptied by undo; next annotation starts a new session
  end
  vim.notify(string.format("review: removed %s:%d-%d (%d left)", it.file, it.l1, it.l2, #M.queue))
end

function M.clear()
  M.queue = {}
  M.session_ts = nil
  vim.notify("review: queue cleared")
end

-- [[ KEYMAPS ]] (set on load, same pattern as settings/diagnostics.lua)
local keymap = vim.keymap.set
keymap("x", "<leader>rr", M.add_comment, { desc = "Review: queue selection + comment" })
keymap("n", "<leader>rw", function()
  M.flush()
end, { desc = "[R]eview: [f]lush queue" })
keymap("n", "<leader>re", M.edit, { desc = "Review: edit the session file" })
keymap("n", "<leader>rs", M.show, { desc = "Review: show queued notes" })
keymap("n", "<leader>ru", M.undo, { desc = "Review: undo last note" })
keymap("n", "<leader>rx", M.clear, { desc = "Review: clear queue" })

return M
