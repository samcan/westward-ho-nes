if exist src\*.lst del /f /q src\*.lst
if exist src\*.mlb del /f /q src\*.mlb
if exist src\*.nes del /f /q src\*.nes
if exist src\*.bak del /f /q src\*.bak
if exist src\*.cdl del /f /q src\*.cdl

py .\util\rm_build_number.py --input .\src\assets\bg_title_screen.bin