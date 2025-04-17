slug=${1/.dockerfile}
echo "File mappings:"
echo "  ~/coverage/trunk is at /cov"
echo "  here ($PWD) is at /here"
docker run \
    --rm --interactive --tty \
    --env=TERM \
    --name=$slug --hostname=$slug \
    --mount=type=bind,source=$HOME/coverage/trunk,target=/cov,readonly \
    --mount=type=bind,source=$PWD,target=/here \
    nedbat/$slug \
    /usr/bin/zsh
