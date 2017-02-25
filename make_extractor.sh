#!/bin/bash
# From: https://community.linuxmint.com/tutorial/view/1998

payload=$1
script=$2

printf "#!/bin/bash\n" > $script
cat before_untar.sh >> $script
printf "PAYLOAD_LINE=\`awk '/^__PAYLOAD_BELOW__/ {print NR + 1; exit 0; }' \$0\`
echo Unpacking
tail -n+\$PAYLOAD_LINE \$0 | tar -xz
" >> $script
cat after_untar.sh >> $script
printf "exit 0
__PAYLOAD_BELOW__
" >> $script
cat $payload >> $script

chmod +x $script
