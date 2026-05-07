#!/usr/bin/env sh
# NOTE: bindkey alone displays or modifies key bindings in the current keymap.
# Using bindkey -M lets you specify which keymap you’re working with.

bindkey -v
export KEYTIMEOUT=1  # 10ms ESC delay (snappy mode switching)
# For ~/.local/bin/scripts/fzf-git.sh
bindkey -M viins -r '^G'
bindkey -M vicmd -r '^G'

# Restore some keymaps removed by vi keybind mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -M viins "^a" beginning-of-line
bindkey -M vicmd "^a" beginning-of-line
bindkey -M viins "^e" end-of-line
bindkey -M vicmd "^e" end-of-line
bindkey -M viins "^d" delete-char-or-list
bindkey -M vicmd "^d" delete-char

function vi-yank-clip {
  zle vi-yank
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-yank-clip

function vi-yank-eol-clip {
  zle vi-yank-eol
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-yank-eol-clip

function vi-yank-whole-line-clip {
  zle vi-yank-whole-line
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-yank-whole-line-clip

function vi-delete-clip {
  zle vi-delete
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-delete-clip

function vi-delete-char-clip {
  zle vi-delete-char
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-delete-char-clip

function vi-change-clip {
  zle vi-change
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-change-clip

function vi-change-eol-clip {
  zle vi-change-eol
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-change-eol-clip

function vi-change-whole-line-clip {
  zle vi-change-whole-line
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-change-whole-line-clip

function vi-put-after-clip {
  CUTBUFFER=$(wl-paste -n 2>/dev/null)
  zle vi-put-after
}
zle -N vi-put-after-clip

function vi-put-before-clip {
  CUTBUFFER=$(wl-paste -n 2>/dev/null)
  zle vi-put-before
}
zle -N vi-put-before-clip

# Normal mode
bindkey -M vicmd 'y' vi-yank-clip
bindkey -M vicmd 'yy' vi-yank-whole-line-clip
bindkey -M vicmd 'Y' vi-yank-eol-clip
bindkey -M vicmd 'd' vi-delete-clip
bindkey -M vicmd 'dd' vi-kill-line  # handled below
bindkey -M vicmd 'x' vi-delete-char-clip
bindkey -M vicmd 'c' vi-change-clip
bindkey -M vicmd 'cc' vi-change-whole-line-clip
bindkey -M vicmd 'C' vi-change-eol-clip
bindkey -M vicmd 'p' vi-put-after-clip
bindkey -M vicmd 'P' vi-put-before-clip

# Visual mode
bindkey -M visual 'y' vi-yank-clip
bindkey -M visual 'd' vi-delete-clip
bindkey -M visual 'x' vi-delete-clip
bindkey -M visual 'c' vi-change-clip

# dd needs special handling (kill whole line + clipboard)
function vi-kill-line-clip {
  zle kill-whole-line
  echo -n "$CUTBUFFER" | wl-copy
}
zle -N vi-kill-line-clip
bindkey -M vicmd 'dd' vi-kill-line-clip
# }}


# Edit hairy command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^o' edit-command-line

bindkey '^y' forward-word        # incremental accept
bindkey '^f' autosuggest-accept  # full accept
bindkey '^w' backward-kill-word
# Bind backspace to delete a character in vi insert mode
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^?' backward-delete-char
# bindkey '^r' history-incremental-search-backward


# shift-tab to move backwards in the completion list
# bindkey '^[[Z' reverse-menu-complete
