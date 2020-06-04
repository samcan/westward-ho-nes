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