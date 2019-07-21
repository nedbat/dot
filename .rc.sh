# Sourced for all interactive shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

if [[ $SHELL_TYPE == bash ]]; then
    # Check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
    # If you bork a ! in bash, this lets you edit the line.
    shopt -s histreedit
    # Case-insensitive wildcard matching.
    shopt -s nocaseglob

    # ** expands recursively
    if [ "$(shopt -p globstar 2>/dev/null)" ]; then
        shopt -s globstar
    else
        echo "No globstar"
    fi

    if [ "$(shopt -p autocd 2>/dev/null)" ]; then
        shopt -s autocd
    else
        echo "No autocd"
    fi
fi

# Set PATH & MANPATH

# Shared object library
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Execute search path
export PATH=$HOME/bin:/usr/local/bin:/opt/local/bin:$PATH:/usr/sbin

stty erase ^H

export PYTHONSTARTUP=~/.startup.py

if [[ $SHELL_TYPE == bash ]]; then
    # Only exit the shell if 10 ^D's are typed.
    export IGNOREEOF=10

    # Set history settings
    export HISTFILE=~/.history
    # Don't record the same command twice in a row
    export HISTCONTROL=ignoredups
    # Save 100000 commands in the history file.
    export HISTSIZE=100000
    # Don't save 1- or 2-letter commands, or space-started commands, or duplicates.
    export HISTIGNORE='?:??: *:&'
    # Append to the history file, don't overwrite it.
    shopt -s histappend
    # After every command, flush the writable history to the file.
    export PROMPT_COMMAND='history -a'
elif [[ $SHELL_TYPE == zsh ]]; then
    # Don't write timestamps
    setopt no_extendedhistory
    setopt no_sharehistory
    setopt incappendhistory
    HISTFILE=~/.history
    SAVEHIST=100000
    HISTSIZE=5000

    # Don't pushd automatically when changing directories.
    setopt no_auto_pushd
    # Make pushd work the same as Bash.
    setopt no_pushd_minus
    # **.c is short for **/*.c
    setopt glob_star_short
    # Don't wait to verify history expansion.
    setopt no_hist_verify

    autoload zargs
    # Use like:
    #   forall *.db -- sqlite3 {} "select count(*) from file"
    alias forall='zargs -i{} --'
fi

#
# Set the terminal type properly.
# TERM is tried as a terminal type. If unknown, a trailing dash component will
# be stripped, and repeat.  So "xterm-256color-italic" will fallback to
# "xterm-256color", and then to "xterm" if needed.
#

while true; do
    if tput longname >/dev/null 2>&1; then
        # This is a known terminal.
        break
    fi
    if [[ $TERM != *-* ]]; then
        # No more qualifiers to strip off.
        break
    fi
    # Remove the last dash-separated component and try again.
    export TERM=${TERM%-*}
done

#
# Basic Unix command aliases
#
alias ls='ls -F'
alias df='df -k'

alias l='ls -lFhH'
alias la='l -A'
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
alias x='pushd +1 >/dev/null'
alias xq='popd >/dev/null'
alias xs='dirs -v'

alias sep='printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n========================================================================================================================\n"'

if command -v pbcopy >/dev/null; then
    alias clipc='pbcopy'
    alias clipv='pbpaste'
elif command -v xclip >/dev/null; then
    alias clipc='xclip -sel clip -i'
    alias clipv='xclip -sel clip -o'
fi

if command -v xdg-open >/dev/null; then
    alias open='xdg-open'
fi

# Git etc stuff

alias g='git'

export GIT_PS1_SHOWSTASHSTATE='y'
export GIT_PS1_SHOWDIRTYSTATE='y'

if [[ $SHELL_TYPE == bash ]]; then
    if [[ -r ~/.git-completion.bash ]]; then
        source ~/.git-completion.bash
        __git_complete g __git_main
        __git_complete gi __git_main
    fi
fi

# Don't show all the release-candidate branches in edx-platform
export TIG_LS_REMOTE="ls-remote-grep -v release-candidate"

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
    local test_branch="$1"
    shift
    find . -name .git -type d -prune | while read d; do
        local d=$(dirname "$d")
        git -C "$d" rev-parse --verify -q "$test_branch" >& /dev/null || continue
        echo "---- $d ----"
        if [[ $# == 1 && $1 == *' '* ]]; then
            (cd "$d" && eval "git $1")
        else
            git -C "$d" "$@"
        fi
    done
}

gittree() {
    # @ is in every repo, so this runs on all repos
    gittreeif @ "$@"
}

# Get IP info from IP address on command line or clipboard.
ipinfo() {
    local ip="$@"
    if [[ -z "$ip" ]] ; then
        local ip="$(clipv)"
    fi
    curl ipinfo.io/$(echo "$ip" | tr -C '[0-9a-f.:\n]' .)
    echo
}

# e means gvim, vim or vi, depending on what's installed.
export EDITOR=vim
if [[ -x /Applications/MacVim.app/Contents/MacOS/Vim ]] ; then
    alias e='/Applications/MacVim.app/Contents/MacOS/Vim --servername VIM --remote-silent'
    alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
    export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
elif type -P gvim &>/dev/null; then
    alias e='gvim --servername GVIM --remote-silent'
elif type -P vim &>/dev/null; then
    alias e='vim'
else
    alias e='vi'
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

# iTerm2 aliases.

alias i2clear="printf '\e]50;ClearScrollback\a'"
alias i2focus="printf '\e]50;StealFocus\a'"
alias i2profile="printf '\e]50;SetProfile=%s\a'"

# Find the first file that exists in a list of possibilities.
first_of() {
    for f; do
        if [[ -r $f ]]; then
            echo "$f"
            return 0    # found
        fi
    done
    return 1  # not found
}

# Pythons
alias p='python'

# pythonz
if [[ -d /usr/local/pythonz ]] ; then
    export PYTHONZ_ROOT=/usr/local/pythonz
    source $PYTHONZ_ROOT/etc/bashrc
fi

# pyenv
if [[ -d /usr/local/pyenv ]] ; then
    export PYENV_ROOT=/usr/local/pyenv
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
if [[ $SHELL_TYPE == bash ]]; then
    completions=(
        /usr/local/etc/bash_completion
        /etc/bash_completion
    )
    completion_source=$(first_of "${completions[@]}")
    if [[ -f $completion_source ]]; then
        source $completion_source
    fi
fi

# Find stuff that might be installed, and put it on our path.
if [[ -d /Applications/Postgres.app ]] ; then
    export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
fi

if [[ -d /usr/local/Cellar/gettext ]] ; then
    # Find the latest gettext, and add it to the PATH.
    # \ls is to get unaliased ls.
    export PATH="$PATH:$(\ls -d1 /usr/local/Cellar/gettext/*/bin | tail -1)"
fi

# Set shell prompt, if we're interactive.
if [[ -n $PS1 ]]; then
    plain_prompt() {
        export PROMPT_COMMAND=
        export PS1="\n$ "
    }
    fancy_prompt() {
        source ~/bin/liquidprompt/liquidprompt
        if [[ $SHELL_TYPE != zsh ]]; then
            export LP_PS1_PREFIX="${SHELL_TYPE:0:1} "
        fi
    }
    fancy_prompt
fi

# Pasting to gist
if [[ -f /usr/local/bin/gist ]]; then
    # gistv [FILENAME]: paste the clipboard to Gist
    gistv() {
        gist -Ppc -f ${1:-something.txt}
    }
fi

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

##
## Third-party tools
##

if [[ -d $HOME/.rbenv/shims ]]; then
    eval "$(rbenv init -)"
fi

# Added by fzf
if [[ -f ~/.fzf.$SHELL_TYPE ]]; then
    source ~/.fzf.$SHELL_TYPE
fi

# Read a local file if it exists.

if [[ -f ~/.rc_local.sh ]]; then
    source ~/.rc_local.sh
fi

# If we are already in a Python virtualenv, re-activate it to make sure it wins
# the $PATH wars.
if [[ -n $VIRTUAL_ENV ]]; then
    echo "Reactivating $VIRTUAL_ENV.."
    source $VIRTUAL_ENV/bin/activate
fi
