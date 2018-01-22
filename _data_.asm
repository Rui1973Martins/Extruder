
include "_REF_\COLORS.asm"

ORG #A000

; NOTE: Bubbles, must be 256 bytes aligned
include "_DATA_\Bubbles.asm"
include "_DATA_\Arrow.asm"

ClownAnimator1_TAB
	DEFW	ClownIdleAnimator1_win		; WIN
	DEFW	ClownIdleAnimFrames			; WIN FRAMES TAB

	DEFW	ClownLoseAnimator1			; LOSE
	DEFW	ClownLoseAnimFrames			; LOSE FRAMES TAB

	DEFW	ClownIdleAnimator1_running	; RUNNING
	DEFW	ClownIdleAnimFrames			; RUNNING FRAMES TAB

ClownAnimator2_TAB
	DEFW	ClownIdleAnimator2_win		; WIN
	DEFW	ClownIdleAnimFrames			; WIN FRAMES TAB

	DEFW	ClownLoseAnimator2			; LOSE
	DEFW	ClownLoseAnimFrames			; LOSE FRAMES TAB

	DEFW	ClownIdleAnimator2_running	; RUNNING
	DEFW	ClownIdleAnimFrames			; RUNNING FRAMES TAB

;include "_DATA_\Clown.asm"
include "_DATA_\ClownIdle.asm"
include "_DATA_\ClownErase.asm"
include "_DATA_\ClownLose.asm"
include "_DATA_\Char-Tiles.asm"

TextTilesTab
		DEFW	#0000
TT00	EQU	1
		DEFW	TilesText00
TT01	EQU	2
		DEFW	TilesText01
TT02	EQU	3
		DEFW	TilesText02
TT03	EQU	4
		DEFW	TilesText03
TT04	EQU	5
		DEFW	TilesText04
TT05	EQU	6
		DEFW	TilesText05
TT06	EQU	7
		DEFW	TilesText06
TT07	EQU	8
		DEFW	TilesText07
TT08	EQU	9
		DEFW	TilesText08
TT09	EQU	10
		DEFW	TilesText09
TT10	EQU	11
		DEFW	TilesText10
TT11	EQU	12
		DEFW	TilesText11
TT12	EQU	13
		DEFW	TilesText12
TT13	EQU	14
		DEFW	TilesText13
TT14	EQU	15
		DEFW	TilesText14
TT15	EQU	16
		DEFW	TilesText15
TT16	EQU	17
		DEFW	TilesText16
TT17	EQU	18
		DEFW	TilesText17
TT18	EQU	19
		DEFW	TilesText18
TT19	EQU	20
		DEFW	TilesText19
TT20	EQU	21
		DEFW	TilesText20
TT21	EQU	22
		DEFW	TilesText21
TT22	EQU	23
		DEFW	TilesText22


WinTextTabRLE
	; DEFB -2
	; DEFW Blit0
	; DEFB TT00,TT01,TT02,TT03,TT04,TT05,TT06,TT07,TT08,TT09,-22,0	;REF Line ;10
	; DEFB -32, 0
	DEFB TT00,-3,0,TT00,0,TT06,-25,0								;Char Line 1 ; 7
	DEFB TT01,-3,0,TT01,-3,0,TT00,TT07,TT08,-21,0					;Char Line 2 ;11
	DEFB TT01,0,TT00,0,TT01,0,TT00,0,TT01,0,TT01,-21,0				;Char Line 3 ;11
	DEFB TT01,0,TT01,0,TT01,0,TT01,0,TT01,0,TT01,-21,0				;Char Line 4 ;11
	DEFB TT02,TT03,TT04,TT03,TT05,0,TT09,0,TT09,0,TT09,-21,0		;Char Line 5 ;11
	DEFB -1

LoseTextTabRLE
	; DEFB -2
	; DEFW Blit0
	; DEFB TT10,TT11,TT12,TT13,TT14,TT15,TT16,TT17,TT18,TT19,TT20,TT21,TT22,-20,0	;REF Line ;12
	; DEFB -32, 0
	DEFB TT10,0,0,TT16,TT18,TT19,0,TT16,TT15,0,TT16,TT15,-20,0		;Char Line 1 ;12
	DEFB TT11,0,0,TT11,0,TT11,0,TT11,0,0,TT11,-21,0					;Char Line 2 ;11
	DEFB TT11,0,0,TT11,0,TT11,0,TT12,TT19,0,TT22,TT15,-20,0			;Char Line 3 ;12
	DEFB TT11,0,0,TT11,0,TT11,0,0,TT11,0,TT11,-21,0					;Char Line 4 ;11
	DEFB TT14,TT15,0,TT12,TT18,TT13,0,TT17,TT13,0,TT14,TT15,-20,0	;Char Line 5 ;12
	DEFB -1

include "_DATA_\TilesText.asm"
