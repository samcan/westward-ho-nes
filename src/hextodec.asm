;;;;;;;;;;;;;;;
;;
;; Converts 8-bit (1-byte) hex number stored in A to 2-byte decimal number
;; in htd_out. Bits 0-4 of htd_out is the ones place, bits 5-7 of htd_out is
;; the tens place, and bits 0-4 of htd_out+1 is the hundreds place.
;;
;; Clobbers: A, X, Y, htd_in, htd_out, htd_out+1
EightBitHexToDec:
;  FROM http://6502.org/source/integers/hex2dec.htm
; A       = Hex input number (gets put into HTD_IN)
; htd_out   = 1s & 10s output byte
; htd_out+1 = 100s output byte

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
;;;;;;;;;;;;;;;
SixteenBitHexToDec:
; from http://forums.nesdev.com/viewtopic.php?f=10&t=1222&start=15 by tokumaru
BinToDec:
  LDA #$00
  STA bcdResult+0
  STA bcdResult+1
  STA bcdResult+2
  STA bcdResult+3
  STA bcdResult+4
  LDX #$10
BitLoop:
  ASL bcdNum+0
  ROL bcdNum+1

  LDY bcdResult+0
  LDA Table, y
  ROL
  STA bcdResult+0

  LDY bcdResult+1
  LDA Table, y
  ROL
  STA bcdResult+1

  LDY bcdResult+2
  LDA Table, y
  ROL
  STA bcdResult+2

  LDY bcdResult+3
  LDA Table, y
  ROL
  STA bcdResult+3

  ROL bcdResult+4

  DEX
  BNE BitLoop
  RTS
;;;;;;;;;;;;;;;
Table:
	.db $00, $01, $02, $03, $04, $80, $81, $82, $83, $84