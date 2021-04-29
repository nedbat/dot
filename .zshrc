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
zstyle ':completion:*' rehash true

# I'll be honest: I don't understand these exactly...
zstyle ':completion:*' completer _complete _correct _approximate

# Space will expand any history references in the current line.
bindkey " " magic-space
# Shift-tab cycles in reverse through menu choices.
bindkey "^[[Z" reverse-menu-complete

# Don't write timestamps
setopt no_extended_history
setopt no_share_history
setopt inc_append_history
# Sounds good, but this takes 12sec
#setopt histexpiredupsfirst
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
HISTFILE=~/.history
SAVEHIST=100000
HISTSIZE=50000

# Prevent Ctrl-D from exiting the shell
setopt ignore_eof

# Don't pushd automatically when changing directories.
setopt no_auto_pushd
# Make pushd work the same as Bash.
setopt no_pushd_minus
# Resolve symlinks when changing directories.
#setopt chase_links

# **.c is short for **/*.c
setopt glob_star_short
# Don't wait to verify history expansion.
setopt no_hist_verify
# Comments work in interactive shells (bashtags)
setopt interactive_comments

# Hash automatically so that executables are found on install.
setopt no_hash_dirs

zle-line-init() rehash
zle -N zle-line-init

export SHELL_TYPE=zsh
source ~/.rc.sh
