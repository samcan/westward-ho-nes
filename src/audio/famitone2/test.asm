;this file for FamiTone2 library generated by text2data tool

test_music_data:
	db 1
	dw @instruments
	dw @samples-3
	dw @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4,307,256

@instruments:
	db $30 ;instrument $00
	dw @env1,@env0,@env0
	db $00

@samples:
@env0:
	db $c0,$00,$00
@env1:
	db $c9,$00,$00


@song0ch0:
	db $fb,$06
@song0ch0loop:
@ref0:
	db $80,$32,$38,$41,$00,$81
	db $fd
	dw @song0ch0loop

@song0ch1:
@song0ch1loop:
@ref1:
	db $8b
	db $fd
	dw @song0ch1loop

@song0ch2:
@song0ch2loop:
@ref2:
	db $8b
	db $fd
	dw @song0ch2loop

@song0ch3:
@song0ch3loop:
@ref3:
	db $8b
	db $fd
	dw @song0ch3loop

@song0ch4:
@song0ch4loop:
@ref4:
	db $8b
	db $fd
	dw @song0ch4loop
