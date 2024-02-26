# Sourced for all shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

# Source the stuff in .config/shellenv

for MODULE in ~/.config/shellenv/*.sh; do
    source $MODULE
done

if [[ $SHELL_TYPE == zsh ]]; then
    for MODULE in ~/.config/shellenv/*.zsh; do
        source $MODULE
    done
fi
