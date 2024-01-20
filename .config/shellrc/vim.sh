# e means gvim, vim or vi, depending on what's installed.
export EDITOR=vim
possible_vims=(
    /opt/homebrew/bin/mvim
    /usr/local/bin/mvim
    /Applications/MacVim.app/Contents/MacOS/Vim
)
the_vim=$(_first_of "${possible_vims[@]}")
if [[ -x $the_vim ]]; then
    alias e="$the_vim --servername VIM --remote-silent"
    alias vim="$the_vim -v"
    export EDITOR="$the_vim -v"
elif type -P gvim &>/dev/null; then
    alias e='gvim --servername GVIM --remote-silent'
elif type -P vim &>/dev/null; then
    alias e='vim'
else
    alias e='vi'
    export EDITOR=vi
fi
