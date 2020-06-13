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

@UpdateDay:
  LDA #FRAMECOUNT_DAY
  STA currframedy
  JSR UpdateCalendar

@UpdateMileageEachDay:
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
  LDX #$24
  JSR UpdateStatusIcons

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
  ; first part of wagon metatile
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0
  
  LDA #$98
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

  ; 2nd part of wagon metatile
  INX
  LDA #$98
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

; first part of oxen metatile
  LDX #$14
  
  LDA #$98
  STA $0200, x

  INX
  LDA #$15
  STA $0200, x

  INX
  LDA #%00000010
  STA $0200, x

  INX
  LDA #$D0
  STA $0200, x

  ; 2nd part of oxen metatile
  INX
  LDA #$98
  STA $0200, x

  INX
  LDA #$16
  STA $0200, x

  INX
  LDA #%00000010
  STA $0200, x

  INX
  LDA #$D8
  STA $0200, x
  RTS

UpdateTravelingSpritesFrameOne:
; first part of wagon metatile
  LDX #$04				; start display using sprite 1 rather than
						; sprite 0

  LDA #$98
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

  ; 2nd part of wagon metatile
  INX
  LDA #$98
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

; first part of oxen metatile
  LDX #$14
  
  LDA #$98
  STA $0200, x

  INX
  LDA #$19
  STA $0200, x

  INX
  LDA #%00000010
  STA $0200, x

  INX
  LDA #$D0
  STA $0200, x

  ; 2nd part of oxen metatile
  INX
  LDA #$98
  STA $0200, x

  INX
  LDA #$1A
  STA $0200, x

  INX
  LDA #%00000010
  STA $0200, x

  INX
  LDA #$D8
  STA $0200, x
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
  STX spritemem

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
  STX spritemem

  ; health icon
  LDA #STATUS_ICON_Y
  STA $0200, x
  INX
  LDA health
  STA $0200, x
  INX
  LDA #%00000010
  STA $0200, x
  INX
  LDA #$D0
  STA $0200, x
  INX
  STX spritemem

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
  STX spritemem

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
  LDA #$00
  STA hundsshown
  TXA
  PHA
  LDA miremaining
  JSR EightBitHexToDec
  PLA
  TAX

  LDA htd_out+1
  BEQ @SkipHundreds
  CLC
  ADC #$44
  TAY

@DisplayHundreds:
  LDA #STATUS_ICON_Y + $18
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
  LDA #$01
  STA hundsshown
  JMP @Tens

@SkipHundreds:
  LDA #STATUS_ICON_Y + $18
  STA $0200, x
  INX
  LDA #$00
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$58
  STA $0200, x
  INX
  LDA #$00
  STA hundsshown

@Tens:
  ; we need to display the tens if there's a value greater than 0 or if
  ; the value in the hundreds place is greater than 0
  LDA htd_out
  AND #%11110000
  LSR A
  LSR A
  LSR A
  LSR A
  TAY
  BEQ @TensZero
@TensNotZero:
  JMP @HundredsShown
@TensZero:
  ; is the hundreds place shown?
  LDA hundsshown
  AND #%00000001
  BNE @HundredsShown
  JMP @HundredsNotShown
@HundredsShown:
  LDA #STATUS_ICON_Y + $18
  STA $0200, x
  INX
  TYA
  CLC
  ADC #$44
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$60
  STA $0200, x
  INX
  JMP @DoneWithTens
@HundredsNotShown:
  LDA #STATUS_ICON_Y + $18
  STA $0200, x
  INX
  LDA #$00
  STA $0200, x
  INX
  LDA #%00000001
  STA $0200, x
  INX
  LDA #$50+$60
  STA $0200, x
  INX
@DoneWithTens:
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
  RTS
;;;;;;;;;;;;;;;;
EightBitHexToDec:
;  FROM http://6502.org/source/integers/hex2dec.htm
; A       = Hex input number (gets put into HTD_IN)
; HTD_OUT   = 1s & 10s output byte
; HTD_OUT+1 = 100s output byte

		CLD             ; (Make sure it's not in decimal mode for the
        STA htd_in      ;                ADCs below.)
        TAY             ; Save the input to restore later if desired.
		LDA #$00
        STA htd_out+1   ; Begin by storing 0 in the output bytes.
        STA htd_out     ; (NMOS 6502 will need LDA #0, STA ...)
        LDX #$8

 htd1$: ASL htd_in
        ROL htd_out
        ROL htd_out+1

        DEX             ; The shifting will happen seven times.  After
        BEQ htd3$       ; the last shift, you don't check for digits of
                        ; 5 or more.
        LDA htd_out
        AND #$F
        CMP #$5
        BMI htd2$

        CLC
        LDA htd_out
        ADC #$3
        STA htd_out

 htd2$: LDA htd_out
        CMP #$50
        BMI htd1$

        CLC
        ADC #$30
        STA htd_out

        JMP htd1$       ; NMOS 6502 can use JMP.

 htd3$: STY htd_in      ; Restore the original input.
        RTS