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
;; LoadPalettes will load your bg and character palettes into memory.
;;
;; Sample usage:
;;   LDA #<palette
;;   STA paletteLo
;;   LDA #>palette
;;   STA palettehi
;;   JSR LoadPalettes
LoadPalettes:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006             ; write the high byte of $3F00 address
  LDA #$00
  STA $2006             ; write the low byte of $3F00 address
  LDY #$00              ; start out at 0
@loop:
  LDA (paletteLo), y        ; load data from address (palette + the value in x)
                          ; 1st time through loop it will load palette+0
                          ; 2nd time through loop it will load palette+1
                          ; 3rd time through loop it will load palette+2
                          ; etc
  STA $2007             ; write to PPU
  INY                   ; X = X + 1
  CPY #$20              ; Compare X to hex $20, decimal 32 - copying 32 bytes = 8 sprites
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
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016
  LDX #$08
@loop:
  LDA $4016
  LSR A            ; bit0 -> Carry
  ROL buttons1     ; bit0 <- Carry
  DEX
  BNE @loop
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
;;