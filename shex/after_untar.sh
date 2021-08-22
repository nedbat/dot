#!/bin/bash
# Commands that will be run after untarring to remove the local copies of 
# old files, and to put new files into their proper places.

# .ssh should be secured.
chmod 700 .ssh

# Some old files need to be renamed.
if [[ -f .path.local ]]; then
    echo Renaming .path.local to .bashrc.local
    mv .path.local .bashrc.local
fi

# # Some Mac junk got into some tarballs. Clean it.
# if [[ $(uname) != 'Darwin' ]]; then
#     echo "Cleaning Mac junk"
#     find . \( -name '.DS_Store' -o -name '._*' \) -print -delete 2>/dev/null
# fi

echo "You can delete dot.sh if you like"
