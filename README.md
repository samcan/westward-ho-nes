[![Board Status](https://dev.azure.com/samuelcantrell/74847b42-095f-489b-ab88-88355b740707/78d5b544-a5a5-4e64-a3e1-5781ec0b780c/_apis/work/boardbadge/7b0494f3-d086-439a-876a-e3687fa2cbee?columnOptions=1)](https://dev.azure.com/samuelcantrell/74847b42-095f-489b-ab88-88355b740707/_boards/board/t/78d5b544-a5a5-4e64-a3e1-5781ec0b780c/Microsoft.RequirementCategory/)

# *Westward Ho!* for NES
*Westward Ho!* is a clone of the *Oregon Trail* game for NES. We
aim to implement a mixture of features/design from the Apple II
and Macintosh (Deluxe) versions. The intention is to have the game
ready for distribution and demonstration at VCF PNW 2021 in early 2021.

*Westward Ho!* is programmed in NES 6502 assembly. It is compiled
using [asm6f][asm6f]. Though we are testing the game with the [fceux][fceux]
and [Mesen][mesen] emulators, we plan to produce a physical cartridge.

## How to compile
Make sure `asm6f_64.exe` from the latest `asm6f` package is located somewhere in
your path. Once you've cloned the repository, switch into the folder, and run
`compile.bat`. If successful, the script will output `src\westward.nes`. This can
be run in fceux or Mesen.

[asm6f]: https://github.com/freem/asm6f
[fceux]: http://www.fceux.com/web/home.html
[mesen]: https://mesen.ca/
