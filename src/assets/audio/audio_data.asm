;this file for FamiTone4.2 library generated by text2vol4 tool
;edited by Doug Fraker, 2018, to add volume column, all notes, 
;and effects 1xx,2xx,4xx


audio_data_music_data:
	db 15
	dw @instruments
	dw @samples-3
	dw @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4,307,256 ; homeOnTheRange
	dw @song1ch0,@song1ch1,@song1ch2,@song1ch3,@song1ch4,192,160 ; yankeeDoodle
	dw @song2ch0,@song2ch1,@song2ch2,@song2ch3,@song2ch4,264,220 ; camptownRaces
	dw @song3ch0,@song3ch1,@song3ch2,@song3ch3,@song3ch4,229,191 ; oldDanTucker
	dw @song4ch0,@song4ch1,@song4ch2,@song4ch3,@song4ch4,307,256 ; onTopOfOldSmoky
	dw @song5ch0,@song5ch1,@song5ch2,@song5ch3,@song5ch4,133,110 ; ohShenandoah
	dw @song6ch0,@song6ch1,@song6ch2,@song6ch3,@song6ch4,131,109 ; wayfaringStranger
	dw @song7ch0,@song7ch1,@song7ch2,@song7ch3,@song7ch4,133,110 ; redRiverValley
	dw @song8ch0,@song8ch1,@song8ch2,@song8ch3,@song8ch4,204,170 ; yellowRoseOfTexas
	dw @song9ch0,@song9ch1,@song9ch2,@song9ch3,@song9ch4,245,204 ; ohSusannah
	dw @song10ch0,@song10ch1,@song10ch2,@song10ch3,@song10ch4,276,230 ; arkansasTraveler
	dw @song11ch0,@song11ch1,@song11ch2,@song11ch3,@song11ch4,348,290 ; irishWasherwoman
	dw @song12ch0,@song12ch1,@song12ch2,@song12ch3,@song12ch4,389,324 ; campbellsAreComing
	dw @song13ch0,@song13ch1,@song13ch2,@song13ch3,@song13ch4,204,170 ; battleHymnOfTheRepublic
	dw @song14ch0,@song14ch1,@song14ch2,@song14ch3,@song14ch4,133,110 ; myOldKentuckyHome

@instruments:
	db $30 ;instrument $00
	dw @env1,@env0,@env0
	db $00
	db $30 ;instrument $01
	dw @env2,@env0,@env0
	db $00
	db $30 ;instrument $04
	dw @env3,@env0,@env0
	db $00
	db $30 ;instrument $05
	dw @env4,@env0,@env0
	db $00

@samples:
@env0:
	db $c0,$00,$00
@env1:
	db $c7,$00,$00
@env2:
	db $c3,$00,$00
@env3:
	db $c3,$c1,$00,$01
@env4:
	db $c2,$c1,$00,$01


; homeOnTheRange
@song0ch0:
	db $fb,$06
@song0ch0loop:
@ref0:
	db $61,$80,$28,$83,$00,$28,$85,$2d,$85,$2f,$85,$31,$8d
@ref1:
	db $2d,$81,$2c,$81,$2a,$85,$32,$83,$00,$32,$83,$00,$32,$8d
@ref2:
	db $31,$81,$32,$81,$34,$85,$2d,$83,$00,$2d,$83,$00,$2d,$85,$2c,$85
@ref3:
	db $2d,$85,$2f,$95,$2f,$8b,$00
@ref4:
	db $28,$83,$00,$28,$85,$2d,$85,$2f,$85,$31,$8d
@ref5:
	db $2d,$81,$2c,$81,$2a,$85,$32,$83,$00,$32,$83,$00,$32,$8b,$00
@ref6:
	db $32,$00,$32,$81,$31,$89,$2f,$81,$2d,$85,$2c,$85,$2d,$85
@ref7:
	db $2f,$85,$2d,$95,$2d,$8b,$00
@ref8:
	db $87,$34,$95,$32,$85,$31,$85
@ref9:
	db $2f,$85,$31,$95,$31,$8d
@ref10:
	db $28,$00,$28,$81,$2d,$87,$00,$2d,$00,$2d,$83,$00,$2d,$85,$2c,$85
	db $ff,$07
	dw @ref3
	db $ff,$0b
	dw @ref4
	db $ff,$0f
	dw @ref5
	db $ff,$0e
	dw @ref6
	db $ff,$07
	dw @ref7
	db $fd
	dw @song0ch0loop

; homeOnTheRange
@song0ch1:
@song0ch1loop:
@ref16:
	db $61,$82,$25,$83,$00,$25,$83,$00,$25,$85,$26,$85,$28,$8b,$00
@ref17:
	db $28,$81,$28,$81,$26,$85,$2a,$83,$00,$2a,$83,$00,$2a,$8d
@ref18:
	db $2d,$81,$2f,$81,$31,$83,$00,$25,$83,$00,$25,$83,$00,$25,$85,$26
	db $85
@ref19:
	db $2a,$85,$2d,$95,$2c,$8b,$00
@ref20:
	db $25,$83,$00,$25,$83,$00,$25,$85,$26,$85,$28,$8b,$00
	db $ff,$0e
	dw @ref17
@ref22:
	db $2f,$00,$2f,$81,$28,$89,$26,$81,$25,$85,$23,$85,$25,$85
@ref23:
	db $26,$85,$25,$95,$25,$8b,$00
@ref24:
	db $87,$31,$95,$2f,$85,$2d,$85
@ref25:
	db $2c,$85,$2d,$95,$2d,$8d
@ref26:
	db $25,$81,$25,$00,$25,$87,$00,$25,$81,$25,$83,$00,$25,$85,$23,$85
@ref27:
	db $25,$85,$26,$95,$26,$8b,$00
	db $ff,$0d
	dw @ref20
	db $ff,$0e
	dw @ref17
	db $ff,$0e
	dw @ref22
	db $ff,$07
	dw @ref23
	db $fd
	dw @song0ch1loop

; homeOnTheRange
@song0ch2:
@song0ch2loop:
@ref32:
	db $87,$86,$21,$85,$28,$83,$00,$28,$85,$21,$85,$28,$83,$00
@ref33:
	db $28,$85,$26,$85,$2d,$83,$00,$2d,$85,$26,$85,$2d,$83,$00
@ref34:
	db $2d,$83,$00,$21,$85,$28,$83,$00,$28,$85,$21,$85,$28,$83,$00
@ref35:
	db $28,$83,$00,$1c,$8d,$17,$85,$10,$8b,$00
@ref36:
	db $87,$21,$83,$00,$28,$83,$00,$28,$85,$21,$85,$28,$83,$00
	db $ff,$0e
	dw @ref33
@ref38:
	db $2d,$83,$00,$21,$85,$28,$83,$00,$28,$83,$00,$1c,$85,$23,$83,$00
@ref39:
	db $23,$85,$21,$8d,$1c,$85,$15,$8b,$00
@ref40:
	db $87,$21,$85,$28,$83,$00,$28,$83,$00,$1c,$85,$23,$83,$00
	db $ff,$09
	dw @ref39
@ref42:
	db $87,$21,$85,$28,$83,$00,$28,$85,$21,$85,$28,$83,$00
@ref43:
	db $28,$83,$00,$28,$8d,$23,$85,$1c,$8b,$00
	db $ff,$0e
	dw @ref36
	db $ff,$0e
	dw @ref33
	db $ff,$10
	dw @ref38
	db $ff,$09
	dw @ref39
	db $fd
	dw @song0ch2loop

; homeOnTheRange
@song0ch3:
@song0ch3loop:
@ref48:
	db $af
@ref49:
	db $af
@ref50:
	db $af
@ref51:
	db $af
@ref52:
	db $af
@ref53:
	db $af
@ref54:
	db $af
@ref55:
	db $af
@ref56:
	db $af
@ref57:
	db $af
@ref58:
	db $af
@ref59:
	db $af
@ref60:
	db $70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81
	db $70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81
	db $70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81,$70,$81
	db $ff,$18
	dw @ref60
	db $ff,$18
	dw @ref60
	db $ff,$18
	dw @ref60
	db $fd
	dw @song0ch3loop

; homeOnTheRange
@song0ch4:
@song0ch4loop:
@ref64:
	db $af
@ref65:
	db $af
@ref66:
	db $af
@ref67:
	db $af
@ref68:
	db $af
@ref69:
	db $af
@ref70:
	db $af
@ref71:
	db $af
@ref72:
	db $af
@ref73:
	db $af
@ref74:
	db $af
@ref75:
	db $af
@ref76:
	db $81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81
	db $81,$81,$81,$81,$81,$81,$81,$81
	db $ff,$18
	dw @ref76
	db $ff,$18
	dw @ref76
	db $ff,$18
	dw @ref76
	db $fd
	dw @song0ch4loop


; yankeeDoodle
@song1ch0:
	db $fb,$06
@song1ch0loop:
@ref80:
	db $80,$20,$81,$25,$00,$25,$81,$27,$81,$29,$81,$25,$81,$29,$81,$27
	db $81
@ref81:
	db $20,$81,$25,$00,$25,$81,$27,$81,$29,$81,$25,$85,$24,$81
@ref82:
	db $20,$81,$25,$00,$25,$81,$27,$81,$29,$81,$2a,$81,$29,$81,$27,$81
@ref83:
	db $25,$81,$24,$81,$20,$81,$22,$81,$24,$81,$25,$83,$00,$25,$00
@ref84:
	db $83,$22,$81,$00,$24,$22,$81,$20,$81,$22,$81,$24,$81,$25,$81
@ref85:
	db $83,$20,$81,$00,$22,$20,$81,$1e,$81,$1d,$85,$20,$00
	db $ff,$0f
	dw @ref84
@ref87:
	db $22,$81,$20,$81,$25,$81,$24,$81,$27,$81,$25,$83,$00,$25,$00
	db $fd
	dw @song1ch0loop

; yankeeDoodle
@song1ch1:
@song1ch1loop:
@ref88:
	db $82,$20,$81,$1d,$00,$1d,$81,$1e,$81,$20,$81,$1d,$81,$20,$81,$1e
	db $00
@ref89:
	db $1e,$81,$1d,$00,$1d,$81,$1e,$81,$20,$81,$1d,$85,$1e,$00
@ref90:
	db $1e,$81,$1d,$00,$1d,$81,$1e,$81,$20,$81,$22,$00,$22,$00,$22,$00
@ref91:
	db $22,$81,$20,$00,$20,$81,$1e,$00,$1e,$81,$1d,$83,$00,$1d,$00
@ref92:
	db $83,$1e,$83,$20,$1e,$81,$1d,$81,$1e,$81,$20,$81,$22,$81
@ref93:
	db $83,$1d,$83,$1e,$1d,$81,$1b,$81,$19,$85,$1d,$00
	db $ff,$0e
	dw @ref92
@ref95:
	db $1e,$81,$1d,$00,$1d,$81,$1e,$00,$1e,$81,$1d,$83,$00,$80,$1d,$00
	db $fd
	dw @song1ch1loop

; yankeeDoodle
@song1ch2:
@song1ch2loop:
@ref96:
	db $86,$14,$81,$19,$83,$00,$14,$83,$00,$19,$83,$00,$14,$81
@ref97:
	db $81,$00,$19,$83,$00,$14,$83,$00,$19,$83,$00,$14,$81
@ref98:
	db $81,$00,$19,$83,$00,$19,$83,$00,$12,$83,$00,$12,$81
@ref99:
	db $81,$00,$14,$83,$00,$14,$83,$00,$19,$83,$00,$19,$81
@ref100:
	db $81,$00,$12,$83,$00,$12,$83,$00,$12,$83,$00,$12,$81
@ref101:
	db $81,$00,$19,$83,$00,$19,$83,$00,$19,$83,$00,$19,$81
	db $ff,$0d
	dw @ref100
@ref103:
	db $81,$00,$14,$83,$00,$14,$83,$00,$19,$83,$00,$19,$00
	db $fd
	dw @song1ch2loop

; yankeeDoodle
@song1ch3:
@song1ch3loop:
@ref104:
	db $9f
@ref105:
	db $9f
@ref106:
	db $9f
@ref107:
	db $9f
@ref108:
	db $9f
@ref109:
	db $9f
@ref110:
	db $9f
@ref111:
	db $9f
	db $fd
	dw @song1ch3loop

; yankeeDoodle
@song1ch4:
@song1ch4loop:
@ref112:
	db $9f
@ref113:
	db $9f
@ref114:
	db $9f
@ref115:
	db $9f
@ref116:
	db $9f
@ref117:
	db $9f
@ref118:
	db $9f
@ref119:
	db $9f
	db $fd
	dw @song1ch4loop


; camptownRaces
@song2ch0:
	db $fb,$06
@song2ch0loop:
@ref120:
	db $80,$31,$00,$31,$00,$31,$00,$2e,$00,$31,$00,$33,$00,$31,$00,$2e
	db $00,$83,$2e,$00,$2c,$87,$00,$2e,$00,$2c,$83,$00,$31,$00,$31,$00
	db $31,$00,$2e,$00,$31,$00,$33,$00,$31,$00,$2e,$00,$83,$2c,$83,$00
	db $2e,$00,$2c,$00,$2a,$83,$00,$83,$2a,$81,$00,$2a,$2e,$00,$31,$00
	db $36,$87,$00,$83,$33,$81,$00,$33,$36,$00,$33,$00,$31,$87,$00,$2e
	db $2f,$31,$00,$31,$00,$2e,$00,$31,$00,$33,$00,$31,$00,$2e,$83,$00
	db $2c,$00,$2e,$2f,$2e,$00,$2c,$00,$2a,$83,$00,$83
	db $fd
	dw @song2ch0loop

; camptownRaces
@song2ch1:
@song2ch1loop:
@ref121:
	db $87,$86,$22,$00,$22,$00,$22,$00,$83,$22,$00,$8b,$23,$00,$23,$00
	db $23,$00,$83,$23,$00,$23,$00,$87,$22,$00,$22,$00,$22,$00,$83,$22
	db $00,$8b,$23,$00,$23,$00,$23,$00,$22,$00,$22,$00,$22,$00,$22,$83
	db $00,$22,$83,$00,$22,$87,$00,$83,$23,$83,$00,$23,$83,$00,$22,$83
	db $00,$22,$00,$87,$22,$00,$83,$22,$00,$83,$22,$00,$83,$22,$00,$83
	db $20,$00,$83,$20,$00,$83,$1e,$00,$83
	db $fd
	dw @song2ch1loop

; camptownRaces
@song2ch2:
@song2ch2loop:
@ref122:
	db $83,$86,$12,$83,$00,$12,$83,$00,$12,$83,$00,$12,$83,$00,$19,$83
	db $00,$19,$83,$00,$19,$83,$00,$19,$83,$00,$12,$83,$00,$12,$83,$00
	db $12,$83,$00,$12,$83,$00,$19,$83,$00,$19,$83,$00,$12,$83,$00,$83
	db $12,$83,$00,$12,$83,$00,$12,$83,$00,$12,$00,$83,$12,$83,$00,$12
	db $83,$00,$12,$83,$00,$12,$83,$00,$12,$83,$00,$12,$83,$00,$12,$83
	db $00,$12,$83,$00,$17,$83,$00,$19,$83,$00,$12,$83,$00,$83
	db $fd
	dw @song2ch2loop

; camptownRaces
@song2ch3:
@song2ch3loop:
@ref123:
	db $f9,$f9,$87
	db $fd
	dw @song2ch3loop

; camptownRaces
@song2ch4:
@song2ch4loop:
@ref124:
	db $f9,$f9,$87
	db $fd
	dw @song2ch4loop


; oldDanTucker
@song3ch0:
	db $fb,$06
@song3ch0loop:
@ref125:
	db $f5,$80,$25,$27,$29,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$2a
	db $00,$2a,$00,$27,$00,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$25,$00,$25
	db $00,$27,$00,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$2a
	db $00,$2a,$00,$27,$27,$2a,$00,$2a,$00,$2a,$00,$2a,$00,$25,$00,$25
	db $00,$27,$00,$2a,$00,$2e,$2e,$00,$2f,$2e,$83,$00,$84,$38,$00,$36
	db $00,$33,$00,$36,$00,$80,$2c,$2c,$00,$2e,$2a,$83,$00,$84,$31,$00
	db $31,$00,$33,$00,$36,$00,$80,$2e,$2e,$00,$2f,$2e,$83,$00,$2c,$00
	db $2a,$00,$27,$00,$2a,$00,$2c,$00,$2e,$00,$2a,$00,$2a,$00,$25,$00
	db $25,$00,$27,$00,$2a,$00,$c3
	db $fd
	dw @song3ch0loop

; oldDanTucker
@song3ch1:
@song3ch1loop:
@ref126:
	db $84,$36,$3a,$38,$35,$36,$3a,$38,$35,$36,$3a,$38,$35,$36,$00,$33
	db $00,$36,$3a,$38,$35,$36,$3a,$38,$35,$31,$00,$31,$00,$33,$00,$36
	db $00,$36,$3a,$38,$35,$36,$3a,$38,$35,$36,$3a,$38,$35,$36,$00,$33
	db $00,$36,$3a,$38,$35,$36,$3a,$38,$35,$36,$31,$2e,$31,$2a,$00,$83
	db $82,$2e,$00,$2e,$00,$2e,$00,$83,$2e,$00,$2e,$00,$2f,$00,$83,$2e
	db $00,$2e,$00,$2e,$00,$2c,$00,$2c,$00,$2a,$00,$2f,$00,$83,$2e,$00
	db $2e,$00,$2e,$00,$83,$2e,$00,$2e,$00,$2f,$00,$83,$2e,$00,$2e,$00
	db $2e,$00,$2c,$00,$2c,$00,$2a,$00,$2f,$00,$31,$31,$00,$33,$31,$83
	db $00,$84,$35,$00,$33,$00,$2f,$00,$2e,$00,$82,$2f,$2f,$00,$31,$2e
	db $83,$00,$84,$2e,$00,$2e,$00,$2f,$00,$2e,$00,$82,$31,$31,$00,$33
	db $31,$83,$00,$35,$00,$33,$00,$2f,$00,$2e,$00,$2f,$00,$31,$00,$2e
	db $00,$2e,$00,$2f,$00,$2f,$00,$2f,$00,$2e,$00,$84,$36,$3a,$38,$35
	db $36,$3a,$38,$35,$36,$3a,$38,$35,$36,$00,$33,$00,$36,$3a,$38,$35
	db $36,$3a,$38,$35,$36,$31,$2e,$31,$2a,$83,$00,$83
	db $fd
	dw @song3ch1loop

; oldDanTucker
@song3ch2:
@song3ch2loop:
@ref127:
	db $f9,$81,$86,$12,$83,$00,$87,$12,$83,$00,$87,$12,$83,$00,$87,$19
	db $00,$83,$17,$00,$83,$12,$83,$00,$87,$12,$83,$00,$87,$12,$83,$00
	db $87,$19,$00,$83,$17,$00,$83,$12,$00,$83,$12,$00,$83,$17,$00,$83
	db $17,$00,$83,$19,$00,$83,$12,$00,$83,$12,$00,$83,$12,$00,$83,$12
	db $00,$83,$12,$00,$83,$17,$00,$83,$17,$00,$83,$19,$00,$83,$12,$00
	db $83,$19,$83,$00,$12,$00,$12,$00,$c3
	db $fd
	dw @song3ch2loop

; oldDanTucker
@song3ch3:
@song3ch3loop:
@ref128:
	db $f9,$f9,$f9,$d1
	db $fd
	dw @song3ch3loop

; oldDanTucker
@song3ch4:
@song3ch4loop:
@ref129:
	db $f9,$f9,$f9,$d1
	db $fd
	dw @song3ch4loop


; onTopOfOldSmoky
@song4ch0:
	db $fb,$06
@song4ch0loop:
@ref130:
	db $80,$23,$83,$00,$23,$85,$27,$85,$2a,$85,$2f,$95,$2c,$8d,$28,$83
	db $00,$28,$85,$2a,$85,$2c,$85,$2a,$a3,$00
@ref131:
	db $23,$83,$00,$23,$85,$27,$85,$2a,$83,$00,$2a,$95,$25,$8b,$00,$25
	db $81,$27,$81,$28,$85,$27,$85,$25,$85,$23,$a3,$00
	db $fd
	dw @song4ch0loop

; onTopOfOldSmoky
@song4ch1:
@song4ch1loop:
@ref132:
	db $f9,$95
@ref133:
	db $f9,$95
	db $fd
	dw @song4ch1loop

; onTopOfOldSmoky
@song4ch2:
@song4ch2loop:
@ref134:
	db $f9,$95
@ref135:
	db $f9,$95
	db $fd
	dw @song4ch2loop

; onTopOfOldSmoky
@song4ch3:
@song4ch3loop:
@ref136:
	db $f9,$95
@ref137:
	db $f9,$95
	db $fd
	dw @song4ch3loop

; onTopOfOldSmoky
@song4ch4:
@song4ch4loop:
@ref138:
	db $f9,$95
@ref139:
	db $f9,$95
	db $fd
	dw @song4ch4loop


; ohShenandoah
@song5ch0:
	db $fb,$06
@song5ch0loop:
@ref140:
	db $62,$80,$1a,$85,$1f,$00,$1f,$00,$1f,$89,$21,$81,$23,$81,$24,$81
	db $28,$81,$26,$89,$2b,$81,$2a,$81,$28,$89,$26,$81,$28,$81,$26,$81
	db $23,$81,$26,$87,$00,$26,$85,$28,$00,$28,$00,$28,$89,$23,$81,$26
	db $81,$23,$81,$21,$81,$1f,$89,$21,$85,$23,$89,$1f,$81,$23,$83,$28
	db $26,$95,$1f,$83,$21,$23,$89,$21,$00,$21,$85,$1f,$8b,$00
	db $fd
	dw @song5ch0loop

; ohShenandoah
@song5ch1:
@song5ch1loop:
@ref141:
	db $f9,$f9,$93
	db $fd
	dw @song5ch1loop

; ohShenandoah
@song5ch2:
@song5ch2loop:
@ref142:
	db $f9,$f9,$93
	db $fd
	dw @song5ch2loop

; ohShenandoah
@song5ch3:
@song5ch3loop:
@ref143:
	db $f9,$f9,$93
	db $fd
	dw @song5ch3loop

; ohShenandoah
@song5ch4:
@song5ch4loop:
@ref144:
	db $f9,$f9,$93
	db $fd
	dw @song5ch4loop


; wayfaringStranger
@song6ch0:
	db $fb,$06
@song6ch0loop:
@ref145:
	db $83,$80,$1e,$00,$1e,$00,$1e,$81,$25,$91,$21,$81,$23,$81,$25,$81
	db $21,$81,$1e,$8b,$00,$1e,$00,$1e,$81,$25,$81,$23,$91,$1e,$81,$21
	db $81,$23,$81,$25,$91,$1e,$00,$1e,$00,$1e,$81,$25,$91,$21,$81,$23
	db $81,$25,$81,$21,$81,$1e,$8b,$00,$1e,$00,$1e,$81,$25,$81,$23,$89
	db $21,$81,$1e,$85,$1c,$85,$1e,$91,$25,$00,$25,$81,$28,$81,$2a,$89
	db $25,$81,$28,$85,$25,$85,$21,$81,$1e,$8d,$25,$00,$25,$81,$28,$81
	db $2a,$89,$28,$81,$25,$85,$23,$85,$25,$8f,$00,$25,$81,$2a,$81,$28
	db $81,$25,$89,$21,$81,$23,$85,$25,$81,$23,$81,$21,$85,$1e,$87,$00
	db $1e,$00,$1e,$81,$25,$81,$23,$89,$21,$81,$1e,$85,$1c,$85,$1e,$89
	db $00
	db $fd
	dw @song6ch0loop

; wayfaringStranger
@song6ch1:
@song6ch1loop:
@ref146:
	db $f9,$f9,$f9,$f9,$95
	db $fd
	dw @song6ch1loop

; wayfaringStranger
@song6ch2:
@song6ch2loop:
	db $ff,$05
	dw @ref146
	db $fd
	dw @song6ch2loop

; wayfaringStranger
@song6ch3:
@song6ch3loop:
	db $ff,$05
	dw @ref146
	db $fd
	dw @song6ch3loop

; wayfaringStranger
@song6ch4:
@song6ch4loop:
	db $ff,$05
	dw @ref146
	db $fd
	dw @song6ch4loop


; redRiverValley
@song7ch0:
	db $fb,$06
@song7ch0loop:
@ref150:
	db $80,$1e,$81,$23,$81,$27,$83,$00,$27,$81,$25,$81,$23,$85,$25,$81
	db $23,$81,$20,$81,$23,$91,$1e,$81,$23,$81,$27,$85,$23,$81,$27,$81
	db $2a,$85,$28,$81,$27,$81,$25,$95,$2a,$81,$28,$81,$27,$83,$00,$27
	db $81,$25,$81,$23,$85,$25,$81,$27,$81,$2a,$81,$28,$91,$20,$81,$1f
	db $81,$1e,$85,$22,$81,$23,$81,$25,$85,$27,$81,$25,$81,$23,$93,$00
	db $fd
	dw @song7ch0loop

; redRiverValley
@song7ch1:
@song7ch1loop:
@ref151:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch1loop

; redRiverValley
@song7ch2:
@song7ch2loop:
@ref152:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch2loop

; redRiverValley
@song7ch3:
@song7ch3loop:
@ref153:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch3loop

; redRiverValley
@song7ch4:
@song7ch4loop:
@ref154:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch4loop


; yellowRoseOfTexas
@song8ch0:
	db $fb,$06
@song8ch0loop:
@ref155:
	db $83,$80,$23,$21,$20,$81,$23,$00,$23,$00,$23,$81,$25,$23,$81,$00
	db $83,$21,$81,$20,$81,$23,$81,$28,$83,$2a,$2c,$83,$00,$83,$2c,$00
	db $2c,$81,$23,$00,$23,$81,$2c,$00,$2c,$81,$2a,$00,$83,$28,$81,$27
	db $83,$28,$2a,$83,$2c,$2a,$83,$00,$83,$23,$81,$20,$81,$23,$00,$23
	db $00,$23,$81,$25,$23,$81,$00,$83,$23,$81,$20,$83,$23,$28,$83,$2a
	db $2c,$89,$23,$00,$23,$81,$2d,$00,$2d,$00,$2d,$00,$2d,$81,$2c,$00
	db $83,$2a,$81,$28,$83,$23,$2c,$83,$2a,$28,$83,$00
@ref156:
	db $83,$23,$21,$20,$23,$83,$28,$81,$20,$00,$20,$23,$81,$00,$83,$21
	db $81,$20,$81,$23,$81,$28,$81,$2a,$81,$2c,$83,$00,$83,$23,$00,$23
	db $81,$2c,$00,$2c,$00,$2c,$00,$2c,$2a,$81,$00,$83,$28,$81,$27,$81
	db $28,$81,$2a,$81,$2c,$81,$2a,$89,$23,$21,$20,$81,$23,$00,$23,$00
	db $23,$81,$25,$81,$23,$00,$23,$83,$21,$20,$81,$23,$81,$28,$83,$2a
	db $2c,$83,$00,$23,$00,$23,$00,$23,$81,$2d,$00,$2d,$00,$2d,$00,$2d
	db $2c,$81,$00,$2c,$83,$2a,$28,$83,$23,$2c,$83,$2a,$28,$89,$00,$81
	db $fd
	dw @song8ch0loop

; yellowRoseOfTexas
@song8ch1:
@song8ch1loop:
@ref157:
	db $f9,$f9,$8b
@ref158:
	db $f9,$f9,$93
	db $fd
	dw @song8ch1loop

; yellowRoseOfTexas
@song8ch2:
@song8ch2loop:
@ref159:
	db $f9,$f9,$8b
@ref160:
	db $f9,$f9,$93
	db $fd
	dw @song8ch2loop

; yellowRoseOfTexas
@song8ch3:
@song8ch3loop:
@ref161:
	db $f9,$f9,$8b
@ref162:
	db $f9,$f9,$93
	db $fd
	dw @song8ch3loop

; yellowRoseOfTexas
@song8ch4:
@song8ch4loop:
@ref163:
	db $f9,$f9,$8b
@ref164:
	db $f9,$f9,$93
	db $fd
	dw @song8ch4loop


; ohSusannah
@song9ch0:
	db $fb,$06
@song9ch0loop:
@ref165:
	db $83,$62,$80,$23,$81,$27,$81,$2a,$00,$2a,$83,$2c,$2a,$81,$27,$81
	db $23,$83,$25,$27,$00,$27,$81,$25,$81,$23,$81,$25,$83,$00,$83,$23
	db $81,$27,$81,$2a,$00,$2a,$83,$2c,$2a,$81,$27,$81,$23,$85,$27,$00
	db $27,$81,$25,$83,$22,$23,$83,$00,$83,$23,$81,$27,$81,$2a,$00,$2a
	db $83,$2c,$2a,$00,$2a,$81,$27,$83,$23,$27,$00,$27,$81,$25,$83,$23
	db $25,$83,$00,$83,$23,$81,$27,$81,$2a,$00,$2a,$83,$2c,$2a,$83,$27
	db $23,$83,$25,$27,$00,$27,$81,$25,$00,$25,$81,$23,$83,$00,$83
@ref166:
	db $23,$83,$00,$23,$85,$28,$81,$2c,$89,$2a,$00,$2a,$81,$27,$81,$23
	db $81,$25,$83,$00,$83,$23,$81,$27,$81,$2a,$00,$2a,$83,$2c,$2a,$27
	db $83,$23,$83,$25,$27,$00,$27,$81,$25,$00,$25,$81,$23,$83,$00
	db $fd
	dw @song9ch0loop

; ohSusannah
@song9ch1:
@song9ch1loop:
@ref167:
	db $f9,$f9,$8f
@ref168:
	db $f7
	db $fd
	dw @song9ch1loop

; ohSusannah
@song9ch2:
@song9ch2loop:
@ref169:
	db $f9,$f9,$8f
@ref170:
	db $f7
	db $fd
	dw @song9ch2loop

; ohSusannah
@song9ch3:
@song9ch3loop:
@ref171:
	db $f9,$f9,$8f
@ref172:
	db $f7
	db $fd
	dw @song9ch3loop

; ohSusannah
@song9ch4:
@song9ch4loop:
@ref173:
	db $f9,$f9,$8f
@ref174:
	db $f7
	db $fd
	dw @song9ch4loop


; arkansasTraveler
@song10ch0:
	db $fb,$06
@song10ch0loop:
@ref175:
	db $80,$1e,$20,$22,$1e,$1b,$00,$1b,$1e,$19,$00,$19,$1b,$1e,$00,$1e
	db $00,$20,$00,$20,$00,$22,$00,$22,$00,$1e,$20,$22,$1e,$1b,$81,$1e
	db $00
@ref176:
	db $1e,$20,$22,$1e,$1b,$00,$1b,$1e,$19,$00,$19,$1b,$1e,$81,$25,$81
	db $2a,$29,$2a,$25,$27,$2a,$25,$23,$22,$1e,$20,$22,$1e,$83,$00
@ref177:
	db $1e,$20,$22,$1e,$1b,$00,$1b,$1e,$19,$00,$19,$1b,$1e,$00,$1e,$00
	db $20,$00,$20,$00,$22,$00,$22,$00,$1e,$20,$22,$1e,$1b,$81,$1e,$00
	db $ff,$1f
	dw @ref176
@ref179:
	db $31,$2f,$2e,$31,$2f,$2e,$2c,$2f,$2e,$2c,$2a,$2e,$2c,$29,$25,$81
	db $2a,$00,$2a,$00,$2c,$00,$2c,$00,$2e,$2c,$2a,$2e,$2c,$85
@ref180:
	db $31,$2f,$2e,$31,$2f,$2e,$2c,$2f,$2e,$2c,$2a,$2e,$2c,$29,$25,$81
	db $2a,$29,$2a,$25,$27,$2a,$25,$23,$22,$1e,$20,$22,$1e,$83,$00
	db $ff,$1e
	dw @ref179
	db $ff,$1f
	dw @ref180
	db $fd
	dw @song10ch0loop

; arkansasTraveler
@song10ch1:
@song10ch1loop:
@ref183:
	db $bf
@ref184:
	db $bf
@ref185:
	db $bf
@ref186:
	db $bf
@ref187:
	db $bf
@ref188:
	db $bf
@ref189:
	db $bf
@ref190:
	db $bf
	db $fd
	dw @song10ch1loop

; arkansasTraveler
@song10ch2:
@song10ch2loop:
@ref191:
	db $bf
@ref192:
	db $bf
@ref193:
	db $bf
@ref194:
	db $bf
@ref195:
	db $bf
@ref196:
	db $bf
@ref197:
	db $bf
@ref198:
	db $bf
	db $fd
	dw @song10ch2loop

; arkansasTraveler
@song10ch3:
@song10ch3loop:
@ref199:
	db $bf
@ref200:
	db $bf
@ref201:
	db $bf
@ref202:
	db $bf
@ref203:
	db $bf
@ref204:
	db $bf
@ref205:
	db $bf
@ref206:
	db $bf
	db $fd
	dw @song10ch3loop

; arkansasTraveler
@song10ch4:
@song10ch4loop:
@ref207:
	db $bf
@ref208:
	db $bf
@ref209:
	db $bf
@ref210:
	db $bf
@ref211:
	db $bf
@ref212:
	db $bf
@ref213:
	db $bf
@ref214:
	db $bf
	db $fd
	dw @song10ch4loop


; irishWasherwoman
@song11ch0:
	db $fb,$06
@song11ch0loop:
@ref215:
	db $80,$27,$81,$23,$00,$23,$81,$1e,$81,$23,$00,$23,$81,$27,$81,$23
	db $81,$27,$81,$2a,$81,$28,$81,$27,$81
@ref216:
	db $28,$81,$25,$00,$25,$81,$20,$81,$25,$00,$25,$81,$28,$81,$25,$81
	db $28,$81,$2c,$81,$2a,$81,$28,$81
@ref217:
	db $27,$81,$23,$00,$23,$81,$1e,$81,$23,$00,$23,$81,$27,$81,$23,$81
	db $27,$81,$2a,$81,$28,$81,$27,$81
@ref218:
	db $28,$81,$27,$81,$28,$81,$25,$81,$2a,$81,$28,$81,$27,$81,$23,$00
	db $23,$00,$23,$89
	db $ff,$18
	dw @ref217
	db $ff,$18
	dw @ref216
	db $ff,$18
	dw @ref217
	db $ff,$14
	dw @ref218
@ref223:
	db $27,$81,$23,$00,$23,$81,$1e,$81,$23,$00,$23,$81,$27,$81,$23,$81
	db $27,$00,$27,$81,$25,$81,$23,$81
@ref224:
	db $25,$81,$22,$00,$22,$81,$1e,$81,$22,$00,$22,$81,$25,$81,$22,$81
	db $25,$00,$25,$81,$23,$81,$22,$81
@ref225:
	db $20,$81,$23,$00,$23,$81,$1e,$81,$23,$00,$23,$81,$1c,$81,$23,$00
	db $23,$81,$1b,$81,$23,$00,$23,$81
	db $ff,$14
	dw @ref218
	db $ff,$18
	dw @ref223
	db $ff,$18
	dw @ref224
	db $ff,$18
	dw @ref225
	db $ff,$14
	dw @ref218
	db $fd
	dw @song11ch0loop

; irishWasherwoman
@song11ch1:
@song11ch1loop:
@ref231:
	db $af
@ref232:
	db $af
@ref233:
	db $af
@ref234:
	db $af
@ref235:
	db $af
@ref236:
	db $af
@ref237:
	db $af
@ref238:
	db $af
@ref239:
	db $af
@ref240:
	db $af
@ref241:
	db $af
@ref242:
	db $af
@ref243:
	db $af
@ref244:
	db $af
@ref245:
	db $af
@ref246:
	db $af
	db $fd
	dw @song11ch1loop

; irishWasherwoman
@song11ch2:
@song11ch2loop:
@ref247:
	db $af
@ref248:
	db $af
@ref249:
	db $af
@ref250:
	db $af
@ref251:
	db $af
@ref252:
	db $af
@ref253:
	db $af
@ref254:
	db $af
@ref255:
	db $af
@ref256:
	db $af
@ref257:
	db $af
@ref258:
	db $af
@ref259:
	db $af
@ref260:
	db $af
@ref261:
	db $af
@ref262:
	db $af
	db $fd
	dw @song11ch2loop

; irishWasherwoman
@song11ch3:
@song11ch3loop:
@ref263:
	db $af
@ref264:
	db $af
@ref265:
	db $af
@ref266:
	db $af
@ref267:
	db $af
@ref268:
	db $af
@ref269:
	db $af
@ref270:
	db $af
@ref271:
	db $af
@ref272:
	db $af
@ref273:
	db $af
@ref274:
	db $af
@ref275:
	db $af
@ref276:
	db $af
@ref277:
	db $af
@ref278:
	db $af
	db $fd
	dw @song11ch3loop

; irishWasherwoman
@song11ch4:
@song11ch4loop:
@ref279:
	db $af
@ref280:
	db $af
@ref281:
	db $af
@ref282:
	db $af
@ref283:
	db $af
@ref284:
	db $af
@ref285:
	db $af
@ref286:
	db $af
@ref287:
	db $af
@ref288:
	db $af
@ref289:
	db $af
@ref290:
	db $af
@ref291:
	db $af
@ref292:
	db $af
@ref293:
	db $af
@ref294:
	db $af
	db $fd
	dw @song11ch4loop


; campbellsAreComing
@song12ch0:
	db $fb,$06
@song12ch0loop:
@ref295:
	db $80,$23,$81,$25,$81,$27,$81,$23,$81,$25,$81,$27,$81,$20,$85,$1e
	db $81,$23,$81,$25,$81,$27,$81,$2a,$87,$00,$2a,$81,$27,$81,$25,$81
@ref296:
	db $23,$81,$25,$81,$27,$81,$23,$81,$25,$81,$27,$81,$2c,$85,$2a,$81
	db $27,$85,$2c,$00,$2c,$81,$2a,$81,$27,$81,$2a,$81,$27,$81,$25,$81
@ref297:
	db $23,$81,$25,$81,$27,$81,$23,$81,$25,$81,$27,$81,$20,$85,$1e,$81
	db $23,$81,$25,$81,$27,$81,$2a,$87,$00,$2a,$81,$27,$81,$25,$81
	db $ff,$20
	dw @ref296
@ref299:
	db $27,$85,$2c,$00,$2c,$85,$2e,$81,$2f,$89,$27,$85,$2c,$00,$2c,$81
	db $2a,$81,$27,$81,$2a,$81,$27,$81,$25,$81
@ref300:
	db $27,$85,$2c,$00,$2c,$85,$2e,$81,$2f,$89,$31,$81,$2f,$81,$2e,$81
	db $2f,$81,$2e,$81,$2c,$81,$2a,$81,$27,$81,$25,$81
	db $ff,$1a
	dw @ref299
	db $ff,$1c
	dw @ref300
	db $fd
	dw @song12ch0loop

; campbellsAreComing
@song12ch1:
@song12ch1loop:
@ref303:
	db $c7
@ref304:
	db $c7
@ref305:
	db $c7
@ref306:
	db $c7
@ref307:
	db $c7
@ref308:
	db $c7
@ref309:
	db $c7
@ref310:
	db $c7
	db $fd
	dw @song12ch1loop

; campbellsAreComing
@song12ch2:
@song12ch2loop:
@ref311:
	db $c7
@ref312:
	db $c7
@ref313:
	db $c7
@ref314:
	db $c7
@ref315:
	db $c7
@ref316:
	db $c7
@ref317:
	db $c7
@ref318:
	db $c7
	db $fd
	dw @song12ch2loop

; campbellsAreComing
@song12ch3:
@song12ch3loop:
@ref319:
	db $c7
@ref320:
	db $c7
@ref321:
	db $c7
@ref322:
	db $c7
@ref323:
	db $c7
@ref324:
	db $c7
@ref325:
	db $c7
@ref326:
	db $c7
	db $fd
	dw @song12ch3loop

; campbellsAreComing
@song12ch4:
@song12ch4loop:
@ref327:
	db $c7
@ref328:
	db $c7
@ref329:
	db $c7
@ref330:
	db $c7
@ref331:
	db $c7
@ref332:
	db $c7
@ref333:
	db $c7
@ref334:
	db $c7
	db $fd
	dw @song12ch4loop


; battleHymnOfTheRepublic
@song13ch0:
	db $fb,$06
@song13ch0loop:
@ref335:
	db $80,$23,$89,$21,$81,$20,$81,$23,$81,$28,$81,$2a,$81,$2c,$8d,$28
	db $83,$00,$87,$25,$89,$27,$81,$28,$83,$27,$28,$83,$25,$23,$8d,$20
	db $83,$00,$87,$23,$89,$21,$81,$20,$81,$23,$81,$28,$81,$2a,$81,$2c
	db $8d,$28,$83,$00,$28,$85,$2a,$83,$00,$2a,$85,$28,$85,$27,$85,$28
	db $93,$00
@ref336:
	db $23,$83,$00,$23,$00,$23,$00,$23,$81,$21,$81,$20,$81,$23,$81,$28
	db $81,$2a,$81,$2c,$00,$2c,$00,$2c,$83,$2a,$28,$83,$00,$28,$81,$27
	db $81,$25,$00,$25,$00,$25,$83,$27,$28,$83,$27,$28,$83,$25,$23,$83
	db $25,$23,$81,$20,$81,$23,$83,$00,$23,$00,$23,$00,$23,$00,$23,$00
	db $23,$81,$21,$81,$20,$81,$23,$81,$28,$81,$2a,$81,$2c,$00,$2c,$00
	db $2c,$83,$2a,$28,$83,$00,$28,$85,$2a,$83,$00,$2a,$85,$28,$85,$27
	db $85,$28,$95
	db $fd
	dw @song13ch0loop

; battleHymnOfTheRepublic
@song13ch1:
@song13ch1loop:
@ref337:
	db $80,$20,$89,$1e,$81,$82,$1c,$81,$80,$20,$00,$82,$20,$81,$21,$81
	db $23,$8d,$20,$83,$00,$87,$21,$89,$23,$81,$80,$25,$83,$82,$23,$80
	db $25,$83,$82,$21,$80,$20,$8d,$82,$1c,$83,$00,$87,$80,$20,$89,$1e
	db $81,$82,$1c,$81,$80,$20,$00,$82,$20,$81,$21,$81,$23,$8d,$20,$83
	db $00,$23,$85,$21,$83,$00,$21,$85,$20,$85,$1e,$85,$20,$93,$00
@ref338:
	db $f9,$f9,$8b
	db $fd
	dw @song13ch1loop

; battleHymnOfTheRepublic
@song13ch2:
@song13ch2loop:
@ref339:
	db $86,$10,$8d,$10,$8d,$10,$8d,$10,$83,$00,$87,$15,$8d,$15,$8d,$10
	db $8d,$10,$83,$00,$87,$10,$8d,$10,$8d,$10,$8d,$10,$83,$00,$14,$85
	db $15,$83,$00,$15,$85,$17,$85,$17,$85,$10,$93,$00
@ref340:
	db $f9,$f9,$8b
	db $fd
	dw @song13ch2loop

; battleHymnOfTheRepublic
@song13ch3:
@song13ch3loop:
@ref341:
	db $f9,$f9,$83
@ref342:
	db $f9,$f9,$8b
	db $fd
	dw @song13ch3loop

; battleHymnOfTheRepublic
@song13ch4:
@song13ch4loop:
@ref343:
	db $f9,$f9,$83
@ref344:
	db $f9,$f9,$8b
	db $fd
	dw @song13ch4loop


; myOldKentuckyHome
@song14ch0:
	db $fb,$06
@song14ch0loop:
@ref345:
	db $83,$80,$27,$00,$27,$83,$00,$27,$85,$23,$85,$25,$83,$27,$28,$83
	db $27,$28,$81,$2c,$81,$2a,$83,$00,$83,$28,$81,$27,$81,$25,$00,$83
	db $23,$00,$23,$81,$22,$00,$83,$23,$81,$25,$93,$00,$83,$25,$81,$27
	db $83,$00,$27,$85,$23,$85,$25,$83,$27,$28,$81,$27,$81,$28,$83,$2c
	db $2a,$85,$23,$83,$25,$27,$83,$00,$27,$85,$25,$81,$23,$81,$27,$83
	db $25,$23,$93,$00,$83,$27,$00,$27,$83,$00,$27,$85,$23,$85,$25,$81
	db $27,$81,$28,$81,$27,$81,$28,$81,$2c,$81,$2a,$83,$00,$83,$28,$81
	db $27,$81,$25,$00,$83,$23,$00,$23,$81,$22,$00,$83,$23,$81,$25,$95
	db $1e,$85,$27,$83,$00,$27,$85,$23,$85,$25,$83,$27,$28,$81,$27,$81
	db $28,$83,$2c,$2a,$85,$23,$83,$25,$27,$81,$23,$81,$28,$81,$27,$81
	db $25,$89,$22,$81,$23,$93
@ref346:
	db $2a,$89,$27,$81,$28,$89,$2c,$81,$2a,$81,$27,$87,$00,$87,$25,$85
	db $23,$89,$25,$81,$23,$89,$20,$81,$23,$93,$00,$23,$81,$25,$81,$27
	db $83,$00,$27,$85,$23,$85,$25,$81,$27,$81,$28,$83,$27,$28,$81,$2c
	db $81,$2a,$95,$23,$83,$25,$27,$83,$23,$28,$81,$27,$81,$25,$83,$00
	db $25,$83,$22,$23,$95
	db $fd
	dw @song14ch0loop

; myOldKentuckyHome
@song14ch1:
@song14ch1loop:
	db $ff,$05
	dw @ref146
@ref348:
	db $f9,$f9,$93
	db $fd
	dw @song14ch1loop

; myOldKentuckyHome
@song14ch2:
@song14ch2loop:
	db $ff,$05
	dw @ref146
@ref350:
	db $f9,$f9,$93
	db $fd
	dw @song14ch2loop

; myOldKentuckyHome
@song14ch3:
@song14ch3loop:
	db $ff,$05
	dw @ref146
@ref352:
	db $f9,$f9,$93
	db $fd
	dw @song14ch3loop

; myOldKentuckyHome
@song14ch4:
@song14ch4loop:
	db $ff,$05
	dw @ref146
@ref354:
	db $f9,$f9,$93
	db $fd
	dw @song14ch4loop
