# From Aron, of course.
if command -v osascript >/dev/null; then
    _osaquote() {
        set -- "${@//\\/\\\\}"
        set -- "${@//\"/\\\"}"
        printf '"%s" ' "$@"
    }

    toast() {
        osascript -e "display notification $(_osaquote "$*") with title \"Hey there\""
    }
fi
