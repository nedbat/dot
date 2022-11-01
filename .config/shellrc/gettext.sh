if [[ -d /usr/local/Cellar/gettext ]]; then
    # Find the latest gettext, and add it to the PATH.
    # \ls is to get unaliased ls.
    export PATH="$PATH:$(\ls -d1 /usr/local/Cellar/gettext/*/bin | tail -1)"
fi
