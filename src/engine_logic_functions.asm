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
MACRO CheckForStartButton jumpto,elsejumpto
  ; Checks for START button to have been pressed on player 1's
  ; controller. Once it has, jump to subroutine given as jumpto.
  ;
  ; Clobbers: A
  LDA buttons1
  AND #BTN_START
  BEQ +
  JMP jumpto
+ JMP elsejumpto
ENDM
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
  CheckForStartButton EndTitleState, GameEngineLogicDone
EndTitleState:
  ; user is exiting title state, switch to new game state
  LDA #STATENEWGAME
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicNewGame:
  CheckForStartButton EndNewGameState, GameEngineLogicDone
EndNewGameState:
  ; user is exiting new game state, switch to alphabet screen to enter name
  LDA #STATEALPHABET
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicAlphabet:
  ; move cursor around
  LDA buttons1
  AND #BTN_UPARROW
  BNE MoveCursorUp

  LDA buttons1
  AND #BTN_DOWNARROW
  BNE MoveCursorDown

  LDA buttons1
  AND #BTN_LEFTARROW
  BEQ +
  JMP MoveCursorLeft
+
  LDA buttons1
  AND #BTN_RIGHTARROW
  BEQ +
  JMP MoveCursorRight
+
  LDA buttons1
  AND #BTN_A
  BNE @SelectLetter

  LDA buttons1
  AND #BTN_B
  BNE @Erase

  JMP UpdateCursorLetterSprites

@SelectLetter:
  LDA hilitedltr
  CMP #$6B					; user selected OK?
  BEQ @End
  CMP #$6A					; user selected backspace
  BEQ @Erase
  LDX numletters
  CPX #$08
  BEQ @Done
  STA name1, X
  INC numletters
  JMP @Done
@Erase:
  LDA #$00
  DEC numletters
  LDX numletters
  CPX #$00
  BMI @Adjust
  JMP @StoreValue
@Adjust:
  LDX #$00
  STX numletters
@StoreValue:
  STA name1, X
@Done:
  JMP UpdateCursorLetterSprites
@End:
  JMP EndAlphabetState

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
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0

  LDA cursorY
  STA $0200, x

  INX
  LDA #$20
  STA $0200, x

  INX
  LDA #%00000000
  STA $0200, x

  INX
  LDA cursorX
  STA $0200, x

  ; draw selected letters
  LDA #$30
  STA letterX

  LDY #$00
- INX
  LDA #$20
  STA $0200, X

  INX
  STX temp
  TYA
  TAX
  LDA name1, X
  LDX temp
  STA $0200, X

  INX
  LDA #%00000000
  STA $0200, X

  INX
  LDA letterX
  STA $0200, X
  CLC
  ADC #$10
  STA letterX

  INY
  CPY #$0A
  BNE -

  ; now that we've implemented an OK button, we don't need to look
  ; for the START button to end this state
  ;CheckForStartButton EndAlphabetState, GameEngineLogicDone
  JMP GameEngineLogicDone
EndAlphabetState:
  ; user is exiting alphabet screen, go to store
  LDA #STATESTORE
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


  LDA buttons1
  AND #BTN_START
  BEQ +
  JMP (vector)
+ JMP GameEngineLogicDone
EndLandmarkState:
  INC curlandmark
  LDA #STATETRAVELING
  STA newgmstate
  JMP GameEngineLogicDone

EndGame:
  ; we've reached the Willamette Valley. Switch back to the Title
  ; Screen once the user presses START by triggering RESET. (Eventually,
  ; we should switch to the Score Screen first.)
  JMP RESET

;;;;;;;;; 
EngineLogicStore:
  ;; logic associated with general store
  CheckForStartButton EndStoreGameState, GameEngineLogicDone
EndStoreGameState:
  ; user is exiting store state, switch to traveling state
  LDA #STATETRAVELING
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicPaused:
  ;; logic associated with paused screen
  CheckForStartButton EndPausedGameState, GameEngineLogicDone
EndPausedGameState:
  ; user is exiting paused state, switch back to traveling state
  LDA #STATETRAVELING
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;;
EngineLogicTraveling:
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

  ; right now we're displaying the background, scrolling it, and updating our
  ; wagon wheel animation. We have a little frame counter that keeps track of
  ; the current frame, and once it gets to 0, will then trigger the background
  ; update and the wagon wheel animation update.
+ DEC currframe

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
  ; calc mi traveled
  ; check if we've passed Fort Laramie or not, as this is the dividing line between
  ; the max number of mi traveled per day
  LDA #LANDMARK_FT_LARAMIE
  CMP curlandmark
  BCC @mileageB
@mileageA:
  MultiplyPercentageDistance #MAX_MI_PER_DAY_A, yokeoxen, tempcalcb
  JMP @cont
@mileageB:
  MultiplyPercentageDistance #MAX_MI_PER_DAY_B, yokeoxen, tempcalcb
@cont:
  LDA tempcalcb
  STA tempcalca
  MultiplyPercentageDistance tempcalca, pace, tempcalcb
  LDA tempcalcb
  STA mitraveldy

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
  STA bcdNum
  LDA mitraveled+1
  ADC #$00
  STA mitraveled+1
  STA bcdNum+1
  JSR SixteenBitHexToDec

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

@DoneUpdatingMileage:
  LDX #$24
  JSR UpdateStatusIcons

  CheckForStartButton EnterPausedGameState, NotEnteringPausedGameState
EnterPausedGameState:
  ; user is entering pause state
  LDA #STATEPAUSED
  STA newgmstate
  JMP GameEngineLogicDone

NotEnteringPausedGameState:
  LDA currframe
  BEQ IncreaseScrollAndFlipWagonAnim
  JMP GameEngineLogicDone

IncreaseScrollAndFlipWagonAnim:
  LDA scrollH
  SEC
  SBC #$01
  STA scrollH

  ; update currframedy; once this has been called enough times, we'll trigger
  ; the day update routine, which updates the mileage traveled
  DEC currframedy

FlipWagonAnimation:
  LDA #FRAMECOUNT
  STA currframe

  LDA currwagfrm
  BEQ LoadFrameOne

LoadFrameZero:
  LDA #$00
  STA currwagfrm

  JSR UpdateTravelingSpritesFrameZero

  JMP GameEngineLogicDone

LoadFrameOne:
  INC currwagfrm

  JSR UpdateTravelingSpritesFrameOne

  JMP GameEngineLogicDone
;;;;;;;;;;
UpdateCalendar:
  ; adds one day to the game's calendar
  ;
  ; Clobbers: A, X
  INC day
  LDX month
  LDA daysinmonth, X
  CMP day
  BCC @UpdateMonth
  RTS
@UpdateMonth:
  INC month
  LDA #$01
  STA day
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

  LDA htd_out+1				; get the hundreds value
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
  LDA #STATUS_ICON_Y + $18
  STA $0200, x
  INX
  TYA						; transfer tile index back off of Y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$A8
  STA $0200, x
  INX

@Tens:
  ; we need to display the tens if there's a value greater than 0 or if
  ; the value in the hundreds place is greater than 0

  ; grab the tens value
  LDA htd_out
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
  LDA #STATUS_ICON_Y + $18
  STA $0200, x
  INX
  TYA						; transfer tile index back off of Y
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$B0
  STA $0200, x
  INX

@DisplayOnes:
  ; now we'll display ones, which are easy because we always display the
  ; ones place
  LDA htd_out
  AND #%00001111
  CLC
  ADC #$44
  PHA
  LDA #STATUS_ICON_Y + $18
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

MileageTraveled:
  ; total mileage traveled
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
  RTS
;;;;;;;;;;;;;;;;