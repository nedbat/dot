# Get IP info from IP address on command line or clipboard.
ipinfo() {
    local ip="$@"
    if [[ -z "$ip" ]]; then
        local ip="$(clipv)"
    fi
    curl ipinfo.io/$(echo "$ip" | tr -C '[0-9a-f.:\n]' .)
    echo
}
