local M = {}

-- A single persistent file for all review notes
M.notes_file = vim.fn.expand("/tmp/nvim-review-notes/REVIEW.md")

local function relpath()
  local p = vim.fn.expand("%:.")
  return p == "" and vim.fn.expand("%:p") or p
end

local function visual_range()
  local a = vim.fn.getpos("v")[2]
  local b = vim.fn.getpos(".")[2]
  return math.min(a, b), math.max(a, b)
end

local function append_to_file(text)
  local dir = vim.fn.fnamemodify(M.notes_file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  -- If file doesn't exist, seed it with the LLM prompt header
  local is_new = vim.fn.filereadable(M.notes_file) == 0
  local fh = io.open(M.notes_file, "a")
  if not fh then
    return vim.notify("review: could not open " .. M.notes_file, vim.log.levels.ERROR)
  end

  if is_new then
    fh:write("Please review these changes and make targeted fixes.\n")
    fh:write("Each item lists a file with a line range, my comment, and the exact lines I selected.\n")
    fh:write("Line numbers may shift as you edit, so match each region by its content.\n")
    fh:write("When there is a clear-cut right answer for review comments, apply them in a way that gets at the heart of the comment and respects existing conventions.\n")
    fh:write("When there is a NOT clear-cut right answer for review comments, give rationale and present tradeoffs.\n")
    fh:write("Make edits to files from the bottom up to preserve line number integrity where possible.\n\n")
  end

  fh:write(text)
  fh:close()
end

function M.add_comment()
  local file = relpath()
  if file == "" then
    return vim.notify("review: this buffer has no file", vim.log.levels.WARN)
  end

  local l1, l2 = visual_range()
  local lines = vim.api.nvim_buf_get_lines(0, l1 - 1, l2, false)
  local ft = vim.bo.filetype

  -- Leave visual mode before prompting
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

  vim.schedule(function()
    local label = string.format("%s:%d-%d", file, l1, l2)
    vim.ui.input({ prompt = "Comment for " .. label .. " > " }, function(comment)
      if not comment or comment == "" then
        return vim.notify("review: skipped (no comment)", vim.log.levels.INFO)
      end

      -- Build the markdown block and append instantly
      local out = {
        string.format("### %s", label),
        comment,
        "```" .. (ft ~= "" and ft or ""),
      }
      for _, line in ipairs(lines) do
        table.insert(out, line)
      end
      table.insert(out, "```\n\n")

      append_to_file(table.concat(out, "\n"))
      vim.notify("review: saved note to " .. M.notes_file)
    end)
  end)
end

function M.edit()
  -- Ensure the file exists before trying to open it
  if vim.fn.filereadable(M.notes_file) == 0 then
    append_to_file("")
  end

  local bufnr = vim.fn.bufnr(M.notes_file)
  local win = (bufnr ~= -1) and vim.fn.bufwinid(bufnr) or -1

  if win ~= -1 then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd("botright split " .. vim.fn.fnameescape(M.notes_file))
  end
end

-- [[ KEYMAPS ]]
vim.keymap.set("x", "<leader>rr", M.add_comment, { desc = "Review: add and save comment" })
vim.keymap.set("n", "<leader>re", M.edit, { desc = "Review: edit persistent notes file" })

return M
