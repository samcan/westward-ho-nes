  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring
  

;;;;;;;;;;;;;;;

;; DECLARE VARIABLES HERE
  .rsset $0000  ;;start variables at ram location 0
  
gamestate	.rs 1		; current game state
newgmstate	.rs 1		; new game state
buttons1    .rs 1		; player 1 controller buttons pressed
spritemem   .rs 1
textxpos    .rs 1
textypos	.rs 1
textvarLo	.rs 1
textvarHi	.rs 1
textattrLo	.rs 1
textattrHi	.rs 1
paletteLo	.rs 1		; palette address, low-byte
paletteHi	.rs 1		; palette address, high-byte
currframe	.rs 1
currwagfrm	.rs 1
vector		.rs 2


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

  .bank 0
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

  LDA #LOW(palette)
  STA paletteLo
  LDA #HIGH(palette)
  STA paletteHi
  JSR LoadPalettes


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
  JMP [vector]

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
  LDX #$04				; start text display using sprite 1 rather than
						; sprite 0
  STX spritemem
  
  LDA #LOW(titlewestwardtext)
  STA textvarLo
  LDA #HIGH(titlewestwardtext)
  STA textvarHi
  
  LDA #LOW(titletextattr)
  STA textattrLo
  LDA #HIGH(titletextattr)
  STA textattrHi
  JSR DisplayText
  
  JMP FinishLoadNewScreen
  
DisplayNewGameScreen:
  LDA #LOW(palette_newgame)
  STA paletteLo
  LDA #HIGH(palette_newgame)
  STA paletteHi
  JSR LoadPalettes
  
  JMP FinishLoadNewScreen
  
DisplayStoreScreen:
  JMP FinishLoadNewScreen
  
DisplayTravelingScreen:
  LDA #LOW(palette)
  STA paletteLo
  LDA #HIGH(palette)
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
 
 ;;;;;;;
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
;;   LDA #LOW(titlewestwardtext)
;;   STA textvarLo
;;   LDA #HIGH(titlewestwardtext)
;;   STA textvarHi
;;
;;   LDA #LOW(titletextattr)
;;   STA textattrLo
;;   LDA #HIGH(titletextattr)
;;   STA textattrHi
;;   JSR DisplayText
DisplayText:
  LDY #$00
LoadTextParams:
  LDA [textvarLo], y
  STA textypos
  
  INY
  LDA [textvarLo], y
  STA textxpos
  
  INY
TextLoop:
  LDX spritemem
  
  LDA textypos
  STA $0200, x
  
  INX
  LDA [textvarLo], y
  STA $0200, x
  
  INX
  TYA
  PHA
  LDY #$00
  LDA [textattrLo], y
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
  LDA [textvarLo], y
  BEQ TextInsertLineBreak
  CMP #$FF
  BEQ TextDone
  JMP TextLoop
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
;;   LDA #LOW(palette)
;;   STA paletteLo
;;   LDA #HIGH(palette)
;;   STA palettehi
;;   JSR LoadPalettes
LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDY #$00              ; start out at 0
LoadPalettesLoop:
  LDA [paletteLo], y        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INY                   ; X = X + 1
  CPY #$20              ; Compare X to hex $20, decimal 32 - copying 32 bytes = 8 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down
  RTS

;;;;;;;;;;;;;;;;;;;
GameEngineLogic:  
  LDA gamestate
  CMP #STATETITLE
  BNE NotDisplayingTitle
  JMP EngineLogicTitle  ;; game is displaying title screen
NotDisplayingTitle:
  LDA gamestate
  CMP #STATENEWGAME
  BNE NotDisplayingNewGame		;; game is displaying new game screen
  JMP EngineLogicNewGame
NotDisplayingNewGame:
  LDA gamestate
  CMP #STATESTORE
  BNE NotDisplayingStore        ;; game is displaying store screen
  JMP EngineLogicStore
NotDisplayingStore:
  LDA gamestate
  CMP #STATETRAVELING
  BNE NotDisplayingTraveling
  JMP EngineLogicTraveling
NotDisplayingTraveling:

  JMP GameEngineLogicDone

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

;;;;;;;;;;;;;;
VBlankWait:
  BIT $2002
  BPL VBlankWait
  RTS

;;;;;;;;;;;;;;;
ReadController1:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
ReadController1Loop:
  LDA $4016
  LSR A            ; bit0 -> Carry
  ROL buttons1     ; bit0 <- Carry
  DEX
  BNE ReadController1Loop
  RTS

;;;;;;;;;;;;;;;
clr_sprite_mem:
  LDX #$00
clr_sprite_mem_loop:
  LDA #$FE
  STA $0200, x
  INX
  CPX #$00
  BNE clr_sprite_mem_loop
  RTS    
;;;;;;;;;;;;;;;



  .bank 1
  .org $E000
  ; set palettes
palette:
  .db $0F,$3D,$19,$09,  $0F,$06,$15,$36,  $0F,$05,$26,$1F,  $0F,$16,$27,$18   ;;background palette
  .db $1F,$17,$28,$30,  $1F,$1C,$2B,$39,  $1F,$06,$15,$36,  $1F,$07,$17,$10   ;;sprite palette

palette_newgame:
  .db $22,$29,$1A,$0F,  $22,$36,$17,$0F,  $22,$1F,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $35,$17,$28,$1F,  $35,$1C,$2B,$39,  $35,$06,$15,$36,  $35,$07,$17,$10   ;;sprite palette


; points to appropriate 'load-new-screen' functions so they can get called
; by NMI when it's time to load a new screen
screen:
  .dw DisplayTitleScreen, DisplayNewGameScreen, DisplayTravelingScreen
  .dw $0000, DisplayStoreScreen

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

  .bank 2
  .org $0000
  .incbin "src\chrblock.chr"   ;includes 8KB graphics file
