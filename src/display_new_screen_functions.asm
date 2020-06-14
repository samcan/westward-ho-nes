MACRO LoadRLEScreen x, nt
  LDA #<x
  STA pointer+0
  LDA #>x
  STA pointer+1

  LDX #nt

  JSR DecodeRLEScreen
ENDM
;;;;;;;;;;;;;;;
MACRO PaletteLoad pltte
  LDA #<pltte
  STA paletteptr
  LDA #>pltte
  STA paletteptr+1
  JSR LoadPalettes
ENDM
;;;;;;;;;;;;;;;
DisplayTitleScreen:
  LDA #$00
  JSR BankSwitch
  LoadRLEScreen bg_title_screen, $00
  JMP FinishLoadNewScreen

DisplayNewGameScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  ; load nametable 0
  LoadRLEScreen bg_instruction_screen, $00

  JMP FinishLoadNewScreen

DisplayStoreScreen:
  JMP FinishLoadNewScreen

DisplayLandmarkScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  ; load background into nametable 0
  LDA curlandmark
  ASL A
  TAX

  ; load nametable 0
  LDA landmarkdisplay, x
  STA pointer+0
  INX
  LDA landmarkdisplay, x
  STA pointer+1
  LDX #$00
  JSR DecodeRLEScreen

  ; display calendar date on screen
  ; calendar month
  LDA month
  STA tempcalca
  ASL A
  CLC
  ADC tempcalca
  TAY

  LDA #LANDMARK_CAL_Y
  STA $0200, x
  INX
  LDA monthtext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$58
  STA $0200, x
  INX
  INY

  LDA #LANDMARK_CAL_Y
  STA $0200, x
  INX
  LDA monthtext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$60
  STA $0200, x
  INX
  INY

  LDA #LANDMARK_CAL_Y
  STA $0200, x
  INX
  LDA monthtext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$68
  STA $0200, x
  INX
  STX spritemem

  ; day text
  LDA day
  ASL A
  TAY
  LDA #LANDMARK_CAL_Y
  STA $0200, x
  INX
  LDA daytext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$78
  STA $0200, x
  INX
  INY

  LDA #LANDMARK_CAL_Y
  STA $0200, x
  INX
  LDA daytext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$80
  STA $0200, x
  INX
  INY

  JMP FinishLoadNewScreen
DisplayTravelingScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  ; load background into both of our nametables.
  ; we also need to load the landmark into the nametable as well, but that
  ; will come later.

  ; load nametable 0
  LoadRLEScreen bg_sprite0_traveling_screen, $00

  ; load nametable 1
  LoadRLEScreen bg_blank_traveling_screen, $01

  ; load sprite 0 for status bar
  LDX #$00
  LDA #$36
  STA $0200, x

  INX
  LDA #$24
  STA $0200, x

  INX
  LDA #%00100011
  STA $0200, x

  INX
  LDA #$31
  STA $0200, x
  ; end loading sprite 0 for status bar

  LDA #FRAMECOUNT
  STA currframe
  
  LDA #FRAMECOUNT_DAY
  STA currframedy

  ; load sprites
  ; load wagon
  LDX #$00
@loop_wagon:
  LDA traveling_wagon, x
  STA $0204, x
  INX
  CPX #$10
  BNE @loop_wagon

  ; load oxen
  LDX #$00
@loop_oxen:
  LDA traveling_oxen, x
  STA $0214, x
  INX
  CPX #$10
  BNE @loop_oxen

  TXA
  STA spritemem

  ; set current wagon frame displayed (for animation)
  LDA #$00
  STA currwagfrm

  LDX curlandmark
  LDA landmarkdist, X
  STA miremaining

  ; update status bar
  LDX #$24
  JSR UpdateStatusIcons

  JMP FinishLoadNewScreen