
include "_REF_\REF.asm"
include "_REF_\KEYBOARD.asm"

	
ORG #6000
JP MENU_ENTRY

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
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F	; Test only keys (5 bits)
	CP #1F	; If Not Zero, some key was pressed !

	RET NZ
	
JP Menu_REPAINT



; ===== MENU =====

MENU_ENTRY

	HALT
	
	LD A,BLACK
	OUT (ULA),A

	; Clear Screen (Black on Black)
	LD A, BLACK<<3 + BLACK	; BLACK INK on BLACK PAPER
	CALL CLSC
	CALL CLS0
	
	CALL DrawMenu

	; Read First Row (12345)
	LD BC, KBRD15
	IN A,(C)
	OR #E0			;Set Bits765

	CP KEY1
	JP Z, MENU_PLAY1

	CP KEY2
	JP Z, MENU_PLAY2
	
	JP MENU_ENTRY
	
MENU_PLAY1

	CALL PLAY1
	CALL WaitNoKeyPressed

	JP MENU_ENTRY
	
MENU_PLAY2

	CALL PLAY2
	CALL WaitNoKeyPressed
	
    JP MENU_ENTRY
;RET


WaitPressAnyKey
	; Press AnyKey
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !

	RET NZ
	JR WaitPressAnyKey

WaitNoKeyPressed
	; Press AnyKey
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !

	RET Z
	JR WaitNoKeyPressed


; ===== 1 Player Init =====

GameInitWithAnim_1Player
	; Player 1
	LD	A, DEVIL
	LD IX, BOARD1
	LD BC, #0B0D	; H x W
	LD DE, BOARD1_DATA
	LD HL, #0818	; Y = 8, X = 24
		CALL BoardInit

	LD	A, 7
		CALL BoardAddLineTotal

GameDropAnim_1Player
	CALL BoardsResetDropAnim
	
	JP PLAY1_DROP_ANIM

PLAY1_DROP_ANIM_NEXT

	CALL BoardsNextDropAnimLine

PLAY1_DROP_ANIM
	
	LD A, BLACK
	OUT (ULA),A

	HALT 

	LD A, CYAN
	OUT (ULA),A

	LD IX, BOARD1
		CALL BoardDropAnimLineColor

	LD A, BLUE
	OUT (ULA),A

		CALL BoardDropAnimLinePixels

	JP NZ, PLAY1_DROP_ANIM_NEXT
RET


;DEPRECATED
GameInitDraw_1Player

	LD IX, BOARD1
		CALL BoardInitDraw
	
	JP WaitPressAnyKey
;RET


; ===== 2 Players =====

GameInitWithAnim_2Players
	; Player 1
	LD	A, JUSTICE
	LD IX, BOARD1
	LD BC, #0B07	; H x W
	LD DE, BOARD1_DATA
	LD HL, #0800	; Y = 8, X = 0
		CALL BoardInit

	LD	A, 9	;5
		CALL BoardAddLineTotal

	; Player 2
	LD	A, MAGICIAN
	LD IX, BOARD2
	LD BC, #0B07	; H x W
	LD DE, BOARD2_DATA
	LD HL, #0890	; Y = 8, X = 144
		CALL BoardInit	

	LD	A, 9	;5
		CALL BoardAddLineTotal

GameDropAnim_2Players
	CALL BoardsResetDropAnim
	
	JP PLAY2_DROP_ANIM
	
PLAY2_DROP_ANIM_NEXT

	CALL BoardsNextDropAnimLine

PLAY2_DROP_ANIM

	LD A, BLACK
	OUT (ULA),A

	HALT 
	
	LD A, CYAN
	OUT (ULA),A

	LD IX, BOARD1
		CALL BoardDropAnimLineColor
	LD IX, BOARD2
		CALL BoardDropAnimLineColor

	LD A, BLUE
	OUT (ULA),A

	LD IX, BOARD1
		CALL BoardDropAnimLinePixels
	LD IX, BOARD2
		CALL BoardDropAnimLinePixels
	
	JP NZ, PLAY2_DROP_ANIM_NEXT
RET


;DEPRECATED
GameInitDraw_2Players

	LD IX, BOARD1
		CALL BoardInitDraw

	LD IX, BOARD2
		CALL BoardInitDraw
	
	JP WaitPressAnyKey
;RET



ORG #8000

	
include "_LIB_\ClearScreen.asm"
include "_LIB_\Screen.asm"

; ===== Single Player Game Loop =====
PLAY1
	; Clear Screen (Black on Black)
	LD A, BLACK<<3 + BLACK	; BLACK INK on BLACK PAPER
	CALL CLSC
	CALL CLS0

	CALL GameInitWithAnim_1Player
	

	; ;Add Extra line from time to time (use a frameTimer)	
	; ;LD	IX, BOARD1
	; LD	A, 1
	; CALL BoardAddLineTotal
	
PLAY1_LOOP

	LD A,BLACK
	OUT (ULA),A

	HALT	; sync before update Board
	
	LD A, RED
	OUT (ULA),A

		LD IX, BOARD1
		CALL BoardUpdateAll

	LD A, YELLOW
	OUT (ULA),A

		;LD A, ; BRD_ANIM_STATE

		LD IX, BOARD1
		CALL BoardStepAnim
		CALL BoardDrawCursor

	
;	CALL WaitPressAnyKey
	
	LD	IX, BOARD1
	LD	DE, BOARD_PATTERN_SINGLE
	CALL	BoardInjectLine


	; Press SPACE to LEAVE
	LD BC, KBRDBS ; Read Last Row Right (B,N,M,SS,Space)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYSP
	RET Z
	
    JP PLAY1_LOOP
;RET


; ===== Dual Player Game Loop =====
PLAY2
	; Clear Screen (Black on Black)
	LD A, BLACK<<3 + BLACK	; BLACK INK on BLACK PAPER
	CALL CLSC
	CALL CLS0

	CALL GameInitWithAnim_2Players

	
	; ;Add Extra line from time to time (use a frameTimer)	
	; LD	IX, BOARD1
	; LD	A, 1
	; CALL BoardAddLineTotal

	; LD	IX, BOARD2
	; LD	A, 1
	; CALL BoardAddLineTotal
	
PLAY2_LOOP

	LD A, BLACK
	OUT (ULA),A

	HALT	; sync before update Board
	
	LD A, RED
	OUT (ULA),A

		LD IX, BOARD1
		CALL BoardUpdateAll
		
	LD A, MAGENTA
	OUT (ULA),A

		LD IX, BOARD2
		CALL BoardUpdateAll
	
	
	LD A, YELLOW
	OUT (ULA),A

		;LD A, ; BRD_ANIM_STATE

		LD IX, BOARD1
		CALL BoardStepAnim
		CALL BoardDrawCursor

	LD A, WHITE
	OUT (ULA),A

		LD IX, BOARD2
		CALL BoardStepAnim
		CALL BoardDrawCursor


;	CALL WaitPressAnyKey
	

	LD	IX, BOARD1
	LD	DE, BOARD_PATTERN_DUAL	;BOARD_PATTERN1
	CALL	BoardInjectLine
	
	LD IX, BOARD2
	LD	DE, BOARD_PATTERN_DUAL	;BOARD_PATTERN_MAGICIAN
	CALL	BoardInjectLine


	; Press SPACE to LEAVE
	LD BC, KBRDBS ; Read Last Row Right (B,N,M,SS,Space)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYSP
	RET Z
		
    JP PLAY2_LOOP
;RET

include "Board.asm"

ORG #A000

include "_DATA_.symbol"
incbin "_DATA_.bin"

include "BoardVars.asm"
