MACRO LoadRLEScreen x, nt
  ; Clobbers: A, X
  LDA #<x
  STA pointer+0
  LDA #>x
  STA pointer+1

  LDX #nt

  JSR DecodeRLEScreen
ENDM
;;;;;;;;;;;;;;;
MACRO PaletteLoad pltte
  ; Clobbers: A
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

  ; set up palette for title screen
  LDA #<palette_title
  STA paletteptr
  LDA #>palette_title
  STA paletteptr+1
  JSR LoadPalettes

  LoadRLEScreen bg_title_screen, $00

  ; start playing title music
  LDA #$00
  JSR FamiToneMusicPlay

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
  LDX curlandmark
  LDA landmarkbank, X
  JSR BankSwitch

  PaletteLoad palette_landmark

  ; start playing landmark music
  LDX curlandmark
  LDA landmarksongs, X
  JSR FamiToneMusicPlay

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

DisplayAlphabetScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_alphabet_screen, $00

  ; clear temp vars
  LDA #$00
  STA letterX
  STA numletters

  ; clear name1
  LDX #$08
- DEX
  STA name1, X
  CPX #$00
  BNE -

  LDA #$50
  STA hilitedltr

  ; set up cursor
  LDX #$04
  LDA #MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #$20
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #MIN_X
  STA cursorX
  STA $0200, x

  JMP FinishLoadNewScreen

DisplayPausedScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_paused_screen, $00

  LDA #$00
  STA choice

  ; set up cursor
  LDX #$04
  LDA #PAUSED_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #PAUSED_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #PAUSED_X
  STA cursorX
  STA $0200, x

  ; display calendar date on screen
  ; calendar month
  LDA month
  STA tempcalca
  ASL A
  CLC
  ADC tempcalca
  TAY

  INX
  LDA #PAUSED_CAL_Y
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

  LDA #PAUSED_CAL_Y
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

  LDA #PAUSED_CAL_Y
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

  ; day text
  LDA day
  ASL A
  TAY
  LDA #PAUSED_CAL_Y
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

  LDA #PAUSED_CAL_Y
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

DisplayPaceScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_pace_screen, $00

  LDA #PACE_STEADY
  STA pace

; set up cursor
  LDX #$04
  LDA #PACE_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #PACE_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #PACE_X
  STA cursorX
  STA $0200, x

  JMP FinishLoadNewScreen

DisplayOccupationScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_occupation_screen, $00

  LDA #OCC_FARMER
  STA occupation

; set up cursor
  LDX #$04
  LDA #OCC_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #OCC_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #OCC_X
  STA cursorX
  STA $0200, x

  JMP FinishLoadNewScreen


DisplayRationsScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_rations_screen, $00

  LDA #RATION_BAREBONE
  STA rations

; set up cursor
  LDX #$04
  LDA #PACE_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #PACE_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #PACE_X
  STA cursorX
  STA $0200, x

  JMP FinishLoadNewScreen


DisplayDecisionFortScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_landmark_fort_decision_screen, $00

  LDA #$00
  STA choice

; set up cursor
  LDX #$04
  LDA #CHOOSEFORT_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #CHOOSEFORT_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #CHOOSEFORT_X
  STA cursorX
  STA $0200, x

  JMP FinishLoadNewScreen

DisplayMonthScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_month_screen, $00

  ; default starting month is Mar
  LDA #$03
  STA month

; set up cursor
  LDX #$04
  LDA #MONTH_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #MONTH_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #MONTH_X
  STA cursorX
  STA $0200, x

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
  ; wagon metatile
  LDA #$04
  STA tileoffset

  LDA #OXEN_TOP_Y
  STA tileY
  LDA #OXEN_TOP_X
  CLC
  ADC #$10
  STA tileX

  LDA #<metatile_wagon_frame0
  STA tileptr
  LDA #>metatile_wagon_frame0
  STA tileptr+1

  JSR DrawMetatile

  ; load oxen
  ; oxen metatile
  LDA #$14
  STA tileoffset

  LDA #OXEN_TOP_Y
  STA tileY
  LDA #OXEN_TOP_X
  STA tileX

  LDA #<metatile_oxen_frame0
  STA tileptr
  LDA #>metatile_oxen_frame0
  STA tileptr+1

  JSR DrawMetatile

  ; load landmark
  ; landmark metatile
  LDA #$78
  STA tileoffset

  LDA #OXEN_TOP_Y
  STA tileY
  LDA #$20
  STA tileX

  LDA #<metatile_landmark_river
  STA tileptr
  LDA #>metatile_landmark_river
  STA tileptr+1

  JSR DrawMetatile

  ; set current wagon frame displayed (for animation)
  LDA #$00
  STA currwagfrm

  ; set the mileage remaining to the next landmark
  ; however, we should only do this if miremaining = 0
  ; otherwise, it means we're coming back from pause
  ;
  ; I found that the way I was doing it, loading the miremaining
  ; every time we called this routine, meant that if I paused the
  ; game, coming back from pause meant this routine was called and
  ; it reset miremaining to the original amount for the next landmark.
  LDA miremaining
  BNE +
  LDX curlandmark
  LDA landmarkdist, X
  STA miremaining
+
  JSR UpdateWeather

  ; update status bar
  LDX #$24
  JSR UpdateStatusIcons

  JMP FinishLoadNewScreen