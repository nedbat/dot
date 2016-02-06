#
# Executed by BASH shell login
#

[ -n "$PS1" ] && echo '(.bash_profile)'

#
# Call the aliases
#
if [ -r ~/.sh_environment ]; then
    . ~/.sh_environment
fi

#
# Setup system path names
#
if [ "$source" != "BASHRC" ]; then
    if [ -r ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi

# Stop CTRL-D logout
ignoreeof=1

#
# Call hostname specific profile
#
if [ -f ~/.bash_profile.$hostname ]; then
    . ~/.bash_profile.$hostname
fi

#
# Call local profile
#
if [ -f ~/.bash_profile.local ]; then
    . ~/.bash_profile.local
fi
