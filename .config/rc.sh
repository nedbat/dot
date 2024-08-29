# Sourced for all interactive shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

# Source the stuff in .config/shellrc

for MODULE in $XDG_CONFIG_HOME/shellrc/*.sh; do
    source $MODULE
done

# Read a local file if it exists.

if [[ -f ~/.rc_local.sh ]]; then
    source ~/.rc_local.sh
fi
