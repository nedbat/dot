if command -v xdg-open >/dev/null; then
    open() { 
        xdg-open "$@"
    }
fi
