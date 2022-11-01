# Pasting to gist
if command -v gist >/dev/null; then
    # gistv [FILENAME]: paste the clipboard to Gist
    gistv() {
        gist -Ppc -f ${1:-something.txt}
    }
fi
