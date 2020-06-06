DisplayTitleScreen:
  LDA #<bg_title_screen
  STA pointer+0
  LDA #>bg_title_screen
  STA pointer+1

  LDX #$00

  JSR DecodeRLEScreen

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

  ; load nametable 0
  LDA #<bg_blank_traveling_screen
  STA pointer+0
  LDA #>bg_blank_traveling_screen
  STA pointer+1
  LDX #$00
  JSR DecodeRLEScreen

  ; load nametable 1
  LDA #<bg_blank_traveling_screen
  STA pointer+0
  LDA #>bg_blank_traveling_screen
  STA pointer+1
  LDX #$01
  JSR DecodeRLEScreen

  LDA #FRAMECOUNT
  STA currframe

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