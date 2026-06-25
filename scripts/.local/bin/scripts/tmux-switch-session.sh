#!/bin/sh
# hop to remote tmux; return home when it detaches
host=$1; sess=${2:-server}

ssh -t "$host" "tmux new -A -s $sess"
exec tmux attach
