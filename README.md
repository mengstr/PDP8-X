# PDP-8/X

## A design for a new implementation of a PDP-8

The end goal of this project is to actually build one in real hardware, but currently I'm aiming for a non-optimized simulation.  Increasing speed and reducing the chip-count are secondary goad for the time being.

### Folder structure
- asm - Assembly source files. By using the assembler `tools/pal` these are made into tape binaries (.bin/.rim) and put in the *bin* folder
- bin - Tape files in .bin or .rim format. These are converted into loadable files by the `tools/tape2bin.sh` utility
- doc - Pdf's and textfiles with info about the PDP-8 architecture
- img - ROM/RAM images to be loaded into the simulated RAM
- sim - The .dig files for the PDP-8/X simulation 
- tools - Executables like the simulator, compilers and converters


### Simulation requirements
I'm using Helmut Neemans 'Digital' for the simulation. It is required to use a pre-release version of software - v0.23-065 or higher. The standard v0.23 release lacks octal setttings that I use.

The prereleases are available from https://infdigital.dhbw-mosbach.de

The main repo of the Digital project is at https://github.com/hneemann/Digital



