JVM = java
PAL = tools/bartpal
DIGITAL = tools/Digital-SRL.jar
#DIGITAL = tools/Digital23-107.jar

BINS := $(wildcard bin/*.bn bin/*.bin bin/*.rim)
TMP := $(addsuffix .eep,$(basename $(BINS)))
EEPS := $(TMP:bin/%=img/%)

.PHONY: sim test


$(EEPS): $(BINS)
	@echo convert $< to $@
	@echo convert $^ to $@

test:
	@echo BINS=$(BINS)
	@echo EEPS=$(EEPS)


#	tools/tape2bin.sh < bin/FOCAL-8.bn > img/FOCAL-8.eep
#	tools/tape2bin.sh < bin/FOCAL-8-NOINT.bn > img/FOCAL-8-NOINT.eep


sim:
	($(JVM) -jar $(DIGITAL) sim/PDP8-X.dig &)

buildpal: tools/pal
	$(CC)  tools/sources/pal/pal.c \
	-o tools/pal \
	-Wno-return-type \
	-Wno-implicit-function-declaration \
	-Wno-implicit-int 


