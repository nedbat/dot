# read for all interactive shells
#

# If not running interactively, don't do anything
[[ -z $PS1 ]] && return

[[ -n $PS1 ]] && echo '(.bashrc)'

if [ "$hostname" = "" ]; then
    source="BASHRC"
    . ~/.bash_profile
fi

# Definitions
#
# Generic file permissions
umask 22

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If you bork a ! in bash, this lets you edit the line.
shopt -s histreedit

#
# Set PATH & MANPATH
#
if [ -r ~/.path ] ; then
    . ~/.path
fi

#
# Add OS specific PATH & MANPATH info
#
if [ -r ~/.path.$OSTYPE ] ; then
    . ~/.path.$OSTYPE
fi

#
# Add workstation specific PATH & MANPATH info
#
if [ -r ~/.path.$hostname ] ; then
    . ~/.path.$hostname
fi

#
# Add a "local" path.
#
if [ -r ~/.path.local ] ; then
    . ~/.path.local
fi

stty erase ^H

export EDITOR=vim
export PYTHONSTARTUP=~/.startup.py

# Only exit the shell if 10 ^D's are typed.
export IGNOREEOF=10

# Set history settings
# Don't record the same command twice in a row
export HISTCONTROL=ignoredups
# Save 10000 commands in the history file.
export HISTSIZE=10000
# Don't save 1- or 2-letter commands, or space-started commands, or duplicates.
export HISTIGNORE='?:??: *:&'
# Append to the history file, don't overwrite it.
shopt -s histappend
# After every command, flush the writable history to the file.
export PROMPT_COMMAND='history -a'

#
# Basic Unix command aliases
#
alias ls='ls -F'
alias la='ls -aF'
alias df='df -k'

alias l='ls -lF'
alias m='more'

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias xp='pushd >/dev/null'
alias xl='pushd +1 >/dev/null'
alias xq='popd >/dev/null'
alias xs='dirs -p'

alias sep='printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n========================================================================================================================\n"'

if command -v xclip >/dev/null; then
    alias clipc='xclip -sel clip -i'
    alias clipv='xclip -sel clip -o'
fi

if command -v pbcopy >/dev/null; then
    alias clipc='pbcopy'
    alias clipv='pbpaste'
fi

if command -v xdg-open >/dev/null; then
    alias open='xdg-open'
fi

# Git stuff

alias g='git'
alias h='hg'

export GIT_PS1_SHOWSTASHSTATE='y'
export GIT_PS1_SHOWDIRTYSTATE='y'

if [ -r ~/.git-completion.sh ] ; then
    . ~/.git-completion.sh
    __git_complete g __git_main
    __git_complete gi __git_main
fi
if [ -r ~/.git-prompt.sh ] ; then
    . ~/.git-prompt.sh
else
    function __git_ps1 { printf ""; }       # Dummy for when we don't have .git-prompt.sh
fi

# Copy the SHA of head, or some other rev.
copysha() { git rev-parse ${@:-HEAD} | tee /dev/tty | tr -d '\n' | clipc; }

# Fetch and prune every git repo in this tree.
fetchtree () { find . -name .git -type d | while read d; do d=$(dirname $d); echo "---- $d ----"; git -C $d fetch --all --prune; done; }

# e means gvim, vim or vi, depending on what's installed.
if [ -x /Applications/MacVim.app/Contents/MacOS/vim ] ; then
    alias e='/Applications/MacVim.app/Contents/MacOS/vim --servername VIM --remote-silent "$@"'
    # one vim per Mac space: http://chrismetcalf.net/2011/02/02/one-vim-server-to-rule-them-all/
elif type -P gvim &>/dev/null; then
    alias e='gvim --servername GVIM --remote-silent "$@"'
elif type -P vim &>/dev/null; then
    alias e='vim "$@"'
else
    alias e='vi "$@"'
fi
# PS: how to have a separate gvim on each desktop:
# http://www.openhex.org/notes/2011/1/27/one-vim-server-per-desktops

# Set the title of the terminal window.
# konsole might need: echo -e "\e]30;foobar\a"
function title {
    # generic:
    #   echo -en "\033]2;$@\007"
    # for iterm2:
    echo -en "\033];$@\007"
}


# Find the first file that exists in a list of possibilities.
first_of() {
    for f; do
        if [[ -e $f ]]; then
            echo "$f"
            return 0    # found
        fi
    done
    return 1  # not found
}

# pythonz
if [ -d /usr/local/pythonz ] ; then
    export PYTHONZ_ROOT=/usr/local/pythonz
    source $PYTHONZ_ROOT/etc/bashrc
fi

# Virtualenvwrapper support
if $(python -c "import virtualenv" &> /dev/null) ; then
    virtualenvwrappers=(
        /usr/local/bin/virtualenvwrapper.sh
        /etc/bash_completion.d/virtualenvwrapper
        )
    virtualenvwrappersh=$(first_of "${virtualenvwrappers[@]}")
    workon_homes=(
        /usr/local/virtualenvs
        $HOME/.virtualenvs
        )
    workon_home=$(first_of "${workon_homes[@]}")
    if [[ -r $virtualenvwrappersh ]] && [[ -d $workon_home ]]; then
        export WORKON_HOME=$workon_home
        #export PROJECT_HOME=$HOME/src
        source $virtualenvwrappersh
    fi
fi

if [ -d $HOME/.rbenv/shims ] ; then
    export PATH="$HOME/.rbenv/shims:$PATH"
fi

if [ -d /usr/local/heroku/bin ] ; then
    ### Added by the Heroku Toolbelt
    export PATH="/usr/local/heroku/bin:$PATH"
fi

# Set shell prompt, if we're interactive.
if [[ $- = *i* ]]; then
    plain_prompt() {
        export PROMPT_COMMAND=
        export PS1="$ "
    }
    nice_prompt() {
        source ~/bin/liquidprompt/liquidprompt
    }
    nice_prompt
fi
