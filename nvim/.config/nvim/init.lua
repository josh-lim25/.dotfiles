-- INFO: had a timeoutlen issue, `:verbose nmap <leader>` helped debug
-- vim.g is the global namespace, meaning any k, v you put in this big ass table will be accessible anywhere in the config.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true  -- if a Nerd Font is installed and selected in the terminal

require("settings.options")
require("settings.keymaps")
require("settings.diagnostics")
require("plugins.bootstrap")
require("wip.review")

-- [[ SNIPPETS ]]
require('luasnip.loaders.from_lua').lazy_load { paths = { vim.fn.stdpath 'config' .. '/lua/snippets' } }
