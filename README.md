# PDP-8/X

## A new TTL-based PDP-8

Ths is currently a work-in-progress, with the end goal of actually build one in real hardware some day. But right now I'm just aiming for a simulation which currently is very un-optimized both speed-wise and in regards of the chip count.

Step one is to get the simulation fully working with the built-in non-standard components.  Then I'll convert the simulation design to use 74-series chips that still can be purchased - I expect some changes will be requred in regards of triggering at rising or falling edges and whether 3'rd-state outputs are available in the parts. Finally I'll spend some time optimizing the design, with a focus on the total chip count.

## Folder structure
- asm - Assembly source files. By using the assembler `tools/pal` these are made into tape binaries (.bin/.rim) and put in the *bin* folder
- bin - Tape files in .bin or .rim format. These are converted into loadable files by the `tools/tape2bin.sh` utility
- doc - Pdf's and textfiles with info about the PDP-8 architecture
- img - ROM/RAM images to be loaded into the simulated RAM
- sim - The .dig files for the PDP-8/X simulation 
- tools - Executables like the simulator, compilers and converters

## Simulation requirements
I'm using Helmut Neemans 'Digital' for the simulation. It is required to use a pre-release version of it - v0.23-065 or higher. The standard v0.23 release lacks octal setttings that I use.

The prereleases are available from https://infdigital.dhbw-mosbach.de

The main repo of the Digital project is at https://github.com/hneemann/Digital

## Version
- 2019-09-19 v0.1 - Runs MAINDEC-8E-D0IB (Instruction test 1) successfully
 