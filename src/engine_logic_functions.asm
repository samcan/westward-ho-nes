MACRO MultiplyPercentageDistance x,y,output
  ;; Clobbers: A
  LDA y
  CMP #$03			; 100%
  BCS @OneHundredPercent
  CMP #$02			; 75%
  BEQ @SeventyFivePercent
  ; should be 50% if it's made it to here
@FiftyPercent:
  LDA x
  LSR A
  STA output
  JMP @Done

@SeventyFivePercent:
  LDA x
  LSR A
  LSR A
  STA output
  ROL A
  CLC
  ADC output
  STA output
  JMP @Done

@OneHundredPercent:
  LDA x
  STA output
@Done:
ENDM
;;;;;;;;;;;;;;;;;;;
MACRO CheckForButton btn,jumpto,elsejumpto
  ; Checks for button btn to have been pressed on player 1's
  ; controller. Once it has, jump to label given as jumpto.
  ; Otherwise, jump to label given as elsejumpto.
  ;
  ; Clobbers: A
  LDA buttons1
  AND btn
  BEQ +
  JMP jumpto
+ JMP elsejumpto
ENDM
;;;;;;;;;;;;;;;;;;;
MACRO UpdateStoreDisplayRegular sprOffset,item,peritempr,itempr,firstX,firstY,secondX,secondY,firstAttr,secondAttr
  LDA peritempr
  PHA
  LDA item
  STA htd_in
  JSR EightBitHexToDec
  LDA #sprOffset
  STA temp
  DisplayNumberHundreds temp, htd_out+1, htd_out, firstX, firstY, firstAttr

  ; display total price
  PLA ; transfers peritempr to Y from stack
  TAY
  LDA item

  JSR Multiply
  STY bcdNum+1
  STA bcdNum
  LDA bcdNum
  STA itempr
  LDA bcdNum+1
  STA itempr+1

  JSR SixteenBitHexToDec
  LDA #sprOffset + $0C
  STA temp
  DisplayNumberThousands temp, bcdResult+3, bcdResult+2, bcdResult+1, bcdResult, secondX, secondY, secondAttr
ENDM
;;;;;;;;;;;;;;;;;;;
MACRO DrawName name,idx,nameidx,startX,startY
  LDA idx
  CMP nameidx
  BEQ +
  ; set value in hilitedname that we don't need to highlight this name
  LDA #$00
  STA hilitedname
  JMP ++

+ ; set value in hilitedname that we need to highlight this name
  LDA #$01
  STA hilitedname

++
  LDA #<name
  STA pointer
  LDA #>name
  STA pointer+1
  LDA startX
  LDY startY
  JSR DrawNameSR
ENDM

DrawNameSR:
  ; set X = sprite offset
  ; set Y = start Y
  ; set A = start X
  ; set pointer to 16-bit address of name var
  ; clobbers A, X, Y, temp
  ; returns X = next sprite offset

  STA letterX
  TYA
  PHA

  LDY #$00
@lp:
  PLA
  STA $0200, X
  PHA

  INX
  STX temp
  ;LDX identity_table, Y
  LDA (pointer), Y
  LDX temp
  STA $0200, X

  INX
  LDA hilitedname
  BEQ @nohilit
  LDA #%00000001
  JMP @cont
@nohilit:
  LDA #%00000000
@cont:
  STA $0200, X

  INX
  LDA letterX
  STA $0200, X
  CLC
  ADC #$10
  STA letterX

  INY
  INX
  CPY #MAX_LETTER_NAME
  BNE @lp
  PLA
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
;;;;;;;;
;;;;;;;; ENGINE LOGIC SUBROUTINES
;;;;;;;;
; deal with title screen input; check for Start button to be pressed to exit
; title screen state
EngineLogicTitle:
  CheckForButton #BTN_START, EndTitleState, GameEngineLogicDone
EndTitleState:
  ; user is exiting title state, switch to new game state

  ; stop music
  JSR FamiToneMusicStop

  LDA #STATENEWGAME
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicColumbiaRiver:
  CheckForButton #BTN_START, EndColumbiaRiverState, GameEngineLogicDone
EndColumbiaRiverState:
  ; user is exiting state, switch to Willamette Valley landmark state
  LDA #$10
  STA curlandmark
  LDA #STATELANDMARK
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicNewGame:
  CheckForButton #BTN_START, EndNewGameState, +

+ JMP GameEngineLogicDone
EndNewGameState:
  ; user is exiting new game state, switch to alphabet screen to enter name
  LDA #STATEALPHABET
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
SetCurName:
  LDA curnameidx
  BEQ @NameZero
  CMP #$01
  BEQ @NameOne
  CMP #$02
  BEQ @NameTwo
  CMP #$03
  BEQ @NameThree
  CMP #MAX_NAMES
  BEQ @NameFour

@NameZero:
  LDA #<name0
  STA curname
  LDA #>name0
  STA curname+1
  RTS

@NameOne:
  LDA #<name1
  STA curname
  LDA #>name1
  STA curname+1
  RTS

@NameTwo:
  LDA #<name2
  STA curname
  LDA #>name2
  STA curname+1
  RTS

@NameThree:
  LDA #<name3
  STA curname
  LDA #>name3
  STA curname+1
  RTS

@NameFour:
  LDA #<name4
  STA curname
  LDA #>name4
  STA curname+1
  RTS
;;;;;;;;;
EngineLogicAlphabet:
  JSR SetCurName

  ; move cursor around
  CheckForButton #BTN_UPARROW, MoveCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveCursorDown, +
+ CheckForButton #BTN_LEFTARROW, MoveCursorLeft, +
+ CheckForButton #BTN_RIGHTARROW, MoveCursorRight, +
+ CheckForButton #BTN_A, EngineLogicAlphabetSelectLetter, +
+ CheckForButton #BTN_B, EngineLogicAlphabetEraseLetter, +

+ LDA changed
  CMP #$01
  BEQ +
  JMP GameEngineLogicDone
+ JMP UpdateCursorLetterSprites

;;;;;;;;;
GameEngineLogicDoneShortcutOne:
  ; think of some other way I can do this that maybe doesn't look so hacky
  JMP GameEngineLogicDone
;;;;;;;;;
EngineLogicAlphabetSelectLetter:
  LDA hilitedltr
  CMP #$6B					; user selected OK?
  BEQ EngineLogicAlphabetEndState
  CMP #$6A					; user selected backspace
  BEQ EngineLogicAlphabetEraseLetter
  LDX numletters
  CPX #$08
  BEQ EngineLogicAlphabetDoneSelecting
  LDY identity_table, X
  STA (curname), Y
  INC numletters
  JMP EngineLogicAlphabetDoneSelecting
EngineLogicAlphabetEraseLetter:
  ; if the user selects to erase when there's no letters for a given name,
  ; we want to move to the previous name and erase that letter. Unless they're
  ; on name0, in which case we should do nothing.
  LDA numletters
  BEQ @CheckOnNameZero

@ContErase:
  LDA #$00
  DEC numletters
  LDX numletters
  CPX #$00
  BMI @Adjust
  JMP @StoreValue
@CheckOnNameZero:
  LDA curnameidx
  BEQ GameEngineLogicDoneShortcutOne
  ; we're on name0, so do nothing

  ; else, move to previous name. This means we need to iterate through this new
  ; name to figure out the last letter so we can appropriately set numletters
  DEC curnameidx
  JSR SetCurName
  LDY #$00
@lp:
  LDA (curname), Y
  INY
  CMP #$00
  BNE @lp
  DEY
  STY numletters
  ; set changed flag to true so screen is redrawn
  LDA #$01
  STA changed
  .ifdef IMMEDIATELY_START_ERASING
  JMP EngineLogicAlphabetEraseLetter
  .endif
  .ifndef IMMEDIATELY_START_ERASING
  JMP GameEngineLogicDone
  .endif
@Adjust:
  LDX #$00
  STX numletters
@StoreValue:
  LDY identity_table, X
  STA (curname), Y
EngineLogicAlphabetDoneSelecting:
  JMP UpdateCursorLetterSprites
EngineLogicAlphabetEndState:
  LDA curnameidx
  CMP #MAX_NAMES
  BNE +
  JMP EndAlphabetState
+ INC curnameidx
  LDA #$00
  STA numletters
  ; set changed flag to true
  LDA #$01
  STA changed
  JMP GameEngineLogicDone



MoveCursorUp:
  LDA hilitedltr
  SEC
  SBC #$07
  STA hilitedltr

  LDA cursorY
  SEC
  SBC #$10
  ; minimum Y is $8F
  CMP #MIN_Y
  BCS +
  LDA hilitedltr
  CLC
  ADC #$07
  STA hilitedltr

  LDA #MIN_Y
+ STA cursorY
  JMP UpdateCursorLetterSprites

MoveCursorDown:
  LDA hilitedltr
  CLC
  ADC #$07
  STA hilitedltr

  LDA cursorY
  CLC
  ADC #$10
  ; maximum Y is $BF
  CMP #MAX_Y
  BCC +
  BEQ +
  LDA hilitedltr
  SEC
  SBC #$07
  STA hilitedltr

  LDA #MAX_Y
+ STA cursorY
  JMP UpdateCursorLetterSprites

MoveCursorLeft:
  LDA hilitedltr
  SEC
  SBC #$01
  STA hilitedltr

  LDA cursorX
  SEC
  SBC #$10
  ; minimum X is $48
  CMP #MIN_X
  BCS +
  LDA hilitedltr
  CLC
  ADC #$01
  STA hilitedltr

  LDA #MIN_X
+ STA cursorX
  JMP UpdateCursorLetterSprites

MoveCursorRight:
  LDA hilitedltr
  CLC
  ADC #$01
  STA hilitedltr

  LDA cursorX
  CLC
  ADC #$10
  ; max X is $A8
  CMP #MAX_X
  BCC +
  BEQ +
  LDA hilitedltr
  SEC
  SBC #$01
  STA hilitedltr

  LDA #MAX_X
+ STA cursorX
  JMP UpdateCursorLetterSprites

UpdateCursorLetterSprites:
  ;
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0

  LDA cursorY
  STA $0200, x

  INX
  LDA #ALPHA_CURSOR_SP
  STA $0200, x

  INX
  LDA #%00000000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x
  
  INX
  ; draw names
  DrawName name0, #0, curnameidx, #NAME0_X, #NAME0_Y
  DrawName name1, #1, curnameidx, #NAME1_X, #NAME1_Y
  DrawName name2, #2, curnameidx, #NAME2_X, #NAME2_Y
  DrawName name3, #3, curnameidx, #NAME3_X, #NAME3_Y
  DrawName name4, #4, curnameidx, #NAME4_X, #NAME4_Y

  ; now that we've implemented an OK button, we don't need to look
  ; for the START button to end this state
  ;CheckForStartButton EndAlphabetState, GameEngineLogicDone
  LDA #$00
  STA changed
  JMP GameEngineLogicDone
EndAlphabetState:
  ; user is exiting alphabet screen, go to occupation screen
  LDA #STATEOCCUPATION
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicLandmark:
  LDA curlandmark
  ASL A
  TAX

  LDA landmarkptr, x
  STA vector

  INX
  LDA landmarkptr, x
  STA vector+1

  ; if START button is pressed, jump to the specific function specified for
  ; this landmark, whether that be a river crossing decision, etc.
  CheckForButton #BTN_START, (vector), GameEngineLogicDone
; the following functions could be special functions called for the specific
; type of landmark. See landmarkptr
EndLandmarkState:
  ; go into paused state b/c we're exiting the landmark state so the player
  ; can decide what to do next
  .ifdef AUDIO_YES
  JSR FamiToneMusicStop
  .endif

  INC curlandmark
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone
EndLandmarkStateFort:
  ; we're at a fort, so we need to switch to the screen where the player
  ; can make a decision to purchase supplies or continue on their journey

  .ifdef AUDIO_YES
  JSR FamiToneMusicStop
  .endif

  INC curlandmark
  LDA #STATECHOOSEFORT
  STA newgmstate
  JMP GameEngineLogicDone
EndLandmarkStateFortLaramie:
  ; we're at Fort Laramie, so we need to update our base mileage to be less
  ; (as we're now entering the mountains). Then we'll jump to the main "fort
  ; decision" screen
  LDA #MAX_MI_PER_DAY_B
  STA basemileage
  JMP EndLandmarkStateFort
EndLandmarkStateBlueMountains
  ; we're not going to INC curlandmark here, instead we need to get the decision
  ; the player makes (detour to Fort Walla Walla or not) and then update the
  ; curlandmark accordingly
  LDA #STATECHOOSEBLUE
  STA newgmstate
  JMP GameEngineLogicDone
EndLandmarkStateDalles:
  LDA #STATECHOOSEDLLS
  STA newgmstate
  JMP GameEngineLogicDone


EndGame:
  ; we've reached the Willamette Valley. Switch back to the Title
  ; Screen once the user presses START by triggering RESET. (Eventually,
  ; we should switch to the Score Screen first.)
  .ifdef AUDIO_YES
  JSR FamiToneMusicStop
  .endif

  JMP RESET

;;;;;;;;; 
EngineLogicStore:
  ;; logic associated with general store
  CheckForButton #BTN_A, AdvanceChoice, +
+ CheckForButton #BTN_B, RetractChoice, +
+ CheckForButton #BTN_LEFTARROW, MoveValueDown, +
+ CheckForButton #BTN_RIGHTARROW, MoveValueUp, +
;+ CheckForButton #BTN_START, EndStoreGameState, UpdateStoreDisplay

+ JMP UpdateStoreDisplay

AdvanceChoice:
  INC choice
  LDA choice

  CMP #$05
  BCC +
  JMP EndStoreGameState

+ ; move cursor down
  LDX #$00
  LDA cursorY
  CLC
  ADC #$18
  STA cursorY
  STA $0200, X

  INX
  LDA #OCC_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP UpdateStoreDisplay


RetractChoice:
  DEC choice
  LDA choice

  CMP #$00
  BPL +

  LDA #$00
  STA choice
  JMP GameEngineLogicDone

  ; move cursor up
+ LDX #$00
  LDA cursorY
  SEC
  SBC #$18
  STA cursorY
  STA $0200, X

  INX
  LDA #OCC_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP UpdateStoreDisplay


MoveValueDown:
  LDA choice
  BEQ @AdjustOxenDown
  CMP #$01
  BEQ @AdjustFoodDown
  CMP #$02
  BEQ @AdjustClothesDown
  CMP #$03
  BEQ @AdjustBulletsDown
  CMP #$04
  BEQ @AdjustSparePartsDown
  JMP @MoveValueDownDone
@AdjustOxenDown:
  LDA #$00
  CMP storeoxen
  BCC @SubtractOxen
  JMP @MoveValueDownDone
@SubtractOxen:
  LDA storeoxen
  SEC
  SBC #OXEN_INC
  STA storeoxen
  JMP @MoveValueDownDone
@AdjustFoodDown:
  LDA #$00
  CMP storefood
  BCC @SubtractFood
  JMP @MoveValueDownDone
@SubtractFood:
  LDA storefood
  SEC
  SBC #FOOD_INC
  STA storefood
  JMP @MoveValueDownDone
@AdjustClothesDown:
  LDA #$00
  CMP storeclth
  BCC @SubtractClothes
  JMP @MoveValueDownDone
@SubtractClothes:
  LDA storeclth
  SEC
  SBC #CLOTHES_INC
  STA storeclth
  JMP @MoveValueDownDone
@AdjustBulletsDown:
  LDA #$00
  CMP storebllt
  BCC @SubtractBullets
  JMP @MoveValueDownDone
@SubtractBullets:
  LDA storebllt
  SEC
  SBC #BULLETS_INC
  STA storebllt
  JMP @MoveValueDownDone
@AdjustSparePartsDown:
  LDA #$00
  CMP storepart
  BCC @SubtractSpareParts
  JMP @MoveValueDownDone
@SubtractSpareParts:
  LDA storepart
  SEC
  SBC #SPAREPARTS_INC
  STA storepart
  JMP @MoveValueDownDone
@MoveValueDownDone:
  JMP UpdateStoreDisplay

MoveValueUp:
  LDA choice
  BEQ @AdjustOxenUp
  CMP #$01
  BEQ @AdjustFoodUp
  CMP #$02
  BEQ @AdjustClothesUp
  CMP #$03
  BEQ @AdjustBulletsUp
  CMP #$04
  BEQ @AdjustSparePartsUp
  JMP @MoveValueUpDone
@AdjustOxenUp:
  LDA storeoxen
  CMP #OXEN_MAX
  BCC @AddOxen
  JMP @MoveValueUpDone
@AddOxen:
  LDA storeoxen
  CLC
  ADC #OXEN_INC
  STA storeoxen
  JMP @MoveValueUpDone
@AdjustFoodUp:
  LDA storefood
  CMP #FOOD_MAX
  BCC @AddFood
  JMP @MoveValueUpDone
@AddFood:
  LDA storefood
  CLC
  ADC #FOOD_INC
  STA storefood
  JMP @MoveValueUpDone
@AdjustClothesUp:
  LDA storeclth
  CMP #CLOTHES_MAX
  BCC @AddClothes
  JMP @MoveValueUpDone
@AddClothes:
  LDA storeclth
  CLC
  ADC #CLOTHES_INC
  STA storeclth
  JMP @MoveValueUpDone
@AdjustBulletsUp:
  LDA storebllt
  CMP #BULLETS_MAX
  BCC @AddBullets
  JMP @MoveValueUpDone
@AddBullets:
  LDA storebllt
  CLC
  ADC #BULLETS_INC
  STA storebllt
  JMP @MoveValueUpDone
@AdjustSparePartsUp:
  LDA storepart
  CMP #SPAREPARTS_MAX
  BCC @AddSpareParts
  JMP @MoveValueUpDone
@AddSpareParts:
  LDA storepart
  CLC
  ADC #SPAREPARTS_INC
  STA storepart
  JMP @MoveValueUpDone
@MoveValueUpDone:
  JMP UpdateStoreDisplay

UpdateStorePtrs:
  .dw UpdateOxen, UpdateFood, UpdateClothes, UpdateBullets, UpdateSpareParts

UpdateStoreDisplay:
  LDA choice
  ASL A
  TAX
  LDA UpdateStorePtrs, X
  STA vector
  INX
  LDA UpdateStorePtrs, X
  STA vector+1
  JMP (vector)

UpdateOxen:
  ; display oxen
  LDA curlandmark
  CMP #$00
  BEQ +
  SEC
  SBC #$01
+ ASL A
  ASL A
  TAX
  LDA storeprices, X
  STA temp

  UpdateStoreDisplayRegular #$64, storeoxen, temp, storeoxenpr, #CASH_START_X - $30, #CASH_START_Y + $18, #CASH_START_X, #CASH_START_Y + $18, %00000001, %00000001
  JMP DoneUpdatingStore

UpdateFood:
  ; display food
  LDA storefood
  STA htd_in
  JSR EightBitHexToDec
  LDA #$80
  STA temp
  DisplayNumberTens temp, htd_out, #CASH_START_X - $40, #CASH_START_Y + $30, %00000001

foodhundszero:
  LDA storefood
  BEQ +
  JMP foodtenszero
+ LDX #$84
  LDA #CASH_START_Y + $30
  STA $0200, X
  INX
  LDA #$00
  STA $0200, X
  INX
  LDA #%00000001
  STA $0200, X
  INX
  LDA #CASH_START_X - $20
  STA $0200, X

foodtenszero:
  LDX #$88
  LDA #CASH_START_Y + $30
  STA $0200, X
  INX
  LDA storefood
  BEQ +
  LDA #$44
  JMP ++
+ LDA #$00
++ STA $0200, X
  INX
  LDA #%00000001
  STA $0200, X
  INX
  LDA #CASH_START_X - $28
  STA $0200, X

foodoneszero:
  LDX #$8C
  LDA #CASH_START_Y + $30
  STA $0200, X
  INX
  LDA #$44
  STA $0200, X
  INX
  LDA #%00000001
  STA $0200, X
  INX
  LDA #CASH_START_X - $20
  STA $0200, X


  ; display food total price
  LDA curlandmark
  CMP #$00
  BEQ +
  SEC
  SBC #$01
+ ASL A
  ASL A
  CLC
  ADC #$03
  TAX
  LDA storeprices, X
  TAY

  LDA storefood

  JSR Multiply
  STY bcdNum+1
  STA bcdNum
  LDA bcdNum
  STA storefoodpr
  LDA bcdNum+1
  STA storefoodpr+1

  JSR SixteenBitHexToDec

  LDA bcdResult+2
  STA htd_out+1
  LDA bcdResult+1
  ASL A
  ASL A
  ASL A
  ASL A
  ORA bcdResult
  STA htd_out
  LDA #$90
  STA temp
  DisplayNumberHundreds temp, htd_out+1, htd_out, #CASH_START_X + $08, #CASH_START_Y + $30, %00000001

  JMP DoneUpdatingStore


UpdateClothes:
  ; display clothes
  LDA curlandmark
  CMP #$00
  BEQ +
  SEC
  SBC #$01
+ ASL A
  ASL A
  TAX
  INX
  LDA storeprices, X
  STA temp
  UpdateStoreDisplayRegular $9C, storeclth, temp, storeclthpr, #CASH_START_X - $30, #CASH_START_Y + $48, #CASH_START_X, #CASH_START_Y + $48, %00000001, %00000001

  JMP DoneUpdatingStore

UpdateBullets:
  ; display bullets
  LDA curlandmark
  CMP #$00
  BEQ +
  SEC
  SBC #$01
+ ASL A
  ASL A
  TAX
  INX
  INX
  LDA storeprices, X
  STA temp
  UpdateStoreDisplayRegular $B8, storebllt, temp, storeblltpr, #CASH_START_X - $30, #CASH_START_Y + $60, #CASH_START_X, #CASH_START_Y + $60, %00000001, %00000001

  JMP DoneUpdatingStore

UpdateSpareParts:
  ; display spare parts
  LDA curlandmark
  CMP #$00
  BEQ +
  SEC
  SBC #$01
+ ASL A
  ASL A
  TAX
  INX
  LDA storeprices, X
  STA temp
  UpdateStoreDisplayRegular $D4, storepart, temp, storepartpr, #CASH_START_X - $30, #CASH_START_Y + $78, #CASH_START_X, #CASH_START_Y + $78, %00000001, %00000001

  JMP DoneUpdatingStore


DoneUpdatingStore:
  ; display cash remaining
  LDA cash
  STA bcdNum
  LDA cash+1
  STA bcdNum+1

  ; subtract price of oxen
  SEC
  LDA bcdNum
  SBC storeoxenpr
  STA bcdNum
  LDA bcdNum+1
  SBC storeoxenpr+1
  STA bcdNum+1

  ; subtract price of food
  SEC
  LDA bcdNum
  SBC storefoodpr
  STA bcdNum
  LDA bcdNum+1
  SBC storefoodpr+1
  STA bcdNum+1

  ; subtract price of clothes
  SEC
  LDA bcdNum
  SBC storeclthpr
  STA bcdNum
  LDA bcdNum+1
  SBC storeclthpr+1
  STA bcdNum+1

  ; subtract price of bullets
  SEC
  LDA bcdNum
  SBC storeblltpr
  STA bcdNum
  LDA bcdNum+1
  SBC storeblltpr+1
  STA bcdNum+1

  ; subtract price of spare parts
  SEC
  LDA bcdNum
  SBC storepartpr
  STA bcdNum
  LDA bcdNum+1
  SBC storepartpr+1
  STA bcdNum+1

  LDA bcdNum
  STA cashremain
  LDA bcdNum+1
  STA cashremain+1

  ; check if our remaining cash is >= $0. If it isn't, we need to see what item
  ; we're currently on, subtract one of the increments, and then jmp back to
  ; UpdateStoreDisplay
  ; (http://www.6502.org/tutorials/compare_beyond.html#6)
  LDA cashremain
  CMP #$00
  LDA cashremain+1
  SBC #$00
  BVC CONT
  EOR #$80
CONT:
  BMI NEGMONEY
  JMP POSMONEY
NEGMONEY:
  LDA choice
  CMP #$00
  BEQ @AdjustOxen
  CMP #$01
  BEQ @AdjustFood
  CMP #$02
  BEQ @AdjustClothes
  CMP #$03
  BEQ @AdjustBullets
  CMP #$04
  BEQ @AdjustSpareParts
  JMP UpdateStoreDisplay
@AdjustOxen:
  LDA storeoxen
  SEC
  SBC #OXEN_INC
  STA storeoxen
  JMP UpdateStoreDisplay
@AdjustFood:
  LDA storefood
  SEC
  SBC #FOOD_INC
  STA storefood
  JMP UpdateStoreDisplay
@AdjustClothes:
  LDA storeclth
  SEC
  SBC #CLOTHES_INC
  STA storeclth
  JMP UpdateStoreDisplay
@AdjustBullets:
  LDA storebllt
  SEC
  SBC #BULLETS_INC
  STA storebllt
  JMP UpdateStoreDisplay
@AdjustSpareParts:
  LDA storepart
  SEC
  SBC #SPAREPARTS_INC
  STA storepart
  JMP UpdateStoreDisplay
POSMONEY:
  JSR SixteenBitHexToDec
  LDA #$54
  STA temp
  DisplayNumberThousands temp, bcdResult+3, bcdResult+2, bcdResult+1, bcdResult, #CASH_START_X, #CASH_START_Y + $88, %00000001

  JMP GameEngineLogicDone
EndStoreGameState:
  ; user is exiting store state, move remaining cash to cash, and all items to
  ; inventory

  LDA cashremain
  STA cash
  LDA cashremain+1
  STA cash+1

  LDA storeoxen
  CLC
  ADC oxen
  STA oxen

  ; multiply food by 100
  LDA storefood
  JSR Mult100

  CLC
  LDA Res
  ADC food
  STA food
  LDA Res2
  ADC food+1
  STA food+1

  LDA storeclth
  CLC
  ADC clothes
  STA clothes

  ; multiply box of bullets by 100
  ; (see http://wiki.nesdev.com/w/index.php/Multiplication_by_a_constant_integer)
  LDA storebllt
  JSR Mult100

  CLC
  LDA bullets
  ADC Res
  STA bullets
  LDA Res2
  ADC bullets+1
  STA bullets+1

  LDA storepart
  CLC
  ADC spareparts
  STA spareparts

  ; user is exiting store state, switch to "starting-month" state, unless
  ; curlandmark is greater than 0, which means that we're already in our journey
  ; and have been at a fort's store, and so need to resume traveling by going to
  ; the paused screen.
  LDA #$00
  CMP curlandmark
  BCC EndStoreGameStateAlreadyTraveling
EndStoreGameStateSettingUpNewGame:
  LDA #STATEMONTH
  STA newgmstate
  JMP GameEngineLogicDone
EndStoreGameStateAlreadyTraveling:
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicPaused:
  ;; logic associated with paused screen
  CheckForButton #BTN_UPARROW, MovePausedCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MovePausedCursorDown, +
+ CheckForButton #BTN_A, EndPausedGameStateItemSelected, +
+ CheckForButton #BTN_START, EndPausedGameState, +

+ LDA changed
  BEQ +
  JMP UpdatePausedCursorSprite
+ JMP GameEngineLogicDone

MovePausedCursorUp:
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA cursorY
  SEC
  SBC #$08
  ; compare to PAUSED_MIN_Y
  CMP #PAUSED_MIN_Y
  BCS +
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA #PAUSED_MIN_Y
+ STA cursorY
  JMP UpdatePausedCursorSprite

MovePausedCursorDown:
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA cursorY
  CLC
  ADC #$08
  ; compare to PAUSED_MAX_Y
  CMP #PAUSED_MAX_Y
  BCC +
  BEQ +
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA #PAUSED_MAX_Y
+ STA cursorY
  JMP UpdatePausedCursorSprite

UpdatePausedCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #PAUSED_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  LDA #$00
  STA changed

  JMP GameEngineLogicDone

; where each of the menu items on the PAUSED screen goes
PAUSEDSELECTIONFUNCTIONS:
  .dw EndPausedGameState
  .dw EndPausedGameStateLoadViewSupply
  .dw $0000
  .dw EndPausedGameStateLoadPace
  .dw EndPausedGameStateLoadRations
  .dw EndPausedGameStateLoadRest

EndPausedGameState:
  ; user is exiting paused state, switch back to traveling state
  LDA #STATETRAVELING
  STA newgmstate
  JMP GameEngineLogicDone
EndPausedGameStateItemSelected:
  ; what item did the user select from the PAUSED screen?
  LDA choice
  ASL A
  TAX
  LDA PAUSEDSELECTIONFUNCTIONS, X
  STA vector
  LDA PAUSEDSELECTIONFUNCTIONS+1, X
  STA vector+1
  JMP (vector)
EndPausedGameStateLoadViewSupply:
  LDA #STATEVIEWSUPPLY
  STA newgmstate
  JMP GameEngineLogicDone
EndPausedGameStateLoadPace:
  LDA #STATEPACE
  STA newgmstate
  JMP GameEngineLogicDone
EndPausedGameStateLoadRations:
  LDA #STATERATIONS
  STA newgmstate
  JMP GameEngineLogicDone
EndPausedGameStateLoadRest:
  LDA #STATEREST
  STA newgmstate
  JMP GameEngineLogicDone


;;;;;;;;;
EngineLogicPace:
  ;; logic associated with pace screen
  CheckForButton #BTN_UPARROW, MovePaceCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MovePaceCursorDown, +
+ CheckForButton #BTN_A, EndPaceGameState, +

+ LDA changed
  BEQ +
  JMP UpdatePaceCursorSprite
+ JMP GameEngineLogicDone

MovePaceCursorUp:
  LDA pace
  SEC
  SBC #$01
  STA pace

  LDA cursorY
  SEC
  SBC #$10
  ; compare to PACE_MIN_Y
  CMP #PACE_MIN_Y
  BCS +
  LDA pace
  CLC
  ADC #$01
  STA pace

  LDA #PACE_MIN_Y
+ STA cursorY
  JMP UpdatePaceCursorSprite

MovePaceCursorDown:
  LDA pace
  CLC
  ADC #$01
  STA pace

  LDA cursorY
  CLC
  ADC #$10
  ; compare to PACE_MAX_Y
  CMP #PACE_MAX_Y
  BCC +
  BEQ +
  LDA pace
  SEC
  SBC #$01
  STA pace

  LDA #PACE_MAX_Y
+ STA cursorY
  JMP UpdatePaceCursorSprite

UpdatePaceCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #PACE_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  LDA #$00
  STA changed

  JMP GameEngineLogicDone
EndPaceGameState:
  ; user is exiting pace state, switch back to PAUSED state
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone



;;;;;;;;;
EngineLogicRations:
  ;; logic associated with rations screen
  CheckForButton #BTN_UPARROW, MoveRationsCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveRationsCursorDown, +
+ CheckForButton #BTN_A, EndRationsGameState, +

+ JMP GameEngineLogicDone

MoveRationsCursorUp:
  LDA rations
  SEC
  SBC #$01
  STA rations

  LDA cursorY
  SEC
  SBC #$10
  ; compare to PACE_MIN_Y
  CMP #PACE_MIN_Y
  BCS +
  LDA rations
  CLC
  ADC #$01
  STA rations

  LDA #PACE_MIN_Y
+ STA cursorY
  JMP UpdateRationsCursorSprite

MoveRationsCursorDown:
  LDA rations
  CLC
  ADC #$01
  STA rations

  LDA cursorY
  CLC
  ADC #$10
  ; compare to PACE_MAX_Y
  CMP #PACE_MAX_Y
  BCC +
  BEQ +
  LDA rations
  SEC
  SBC #$01
  STA rations

  LDA #PACE_MAX_Y
+ STA cursorY
  JMP UpdateRationsCursorSprite

UpdateRationsCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #PACE_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP GameEngineLogicDone
EndRationsGameState:
  ; user is exiting pace state, switch back to PAUSED state
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone




;;;;;;;;;
EngineLogicDecisionFort:
  ;; logic associated with the decision screen for forts
  CheckForButton #BTN_UPARROW, MoveDecisionFortCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveDecisionFortCursorDown, +
+ CheckForButton #BTN_A, EndDecisionFortGameState, +

+ JMP GameEngineLogicDone
MoveDecisionFortCursorUp:
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA cursorY
  SEC
  SBC #$10
  ; compare to CHOOSEFORT_MIN_Y
  CMP #CHOOSEFORT_MIN_Y
  BCS +
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA #CHOOSEFORT_MIN_Y
+ STA cursorY
  JMP UpdateDecisionFortCursorSprite

MoveDecisionFortCursorDown:
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA cursorY
  CLC
  ADC #$10
  ; compare to CHOOSEFORT_MAX_Y
  CMP #CHOOSEFORT_MAX_Y
  BCC +
  BEQ +
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA #CHOOSEFORT_MAX_Y
+ STA cursorY
  JMP UpdateDecisionFortCursorSprite

UpdateDecisionFortCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #CHOOSEFORT_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP GameEngineLogicDone
EndDecisionFortGameState:
  ; user is exiting fort-decision state
  LDA choice
  BEQ EndDecisionFortGameStateGoToStore
EndDecisionFortGameStateContinueTravel:
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone
EndDecisionFortGameStateGoToStore:
  LDA #STATESTORE
  STA newgmstate
  JMP GameEngineLogicDone



;;;;;;;;;
EngineLogicDecisionDalles:
  ;; logic associated with the decision screen for Dalles
  CheckForButton #BTN_UPARROW, MoveDecisionDallesCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveDecisionDallesCursorDown, +
+ CheckForButton #BTN_A, EndDecisionDallesGameState, +

+ JMP GameEngineLogicDone
MoveDecisionDallesCursorUp:
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA cursorY
  SEC
  SBC #$10
  CMP #CHOOSEDALLES_MIN_Y
  BCS +
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA #CHOOSEDALLES_MIN_Y
+ STA cursorY
  JMP UpdateDecisionDallesCursorSprite

MoveDecisionDallesCursorDown:
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA cursorY
  CLC
  ADC #$10
  CMP #CHOOSEDALLES_MAX_Y
  BCC +
  BEQ +
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA #CHOOSEDALLES_MAX_Y
+ STA cursorY
  JMP UpdateDecisionDallesCursorSprite

UpdateDecisionDallesCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #CHOOSEDALLES_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP GameEngineLogicDone
EndDecisionDallesGameState:
  ; user is exiting Dalles decision state
  LDA choice
  BEQ EndDecisionDallesGameStateRaftColumbia
EndDecisionDallesGameStateBarlowRoad:
  INC curlandmark
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone
EndDecisionDallesGameStateRaftColumbia:
  LDA #STATECLMBIARVR
  STA newgmstate
  JMP GameEngineLogicDone




;;;;;;;;;
EngineLogicDecisionBlueMountains:
  ;; logic associated with the decision screen for the Blue Mountains
  CheckForButton #BTN_UPARROW, MoveDecisionBlueMountainsCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveDecisionBlueMountainsCursorDown, +
+ CheckForButton #BTN_A, EndDecisionBlueMountainsGameState, +

+ JMP GameEngineLogicDone
MoveDecisionBlueMountainsCursorUp:
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA cursorY
  SEC
  SBC #$10
  ; compare to CHOOSEBlueMountains_MIN_Y
  CMP #CHOOSEBLUE_MIN_Y
  BCS +
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA #CHOOSEBLUE_MIN_Y
+ STA cursorY
  JMP UpdateDecisionBlueMountainsCursorSprite

MoveDecisionBlueMountainsCursorDown:
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA cursorY
  CLC
  ADC #$10
  ; compare to CHOOSEBlueMountains_MAX_Y
  CMP #CHOOSEBLUE_MAX_Y
  BCC +
  BEQ +
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA #CHOOSEBLUE_MAX_Y
+ STA cursorY
  JMP UpdateDecisionBlueMountainsCursorSprite

UpdateDecisionBlueMountainsCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #CHOOSEBLUE_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP GameEngineLogicDone
EndDecisionBlueMountainsGameState:
  ; user is exiting Blue Mountains-decision state
  LDA choice
  BEQ EndDecisionBlueMountainsGameStateBypass
EndDecisionBlueMountainsGameStateDetour:
  INC curlandmark
  JMP EndDecisionBlueMountainsGameStateFinish
EndDecisionBlueMountainsGameStateBypass:
  INC curlandmark
  INC curlandmark
  ; we're grabbing a hard-coded value as we need to get
  ; the distance for the bypass. Not sure yet how to work
  ; around this so we're doing this for now.
  LDX #$13
  LDA landmarkdist, X
  STA miremaining
EndDecisionBlueMountainsGameStateFinish:
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone



;;;;;;;;;
EngineLogicOccupation:
  ;; logic associated with occupation screen
  CheckForButton #BTN_UPARROW, MoveOccupationCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveOccupationCursorDown, +
+ CheckForButton #BTN_A, EndOccupationGameState, +
  
+ LDA changed
  BEQ +
  JMP UpdateOccupationCursorSprite
+ JMP GameEngineLogicDone

MoveOccupationCursorUp:
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA cursorY
  SEC
  SBC #$10
  ; compare to OCC_MIN_Y
  CMP #OCC_MIN_Y
  BCS +
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA #OCC_MIN_Y
+ STA cursorY
  JMP UpdateOccupationCursorSprite

MoveOccupationCursorDown:
  LDA choice
  CLC
  ADC #$01
  STA choice

  LDA cursorY
  CLC
  ADC #$10
  ; compare to OCC_MAX_Y
  CMP #OCC_MAX_Y
  BCC +
  BEQ +
  LDA choice
  SEC
  SBC #$01
  STA choice

  LDA #OCC_MAX_Y
+ STA cursorY
  JMP UpdateOccupationCursorSprite

UpdateOccupationCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #OCC_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  LDA #$00
  STA changed

  JMP GameEngineLogicDone
EndOccupationGameState:
  ; user is exiting occupation state, switch to store state
  LDA choice
  STA occupation

  ; TODO replace hardcoded cash amounts with constants
  CMP #$00
  BEQ @Farmer
  CMP #$01
  BEQ @Carpenter
@Banker:
  LDA #$40
  STA cash
  LDA #$06
  STA cash+1
  JMP @ContExitStore
@Carpenter:
  LDA #$20
  STA cash
  LDA #$03
  STA cash+1
  JMP @ContExitStore
@Farmer:
  LDA #$90
  STA cash
  LDA #$01
  STA cash+1
  JMP @ContExitStore
@ContExitStore:
  LDA #STATESTORE
  STA newgmstate
  JMP GameEngineLogicDone



;;;;;;;;;
EngineLogicRestScreen:
  ;; logic associated with rest screen
  CheckForButton #BTN_UPARROW | #BTN_RIGHTARROW, MoveRestNumberUp, +
+ CheckForButton #BTN_DOWNARROW | #BTN_LEFTARROW, MoveRestNumberDown, +
+ CheckForButton #BTN_B, EndRestGameStateNoRest, +
+ CheckForButton #BTN_A, EndRestGameStateRest, +

+ JMP UpdateRestNumberSprites

MoveRestNumberUp:
  LDA choice
  CLC
  ADC #$01
  STA choice

  CMP #REST_DAYS_MAX
  BCC +
  BEQ +
  SEC
  SBC #$01
  STA choice

+ JMP UpdateRestNumberSprites

MoveRestNumberDown:
  LDA choice
  SEC
  SBC #$01
  STA choice

  CMP #$00
  BPL +
  CLC
  ADC #$01
  STA choice

+ JMP UpdateRestNumberSprites

UpdateRestNumberSprites:
  LDA choice
  STA htd_in
  JSR EightBitHexToDec

  LDA #$08
  STA temp
  DisplayNumberTens temp, htd_out, $58, $57, %00000001

  JMP GameEngineLogicDone
EndRestGameStateRest:
  LDA choice
  BEQ EndRestGameStateNoRest

  TAY
- JSR UpdateCalendar
  DEY
  CPY #$00
  BNE -
EndRestGameStateNoRest:
  ; user is exiting rest game state, switch to paused screen
  ; user backed out so no rest
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone



;;;;;;;;;
EngineLogicMonth:
  ;; logic associated with "start-month" screen
  CheckForButton #BTN_UPARROW, MoveMonthCursorUp, +
+ CheckForButton #BTN_DOWNARROW, MoveMonthCursorDown, +
+ CheckForButton #BTN_A, EndMonthGameState, +

+ JMP UpdateMonthCursorSprite

MoveMonthCursorUp:
  LDA month
  SEC
  SBC #$01
  STA month

  LDA cursorY
  SEC
  SBC #$10
  CMP #MONTH_MIN_Y
  BCS +
  LDA month
  CLC
  ADC #$01
  STA month

  LDA #MONTH_MIN_Y
+ STA cursorY
  JMP UpdateMonthCursorSprite

MoveMonthCursorDown:
  LDA month
  CLC
  ADC #$01
  STA month

  LDA cursorY
  CLC
  ADC #$10
  CMP #MONTH_MAX_Y
  BCC +
  BEQ +
  LDA month
  SEC
  SBC #$01
  STA month

  LDA #MONTH_MAX_Y
+ STA cursorY
  JMP UpdateMonthCursorSprite

UpdateMonthCursorSprite:
  LDX #$04
  LDA cursorY
  STA $0200, X

  INX
  LDA #MONTH_CURSOR_SPR
  STA $0200, x

  INX
  LDA #%00100000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  JMP GameEngineLogicDone
EndMonthGameState:
  ; user is exiting month state, switch to landmark state so we can load initial
  ; landmark (Independence, MO)
  LDA #STATELANDMARK
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;;
EngineLogicViewSupplyScreen:
  CheckForButton #BTN_A | #BTN_B, EndViewSupplyScreen, GameEngineLogicDone
EndViewSupplyScreen:
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone
;;;;;;;;;;
EngineLogicTraveling:
  ;; Set new miremaining for new landmark
  ;
  ; we check the miremaining variable to see if it's equal to 0. If it is, that
  ; means we must have arrived at a landmark. We will now load in the next
  ; landmark's distance and store it in miremaining. Note that we assume that
  ; curlandmark has already been incremented prior to this point, particularly
  ; by the logic associated with the landmark display function. Once we code in
  ; the special functionality to handle forks in the trail, that will handle
  ; setting the curlandmark to the correct value.
  LDA miremaining
  BNE +
  LDX curlandmark
  LDA landmarkdist, X
  STA miremaining

  ;; Decrement frame counter currframe
  ;
  ; right now we're displaying the background, scrolling it, and updating our
  ; wagon wheel animation. We have a little frame counter that keeps track of
  ; the current frame, and once it gets to 0, will then trigger the background
  ; update and the wagon wheel animation update.
+ DEC currframe

  ; calc mi traveled
  LDA oxen
  CLC				; need CLC to clear the carry flag; this was sometimes set
					; and the ROR was shifting it into bit 7 which was throwing
					; off calculations of mileage
  ROR A
  STA temp
  MultiplyPercentageDistance basemileage, temp, tempcalcb
  LDA tempcalcb
  STA tempcalca
  MultiplyPercentageDistance tempcalca, pace, tempcalcb
  LDA tempcalcb
  STA mitraveldy

  ;; Check if currframedy should trigger to update day
  LDA currframedy
  BEQ @UpdateDay
  JMP @DoneUpdatingMileage
@UpdateDay:
  LDA #FRAMECOUNT_DAY
  STA currframedy
  JSR UpdateCalendar

  ; seed the random number generator and get the weather
  JSR UpdateWeather

@UpdateMileageEachDay:
  ;; increase mi traveled

  ; we've calculated the max distance we can travel today. However, we may have
  ; reached a landmark. For example, if we're traveling a max of 30 miles today,
  ; but the landmark is only 23 miles away, we need to only travel 23 miles
  ; today, not 30. Check if miremaining < mitraveldy, and if it is, set
  ; mitraveldy to miremaining. (Later we check if miremaining = mitraveldy,
  ; which means we've reached the landmark, and if it is, we trigger the
  ; landmark.)
  LDA mitraveldy
  CMP miremaining
  BCC @UpdateTotalMiTraveled
  LDA miremaining
  STA mitraveldy

@UpdateTotalMiTraveled:
  ; update total mi traveled (this is a 16-bit number hence the rigamarole)
  LDA mitraveled
  CLC
  ADC mitraveldy
  STA mitraveled
  LDA mitraveled+1
  ADC #$00
  STA mitraveled+1

  ; time to trigger landmark?
  ; is miremaining = mitraveldy?
  ;    if so, trigger landmark
  LDA miremaining
  CMP mitraveldy
  BEQ @TriggerLandmark
  SEC
  SBC mitraveldy
  STA miremaining
  JMP @DoneUpdatingMileage

@TriggerLandmark:
  LDA #$00
  STA miremaining

  LDA #STATELANDMARK
  STA newgmstate

  JMP GameEngineLogicDone

@DoneUpdatingMileage:
  ;; Now we're updating graphical sprites, including the status bar, the bg
  ;; scroll, and the wagon animation
  LDX #$24
  JSR UpdateStatusIcons

  ;; Check our currframe frame counter, and if it's zero (i.e. triggered) then
  ;; increase the background scroll and flip the wagon animation to the other
  ;; set of frames.
  LDA currframe
  BEQ +
  JMP CheckLandmarkIcon
+ JSR IncreaseScrollAndFlipWagonAnim

CheckLandmarkIcon:
  .ifdef LANDMARK_ICON_YES
  ;; Check if we're going to update our small landmark icon
  ;
  ; draw small landmark icon once there's < 100 miles to the landmark in
  ; question. Once we've started drawing small landmark icon, keep drawing it
  ; until we reach landmark.
  LDA lndmrkicony
  BEQ @ShouldLandmarkIconShow
  JMP @ShouldUpdateLandmarkIcon
@ShouldLandmarkIconShow:
  ;is the landmark less than 100 miles away?
  LDA miremaining
  CMP #LANDMARK_MILES
  BCS @NoLandmarkIcon

  ;set our starting X position. This will be #LANDMARK_MILES - miremaining
  ;(100 miles - miremaining), at 1 pixel per mi.
  LDA #LANDMARK_MILES
  SEC
  SBC miremaining
  STA landmarkX

  LDA #$01
  STA lndmrkicony
  ; load the current frame for landmark icon purposes and see if we've reached
  ; zero yet. If we have, draw the landmark icon at the new spot. We will then
  ; reset the frame counter for landmark icon purposes. The value we choose will
  ; be dependent on the miles traveled that day (mitraveldy).
@ShouldUpdateLandmarkIcon:
  LDA currframeld
  BNE @DontUpdateLandmarkIcon
  JSR UpdateLandmarkIcon

@DontUpdateLandmarkIcon:
  DEC currframeld
@NoLandmarkIcon:
  .endif
  ;; Check if we should enter Pause
  CheckForButton #BTN_START, EnterPausedGameState, GameEngineLogicDone

EnterPausedGameState:
  ; user is entering pause state
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone

.ifdef LANDMARK_ICON_YES
UpdateLandmarkIcon:
  ; load landmark metatile
  LDA #LANDMARK_OFFSET
  STA tileoffset

  LDA #LANDMARK_TOP_Y
  STA tileY
  LDA landmarkX
  CMP #LANDMARK_MAX_X
  BCC +
  BEQ +
  LDA #LANDMARK_MAX_X
+ STA tileX

  ; grab the appropriate metatile later based on the
  ; landmark we are traveling towards
  LDA curlandmark
  ASL A
  TAX

  LDA landmarkicons, X
  STA tileptr
  LDA landmarkicons+1, X
  STA tileptr+1

  JSR DrawMetatile
  LDA landmarkX
  CLC

  ; reset the currframeld counter
  ; I have to adjust the counter starting value based on the miles traveled
  ; that day. Right now I do it in ten mile increments starting at 10, going up
  ; to 40.
  ; TODO I may need to add values for the 5 mile increments in between. I'll
  ; have to do more testing.
  LDA mitraveldy
  CMP #11
  BCC TEN
  JMP TESTTWENTY
TEN:
  LDA #FRAME_LNDMRK_10
  STA currframeld
  JMP RESETFRAMELANDMARK
TESTTWENTY:
  CMP #21
  BCC TWENTY
  JMP TESTTHIRTY
TWENTY:
  LDA #FRAME_LNDMRK_20
  STA currframeld
  JMP RESETFRAMELANDMARK
TESTTHIRTY:
  CMP #31
  BCC THIRTY
  JMP TESTFORTY
THIRTY:
  LDA #FRAME_LNDMRK_30
  STA currframeld
  JMP RESETFRAMELANDMARK
TESTFORTY:
  CMP #41
  BCC FORTY
  JMP RESETFRAMELANDMARK			; top mi per day should be 40 mi, so this
									; should never be called
FORTY:
  LDA #FRAME_LNDMRK_40
  STA currframeld
  JMP RESETFRAMELANDMARK

RESETFRAMELANDMARK:
  INC landmarkX

CONTFRAME:
  RTS
.endif
;;;;;;;;;;
IncreaseScrollAndFlipWagonAnim:
  ;; Increase the background scroll
  LDA scrollH
  SEC
  SBC #$01
  STA scrollH

  ; update currframedy; once this has been called enough times, we'll trigger
  ; the day update routine, which updates the mileage traveled
  DEC currframedy

@FlipWagonAnimation:
  ;; Reset the currframe frame counter
  LDA #FRAMECOUNT
  STA currframe

  LDA currwagfrm
  BEQ @LoadFrameOne

@LoadFrameZero:
  LDA #$00
  STA currwagfrm

  JSR UpdateTravelingSpritesFrameZero

  RTS

@LoadFrameOne:
  INC currwagfrm

  JSR UpdateTravelingSpritesFrameOne

  RTS
;;;;;;;;;;
UpdateTravelingSpritesFrameZero:
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

  RTS

UpdateTravelingSpritesFrameOne:
  ; wagon metatile
  LDA #$04
  STA tileoffset

  LDA #OXEN_TOP_Y
  STA tileY
  LDA #OXEN_TOP_X
  CLC
  ADC #$10
  STA tileX

  LDA #<metatile_wagon_frame1
  STA tileptr
  LDA #>metatile_wagon_frame1
  STA tileptr+1

  JSR DrawMetatile

  ; oxen metatile
  LDA #$14
  STA tileoffset

  LDA #OXEN_TOP_Y
  STA tileY
  LDA #OXEN_TOP_X
  STA tileX

  LDA #<metatile_oxen_frame1
  STA tileptr
  LDA #>metatile_oxen_frame1
  STA tileptr+1

  JSR DrawMetatile

  RTS
;;;;;;;;;;;;;
UpdateStatusIcons:
  ; temp icon
  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA temperature
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$B0
  STA $0200, x
  INX

  ; weather icon
  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA weather
  STA $0200, x
  INX
  LDA #%00000000
  STA $0200, x
  INX
  LDA #$C0
  STA $0200, x
  INX

  ; health icon
  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA health
  STA $0200, x
  INX
  LDA #%00000011
  STA $0200, x
  INX
  LDA #$D0
  STA $0200, x
  INX

  ; calendar month
  LDA month
  STA tempcalca
  ASL A
  CLC
  ADC tempcalca
  TAY

  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA monthtext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$28
  STA $0200, x
  INX
  INY

  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA monthtext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$30
  STA $0200, x
  INX
  INY

  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA monthtext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$38
  STA $0200, x
  INX

  ; day text
  LDA day
  ASL A
  TAY
  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA daytext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$48
  STA $0200, x
  INX
  INY

  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA daytext, y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50
  STA $0200, x
  INX
  INY

  ; mileage remaining to next landmark
  ;
  ; thankfully, given the distances involved, we only ever need to show
  ; ones, tens, and hundreds
  ;
  ; Input: miremaining, X
  ; Clobbers: A, Y
  LDA #$00
  STA hundsshown
  ; X is the current offset in sprite memory; we need to store it on the
  ; stack before we clobber it
  TXA
  PHA

  LDA miremaining
  JSR EightBitHexToDec

  ; now that we've converted miremaining to two-byte decimal, we can pull
  ; X back off of the stack
  PLA
  TAX
  STA temp
  DisplayNumberHundreds temp, htd_out+1, htd_out, $A8, #STATUS_ICON_Y + $18, %00000001
  LDX temp

MileageTraveled:
  ;TXA
  ;PHA
  LDA mitraveled
  STA bcdNum
  LDA mitraveled+1
  STA bcdNum+1
  JSR SixteenBitHexToDec

  ;PLA
  ;TAX
  ;STX temp
  ; total mileage traveled
  ;DisplayNumberThousands temp, bcdResult+3, bcdResult+2, bcdResult+1, bcdResult, $50 + $50, #STATUS_ICON_Y + $20, %00000001
  ; NEED TO FIGURE OUT WHY MACRO ISN'T WORKING HERE AND FOR FOOD REMAINING
  LDX temp
  LDA #$00
  STA thousshown
  STA hundsshown

  ; display thousands
  LDA bcdResult+3
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
  LDA #STATUS_ICON_Y + $20
  STA $0200, x
  INX
  TYA
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$50
  STA $0200, x
  INX

@DisplayHundreds:
  ; display hundreds
  LDA bcdResult+2
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
  LDA bcdResult+2
  CLC
  ADC #$44
  TAY
@ContHundreds:
  LDA #STATUS_ICON_Y + $20
  STA $0200, x
  INX
  TYA
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$58
  STA $0200, x
  INX

  ; display tens
  LDA #STATUS_ICON_Y + $20
  STA $0200, x
  INX
  LDA bcdResult+1
  BEQ @TensZero
@TensNotZero:
  LDA bcdResult+1
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
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$60
  STA $0200, x
  INX
  ; now we'll display ones, which are easy because we always display the
  ; ones place
  LDA bcdResult
  CLC
  ADC #$44
  PHA
  LDA #STATUS_ICON_Y + $20
  STA $0200, x
  INX
  PLA
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$68
  STA $0200, x
  INX

FoodRemaining:
  TXA
  PHA
  LDA food
  STA bcdNum
  LDA food+1
  STA bcdNum+1
  JSR SixteenBitHexToDec

  PLA
  TAX


  LDA #$00
  STA thousshown
  STA hundsshown

  ; display thousands
  LDA bcdResult+3
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
  LDA #STATUS_ICON_Y + $10
  STA $0200, x
  INX
  TYA
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$50
  STA $0200, x
  INX

@DisplayHundreds:
  ; display hundreds
  LDA bcdResult+2
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
  LDA bcdResult+2
  CLC
  ADC #$44
  TAY
@ContHundreds:
  LDA #STATUS_ICON_Y + $10
  STA $0200, x
  INX
  TYA
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$58
  STA $0200, x
  INX

  ; display tens
  LDA #STATUS_ICON_Y + $10
  STA $0200, x
  INX
  LDA bcdResult+1
  BEQ @TensZero
@TensNotZero:
  LDA bcdResult+1
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
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$60
  STA $0200, x
  INX
  ; now we'll display ones, which are easy because we always display the
  ; ones place
  LDA bcdResult
  CLC
  ADC #$44
  PHA
  LDA #STATUS_ICON_Y + $10
  STA $0200, x
  INX
  PLA
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$68
  STA $0200, x
  INX

  RTS
;;;;;;;;;;;;;;;;