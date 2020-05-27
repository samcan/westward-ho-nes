# *Westward Ho!* for NES
*Westward Ho!* is a clone of the *Oregon Trail* game for NES. We
aim to implement a mixture of features/design from the Apple II
and Macintosh (Deluxe) versions. The intention is to have the game
ready for distribution and demonstration at VCF PNW 2021 in early 2021.

*Westward Ho!* is programmed in NES 6502 assembly. It is compiled
using nesasm3. Though we are testing the game with the fceux and Nestopia
emulators, we plan to produce a physical cartridge.

## How to compile
Make sure `nesasm.exe` from `nesasm3.zip` is located somewhere in your path.
Once you've cloned the repository, switch into the folder, and run `compile.bat`.
If successful, the script will output `src\westward.nes`. This can be run in
fceux or Nestopia.
