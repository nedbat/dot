# Git etc stuff

# A function instead of an alias so that g will work when non-interactive
# (such as inside gittreeif).  But in some places the alias already exists,
# so remove it first.
unalias g 2>/dev/null
g() { git "$@"; }

if command -v diff-so-fancy >/dev/null; then
    export GIT_PAGER='diff-so-fancy | less -iFRQX'
fi

if [[ $SHELL_TYPE == zsh ]]; then
    compdef g=git
fi

if [[ $SHELL_TYPE == bash ]]; then
    if [[ -r ~/.git-completion.bash ]]; then
        source ~/.git-completion.bash
        __git_complete g __git_main
    fi
fi

# Use our own ~/bin/git-ref-grep to filter references based on a line in .treerc
export TIG_LS_REMOTE=git-ref-grep

# A pager to get exactly one screen of output (taking the prompt into account),
# like this:
#
#   % 1s git log
#
# Define GIT_PAGER and PAGER to be sure it works.
alias 1s='PAGER="head -n $(($(tput lines)-4))" GIT_PAGER=$PAGER'

# Watch the actions, and when they pass, merge to main and push.
alias gshipit='watch_gha_runs --wait-for-start --poll 15 && g ma && g brmerge- && g push'
alias wgha='watch_gha_runs'

# Make it easier to work with merge conflicts.
alias eflict='e $(git flict)'
alias gaflict='git add $(git flict)'
