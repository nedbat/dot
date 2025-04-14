# Add this line to .zshenv (or create it with this line):
#   source ~/.config/nedbat/.zshenv
#
# Run by all zshells

export XDG_CONFIG_HOME=$HOME/.config
export SHELL_TYPE=zsh

# To stop /etc/zshrc from calling compinit
skip_global_compinit=1

source ~/.config/env.sh
