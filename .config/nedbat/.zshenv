# Add this line to .zshenv (or create it with this line):
#   source ~/.config/nedbat/.zshenv
#
# Run by all zshells

if [[ -d $HOME/dotroot ]]; then
    export XDG_CONFIG_HOME=$HOME/dotroot/.config
else
    export XDG_CONFIG_HOME=$HOME/.config
fi

export SHELL_TYPE=zsh
source ~/.config/env.sh
