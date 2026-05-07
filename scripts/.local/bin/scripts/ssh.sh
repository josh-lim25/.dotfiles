# NOTE: Stolen from arch wiki
# when on new machine, need to do following:
# 1. `systemctl --user enable ssh-agent` # and start
# 2. `stow . -t ~/.config/systemd/user`

# TODO: https://gist.github.com/grenade/6318301#file-ssh-key-add-sh

# https://wiki.archlinux.org/title/SSH_keys#Forwarding_ssh-agent
# "When forwarding a local ssh-agent to remote (e.g., through command-line argument ssh -A remote
# or through ForwardAgent yes in the configuration file), it is important for the remote machine
# not to overwrite the environment variable SSH_AUTH_SOCK" (Forwarding ssh-agent)
if [[ -z "${SSH_CONNECTION}" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# https://wiki.archlinux.org/title/SSH_keys#ssh-agent
# In order to start the agent automatically and make sure that only one ssh-agent process runs at a time
if [[ -z "${SSH_AUTH_SOCK}" ]] || ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [[ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
