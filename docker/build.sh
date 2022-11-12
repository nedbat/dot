cp ~/dot/dot.sh . 
docker build --file=$1.dockerfile --tag=nedbat/$1 --progress=plain .
docker image prune --force
rm dot.sh
