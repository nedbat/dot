# https://werat.github.io/2017/02/04/tmux-ssh-agent-forwarding.html
if [[ ! -S ~/.ssh/ssh_auth_sock ]] && [[ -S "$SSH_AUTH_SOCK" ]]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

if [[ ! -z "$TMUX" ]]; then
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

_start_tmux() {
    # Start or attach to tmux automatically. From https://unix.stackexchange.com/a/490830
    # For calling from local startup files.
    if command -v tmux &> /dev/null && [[ -n "$PS1" ]] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [[ -z "$TMUX" ]]; then
        tmux attach -t default || exec tmux new -s default && exit;
    fi
}
