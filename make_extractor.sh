#!/bin/bash
# From: https://community.linuxmint.com/tutorial/view/1998

payload=$1
script=$2
tmp=__extract__$RANDOM

printf "#!/bin/bash
PAYLOAD_LINE=\`awk '/^__PAYLOAD_BELOW__/ {print NR + 1; exit 0; }' \$0\`
tail -n+\$PAYLOAD_LINE \$0 | tar -xvz
source .after_untar
rm .after_untar

exit 0
__PAYLOAD_BELOW__\n" > "$tmp"

cat "$tmp" "$payload" > "$script" && rm "$tmp"
chmod +x "$script"
