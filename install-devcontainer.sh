#!/usr/bin/env bash
# Devcontainer bootstrap for josh-lim25/.dotfiles, shell and git config only.
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
log() { printf 'dotfiles: %s\n' "$*"; }

# ~/.zshrc is the whole point; without zsh the config does nothing.
if ! command -v zsh >/dev/null 2>&1; then
    log "installing zsh"
    sudo apt-get update
    sudo apt-get install -y zsh
fi

# CLI tools ~/.zshrc and ~/.fzf_config call directly (fzf, eza, zoxide, bat).
# Debian/Ubuntu ship `bat` as `batcat` and `fd` as `fdfind`.
if ! command -v fzf >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
    log "installing shell tools"
    sudo apt-get update
    sudo apt-get install -y fzf eza zoxide bat fd-find ripgrep curl wget xclip
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
fi

if ! command -v delta >/dev/null 2>&1; then
    log "installing git-delta"
    sudo apt-get update
    sudo apt-get install -y git-delta
fi

# Link a config file into $HOME, replacing an existing file/symlink.
link() {
    local src="$REPO_DIR/$1" dest="$HOME/$2"
    [ -e "$src" ] || { log "skip (missing): $1"; return 0; }
    mkdir -p "$(dirname -- "$dest")"
    ln -sfn "$src" "$dest"
    log "linked $2"
}

link zsh/.zshrc           .zshrc
link zsh/.zprofile        .zprofile
link zsh/.p10k.zsh        .p10k.zsh
link zsh/.fzf_config      .fzf_config
link zsh/.functions.zsh   .functions.zsh
link zsh/.fdignore        .fdignore
link .bashrc              .bashrc
link shell-qol/.gitconfig .gitconfig

# ~/.zshrc sources "$HOME/.dotfiles/scripts/..." and ~/.gitconfig includes
# ".dotfiles/delta/themes.ini" (relative to $HOME). The clone may not be at
# ~/.dotfiles, so point it there.
if [ "$REPO_DIR" != "$HOME/.dotfiles" ]; then
    ln -sfn "$REPO_DIR" "$HOME/.dotfiles"
    log "linked .dotfiles -> $REPO_DIR"
fi

# Make zsh the login shell.
if ! grep -qx /usr/bin/zsh /etc/shells 2>/dev/null; then
    echo /usr/bin/zsh | sudo tee -a /etc/shells >/dev/null
fi
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo chsh -s /usr/bin/zsh "$(id -un)"
fi

log "done -- open a new terminal"
