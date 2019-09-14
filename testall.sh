#!/bin/bash

tools/palbart asm/testall.pa || exit 1
tools/tape2bin.sh < asm/testall.bin >img/testall.bin
