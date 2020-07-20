echo '(.zshrc)'

fpath=(/src/zsh-completions/src $fpath)

autoload zmv
autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# I'll be honest: I don't understand these exactly...
zstyle ':completion:*' completer _complete _correct _approximate

# Space will expand any history references in the current line.
bindkey " " magic-space
# Shift-tab cycles in reverse through menu choices.
bindkey "^[[Z" reverse-menu-complete

export SHELL_TYPE=zsh
source ~/.rc.sh
