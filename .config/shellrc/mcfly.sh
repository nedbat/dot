# https://github.com/cantino/mcfly
if [[ -n $PS1 ]]; then
    if command -v mcfly >/dev/null; then
        export MCFLY_RESULTS=30
        export MCFLY_HISTORY_LIMIT=50000
        eval "$(mcfly init $SHELL_TYPE)"
    fi
fi
