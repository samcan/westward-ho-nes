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
MACRO DisplayNumberTens sprOffset, num, startX, startY, attr
  ; Clobbers: A, X, Y
  ; Returns: X for next sprite offset
  LDX sprOffset

@Tens:
  ; we need to display the tens if there's a value greater than 0
  ; grab the tens value
  LDA num
  AND #%11110000
  LSR A
  LSR A
  LSR A
  LSR A
  TAY

  BEQ @TensZero
@TensNotZero:
  TYA
  CLC
  ADC #$44
  TAY						; store in Y for safe-keeping
  JMP @DisplayTens
@TensZero:
  LDA #$00					; set tile index of $00 as we want blank space
  TAY
@DisplayTens:
  LDA #startY
  STA $0200, x
  INX
  TYA						; transfer tile index back off of Y
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $08
  STA $0200, x
  INX

@DisplayOnes:
  ; now we'll display ones, which are easy because we always display the
  ; ones place
  LDA num
  AND #%00001111
  CLC
  ADC #$44
  PHA
  LDA #startY
  STA $0200, x
  INX
  PLA
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $10
  STA $0200, x
  INX
  STX sprOffset
ENDM
;;;;;;;;;;;;;;;
MACRO DisplayNumberHundreds sprOffset, num1, num, startX, startY, attr
  ; Clobbers: A, X, Y
  ; Returns: X for next sprite offset
  LDX sprOffset
  LDA num1					; get the hundreds value
  BEQ @SkipHundreds

@LoadHundreds:
  CLC
  ADC #$44					; adds $44 to get the tile number we need
  TAY						; transfer to Y for safe-keeping
  STA hundsshown			; store non-zero value in hundsshown
  JMP @DisplayHundreds

@SkipHundreds:
  LDA #$00					; load blank tile for hundreds
  TAY						; transfer to Y for safe-keeping
  STA hundsshown			; store zero value in hundsshown

@DisplayHundreds:
  LDA #startY
  STA $0200, x
  INX
  TYA						; transfer tile index back off of Y
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX
  STA $0200, x
  INX

@Tens:
  ; we need to display the tens if there's a value greater than 0 or if
  ; the value in the hundreds place is greater than 0

  ; grab the tens value
  LDA num
  AND #%11110000
  LSR A
  LSR A
  LSR A
  LSR A
  TAY

  BEQ @TensZero
@TensNotZero:
  TYA
  CLC
  ADC #$44
  TAY						; store in Y for safe-keeping
  JMP @DisplayTens
@TensZero:
  ; is the hundreds place shown?
  LDA hundsshown
  BNE @TensNotZero
  LDA #$00					; set tile index of $00 as we want blank space
  TAY
@DisplayTens:
  LDA #startY
  STA $0200, x
  INX
  TYA						; transfer tile index back off of Y
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $08
  STA $0200, x
  INX

@DisplayOnes:
  ; now we'll display ones, which are easy because we always display the
  ; ones place
  LDA num
  AND #%00001111
  CLC
  ADC #$44
  PHA
  LDA #startY
  STA $0200, x
  INX
  PLA
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $10
  STA $0200, x
  INX
  STX sprOffset
ENDM
;;;;;;;;;;;;;;;
MACRO DisplayNumberThousands sprOffset, bcd3, bcd2, bcd1, bcd, startX, startY, attr
  ; Clobbers: A, X, Y, thousshown, hundsshown
  ; Returns: X - next sprite offset
  LDX sprOffset

  LDA #$00
  STA thousshown
  STA hundsshown

  ; display thousands
  LDA bcd3
  BEQ @ThousandsNotShown
  JMP @ThousandsShown
@ThousandsNotShown:
  LDA #$00
  TAY
  JMP @ContThousands
@ThousandsShown:
  CLC
  ADC #$44
  TAY
  LDA #$01
  STA thousshown
@ContThousands:
  LDA #startY
  STA $0200, x
  INX
  TYA
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX
  STA $0200, x
  INX

@DisplayHundreds:
  ; display hundreds
  LDA bcd2
  BEQ @HundredsZero
  JMP @HundredsShown
@HundredsZero:
  LDA thousshown
  BEQ @HundredsNotShown
  JMP @HundredsShown
@HundredsNotShown:
  LDA #$00
  TAY
  JMP @ContHundreds
@HundredsShown:
  LDA #$01
  STA hundsshown
  LDA bcd2
  CLC
  ADC #$44
  TAY
@ContHundreds:
  LDA #startY
  STA $0200, x
  INX
  TYA
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $08
  STA $0200, x
  INX

  ; display tens
  LDA startY
  STA $0200, x
  INX
  LDA bcd1
  BEQ @TensZero
@TensNotZero:
  LDA bcd1
  CLC
  ADC #$44
  JMP @ContTens
@TensZero:
  LDA thousshown
  ORA hundsshown
  BNE @TensNotZero
  LDA #$00
@ContTens:
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $10
  STA $0200, x
  INX
  ; now we'll display ones, which are easy because we always display the
  ; ones place
  LDA bcd
  CLC
  ADC #$44
  PHA
  LDA #startY
  STA $0200, x
  INX
  PLA
  STA $0200, x
  INX
  LDA #attr
  STA $0200, x
  INX
  LDA #startX + $18
  STA $0200, x
  INX
  STX sprOffset
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

  .ifdef AUDIO_YES
  ; start playing title music
  LDA #TITLE_SONG
  JSR FamiToneMusicPlay
  .endif

  JMP FinishLoadNewScreen



DisplayColumbiaRiverScreen:
  LDA #$01
  JSR BankSwitch

  ; set up palette
  LDA #<palette
  STA paletteptr
  LDA #>palette
  STA paletteptr+1
  JSR LoadPalettes

  LoadRLEScreen bg_columbia_river_screen, $00

  JMP FinishLoadNewScreen



DisplayNewGameScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  ; load nametable 0
  LoadRLEScreen bg_instruction_screen, $00

  JMP FinishLoadNewScreen

DisplayStoreScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  ; load nametable 0
  LoadRLEScreen bg_store_screen, $00

  LDA #$00
  STA choice
  STA storeoxen
  STA storefood
  STA storeclth
  STA storebllt
  STA storepart

DrawCursor:
  ; set up cursor
  LDX #$00
  LDA #CASH_START_Y + $18
  STA cursorY
  STA $0200, X

  INX
  LDA #OCC_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #CASH_START_X - $54
  STA cursorX
  STA $0200, x

  ; draw cash start
DrawCashStart:
  LDA cash
  STA bcdNum
  LDA cash+1
  STA bcdNum+1
  JSR SixteenBitHexToDec

  LDA #$04
  STA temp
  DisplayNumberThousands temp, bcdResult+3, bcdResult+2, bcdResult+1, bcdResult, #CASH_START_X, #CASH_START_Y, %00000001

DrawPrices:
  ; oxen
  LDA curlandmark
  ASL A
  ASL A
  TAX
  LDA storeprices, X
  STA htd_in
  JSR EightBitHexToDec

  LDA #$14
  STA temp
  DisplayNumberHundreds, temp, htd_out+1, htd_out, #CASH_START_X + $08, #CASH_START_Y + $10, %00000001

  ; food
  LDA curlandmark
  ASL A
  ASL A
  CLC
  ADC #3
  TAX
  LDA storeprices, X
  STA htd_in
  JSR EightBitHexToDec

  LDA #$20
  STA temp
  DisplayNumberHundreds, temp, htd_out+1, htd_out, #CASH_START_X + $08, #CASH_START_Y + $28, %00000001

  ; clothes
  LDA curlandmark
  ASL A
  ASL A
  CLC
  ADC #1
  TAX
  LDA storeprices, X
  STA htd_in
  JSR EightBitHexToDec
  LDA #$2C
  STA temp
  DisplayNumberHundreds, temp, htd_out+1, htd_out, #CASH_START_X + $08, #CASH_START_Y + $40, %00000001

  ; bullets
  LDA curlandmark
  ASL A
  ASL A
  CLC
  ADC #2
  TAX
  LDA storeprices, X
  STA htd_in
  JSR EightBitHexToDec
  LDA #$38
  STA temp
  DisplayNumberHundreds, temp, htd_out+1, htd_out, #CASH_START_X + $08, #CASH_START_Y + $58, %00000001

  ; spare parts
  LDA curlandmark
  ASL A
  ASL A
  CLC
  ADC #1
  TAX
  LDA storeprices, X
  STA htd_in
  JSR EightBitHexToDec
  LDA #$44
  STA temp
  DisplayNumberHundreds, temp, htd_out+1, htd_out, #CASH_START_X + $08, #CASH_START_Y + $70, %00000001

  JMP FinishLoadNewScreen

DisplayLandmarkScreen:
  LDX curlandmark
  LDA landmarkbank, X
  JSR BankSwitch

  PaletteLoad palette_landmark

  .ifdef AUDIO_YES
  ; start playing landmark music
  LDX curlandmark
  LDA landmarksongs, X
  JSR FamiToneMusicPlay
  .endif

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



DisplayDecisionDallesScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_landmark_dalles_decision_screen, $00

  LDA #$00
  STA choice

; set up cursor
  LDX #$04
  LDA #CHOOSEDALLES_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #CHOOSEDALLES_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #CHOOSEDALLES_X
  STA cursorX
  STA $0200, x

  JMP FinishLoadNewScreen




DisplayDecisionBlueMountainsScreen:
  LDA #$01
  JSR BankSwitch

  PaletteLoad palette

  LoadRLEScreen bg_landmark_blue_mtn_decision_screen, $00

  LDA #$00
  STA choice

; set up cursor
  LDX #$04
  LDA #CHOOSEBLUE_MIN_Y
  STA cursorY
  STA $0200, X

  INX
  LDA #CHOOSEBLUE_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA #CHOOSEBLUE_X
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