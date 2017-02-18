#!/bin/bash
# read for all interactive shells
#

# If not running interactively, don't do anything
[[ -z $PS1 ]] && return

[[ -n $PS1 ]] && echo -n '(.bashrc) '

# Generic file permissions
umask 22

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If you bork a ! in bash, this lets you edit the line.
shopt -s histreedit

# Set PATH & MANPATH

# Shared object library
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Execute search path
export PATH=$HOME/bin:/opt/local/bin:$PATH:/usr/sbin

#
# Add OS specific PATH & MANPATH info
#
if [ -r ~/.path.$OSTYPE ] ; then
    . ~/.path.$OSTYPE
fi

stty erase ^H

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
alias m='less'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias xp='pushd >/dev/null'
alias xl='pushd +1 >/dev/null'
alias xq='popd >/dev/null'
alias xs='dirs -v'

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

if [ -r ~/.git-completion.bash ] ; then
    . ~/.git-completion.bash
    __git_complete g __git_main
    __git_complete gi __git_main
fi

# Copy the SHA of head, or some other rev.
copysha() { 
    git rev-parse ${@:-HEAD} | tee /dev/tty | tr -d '\n' | clipc
}

# Run a git command for every repo found somewhere beneath the current
# directory.  Use just like "git":
#
#   $ gittree fetch --all --prune       # for example
#
# To only run commands in repos with a particular branch, use gittreeif:
#
#   $ gittreeif branch_name fetch --all --prune
#
gittreeif() {
    local test_branch=$1
    shift
    local git_cmd="$@"
    find . -name .git -type d -prune | while read d; do
        local d=$(dirname $d)
        git -C $d rev-parse --verify -q $test_branch >& /dev/null || continue
        echo "---- $d ----"
        git -C $d $git_cmd
    done
}

gittree() {
    # @ is in every repo, so this runs on all repos
    gittreeif @ "$@"
}

ipinfo() {
    curl ipinfo.io/$(echo "$@" | tr -C '[0-9a-f.:\n]' .)
    echo
}

# e means gvim, vim or vi, depending on what's installed.
export EDITOR=vim
if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ] ; then
    alias e='/Applications/MacVim.app/Contents/MacOS/Vim --servername VIM --remote-silent "$@"'
    alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
    export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
elif type -P gvim &>/dev/null; then
    alias e='gvim --servername GVIM --remote-silent "$@"'
elif type -P vim &>/dev/null; then
    alias e='vim "$@"'
else
    alias e='vi "$@"'
    export EDITOR=vi
fi

# Make less more friendly.
export LESS=-isFJRQWX

# Keep devops from laughing at me :)
export ANSIBLE_NOCOWS=1

# Set the title of the terminal window.
title() {
    # generic:
    #   echo -en "\033]2;$@\007"
    # for iterm2:
    #   http://superuser.com/a/344397
    export WINDOW_TITLE="$@"
    echo -en "\033];$@\007"
}

# iTerm2 has a Window title in addition to the tab title, which title() sets.
wtitle() {
    echo -ne "\033]2;$@\007"
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
        source $virtualenvwrappersh
    fi
fi

# Bash completion
completions=(
    /usr/local/etc/bash_completion
    /etc/bash_completion
)
completion_source=$(first_of "${completions[@]}")
if [[ -f $completion_source ]]; then
    . $completion_source
fi

# Other junk...
if [ -d $HOME/.rbenv/shims ] ; then
    eval "$(rbenv init -)"
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
    fancy_prompt() {
        source ~/bin/liquidprompt/liquidprompt
    }
    fancy_prompt
fi

# Open edX helpers
alias comas='git checkout master'
alias codog='git checkout named-release/dogwood.rc'
alias coeuc='git checkout open-release/eucalyptus.master'
alias cofic='git checkout open-release/ficus.master'

### Added by fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Read a local file if it exists.
if [[ -f ~/.bashrc.local ]]; then
    . ~/.bashrc.local
fi
