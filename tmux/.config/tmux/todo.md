- From [this comment](https://www.reddit.com/r/unixporn/comments/18yqmgk/tmux_always_feared_tmux_finally_managed_to/)
```
display-popup is your friend. bind everything to it in tmux, scratch terms, fzf, clipboard, term/pane selection

alt+, (common settings shorty in gui apps) opens my dotfiles in fzf

bind -n 'M-,' display-popup -E dotfile-edit

keep your tmux clipboard/copy-pipe-and-cancel/copy-mode-vi buffers separate from your x11 buffer, and have some key to allow for {in,e}gress'ing their content. having two clipboards both active without having to hit a clip history mgr, as well as being able to use the tmux {load,copy,paste,show,set}-buffer to manipulate an area of content that doesnt automatically overwrite your xsel -i --clipboard ; xsel -o --clipboard

specify a server/socket, a session, and target session name when starting tmux

tmux -L default new -A -s furstsesh -t globalsesh

This sets up a server socket named default, a target session called "globalsesh" and the current session named "furstsesh".

tmux -L default new -A -s secondsesh -t globalsesh

If you open a new window/tab/quake and define a diff session name, they will NOT share the same view. They will share the same windows/tabs/panes, but wil operate independently from each other's active view.

I define a socket/server name because of "not all eggs in one basket". (my tmux can segfault occasionaly by having a ton of shit trying to work on same server). I also have my quake/statusbar using its own socket/server.
```
