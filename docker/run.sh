echo "File mappings:"
echo "  ~/coverage/trunk is at /cov"
echo "  here ($PWD) is at /here"
docker run \
    --rm --interactive --tty \
    --env=TERM \
    --name=$1 --hostname=$1 \
    --mount=type=bind,source=$HOME/coverage/trunk,target=/cov,readonly \
    --mount=type=bind,source=$PWD,target=/here \
    nedbat/$1 \
    /usr/bin/zsh
