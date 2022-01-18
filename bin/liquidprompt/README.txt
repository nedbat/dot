This is a subset of https://github.com/nojhan/liquidprompt

To update:

git -C /src/liquidprompt fetch --all
git -C /src/liquidprompt switch stable
for f in *; do 
    if [[ -e /src/liquidprompt/$f ]]; then 
        cp -v /src/liquidprompt/$f .; 
    fi;
done
