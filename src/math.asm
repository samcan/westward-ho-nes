;8-bit multiply
;by Bregalad
;Enter with A,Y, numbers to multiply
;Output with YA = 16-bit result (X is unchanged)
; see http://wiki.nesdev.com/w/index.php/8-bit_Multiply
Multiply:
	sty Factor  ;Store input factor
	ldy #$00
	sty Res
	sty Res2    ;Clear result
	ldy #$08    ;Number of shifts needed

-	lsr A       ;Shift right input number
	bcc +       ;Check if bit is set
	pha
	lda Res2
	clc
	adc Factor
	sta Res2    ;If so add number to result
	pla
+	lsr Res2    ;Shift result right
	ror Res
	dey
	bne -
	lda Res
	ldy Res2
	rts