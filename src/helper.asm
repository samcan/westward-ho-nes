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
;;   LDA #$08
;;   STA sproffset
;;
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
;;
;; Clobbers: A, X, Y
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
  LDX sproffset

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
;; Clobbers: A, X, Y
DecodeRLEScreen:
  ; set output address
  LDA #PpuStatus
  CPX #$01
  BEQ @loadOne
  LDA #$20
  JMP @cont
@loadOne:
  LDA #$24
@cont:
  STA PpuAddr
  LDA #$00
  STA PpuAddr

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
  STA PpuData
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
;;
;; Clobbers: A, Y
LoadPalettes:
  LDA PpuStatus         ; read PPU status to reset the high/low latch
  LDA #$3F
  STA PpuAddr           ; write the high byte of $3F00 address
  LDA #$00
  STA PpuAddr           ; write the low byte of $3F00 address
  LDY #$00              ; start out at 0
@loop:
  LDA (paletteptr), y     ; load data from address (paletteptr + the value in y)
                          ; 1st time through loop it will load paletteptr+0
                          ; 2nd time through loop it will load paletteptr+1
                          ; 3rd time through loop it will load paletteptr+2
                          ; etc
  STA PpuData           ; write to PPU
  INY                   ; Y = Y + 1
  CPY #$20              ; Compare Y to hex $20, decimal 32 - copying 32 bytes = 8 sprites
  BNE @loop             ; Branch to @loop if compare was Not Equal to zero
                        ; if compare was equal to 32, keep going down
  RTS

;;;;;;;;;;;;;;;
;; ClearBackground will clear the background tiles loaded into memory
;;
;; Clobbers: A, X, Y
ClearBgMemory:
  ; set output address
  LDA #PpuStatus
  LDA #$20
  STA PpuAddr
  LDA #$00
  STA PpuAddr

  ; clear VRAM
@Copy1024Bytes:
  LDX #$04
@Copy256Bytes:
  LDY #$00
@Copy1Byte:
  LDA #$00
  STA PpuData
  INY
  BNE @Copy1Byte
  DEX
  BNE @Copy256Bytes
  RTS

;;;;;;;;;;;;;;;
;;
;; Clobbers: none
VBlankWait:
  BIT PpuStatus
  BPL VBlankWait

;;;;;;;;;;;;;;;
;;
;; Clobbers: A, X
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
;;
;; Clobbers: A, X
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
;;
;; Clobbers: A, X
;;
;; I HAVE NO IDEA WHY THIS WORKS
;; I THOUGHT WE NEEDED TO WRITE TO $8000 TO
;; SWITCH BANKS, WHICH WORKED IN MESEN, BUT
;; NOT IN FCEUX. YOU'RE TELLING ME THAT WE CAN
;; JUST WRITE TO bankvalues AND THAT SWITCHES
;; BANKS???? WHYY???????!!!!!!!!
BankSwitch:
  TAX
  STA bankvalues, x
  RTS
;;;;;;;;;;;;;;;
;;
;; Clobbers: A
DisableNMI:
  ; disable rendering and NMIs
  LDA #$00
  STA PpuCtrl
  STA PpuMask

  ; set output address
  LDA PpuStatus
  LDA #$20
  STA PpuAddr
  LDA #$00
  STA PpuAddr
  RTS
;;;;;;;;;;;;;;;
;;
;; Clobbers: A
EnableNMI:
  ; enable NMI
  LDA PpuStatus
  LDA #%10010000
  STA PpuCtrl
  RTS
;;;;;;;;;;;;;;;
; From http://wiki.nesdev.com/w/index.php/Random_number_generator
; Returns a random 8-bit number in A (0-255)
; Clobbers: A, Y
;
; Requires a 2-byte value on the zero page called "seed".
; Initialize seed to any value except 0 before the first call to prng.
; (A seed value of 0 will cause prng to always return 0.)
;
; This is a 16-bit Galois linear feedback shift register with polynomial $0039.
; The sequence of numbers it generates will repeat after 65535 calls.
;
; Execution time is an average of 125 cycles (excluding jsr and rts)
GetRandomNumber:
	LDA #8     ; iteration count (generates 8 bits)
	LDA seed+0
	
	;CMP #$00
	;BNE :+
	;CLC
	;ADC #$01
@a:
	ASL        ; shift the register
	ROL seed+1
	BCC @b
	EOR #$39   ; apply XOR feedback whenever a 1 bit is shifted out
@b:
	DEY
	BNE @a
	STA seed+0
	CMP #0     ; reload flags
	RTS
;;;;;;;;;;;;;;;
; Set weather and temperature
; randomly generates weather for now
; Clobbers: A, Y
UpdateWeather:
  JSR UpdateTemperature

  LDA tempernum
  STA weathernum

  CMP #$3A
  BCS +
  LDA #WEATHER_STORM
  STA weather
  JMP WeatherDone:
+ CMP #$7E
  BCS +
  LDA #WEATHER_RAIN
  STA weather
  JMP WeatherDone
+ CMP #$B8
  BCS +
  LDA #WEATHER_PARTLY
  STA weather
  JMP WeatherDone
+ LDA #WEATHER_SUN
  STA weather

WeatherDone:
  RTS
;;;;;;;;;;;;;;;
GetRandomTemperature:
  ; gets random temperature based on mean, variance, and month. Only uses
  ; data for Kansas City, MO. Next we'll need to extend to use the weather
  ; zones.
  ;
  ; Returns a temperature that's either the mean, mean + +variance, or
  ; mean + -variance. There's no in-between values. Also, we don't mess with 2x
  ; variance or 3x variance. I think this will look realistic enough, at least
  ; right now. I may change my mind down the road. (Heh heh, "down the trail.")

  ; load mean temperature for month and store in stack
  LDA month
  ASL A
  ASL A
  CLC
  ADC #$01 ; x offset for mean temp for given month
  PHA ; store X offset on stack
  TAX
  LDA temperatures, X ; load the mean temp
  PHA ; store mean temp on stack

@GetRandTemperature:
  JSR GetRandomNumber
  TAX ; make copy of random number generated on X
  AND #%00000011
  CMP #$03
  BEQ @SubtractOne
  JMP @ContSigned
@SubtractOne:
  SEC
  SBC #$01
@ContSigned:
  STA randsigned
  TXA ; transfer copy of random number back
  CMP #$BF
  BCC @OneAnomaly
  BEQ @OneAnomaly
;  CMP #$F5
;  BCC @TwoAnomaly
;  BEQ @TwoAnomaly
;  JMP @ThreeAnomaly


@OneAnomaly:
  PLA ; pull mean temp off of stack
  TAY
  PLA ; pull X offset off of stack
  CLC
  ADC randsigned ; inc X offset to whatever
  TAX
  TYA
  CLC
  ADC temperatures, X ; get variance



;@TwoAnomaly:

;@ThreeAnomaly:


@StoreTemperature:
  CMP #TEMP_MAX_F
  BNE +
  LDA #TEMP_MAX_F
+ STA tempernum

  RTS
;;;;;;;;;;;;;;;
UpdateTemperature:
  ;; Clobbers: A, X, Y
  JSR GetRandomTemperature
  
  ; we now need to set the status icon to be used
  CMP #TEMP_VERYHOT_F
  BCS @TempVeryHot
  CMP #TEMP_HOT_F
  BCS @TempHot
  CMP #TEMP_WARM_F
  BCS @TempWarm
  CMP #TEMP_COOL_F
  BCS @TempCool
  CMP #TEMP_COLD_F
  BCS @TempCold
  JMP @TempVeryCold

@TempVeryHot:
  LDA #TEMP_VERYHOT
  JMP UpdateTemperatureDone

@TempHot:
  LDA #TEMP_HOT
  JMP UpdateTemperatureDone

@TempWarm:
  LDA #TEMP_WARM
  JMP UpdateTemperatureDone

@TempCool:
  LDA #TEMP_COOL
  JMP UpdateTemperatureDone

@TempCold:
  LDA #TEMP_COLD
  JMP UpdateTemperatureDone

@TempVeryCold:
  LDA #TEMP_VERYCOLD
  JMP UpdateTemperatureDone

UpdateTemperatureDone:
  STA temperature
  RTS
;;;;;;;;;;;;;;;
DrawMetatile:
; Draw a four-tile metatile
; Clobbers: A, X, Y
; first part of oxen metatile
  LDX #$00
  LDY #$00

; metatile_oxen_frame1:
; .db $05,%00000010,  $06,%00000010
; .db $1B,%00000010,  $1C,%00000010

  ; load tile info as part of metatile
@loop:
  LDA (tileptr), Y
  STA tile
  INY
  LDA (tileptr), Y
  STA tilepal
  INY

  ; draw tile to OAM
  CPX #$00
  BEQ @DrawTopLeft
  CPX #$01
  BEQ @DrawTopRight
  CPX #$02
  BEQ @DrawBottomLeft
  CPX #$03
  BEQ @DrawBottomRight
  JMP @cont

@DrawTopLeft:
  TXA
  PHA

  LDX tileoffset
  LDA tileY
  STA $0200, X

  INX
  LDA tile
  STA $0200, X

  INX
  LDA tilepal
  STA $0200, X

  INX
  LDA tileX
  STA $0200, X

  INX
  STX tileoffset

  PLA
  TAX
  JMP @cont

@DrawTopRight:
  TXA
  PHA

  LDX tileoffset
  LDA tileY
  STA $0200, X

  INX
  LDA tile
  STA $0200, X

  INX
  LDA tilepal
  STA $0200, X

  INX
  LDA tileX
  CLC
  ADC #$08
  STA $0200, X

  INX
  STX tileoffset

  PLA
  TAX
  JMP @cont

@DrawBottomLeft:
  TXA
  PHA

  LDX tileoffset
  LDA tileY
  CLC
  ADC #$08
  STA $0200, X

  INX
  LDA tile
  STA $0200, X

  INX
  LDA tilepal
  STA $0200, X

  INX
  LDA tileX
  STA $0200, X

  INX
  STX tileoffset

  PLA
  TAX
  JMP @cont

@DrawBottomRight:
  TXA
  PHA

  LDX tileoffset
  LDA tileY
  CLC
  ADC #$08
  STA $0200, X

  INX
  LDA tile
  STA $0200, X

  INX
  LDA tilepal
  STA $0200, X

  INX
  LDA tileX
  CLC
  ADC #$08
  STA $0200, X

  INX
  STX tileoffset

  PLA
  TAX
  JMP @cont

@cont:
  INX
  CPX #$04
  BEQ +
  JMP @loop
+ RTS
;;;;;;;;;;;;;;;
IncrementSeed:
;; Clobbers: A
  LDA seed
  CLC
  ADC #$01
  STA seed
  LDA seed+1
  ADC #$00
  STA seed+1
  RTS