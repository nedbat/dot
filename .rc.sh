# Sourced for all interactive shells, $SHELL_TYPE is the shell type.
# Must work for bash and zsh.

# Shared object library
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib

# Execute search path
export PATH=$HOME/bin:/usr/local/bin:/opt/local/bin:$PATH:/usr/sbin

stty erase ^H

#
# Set the terminal type properly.
# TERM is tried as a terminal type. If unknown, a trailing dash component will
# be stripped, and repeat.  So "xterm-256color-italic" will fallback to
# "xterm-256color", and then to "xterm" if needed.
#
# To make xterm-256color-italic work:
# https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
#
# $ cat > xterm-256color-italic.terminfo
# xterm-256color-italic|xterm with 256 colors and italic,
#   sitm=\E[3m, ritm=\E[23m,
#   use=xterm-256color,
# $ tic xterm-256color-italic.terminfo
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
    echo "Couldn't use TERM=${TERM}, trying ${TERM%-*}"
    # Remove the last dash-separated component and try again.
    export TERM=${TERM%-*}
done

export LSCOLORS=gxfxDxDxxxDxDxxxxxgxgx
export CLICOLOR=1

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
alias x='pushd +1 >/dev/null'
alias xx='pushd +2 >/dev/null'
alias xxx='pushd +3 >/dev/null'
alias xxxx='pushd +4 >/dev/null'
alias x1='pushd +1 >/dev/null'
alias x2='pushd +2 >/dev/null'
alias x3='pushd +3 >/dev/null'
alias x4='pushd +4 >/dev/null'
alias x5='pushd +5 >/dev/null'
alias x6='pushd +6 >/dev/null'
alias x7='pushd +7 >/dev/null'
alias x8='pushd +8 >/dev/null'
alias x9='pushd +9 >/dev/null'
alias xq='popd >/dev/null'
alias xs='dirs -v'
alias xc='dirs -c'

alias sep='printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n========================================================================================================================\n"'

# Reset things
# this used to "cd $(pwd -P)" but I don't remember why.
alias a='title "$WINDOW_TITLE"; wtitle "$WINDOW_TITLE"'

# Clip output horizontally to not wrap lines in the terminal
alias ccc='cut -c-$(tput cols)'

if command -v pbcopy >/dev/null; then
    clipc() { pbcopy "$@"; }
    clipv() { pbpaste "$@"; }
elif command -v xclip >/dev/null; then
    clipc() { xclip -sel clip -i "$@"; }
    clipv() { xclip -sel clip -o "$@"; }
fi

if command -v xdg-open >/dev/null; then
    open() { xdg-open "$@"; }
fi

# Git etc stuff

# A function instead of an alias so that g will work when non-interactive
# (such as inside gittreeif).
g() { git "$@"; }

if command -v diff-so-fancy >/dev/null; then
    export GIT_PAGER='diff-so-fancy | less -iFRQX'
fi

if [[ $SHELL_TYPE == zsh ]]; then
    compdef g=git
fi

if [[ $SHELL_TYPE == bash ]]; then
    if [[ -r ~/.git-completion.bash ]]; then
        source ~/.git-completion.bash
        __git_complete g __git_main
    fi
fi

# Don't show all the release-candidate branches in edx-platform
export TIG_LS_REMOTE="ls-remote-grep -v release-candidate"

# Run a command for every repo found somewhere beneath the current directory.
#
#   $ gittree git fetch --all --prune
#
# To only run commands in repos with a particular branch, use gittreeif:
#
#   $ gittreeif branch_name git fetch --all --prune
#
# If the command has subcommands that need to run in each directory, quote the
# entire command:
#
#   $ gittreeif origin/foo 'git log --format="%s" origin/foo ^$(git merge-base origin/master origin/foo)'
#
# The directory name is printed before each command.  Use -q to suppress this,
# or -r to show the origin remote url instead of the directory name.
#
#   $ gittreeif origin/foo -q git status
#
gittreeif() {
    local test_branch="$1"
    shift
    local show_dir=true show_repo=false
    if [[ $1 == -r ]]; then
        # -r means, show the remote url instead of the directory.
        shift
        local show_dir=false show_repo=true
    fi
    if [[ $1 == -q ]]; then
        # -q means, don't echo the separator line with the directory.
        shift
        local show_dir=false show_repo=false
    fi
    find . -name .git -type d -prune | while read d; do
        local d=$(dirname "$d")
        git -C "$d" rev-parse --verify -q "$test_branch" >& /dev/null || continue
        if [[ $show_dir == true ]]; then
            echo "---- $d ----"
        fi
        if [[ $show_repo == true ]]; then
            echo "----" $(git -C "$d" config --get remote.origin.url) "----"
        fi
        if [[ $# == 1 && $1 == *' '* ]]; then
            (cd "$d" && eval "$1")
        else
            (cd "$d" && "$@")
        fi
    done
}

gittree() {
    # @ is in every repo, so this runs on all repos
    gittreeif @ "$@"
}

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'

# Get IP info from IP address on command line or clipboard.
ipinfo() {
    local ip="$@"
    if [[ -z "$ip" ]] ; then
        local ip="$(clipv)"
    fi
    curl ipinfo.io/$(echo "$ip" | tr -C '[0-9a-f.:\n]' .)
    echo
}

# https://github.com/nedbat/odds/blob/master/set_env.py
alias set_env='$(set_env.py $(git ls-files))'

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

# rg will read options from a config file.
export RIPGREP_CONFIG_PATH=~/.rgrc

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

export PYTHONSTARTUP=~/.startup.py

# Locally installed Python stuff.
if [[ -d $HOME/.local/bin ]] ; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# pyenv
#if [[ -d /usr/local/pyenv ]] ; then
#    export PYENV_ROOT=/usr/local/pyenv
#fi

# Virtualenvwrapper support
virtualenvwrappers=(
    ~/.local/bin/virtualenvwrapper.sh
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
    export VIRTUALENVWRAPPER_PYTHON=python3.9
    source $virtualenvwrappersh
fi

# miniconda
if [[ -d /usr/local/miniconda ]] ; then
    eval "$(/usr/local/miniconda/bin/conda shell.$SHELL_TYPE hook)"
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
        prompt_OFF
        export PS1=$(printf "\n$ ")
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

# https://werat.github.io/2017/02/04/tmux-ssh-agent-forwarding.html
if [[ ! -S ~/.ssh/ssh_auth_sock ]] && [[ -S "$SSH_AUTH_SOCK" ]]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

if [[ ! -z "$TMUX" ]]; then
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

_start_tmux() {
    # Start or attach to tmux automatically. From https://unix.stackexchange.com/a/490830
    # For calling from local startup files.
    if command -v tmux &> /dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [[ -z "$TMUX" ]]; then
        tmux attach -t default || exec tmux new -s default && exit;
    fi
}

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

if [[ -n $PS1 ]]; then
    # If we are already in a Python virtualenv, re-activate it to make sure it wins
    # the $PATH wars.
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "Reactivating $VIRTUAL_ENV.."
        source $VIRTUAL_ENV/bin/activate
    fi
fi
