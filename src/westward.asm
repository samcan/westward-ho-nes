PRG_COUNT		= 2   ; 2x 16KB PRG code
CHR_COUNT		= 4   ; 4x  8KB CHR data
MAPPER			= 3   ; mapper 3 = CNROM
MIRRORING		= 1   ; background mirroring

;;;;;;;;;;;;;;;
;; iNES header
  .inesprg PRG_COUNT
  .ineschr CHR_COUNT
  .inesmap MAPPER
  .inesmir MIRRORING

;;;;;;;;;;;;;;;

AUDIO_YES					; define to include audio support
;SMALL_LANDMARK_YES			; define to include small landmarks
;IMMEDIATELY_START_ERASING	; on alphabet screen, if name is erased, and erase
							; key is pressed again, immediately start deleting
							; letters in previous name rather than just moving
							; indicator up to previous name

;; DECLARE VARIABLES HERE
  .enum $0000  ;;start variables at ram location 0

gamestate	.dsb 1		; current game state
newgmstate	.dsb 1		; new game state
buttons1    .dsb 1		; player 1 controller buttons pressed
miremaining	.dsb 1		; number of miles remaining (in curr. segment of map)
mitraveldy  .dsb 1		; number of miles traveled (curr. day)
mitraveled	.dsb 2		; number of miles traveled (total)
oxen		.dsb 1			; number of oxen
pace		.dsb 1		; travel pace (steady, strenuous, grueling)
rations		.dsb 1
occupation	.dsb 1
basemileage	.dsb 1		; base miles per day
curlandmark	.dsb 1		; current landmark we're traveling toward (index value)
month		.dsb 1		; current month (we're assuming a year of 1848)
						; March-July are valid options for starting point
day			.dsb 1		; current day -- start on 1st day of month
health		.dsb 1		; current health status
weatherzone	.dsb 1		; current weather zone (based on mileage)
tempernum	.dsb 1		; current number for temperature (translated into status)
temperature	.dsb 1		; current temperature status
weathernum	.dsb 1		; current number for weather (translated into status)
weather		.dsb 1		; current weather status
food		.dsb 2
clothes		.dsb 1
cash		.dsb 2
cashremain	.dsb 2
bullets		.dsb 2		; individual number of bullets (100/box)
spareparts	.dsb 1

storeoxen	.dsb 1
storeoxenpr	.dsb 2
storefood	.dsb 1
storefoodpr	.dsb 2
storeclth	.dsb 1
storeclthpr	.dsb 2
storebllt	.dsb 1
storeblltpr	.dsb 2
storepart	.dsb 1
storepartpr	.dsb 1

changed		.dsb 1

sproffset	.dsb 1
textxpos    .dsb 1
textypos	.dsb 1
textvarLo	.dsb 1
textvarHi	.dsb 1
textattrLo	.dsb 1
textattrHi	.dsb 1
paletteptr	.dsb 2		; palette address
currframe	.dsb 1
currframedy	.dsb 1		; number of times frame has been updated in curr. day
currframeld	.dsb 1
currwagfrm	.dsb 1
vector		.dsb 2
pointer		.dsb 2
scrollH		.dsb 1		; current scroll position
prevbtns	.dsb 1
newbtns		.dsb 1
tempcalca	.dsb 1
tempcalcb	.dsb 1
numsprattr	.dsb 1		; attribute for drawing number sprites
numstartX	.dsb 1
numstartY	.dsb 1
htd_in		.dsb 1
htd_out		.dsb 2
thousshown	.dsb 1
hundsshown	.dsb 1
bcdNum		.dsb 2
bcdResult	.dsb 5
Factor		.dsb 1
Res			.dsb 1
Res2		.dsb 1
seed		.dsb 2		; seed for PRNG
randsigned	.dsb 1

.ifdef SMALL_LANDMARKS_YES
landmarkX	.dsb 1
lndmrkicony .dsb 1		; whether landmark icon is shown (0 = NO, 1 = YES)
.endif

choice		.dsb 1
cursorX		.dsb 1
cursorY		.dsb 1
hilitedname	.dsb 1
hilitedltr	.dsb 1
letterX		.dsb 1
numletters	.dsb 1
temp		.dsb 1
curnameidx  .dsb 1
curname		.dsb 2
name0		.dsb 8
name1		.dsb 8
name2		.dsb 8
name3		.dsb 8
name4		.dsb 8

; top-left for metatile
tileptr		.dsb 2
tileoffset	.dsb 1
tileX		.dsb 1
tileY		.dsb 1
tile		.dsb 1
tilepal		.dsb 1
; note that we're reserving $FD-$FF for FamiTone2
  .ende

;; DECLARE CONSTANTS HERE
SPRITE_0		= $10

; game state constants
STATETITLE		= $00
STATENEWGAME	= $01
STATETRAVELING	= $02
STATELANDMARK	= $03
STATESTORE		= $04
STATEPAUSED		= $05
STATEENDGAME	= $06
STATEALPHABET	= $07
STATEPACE		= $08
STATEMONTH		= $09
STATEOCCUPATION	= $0A
STATECHOOSEFORT = $0B
STATERATIONS	= $0C
STATECHOOSEBLUE = $0D
STATECLMBIARVR  = $0E
STATECHOOSEDLLS = $0F
STATEREST		= $10
STATEVIEWSUPPLY = $11

FRAMECOUNT		= $30

FRAMECOUNT_DAY	= $05

.ifdef LANDMARK_ICON_YES
; various specs for the landmark icon on the traveling screen
LANDMARK_OFFSET = $78		; the sprite offset for the small landmark metatile
LANDMARK_TOP_Y  = $90
LANDMARK_LEFT_X = $00
LANDMARK_MAX_X  = $B4
LANDMARK_MILES  = $64		; 100 dec.
FRAME_LNDMRK_10 = $0E
FRAME_LNDMRK_20	= $07
FRAME_LNDMRK_30 = $05
FRAME_LNDMRK_40 = $03
.endif

STATUS_ICON_Y	= $17

; General party health
; the health status icons
HEALTH_GOOD			= $21			; 0-34
HEALTH_FAIR			= $22			; 35-69
HEALTH_POOR			= $23			; 70-104
HEALTH_VERYPOOR		= $24			; 105-139
									; 140+ (remaining party members all die
									; within a few days, whatever that means.
									; I'm guessing it causes an elevated chance
									; for others to get sick and die (see
									; HEALTH_DYING_VAL))

; health values (these are the minimums)
HEALTH_GOOD_VAL 	= 0
HEALTH_FAIR_VAL 	= 35
HEALTH_POOR_VAL 	= 70
HEALTH_VERYPOOR_VAL	= 105
HEALTH_DYING_VAL	= 140


OCC_FARMER		= $01
OCC_CARPENTER	= $02
OCC_BANKER		= $03

; temperatures and their related sprites
TEMP_VERYHOT	= $B0			; >=90 degrees
TEMP_HOT		= $B1			; 70-90 degrees
TEMP_WARM		= $B2			; 50-70 degrees
TEMP_COOL		= $B3			; 30-50 degrees
TEMP_COLD		= $B4			; 10-30 degrees
TEMP_VERYCOLD	= $B5			; <10 degrees
; min temps for above descriptors
TEMP_MAX_F		= 126			; our "MAX" temp. We'll discard any random temps
								; >= this temp and get a new random number.
TEMP_MIN_F		= 0				; our "MIN" temp. For sake of argument, we'll
								; ignore the chance of any negative temps.
TEMP_VERYHOT_F	= 90
TEMP_HOT_F		= 70
TEMP_WARM_F		= 50
TEMP_COOL_F		= 30
TEMP_COLD_F		= 10
; everything below 10 would be TEMP_VERYCOLD

; weather icons
WEATHER_SUN		= $B6
WEATHER_PARTLY	= $B7
WEATHER_RAIN	= $B8
WEATHER_STORM	= $B9
WEATHER_SNOW	= $BA
WEATHER_SNWSTRM = $BB


RATION_BAREBONE	= $01
RATION_MEAGER	= $02
RATION_FILLING	= $03



LANDMARK_CAL_Y	= $BF
PAUSED_CAL_Y	= $1F
; traveling constants
MAX_MI_PER_DAY_A	= $28			; max miles per day to Fort Laramie
MAX_MI_PER_DAY_B	= $18			; max miles per day after Fort Laramie

PACE_STEADY			= $01
PACE_STRENUOUS		= $02
PACE_GRUELING		= $03

REST_DAYS_MAX		= $09

; controller buttons
BTN_A			= 1 << 7
BTN_B			= 1 << 6
BTN_START		= 1 << 4
BTN_SELECT		= 1 << 5
BTN_UPARROW		= 1 << 3
BTN_DOWNARROW	= 1 << 2
BTN_LEFTARROW	= 1 << 1
BTN_RIGHTARROW	= 1 << 0

; alphabet screen
ALPHA_CURSOR_SP = $20
MAX_NAMES		= $04				; including 0, so 5 names total
MAX_LETTER_NAME = $08
MIN_Y			= $8F
MAX_Y			= $BF
MIN_X			= $48
MAX_X			= $A8
NAME0_X			= $30
NAME0_Y			= $2F
NAME1_X			= #NAME0_X
NAME1_Y			= $3F
NAME2_X			= #NAME0_X
NAME2_Y			= $4F
NAME3_X			= #NAME0_X
NAME3_Y			= $5F
NAME4_X			= #NAME0_X
NAME4_Y			= $6F

; pace screen
PACE_CURSOR_SPR	= $3F
PACE_X			= $48
PACE_MIN_Y		= $57
PACE_MAX_Y		= $77

; occupation screen
OCC_CURSOR_SPR	= $3F
OCC_X			= $40
OCC_MIN_Y		= $57
OCC_MAX_Y		= $77

; paused screen
PAUSED_CURSOR_SPR	= $3F
PAUSED_X			= $30
PAUSED_MIN_Y		= $87
PAUSED_MAX_Y		= $AF

; store screen
CASH_START_X		= $D0
CASH_START_Y		= $2F
OXEN_INC			= $01
OXEN_MAX			= 80
FOOD_INC			= $01
FOOD_MAX			= $13
CLOTHES_INC			= $01
CLOTHES_MAX			= 100
BULLETS_INC			= 10
BULLETS_MAX			= 100
SPAREPARTS_INC		= $01
SPAREPARTS_MAX		= 99

; view supply screen
VIEW_CASH_X			= 208
VIEW_CASH_Y			= 40
VIEW_OXEN_X			= 216
VIEW_OXEN_Y			= 64
VIEW_FOOD_X			= 208
VIEW_FOOD_Y			= 88
VIEW_CLOTHES_X		= 216
VIEW_CLOTHES_Y		= 112
VIEW_BULLETS_X		= 208
VIEW_BULLETS_Y		= 136
VIEW_SPAREPARTS_X	= 216
VIEW_SPAREPARTS_Y	= 160

; start-month screen
MONTH_CURSOR_SPR	= $3F
MONTH_X				= $70
MONTH_MIN_Y			= $77
MONTH_MAX_Y			= $B7

; decision-fort screen
CHOOSEFORT_CURSOR_SPR	= $3F
CHOOSEFORT_X			= $40
CHOOSEFORT_MIN_Y		= $57
CHOOSEFORT_MAX_Y		= $67

; decision Blue Mountains screen
CHOOSEBLUE_CURSOR_SPR	= $3F
CHOOSEBLUE_X			= $20
CHOOSEBLUE_MIN_Y		= $57
CHOOSEBLUE_MAX_Y		= $67

; decision Dalles screen
CHOOSEDALLES_CURSOR_SPR	= $3F
CHOOSEDALLES_X			= $20
CHOOSEDALLES_MIN_Y		= $57
CHOOSEDALLES_MAX_Y		= $67

; traveling screen
OXEN_TOP_Y		= $90
OXEN_TOP_X		= $C8

; song names
HOME_ON_THE_RANGE	= $00
YANKEE_DOODLE		= $01
CAMPTOWN_RACES		= $02
OLD_DAN_TUCKER		= $03
ON_TOP_OF_OLD_SMOKY	= $04
OH_SHENANDOAH		= $05
WAYFARING_STRANGER	= $06
RED_RIVER_VALLEY	= $07
YLW_ROSE_OF_TEXAS	= $08
OH_SUSANNAH			= $09
ARKANSAS_TRAVELER	= $0A
IRISH_WASHERWOMAN	= $0B
CAMPBELLS_ARE_CMNG	= $0C
BATTLE_HYMN_REPBLC	= $0D
OLD_KENTUCKY_HOME	= $0E

TITLE_SONG			= #HOME_ON_THE_RANGE

; PPU addresses
PpuCtrl			= $2000
PpuMask			= $2001
PpuStatus		= $2002
OamAddr			= $2003
OamData			= $2004
PpuScroll		= $2005
PpuAddr			= $2006
PpuData			= $2007
OamDma			= $4014

;;;;;;;;;;;;;;;;;;

MACRO WAIT_FOR_PPU_STATUS x
@WaitNotSprite0:
  LDA PpuStatus
  AND #x
  BNE @WaitNotSprite0   ; wait until sprite 0 not hit

@WaitSprite0:
  LDA PpuStatus
  AND #x
  BEQ @WaitSprite0      ; wait until sprite 0 is hit
ENDM

  .org $10000-(PRG_COUNT*$4000)
RESET:
  SEI          ; disable IRQs
  CLD          ; disable decimal mode
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX PpuCtrl  ; disable NMI
  STX PpuMask  ; disable rendering
  STX $4010    ; disable DMC IRQs

  JSR VBlankWait		; First wait for vblank to make sure PPU is ready

  LDX #$00
clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  ;STA $01F0, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x
  INX
  CPX #$00
  BNE clrmem

  JSR VBlankWait		; Second wait for vblank, PPU is ready after this

  ; set up palette for title screen
  LDA #<palette_title
  STA paletteptr
  LDA #>palette_title
  STA paletteptr+1
  JSR LoadPalettes

  ; Interesting. Apparently, once I've switched to a different bank (like in
  ; the traveling state), if I reset the console, it won't automatically go
  ; back to the original bank. So I need to explicitly set the bank to 0.
  LDA #$00
  JSR BankSwitch

;;;Set some initial stats in vars
  JSR SetInitialState

              
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PpuCtrl

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PpuMask

Forever:
  JMP Forever     ;jump back to Forever, infinite loop, waiting for NMI




;;;;;;
NMI:
  JSR IncrementSeed

  ;; NMI (vblank) has been triggered; check if we need to load a new
  ;; screen or just update our current screen.
  LDA newgmstate
  CMP gamestate
  BNE LoadNewScreen

UpdateCurrentScreen:
  ;; We're in the NMI and have determined that we just need to update
  ;; the current screen rather than draw a new screen. Hence we'll leave
  ;; the NMI enabled, quickly read the controller and do our game logic,
  ;; and get out of here.

  ; do sprite DMA
  LDA #$00
  STA OamAddr     ; set the low byte (00) of the RAM address
  LDA #$02
  STA OamDma      ; set the high byte (02) of the RAM address, start the transfer

  ;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PpuCtrl
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PpuMask

  ; do scrolling, but we'll only check for scrolling in traveling state.
  ; theoretically, I could just set scrollH to #$00 in all other states, and I
  ; may end up doing that, but for now, I'll do this check.
  LDA newgmstate
  CMP #STATETRAVELING
  BNE @NoScroll

@Scrollbar:
  ; see code at https://web.archive.org/web/20190326192637/http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=36969
  ; for getting horizontal status bar working. Now I need to flip it so the horizontal status bar is on the
  ; BOTTOM!
  LDA #$00
  STA PpuAddr
  STA PpuAddr

  ; set no scroll for status bar
  LDA #$00
  STA PpuScroll
  STA PpuScroll
  LDA #%10010000
  STA PpuCtrl
  
  WAIT_FOR_PPU_STATUS %01000000

  LDX #$10
@WaitScanline:
  DEX
  BNE @WaitScanline

  LDA scrollH
  STA PpuScroll
  LDA #$00
  STA PpuScroll
  JMP @GraphicsDone
@NoScroll:
  LDA #$00
  STA PpuScroll
  STA PpuScroll

@GraphicsDone
  ;;;all graphics updates done by here, run game engine

  JSR ReadController1  ;;get the current button data for player 1
  JMP GameEngineLogic  ;;process game engine logic

GameEngineLogicDone:
  JMP FinishNMI


;;
LoadNewScreen:
  ;; Still in NMI, we've been told that we need to load a new screen.
  ;; Hence, we'll disable the NMI, clear sprite memory, and load the
  ;; new screen. Then we'll re-enable the NMI before returning from the
  ;; interrupt.
  JSR DisableNMI

  JSR clr_sprite_mem
  JSR ClearBgMemory

  LDA newgmstate
  STA gamestate

  ; we've got to ASL the newgmstate to figure out our index to check for
  ; our screen function to load. we'll then rewrite our gamestate over
  ; newgmstate before jumping. 
  ASL newgmstate
  LDX newgmstate
  LDA screen, x
  STA vector
  INX
  LDA screen, x
  STA vector+1

  ; reset newgmstate to gamestate, otherwise we'll be trying to load the
  ; new screen again, which we don't want.
  LDA gamestate
  STA newgmstate

  ; finally execute the jump
  JMP (vector)

FinishLoadNewScreen:
  ;; now that we've finished loading the new screen, re-enable the NMI and
  ;; return from interrupt
  JSR EnableNMI
  JMP FinishNMI
;;
FinishNMI:
  .ifdef AUDIO_YES
  ; Update music if playing. Note that this should be the last thing
  ; done before returning from the interrupt.
  JSR FamiToneUpdate
  .endif
  RTI             		; return from interrupt
;;;;;;;; NMI should be complete here
;;;;;;;;;;;;;;
SetInitialState:
  LDA #$FF
  STA gamestate
  LDA #STATETITLE
  STA newgmstate

  ; set the number of miles traveled in the current segment to 0 mi.
  LDA #$00
  STA mitraveldy

  ; set total miles traveled to 0
  STA mitraveled
  STA mitraveled+1

  ; set initial weather zone of 0
  STA weatherzone

  ; set index 0 as the initial landmark traveling towards
  STA curlandmark

  ; set 0 oxen (until you buy some)
  STA oxen

  ; until we reach Fort Laramie, our max mileage per day is stored
  ; in MAX_MI_PER_DAY
  LDA #MAX_MI_PER_DAY_A
  STA basemileage

  ; set initial pace of STEADY
  LDA #PACE_STEADY
  STA pace

  ; set initial rations of MEAGER
  LDA #RATION_MEAGER
  STA rations

  ; set health of good
  LDA #HEALTH_GOOD
  STA health

  ; set temperature to fair
  LDA #TEMP_WARM
  STA temperature

  LDA #WEATHER_PARTLY
  STA weather

  ; set starting date of 1st day of month in 1848 (month will
  ; be selected later by player)
  LDA #$01
  STA day

  ; set food of $7D0 (2000 lbs)
  ;LDA #$D0
  ;STA food
  ;LDA #$07
  ;STA food+1

  LDA #$00
  ; set horizontal scroll
  STA scrollH

  ; clear button states
  STA prevbtns
  STA newbtns

  RTS

;;;;;;;;;;;;;;
  ; The ".org $E000" directive isn't necessary as it's artificially partitioning
  ; the ROM's PRG-ROM. I still had a lot of space to fill before this point, and
  ; some space after the palette and background definitions, but this would mean
  ; that I'd have to be careful to line data exactly up so it fit in the remain.
  ; space. This way, all the PRG-ROM data is in one chunk, and as I add data,
  ; whether it be background definitions, audio data, or game logic, the PRG-ROM
  ; will just naturally grow and fill up all the space.
  ;.org $E000

  .include "src/display_new_screen_functions.asm"
  .include "src/engine_logic_functions.asm"
  .include "src/helper.asm"
  .include "src/math.asm"

  ; audio library (FamiTone4.1) and audio data file
  .include "src/audio/famitone4.1/famitone4_asm6.asm"
  .include "src/assets/audio/audio_data.asm"

  ; set palettes
palette:
  .db $0F,$3D,$09,$19,  $0F,$06,$15,$36,  $0F,$05,$26,$10,  $0F,$16,$27,$18   ;;background palette
  .db $1F,$00,$27,$10,  $1F,$1C,$06,$10,  $1F,$11,$21,$10,  $1F,$07,$17,$10   ;;sprite palette

palette_alphabet:
  .db $0F,$3D,$09,$19,  $0F,$06,$15,$36,  $0F,$05,$26,$10,  $0F,$16,$27,$18   ;;background palette
  .db $1F,$00,$27,$10,  $1F,$1C,$06,$27,  $1F,$11,$21,$10,  $1F,$07,$17,$10   ;;sprite palette

palette_title:
  .db $3F,$20,$10,$17,  $3F,$10,$30,$35,  $3F,$10,$11,$12,  $3F,$13,$14,$15   ;;background palette
  .db $3F,$17,$28,$30,  $3F,$1C,$2B,$39,  $3F,$06,$15,$36,  $3F,$07,$17,$10   ;;sprite palette

palette_newgame:
  .db $22,$29,$1A,$0F,  $22,$36,$17,$0F,  $22,$1F,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $35,$17,$28,$1F,  $35,$1C,$2B,$39,  $35,$06,$15,$36,  $35,$07,$17,$10   ;;sprite palette

palette_landmark:
  .db $0F,$22,$09,$19,  $0F,$21,$19,$36,  $0F,$05,$26,$10,  $0F,$16,$27,$18   ;;background palette
  .db $1F,$00,$27,$10,  $1F,$1C,$06,$10,  $1F,$07,$20,$10,  $1F,$07,$17,$10   ;;sprite palette

palette_landmark_chimney_rock:
  .hex 31 0F 3D 10   31 17 19 29   31 17 27 0F   31 09 19 29				  ;;background palette
  .hex 31 0F 27 10   31 0F 06 10   31 07 20 10   31 07 17 10				  ;;sprite palette

palette_landmark_south_pass:
  .hex 31 0F 3D 10   31 17 19 29   31 17 19 0F   31 09 19 29				  ;;background palette
  .hex 31 0F 27 10   31 0F 06 10   31 07 20 10   31 07 17 10				  ;;sprite palette

palette_landmark_blue_mountains:
  .hex 31 0F 3D 10   31 1A 2A 3A   31 2B 2B 3B   31 1B 21 3C				  ;;background palette
  .hex 31 0F 27 10   31 0F 06 10   31 07 20 10   31 07 17 10				  ;;sprite palette

palette_landmark_snake_river_crossing:
  .hex 31 0F 3D 10   31 1A 2A 3A   31 07 17 3B   31 1B 21 3C				  ;;background palette
  .hex 31 0F 27 10   31 0F 06 10   31 07 20 10   31 07 17 10				  ;;sprite palette


; metatile description is the following:
; tile num, palette num IN THE FOLLOWING ORDER:
; TOP LEFT, TOP RIGHT, BOTTOM LEFT, BOTTOM RIGHT
metatile_wagon_frame0:
  .db $07,%00000011,  $08,%00000011
  .db $17,%00000011,  $18,%00000011

metatile_wagon_frame1:
  .db $07,%00000011,  $08,%00000011
  .db $1B,%00000011,  $1C,%00000011

metatile_oxen_frame0:
  .db $05,%00000011,  $06,%00000011
  .db $15,%00000011,  $16,%00000011

metatile_oxen_frame1:
  .db $05,%00000011,  $06,%00000011
  .db $19,%00000011,  $1A,%00000011

; Kansas River Crossing
metatile_landmark_river:
  .db $94,%00000010,  $95,%00000010
  .db $A4,%00000010,  $A5,%00000010

metatile_landmark_big_blue_river:
  .db $96,%00000001,  $97,%00000001
  .db $A6,%00000001,  $A7,%00000001

metatile_landmark_chimney_rock:
  .db $98,%00000011,  $99,%00000011
  .db $A8,%00000011,  $A9,%00000011

metatile_landmark_south_pass:
  .db $9A,%00000011,  $9B,%00000011
  .db $AA,%00000011,  $AB,%00000011

metatile_landmark_fort:
  .db $9C,%00000011,  $9D,%00000001
  .db $AC,%00000011,  $AD,%00000011

metatile_landmark_independence_rock:
  .db $9E,%00000000,  $9F,%00000000
  .db $AE,%00000011,  $AF,%00000011

bg_title_screen:
  ;.incbin "src/assets/bg_title_screen.bin"
  .incbin "src/assets/bg_title_screen.rle"
bg_instruction_screen:
  .incbin "src/assets/bg_instruction_screen.rle"
bg_blank_traveling_screen:
  .incbin "src/assets/bg_blank_traveling_screen.rle"
bg_sprite0_traveling_screen:
  .incbin "src/assets/bg_sprite0_traveling_screen.rle"
bg_alphabet_screen:
  .incbin "src/assets/bg_alphabet_screen.rle"
bg_paused_screen:
  .incbin "src/assets/bg_paused_screen.rle"
bg_pace_screen:
  .incbin "src/assets/bg_pace_screen.rle"
bg_month_screen:
  .incbin "src/assets/bg_start_month_screen.rle"
bg_occupation_screen:
  .incbin "src/assets/bg_occupation_screen.rle"
bg_rations_screen:
  .incbin "src/assets/bg_rations_screen.rle"
bg_rest_screen:
  .incbin "src/assets/bg_rest_screen.rle"
bg_store_screen:
  .incbin "src/assets/bg_store_screen.rle"
bg_view_supply_screen:
  .incbin "src/assets/bg_view_supply_screen.rle"
bg_landmark_kansas_river:
  .incbin "src/assets/bg_landmark_kansas_river.rle"
bg_landmark_big_blue_river:
  .incbin "src/assets/bg_landmark_big_blue_river.rle"
bg_landmark_fort_kearney:
  .incbin "src/assets/bg_landmark_fort_kearney.rle"
bg_landmark_chimney_rock:
  .incbin "src/assets/bg_landmark_chimney_rock.rle"
bg_landmark_fort_laramie:
  .incbin "src/assets/bg_landmark_fort_laramie.rle"
bg_landmark_independence:
  .incbin "src/assets/bg_landmark_independence.rle"
bg_landmark_independence_rock:
  .incbin "src/assets/bg_landmark_independence_rock.rle"
bg_landmark_south_pass:
  .incbin "src/assets/bg_landmark_south_pass.rle"
bg_landmark_fort_bridger:
  .incbin "src/assets/bg_landmark_fort_bridger.rle"
bg_landmark_soda_springs:
  .incbin "src/assets/bg_landmark_soda_springs.rle"
bg_landmark_fort_hall:
  .incbin "src/assets/bg_landmark_fort_hall.rle"
bg_landmark_snake_river_crossing:
  .incbin "src/assets/bg_landmark_snake_river_crossing.rle"
bg_landmark_fort_boise:
  .incbin "src/assets/bg_landmark_fort_boise.rle"
bg_landmark_blue_mountains:
  .incbin "src/assets/bg_landmark_blue_mountains.rle"
bg_landmark_fort_walla_walla:
  .incbin "src/assets/bg_landmark_fort_walla_walla.rle"
bg_landmark_the_dalles:
  .incbin "src/assets/bg_landmark_the_dalles.rle"
bg_landmark_willamette_valley:
  .incbin "src/assets/bg_landmark_willamette_valley.rle"
bg_landmark_green_river:
  .incbin "src/assets/bg_landmark_green_river.rle"
bg_columbia_river_screen:
  .incbin "src/assets/bg_columbia_river_screen.rle"
; landmark decision screens
bg_landmark_fort_decision_screen:
  .incbin "src/assets/bg_landmark_fort_decision_screen.rle"
bg_landmark_blue_mtn_decision_screen:
  .incbin "src/assets/bg_landmark_blue_mtn_decision_screen.rle"
bg_landmark_dalles_decision_screen:
  .incbin "src/assets/bg_landmark_dalles_decision_screen.rle"

bankvalues:
  .db $00,$01,$02,$03


; points to appropriate 'load-new-screen' functions so they can get called
; by NMI when it's time to load a new screen
screen:
  .dw DisplayTitleScreen, DisplayNewGameScreen, DisplayTravelingScreen
  .dw DisplayLandmarkScreen, DisplayStoreScreen, DisplayPausedScreen
  .dw $0000
  .dw DisplayAlphabetScreen, DisplayPaceScreen, DisplayMonthScreen
  .dw DisplayOccupationScreen, DisplayDecisionFortScreen
  .dw DisplayRationsScreen, DisplayDecisionBlueMountainsScreen
  .dw DisplayColumbiaRiverScreen, DisplayDecisionDallesScreen
  .dw DisplayRestScreen, DisplayViewSupplyScreen

; points to appropriate engine logic functions so they can get called by
; the engine
enginelogic:
  .dw EngineLogicTitle, EngineLogicNewGame, EngineLogicTraveling
  .dw EngineLogicLandmark, EngineLogicStore, EngineLogicPaused
  .dw $0000
  .dw EngineLogicAlphabet, EngineLogicPace, EngineLogicMonth
  .dw EngineLogicOccupation, EngineLogicDecisionFort
  .dw EngineLogicRations, EngineLogicDecisionBlueMountains
  .dw EngineLogicColumbiaRiver, EngineLogicDecisionDalles
  .dw EngineLogicRestScreen, EngineLogicViewSupplyScreen

; new line = $00, space char needs to be something else, $FF = done
; first byte is starting y pos
; second byte is starting x pos
; third byte is first char of string
titlewestwardtext:
  .db $40,$60,$66,$54,$62,$63,$66,$50,$61,$53,$00
  .db $50,$76,$57,$5E,$31,$00
  .db $90,$6B,$5F,$7B,$6E,$7C,$7C,$00
  .db $A0,$6B,$62,$63,$50,$61,$63,$FF
titletextattr:
  .db $00

  ; yoke of oxen, spare parts/clothes, box of bullets, 1 lb of food (/100)
storeprices:
  .db 20, 10, 2, 20
  .db 0, 0, 0, 0
  .db 0, 0, 0, 0
  .db 25, 12, 2, 25
  .db 0, 0, 0, 0
  .db 30, 15, 3, 30
  .db 0, 0, 0, 0
  .db 0, 0, 0, 0
  .db 35, 17, 3, 35
  .db 0, 0, 0, 0
  .db 40, 20, 4, 40
  .db 0, 0, 0, 0
  .db 45, 22, 4, 45
  .db 0, 0, 0, 0
  .db 50, 25, 5, 50
  .db 0, 0, 0, 0
  .db 0, 0, 0, 0
  .db 0, 0, 0, 0


; Note regarding Landmarks and the data surrounding them:
;
; Right now I have several pieces of data associated with given
; landmarks:
;
;   * The bank they're loaded from
;   * The distance in mi to them
;   * The bg table responsible for displaying the landmark screen
;   * The function ptr called after the user leaves the landmark screen
;   * The song associated with the landmark screen
;   * (Eventually) The small icon displayed on the main map while traveling for the
;     landmark
;
; Reading _The Pragmatic Programmer_, it seems like I should create one universal table
; responsible for storing all information about landmarks, so that it's easy to see at a
; glance and make changes to this info.
;
; However, at least right now, I'm not making the change. Unfortunately I can't combine
; .db and .dw directives on a single line, which means I need to figure out some way to
; get all of this data (two-byte words and one-byte items) into a single line without making
; it look too long.
landmarkicons:
  .dw $0000, metatile_landmark_river, metatile_landmark_big_blue_river
  .dw metatile_landmark_fort, metatile_landmark_chimney_rock
  .dw metatile_landmark_fort, metatile_landmark_independence_rock
  .dw metatile_landmark_south_pass
  .dw metatile_landmark_fort, metatile_landmark_river
  .dw metatile_landmark_fort, metatile_landmark_river
  .dw metatile_landmark_fort, metatile_landmark_river
  .dw metatile_landmark_fort, metatile_landmark_river
  .dw metatile_landmark_river
  .dw metatile_landmark_river

landmarkdist:
  ; map up to South Pass
  .db 0, 102, 83, 119, 250, 86, 190, 102
  ; (split A) go to Fort Bridger
  .db 125, 162
  ; back at Soda Springs, up to Blue Mountains
  .db 57, 182, 114, 160
  ; (split B) go to Fort Walla Walla
  .db 55, 120
  ; (split C) back at the The Dalles, take Barlow Road
  .db 100
  ; (split A-2) go to Green River
  .db 57, 144
  ; (split B-2) bypass Fort Walla Walla
  .db 125
  ; (split C-2) go down the Columbia River
  .db 0

landmarkdisplay:
  .dw bg_landmark_independence, bg_landmark_kansas_river, bg_landmark_big_blue_river
  .dw bg_landmark_fort_kearney, bg_landmark_chimney_rock
  .dw bg_landmark_fort_laramie, bg_landmark_independence_rock
  .dw bg_landmark_south_pass
  .dw bg_landmark_fort_bridger, bg_landmark_soda_springs
  .dw bg_landmark_fort_hall, bg_landmark_snake_river_crossing
  .dw bg_landmark_fort_boise, bg_landmark_blue_mountains
  .dw bg_landmark_fort_walla_walla, bg_landmark_the_dalles
  .dw bg_landmark_willamette_valley
  ; handles trail splits
  .dw bg_landmark_green_river
  ; need to add separate bg for rafting the Columbia River

landmarkbank:
  .db $02, $01, $01
  .db $01, $02
  .db $01, $01
  .db $02
  .db $01, $01
  .db $01, $03
  .db $01, $02
  .db $01, $01
  .db $01
  .db $01

landmarkptr:
  .dw EndLandmarkState, EndLandmarkState, EndLandmarkState
  .dw EndLandmarkStateFort, EndLandmarkState
  .dw EndLandmarkStateFortLaramie, EndLandmarkState
  .dw EndLandmarkState
  .dw EndLandmarkStateFort, EndLandmarkState
  .dw EndLandmarkStateFort, EndLandmarkState
  .dw EndLandmarkStateFort, EndLandmarkStateBlueMountains
  .dw EndLandmarkStateFort, EndLandmarkStateDalles
  .dw EndGame
  .dw EndLandmarkState

landmarksongs:
  .db #YANKEE_DOODLE, #CAMPTOWN_RACES, #OH_SHENANDOAH
  .db #OH_SUSANNAH, #OLD_DAN_TUCKER
  .db #ARKANSAS_TRAVELER, #WAYFARING_STRANGER
  .db #ON_TOP_OF_OLD_SMOKY
  .db #IRISH_WASHERWOMAN, #RED_RIVER_VALLEY
  .db #CAMPBELLS_ARE_CMNG, #YLW_ROSE_OF_TEXAS
  .db #YANKEE_DOODLE, #OLD_KENTUCKY_HOME
  .db #YANKEE_DOODLE, #YANKEE_DOODLE
  .db #BATTLE_HYMN_REPBLC
  .db #YANKEE_DOODLE

; mileposts at which we go to the next weather zone
weather_zones:
  .dw 0, 209, 595, 842, 1140, 1676

; weather zone number, temperature pointer
weather_zone_temperatures:
  .dw temperatures_kansas_city
  .dw temperatures_north_platte
  .dw temperatures_casper
  .dw temperatures_lander
  .dw temperatures_boise
  .dw temperatures_portland

; month, mean, +variance, -variance
; I'm rounding mean, +variance, and -variance to integer values
; set aside fake month "0"
temperatures_kansas_city:
  .db 0, 0, 0, 0
  .db 1, 29, 12, -16
  .db 2, 34, 10, -14
  .db 3, 44, 14, -8
  .db 4, 55, 7, -8
  .db 5, 65, 9, -5
  .db 6, 74, 5, -4
  .db 7, 78, 7, -5
  .db 8, 77, 7, -6
  .db 9, 68, 7, -6
  .db 10, 56, 6, -6
  .db 11, 44, 8, -8
  .db 12, 31, 8, -18

temperatures_north_platte:
  .db 0, 0, 0, 0
  .db 1, 26, 12, -18
  .db 2, 30, 12, -14
  .db 3, 39, 12, -14
  .db 4, 48, 7, -6
  .db 5, 59, 6, -6
  .db 6, 69, 8, -6
  .db 7, 75, 6, -6
  .db 8, 73, 5, -6
  .db 9, 63, 7, -8
  .db 10, 50, 9, -8
  .db 11, 36, 8, -12
  .db 12, 26, 9, -18

temperatures_casper:
  .db 1, 25, 7, -19
  .db 2, 27, 8, -16
  .db 3, 35, 9, -16
  .db 4, 42, 6, -8
  .db 5, 52, 7, -8
  .db 6, 62, 9, -8
  .db 7, 70, 5, -6
  .db 8, 69, 4, -6
  .db 9, 58, 7, -11
  .db 10, 45, 8, -9
  .db 11, 33, 11, -14
  .db 12, 24, 10, -14

temperatures_lander:
  .db 1, 21, 9, -21
  .db 2, 25, 10, -16
  .db 3, 35, 9, -13
  .db 4, 43, 6, -11
  .db 5, 53, 7, -9
  .db 6, 62, 9, -9
  .db 7, 71, 5, -7
  .db 8, 69, 4, -6
  .db 9, 58, 7, -12
  .db 10, 45, 7, -9
  .db 11, 31, 10, -15
  .db 12, 20, 13, -16

temperatures_boise:
  .db 1, 31, 11, -20
  .db 2, 36, 8, -12
  .db 3, 44, 6, -8
  .db 4, 51, 6, -7
  .db 5, 59, 7, -6
  .db 6, 67, 9, -7
  .db 7, 76, 7, -10
  .db 8, 74, 4, -6
  .db 9, 65, 7, -7
  .db 10, 53, 8, -7
  .db 11, 40, 7, -11
  .db 12, 31, 8, -17

temperatures_portland:
  .db 1, 41, 7, -13
  .db 2, 44, 6, -8
  .db 3, 48, 4, -6
  .db 4, 52, 6, -5
  .db 5, 58, 5, -5
  .db 6, 64, 7, -5
  .db 7, 69, 5, -5
  .db 8, 70, 4, -5
  .db 9, 65, 3, -4
  .db 10, 55, 5, -4
  .db 11, 47, 6, -9
  .db 12, 40, 7, -7


  ; load calendar support
  .incsrc "src/calendar.asm"
  ; load routines for converting hex to dec
  .incsrc "src/hextodec.asm"

; see http://wiki.nesdev.com/w/index.php/Identity_table
; used to emulate instructions like TYX and TXY
identity_table:
  .db $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
  .db $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
  .db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
  .db $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
  .db $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f
  .db $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
  .db $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f
  .db $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f
  .db $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
  .db $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f
  .db $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
  .db $b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
  .db $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
  .db $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df
  .db $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
  .db $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial


;;;;;;;;;;;;;;

  .incbin "src/chrblock.chr"   ;includes 8KB graphics file