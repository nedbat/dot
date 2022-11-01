# Directory manipulation.

# alias uuu='cd ../../../'
for n in {1..5}; do alias $(printf 'u%.0s' {1..$n})="cd $(printf '../%.0s' {1..$n})"; done
# alias xxx='pushd +3 >/dev/null'
for n in {1..5}; do alias $(printf 'x%.0s' {1..$n})="pushd +$n >/dev/null"; done
# alias x3='pushd +3 >/dev/null'
for n in {1..9}; do alias x$n="pushd +$n >/dev/null"; done
alias xp='pushd >/dev/null'
alias xq='popd >/dev/null'
alias xs='dirs -v'
alias xc='dirs -c'

# Make a directory and cd into it.
# https://unix.stackexchange.com/questions/125385/combined-mkdir-and-cd
mkcd() { 
    mkdir -p -- "$1" && cd -- "$1"
}
