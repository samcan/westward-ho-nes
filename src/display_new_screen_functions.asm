MACRO DefineTravelingBackground x
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #>x
  STA $2006             ; write the high byte
  LDA #<x
  STA $2006             ; write the low byte
  ; LDX #$04

  ; 4 rows of blank (32 tiles per row)
  LDA #$00
  LDX #$80
@loop
  STA $2007
  DEX
  BNE @loop

  LDX #$10
@loop2
  LDA #$92
  STA $2007
  LDA #$93
  STA $2007
  DEX
  BNE @loop2

  LDX #$10
@loop3
  LDA #$A2
  STA $2007
  LDA #$A3
  STA $2007
  DEX
  BNE @loop3

  ; load background attributes
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$B0
  LDA #$00
@attrLoop:
  STA $2007
  DEX
  BNE @attrLoop
ENDM


DisplayTitleScreen:
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

  ; ; copy screen to VRAM
  ; Decode RLE
  LDY #$00
@big:
  ; get count and byte
  ; get count (has to be LDA rather than LDX)
  LDA (pointer),y
  TAX
  CPX #$00
  BEQ @done
  INY
  ; get byte
  LDA (pointer), y
@loop:
  STA $2007
  DEX
  BNE @loop
  INY
  BNE @big
  INC pointer+1
  JMP @big
@done:
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
  LDA #$01
  JSR BankSwitch

  LDA #<palette
  STA paletteLo
  LDA #>palette
  STA paletteHi
  JSR LoadPalettes

  ; load background into both of our nametables.
  ; we also need to load the landmark into the nametable as well, but that
  ; will come later.
  DefineTravelingBackground $2000
  DefineTravelingBackground $2400

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

  ; set current wagon frame displayed (for animation)
  LDA #$00
  STA currwagfrm

  JMP FinishLoadNewScreen