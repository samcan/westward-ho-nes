[![Board Status](https://dev.azure.com/samuelcantrell/74847b42-095f-489b-ab88-88355b740707/78d5b544-a5a5-4e64-a3e1-5781ec0b780c/_apis/work/boardbadge/7b0494f3-d086-439a-876a-e3687fa2cbee?columnOptions=1)](https://dev.azure.com/samuelcantrell/74847b42-095f-489b-ab88-88355b740707/_boards/board/t/78d5b544-a5a5-4e64-a3e1-5781ec0b780c/Microsoft.RequirementCategory/)

# *Westward Ho!* for NES
*Westward Ho!* is a clone of the *Oregon Trail* game for NES. We
aim to implement a mixture of features/design from the Apple II
and Macintosh (Deluxe) versions. The intention is to have the game
ready for distribution and demonstration at VCF PNW 2021 in early 2021.

*Westward Ho!* is programmed in NES 6502 assembly. It is compiled
using [asm6f][asm6f]. Though we are testing the game with the
[Mesen][mesen] emulator, we plan to produce a physical cartridge.

![](docs/img/westward_001.png?raw=true)

## How to compile

### Compiling on Windows
#### Prerequisites
* Windows 10
* Python 3.8.x (tested using Python 3.8.1)
* [GNU Make for Windows][make] 3.8.1
* [asm6f][asm6f] v1.6 (freem modifications v02)

#### Instructions
1. Install [GNU Make for Windows][make] and add the `bin` directory to your path.
2. Download `asm6f_64.exe` from the latest `asm6f` package and put that in
your path as well.
3. Clone the repository:
  `git clone https://github.com/samcan/westward-ho-nes.git`
4. Switch into the `westward-ho-nes` directory.
5. Run `make`.
6. This will RLE-compress the background files and compile `src\westward.nes`. This can
be run in Mesen.

### Compiling on Linux - OUTDATED
Tested in a live CD environment of Pop!OS 20.04 and in an install of Ubuntu 20.04.

#### Prerequisites
* Python 3.8.x (tested using Python 3.8.2)
* GNU Make 4.2.1
* [asm6f][asm6f] v1.6 (freem modifications v02)

#### Instructions
1. Install `python3`, `git`, and `make` on your machine if not already installed. If you
haven't already compiled `asm6f`, you'll also need `gcc` installed. In Ubuntu, you can install
by running `sudo apt install python3 git make gcc`.
2. Download the latest `asm6f` package and unzip. A Linux makefile doesn't exist yet, but
you can simply compile by running: `gcc -Wall asm6f.c -o asm6f`. Put the compiled binary
`asm6f` somewhere in your path.
3. Clone the repository:
  `git clone https://github.com/samcan/westward-ho-nes.git`
4. Switch into the `westward-ho-nes` directory.
5. Run `make`.
6. This will RLE-compress the background files and compile `src\westward.nes`. This can
be run in Mesen.
  * If `make` can't find `asm6f`, you can specify its location on the command line using the variable `ASM_LINUX`. Similarly,
  you can specify the Python command using `PYTHON_LINUX`.

### Cleaning
1. Run `make clean` to clean the directory of all generated files, including `westward.nes`.

[asm6f]: https://github.com/freem/asm6f
[fceux]: http://www.fceux.com/web/home.html
[mesen]: https://mesen.ca/
[make]: http://gnuwin32.sourceforge.net/packages/make.htm

## Mesen emulation settings
We are using the following emulation settings in Mesen v0.9.9. These are changed in Options > Emulation, on the Advanced tab:

* Enable OAM RAM decay
* Randomize power-on state for mappers
* Randomize power-on/reset CPU/PPU alignment
* Enable PPU $2006 scroll glitch emulation
* Enable PPU $2000/$2005/$2006 first-write scroll glitch emulation
* Default power on state for RAM: Random Values
