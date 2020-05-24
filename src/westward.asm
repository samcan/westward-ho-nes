  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring
  

;;;;;;;;;;;;;;;

;; DECLARE SOME VARIABLES HERE
  .rsset $0000  ;;start variables at ram location 0
  
; initialize variables here
gamestate	.rs 1		; current game state
buttons1    .rs 1
buttons2    .rs 1
spritemem   .rs 1
textxpos    .rs 1
textypos	.rs 1
textlen		.rs 1


;; DECLARE CONSTANTS HERE
; game state constants
STATETITLE		= $00
STATENEWGAME	= $01
STATETRAVELING	= $02
STATELANDMARK	= $03
STATESTORE		= $04
STATEPAUSED		= $05
STATEENDGAME	= $06

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

clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x
  INX
  BNE clrmem
   
  JSR VBlankWait		; Second wait for vblank, PPU is ready after this

LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDX #$00              ; start out at 0
LoadPalettesLoop:
  LDA palette, x        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$20              ; Compare X to hex $20, decimal 32 - copying 32 bytes = 8 sprites
  BNE LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down


;;;Set some initial stats in vars
  JSR SetInitialState

              
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

Forever:
  JMP Forever     ;jump back to Forever, infinite loop, waiting for NMI
  
SetInitialState:
  LDA #STATETITLE
  STA gamestate
  
  RTS

VBlankWait:
  BIT $2002
  BPL VBlankWait
  RTS


NMI:
  LDA #$00
  STA $2003       ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014       ; set the high byte (02) of the RAM address, start the transfer

  JSR DrawScore

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
  JSR ReadController2  ;;get the current button data for player 2
  
GameEngine:  
  LDA gamestate
  CMP #STATETITLE
  BEQ EngineTitle		;; game is displaying title screen
  
  LDA gamestate
  CMP #STATENEWGAME
  BNE NotDisplayingNewGame		;; game is displaying new game screen
  JMP EngineNewGame
NotDisplayingNewGame:
    
  ;LDA gamestate
  ;CMP #STATEGAMEOVER
  ;BEQ EngineGameOver  ;;game is displaying ending screen
  
  ;LDA gamestate
  ;CMP #STATEPLAYING
  ;BEQ EnginePlaying   ;;game is playing
GameEngineDone:  
  
  JSR UpdateSprites  ;;set ball/paddle sprites from positions

  RTI             ; return from interrupt
 
 
 
 
;;;;;;;;
; display title screen, check for Start button to be pressed to exit
; title screen state
EngineTitle:
  LDX #$00
  STX spritemem
  
  LDA #$40
  STA textypos
  
  LDA #$60
  STA textxpos
  
  LDY titlewestwardtext
  STY textlen
  LDY #$01
EngineTopTitleTextLoop:
  LDX spritemem
  
  LDA textypos
  STA $0200, x
  
  INX
  LDA titlewestwardtext, y
  STA $0200, x
  
  INX
  LDA titletextattr
  STA $0200, x
  
  INX
  LDA textxpos
  STA $0200, x
  CLC
  ADC #$08
  STA textxpos
  
  INX
  STX spritemem
  
  INY
  CPY textlen
  BCC EngineTopTitleTextLoop
  BEQ EngineTopTitleTextLoop
  ; first line of title text displayed DONE
  
  LDA textypos
  CLC
  ADC #$10
  STA textypos
  
  LDA #$76
  STA textxpos
  
  LDY titlehotext
  STY textlen
  LDY #$01
EngineBottomTitleTextLoop:
  LDX spritemem
  
  LDA textypos
  STA $0200, x
  
  INX
  LDA titlehotext, y
  STA $0200, x
  
  INX
  LDA titletextattr
  STA $0200, x
  
  INX
  LDA textxpos
  STA $0200, x
  CLC
  ADC #$08
  STA textxpos
  
  INX
  STX spritemem
  
  INY
  CPY textlen
  BCC EngineBottomTitleTextLoop
  BEQ EngineBottomTitleTextLoop
  
  
  
  JSR ReadController1
  LDA buttons1
  AND #BTN_START
  BNE EndTitleState
  JMP EngineTitle
EndTitleState:
  ; user is exiting title state, switch to new game state
  LDA #STATENEWGAME
  STA gamestate
  JMP GameEngineDone

;;;;;;;;; 

EngineNewGame:
  JSR ReadController1
  LDA buttons1
  AND #BTN_SELECT		; todo change to start once more function implemented
  BNE EndNewGameState
  JMP EngineNewGame
EndNewGameState:
  ; user is exiting new game state, switch to general store state
  LDA #STATESTORE
  STA gamestate
  JMP GameEngineDone



EngineGameOver:
  JMP GameEngineDone
 
;;;;;;;;;;;
 
EnginePlaying:
  ;;update calculations here
  JMP GameEngineDone
 
 
 
 
UpdateSprites:
  ;;update sprites here
  RTS
 
 
DrawScore:
  ;;draw score on screen using background tiles
  ;;or using many sprites
  RTS
 
 
 
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
  
ReadController2:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
ReadController2Loop:
  LDA $4017
  LSR A            ; bit0 -> Carry
  ROL buttons2     ; bit0 <- Carry
  DEX
  BNE ReadController2Loop
  RTS  
  
  
    
        
;;;;;;;;;;;;;;  
  
  
  
  .bank 1
  .org $E000
  ; set palettes
palette:
  .db $22,$29,$1A,$0F,  $22,$36,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $22,$1C,$15,$0F,  $22,$02,$38,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

titlewestwardtext:
  .db $08,$66,$54,$62,$63,$66,$50,$61,$53
titlehotext:
  .db $03,$57,$5E,$31
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
