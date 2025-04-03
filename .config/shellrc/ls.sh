# ls stuff

export LSCOLORS=gxfxDxDxxxDxDxxxxxgxgx
export CLICOLOR=1

alias ls='ls -F'
alias l='ls -lFhH'
alias la='l -A'

if [[ $SHELL_TYPE == zsh ]]; then
    # https://twitter.com/dailyzshtip/status/1534925273703096322
    alias lsd='l -d *(/D)'
fi

alias df='df -k'


if command -v eza >/dev/null; then
    export EZA_CONFIG_DIR=$XDG_CONFIG_HOME/eza
    alias ll='eza -lF --group-directories-first'
fi
