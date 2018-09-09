#!/bin/bash

# Read by login shells, but the distinction is unimportant, so just read the
# real .bashrc here.

source ~/.bashrc

if [ -f ~/.bash_profile.local ]; then
    echo "*** Not reading .bash_profile.local: rename to .bashrc.local"
fi
