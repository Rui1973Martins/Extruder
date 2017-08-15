
include "_REF_\REF.asm"
include "_REF_\KEYBOARD.asm"

	
ORG #6000
JP MENU_ENTRY

include "_LIB_\ClearScreen.asm"
include "_LIB_\Screen.asm"

MENU_ENTRY

	HALT
	
	;Set Border
	LD A,BLACK
	OUT (ULA),A

	; Clear Screen (Black on Black)
	LD A, BLACK<<3 + BLACK	; BLACK on  BLACK
	CALL CLSC
	CALL CLS0

MENU_PLAY
	CALL DrawMenu

	CALL MAIN_ENTRY; 	FULL_GAME

    JP MENU_ENTRY ;MENU_PLAY
;RET


WaitPressAnyKey
	; Press AnyKey
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !

	RET NZ
	JR WaitPressAnyKey


MAIN_ENTRY

	LD HL, BOARD1
	LD DE, #0B07	; H x W
	LD BC, BOARD1_DATA
	
	CALL BoardInit
	LD IX, BOARD1
	CALL BoardDraw

	HALT

	LD HL, BOARD2
	LD DE, #0B07	; H x W
	LD BC, BOARD2_DATA
	
	CALL BoardInit	
	LD IX, BOARD2
	CALL BoardDraw

	HALT
	
	JP WaitPressAnyKey
;RET

DrawCredits

	HALT

	LD A,BLACK
	OUT (ULA),A

	; Press AnyKey
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !

	JP Z, DrawCredits

RET


borderCounter DEFB BLACK

DrawMenu

	HALT
	
	LD A,WHITE
	CALL CLSC
	CALL CLS0
	
Menu_REPAINT

		; LD HL, borderCounter
		; DEC (HL)

		; JP NC, Menu_PAINT
			; LD (HL), WHITE

	LD HL, borderCounter
	INC (HL)

	JP NC, Menu_PAINT
		LD (HL), BLACK
		
Menu_PAINT
	HALT

	LD A,(borderCounter)
	OUT (ULA),A
	; Do some drawing

	; Press AnyKey
	XOR A
	IN A,(ULA)	; Read All Keys - Check for nay Key pressed
	AND #1F	; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !

	RET NZ
	
JP Menu_REPAINT


ORG #8000
include "Board.asm"

ORG #A000

include "_DATA_.symbol"
incbin "_DATA_.bin"

include "BoardVars.asm"
