# Add this line to .zlogin (or create it with this line):
#   source ~/.config/nedbat/.zlogin
#
# Read the iTerm2 window number, and run something specific to it.
#
# Used to be a setting in iterm2 (Profile - General - Send text at start):
#   cd; if [ "\(tab.id)" -lt "3" ]; then source ~/go/\(tab.window.number); fi

if [[ -n $ITERM_SESSION_ID ]]; then
    IFS=: read -r panename _ <<< "$ITERM_SESSION_ID"
    if [[ -f $HOME/go/iterm_$panename.sh ]]; then
        source $HOME/go/iterm_$panename.sh
    fi
fi
