docker run \
    --rm --interactive --tty \
    --env=TERM \
    --name=$1 --hostname=$1 \
    --mount=type=bind,source=$HOME/coverage/trunk,target=/cov,readonly \
    --mount=type=bind,source=$PWD,target=/here \
    nedbat/$1 \
    /bin/bash
