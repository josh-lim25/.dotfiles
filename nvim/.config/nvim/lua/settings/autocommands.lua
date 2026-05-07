local M = {}

-- [[ HIGHLIGHT ON YANK ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ JUMP TO LAST CURSOR POSITION ON FILE OPEN ]]
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- [[ REMOVE TRAILING SPACES ]]
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- [[ PREVENT ACCIDENTAL WRITES TO BUFFERS THAT SHOULDN'T BE EDITED ]]
vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.orig", "*.pacnew" },
  command = "set readonly",
})

-- [[ LEAVE PASTE MODE WHEN LEAVING INSERT MODE ]]
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- -- [[ CENTER SCREEN IN INSERT MODE ]]
-- FIXME: still jank, jumps around
--  vim.cmd "autocmd CursorMoved * normal! zz"
-- -- Define the Lua function
-- local function center_cursor()
-- local pos = vim.fn.getpos(".")
-- vim.cmd("normal! zz")
-- vim.fn.setpos(".", pos)
-- end
-- -- Create the autocmd using Lua
-- vim.api.nvim_create_autocmd("CursorMovedI", {
-- pattern = "*",
-- callback = center_cursor
-- })

-- [[ FILETYPE DETECTION (as needed, just example of how) ]]
--vim.api.nvim_create_autocmd('BufRead', { pattern = '*.txt', command = 'set filetype=someft' })
-- }}

-- [[ SET SPELL FOR TEXT FILETYPES ]]
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("setspell", { clear = true }),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    -- command = 'setlocal spell tw=72 colorcolumn=73',
    vim.opt_local.spell = true
  end,
})

-- [[ OPEN DOCS IN FULLSCREEN ]]
-- Usage: <leader>fh -> <leader>; to toggle -> <leader>bd to quit
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.cmd("wincmd T")
  end,
})

-- [[ SET WORKDIR TO FILE YOU'RE EDITING ]]
-- Use case: open random ass file, realize you wanna be in that dir,
-- so you <leader>cd and open a new pane to do stuff
M.change_to_buf_dir = function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    vim.notify("[cd] No file path detected.", vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(filepath, ":p:h")
  if vim.fn.isdirectory(dir) == 1 then
    vim.cmd("lcd " .. vim.fn.fnameescape(dir))
    vim.notify("cwd → " .. dir, vim.log.levels.INFO)
  else
    vim.notify("Invalid directory: " .. dir, vim.log.levels.ERROR)
  end
end

-- [[ START JDTLS FOR JAVA ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  group = vim.api.nvim_create_augroup("jdtls-setup", { clear = true }),
  callback = function()
    require("jdtls.jdtls_setup").setup()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.bo.formatprg = "jq"
  end,
})

return M
