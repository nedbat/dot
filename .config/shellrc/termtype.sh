#
# Set the terminal type properly.
# TERM is tried as a terminal type. If unknown, a trailing dash component will
# be stripped, and repeat.  So "xterm-256color-italic" will fallback to
# "xterm-256color", and then to "xterm" if needed.
#
# To make xterm-256color-italic work:
# $ tic .config/shellrc/xterm-256color-italic.terminfo

while true; do
    if tput longname >/dev/null 2>&1; then
        # This is a known terminal.
        break
    fi
    if [[ $TERM != *-* ]]; then
        # No more qualifiers to strip off.
        break
    fi
    echo "Couldn't use TERM=${TERM}, trying ${TERM%-*}"
    # Remove the last dash-separated component and try again.
    export TERM=${TERM%-*}
done

if [[ -n $PS1 ]]; then
    stty erase ^H
fi
