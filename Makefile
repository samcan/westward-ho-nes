ASM = asm6f_64.exe
ASM_FLAGS = -L -c -m
ASM_FILE = src\westward.asm
NES_FILE = src\westward.nes

PYTHON = py
PY_ADD_BUILD_NUM = .\util\add_build_number.py
PY_RM_BUILD_NUM = .\util\rm_build_number.py
PY_COMPRESS_RLE = .\util\compress_rle.py

DIR_SRC = src
DIR_ASSETS = src\assets

COMMIT = $(shell git rev-parse --short HEAD)

RLE_FILES = $(DIR_ASSETS)\bg_alphabet_screen.rle \
			$(DIR_ASSETS)\bg_blank_traveling_screen.rle \
			$(DIR_ASSETS)\bg_instruction_screen.rle \
			$(DIR_ASSETS)\bg_landmark_big_blue_river.rle \
			$(DIR_ASSETS)\bg_landmark_blue_mountains.rle \
			$(DIR_ASSETS)\bg_landmark_chimney_rock.rle \
			$(DIR_ASSETS)\bg_landmark_fort_boise.rle \
			$(DIR_ASSETS)\bg_landmark_fort_bridger.rle \
			$(DIR_ASSETS)\bg_landmark_fort_hall.rle \
			$(DIR_ASSETS)\bg_landmark_fort_kearney.rle \
			$(DIR_ASSETS)\bg_landmark_fort_laramie.rle \
			$(DIR_ASSETS)\bg_landmark_fort_walla_walla.rle \
			$(DIR_ASSETS)\bg_landmark_green_river.rle \
			$(DIR_ASSETS)\bg_landmark_independence_rock.rle \
			$(DIR_ASSETS)\bg_landmark_kansas_river.rle \
			$(DIR_ASSETS)\bg_landmark_snake_river_crossing.rle \
			$(DIR_ASSETS)\bg_landmark_soda_springs.rle \
			$(DIR_ASSETS)\bg_landmark_south_pass.rle \
			$(DIR_ASSETS)\bg_landmark_the_dalles.rle \
			$(DIR_ASSETS)\bg_landmark_willamette_valley.rle \
			$(DIR_ASSETS)\bg_pace_screen.rle \
			$(DIR_ASSETS)\bg_paused_screen.rle \
			$(DIR_ASSETS)\bg_sprite0_traveling_screen.rle \
			$(DIR_ASSETS)\bg_start_month_screen.rle \
			$(DIR_ASSETS)\bg_store_screen.rle \
			$(DIR_ASSETS)\bg_title_screen.rle

default: all

.PHONY: all
all: westward

.PHONY: clean rm_build_number westward rle_files
clean:
	del /f /s /q *.lst
	del /f /s /q *.mlb
	del /f /s /q *.nes
	del /f /s /q *.bak
	del /f /s /q *.cdl
	del /f /s /q *.rle

add_build_number:
	$(PYTHON) $(PY_ADD_BUILD_NUM) --input $(DIR_ASSETS)\bg_title_screen.bin --commit $(COMMIT)

rm_build_number:
	$(PYTHON) $(PY_RM_BUILD_NUM) --input $(DIR_ASSETS)\bg_title_screen.bin

$(RLE_FILES): %.rle: %.bin
	$(PYTHON) $(PY_COMPRESS_RLE) --input $< --output $@

westward.nes: $(RLE_FILES) $(ASM_FILE)
	$(ASM) $(ASM_FLAGS) $(ASM_FILE) $(NES_FILE)

westward: | add_build_number westward.nes rm_build_number