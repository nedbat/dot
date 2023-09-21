if command -v xdg-open >/dev/null; then
    open() { 
        xdg-open "$@"
    }
fi

if [[ -d /Applications/Firefox.app ]]; then
    ffopen() {
        open -a /Applications/Firefox.app "$@"
    }
fi
