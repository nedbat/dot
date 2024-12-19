# This directory has miscellaneous other files that go in random places.

for f in \
    ~/Library/Application\ Support/Choosy/behaviors.plist \
    /usr/local/pyenv/*.{sh,py} \
    /etc/synthetic.conf \
    /src/python/build.sh \
; do
    if [[ -f $f ]]; then
        cp $f elsewhere/${f//\//__}
    fi
done
