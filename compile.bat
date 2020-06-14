@echo off
echo #####################
echo Cleaning old files...
echo #####################
call clean.bat
echo ###################################
echo RLE-compressing background files...
echo ###################################
py .\util\compress_rle.py --input .\src\assets\bg_blank_traveling_screen.bin --output .\src\assets\bg_blank_traveling_screen_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_instruction_screen.bin --output .\src\assets\bg_instruction_screen_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_sprite0_traveling_screen.bin --output .\src\assets\bg_sprite0_traveling_screen_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_alphabet_screen.bin --output .\src\assets\bg_alphabet_screen_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_paused_screen.bin --output .\src\assets\bg_paused_screen_rle.bin
echo.
echo # Compressing title screen...
echo.
py .\util\compress_rle.py --input .\src\assets\bg_title_screen.bin --output .\src\assets\bg_title_screen_rle.bin
echo.
echo # Compressing landmark screens...
echo. 
py .\util\compress_rle.py --input .\src\assets\bg_landmark_kansas_river.bin --output .\src\assets\bg_landmark_kansas_river_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_big_blue_river.bin --output .\src\assets\bg_landmark_big_blue_river_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_fort_kearney.bin --output .\src\assets\bg_landmark_fort_kearney_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_chimney_rock.bin --output .\src\assets\bg_landmark_chimney_rock_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_fort_laramie.bin --output .\src\assets\bg_landmark_fort_laramie_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_independence_rock.bin --output .\src\assets\bg_landmark_independence_rock_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_south_pass.bin --output .\src\assets\bg_landmark_south_pass_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_fort_bridger.bin --output .\src\assets\bg_landmark_fort_bridger_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_soda_springs.bin --output .\src\assets\bg_landmark_soda_springs_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_fort_hall.bin --output .\src\assets\bg_landmark_fort_hall_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_snake_river_crossing.bin --output .\src\assets\bg_landmark_snake_river_crossing_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_fort_boise.bin --output .\src\assets\bg_landmark_fort_boise_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_blue_mountains.bin --output .\src\assets\bg_landmark_blue_mountains_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_fort_walla_walla.bin --output .\src\assets\bg_landmark_fort_walla_walla_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_the_dalles.bin --output .\src\assets\bg_landmark_the_dalles_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_willamette_valley.bin --output .\src\assets\bg_landmark_willamette_valley_rle.bin
py .\util\compress_rle.py --input .\src\assets\bg_landmark_green_river.bin --output .\src\assets\bg_landmark_green_river_rle.bin
echo #####################
echo Compiling NES file...
echo #####################
asm6f_64.exe -L -c -m src\westward.asm src\westward.nes