#!/bin/bash

# Add this line to .bash_profile (or create it with this line):
#   source ~/.config/nedbat/.bash_profile

# Read by login shells, but the distinction is unimportant, so just read the
# real .bashrc here.

source ~/.bashrc

if [ -f ~/.bash_profile.local ]; then
    echo "*** Not reading .bash_profile.local: rename to .bashrc.local"
fi
