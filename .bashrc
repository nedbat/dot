#!/bin/bash

if [[ -n $PS1 ]]; then
    echo '(.bashrc)'
fi

export SHELL_TYPE=bash
source ~/.rc.sh
