# PDP-8/X

## A new TTL-based PDP-8

Ths is currently a work-in-progress, with the end goal of actually build one in real hardware some day. But right now I'm just aiming for a simulation which currently is very un-optimized both speed-wise and in regards of the chip count.

Step one is to get the simulation fully working with the built-in non-standard components.  Then I'll convert the simulation design to use 74-series chips that still can be purchased - I expect some changes will be requred in regards of triggering at rising or falling edges and whether 3'rd-state outputs are available in the parts. Finally I'll spend some time optimizing the design, with a focus on the total chip count.

## Some screenshots
![Overall view](https://raw.githubusercontent.com/SmallRoomLabs/PDP8-X/master/pictures/Sim-Overall-v0.2.png)

![Front panel](https://raw.githubusercontent.com/SmallRoomLabs/PDP8-X/master/pictures/Sim-ControlPanel-v0.2.png)

![Data paths](https://raw.githubusercontent.com/SmallRoomLabs/PDP8-X/master/pictures/Sim-DataPaths-v0.2.png)

![AC/L/MQ registers](https://raw.githubusercontent.com/SmallRoomLabs/PDP8-X/master/pictures/Sim-AC_L_MQ-v0.2.png)



## Folder structure
- /asm/ - Assembly source files. By using the assembler `tools/pal` these are made into tape binaries (.bin/.rim) and put in the *bin* folder
- /bin/ - Tape files in .bin or .rim format. These are converted into loadable files by the `tools/tape2bin.sh` utility
- /doc/ - Pdf's and textfiles with info about the PDP-8 architecture
- /img/ - ROM/RAM images to be loaded into the simulated RAM
- /sim/ - The .dig files for the PDP-8/X simulation 
- /tools/ - Executables like the simulator, compilers and converters
- /pictures/ - Screenshots and other images

## Simulation requirements
I'm using Helmut Neemans 'Digital' for the simulation. It is required to use a pre-release version of it - v0.23-065 or higher. The standard v0.23 release lacks octal setttings that I use.

The prereleases are available from https://infdigital.dhbw-mosbach.de

The main repo of the Digital project is at https://github.com/hneemann/Digital

## Versions
- 2019-09-19 v0.1 - Runs MAINDEC-8E-D0AB (Instruction test 1) successfully
- 2019-09-19 v0.2PA - Runs MAINDEC-8E-D0BB (Instruction test 2) until *2677. Uses 8-slot banked memory to ease changing of test images.

 