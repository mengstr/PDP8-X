#!/bin/bash

#
# Convert PDP-8 assembly output (tape) files into a plain 16 bit bnary file
# suitable to include in an digital emulator like Logisim or Digital
#
# Written by Mats Engstrom (mats.engstrom@gmail.com)
# Repo for this code at https://github.com/SmallRoomLabs/pdp8-tape2bin
#
# Example usage:
# ../Tools/pal test.pa
# ./tape2bin.sh < test.bin > test.eep
#
#
#--------------------------------------------------------------------------
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any means.
#
# For more information, please refer to <http://unlicense.org>
#--------------------------------------------------------------------------

#
# TAPE FORMAT
#
# http://www.pdp8.net/pdp8cgi/query_docs/tifftopdf.pl/pdp8docs/dec-8e-xbina-a-d.pdf
#
#
# 10.000.000  o200  Leader/Trailer
# 
# 11.xxx.000  o3x0  Field value xxx
#
# 01.xxx.xxx  o1xx  Origin xxx.xxx.yyy.yyy
# 00.yyy.yyy  o0yy  
#
# 00.xxx.xxx  o0xx  Data xxx.xxx.yyy.yyy
# 00.yyy.yyy  o0yy 
#
#

# Size of RAM in PDP8-words
WORDS=4096

# Fill unused words with this constant
FILLWORD=7402

# Convert the in-data (stdin) into a temporary file with one octal word per line
tmpfile=$(mktemp)
od -An -v -b | LC_ALL=C tr -cs '0-7' '[\n*]' > $tmpfile

declare -a ram
for ((i=0; i<WORDS; i++)); do ram[i]=$FILLWORD; done

mode=0  # 0=default, 1 collecting Origin, 2 collecting Data
field="0"
origin=""
data=""
address=0

# scan all octal data line-by-line
while read line; do
    op=${line:0:1}

    # Leader/Trailer records - Just ignore them
    if [ "$op" == "2" ]; then 
    	continue; 
    fi

    # Field records - update the field variable (unused in this code)
    if [ "$op" == "3" ]; then
        field=${line:1:1}
#	>&2 echo "Field record "$field
        continue
    fi

    # Origin records - update the address variable at the second(final) record
    if [ $mode == 1 ]; then
        origin=$origin${line:1:2}
#	>&2 echo "Origin record 0"$origin
        address=$((8#$origin))
        mode=0
        continue
    fi
    if [ "$op" == "1" ]; then
        origin=${line:1:2}
        mode=1
        continue
    fi

    # Data records - update the ram-array with the new value at the 
    # second(final) record, but ignore any data destined for other fields
    # than field 0 (within the first 4 KW of memory). And also don't
    # overwrite any old value
    if [ $mode == 2 ]; then
        data=$data${line:1:2}
        mode=0
        if [ "$field" == "0" ]; then
            lastAddress=$address
            lastData=${ram[$address]}
            if [ "${ram[$address]}" == "$FILLWORD" ]; then
                ram[$address]=$data
	    fi
            (( address++ ))
        fi
        continue
    fi
    if [ "$op" == "0" ]; then
        data=${line:1:2}
        mode=2
        continue
    fi

done < $tmpfile
rm $tmpfile

# Undo the last written data that was the checksum in a .bin file
#ram[$lastAddress]=$lastData

# Write all the ram data as plain binary chars to stdout 
>&2 echo "Writing..."
for ((i=0; i<WORDS; i++)); do
    v=$((8#$o${ram[$i]}))
    vH=$(printf "%x" $(( v / 256 )) )
    vL=$(printf "%x" $(( v -  ( v / 256 ) * 256 )) )
    echo -n -e "\\x$vL\\x$vH"
done
