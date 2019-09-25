#!/bin/bash

tools/palbart -d -x asm/testall.pa || exit 1
tools/tape2bin.sh < asm/testall.bin >img/testall.eep
tools/tapedump.sh < asm/testall.bin >asm/testall.dmp
