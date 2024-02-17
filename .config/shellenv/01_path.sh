# Set the search path. Later entries here win.
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
