# Add this line to .zshrc (or create it with this line):
#   source ~/.config/nedbat/.zshrc
#
# Run by interactive zshells

echo '(.zshrc)'

export XDG_CONFIG_HOME=$HOME/.config

if [[ -f $HOME/.gitconfig.$USER ]]; then
    export GIT_CONFIG_GLOBAL=$HOME/.gitconfig.$USER
fi

# Places to find more zsh completions
for d in \
    /src/zsh-completions/src \
    /opt/homebrew/share/zsh/site-functions \
    $XDG_CONFIG_HOME/zsh-completions \
; do
    if [[ -d $d ]]; then
        fpath=($d $fpath)
    fi
done

autoload zmv
autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select
# Directories are shown in white
# https://github.com/zsh-users/zsh/blob/master/Functions/Misc/colors
zstyle -d ':completion:*:default' list-colors
zstyle ':completion:*' list-colors 'di=01;37'
zstyle ':completion:*' verbose true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' format '%F{225}╒═══ %d ═══╕%f' # 225 is thistle1 #ffd7ff
zstyle ':completion:*' group-name ''

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

# Can use compact forms of command:  for i in 1 2 3; echo $i
setopt short_loops
# Disable silly =command expansion (same as $(which command) )
setopt no_equals

# I need @^ to mean @^
setopt no_extended_glob

#zle-line-init() rehash
#zle -N zle-line-init

# Transient prompt for starship
# From: https://github.com/spaceship-prompt/spaceship-prompt/issues/775#issuecomment-977161851
if command -v starship >/dev/null; then
    zle-line-init() {
      emulate -L zsh
    
      [[ $CONTEXT == start ]] || return 0
    
      while true; do
        zle .recursive-edit
        local -i ret=$?
        [[ $ret == 0 && $KEYS == $'\4' ]] || break
        [[ -o ignore_eof ]] || exit 0
      done
    
      local saved_prompt=$PROMPT
      local saved_rprompt=$RPROMPT
      PROMPT='$(STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship-transient.toml starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
      RPROMPT=''
      zle .reset-prompt
      PROMPT=$saved_prompt
      RPROMPT=$saved_rprompt
    
      if (( ret )); then
        zle .send-break
      else
        zle .accept-line
      fi
      return ret
    }
    zle -N zle-line-init
fi


export SHELL_TYPE=zsh
# We shouldn't need to read env.sh again, because it was already read by .zshenv.
# But something is pushing things onto the front of PATH, and env.sh pushes the
# things we want at the front.
source $XDG_CONFIG_HOME/env.sh
source $XDG_CONFIG_HOME/rc.sh
