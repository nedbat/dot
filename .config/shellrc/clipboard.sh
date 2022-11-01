if command -v pbcopy >/dev/null; then
    clipc() { pbcopy "$@"; }
    clipv() { pbpaste "$@"; }
elif command -v xclip >/dev/null; then
    clipc() { xclip -sel clip -i "$@"; }
    clipv() { xclip -sel clip -o "$@"; }
fi
