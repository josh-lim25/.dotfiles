# Ubuntu deps
stow
build-essential
git
fzf
fd-find
eza

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
