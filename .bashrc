#!/bin/bash

if [[ -n $PS1 ]]; then
    echo '(.bashrc)'
else
    # If not running interactively, don't do anything
    return
fi

export SHELL_TYPE=bash
source ~/.rc.sh
