  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 2   ; 2x  8KB CHR data
  .inesmap 3   ; mapper 3 = CNROM
  .inesmir 1   ; background mirroring
  

;;;;;;;;;;;;;;;

;; DECLARE VARIABLES HERE
  .enum $0000  ;;start variables at ram location 0

gamestate	.dsb 1		; current game state
newgmstate	.dsb 1		; new game state
buttons1    .dsb 1		; player 1 controller buttons pressed
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
currwagfrm	.dsb 1
vector		.dsb 2
pointer		.dsb 2
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

  .org $C000 
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
  LDA #$01
  JSR BankSwitch

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
  LDA #$00        ;;tell the ppu there is no background scrolling
  STA $2005
  STA $2005

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
DisableNMI:
  ; disable rendering and NMIs
  LDA #$00
  STA $2000
  STA $2001

  ; set output address
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006
  RTS

EnableNMI:
  ; enable NMI
  LDA $2002
  LDA #%10010000
  STA $2000
  RTS
;;
DisplayTitleScreen:
  ;LDX #$04				; start text display using sprite 1 rather than
						; sprite 0
  ;STX spritemem

  ;LDA #<titlewestwardtext
  ;STA textvarLo
  ;LDA #>titlewestwardtext
  ;STA textvarHi

  ;LDA #<titletextattr
  ;STA textattrLo
  ;LDA #>titletextattr
  ;STA textattrHi
  ;JSR DisplayText

  LDA #<bg_title_screen
  STA pointer+0
  LDA #>bg_title_screen
  STA pointer+1

  ; set output address
  LDA #$2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  ; copy screen to VRAM
@Copy1024Bytes:
  LDX #$04
@Copy256Bytes:
  LDY #$00
@Copy1Byte:
  LDA (pointer), y
  STA $2007
  INY
  BNE @Copy1Byte
  INC pointer+1
  DEX
  BNE @Copy256Bytes

  JMP FinishLoadNewScreen

DisplayNewGameScreen:
  LDA #<palette_newgame
  STA paletteLo
  LDA #>palette_newgame
  STA paletteHi
  JSR LoadPalettes

  JMP FinishLoadNewScreen

DisplayStoreScreen:
  JMP FinishLoadNewScreen

DisplayTravelingScreen:
  LDA #<palette
  STA paletteLo
  LDA #>palette
  STA paletteHi
  JSR LoadPalettes

  ; first part of metatile
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0

  LDA #$60
  STA $0200, x

  INX
  LDA #$17
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E0
  STA $0200, x

  ; 2nd part of metatile
  INX
  LDA #$60
  STA $0200, x

  INX
  LDA #$18
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E8
  STA $0200, x

  ; 3rd part of metatile
  INX
  LDA #$58
  STA $0200, x

  INX
  LDA #$07
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E0
  STA $0200, x

  ; 4th part of metatile
  INX
  LDA #$58
  STA $0200, x

  INX
  LDA #$08
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E8
  STA $0200, x

  ;; load oxen metatile
  ; first part of metatile
  INX
  LDA #$60
  STA $0200, x

  INX
  LDA #$15
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$D0
  STA $0200, x

  ; 2nd part of metatile
  INX
  LDA #$60
  STA $0200, x

  INX
  LDA #$16
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$D8
  STA $0200, x

  ; 3rd part of metatile
  INX
  LDA #$58
  STA $0200, x

  INX
  LDA #$05
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$D0
  STA $0200, x

  ; 4th part of metatile
  INX
  LDA #$58
  STA $0200, x

  INX
  LDA #$06
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$D8
  STA $0200, x

  LDA #$00
  STA currwagfrm

  JMP FinishLoadNewScreen
;;;;;;;; NMI should be complete here

;;;;;;;;
;;;;;;;; ENGINE LOGIC SUBROUTINES
;;;;;;;;
; deal with title screen input; check for Start button to be pressed to exit
; title screen state
EngineLogicTitle:
  LDA buttons1
  AND #BTN_START
  BNE EndTitleState
  JMP GameEngineLogicDone
EndTitleState:
  ; user is exiting title state, switch to new game state
  LDA #STATENEWGAME
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicNewGame:
  JSR ReadController1
  LDA buttons1
  AND #BTN_SELECT		; todo change to start once more function implemented
  BNE EndNewGameState
  JMP GameEngineLogicDone
EndNewGameState:
  ; user is exiting new game state, switch to general store state
  LDA #STATESTORE
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;; 
EngineLogicStore:
  ;; logic associated with general store
  JSR ReadController1
  LDA buttons1
  AND #BTN_START
  BNE EndStoreGameState
  JMP GameEngineLogicDone
EndStoreGameState:
  ; user is exiting new game state, switch to general store state
  LDA #STATETRAVELING
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;;
EngineLogicTraveling:
  INC currframe
  LDA currframe
  CMP #FRAMECOUNT
  BEQ FlipWagonAnimation
  JMP GameEngineLogicDone

FlipWagonAnimation:
  LDA #$00
  STA currframe

  LDA currwagfrm
  CMP #$00
  BEQ LoadFrameOne

LoadFrameZero:
  LDA #$00
  STA currwagfrm

  ; first part of metatile
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0
  
  LDA #$60
  STA $0200, x

  INX
  LDA #$17
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E0
  STA $0200, x

  ; 2nd part of metatile
  INX
  LDA #$60
  STA $0200, x

  INX
  LDA #$18
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E8
  STA $0200, x

  JMP GameEngineLogicDone

LoadFrameOne:
  INC currwagfrm

  ; first part of metatile
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0

  LDA #$60
  STA $0200, x

  INX
  LDA #$1B
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E0
  STA $0200, x

  ; 2nd part of metatile
  INX
  LDA #$60
  STA $0200, x

  INX
  LDA #$1C
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E8
  STA $0200, x

  JMP GameEngineLogicDone
;;;;;;;;;;

;;;;;;;;;;
;;;;;;;;;; HELPER FUNCTIONS HERE
;;;;;;;;;;
;; DisplayText function will draw text sprites using the text
;; strings given using the attributes given. 16-bit pointer to
;; text string should be in textvarLo and textvarHi. 16-bit
;; pointer to attribute should be in textattrLo and textattrHi.
;;
;; For text string:
;; new line = $00, space char needs to be something else, $FF = done
;; * first byte is starting y pos
;; * second byte is starting x pos
;; * third byte is first char of string
;;
;; Note that as this uses sprites you are limited to 8 sprites incl.
;; spaces per line. We need to update this to use background graphics.
;;
;;
;; Sample usage:
;;   LDA #<titlewestwardtext
;;   STA textvarLo
;;   LDA #>titlewestwardtext
;;   STA textvarHi
;;
;;   LDA #<titletextattr
;;   STA textattrLo
;;   LDA #>titletextattr
;;   STA textattrHi
;;   JSR DisplayText
DisplayText:
  LDY #$00
LoadTextParams:
  LDA (textvarLo), y
  STA textypos

  INY
  LDA (textvarLo), y
  STA textxpos

  INY
@loop:
  LDX spritemem

  LDA textypos
  STA $0200, x

  INX
  LDA (textvarLo), y
  STA $0200, x

  INX
  TYA
  PHA
  LDY #$00
  LDA (textattrLo), y
  STA $0200, x
  PLA
  TAY

  INX
  LDA textxpos
  STA $0200, x
  CLC
  ADC #$08
  STA textxpos

  INX
  STX spritemem

  INY
  LDA (textvarLo), y
  BEQ TextInsertLineBreak
  CMP #$FF
  BEQ TextDone
  JMP @loop
TextInsertLineBreak:
  INY
  JMP LoadTextParams
TextDone:
  ; text displayed DONE
  RTS


;;;;;;;;;;;;;;;;
;; LoadPalettes will load your bg and character palettes into memory.
;;
;; Sample usage:
;;   LDA #<palette
;;   STA paletteLo
;;   LDA #>palette
;;   STA palettehi
;;   JSR LoadPalettes
LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDY #$00              ; start out at 0
@loop:
  LDA (paletteLo), y        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INY                   ; X = X + 1
  CPY #$20              ; Compare X to hex $20, decimal 32 - copying 32 bytes = 8 sprites
  BNE @loop             ; Branch to @loop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down
  RTS
;;;;;;;;;;;;;;;
;; ClearBackground will clear the background tiles loaded into memory
ClearBgMemory:
  ; set output address
  LDA #$2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  ; clear VRAM
@Copy1024Bytes:
  LDX #$04
@Copy256Bytes:
  LDY #$00
@Copy1Byte:
  LDA $00
  STA $2007
  INY
  BNE @Copy1Byte
  DEX
  BNE @Copy256Bytes
  RTS

;;;;;;;;;;;;;;;;;;;
GameEngineLogic:  
  LDA gamestate
  ASL A
  TAX

  LDA enginelogic, x
  STA vector

  INX
  LDA enginelogic, x
  STA vector+1

  JMP (vector)

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

  RTS

VBlankWait:
  BIT $2002
  BPL VBlankWait

;;;;;;;;;;;;;;;
ReadController1:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
@loop:
  LDA $4016
  LSR A            ; bit0 -> Carry
  ROL buttons1     ; bit0 <- Carry
  DEX
  BNE @loop
  RTS

;;;;;;;;;;;;;;;
clr_sprite_mem:
  LDX #$00
@loop:
  LDA #$FE
  STA $0200, x
  INX
  CPX #$00
  BNE @loop
  RTS    
;;;;;;;;;;;;;;;
BankSwitch:
  TAX
  LDA bankvalues, x
  STA $8000
  RTS



  .org $E000
  ; set palettes
palette:
  .db $0F,$3D,$19,$09,  $0F,$06,$15,$36,  $0F,$05,$26,$1F,  $0F,$16,$27,$18   ;;background palette
  .db $1F,$17,$28,$30,  $1F,$1C,$2B,$39,  $1F,$06,$15,$36,  $1F,$07,$17,$10   ;;sprite palette

palette_title:
  .db $10,$30,$3F,$28,  $10,$10,$10,$10,  $10,$10,$10,$10,  $10,$10,$10,$10
  .db $10,$17,$28,$30,  $10,$1C,$2B,$39,  $10,$06,$15,$36,  $10,$07,$17,$10

palette_newgame:
  .db $22,$29,$1A,$0F,  $22,$36,$17,$0F,  $22,$1F,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $35,$17,$28,$1F,  $35,$1C,$2B,$39,  $35,$06,$15,$36,  $35,$07,$17,$10   ;;sprite palette

bg_title_screen:
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0D,$0E,$11,$12
  .db $15,$16,$19,$1A,  $1D,$1E,$21,$22,  $25,$26,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0F,$10,$13,$14
  .db $17,$18,$1B,$1C,  $1F,$20,$23,$24,  $14,$27,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $2C,$2D,$30,$14
  .db $14,$33,$35,$36,  $39,$3A,$14,$3D,  $14,$40,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $28,$29,$2A,$2B,  $2E,$2F,$31,$32
  .db $34,$14,$37,$38,  $3B,$3C,$3E,$3F,  $41,$42,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$43,$44,  $47,$48,$4B,$4C,  $4F,$50,$53,$54
  .db $57,$58,$5B,$5C,  $5F,$60,$63,$64,  $67,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$45,$46,  $49,$4A,$4D,$4E,  $51,$52,$55,$56
  .db $59,$5A,$5D,$5E,  $61,$62,$65,$66,  $68,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$69,$6A,  $6C,$6D,$70,$71,  $74,$75,$78,$79
  .db $7C,$7D,$80,$81,  $84,$85,$88,$89,  $8C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$6B,  $6E,$6F,$72,$73,  $76,$77,$7A,$7B
  .db $7E,$7F,$82,$83,  $86,$87,$8A,$8B,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$8D,  $8E,$8F,$90,$91,  $92,$93,$94,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$95,$97,$98,  $9B,$9C,$9F,$A0,  $A3,$A4,$A7,$A8
  .db $AB,$AC,$AF,$B0,  $B3,$B4,$B7,$B8,  $BB,$BC,$BF,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$96,$99,$9A,  $9D,$9E,$A1,$A2,  $A5,$A6,$A9,$AA
  .db $AD,$AE,$B1,$B2,  $B5,$B6,$B9,$BA,  $BD,$BE,$C0,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$C1,$C3,$C4,  $C7,$C8,$CB,$CC,  $CF,$D0,$D3,$D4
  .db $D7,$D8,$DA,$DB,  $DD,$DE,$E0,$E1,  $E4,$E5,$E7,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$C2,$C5,$C6,  $C9,$CA,$CD,$CE,  $D1,$D2,$D5,$D6
  .db $D9,$C5,$C5,$DC,  $DF,$0C,$E2,$E3,  $CA,$E6,$E6,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$E8,$EA,$EB
  .db $EE,$EF,$F2,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$E9,$EC,$ED
  .db $F0,$F1,$F3,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$F4,$F6,$F7
  .db $FA,$FB,$FE,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$F5,$F8,$F9
  .db $FC,$FD,$FF,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C,  $0C,$0C,$0C,$0C
  .db $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00
  .db $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00
  .db $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00
  .db $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00

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

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial


;;;;;;;;;;;;;;  

  .incbin "src\chrblock.chr"   ;includes 8KB graphics file
