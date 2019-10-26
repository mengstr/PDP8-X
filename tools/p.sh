#!/bin/bash
 
# Location   063 from 02676 to 01354
# Location   064 from 02666 to 02414
# Location 02732 from 06001 to 05336
# Location 02762 from 06046 to 07000

cat test.bin | ./tapedump.sh | grep -E '0060 -|2730 -|2760 -'

cat test.bin | \
	./tapepatch.sh 00063 02676 01354 | \
	./tapepatch.sh 00064 02666 02414 | \
	./tapepatch.sh 02732 06001 05336 | \
	./tapepatch.sh 02762 06046 07000 > test1.bin

cat test1.bin | ./tapedump.sh | grep -E '0060 -|2730 -|2760 -'

 
