# Sourced for all shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

# Source the stuff in .config/shellenv

for MODULE in $XDG_CONFIG_HOME/shellenv/*.sh; do
    source $MODULE
done

if [[ $SHELL_TYPE == zsh ]]; then
    for MODULE in $XDG_CONFIG_HOME/shellenv/*.zsh; do
        source $MODULE
    done
fi
