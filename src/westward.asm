PRG_COUNT		= 2   ; 2x 16KB PRG code
CHR_COUNT		= 2   ; 2x  8KB CHR data
MAPPER			= 3   ; mapper 3 = CNROM
MIRRORING		= 1   ; background mirroring

;;;;;;;;;;;;;;;
;; iNES header
  .inesprg PRG_COUNT
  .ineschr CHR_COUNT
  .inesmap MAPPER
  .inesmir MIRRORING

;;;;;;;;;;;;;;;

;; DECLARE VARIABLES HERE
  .enum $0000  ;;start variables at ram location 0

gamestate	.dsb 1		; current game state
newgmstate	.dsb 1		; new game state
buttons1    .dsb 1		; player 1 controller buttons pressed
miremaining	.dsb 1		; number of miles remaining (in curr. segment of map)
mitraveled  .dsb 1		; number of miles traveled (curr. day)
yokeoxen	.dsb 1		; number of yoke of oxen
pace		.dsb 1		; travel pace (steady, strenuous, grueling)
curlandmark	.dsb 1		; current landmark we're traveling toward (index value)
month		.dsb 1		; current month (we're assuming a year of 1848)
						; March-July are valid options for starting point
day			.dsb 1		; current day -- start on 1st day of month
spritemem   .dsb 1
textxpos    .dsb 1
textypos	.dsb 1
textvarLo	.dsb 1
textvarHi	.dsb 1
textattrLo	.dsb 1
textattrHi	.dsb 1
paletteLo	.dsb 1		; palette address, low-byte
paletteHi	.dsb 1		; palette address, high-byte
currframe	.dsb 1
currframedy	.dsb 1		; number of times frame has been updated in curr. day
currwagfrm	.dsb 1
vector		.dsb 2
pointer		.dsb 2
scrollH		.dsb 1		; current scroll position
prevbtns	.dsb 1
newbtns		.dsb 1
tempcalca	.dsb 1
tempcalcb	.dsb 1
  .ende

;; DECLARE CONSTANTS HERE
; game state constants
STATETITLE		= $00
STATENEWGAME	= $01
STATETRAVELING	= $02
STATELANDMARK	= $03
STATESTORE		= $04
STATEPAUSED		= $05
STATEENDGAME	= $06

FRAMECOUNT		= $30

FRAMECOUNT_DAY	= $05

; traveling constants
MAX_MI_PER_DAY_A	= $28			; max miles per day to Fort Laramie
MAX_MI_PER_DAY_B	= $18			; max miles per day after Fort Laramie

PACE_STEADY			= $01
PACE_STRENUOUS		= $02
PACE_GRUELING		= $03


; controller buttons
BTN_A			= %10000000
BTN_B			= %01000000
BTN_START		= %00010000
BTN_SELECT		= %00100000
BTN_UPARROW		= %00001000
BTN_DOWNARROW	= %00000100
BTN_LEFTARROW	= %00000010
BTN_RIGHTARROW	= %00000001

;;;;;;;;;;;;;;;;;;

MACRO WAIT_FOR_PPU_STATUS x
@WaitNotSprite0:
  LDA $2002
  AND #x
  BNE @WaitNotSprite0   ; wait until sprite 0 not hit

@WaitSprite0:
  LDA $2002
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
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
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
  STA paletteLo
  LDA #>palette_title
  STA paletteHi
  JSR LoadPalettes

  ; test switching to bank 1 from bank 0 on the CHR-ROM
  ; LDA #$01
  ; JSR BankSwitch

  ; Interesting. Apparently, once I've switched to a different bank (like in
  ; the traveling state), if I reset the console, it won't automatically go
  ; back to the original bank. So I need to explicitly set the bank to 0.
  LDA #$00
  JSR BankSwitch

;;;Set some initial stats in vars
  JSR SetInitialState

              
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop, waiting for NMI




;;;;;;
NMI:
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
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  ;;This is the PPU clean up section, so rendering the next frame starts properly.
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

  ; do scrolling, but we'll only check for scrolling in traveling state.
  ; theoretically, I could just set scrollH to #$00 in all other states, and I
  ; may end up doing that, but for now, I'll do this check.
  LDA gamestate
  AND #STATETRAVELING
  BEQ @NoScroll

  ; see code at https://web.archive.org/web/20190326192637/http://nintendoage.com/forum/messageview.cfm?catid=22&threadid=36969
  ; for getting horizontal status bar working. Now I need to flip it so the horizontal status bar is on the
  ; BOTTOM!
  LDA #$00
  STA $2006
  STA $2006

  ; set no scroll for status bar
  LDA #$00
  STA $2005
  STA $2005
  LDA #%10010000
  STA $2000
  
  WAIT_FOR_PPU_STATUS %01000000

  LDX #$10
@WaitScanline:
  DEX
  BNE @WaitScanline

  LDA scrollH
  STA $2005
  LDA #$00
  STA $2005
  JMP @GraphicsDone:
@NoScroll:
  LDA #$00
  STA $2005
  STA $2005

@GraphicsDone
  ;;;all graphics updates done by here, run game engine

  JSR ReadController1  ;;get the current button data for player 1
  JMP GameEngineLogic  ;;process game engine logic

GameEngineLogicDone:  
  JSR UpdateSprites    ;;update sprites as necessary. Note that I think I need
                       ;;to move this just above the comment above about having
                       ;;all graphical updates "done by here."

  RTI             		; return from interrupt


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
  RTI
;;
  .include "src\display_new_screen_functions.asm"
;;;;;;;; NMI should be complete here

  .include "src\engine_logic_functions.asm"

  .include "src\helper.asm"

;;;;;;;;;;;;;;
UpdateSprites:
  ;;update sprites here
  RTS

;;;;;;;;;;;;;;
SetInitialState:
  LDA #$FF
  STA gamestate
  LDA #STATETITLE
  STA newgmstate
  
  ; set the number of miles traveled in the current segment to 0 mi.
  LDA #$00
  STA mitraveled

  ; set index 0 as the initial landmark traveling towards
  LDA #$00
  STA curlandmark

  ; set 3 yoke of oxen
  LDA #$03
  STA yokeoxen
  
  ; set strenuous pace
  LDA #PACE_STRENUOUS
  STA pace

  ; set starting date of March 1, 1848
  LDA #$03
  STA month
  LDA #$01
  STA day

  LDA #$00
  STA scrollH

  LDA #$00
  STA prevbtns

  LDA #$00
  STA newbtns

  RTS


  .org $E000
  ; set palettes
palette:
  .db $0F,$3D,$09,$19,  $0F,$06,$15,$36,  $0F,$05,$26,$1F,  $0F,$16,$27,$18   ;;background palette
  .db $1F,$00,$27,$10,  $1F,$1C,$06,$10,  $1F,$07,$20,$10,  $1F,$07,$17,$10   ;;sprite palette

palette_title:
  .db $10,$34,$3F,$17,  $10,$3F,$30,$35,  $10,$10,$10,$10,  $10,$10,$10,$10
  .db $10,$17,$28,$30,  $10,$1C,$2B,$39,  $10,$06,$15,$36,  $10,$07,$17,$10

palette_newgame:
  .db $22,$29,$1A,$0F,  $22,$36,$17,$0F,  $22,$1F,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $35,$17,$28,$1F,  $35,$1C,$2B,$39,  $35,$06,$15,$36,  $35,$07,$17,$10   ;;sprite palette

traveling_wagon:
  .db $60,$17,%00000011,$E0,  $60,$18,%00000011,$E8,  $58,$07,%00000011,$E0,  $58,$08,%00000011,$E8
traveling_oxen:
  .db $60,$15,%00000010,$D0,  $60,$16,%00000010,$D8,  $58,$05,%00000010,$D0,  $58,$06,%00000010,$D8

bg_title_screen:
  ;.incbin "src\bg_title_screen.bin"
  .incbin "src\bg_title_screen_rle.bin"
bg_instruction_screen:
  .incbin "src\bg_instruction_screen_rle.bin"
bg_blank_traveling_screen:
  .incbin "src\bg_blank_traveling_screen_rle.bin"
bg_sprite0_traveling_screen:
  .incbin "src\bg_sprite0_traveling_screen_rle.bin"

bankvalues:
  .db $00,$01


; points to appropriate 'load-new-screen' functions so they can get called
; by NMI when it's time to load a new screen
screen:
  .dw DisplayTitleScreen, DisplayNewGameScreen, DisplayTravelingScreen
  .dw $0000, DisplayStoreScreen

; points to appropriate engine logic functions so they can get called by
; the engine
enginelogic:
  .dw EngineLogicTitle, EngineLogicNewGame, EngineLogicTraveling
  .dw $0000, EngineLogicStore

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


landmarkdist:
  .db 102

daysinmonth:
  ; we fill [0] with fake value and that way we can use the month [3] to get the
  ; number of days in March
  .db 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial


;;;;;;;;;;;;;;

  .incbin "src\chrblock.chr"   ;includes 8KB graphics file