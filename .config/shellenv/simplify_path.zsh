# Simplify the path: remove duplicates and non-existant directories.

typeset -U ppath=()
for d in $path; do
    if [[ -d $d ]]; then
        ppath+=($d)
    fi
done

typeset path=($ppath)
unset ppath
