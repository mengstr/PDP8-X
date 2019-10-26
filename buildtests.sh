#!/bin/bash

declare -a arr=(
	"printhelp.bin                PC:0200 (This help)"
	"D0AB-InstTest-1.pt           PC:0200 SR:7777 Watch:0121 cont@0147"
	"D0BB-InstTest-2.pt           PC:0200 SR:xxxx Watch:3747"
	"D0IB-JMPJMS.pt               PC:0200 SR:xxxx Watch:3571"
	"D0JB-JMPJMS-RANDOM.pt        PC:0200 SR:0000 Watch:0043/0044"
	"D0DB-RandomAND.pt            PC:0200 SR:0000 Watch:0202"
	"D0EB-Random-TAD.pt           PC:0200 SR:0000 Watch:6776"
	"D0FC-Random-ISZ.pt           PC:0200 SR:0000 Watch:0175/0575"
	"D0GC-Random-DCA.pt           PC:0200 SR:0000 Watch 0006/0011"
	"D0CC-AddTest.pt              PC:0200"
	"D1AA-Memory-Checkerboard.pt  PC:0200"
	"D1EA-Memory-Address.rim      PC:0200"
	"focal-8.bin                  PC:0200"
	"IntIO.bin                    PC:0100"
	"Intout.bin                   PC:0100"
	"tstest.bin                   PC:0100"
	"CHEKMO.bn                    PC:0200"
	"chkmoo.bin                   PC:0200"
	"irqtest.bin                  PC:0200"
 )

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


echo Appending the texts into the printhelp
cp asm/printhelp.base asm/printhelp.pal
# Convert array text into PAL assembly
for (( cnt=0; cnt<${#arr[@]}; cnt++ )); do
	full=${arr[cnt]}
	msg="$(printf "%03o: %s\n" $cnt "$full")"
	for (( i=0; i<${#msg}; i++ )); do
		v=$(ord "${msg:$i:1}")
		vo=$(printf "%04o" $v)
		echo "    $vo   / ${msg:$i:1}" >> asm/printhelp.pal
	done
	echo "    0012   / CR" >> asm/printhelp.pal
	echo "    0015   / NL" >> asm/printhelp.pal
	echo "" >> asm/printhelp.pal
done
echo '    "<;"e;"n;"d;">;0015' >> asm/printhelp.pal
echo "    0" >> asm/printhelp.pal
echo "$" >> asm/printhelp.pal

echo Running the printhelp source thru the assembler
tools/palbart asm/printhelp.pal
mv -f asm/printhelp.bin bin/

echo Running the focal source thru the assembler
tools/palbart asm/focal-8.pal
mv -f asm/focal-8.bin bin/

echo Running Vince Slyngstads IntIO.pal thru the assembler
tools/palbart asm/IntIO.pal
mv -f asm/IntIO.bin bin/

echo Running Vince Slyngstads Intout.pal thru the assembler
tools/palbart asm/Intout.pal
mv -f asm/Intout.bin bin/

echo Running Vince Slyngstads tstest.pal thru the assembler
tools/palbart asm/tstest.pal
mv -f asm/tstest.bin bin/

echo Running chkmoo.pal thru the assembler
tools/palbart asm/chkmoo.pal
mv -f asm/chkmoo.bin bin/

echo Running irqtest.pal thru the assembler
tools/palbart asm/irqtest.pal
mv -f asm/irqtest.bin bin/
 
# Interate over the array of files and process them
# where the source is newer than the destination file
for (( cnt=0; cnt<${#arr[@]}; cnt++ )); do
	src=${arr[cnt]%% *}
	dst="${src%.*}".eep
	echo Checking if "bin/$src" is newer than "img/$dst"
	if [[ "bin/$src" -nt "img/$dst" ]]; then
		echo Converting...
		tools/tape2bin.sh < bin/$src >img/$dst
	fi
done

echo Create an empty 4KW filler file
dd if=/dev/zero of=img/blank4KW.eep bs=2 count=4096 
# 2&> /dev/null

echo Copy all separate files into the single multitest -file
rm -f img/32xMultitest.eep
touch img/32xMultitest.eep
for src in "${arr[@]}"; do
	dst="${src%.*}".eep
	cat img/$dst >> img/32xMultitest.eep
done

echo Fill up the remainder of the 32 slots with blanks 
cnt=${#arr[@]}
while [ $cnt -lt 32 ]; do
	cat img/blank4KW.eep >> img/32xMultitest.eep
	((cnt++))
done

