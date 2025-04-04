#!/bin/bash
#
# A shell archive for all dot files. Copy to a machine, then:
# 
#   prompt> ./dot.sh
#

# Commands run before untarring.

if [[ ${0##*/} != :SCRIPTNAME: ]]; then
    echo "Run this directly, don't source it."
    echo "This shell might disappear..."
    sleep 5
    exit 1
fi

if [[ $(pwd) != $HOME ]]; then
    echo "This must be run in your home directory ($HOME)."
    exit 1
fi

# Moved git stuff into .config/git
mv -v .gitconfig .gitconfig.old.$(date "+%Y%M%d%H%M%S")
rm -vf .tigrc
rm -vrf .gitglobal

# Re-organized shell startup
rm -vf .rc.sh

# Vimrc moved
rm -vf .vimrc

# All vim settings moved
rm -vrf .vim

# Remove things that might be in the account by default that we don't want.
rm -vf .cshrc .profile

# Remove things we used to use.
rm -vf .sh_environment .sh_environment.Linux
rm -vf .path .path.Linux .path.darwin12 .path.darwin14 .path.darwin7.0
rm -vf .path.solaris .path.solaris2.8
rm -vf .emacs .cvspass .rhosts
rm -vf .vim/plugin/qfixtoggle.vim
rm -vf .vim/doc/fuf.* .vim/plugin/fuf.vim
rm -vrf .vim/autoload/fuf
rm -vf .xchat_freenode .xchat_guildofwriters .xchat_macroped
rm -vf .gitattributes_global .gitignore_global

# Moved to pathogen, remove .vim stuff from the old locations
rm -vf .vim/doc/NERD_tree.txt .vim/doc/fugitive.txt .vim/doc/qfixtoggle.txt
rm -vrf .vim/nerdtree_plugin
rm -vf .vim/plugin/NERD_tree.vim .vim/plugin/fugitive.vim .vim/plugin/minibufexpl.vim
rm -vf .vim/syntax/nerdtree.vim
rm -vf .vim/doc/tags

# Moved away from pathogen, no need for bundle any more.
rm -vrf .vim/bundle

# Plugins are fully provided in the tarball, so delete whatever is there, or
# we have no way of removing plugins we no longer use.
rm -rf .vim/plugged

# Old way of handling tar cleanup.
rm -vf .after_untar .clean_old_dot_files

# This got in somehow.
rm -rf .mypy_cache
