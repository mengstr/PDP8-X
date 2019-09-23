#!/bin/bash


dd if=/dev/zero of=img/blank4KW.eep bs=2 count=4096

#0
tools/tape2bin.sh < bin/D0AB-InstTest-1.pt >img/D0AB-InstTest-1.eep

#1
tools/tape2bin.sh < bin/D0BB-InstTest-2.pt >img/D0BB-InstTest-2.eep

#2
tools/tape2bin.sh < bin/D0IB-JMPJMS.pt >img/D0IB-JMPJMS.eep

#3
tools/tape2bin.sh < bin/D0JB-JMPJMS-RANDOM.pt >img/D0JB-JMPJMS-RANDOM.eep

#4
tools/tape2bin.sh < bin/D0DB-RandomAND.pt >img/D0DB-RandomAND.eep

#5
tools/tape2bin.sh < bin/D0CC-AddTest.pt > img/D0CC-AddTest.eep

#6
#tools/tape2bin.sh < bin/_____.pt > img_____.eep

#31 
tools/tape2bin.sh < bin/FOCAL-8-NOINT.bn > img/FOCAL8NOI.eep

cat \
	img/D0AB-InstTest-1.eep \
	img/D0BB-InstTest-2.eep \
	img/D0IB-JMPJMS.eep \
	img/D0JB-JMPJMS-RANDOM.eep \
	img/D0DB-RandomAND.eep \
	img/D0CC-AddTest.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/FOCAL8NOI.eep \
	> img/multitest128KW.eep
	
