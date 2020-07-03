;this file for FamiTone2 library generated by text2data tool

audio_data_music_data:
	db 10
	dw @instruments
	dw @samples-3
	dw @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4,307,256
	dw @song1ch0,@song1ch1,@song1ch2,@song1ch3,@song1ch4,192,160
	dw @song2ch0,@song2ch1,@song2ch2,@song2ch3,@song2ch4,264,220
	dw @song3ch0,@song3ch1,@song3ch2,@song3ch3,@song3ch4,229,191
	dw @song4ch0,@song4ch1,@song4ch2,@song4ch3,@song4ch4,307,256
	dw @song5ch0,@song5ch1,@song5ch2,@song5ch3,@song5ch4,133,110
	dw @song6ch0,@song6ch1,@song6ch2,@song6ch3,@song6ch4,131,109
	dw @song7ch0,@song7ch1,@song7ch2,@song7ch3,@song7ch4,133,110
	dw @song8ch0,@song8ch1,@song8ch2,@song8ch3,@song8ch4,204,170
	dw @song9ch0,@song9ch1,@song9ch2,@song9ch3,@song9ch4,245,204

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


@song0ch0:
	db $fb,$06
@song0ch0loop:
@ref0:
	db $80,$4a,$83,$00,$4a,$85,$54,$85,$58,$85,$5c,$8d,$55,$53,$4e,$85
	db $5e,$83,$00,$5e,$83,$00,$5e,$8d,$5d,$5f,$62,$85,$54,$83,$00,$54
	db $83,$00,$54,$85,$52,$85,$54,$85,$58,$95,$58,$8b,$00
@ref1:
	db $4a,$83,$00,$4a,$85,$54,$85,$58,$85,$5c,$8d,$55,$53,$4e,$85,$5e
	db $83,$00,$5e,$83,$00,$5e,$8b,$00,$5e,$00,$5f,$5c,$89,$59,$54,$85
	db $52,$85,$54,$85,$58,$85,$54,$95,$54,$8b,$00
@ref2:
	db $87,$62,$95,$5e,$85,$5c,$85,$58,$85,$5c,$95,$5c,$8d,$4a,$00,$4b
	db $54,$87,$00,$54,$00,$54,$83,$00,$54,$85,$52,$85,$54,$85,$58,$95
	db $58,$8b,$00
	db $ff,$2b
	dw @ref1
	db $fd
	dw @song0ch0loop

@song0ch1:
@song0ch1loop:
@ref4:
	db $82,$44,$83,$00,$44,$83,$00,$44,$85,$46,$85,$4a,$8b,$00,$4b,$4b
	db $46,$85,$4e,$83,$00,$4e,$83,$00,$4e,$8d,$55,$59,$5c,$83,$00,$44
	db $83,$00,$44,$83,$00,$44,$85,$46,$85,$4e,$85,$54,$95,$52,$8b,$00
@ref5:
	db $44,$83,$00,$44,$83,$00,$44,$85,$46,$85,$4a,$8b,$00,$4b,$4b,$46
	db $85,$4e,$83,$00,$4e,$83,$00,$4e,$8d,$58,$00,$59,$4a,$89,$47,$44
	db $85,$40,$85,$44,$85,$46,$85,$44,$95,$44,$8b,$00
@ref6:
	db $87,$5c,$95,$58,$85,$54,$85,$52,$85,$54,$95,$54,$8d,$45,$44,$00
	db $44,$87,$00,$45,$44,$83,$00,$44,$85,$40,$85,$44,$85,$46,$95,$46
	db $8b,$00
	db $ff,$2c
	dw @ref5
	db $fd
	dw @song0ch1loop

@song0ch2:
@song0ch2loop:
@ref8:
	db $87,$86,$3c,$85,$4a,$83,$00,$4a,$85,$3c,$85,$4a,$83,$00,$4a,$85
	db $46,$85,$54,$83,$00,$54,$85,$46,$85,$54,$83,$00,$54,$83,$00,$3c
	db $85,$4a,$83,$00,$4a,$85,$3c,$85,$4a,$83,$00,$4a,$83,$00,$32,$8d
	db $28,$85,$1a,$8b,$00
@ref9:
	db $87,$3c,$83,$00,$4a,$83,$00,$4a,$85,$3c,$85,$4a,$83,$00,$4a,$85
	db $46,$85,$54,$83,$00,$54,$85,$46,$85,$54,$83,$00,$54,$83,$00,$3c
	db $85,$4a,$83,$00,$4a,$83,$00,$32,$85,$40,$83,$00,$40,$85,$3c,$8d
	db $32,$85,$24,$8b,$00
@ref10:
	db $87,$3c,$85,$4a,$83,$00,$4a,$83,$00,$32,$85,$40,$83,$00,$40,$85
	db $3c,$8d,$32,$85,$24,$8b,$00,$87,$3c,$85,$4a,$83,$00,$4a,$85,$3c
	db $85,$4a,$83,$00,$4a,$83,$00,$4a,$8d,$40,$85,$32,$8b,$00
	db $ff,$35
	dw @ref9
	db $fd
	dw @song0ch2loop

@song0ch3:
@song0ch3loop:
@ref12:
	db $f9,$c5
@ref13:
	db $f9,$c5
@ref14:
	db $f9,$c5
@ref15:
	db $f9,$c5
	db $fd
	dw @song0ch3loop

@song0ch4:
@song0ch4loop:
@ref16:
	db $f9,$c5
@ref17:
	db $f9,$c5
@ref18:
	db $f9,$c5
@ref19:
	db $f9,$c5
	db $fd
	dw @song0ch4loop


@song1ch0:
	db $fb,$06
@song1ch0loop:
@ref20:
	db $80,$3b,$44,$00,$45,$49,$4d,$45,$4d,$49,$3b,$44,$00,$45,$49,$4d
	db $44,$85,$43,$3b,$44,$00,$45,$49,$4d,$4f,$4d,$49,$45,$43,$3b,$3f
	db $43,$44,$83,$00,$44,$00,$83,$3f,$00,$42,$3f,$3b,$3f,$43,$44,$85
	db $3b,$00,$3e,$3b,$37,$34,$85,$3a,$00,$83,$3f,$00,$42,$3f,$3b,$3f
	db $43,$45,$3f,$3b,$45,$43,$49,$44,$83,$00,$44,$00
	db $fd
	dw @song1ch0loop

@song1ch1:
@song1ch1loop:
@ref21:
	db $82,$3b,$34,$00,$35,$37,$3b,$35,$3b,$36,$00,$37,$34,$00,$35,$37
	db $3b,$34,$85,$36,$00,$37,$34,$00,$35,$37,$3b,$3e,$00,$3e,$00,$3e
	db $00,$3f,$3a,$00,$3b,$36,$00,$37,$34,$83,$00,$34,$00,$83,$36,$83
	db $3a,$37,$35,$37,$3b,$3e,$85,$34,$83,$36,$35,$31,$2c,$85,$34,$00
	db $83,$36,$83,$3a,$37,$35,$37,$3b,$3f,$37,$34,$00,$35,$36,$00,$37
	db $34,$83,$00,$80,$34,$00
	db $fd
	dw @song1ch1loop

@song1ch2:
@song1ch2loop:
@ref22:
	db $86,$23,$2c,$83,$00,$22,$83,$00,$2c,$83,$00,$22,$83,$00,$2c,$83
	db $00,$22,$83,$00,$2c,$83,$00,$22,$83,$00,$2c,$83,$00,$2c,$83,$00
	db $1e,$83,$00,$1e,$83,$00,$22,$83,$00,$22,$83,$00,$2c,$83,$00,$2c
	db $83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$2c,$83
	db $00,$2c,$83,$00,$2c,$83,$00,$2c,$83,$00,$1e,$83,$00,$1e,$83,$00
	db $1e,$83,$00,$1e,$83,$00,$22,$83,$00,$22,$83,$00,$2c,$83,$00,$2c
	db $00
	db $fd
	dw @song1ch2loop

@song1ch3:
@song1ch3loop:
@ref23:
	db $f9,$f9,$8b
	db $fd
	dw @song1ch3loop

@song1ch4:
@song1ch4loop:
@ref24:
	db $f9,$f9,$8b
	db $fd
	dw @song1ch4loop


@song2ch0:
	db $fb,$06
@song2ch0loop:
@ref25:
	db $80,$5c,$00,$5c,$00,$5c,$00,$56,$00,$5c,$00,$60,$00,$5c,$00,$56
	db $00,$83,$56,$00,$52,$87,$00,$56,$00,$52,$83,$00,$5c,$00,$5c,$00
	db $5c,$00,$56,$00,$5c,$00,$60,$00,$5c,$00,$56,$00,$83,$52,$83,$00
	db $56,$00,$52,$00,$4e,$83,$00,$83,$4f,$00,$4e,$56,$00,$5c,$00,$66
	db $87,$00,$83,$61,$00,$60,$66,$00,$60,$00,$5c,$87,$00,$56,$58,$5c
	db $00,$5c,$00,$56,$00,$5c,$00,$60,$00,$5c,$00,$56,$83,$00,$52,$00
	db $56,$58,$56,$00,$52,$00,$4e,$83,$00,$83
	db $fd
	dw @song2ch0loop

@song2ch1:
@song2ch1loop:
@ref26:
	db $87,$86,$3e,$00,$3e,$00,$3e,$00,$83,$3e,$00,$8b,$40,$00,$40,$00
	db $40,$00,$83,$40,$00,$40,$00,$87,$3e,$00,$3e,$00,$3e,$00,$83,$3e
	db $00,$8b,$40,$00,$40,$00,$40,$00,$3e,$00,$3e,$00,$3e,$00,$3e,$83
	db $00,$3e,$83,$00,$3e,$87,$00,$83,$40,$83,$00,$40,$83,$00,$3e,$83
	db $00,$3e,$00,$87,$3e,$00,$83,$3e,$00,$83,$3e,$00,$83,$3e,$00,$83
	db $3a,$00,$83,$3a,$00,$83,$36,$00,$83
	db $fd
	dw @song2ch1loop

@song2ch2:
@song2ch2loop:
@ref27:
	db $83,$86,$1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$2c,$83
	db $00,$2c,$83,$00,$2c,$83,$00,$2c,$83,$00,$1e,$83,$00,$1e,$83,$00
	db $1e,$83,$00,$1e,$83,$00,$2c,$83,$00,$2c,$83,$00,$1e,$83,$00,$83
	db $1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$00,$83,$1e,$83,$00,$1e
	db $83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$83,$00,$1e,$83
	db $00,$1e,$83,$00,$28,$83,$00,$2c,$83,$00,$1e,$83,$00,$83
	db $fd
	dw @song2ch2loop

@song2ch3:
@song2ch3loop:
@ref28:
	db $f9,$f9,$87
	db $fd
	dw @song2ch3loop

@song2ch4:
@song2ch4loop:
@ref29:
	db $f9,$f9,$87
	db $fd
	dw @song2ch4loop


@song3ch0:
	db $fb,$06
@song3ch0loop:
@ref30:
	db $f5,$80,$44,$48,$4c,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e
	db $00,$4e,$00,$48,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$44,$00,$44
	db $00,$48,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e
	db $00,$4e,$00,$48,$48,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$44,$00,$44
	db $00,$48,$00,$4e,$00,$56,$56,$00,$58,$56,$83,$00,$84,$6a,$00,$66
	db $00,$60,$00,$66,$00,$80,$52,$52,$00,$56,$4e,$83,$00,$84,$5c,$00
	db $5c,$00,$60,$00,$66,$00,$80,$56,$56,$00,$58,$56,$83,$00,$52,$00
	db $4e,$00,$48,$00,$4e,$00,$52,$00,$56,$00,$4e,$00,$4e,$00,$44,$00
	db $44,$00,$48,$00,$4e,$00,$c3
	db $fd
	dw @song3ch0loop

@song3ch1:
@song3ch1loop:
@ref31:
	db $84,$66,$6e,$6a,$64,$66,$6e,$6a,$64,$66,$6e,$6a,$64,$66,$00,$60
	db $00,$66,$6e,$6a,$64,$66,$6e,$6a,$64,$5c,$00,$5c,$00,$60,$00,$66
	db $00,$66,$6e,$6a,$64,$66,$6e,$6a,$64,$66,$6e,$6a,$64,$66,$00,$60
	db $00,$66,$6e,$6a,$64,$66,$6e,$6a,$64,$66,$5c,$56,$5c,$4e,$00,$83
	db $82,$56,$00,$56,$00,$56,$00,$83,$56,$00,$56,$00,$58,$00,$83,$56
	db $00,$56,$00,$56,$00,$52,$00,$52,$00,$4e,$00,$58,$00,$83,$56,$00
	db $56,$00,$56,$00,$83,$56,$00,$56,$00,$58,$00,$83,$56,$00,$56,$00
	db $56,$00,$52,$00,$52,$00,$4e,$00,$58,$00,$5c,$5c,$00,$60,$5c,$83
	db $00,$84,$64,$00,$60,$00,$58,$00,$56,$00,$82,$58,$58,$00,$5c,$56
	db $83,$00,$84,$56,$00,$56,$00,$58,$00,$56,$00,$82,$5c,$5c,$00,$60
	db $5c,$83,$00,$64,$00,$60,$00,$58,$00,$56,$00,$58,$00,$5c,$00,$56
	db $00,$56,$00,$58,$00,$58,$00,$58,$00,$56,$00,$84,$66,$6e,$6a,$64
	db $66,$6e,$6a,$64,$66,$6e,$6a,$64,$66,$00,$60,$00,$66,$6e,$6a,$64
	db $66,$6e,$6a,$64,$66,$5c,$56,$5c,$4e,$83,$00,$83
	db $fd
	dw @song3ch1loop

@song3ch2:
@song3ch2loop:
@ref32:
	db $f9,$81,$86,$1e,$83,$00,$87,$1e,$83,$00,$87,$1e,$83,$00,$87,$2c
	db $00,$83,$28,$00,$83,$1e,$83,$00,$87,$1e,$83,$00,$87,$1e,$83,$00
	db $87,$2c,$00,$83,$28,$00,$83,$1e,$00,$83,$1e,$00,$83,$28,$00,$83
	db $28,$00,$83,$2c,$00,$83,$1e,$00,$83,$1e,$00,$83,$1e,$00,$83,$1e
	db $00,$83,$1e,$00,$83,$28,$00,$83,$28,$00,$83,$2c,$00,$83,$1e,$00
	db $83,$2c,$83,$00,$1e,$00,$1e,$00,$c3
	db $fd
	dw @song3ch2loop

@song3ch3:
@song3ch3loop:
@ref33:
	db $f9,$f9,$f9,$d1
	db $fd
	dw @song3ch3loop

@song3ch4:
@song3ch4loop:
@ref34:
	db $f9,$f9,$f9,$d1
	db $fd
	dw @song3ch4loop


@song4ch0:
	db $fb,$06
@song4ch0loop:
@ref35:
	db $80,$40,$83,$00,$40,$85,$48,$85,$4e,$85,$58,$95,$52,$8d,$4a,$83
	db $00,$4a,$85,$4e,$85,$52,$85,$4e,$a3,$00
@ref36:
	db $40,$83,$00,$40,$85,$48,$85,$4e,$83,$00,$4e,$95,$44,$8b,$00,$45
	db $49,$4a,$85,$48,$85,$44,$85,$40,$a3,$00
	db $fd
	dw @song4ch0loop

@song4ch1:
@song4ch1loop:
@ref37:
	db $f9,$95
@ref38:
	db $f9,$95
	db $fd
	dw @song4ch1loop

@song4ch2:
@song4ch2loop:
@ref39:
	db $f9,$95
@ref40:
	db $f9,$95
	db $fd
	dw @song4ch2loop

@song4ch3:
@song4ch3loop:
@ref41:
	db $f9,$95
@ref42:
	db $f9,$95
	db $fd
	dw @song4ch3loop

@song4ch4:
@song4ch4loop:
@ref43:
	db $f9,$95
@ref44:
	db $f9,$95
	db $fd
	dw @song4ch4loop


@song5ch0:
	db $fb,$06
@song5ch0loop:
@ref45:
	db $80,$2e,$85,$38,$00,$38,$00,$38,$89,$3d,$41,$43,$4b,$46,$89,$51
	db $4f,$4a,$89,$47,$4b,$47,$41,$46,$87,$00,$46,$85,$4a,$00,$4a,$00
	db $4a,$89,$41,$47,$41,$3d,$38,$89,$3c,$85,$40,$89,$39,$40,$83,$4a
	db $46,$95,$38,$83,$3c,$40,$89,$3c,$00,$3c,$85,$38,$8b,$00
	db $fd
	dw @song5ch0loop

@song5ch1:
@song5ch1loop:
@ref46:
	db $f9,$f9,$93
	db $fd
	dw @song5ch1loop

@song5ch2:
@song5ch2loop:
@ref47:
	db $f9,$f9,$93
	db $fd
	dw @song5ch2loop

@song5ch3:
@song5ch3loop:
@ref48:
	db $f9,$f9,$93
	db $fd
	dw @song5ch3loop

@song5ch4:
@song5ch4loop:
@ref49:
	db $f9,$f9,$93
	db $fd
	dw @song5ch4loop


@song6ch0:
	db $fb,$06
@song6ch0loop:
@ref50:
	db $83,$80,$36,$00,$36,$00,$37,$44,$91,$3d,$41,$45,$3d,$36,$8b,$00
	db $36,$00,$37,$45,$40,$91,$37,$3d,$41,$44,$91,$36,$00,$36,$00,$37
	db $44,$91,$fb,$0e,$3d,$41,$45,$3d,$36,$8b,$00,$36,$00,$37,$45,$40
	db $89,$3d,$36,$85,$32,$85,$36,$91,$44,$00,$45,$4b,$4e,$89,$45,$4a
	db $85,$44,$85,$3d,$36,$8d,$44,$00,$45,$4b,$4e,$89,$4b,$44,$85,$40
	db $85,$44,$8f,$00,$45,$4f,$4b,$44,$89,$3d,$40,$85,$45,$41,$3c,$85
	db $36,$87,$00,$36,$00,$37,$45,$40,$89,$3d,$36,$85,$32,$85,$36,$89
	db $00
	db $fd
	dw @song6ch0loop

@song6ch1:
@song6ch1loop:
@ref51:
	db $f9,$f9,$f9,$f9,$95
	db $fd
	dw @song6ch1loop

@song6ch2:
@song6ch2loop:
	db $ff,$05
	dw @ref51
	db $fd
	dw @song6ch2loop

@song6ch3:
@song6ch3loop:
	db $ff,$05
	dw @ref51
	db $fd
	dw @song6ch3loop

@song6ch4:
@song6ch4loop:
	db $ff,$05
	dw @ref51
	db $fd
	dw @song6ch4loop


@song7ch0:
	db $fb,$06
@song7ch0loop:
@ref55:
	db $80,$37,$41,$48,$83,$00,$49,$45,$40,$85,$45,$41,$3b,$40,$91,$37
	db $41,$48,$85,$41,$49,$4e,$85,$4b,$49,$44,$95,$4f,$4b,$48,$83,$00
	db $49,$45,$40,$85,$45,$49,$4f,$4a,$91,$3b,$39,$36,$85,$3f,$41,$44
	db $85,$49,$45,$40,$93,$00
	db $fd
	dw @song7ch0loop

@song7ch1:
@song7ch1loop:
@ref56:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch1loop

@song7ch2:
@song7ch2loop:
@ref57:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch2loop

@song7ch3:
@song7ch3loop:
@ref58:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch3loop

@song7ch4:
@song7ch4loop:
@ref59:
	db $f9,$f9,$8b
	db $fd
	dw @song7ch4loop


@song8ch0:
	db $fb,$06
@song8ch0loop:
@ref60:
	db $83,$80,$40,$3c,$3b,$40,$00,$40,$00,$41,$44,$41,$00,$83,$3d,$3b
	db $41,$4a,$83,$4e,$52,$83,$00,$83,$52,$00,$53,$40,$00,$41,$52,$00
	db $53,$4e,$00,$83,$4b,$48,$83,$4a,$4e,$83,$52,$4e,$83,$00,$83,$41
	db $3b,$40,$00,$40,$00,$41,$44,$41,$00,$83,$41,$3a,$83,$40,$4a,$83
	db $4e,$52,$89,$40,$00,$41,$54,$00,$54,$00,$54,$00,$55,$52,$00,$83
	db $4f,$4a,$83,$40,$52,$83,$4e,$4a,$83,$00
@ref61:
	db $83,$40,$3c,$3a,$40,$83,$4b,$3a,$00,$3a,$41,$00,$83,$3d,$3b,$41
	db $4b,$4f,$52,$83,$00,$83,$40,$00,$41,$52,$00,$52,$00,$52,$00,$52
	db $4f,$00,$83,$4b,$49,$4b,$4f,$53,$4e,$89,$40,$3c,$3b,$40,$00,$40
	db $00,$41,$45,$40,$00,$40,$83,$3c,$3b,$41,$4a,$83,$4e,$52,$83,$00
	db $40,$00,$40,$00,$41,$54,$00,$54,$00,$54,$00,$54,$53,$00,$52,$83
	db $4e,$4a,$83,$40,$52,$83,$4e,$4a,$89,$00,$81
	db $fd
	dw @song8ch0loop

@song8ch1:
@song8ch1loop:
@ref62:
	db $f9,$f9,$8b
@ref63:
	db $f9,$f9,$93
	db $fd
	dw @song8ch1loop

@song8ch2:
@song8ch2loop:
@ref64:
	db $f9,$f9,$8b
@ref65:
	db $f9,$f9,$93
	db $fd
	dw @song8ch2loop

@song8ch3:
@song8ch3loop:
@ref66:
	db $f9,$f9,$8b
@ref67:
	db $f9,$f9,$93
	db $fd
	dw @song8ch3loop

@song8ch4:
@song8ch4loop:
@ref68:
	db $f9,$f9,$8b
@ref69:
	db $f9,$f9,$93
	db $fd
	dw @song8ch4loop


@song9ch0:
	db $fb,$06
@song9ch0loop:
@ref70:
	db $83,$80,$41,$49,$4e,$00,$4e,$83,$52,$4f,$49,$40,$83,$44,$48,$00
	db $49,$45,$41,$44,$83,$00,$83,$41,$49,$4e,$00,$4e,$83,$52,$4f,$49
	db $40,$85,$48,$00,$49,$44,$83,$3e,$40,$83,$00,$83,$41,$49,$4e,$00
	db $4e,$83,$52,$4e,$00,$4f,$48,$83,$40,$48,$00,$49,$44,$83,$40,$44
	db $83,$00,$83,$41,$49,$4e,$00,$4e,$83,$52,$4e,$83,$48,$40,$83,$44
	db $48,$00,$49,$44,$00,$45,$40,$83,$00,$83
@ref71:
	db $40,$83,$00,$40,$85,$4b,$52,$89,$4e,$00,$4f,$49,$41,$44,$83,$00
	db $83,$41,$49,$4e,$00,$4e,$83,$52,$4e,$48,$83,$40,$83,$44,$48,$00
	db $49,$44,$00,$45,$40,$83,$00
	db $fd
	dw @song9ch0loop

@song9ch1:
@song9ch1loop:
@ref72:
	db $f9,$f9,$8f
@ref73:
	db $f7
	db $fd
	dw @song9ch1loop

@song9ch2:
@song9ch2loop:
@ref74:
	db $f9,$f9,$8f
@ref75:
	db $f7
	db $fd
	dw @song9ch2loop

@song9ch3:
@song9ch3loop:
@ref76:
	db $f9,$f9,$8f
@ref77:
	db $f7
	db $fd
	dw @song9ch3loop

@song9ch4:
@song9ch4loop:
@ref78:
	db $f9,$f9,$8f
@ref79:
	db $f7
	db $fd
	dw @song9ch4loop
