# Sourced for all interactive shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

# Find the first file that exists in a list of possibilities.
_first_of() {
    for f; do
        if [[ -r $f ]]; then
            echo "$f"
            return 0    # found
        fi
    done
    return 1  # not found
}

# Execute search path. Later entries here win.
for d in \
    /opt/local/bin \
    /opt/homebrew/bin \
    /usr/local/bin \
    $HOME/.local/bin \
    $HOME/bin \
; do
    if [[ -d $d ]]; then
        export PATH=$d:$PATH
    fi
done

export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

alias sep='printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n========================================================================================================================\n"'

# Clip output horizontally to not wrap lines in the terminal
alias ccc='cut -c-$(tput cols)'

# Source the stuff in .config/shellrc

for MODULE in  ~/.config/shellrc/*.sh; do
    source $MODULE
done

# Read a local file if it exists.

if [[ -f ~/.rc_local.sh ]]; then
    source ~/.rc_local.sh
fi
