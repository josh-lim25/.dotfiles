# [[ POWERLEVEL10K INSTANT PROMPT ]] {{
# NOTE: should stay close to the top of ~/.zshrc.
# NOTE: initialization code that may REQUIRE CONSOLE INPUT (password prompts, [y/n]
# confirmations, etc.) MUST GO ABOVE this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# if [[ -f "/opt/homebrew/bin/brew" ]] then
#   # If you're using macOS, you'll want this enabled
#   eval "$(/opt/homebrew/bin/brew shellenv)"
# fi
# Hacky fix I was using to get rid of error message
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# }}

# Directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Check for Zinit
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# [[ EXPORTS ]] {{
# NOTE: you want to define that directory to the path variable, not the actual binary:
# EG: `PATH=$MYDIR:$PATH`, where MYDIR is def as the dir containing your binary
# NOTE: ORDER MATTERS. For `LHS:RHS,` LHS is the prepended head, RHS is the appended tail
# NOTE: symlinked to ~/.dotfiles/scripts
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/bin/scripts

# [[ NVIM ]]
export EDITOR="$(which nvim)"
export VISUAL="$(which nvim)"
export FCEDIT="$(which nvim)"
export MANPAGER="$(which nvim) +Man!"
# export NVIM_APPNAME='nvim.bak'
# export NVIM_APPNAME='nvim-test'
export NVIM_APPNAME='nvim'
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH" # NOTE: change if using diff NVIM_APPNAME


# RUSTUP TAB COMPLETIONS
fpath+=~/.zfunc

# # SCRIPT ORGANIZATION
# # https://stackoverflow.com/questions/24583863/how-do-i-organize-my-zsh-code-multiple-methods-in-single-file-vs-multiple-files?utm_source=chatgpt.com
# fpath=(~/.zsh_functions $fpath)
# autoload -Uz myfunc1 myfunc2

# BAT COLOR
export BAT_THEME="ansi"

# TODO: diff bw this and what's in ./.zshenv?
# export PATH="$HOME/.cargo/bin:$PATH"

# TODO: python path edition
# export PYTHONPATH="`pwd`:$PYTHONPATH"
# }}

# [[ ADDITIONAL ZINIT/PROMPT CONFIGURATION ]] {{
zinit ice depth=1; zinit light romkatv/powerlevel10k # Add Powerlevel10k
# NOTE: to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# [[ ZSH PLUGINS ]]
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light kutsan/zsh-system-clipboard

# [[ SNIPPETS ]]
# Don't use, but could be worth looking at
# `rm -rf .local/share/zinit/snippets`
zinit snippet OMZP::archlinux
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit # Load completions
zinit cdreplay -q # Replay cached completions (recommended)
# }}

# [[ HISTORY ]] {{
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# }}

# [[ STYLING COMPLETIONS ]] {{
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# }}

# [[ SHELL INTEGRATIONS ]] {{
eval "$(fzf --zsh)"
# eval "$(zoxide init --cmd cd zsh)"
# }}

# [[ CUSTOM SCRIPTS, FUNCTIONS, AND CONFIGS ]] {{
# Keybindings
source ~/.dotfiles/scripts/.local/bin/scripts/set-vi-mode.sh
# SSH
source ~/.dotfiles/scripts/.local/bin/scripts/ssh.sh
# Fish-like abbrevations/expansions
source ~/.dotfiles/scripts/.local/bin/scripts/abbrev-alias.sh
# See ~/.config/systemd/user/ssh-agent.service
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# [[ FZF CONFIGURATIONS ]]
# src: https://github.com/junegunn/fzf?tab=readme-ov-file#display-modes
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# https://github.com/junegunn/fzf?tab=readme-ov-file#tips
source ~/.fzf_config

# [[ FUNCTIONS ]]
source ~/.functions.zsh
# }}

# [[ ABBREVIATIONS ]] {{
# [[ ESSENTIAL ]]
abbrev-alias v='nvim'
abbrev-alias z='zed'
abbrev-alias getmeout="shutdown -h now"
abbrev-alias za="zathura"

# [[ QUICK NAVIGATION ]]
abbrev-alias cdracket="cd ~/Documents/cis-352/autograder-assignments/"
abbrev-alias cdsystems="cd ~/Documents/cis-384/"
abbrev-alias cdtest="cd ~/spaghetti/test/"
abbrev-alias cdgit="cd ~/Documents/git_testing/"
abbrev-alias cdrs="cd ~/spaghetti/langs/rust/testing_grounds/"

# [[ DOCKER ]]
abbrev-alias dc="docker compose"
abbrev-alias dcbuild="docker compose build"
abbrev-alias dcup="docker compose up"
# See https://docs.docker.com/reference/cli/docker/compose/up/ for more
abbrev-alias dcups="docker compose up --remove-orphans --abort-on-container-failure"
abbrev-alias dockps='docker ps --format "{{.ID}} {{.Names}}"'
docksh() { docker exec -it "$1" /bin/bash; }
# docker exec -it <id> /bin/bash
alias ctop='TERM="${TERM/#tmux/screen}" ctop'

# [[ MISE ]]
# https://mise.jdx.dev/getting-started.html#activate-mise
eval "$(~/.local/bin/mise activate zsh)"

# [[ JAVA ]]
# export JAVA_HOME=/path/to/new/jdk
# export PATH=$JAVA_HOME/bin:$PATH
export MAVEN_COLOR=true

# [[ RUST ]]
abbrev-alias clipme='
cargo clippy -- \
-W clippy::pedantic \
-W clippy::nursery \
-W clippy::unwrap_used \
'

# [[ GO ]] {{
# check for new available package updates
abbrev-alias gocheck="go list -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}}: {{.Version}} -> {{.Update.Version}}{{end}}' -m all"

# NOTE: https://github.com/lotusirous/gostdsym#installation
# [G]o [O]pen [D]ocs
alias god='stdsym | fzf --preview "go doc {} | bat -l go --color=always --style=plain" \
             --preview-window "right,60%,border-left" \
             --bind "enter:execute(go doc {} | bat -l go --style=plain --paging=always)"'
# [G]o [O]pen [D]ocs e[X]ecute in browser
alias godx='stdsym -web | fzf --prompt "Symbols> " --preview "go doc \$(echo {} | sed s/#/./g)" --bind "enter:become( echo "https://pkg.go.dev/{}" |xargs xdg-open)"'
# }}

# [[ TMUX ]]
abbrev-alias t="tmux"
abbrev-alias tnew="tmux new -s"
# }}

# [[ ALIASES ]] {{
# [[ GLOBAL ]]
# alias -g tg='|& tee out.log | grep '
alias -g tg='|& tee out.log | grep '

# [[ SHELL ]]
alias s='source ~/.zshrc'
alias dot='cd ~/.dotfiles'
alias vz='nvim ~/.zshrc'
alias c='clear'
alias ls='ls --color=always -F'
alias l="eza --no-filesize --color=always --no-user --classify"
alias ll="eza --no-filesize --git --long --color=always --no-user --classify"
alias lla="eza -a --no-filesize --git --long --color=always --no-user --classify"
alias lll="eza --long --git --color=always --no-user --classify --tree --level=2"
alias ..="cd .. && ls"
alias ...="cd ../.. && ls"
alias ....="cd ../../.. && ls"
alias .....="cd ../../../.. && ls"
# alias cat='bat'   # needed to escape too often
alias bat="bat --color=always --style=numbers,changes,header,grid --italic-text=always"
alias loc="tokei"
alias clean="kondo"
alias rm='rm -I'    # safety
alias mv='mv -iv'   # safety
alias cp='cp -iv'   # safety
# alias grep='rg'   # mental block :(
alias grep='grep --color=auto'
alias mdkir='mkdir' # i have a disability T_T
# alias vim='nvim'
alias ip='ip --color=auto'
alias path='echo $PATH | tr ":" "\n"'
alias pkg="pacman -Qq | fzf \
  --preview 'pacman -Qil {} | bat --style=full --color=always --language=yaml' \
  --preview-window=right:60%:wrap \
  --header='[PKG INFO] Press ENTER to view full details, ? for help' \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --height=80% \
  --bind 'enter:execute(pacman -Qil {} | bat --style=full --color=always --language=yaml | less -R)' \
  --bind 'ctrl-d:preview-page-down' \
  --bind 'ctrl-u:preview-page-up' \
  --bind '?:toggle-preview-wrap'"


# [[ "QOL" ]]
# `ddcutil --display 1 getvcp 10` to see what brightness is at. 10 is "brightness"
alias mondown='ddcutil --display 1 setvcp 10 50'
alias monup='ddcutil --display 1 setvcp 10 100'
alias dim='wlsunset -s $(date +%H:%M) -t 4000 &'
alias vdiff='nvim -d'
alias py='python3'
# alias tree="tree -C -L 3 -a -I '.git' --charset X " # -C for color
alias minitree="tree -aCL 3 --prune"
alias dirtree="tree -L 3 -a -d -I '.git' --charset X "
alias todo='nvim ~/misc/TODO.md'
alias piano='nvim ~/misc/piano.md'
alias hk='nvim ~/misc/hotkeys.md'
alias qq='nvim ~/misc/blooms.md'
# alias proompt='nvim ~/spaghetti/refs/prompts/'
alias sc='shellcheck'
alias btconnect='bluetoothctl connect BC:87:FA:BB:97:66'
alias souniq='sort | uniq -c'
alias text='shuf -n25 /usr/share/dict/american-english -o test.txt'
# https://www.reddit.com/r/golang/comments/uzrbw3/best_practice_do_you_use_the_go_compiler_from/
# TODO: hardcoded binary. See script in ~/.local/bin/scripts/goupdate
alias goupdate='sudo rm -rf /usr/local/go && curl -L https://go.dev/dl/go1.18.2.linux-amd64.tar.gz | sudo tar zx -C /usr/local/ go'

# [[ GRC (COLORIZED OUTPUT) ]]
alias go='grc go'
alias ifconfig='grc ifconfig'
alias diff='grc diff'
# }}

# [[ TESTING THROWAWAY IDEAS ]] {{
alias vv='cd /tmp && (nvim random.md)'  # e.g., changelog for big commits
# [[ GIT ]]
alias gitplay='cd ~/spaghetti/git_playground/'
# [[ GO ]]
alias vgo='cd /tmp && (nvim main.go)'
# [[ JAVA ]]
# TODO: migrate to ~/.functions.zsh?
# TODO: https://github.com/jbangdev/jbang
alias vjava='cd /tmp && (nvim Solution.java)'
jj() {
    local filename="$1"
    local stripped="${filename%.*}"
    javac "$filename" && java "$stripped"
}
# }}
alias u="v ~/.dotfiles/doc/ubuntu.md"
