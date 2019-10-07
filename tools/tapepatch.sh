#!/bin/bash

#
# Patch words in a PDP-8 assembly output (tape) files 
#
# Written by Mats Engstrom (mats.engstrom@gmail.com)
# Repo for this code at https://github.com/SmallRoomLabs/pdp8-tape2bin
#
# Example usage:
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

theaddress=$((8#$1))
fromvalue=$((8#$2))
tovalue=$((8#$3))

# Convert the in-data (stdin) into a temporary file with one octal word per line
tmpfile=$(mktemp)
od -An -v -b | LC_ALL=C tr -cs '0-7' '[\n*]' > $tmpfile

mode=0  # 0=default, 1 collecting Origin, 2 collecting Data
field="0"
origin=""
data=""
address=0

# scan all octal data line-by-line
while read line; do
    op=${line:0:1}
    linev=$((8#$line))

    # Leader/Trailer records - Just output them as-is
    if [ "$op" == "2" ]; then 
   	v=$(printf "%x" $linev ); echo -n -e "\\x$v"
	continue; 
    fi

    # Field records - update the field variable (unused in this code)
    if [ "$op" == "3" ]; then
        field=${line:1:1}
   	v=$(printf "%x" $linev ); echo -n -e "\\x$v"
        continue
    fi

    # Origin records - update the address variable at the second(final) record
    if [ $mode == 1 ]; then
        origin=$origin${line:1:2}
        address=$((8#$origin))
        mode=0
   	v=$(printf "%x" $linev ); echo -n -e "\\x$v"
        continue
    fi
    if [ "$op" == "1" ]; then
        origin=${line:1:2}
        mode=1
   	v=$(printf "%x" $linev ); echo -n -e "\\x$v"
        continue
    fi

    # Data records - update the ram-array with the new value at the second(final) record
    if [ $mode == 2 ]; then
        data2=$linev
        mode=0
	if [ "$address" == "$theaddress" ]; then
    		data1=$(( tovalue / 64 )) 
    		data2=$(( tovalue -  ( tovalue / 64 ) * 64 )) 
         fi
        (( address++ ))
   	v=$(printf "%x" $data1 ); echo -n -e "\\x$v"
   	v=$(printf "%x" $data2 ); echo -n -e "\\x$v"
        continue
    fi
    if [ "$op" == "0" ]; then
        data1=$linev
        mode=2
       continue
    fi

done < $tmpfile
rm $tmpfile

