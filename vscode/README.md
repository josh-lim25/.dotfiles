- Remember to stow both packages:
```sh
cd ~/.dotfiles/vscode
stow -t ~ nvim-vscode settings
```
Stow links into the parent of the stow directory by default; other packages work without `-t` only because they sit directly in `~/.dotfiles`, whose parent is `~`.


- [install](https://code.visualstudio.com/docs/setup/linux)
```sh
# Uninstall
sudo apt purge -y code
sudo apt autoremove -y

# Delete personal settings, extensions, and caches
rm -rf ~/.vscode ~/.config/Code

# Clean up the Microsoft repository configuration and key
sudo rm -f /etc/apt/sources.list.d/vscode.sources
sudo rm -f /usr/share/keyrings/microsoft.gpg

# Refresh your system package list
sudo apt update
```

## Colorscheme
```sh
# run from ~/.dotfiles/vscode
mkdir -p ~/.vscode/extensions/kanagawa-paper-ink
ln -sf "$PWD/kanagawa-paper-ink-color-theme.json" ~/.vscode/extensions/kanagawa-paper-ink/theme.json
printf '%s' '{"name":"kanagawa-paper-ink","publisher":"local","version":"1.0.0","engines":{"vscode":"*"},"contributes":{"themes":[{"label":"Kanagawa Paper Ink (custom)","uiTheme":"vs-dark","path":"./theme.json"}]}}' > ~/.vscode/extensions/kanagawa-paper-ink/package.json
```

```json
// Add to `settings/.config/Code/User/settings.json`
"workbench.colorTheme": "Kanagawa Paper Ink (custom)"
```
