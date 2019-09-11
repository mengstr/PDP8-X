JVM = java
PAL = bin/pal

.PHONY: sim

sim:
	$(JVM) -jar bin/Digital.jar sim/PDP8-X.dig

