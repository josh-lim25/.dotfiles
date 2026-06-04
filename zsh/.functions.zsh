# [[ HELPER FUNCTIONS ]] {{
# # https://stackoverflow.com/questions/1314334/easy-way-to-create-a-file-nested-in-unavailable-directories/1314345#1314345
# mktouch {
#   mkdir -p "$(dirname $1)"
#   touch "$1"
# }
# # https://superuser.com/questions/1412808/add-function-to-zsh
# docker-clean() {
#   docker stop "$(docker ps -a -q)"
#   docker rm "$(docker ps -a -q)"
#   docker rmi "$(docker images -q)"
#   docker volume prune
# }
# }}

# [[ REFS ]] {{
# [[ SIMPLER SOLNS ]]
# bindkey -s ^v 'nvim ~/spaghetti/refs/**\t'
# bindkey -s '^v' 'nvim $(find ~/spaghetti/refs/ -type f | fzf --with-nth=-1 --delimiter=/)\n'

# [[ ONLY BASENAME ]]
# fzf-nvim-widget() {
#   local file
#   file=$(find ~/spaghetti/refs/ -type f | fzf --with-nth=-1 --delimiter=/) || return
#   [[ -n $file ]] && BUFFER="nvim $file" && zle accept-line
# }
# zle -N fzf-nvim-widget
# bindkey '^v' fzf-nvim-widget

# [[ INCLUDES DIRPATH ]]
fzf_references() {
  local file=$(fd --type f --type l --base-directory ~/spaghetti/refs | fzf)
  if [[ -n "$file" ]]; then
    BUFFER="nvim ~/spaghetti/refs/$file"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf_references
bindkey '^v' fzf_references
# }}

# [[ BASICS ]] {{
# TODO: ls on entering some dir. breaks for `..` and weird output
# chpwd() {
#     l
# }
# [[ FIND A FILE AND OPEN IT WITH NVIM ]]
# note that this requires that nvim, fzf, and bat are installed
# old soln: alias f='fzf --print0 | xargs -0 --no-run-if-empty -- nvim'
# TODO: figure out if you want ~/.local/bin/scripts/ff
f() {
  command -v fzf >/dev/null 2>&1 || { echo "Install fzf first!"; return 1; }
  command -v bat >/dev/null 2>&1 || { echo "Install bat first!"; return 1; }

  # The parenthesis () ensure the directory change doesn't leak out
  (
    cd "$HOME" || return 1
    local file=$(fzf --preview "bat --style=numbers --color=always {}")
    [[ -n $file ]] && nvim "$file"
  )
}

# [[ CREATE DIR AND CD INTO IT ]]
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# [[ EXTRACT DIFF ARCHIVE FORMATS ]]
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *.rar)     unrar x "$1" ;;
            *)         echo "'$1' is of a filetype that can't be extracted w/extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# }}

# [[ GIT ]] {{
# [[ CD TO GIT ROOT ]]
cdg() {
    local root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$root" ]]; then
        cd "$root"
    else
        echo "Not in a git repository"
    fi
}

# https://github.com/MSmaili/dotfiles/blob/370bac98a72d1a4ff8d2cfbea789ef4472f348a7/.config/zsh/functions.zsh
# [[ VIEW THE DIFF OF A FILE ]]
gdiff() {
    local args="$*"
    local preview_cmd
    if command -v delta >/dev/null 2>&1; then
        preview_cmd="git diff $args --color=always -- {-1} | delta --side-by-side --width \${FZF_PREVIEW_COLUMNS:-\$COLUMNS}"
    else
        preview_cmd="git diff $args --color=always -- {-1}"
    fi
    git diff "$@" --name-only | fzf -m --ansi --preview "$preview_cmd" \
        --layout=reverse --height=100% --preview-window=down:90%
}

# }}
