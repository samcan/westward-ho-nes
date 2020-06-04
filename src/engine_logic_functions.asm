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
  JSR ReadController1
  LDA buttons1
  AND #BTN_SELECT		; todo change to start once more function implemented
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
  JSR ReadController1
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
  INC currframe
  LDA currframe
  CMP #FRAMECOUNT
  BEQ FlipWagonAnimation
  JMP GameEngineLogicDone

FlipWagonAnimation:
  LDA #$00
  STA currframe

  LDA currwagfrm
  CMP #$00
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