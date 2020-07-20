ASM_WIN = asm6f_64.exe
ASM_LINUX = asm6f

ASM_FLAGS = -L -c -m
ASM_FILE = src/westward.asm
NES_FILE = src/westward.nes

PYTHON_WIN = py
PYTHON_LINUX = python3

RM_WIN = del /f /q

ifeq ($(OS), Windows_NT)
	ASM = $(ASM_WIN)
	PYTHON = $(PYTHON_WIN)
else
	ASM = $(ASM_LINUX)
	PYTHON = $(PYTHON_LINUX)
endif

PY_ADD_BUILD_NUM = util/add_build_number.py
PY_RM_BUILD_NUM = util/rm_build_number.py
PY_COMPRESS_RLE = util/compress_rle.py

FT_TEXT2DATA = util/famitone4.1/text2vol4

DIR_SRC = src
DIR_ASSETS = src/assets
DIR_ASSETS_WIN = src\assets

COMMIT = $(shell git rev-parse --short HEAD)

RLE_FILES = $(DIR_ASSETS)/bg_alphabet_screen.rle \
			$(DIR_ASSETS)/bg_blank_traveling_screen.rle \
			$(DIR_ASSETS)/bg_columbia_river_screen.rle \
			$(DIR_ASSETS)/bg_instruction_screen.rle \
			$(DIR_ASSETS)/bg_landmark_big_blue_river.rle \
			$(DIR_ASSETS)/bg_landmark_blue_mountains.rle \
			$(DIR_ASSETS)/bg_landmark_chimney_rock.rle \
			$(DIR_ASSETS)/bg_landmark_fort_boise.rle \
			$(DIR_ASSETS)/bg_landmark_fort_bridger.rle \
			$(DIR_ASSETS)/bg_landmark_fort_hall.rle \
			$(DIR_ASSETS)/bg_landmark_fort_kearney.rle \
			$(DIR_ASSETS)/bg_landmark_fort_laramie.rle \
			$(DIR_ASSETS)/bg_landmark_fort_walla_walla.rle \
			$(DIR_ASSETS)/bg_landmark_green_river.rle \
			$(DIR_ASSETS)/bg_landmark_independence.rle \
			$(DIR_ASSETS)/bg_landmark_independence_rock.rle \
			$(DIR_ASSETS)/bg_landmark_kansas_river.rle \
			$(DIR_ASSETS)/bg_landmark_snake_river_crossing.rle \
			$(DIR_ASSETS)/bg_landmark_soda_springs.rle \
			$(DIR_ASSETS)/bg_landmark_south_pass.rle \
			$(DIR_ASSETS)/bg_landmark_the_dalles.rle \
			$(DIR_ASSETS)/bg_landmark_willamette_valley.rle \
			$(DIR_ASSETS)/bg_landmark_fort_decision_screen.rle \
			$(DIR_ASSETS)/bg_landmark_blue_mtn_decision_screen.rle \
			$(DIR_ASSETS)/bg_landmark_dalles_decision_screen.rle \
			$(DIR_ASSETS)/bg_occupation_screen.rle \
			$(DIR_ASSETS)/bg_pace_screen.rle \
			$(DIR_ASSETS)/bg_paused_screen.rle \
			$(DIR_ASSETS)/bg_rations_screen.rle \
			$(DIR_ASSETS)/bg_rest_screen.rle \
			$(DIR_ASSETS)/bg_sprite0_traveling_screen.rle \
			$(DIR_ASSETS)/bg_start_month_screen.rle \
			$(DIR_ASSETS)/bg_store_screen.rle \
			$(DIR_ASSETS)/bg_title_screen.rle \
			$(DIR_ASSETS)/bg_view_supply_screen.rle

default: all

.PHONY: all
all: westward

.PHONY: clean rm_build_number westward rle_files
clean:
ifeq ($(OS), Windows_NT)
	$(RM_WIN) $(DIR_SRC)\*.lst
	$(RM_WIN) $(DIR_SRC)\*.mlb
	$(RM_WIN) $(DIR_SRC)\*.nes
	$(RM_WIN) $(DIR_SRC)\*.bak
	$(RM_WIN) $(DIR_ASSETS_WIN)\*.bak
	$(RM_WIN) $(DIR_SRC)\*.cdl
	$(RM_WIN) $(DIR_ASSETS_WIN)\*.rle
else
	$(RM) $(DIR_SRC)/*.lst
	$(RM) $(DIR_SRC)/*.mlb
	$(RM) $(DIR_SRC)/*.nes
	$(RM) $(DIR_SRC)/*.bak
	$(RM) $(DIR_ASSETS)/*.bak
	$(RM) $(DIR_SRC)/*.cdl
	$(RM) $(DIR_ASSETS)/*.rle
endif

add_build_number:
	$(PYTHON) $(PY_ADD_BUILD_NUM) --input $(DIR_ASSETS)/bg_title_screen.bin --commit $(COMMIT)

rm_build_number:
	$(PYTHON) $(PY_RM_BUILD_NUM) --input $(DIR_ASSETS)/bg_title_screen.bin

$(RLE_FILES): %.rle: %.bin
	$(PYTHON) $(PY_COMPRESS_RLE) --input $< --output $@

# NOT YET WORKING FOR LINUX AS WE CALL WINDOWS PROGRAM
# NEED TO ADD VARS FOR CALLING LINUX-COMPILED VERSION
$(DIR_ASSETS)/audio/audio_data.asm: $(DIR_ASSETS)/audio/audio_data.txt
	$(FT_TEXT2DATA) -asm6 -allin $<

westward.nes: | $(RLE_FILES) $(DIR_ASSETS)/audio/audio_data.asm $(ASM_FILE)
	$(ASM) $(ASM_FLAGS) $(ASM_FILE) $(NES_FILE)

westward: | add_build_number westward.nes rm_build_number