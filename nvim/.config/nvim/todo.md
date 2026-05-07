[fix treesitter](https://www.reddit.com/r/neovim/comments/1sdkkaj/how_to_setup_treesitter_now/)
[og post](https://www.reddit.com/r/neovim/comments/1ppa4ag/nvimtreesitter_breaking_changes/)
    - [README](https://github.com/nvim-treesitter/nvim-treesitter)
    - [gh discussion](https://github.com/nvim-treesitter/nvim-treesitter/discussions/7927)


- fix yank highlight color
- fix next search term color
- fix noneckpain line


# One day
- [x] change directory structure
- [x] add new keybinds
- [x] remove which-key, rust*
- [x] migrate from telescope -> fzf-lua
- [x] migrate from nvim-cmp -> blink
- [x] migrate from lualine -> mini.statusline
- [x] fix treesitter capture groups (missing dep)
- [x] fix lsp and fzf keybinds
- [x] fix ephemeral noneckpain scratchpad
- [x] add: debug print
- [ ] [image viewing](https://github.com/3rd/image.nvim)
- [ ] [how to work in remote servers](https://www.reddit.com/r/neovim/comments/1khhmpw/how_to_work_in_remote_server/)
    - type "nvim oil-ssh://your_ssh_server_of_ssh_config_file/relative_path_of_remote_server_home_dir" or "nvim oil-ssh://your_ssh_server_of_ssh_config_file//absolute_path_of_remote_server" in ur terminal.
    - sshfs
    - [post](https://www.reddit.com/r/neovim/comments/1mm0ukh/any_tips_for_remote_development_via_ssh/)
    - [post](https://www.reddit.com/r/vim/comments/u7amd6/can_i_use_vim_or_neovim_through_ssh_like_i_would/)
    - [some ideas](https://www.reddit.com/r/neovim/comments/ykb8td/do_you_use_neovim_when_doing_server_configuration/)
    - `vim.g.clipboard = 'osc52'`
- [ ] [quickfix list](https://www.youtube.com/watch?v=AuXZA-xCv04)


- [ ] configure: trouble


- [java nvim](https://www.reddit.com/r/neovim/comments/1eocacb/is_java_in_neovim_doable/)
    - [ ] [jdtls](https://github.com/brianrbrenner/nvim/blob/master/lua/brian/config/jdtls_setup.lua)
    - [ ] [update vimrc](https://github.com/peppy/dotfiles/blob/f78c755e795d69ddd4941818ab38573cb70a2c51/dot_vimrc)
    - [ ] [make ideavimrc](https://github.com/peppy/dotfiles/blob/master/dot_ideavimrc)



## ideas
- snippet ideas somehwere
- history parse it and get rid of certain keywords like :q or :wq
    - autocommand? or probably bash on a cronjob
tmail - like terminal.shop, learn SFTP
-blog: death, passion and purpose and meaning
- mask cli md runner: what cna i do w/markdown and code blocks?

```sh
for dir in $(find /home/user/scripts -type d); do
    PATH="$PATH:$dir"
done
export PATH
```



```lua
-- Set general floating window options
vim.o.winblend = 10  -- transparency for floating windows
vim.o.pumblend = 10  -- transparency for popups
vim.api.nvim_set_hl(0, 'NormalFloat', {bg = 'None'})  -- remove background for floating windows

-- Customize border style for floating windows
vim.o.winborder = 'rounded'  -- Set 'rounded', 'single', 'double', etc.

-- Alternatively, for specific plugin floating windows:
vim.cmd([[autocmd FileType * setlocal winblend=15 pumblend=15]])
```
