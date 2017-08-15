
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

MENU_LOOP
	CALL DrawMenu

	HALT	; sync before update Board
	
	LD IX, BOARD1
	CALL BoardUpdateAll
	
	; ;FORCED FOR NOW
	; LD D, (IX+BRD_POS_Y)	; Start Position Y
	; LD E, (IX+BRD_POS_X)	; Start Position X
	; LD H, (IX+BRD_BUF_H)	; Col Buffer
	; LD L, (IX+BRD_BUF_L)	; Col Buffer
	; CALL BoardDrawCol

	; ;FORCED FOR NOW
	; LD	D, (IX+BRD_POS_Y)	; Start Position Y
	; LD	E, (IX+BRD_POS_X)	; Start Position X
	; CALL BoardColNextPos
	
	; LD H, (IX+BRD_BUF_H)	; Col Buffer
	; LD L, (IX+BRD_BUF_L)	; Col Buffer
	; CALL BoardColNextBuf

	; CALL BoardDrawCol

	
	LD IX, BOARD2
	CALL BoardUpdateAll
		
	; ; FORCED FOR NOW
	; LD D, (IX+BRD_POS_Y)	; Start Position Y
	; LD E, (IX+BRD_POS_X)	; Start Position X
	; LD H, (IX+BRD_BUF_H)	; Col Buffer
	; LD L, (IX+BRD_BUF_L)	; Col Buffer
	; CALL BoardDrawCol

	; ; FORCED FOR NOW
	; LD	D, (IX+BRD_POS_Y)	; Start Position Y
	; LD	E, (IX+BRD_POS_X)	; Start Position X
	; CALL BoardColNextPos
	
	; LD H, (IX+BRD_BUF_H)	; Col Buffer
	; LD L, (IX+BRD_BUF_L)	; Col Buffer
	; CALL BoardColNextBuf

	; CALL BoardDrawCol

	
	LD IX, BOARD1
	
	CALL InjectLine1
	CALL InjectLine2
	
	LD IX, BOARD2
		
	CALL InjectLine2
	CALL InjectLine1

		
    JP MENU_LOOP ;MENU_PLAY
;RET

InjectLine1
	LD H, (IX+BRD_BUF_H)
	LD L, (IX+BRD_BUF_L)

	LD A, 1	; RED
	PUSH HL	
		CALL BoardColInject
	POP HL
	
	CALL BoardColNextBuf

	LD	A, 2	; GREEN
	PUSH HL
		CALL	BoardColInject
	POP HL

	CALL BoardColNextBuf

	LD	A, 3	; CYAN
	PUSH HL
		CALL	BoardColInject
	POP HL

	CALL BoardColNextBuf

	LD	A, 4	; Yeloow
	PUSH HL
		CALL	BoardColInject
	POP HL

RET


InjectLine2
	LD H, (IX+BRD_BUF_H)
	LD L, (IX+BRD_BUF_L)

	LD	A, 4	; Yeloow
	PUSH HL	
		CALL BoardColInject
	POP HL
	
	CALL BoardColNextBuf

	LD	A, 3	; CYAN
	PUSH HL
		CALL	BoardColInject
	POP HL

	CALL BoardColNextBuf

	LD	A, 2	; GREEN
	PUSH HL
		CALL	BoardColInject
	POP HL

	CALL BoardColNextBuf

	LD A, 1	; RED
	PUSH HL
		CALL	BoardColInject
	POP HL
RET

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
