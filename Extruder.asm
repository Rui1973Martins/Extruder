
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

	CALL GameInit_Versus
	CALL GameInitDraw_Versus; 	FULL_GAME

	LD	IX, BOARD1
	LD	A, 8
	CALL BoardAddLineTotal

	LD	IX, BOARD2
	LD	A, 8
	CALL BoardAddLineTotal

	CALL DrawMenu
	
	;Set Border
	LD A,BLACK
	OUT (ULA),A
	
MENU_LOOP
	HALT	; sync before update Board
	
	LD IX, BOARD1
	CALL BoardUpdateAll
		
	LD IX, BOARD2
	CALL BoardUpdateAll
	
	
	LD IX, BOARD1
	CALL BoardDrawCursor

	LD IX, BOARD2
	CALL BoardDrawCursor


	CALL WaitPressAnyKey
	

	LD	IX, BOARD1
	LD	DE, BOARD_PATTERN1
	CALL	BoardInjectLine
	
	LD IX, BOARD2
	LD	DE, BOARD_PATTERN_MAGICIAN
	CALL	BoardInjectLine

		
    JP MENU_LOOP ;MENU_PLAY
;RET


WaitPressAnyKey
	; Press AnyKey
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !

	RET NZ
	JR WaitPressAnyKey


GameInit_Versus
	; Player 1
	LD IX, BOARD1
	LD BC, #0B07	; H x W
	LD DE, BOARD1_DATA
	CALL BoardInit

	; Player 2
	LD IX, BOARD2
	LD BC, #0B07	; H x W
	LD DE, BOARD2_DATA
	CALL BoardInit	
RET

GameInitDraw_Versus

	LD IX, BOARD1
	CALL BoardInitDraw

	LD IX, BOARD2
	CALL BoardInitDraw
	
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
	
;	LD A,WHITE
;	CALL CLSC
;	CALL CLS0
	
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
