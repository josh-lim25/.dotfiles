-- Minimal nvim config for the pi container (NVIM_MINIMAL=1).
--
-- Loads options, keymaps, wip.review, and the colorscheme. No plugin manager
-- so startup stays fast. The colorscheme is read from the lazy store that is
-- already mounted from the host.
require("settings.options")
require("settings.keymaps")
require("wip.review")

-- With no plugins there is no remote-plugin manifest to load; stop rplugin.vim
-- from needing a writable data dir just to write one.
vim.g.loaded_remote_plugins = 1

-- The colorscheme is the one plugin we keep. Add to rtp and run its lazy
-- spec's config directly since lazy.nvim itself is not loaded. Gross but it
-- works :D
local theme = vim.fn.stdpath("data") .. "/lazy/kanagawa-paper.nvim"
if vim.fn.isdirectory(theme) == 1 then
  vim.opt.runtimepath:prepend(theme)
  local ok, spec = pcall(require, "plugins.core.colorschemes.colorscheme")
  if ok and type(spec) == "table" and type(spec.config) == "function" then
    pcall(spec.config, nil, spec.opts)
  end
end
