# Things needed for other rc files.

# Find the first file that exists in a list of possibilities.
_first_of() {
    for f; do
        if [[ -r $f ]]; then
            echo "$f"
            return 0    # found
        fi
    done
    return 1  # not found
}
