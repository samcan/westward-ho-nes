DisplayTitleScreen:
  LDA #<bg_title_screen
  STA pointer+0
  LDA #>bg_title_screen
  STA pointer+1

  LDX #$00

  JSR DecodeRLEScreen

  JMP FinishLoadNewScreen

DisplayNewGameScreen:
  LDA #$01
  JSR BankSwitch

  LDA #<palette
  STA paletteLo
  LDA #>palette
  STA paletteHi
  JSR LoadPalettes

  ; load nametable 0
  LDA #<bg_instruction_screen
  STA pointer+0
  LDA #>bg_instruction_screen
  STA pointer+1
  LDX #$00
  JSR DecodeRLEScreen

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
  LDA #<bg_sprite0_traveling_screen
  STA pointer+0
  LDA #>bg_sprite0_traveling_screen
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

  ; set current wagon frame displayed (for animation)
  LDA #$00
  STA currwagfrm

  LDX curlandmark
  LDA landmarkdist, X
  STA miremaining

  JMP FinishLoadNewScreen