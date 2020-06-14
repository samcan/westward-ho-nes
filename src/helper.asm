;;;;;;;;;;
;;;;;;;;;; HELPER FUNCTIONS HERE
;;;;;;;;;;
;; DisplayText function will draw text sprites using the text
;; strings given using the attributes given. 16-bit pointer to
;; text string should be in textvarLo and textvarHi. 16-bit
;; pointer to attribute should be in textattrLo and textattrHi.
;;
;; For text string:
;; new line = $00, space char needs to be something else, $FF = done
;; * first byte is starting y pos
;; * second byte is starting x pos
;; * third byte is first char of string
;;
;; Note that as this uses sprites you are limited to 8 sprites incl.
;; spaces per line. We need to update this to use background graphics.
;;
;;
;; Sample usage:
;;   LDA #<titlewestwardtext
;;   STA textvarLo
;;   LDA #>titlewestwardtext
;;   STA textvarHi
;;
;;   LDA #<titletextattr
;;   STA textattrLo
;;   LDA #>titletextattr
;;   STA textattrHi
;;   JSR DisplayText
DisplayText:
  LDY #$00
LoadTextParams:
  LDA (textvarLo), y
  STA textypos

  INY
  LDA (textvarLo), y
  STA textxpos

  INY
@loop:
  LDX spritemem

  LDA textypos
  STA $0200, x

  INX
  LDA (textvarLo), y
  STA $0200, x

  INX
  TYA
  PHA
  LDY #$00
  LDA (textattrLo), y
  STA $0200, x
  PLA
  TAY

  INX
  LDA textxpos
  STA $0200, x
  CLC
  ADC #$08
  STA textxpos

  INX
  STX spritemem

  INY
  LDA (textvarLo), y
  BEQ TextInsertLineBreak
  CMP #$FF
  BEQ TextDone
  JMP @loop
TextInsertLineBreak:
  INY
  JMP LoadTextParams
TextDone:
  ; text displayed DONE
  RTS

;;;;;;;;;;;;;;;;
;; DecodeRLEScreen
;;
;; Decodes an RLE-compressed screen and loads it into the background.
;;
;;
;; Sample usage:
;;
;;   LDA #<bg_title_screen
;;   STA pointer+0
;;   LDA #>bg_title_screen
;;   STA pointer+1
;;
;;   ; set which nametable to load (0 = nametable 0, 1 = nametable 1)
;;   LDX #$00
;;
;;   JSR DecodeRLEScreen
;;
DecodeRLEScreen:
  ; set output address
  LDA #$2002
  CPX #$01
  BEQ @loadOne
  LDA #$20
  JMP @cont
@loadOne:
  LDA #$24
@cont:
  STA $2006
  LDA #$00
  STA $2006

  ; ; copy screen to VRAM
  ; Decode RLE
  LDY #$00
@big:
  ; get count and byte
  ; get count (has to be LDA rather than LDX)
  LDA (pointer),y
  TAX
  CPX #$00
  BEQ @done
  INY
  ; get byte
  LDA (pointer), y
@loop:
  STA $2007
  DEX
  BNE @loop
  INY
  BNE @big
  INC pointer+1
  JMP @big
@done:
  RTS

;;;;;;;;;;;;;;;;
;; LoadPalettes will load your bg and character palettes into memory.
;;
;; Sample usage:
;;   LDA #<palette
;;   STA paletteptr
;;   LDA #>palette
;;   STA paletteptr
;;   JSR LoadPalettes
LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDY #$00              ; start out at 0
@loop:
  LDA (paletteptr), y     ; load data from address (paletteptr + the value in y)
                          ; 1st time through loop it will load paletteptr+0
                          ; 2nd time through loop it will load paletteptr+1
                          ; 3rd time through loop it will load paletteptr+2
                          ; etc
  STA $2007             ; write to PPU
  INY                   ; Y = Y + 1
  CPY #$20              ; Compare Y to hex $20, decimal 32 - copying 32 bytes = 8 sprites
  BNE @loop             ; Branch to @loop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down
  RTS

;;;;;;;;;;;;;;;
;; ClearBackground will clear the background tiles loaded into memory
ClearBgMemory:
  ; set output address
  LDA #$2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  ; clear VRAM
@Copy1024Bytes:
  LDX #$04
@Copy256Bytes:
  LDY #$00
@Copy1Byte:
  LDA #$00
  STA $2007
  INY
  BNE @Copy1Byte
  DEX
  BNE @Copy256Bytes
  RTS

;;;;;;;;;;;;;;;
VBlankWait:
  BIT $2002
  BPL VBlankWait

;;;;;;;;;;;;;;;
ReadController1:
  LDA newbtns
  STA prevbtns

  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
@loop:
  LDA $4016
  LSR A            ; bit0 -> Carry
  ROL newbtns     ; bit0 <- Carry
  DEX
  BNE @loop

  ; http://forums.nesdev.com/viewtopic.php?f=10&t=20150#p250630
  ; to eliminate input being read multiple times, we need to subtract
  ; previously-pressed buttons
  LDA prevbtns
  EOR #$FF
  AND newbtns
  STA buttons1
  RTS

;;;;;;;;;;;;;;;
clr_sprite_mem:
  LDX #$00
@loop:
  LDA #$FE
  STA $0200, x
  INX
  CPX #$00
  BNE @loop
  RTS    
;;;;;;;;;;;;;;;
BankSwitch:
  TAX
  LDA bankvalues, x
  STA $8000
  RTS
;;;;;;;;;;;;;;;
DisableNMI:
  ; disable rendering and NMIs
  LDA #$00
  STA $2000
  STA $2001

  ; set output address
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006
  RTS
;;;;;;;;;;;;;;;
EnableNMI:
  ; enable NMI
  LDA $2002
  LDA #%10010000
  STA $2000
  RTS
;;;;;;;;;;;;;;;
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