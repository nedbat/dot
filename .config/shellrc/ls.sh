# ls stuff

export LSCOLORS=gxfxDxDxxxDxDxxxxxgxgx
unset LS_COLORS
export CLICOLOR=1

if command -v eza &>/dev/null; then
    export EZA_CONFIG_DIR=$XDG_CONFIG_HOME/eza
    alias l="eza --long --classify --group-directories-first --git"
    alias la="l -A"
    alias lsd="l -A --only-dirs"
    alias lt="l --tree"
    for n in {2..5}; do alias lt$n="lt --level=$n"; done
else
    alias l="ls -lFhH"
    alias la="l -A"
    if [[ $SHELL_TYPE == zsh ]]; then
        # https://twitter.com/dailyzshtip/status/1534925273703096322
        alias lsd='l -d *(/D)'
    fi
fi

alias df='df -k'
