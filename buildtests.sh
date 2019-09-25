#!/bin/bash

declare -a arr=(
	"printhelp.bin          PC:0200 - This help"
	"D0AB-InstTest-1.pt     PC:0200, cont at 0147 - "
	"D0BB-InstTest-2.pt     PC:0200 - "
	"D0IB-JMPJMS.pt         PC:0200 - "
	"D0JB-JMPJMS-RANDOM.pt  PC:0200 - "
	"D0DB-RandomAND.pt      PC:0200 - "
	"D0CC-AddTest.pt        PC:0200 - "
	"FOCAL-8-NOINT.bn       PC:0200 - "
)

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

cp asm/printhelp.base asm/printhelp.pal
# Convert array text into PAL assembly
for (( cnt=0; cnt<${#arr[@]}; cnt++ )); do
	full=${arr[cnt]}
	msg="$(printf "%02o: %s\n" $cnt "$full")"
	for (( i=0; i<${#msg}; i++ )); do
		v=$(ord "${msg:$i:1}")
		vo=$(printf "%04o" $v)
		echo "    $vo   / ${msg:$i:1}" >> asm/printhelp.pal
	done
	echo "    0015   / Newline" >> asm/printhelp.pal
	echo "" >> asm/printhelp.pal
done
echo '    "<;"e;"n;"d;">;0015' >> asm/printhelp.pal
echo "    0" >> asm/printhelp.pal
echo "$" >> asm/printhelp.pal
tools/palbart asm/printhelp.pal
mv -f asm/printhelp.bin bin/

# Interate over the array of files and process them
# where the source is newer than the destination file
for src in ${arr[@]}; do
	dst="${src%.*}".eep
	if [[ "bin/$src" -nt "img/$dst" ]]; then
		tools/tape2bin.sh < bin/$src >img/$dst
	fi
done

# Create an empty "filler" file
dd if=/dev/zero of=img/blank4KW.eep bs=2 count=4096 2&> /dev/null

# Copy all resultings files into the multitest -file
rm -f img/32xMultitest.eep
touch img/32xMultitest.eep
for src in "${arr[@]}"; do
	dst="${src%.*}".eep
	cat img/$dst >> img/32xMultitest.eep
done

# Fill up the remainder of the 32 slots with blank images 
cnt=${#arr[@]}
while [ $cnt -lt 32 ]; do
	cat img/blank4KW.eep >> img/32xMultitest.eep
	((cnt++))
done
