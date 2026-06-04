# Dependencies, Post Install TODOs, and Notes
---
## GNU Stow
- See `./automated_setup.md`

### TODO
- [ ] [etckeeper](https://etckeeper.branchable.com/README/)

### Packages
- See `./dependencies.md`

### ZSH
- Run `chsh -s /usr/bin/zsh`, assuming `which zsh` returns that (and source it)

### Tmux
- Clone the `tpm` github repo, this should be put in `~/.config/tmux/plugins/tpm`
- Run `tmux source ~/.config/tmux/tmux.conf`
- `<Prefix+I>`

## Install AUR Helper:

- `yay` or `paru` (AUR helper, automates the manual pkgbuild process)
- Clone the associate git repo, `cd` into it, and run `makepkg -si`
- `sudo chown -R  josh:users yay`
- `sudo git clone https://aur.archlinux.org/yay.git`


#### AUR Packages

- Install these with `yay -S <pkg>`:
- `shellcheck-bin`


## Ly

- `/etc/ly/config.ini` contains config
- Run `sudo systemctl enable ly.service`
- `sudoedit /lib/systemd/system/ly.service` to change colors:

## Reflector
`sudoedit /etc/xdg/reflector/reflector.conf`

```
# Reflector configuration file for the systemd service.
#
# Empty lines and lines beginning with "#" are ignored.  All other lines should
# contain valid reflector command-line arguments. The lines are parsed with
# Python's shlex modules so standard shell syntax should work. All arguments are
# collected into a single argument list.
#
# See "reflector --help" for details.

# Recommended Options

# Set the output path where the mirrorlist will be saved (--save).
--save /etc/pacman.d/mirrorlist

# Select the transfer protocol (--protocol).
--protocol https

# Select the country (--country).
# Consult the list of available countries with "reflector --list-countries" and
# select the countries nearest to you or the ones that you trust. For example:
# --country France,Germany
--country "United States"

# Use only the  most recently synchronized mirrors (--latest).
--latest 5

# Sort the mirrors by synchronization time (--sort).
--sort age
```

Afterwards, enable `reflector.service` to run on boot


## Docker
- Enable `docker.socket` (only starts docker service on usage)
- Note that docker.service starts the service on boot, whereas docker.socket starts docker on first usage which can decrease boot times


## SSH
- Ensure you have the requisite programs, `openssh`
- Enable `sshd.service`

### To automate the ssh-agent process
- See: [SO post](https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login)
- See: [wiki page](https://wiki.archlinux.org/title/SSH_keys#Start_ssh-agent_with_systemd_user)
- `systemd` service, put in ~/.config/systemd/user/ssh-agent.service

```sh
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK
Restart=on-failure

[Install]
WantedBy=default.target
```

