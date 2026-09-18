#!/usr/bin/env bash

set -e

FIREFOX_DIR="$HOME/snap/firefox/common/.mozilla/firefox"
BF_GIT_REPO="https://github.com/yokoffing/BetterFox"
PROFILE_DIR=$(find "$FIREFOX_DIR" -maxdepth 1 \( -name '*.default' -o -name '*.default-release' \) -print -quit)

if [ -z "$PROFILE_DIR" ]; then
    echo "Error: Snap Firefox profile directory not found in $FIREFOX_DIR" >&2
    exit 1
fi

BF_REPO_DIR="$PROFILE_DIR/Betterfox"
OVERRIDES="$HOME/.dotfiles/firefox/user-overrides.js"

if [ ! -d "$BF_REPO_DIR" ]; then
    echo "Cloning Betterfox into Snap profile..."
    git clone "$BF_GIT_REPO" "$BF_REPO_DIR"
else
    echo "Betterfox repository already exists. Pulling latest updates..."
    git -C "$BF_REPO_DIR" pull
fi

echo "Generating clean user.js..."
cat "$BF_REPO_DIR/user.js" > "$PROFILE_DIR/user.js"

if [ -f "$OVERRIDES" ]; then
    echo "Appending custom overrides from dotfiles..."
    cat "$OVERRIDES" >> "$PROFILE_DIR/user.js"
else
    echo "Warning: Custom overrides file ($OVERRIDES) not found. Skipping."
fi

echo "Success! Snap Firefox user.js has been safely updated."
