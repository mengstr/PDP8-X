#!/bin/bash


dd if=/dev/zero of=img/blank4KW.eep bs=2 count=4096

tools/tape2bin.sh < bin/D0AB-InstTest-1.pt >img/D0AB-InstTest-1.eep

tools/tape2bin.sh < bin/D0BB-InstTest-2.pt >img/D0BB-InstTest-2.eep
 
cat 	img/D0AB-InstTest-1.eep \
	img/D0BB-InstTest-2.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	img/blank4KW.eep \
	> img/multitest32KW.eep
	
