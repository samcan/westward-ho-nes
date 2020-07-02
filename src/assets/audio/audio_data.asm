;this file for FamiTone2 library generated by text2data tool

audio_data_music_data:
	db 4
	dw @instruments
	dw @samples-3
	dw @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4,256,213
	dw @song1ch0,@song1ch1,@song1ch2,@song1ch3,@song1ch4,256,213
	dw @song2ch0,@song2ch1,@song2ch2,@song2ch3,@song2ch4,307,256
	dw @song3ch0,@song3ch1,@song3ch2,@song3ch3,@song3ch4,307,256

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
	db $fb,$09,$80,$32,$00,$32,$83,$3c,$83,$40,$83,$44,$89,$3c,$3a,$36
	db $83,$47,$00,$47,$00,$46,$89,$45,$47,$4a,$89,$3c,$00,$3c,$00,$3c
	db $83,$3a,$83,$3c,$83,$40,$99,$32,$00,$32,$83,$3c,$83,$40,$83,$44
	db $89,$3c,$3a,$36,$83,$47,$00,$47,$00,$46,$89,$46,$00,$46,$00,$46
	db $00,$44,$85,$41,$3d,$3a,$83,$3c,$83,$40,$83,$3c,$97,$4a,$87,$46
	db $83,$44,$83,$40,$83,$44,$8b,$33,$00,$32,$83,$3c,$83,$00,$3c,$00
	db $3c,$00,$3c,$83,$3a,$83,$3c,$83,$40,$8f,$32,$00,$32,$83,$3c,$83
	db $40,$83,$44,$89,$3c,$3a,$36,$83,$47,$00,$47,$00,$46,$85,$46,$00
	db $46,$00,$44,$83,$41,$3c,$83,$3b,$3d,$41,$3c,$93
	db $fd
	dw @song0ch0loop

@song0ch1:
@song0ch1loop:
@ref1:
	db $f9,$f9,$f9,$f9,$95
	db $fd
	dw @song0ch1loop

@song0ch2:
@song0ch2loop:
	db $ff,$05
	dw @ref1
	db $fd
	dw @song0ch2loop

@song0ch3:
@song0ch3loop:
	db $ff,$05
	dw @ref1
	db $fd
	dw @song0ch3loop

@song0ch4:
@song0ch4loop:
	db $ff,$05
	dw @ref1
	db $fd
	dw @song0ch4loop


@song1ch0:
	db $fb,$06
@song1ch0loop:
@ref5:
	db $fb,$10,$80,$3a,$44,$44,$48,$4c,$44,$4c,$48,$3a,$44,$44,$48,$4c
	db $45,$42,$3a,$44,$44,$48,$4c,$4e,$4c,$48,$44,$42,$3a,$3e,$42,$44
	db $45,$00,$3e,$42,$3e,$3a,$3e,$42,$45,$3a,$3e,$3a,$36,$35,$3a,$00
	db $3e,$42,$3e,$3a,$3e,$42,$44,$3e,$3a,$44,$42,$48,$44,$83,$00,$81
	db $fd
	dw @song1ch0loop

@song1ch1:
@song1ch1loop:
@ref6:
	db $82,$3a,$34,$34,$36,$3a,$34,$3a,$36,$36,$34,$34,$36,$3a,$35,$36
	db $36,$34,$34,$36,$3a,$3e,$3e,$3e,$3e,$3a,$3a,$36,$36,$34,$35,$00
	db $36,$3a,$36,$34,$36,$3a,$3f,$34,$36,$34,$30,$2d,$34,$00,$36,$3a
	db $36,$34,$36,$3a,$3e,$36,$34,$34,$36,$36,$34,$83,$00,$81
	db $fd
	dw @song1ch1loop

@song1ch2:
@song1ch2loop:
@ref7:
	db $86,$22,$2c,$00,$22,$00,$2c,$00,$22,$00,$2c,$00,$22,$00,$2c,$00
	db $22,$00,$2c,$00,$2c,$00,$1e,$00,$1e,$00,$22,$00,$22,$00,$2c,$00
	db $2c,$00,$1e,$00,$1e,$00,$1e,$00,$1e,$00,$2c,$00,$2c,$00,$2c,$00
	db $2c,$00,$1e,$00,$1e,$00,$1e,$00,$1e,$00,$22,$00,$22,$00,$2c,$00
	db $2c,$00,$81
	db $fd
	dw @song1ch2loop

@song1ch3:
@song1ch3loop:
@ref8:
	db $f9,$89
	db $fd
	dw @song1ch3loop

@song1ch4:
@song1ch4loop:
@ref9:
	db $f9,$89
	db $fd
	dw @song1ch4loop


@song2ch0:
	db $fb,$06
@song2ch0loop:
@ref10:
	db $fb,$07,$80,$5c,$00,$5c,$00,$5c,$00,$56,$00,$5c,$00,$60,$00,$5c
	db $00,$56,$00,$83,$56,$00,$52,$87,$00,$56,$00,$52,$83,$00,$5c,$00
	db $5c,$00,$5c,$00,$56,$00,$5c,$00,$60,$00,$5c,$00,$56,$00,$83,$52
	db $83,$00,$56,$00,$52,$00,$4e,$83,$00,$83,$4f,$00,$4e,$56,$00,$5c
	db $00,$66,$87,$00,$83,$61,$00,$60,$66,$00,$60,$00,$5c,$87,$00,$56
	db $58,$5c,$00,$5c,$00,$56,$00,$5c,$00,$60,$00,$5c,$00,$56,$83,$00
	db $52,$00,$56,$58,$56,$00,$52,$00,$4e,$83,$00,$83
	db $fd
	dw @song2ch0loop

@song2ch1:
@song2ch1loop:
@ref11:
	db $f9,$f9,$87
	db $fd
	dw @song2ch1loop

@song2ch2:
@song2ch2loop:
@ref12:
	db $f9,$f9,$87
	db $fd
	dw @song2ch2loop

@song2ch3:
@song2ch3loop:
@ref13:
	db $f9,$f9,$87
	db $fd
	dw @song2ch3loop

@song2ch4:
@song2ch4loop:
@ref14:
	db $f9,$f9,$87
	db $fd
	dw @song2ch4loop


@song3ch0:
	db $fb,$06
@song3ch0loop:
@ref15:
	db $fb,$08,$f5,$80,$44,$48,$4c,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e
	db $00,$4e,$00,$4e,$00,$48,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$44
	db $00,$44,$00,$48,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$4e
	db $00,$4e,$00,$4e,$00,$48,$48,$4e,$00,$4e,$00,$4e,$00,$4e,$00,$44
	db $00,$44,$00,$48,$00,$4e,$00,$56,$56,$00,$58,$56,$83,$00,$84,$6a
	db $00,$66,$00,$60,$00,$66,$00,$80,$52,$52,$00,$56,$4e,$83,$00,$84
	db $5c,$00,$5c,$00,$60,$00,$66,$00,$80,$56,$56,$00,$58,$56,$83,$00
	db $52,$00,$4e,$00,$48,$00,$4e,$00,$52,$00,$56,$00,$4e,$00,$4e,$00
	db $44,$00,$44,$00,$48,$00,$4e,$00,$c3
	db $fd
	dw @song3ch0loop

@song3ch1:
@song3ch1loop:
@ref16:
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
@ref17:
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
@ref18:
	db $f9,$f9,$f9,$d1
	db $fd
	dw @song3ch3loop

@song3ch4:
@song3ch4loop:
@ref19:
	db $f9,$f9,$f9,$d1
	db $fd
	dw @song3ch4loop
