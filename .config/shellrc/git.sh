# Git etc stuff

# A function instead of an alias so that g will work when non-interactive
# (such as inside gittreeif).
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
