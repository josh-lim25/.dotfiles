#!/usr/bin/env sh
# NOTE: Optimized Zsh Vi-Mode Config with Text Objects & Safe Clipboard Integration

# Core Vi Mode Options & Fixes
bindkey -v
export KEYTIMEOUT=1  # 10ms ESC delay (snappy mode switching)

# Unbind conflicting keys (e.g., for fzf-git.sh)
bindkey -M viins -r '^G'
bindkey -M vicmd -r '^G'

# Enable Vim Text Objects (di", ci(, va{, etc.)
# Zsh needs these explicitly autoloaded and bound to visual/operator-pending modes
autoload -U select-quoted select-bracketed
zle -N select-quoted
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# ==========================================
# qol
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -M viins "^a" beginning-of-line
bindkey -M vicmd "^a" beginning-of-line
bindkey -M viins "^e" end-of-line
bindkey -M vicmd "^e" end-of-line
bindkey -M viins "^d" delete-char-or-list
bindkey -M vicmd "^d" delete-char

# Direct Navigation Shifts
bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M visual 'H' vi-beginning-of-line
bindkey -M visual 'L' vi-end-of-line

# Bulletproof Clipboard Helpers
# These functions guard against missing Wayland servers and hide stderr completely.
function _zsh_clip_copy {
  if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy &>/dev/null; then
    echo -n "$CUTBUFFER" | wl-copy 2>/dev/null
  fi
}

function _zsh_clip_paste {
  if [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-paste &>/dev/null; then
    CUTBUFFER=$(wl-paste -n 2>/dev/null)
  fi
}

# Clean, DRY ZLE Clipboard Widgets
function vi-yank-clip { zle vi-yank; _zsh_clip_copy; }
function vi-yank-eol-clip { zle vi-yank-eol; _zsh_clip_copy; }
function vi-yank-whole-line-clip { zle vi-yank-whole-line; _zsh_clip_copy; }
function vi-delete-clip { zle vi-delete; _zsh_clip_copy; }
function vi-delete-char-clip { zle vi-delete-char; _zsh_clip_copy; }
function vi-change-clip { zle vi-change; _zsh_clip_copy; }
function vi-change-eol-clip { zle vi-change-eol; _zsh_clip_copy; }
function vi-change-whole-line-clip { zle vi-change-whole-line; _zsh_clip_copy; }
function vi-kill-line-clip { zle kill-whole-line; _zsh_clip_copy; }

function vi-put-after-clip { _zsh_clip_paste; zle vi-put-after; }
function vi-put-before-clip { _zsh_clip_paste; zle vi-put-before; }

# Register all functions to ZLE
zle -N vi-yank-clip
zle -N vi-yank-eol-clip
zle -N vi-yank-whole-line-clip
zle -N vi-delete-clip
zle -N vi-delete-char-clip
zle -N vi-change-clip
zle -N vi-change-eol-clip
zle -N vi-change-whole-line-clip
zle -N vi-kill-line-clip
zle -N vi-put-after-clip
zle -N vi-put-before-clip

# Keymaps Configuration
# Normal mode mappings
bindkey -M vicmd 'y' vi-yank-clip
bindkey -M vicmd 'yy' vi-yank-whole-line-clip
bindkey -M vicmd 'Y' vi-yank-eol-clip
bindkey -M vicmd 'd' vi-delete-clip
bindkey -M vicmd 'dd' vi-kill-line-clip
bindkey -M vicmd 'x' vi-delete-char-clip
bindkey -M vicmd 'c' vi-change-clip
bindkey -M vicmd 'cc' vi-change-whole-line-clip
bindkey -M vicmd 'C' vi-change-eol-clip
bindkey -M vicmd 'p' vi-put-after-clip
bindkey -M vicmd 'P' vi-put-before-clip

# Visual mode mappings
bindkey -M visual 'y' vi-yank-clip
bindkey -M visual 'd' vi-delete-clip
bindkey -M visual 'x' vi-delete-clip
bindkey -M visual 'c' vi-change-clip

# Extras
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^o' edit-command-line

bindkey '^y' forward-word        # incremental accept
bindkey '^f' autosuggest-accept  # full accept
bindkey '^w' backward-kill-word
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^?' backward-delete-char

