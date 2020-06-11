MACRO MultiplyPercentageDistance x,y,output
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
  LDA buttons1
  AND #BTN_START
  BNE EndTitleState
  JMP GameEngineLogicDone
EndTitleState:
  ; user is exiting title state, switch to new game state
  LDA #STATENEWGAME
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;
EngineLogicNewGame:
  ;JSR ReadController1
  LDA buttons1
  AND #BTN_START
  BNE EndNewGameState
  JMP GameEngineLogicDone
EndNewGameState:
  ; user is exiting new game state, switch to general store state
  LDA #STATESTORE
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;; 
EngineLogicStore:
  ;; logic associated with general store
  ;JSR ReadController1
  LDA buttons1
  AND #BTN_START
  BNE EndStoreGameState
  JMP GameEngineLogicDone
EndStoreGameState:
  ; user is exiting new game state, switch to general store state
  LDA #STATETRAVELING
  STA newgmstate
  JMP GameEngineLogicDone

;;;;;;;;;;
EngineLogicTraveling:
  ; right now we're displaying the background, scrolling it, and updating our
  ; wagon wheel animation. We have a little frame counter that keeps track of
  ; the current frame, and once it gets to 0, will then trigger the background
  ; update and the wagon wheel animation update.
  DEC currframe


  LDA currframedy
  BNE @DoneUpdatingMileage

@UpdateMileage:
  LDA #FRAMECOUNT_DAY
  STA currframedy
  ;; increase mi traveled
  ; calc mi traveled
  ; assume we're not yet at Fort Laramie yet
  MultiplyPercentageDistance #MAX_MI_PER_DAY_A, yokeoxen, tempcalcb
  LDA tempcalcb
  STA tempcalca
  MultiplyPercentageDistance tempcalca, pace, tempcalcb
  LDA tempcalcb
  STA mitraveled

  ; time to trigger landmark?
  ; is miremaining <= mitraveled?
  ;    if so, trigger landmark
  LDA miremaining
  CMP mitraveled
  BCC @TriggerLandmark
  BEQ @TriggerLandmark
  SEC
  SBC mitraveled
  STA miremaining
  JMP @DoneUpdatingMileage

@TriggerLandmark:
  LDA #$00
  STA miremaining


@DoneUpdatingMileage:
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

  JMP GameEngineLogicDone

LoadFrameOne:
  INC currwagfrm

  ; first part of metatile
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0

  LDA #$60
  STA $0200, x

  INX
  LDA #$1B
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
  LDA #$1C
  STA $0200, x

  INX
  LDA #%00000011
  STA $0200, x

  INX
  LDA #$E8
  STA $0200, x

  JMP GameEngineLogicDone
;;;;;;;;;;