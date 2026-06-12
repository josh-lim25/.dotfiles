-- SAFETY: only run inside VSCode (this file should only ever be loaded there).
if not vim.g.vscode then
  return
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local vscode = require("vscode")
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local o = vim.opt

o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.virtualedit = "block"
o.timeout = true
o.ttimeout = true
o.ttimeoutlen = -1
o.timeoutlen = 250
o.iskeyword:remove("_")      -- w/e/b/text-objects stop at underscores
o.iskeyword:remove("-")      -- ...and at hyphens

-- easier common change/delete-to ops
keymap("n", "cu", "ct_", opts)
keymap("n", "du", "dt_", opts)
keymap("n", "c.", "ct.", opts)
keymap("n", "d.", "dt.", opts)
keymap("n", 'c"', 'ct"', opts)
keymap("n", 'd"', 'dt"', opts)
keymap("n", "c'", "ct'", opts)
keymap("n", "d'", "dt'", opts)
keymap("x", ",", "t,", opts)
keymap("x", ".", "t.", opts)

-- line start/end
keymap({ "n", "v", "x", "o" }, "H", "^", opts)
keymap({ "n", "v", "x", "o" }, "L", "$", opts)
keymap({ "n", "v", "x", "o" }, "gH", "g^", opts)
keymap({ "n", "v", "x", "o" }, "gL", "g$", opts)

-- move selected lines vertically
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- join, keep cursor
keymap("n", "J", "mzJ`z")

-- visual-line I/A -> block insert (nvim handles the visual trigger)
keymap("x", "I", function()
  return vim.fn.mode() == "V" and "^<C-v>I" or "I"
end, { expr = true })
keymap("x", "A", function()
  return vim.fn.mode() == "V" and "$<C-v>A" or "A"
end, { expr = true })

-- duplicate line + comment original (native `gc`, requires nvim >= 0.10)
keymap("n", "yc", "yygccp", { remap = true })

-- global substitute of word under cursor
keymap("n", "S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><C-w>]], opts)

-- anti-textwrap j/k
keymap({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- very-nomagic search
keymap("n", "?", "?\\V")
keymap("n", "/", "/\\V")
keymap("c", "%s/", "%sm/")

-- clear search highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- keep paste register clean
keymap("x", "<leader>p", [["_dP]])
keymap("n", "cc", '"_cc', opts)

-- reselect last changed/pasted region
keymap("n", "<leader>v", "`[V`]", opts)

-- select entire buffer
keymap("n", "gG", "gg<S-v>G", { desc = "Select all" })

-- repeat change to EOL / inside selection
keymap("n", "<leader>.", function()
  vim.fn.setreg("z", ";.@z")
  vim.cmd("normal! @z")
end, { desc = "Repeat change to end of line" })
keymap("x", "<leader>.", function()
  vim.fn.setreg("z", ";.@z")
  vim.cmd("normal! gv")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":norm! @z<cr>", true, false, true), "n", false)
end, { desc = "Repeat change inside selection" })

-- shell filters
keymap("n", "<leader>so", ":.!sh<CR>", { noremap = true, desc = "Shell output" })
keymap("x", "<leader>wc", ":'<,'>w !wc<CR>", { desc = "Word count selection" })
keymap("x", "<leader>mf", ":'<,'>! tr -s ' ' | column -t -s '|' -o '|'<CR>", opts)

-- cd to current buffer's dir
keymap("n", "<leader>cd", function()
  vim.cmd("cd %:p:h")
  vim.notify("cwd -> " .. vim.fn.expand("%:p:h"))
end, { desc = "cd to buffer dir" })

-- ----------------------------------------------
--                 VSCODE MAPS                 --
-- ----------------------------------------------
local function action(name)
  return function()
    vscode.action(name)
  end
end

-- nvim 0.11+ ships default `gr`-prefixed LSP maps (grn/gra/grr/gri/grt),
-- `gr` would wait `timeoutlen` to disambiguate.
for _, m in ipairs({
  { "n", "grn" }, { "n", "gra" }, { "x", "gra" }, { "n", "grr" }, { "n", "gri" }, { "n", "grt" },
}) do
  pcall(vim.keymap.del, m[1], m[2])
end

-- LSP / code navigation
keymap("n", "gr", action("editor.action.referenceSearch.trigger"), { desc = "References" })
keymap("n", "gI", action("editor.action.goToImplementation"), { desc = "Implementation" })
keymap("n", "gy", action("editor.action.goToTypeDefinition"), { desc = "Type definition" })
keymap("n", "gD", action("editor.action.revealDeclaration"), { desc = "Declaration" })
keymap("n", "<leader>rn", action("editor.action.rename"), { desc = "Rename" })
keymap({ "n", "x" }, "<leader>ca", action("editor.action.quickFix"), { desc = "Code action" })
keymap({ "n", "x" }, "<leader>cap", function()
  vscode.with_insert(function()
    vscode.action("editor.action.refactor")
  end)
end, { desc = "Refactor" })
keymap("n", "<leader>th", function()
  local cur = vscode.get_config("editor.inlayHints.enabled")
  vscode.update_config("editor.inlayHints.enabled", cur == "on" and "off" or "on", "global")
end, { desc = "Toggle inlay hints" })

-- diagnostics
keymap("n", "]d", action("editor.action.marker.next"), { desc = "Next diagnostic" })
keymap("n", "[d", action("editor.action.marker.prev"), { desc = "Prev diagnostic" })
keymap("n", "<leader>q", action("workbench.actions.view.problems"), { desc = "Problems panel" })
keymap("n", "<leader>fd", action("workbench.actions.view.problems"), { desc = "Document diagnostics" })

-- finders
keymap("n", "<leader>ff", action("workbench.action.quickOpen"), { desc = "Find files" })
keymap("n", "<leader>fg", action("workbench.action.findInFiles"), { desc = "Live grep" })
keymap("n", "<leader>/", action("actions.find"), { desc = "Find in buffer" })
keymap("n", "<leader><leader>", action("workbench.action.showAllEditors"), { desc = "Open editors" })
keymap("n", "<leader>fo", action("workbench.action.openRecent"), { desc = "Recent files" })
keymap("n", "<leader>fs", action("workbench.action.gotoSymbol"), { desc = "Document symbols" })
keymap("n", "<leader>fS", action("workbench.action.showAllSymbols"), { desc = "Workspace symbols" })
keymap("n", "<leader>fk", action("workbench.action.openGlobalKeybindings"), { desc = "Keybindings" })
keymap("n", "<leader>fw", function()
  vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end, { desc = "Grep word under cursor" })
keymap("n", "<leader>fW", function()
  vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cWORD>") } })
end, { desc = "Grep WORD under cursor" })

-- switching buffers
keymap("n", "<leader>j", action("workbench.action.previousEditor"), { desc = "Prev editor" })
keymap("n", "<leader>k", action("workbench.action.nextEditor"), { desc = "Next editor" })
keymap("n", "<leader>bd", action("workbench.action.closeActiveEditor"), { desc = "Close editor" })
keymap("n", "<leader>;", action("workbench.action.openPreviousRecentlyUsedEditorInGroup"), { desc = "MRU editor" })

-- vim: ts=2 sts=2 sw=2 et
