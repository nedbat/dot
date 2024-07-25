#!/bin/bash

# Add this line to .bashrc (or create it with this line):
#   source ~/.config/nedbat/.bashrc

if [[ -n $PS1 ]]; then
    echo '(.bashrc)'
fi

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
    if [[ -n $PS1 ]]; then
        echo "No globstar"
    fi
fi

if [ "$(shopt -p autocd 2>/dev/null)" ]; then
    shopt -s autocd
else
    if [[ -n $PS1 ]]; then
        echo "No autocd"
    fi
fi

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

export SHELL_TYPE=bash
source ~/.config/env.sh
source ~/.config/rc.sh

# Bash completion
completions=(
    /usr/local/etc/bash_completion
    /etc/bash_completion
)
completion_source=$(_first_of "${completions[@]}")
if [[ -f $completion_source ]]; then
    source $completion_source
fi
