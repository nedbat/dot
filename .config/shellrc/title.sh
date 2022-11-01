# Set the title of the terminal window.
title() {
    # generic:
    #   echo -en "\033]2;$@\007"
    # for iterm2:
    #   http://superuser.com/a/344397
    # Getting the window number from a terminal:
    #  _win_num="${ITERM_SESSION_ID%%t*}"
    #  _win_num="${_win_num#w}"
    export WINDOW_TITLE="$@"
    echo -en "\033];$@\007"
    if [[ -n "$WWINDOW_TITLE" ]]; then
        wtitle "$WWINDOW_TITLE"
    fi
}

# iTerm2 has a Window title in addition to the tab title, which title() sets.
wtitle() {
    echo -ne "\033]2;$@\007"
    export WWINDOW_TITLE="$@"
}

# Reset things
# this used to "cd $(pwd -P)" but I don't remember why.
alias a='title "$WINDOW_TITLE"; wtitle "$WINDOW_TITLE"'
