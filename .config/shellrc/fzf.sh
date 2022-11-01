# Added by fzf
if [[ -n $PS1 ]]; then
    if [[ -f ~/.fzf.$SHELL_TYPE ]]; then
        source ~/.fzf.$SHELL_TYPE
    fi
fi
