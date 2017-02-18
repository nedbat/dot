#!/bin/bash
# Commands that will be run after untarring to remove the local copies of 
# old files, and to put new files into their proper places.

# .ssh should be secured.
chmod 700 .ssh

# Some Mac junk got into some tarballs
if [[ $(uname) == 'Linux' ]]; then
    find . -name '.DS_Store' -delete
    find . -name '._*' -delete
fi
