@echo off
echo Cleaning old files...
call clean.bat
echo RLE-compressing background files...
py .\util\compress_rle.py --input .\src\bg_blank_traveling_screen.bin --output .\src\bg_blank_traveling_screen_rle.bin
py .\util\compress_rle.py --input .\src\bg_instruction_screen.bin --output .\src\bg_instruction_screen_rle.bin
py .\util\compress_rle.py --input .\src\bg_sprite0_traveling_screen.bin --output .\src\bg_sprite0_traveling_screen_rle.bin
py .\util\compress_rle.py --input .\src\bg_title_screen.bin --output .\src\bg_title_screen_rle.bin
echo Compiling NES file...
asm6f_64.exe -L -c -m src\westward.asm src\westward.nes