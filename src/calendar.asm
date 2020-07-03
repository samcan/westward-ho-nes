;;;;;;;;;;
; CALENDAR support
;;;;;;;;;;

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

daysinmonth:
  ; we fill [0] with fake value and that way we can use the month [3] to get the
  ; number of days in March
  .db 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

monthtext:
  .db $00, $00, $00
  .db $59, $6A, $77		; Jan
  .db $55, $6E, $6B		; Feb
  .db $5C, $6A, $7B		; Mar
  .db $50, $79, $7B		; Apr
  .db $5C, $6A, $82		; May
  .db $59, $7E, $77		; Jun
  .db $59, $7E, $75		; Jul
  .db $50, $7E, $70		; Aug
  .db $62, $6E, $79		; Sep
  .db $5E, $6C, $7D		; Oct
  .db $5D, $78, $7F		; Nov
  .db $53, $6E, $6C		; Dec

daytext:
  .db $00, $00
  .db $00, $45			; 1
  .db $00, $46
  .db $00, $47
  .db $00, $48
  .db $00, $49
  .db $00, $4A
  .db $00, $4B
  .db $00, $4C
  .db $00, $4D
  .db $45, $44			; 10
  .db $45, $45
  .db $45, $46
  .db $45, $47
  .db $45, $48
  .db $45, $49
  .db $45, $4A
  .db $45, $4B
  .db $45, $4C
  .db $45, $4D
  .db $46, $44			; 20
  .db $46, $45
  .db $46, $46
  .db $46, $47
  .db $46, $48
  .db $46, $49
  .db $46, $4A
  .db $46, $4B
  .db $46, $4C
  .db $46, $4D
  .db $47, $44			; 30
  .db $47, $45