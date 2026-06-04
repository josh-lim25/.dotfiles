- NOTE: wouldve been nice to have something like a sxkd or whatever that does keymaps irrespective of the linux distro

# Deps
- `stow`
- `build-essential`
- `git`
- `fzf`
- `fd-find`
- `eza`
- `curl`
- `eza`
- `tree`
- `grc`
- `ripgrep`
- `gnome-shell-extension-manager`

### Snaps
- `nvim`
- `mattermost-desktop`

## Installation mishaps
### SSH
### NVIM stuff

```bash
# uninstall ppa
sudo add-apt-repository --remove ppa:neovim-ppa/stable
# or whichever PPA you added (check with:)
ls /etc/apt/sources.list.d/ | grep -i neovim

sudo apt remove --purge -y neovim
sudo apt autoremove -y

```
- `sudo apt install --no-install-recommends wl-clipboard`


#### Building from source
- [Directions](https://neovim.io/doc/install/#install-from-source)
1. Clear build [prereqs](https://neovim.io/doc/build/#build-prerequisites)
    ```sh
    # Ubuntu
    sudo apt-get install ninja-build gettext cmake curl build-essential git
    ```
2.
https://www.reddit.com/r/neovim/comments/1b117m7/why_are_there_a_million_different_ways_to_install/

- Setup the [caps lock remapping](https://github.com/rvaiya/keyd/tree/f564288ac2b19d2305a5b39023c474805ff8fce5#quickstart)
- Annoying asking for sudo pw everywhere
```sh
sudo visudo
# add this exact line at the bottom:
josh ALL=(ALL) NOPASSWD: ALL
```

- fdfind and batcat bullshit
```sh
ln -sf $(which fdfind) ~/.local/bin/fd
ln -sf $(which batcat) ~/.local/bin/bat
```

- Exporting `XDG_CURRENT_DESKTOP=sway` in `~/.zprofile`

- Setting up firefox

- "snap-confine has elevated permissions and is not confined but should be":
```sh
sudo systemctl enable --now apparmor.service

# Reload the specific Snap profiles into the AppArmor parser:
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*

# If not synced properly
sudo rm -rf /var/cache/apparmor/*

sudo systemctl restart snapd.service
```

- ssh
```sh
sudo apt install openssh-server
sudo systemctl enable --now ssh
```

- gnome tweaks to treat both win and alt as alt (Super remapping)

- start using workspaces
```sh
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"

# to make apps only open on certain workspaces
sudo apt update && sudo apt install gnome-shell-extension-auto-move-windows

for i in {1..9}; do gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"; done

for i in {1..9}; do gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"; done

# WARN: HARD REVERT
for i in {1..9}; do gsettings reset org.gnome.desktop.wm.keybindings switch-to-workspace-$i; gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-$i; done
```

- stdsym go docs
- ufw
```sh
sudo ufw status
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw reload
```

- [docker installation](https://docs.docker.com/engine/install/ubuntu/)
```sh
sudo groupadd docker
sudo usermod -aG docker $USER
# Apply changes immediately
newgrp docker
```

- [gh cli](https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian)
- focus window with super H and L
```sh
gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "[]"
```
