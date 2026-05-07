-- NOTE: weird modes — vblock/`<C-v>` (x), term (t), cmd mode/`:` (c), visual (v), visual line (V)
-- o: "operator-pending" mode - when you wait for a motion after an operator like d, y, c (e.g., after pressing d but before a movement)
-- INFO: vim.keymap.set({mode}, {lhs}, {rhs}, {opts}), `lhs` = input, `rhs` = cmd

-- [[ ESSENTIAL ]] {{
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local autocmds = require("settings.autocommands")

-- [[ EASIER KEYBINDS FOR COMMON OPS ]]
keymap("n", "cu", "ct_", opts)
keymap("n", "du", "dt_", opts)
keymap("n", "c.", "ct.", opts)
keymap("n", "d.", "dt.", opts)
keymap("n", 'c"', 'ct"', opts)
keymap("n", 'd"', 'dt"', opts)
keymap("n", "c'", "ct'", opts)
keymap("n", "d'", "dt'", opts)
keymap("x", ",", "t,", opts) -- TODO: get f, F behavior w/; and , see treesitter textobjs
keymap("x", ".", "t.", opts)
keymap({ "n", "v", "x", "o" }, "H", "^", opts)
keymap({ "n", "v", "x", "o" }, "L", "$", opts)
keymap({ "n", "v", "x", "o" }, "gH", "g^", opts)
keymap({ "n", "v", "x", "o" }, "gL", "g$", opts)
keymap({ "n", "v", "x", "o" }, "<C-e>", "$%", opts) -- WHY DIDNT I DO THIS EARLIER
keymap("n", "<leader>e", "q:", { noremap = true, silent = true, desc = "[E]dit commands in cmd line window" })

-- [[ "WRITE NO FORMAT" ]]
keymap("n", "<leader>wnf", ":noautocmd w <CR>", { noremap = true, silent = true, desc = "[W]rite [N]o [F]ormat" })
-- }}

-- [[ QOL ]] {{
-- [[ MOVE VISUALLY SELECTED LINES/BLOCKS VERTICALLY ]]
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- [[ DUPLICATE A LINE, COMMENT OUT THE ORIGINAL LINE ]]
keymap("n", "yc", "yygccp", { remap = true }) -- NOTE: `remap = true` is required

-- [[ SENSIBLE BEHAVIOR ]]
keymap("n", "J", "mzJ`z")
keymap("x", "I", function()
  return vim.fn.mode() == "V" and "^<C-v>I" or "I"
end, { expr = true })
keymap("x", "A", function()
  return vim.fn.mode() == "V" and "$<C-v>A" or "A"
end, { expr = true })

-- [[ STOP KILLING BROWSER WINDOW. HAD TO BE DONE. ]]
-- NOTE: "CTRL+Backspace sends the same control character as CTRL+H, so for terminal they are exactly the same key combination.
-- Others: TAB/CTRL+I, ESC/CTRL+[, ENTER/CTRL+M."
vim.keymap.set({ "i", "c" }, "<C-H>", "<C-W>", { desc = "Delete previous word (Ctrl+Backspace)" })

-- [[ GLOBAL SUBSTITUTION ]]
-- keymap("n", "<leader>su", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
keymap("n", "S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><C-w>]], opts)

-- [[ SET WORKDIR TO FILE YOU'RE EDITING ]]
keymap(
  "n",
  "<leader>cd",
  autocmds.change_to_buf_dir,
  { noremap = true, silent = true, desc = "[C]hange [D]irectory to current buffer path" }
)

-- [[ DOCS AND TYPE INFO ]]
keymap("n", "<leader>fh", ":help <C-r><C-w><CR>", { desc = "[F]ind [H]elp for word under cursor" })
keymap("n", "<leader>i", ":Inspect<CR>", { desc = "[I]nspect word under cursor" })

-- TODO: https://github.com/sheerun/blog/blob/master/_posts/2014-03-21-how-to-boost-your-vim-productivity.markdown#iv-discover-text-search-object

-- [[ STAY IN INDENT MODE ]]
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- [[ TYPE SHELL COMMANDS IN A FILE AND EXPAND THE OUTPUT ]]
keymap("n", "<leader>so", ":.!sh<cr>", { noremap = true, desc = "[S]hell [O]utput" })

-- [[ ANTI-TEXTWRAP ]]
-- keymap({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- keymap({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ VERTICAL MVMT ]]
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- [[ CENTER SEARCH RESULTS ]]
keymap("n", "n", "nzzzv", { silent = true })
keymap("n", "N", "Nzzzv", { silent = true })
keymap("n", "*", "*zz", { silent = true })
keymap("n", "#", "#zz", { silent = true })
keymap("n", "g*", "g*zz", { silent = true })

-- [[ NO MORE ESCAPING SPECIAL CHARS IN SEARCH ]]
-- INFO: `\V` (Very nomagic) treats almost everything as literal, whereas `\v` (very magic) treats almost everything as special (which is best for regex-heavy use).
keymap("n", "?", "?\\V")
keymap("n", "/", "/\\V")
keymap("c", "%s/", "%sm/") -- easier regexes

-- keymap('n', '?', '?\\v')
-- keymap('n', '/', '/\\v')
-- keymap('c', '%s/', '%sm/')

-- [[ WORD COUNT FOR VISUAL SELECTION ]]
keymap("x", "<leader>wc", ":'<,'>w !wc <CR>", { desc = "[W]ord [C]ount selection" })

-- [[ FORMAT MARKDOWN TABLE ]]
-- src: https://heitorpb.github.io/bla/format-tables-in-vim/
-- ! tr -s " " | column -t -s '|' -o '|'
keymap(
  "x",
  "<leader>mf",
  ":'<,'>! tr -s ' ' | column -t -s '|' -o '|'<CR>",
  { desc = "[M]arkdown [F]ormat  table", noremap = true, silent = true }
)

-- [[ APPLY CHANGE ACROSS LINE OR VISUAL SELECTION (i.e., ;.;.;.) ]]
-- Normal Mode: Just runs the loop
vim.keymap.set("n", "<leader>.", function()
  vim.fn.setreg("z", ";.@z")
  vim.cmd("normal! @z")
end, { desc = "Repeat change to end of line" })

-- Visual Mode: Re-selects the area and runs the loop inside it
vim.keymap.set("x", "<leader>.", function()
  -- 1. Save the last search-and-repeat macro
  vim.fn.setreg("z", ";.@z")
  -- 2. 'gv' re-selects the last visual area
  -- 3. ':norm @z' runs the macro on that selection
  -- We use <esc> to ensure we are in a clean state before running
  vim.cmd("normal! gv")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":norm! @z<cr>", true, false, true), "n", false)
end, { desc = "Repeat change inside selection" })
-- }}

-- [[ TOGGLES ]] {{
-- [[ TOGGLE SEARCH HIGHLIGHTS ]]
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- [[ TOGGLE ROOT FOR OPS ]]
-- TODO: fix search behavior
-- HELP: file-searching,
-- :help finddir and :help fnamemodify
local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end
keymap("n", "<leader>tr", function()
  local new = get_git_root()
  vim.api.nvim_set_current_dir(get_git_root())
  vim.notify(string.format("Changed root to: %s", new))
end, {})

-- keymap('n', '<leader>tr', function()
--   vim.g.use_git_root = not vim.g.use_git_root
--   local cwd = vim.g.use_git_root and vim.fs.root(0, '.git') or vim.uv.cwd()
--   vim.notify(string.format('New root: %s', cwd))
-- end)

-- keymap('n', '<leader>tr', function()
--   vim.g.use_git_root = not vim.g.use_git_root
--   local new_root = vim.g.use_git_root and vim.fs.root(0, '.git') or vim.uv.cwd()
--   if new_root then
--     vim.api.nvim_set_current_dir(new_root)
--     vim.notify(string.format('Changed root to: %s', new_root))
--   else
--     vim.notify('Could not find a viable `.git` root, aborting...', vim.log.levels.ERROR)
--   end
-- end)

-- -- Example of above root toggle for Telescope
-- require('telescope.builtin').find_files {
--   cwd = vim.g.use_git_root and vim.fs.dirname(git_root) or nil,
-- }

-- [[ TOGGLE FORMATTING ]]
keymap("n", "<leader>tf", function()
  vim.b.disable_formatting = not vim.b.disable_formatting
  local res = vim.b.disable_formatting and "Disabled" or "Enabled"
  vim.notify(string.format("%s autoformat on save", res))
end, { desc = "Format: Toggle format on save" })
-- }}

-- [[ COPY/PASTE ]] {{
-- [[ KEEP PASTE BUFFER CLEAN/REPEATED PASTE ]]
keymap("x", "<leader>p", [["_dP]])

-- [[ SANER PASTE BEHAVIOR ]]
keymap({ "i", "c" }, "<C-v>", "<C-r>+", { noremap = true, desc = "Paste from system clipboard" })
keymap("n", "cc", '"_cc', opts) -- INFO: "_ is like a pit of hell ("black hole register", discards)

-- [[ RE-SELECT MOST RECENT VISUAL HIGHLIGHTED ]]
keymap("n", "<leader>v", "`[V`]", opts)

-- -- [[ NEAT X CLIPBOARD INTEGRATION ]]
-- keymap("n", "<leader>p", ":read !wl-paste<cr>") -- paste clipboard into buffer
keymap("n", "<leader>cc", ":w !wl-copy<cr><cr>") -- copy entire buffer into clipboard

-- [[ EXPLICITLY YANK TO SYSTEM CLIPBOARD (HIGHLIGHTED AND ENTIRE ROW) ]]
-- keymap({ 'n', 'v' }, '<leader>y', [["+y]])
-- keymap('n', '<leader>Y', [["+Y]])
-- }}

-- [[ GIT STUFF ]] {{
-- nmap('<leader>fc', '/<<<<CR>', '[F]ind [C]onflicts')
-- nmap('<leader>gcu', 'dd/|||<CR>0v/>>><CR>$x', '[G]it [C]onflict Choose [U]pstream')
-- nmap('<leader>gcb', '0v/|||<CR>$x/====<CR>0v/>>><CR>$x', '[G]it [C]onflict Choose [B]ase')
-- nmap('<leader>gcs', '0v/====<CR>$x/>>><CR>dd', '[G]it [C]onflict Choose [S]tashed')

-- [[ GIT HISTORY OF THE VISUAL SELECTION ]]
keymap("v", "gl", ":<c-u>exe ':term git log -L' line(\"'<\").','.line(\"'>\").':'.expand('%')<CR>", opts)

-- }}

-- [[ BUFFERS ]] {{
keymap("n", "<leader>j", ":bnext<enter>", { noremap = false, silent = true })
keymap("n", "<leader>k", ":bprev<enter>", { noremap = false, silent = true })
keymap("n", "<leader>bd", ":bdelete<enter>", { noremap = false, silent = true })
keymap("n", "<leader>;", ":b#<CR>", { silent = true, desc = "Swap to most recently used buffer" }) -- NOTE: <C-6> by default, fuck that.

--  [[ WINDOW/SPLIT NAVIGATION ]]
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Switch focus to left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Switch focus to right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Switch focus to lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Switch focus to upper window" })

-- [[ SELECT ENTIRE BUFFER ]]
keymap("n", "gG", "gg<S-v>G", { desc = "Select all" })

-- [[ TEXT ]] {{
-- [[ CORRECT SPELLING MISTAKES ]]
-- src: https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
-- Used in conjuction w/builtin C-w
-- keymap('i', '<C-b>', '<c-g>u<Esc>[s1z=gi<c-g>u', opts)

-- [[ AUTOCORRECT ]]
local abbreviations = {
  teh = "the",
  jsut = "just",
  recieve = "receive",
  strcut = "struct",
  cosnt = "const",
  sf = "static final",
  -- [">>"] = "→",  // holy mother of god is this annoying for i →= 1
  -- ["<<"] = "←",
  ["^^"] = "↑",
  VV = "↓",
}

for from, into in pairs(abbreviations) do
  vim.cmd(string.format("iabbrev %s %s", from, into))
end
-- }}

-- [[ TESTS ]] {{
keymap("n", "<leader>r", function()
  vim.cmd("write")
  local filename = vim.fn.expand("%:t")
  os.execute('tmux send-keys -t 1 "go run ./' .. filename .. '" C-m')
end)
-- }}
-- vim: ts=2 sts=2 sw=2 et
