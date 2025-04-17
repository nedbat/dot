slug=${1/.dockerfile}
shift 1
docker build --file=$slug.dockerfile --tag=nedbat/$slug --progress=plain "$@" .
docker image prune --force
