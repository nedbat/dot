# Add this line to .zshenv (or create it with this line):
#   source ~/.config/nedbat/.zshenv
#
# Run by all zshells

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export SHELL_TYPE=zsh

# To stop /etc/zshrc from calling compinit
skip_global_compinit=1

source ~/.config/env.sh
