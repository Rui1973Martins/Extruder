
include "_REF_\REF.asm"
include "_REF_\KEYBOARD.asm"

include "Macros.asm"
	
ORG #6000
JP MENU_ENTRY

borderCounter DEFB BLACK

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

DrawMenu

	HALT
	
;	LD A,WHITE
;	CALL CLSC
;	CALL CLS0

Menu_REPAINT

	HALT

	LD A, BLACK
	OUT (ULA), A


		; LD HL, borderCounter
		; DEC (HL)

		; JP NC, Menu_PAINT
			; LD (HL), WHITE

	LD HL, borderCounter
	INC (HL)

	JP NC, Menu_PAINT
		LD (HL), BLACK

Menu_PAINT

	; LD A, RED
	; OUT (ULA), A

	; WAIT so that we can draw, at the right moment to avoid flicker
	LD	BC, 0xF205
Menu_WAIT0
	DJNZ Menu_WAIT0
	DEC C
	JP NZ, Menu_WAIT0

	; Control Speed of Animation
	LD A,(borderCounter)
	AND	0x03
	XOR	0x02
	JP NZ, NON_multiple

	; LD A, WHITE
	; OUT (ULA), A

		; Clear TOP BAND of 5 lines of screen
			LD HL, ATTR
			LD DE, ATTR+1
			LD A, WHITE
			LD (HL), A

			LD BC, 32*5-1
			LDIR

	; LD A, GREEN
	; OUT (ULA), A
	
		CALL	RollDraw

NON_multiple
	LD A, BLACK
	OUT (ULA), A

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

;	HALT

	; LD A,(borderCounter)
	; OUT (ULA),A
	
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
	LD	A, FOOL
	LD IX, BOARD1
	LD BC, #0B0D	; H x W
	LD DE, BOARD1_DATA
	LD HL, #0818	; Y = 8, X = 24
		CALL BoardInit

	LD	A, BRD_FLAG_WRAP
		CALL BoardSetFlags

	LD	A, 7
		CALL BoardAddLineTotal

GameDropAnim_1Player

;###############################
;     Animation Logic STEPS
;###############################

; Counters
;	E	Brd
;-------------------------------
;			HALT
;	1	0		EDGE PX
;			HALT
;	1			EDGE CL
;	2			INC EDGE
;			HALT
;		0		; BRD PX odd - Do nothing
;		0		; INC BRD - DO nothing
; GOTO JUMP START
;			HALT
;	2			EDGE PX
;			HALT
;		0		BRD CL even
;	2			EDGE CL
;	3			INC EDGE
;	;------------------------------- LOOP Start
;			HALT
;		0		BRD PX even
;		1		INC BRD
;			HALT
;	3			EDGE PX
;			HALT
;		1		BRD CL odd
;	3			EDGE CL
;	4			INC EDGE
;			HALT
;		1		BRD PX odd
;		2		INC BRD
; JUMP START
;			HALT
;	4			EDGE PX
;			HALT
;		2		BRD CL even
;	4			EDGE CL
;	5			INC EDGE
;	;------------------------------- LOOP End, NOTE: Must end on BRD even



; Implementation
;-------------------------------
			BOARDS_DROP_BRD_ANIM_Reset
			BOARDS_DROP_EDGE_ANIM_Reset

;	E	Brd
			HALT
;	1	0		EDGE PX
					CALL_DROP_EDGE_ANIM_PIXELS
			HALT
;		0		; BRD CL odd - Do nothing
;	1			EDGE CL
					CALL_DROP_EDGE_ANIM_COLOR
;	1			INC EDGE
					BOARDS_DROP_EDGE_ANIM_NextLine

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

			HALT
;				; BRD PX odd - Do nothing
;		0		; INC BRD - DO nothing
; GOTO JUMP START
			JR	PLAY1_JUMP_START
;			HALT
;	1			EDGE PX
;			HALT
;		0		BRD CL even
;	1			EDGE CL
;	2			INC EDGE
;	;------------------------------- LOOP Start
PLAY1_DROP_ANIM_NEXT

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

			HALT
;		0		BRD PX even
					CALL_DROP_BRD_ANIM_PIXELS_EVEN
;		1		INC BRD
					BOARDS_DROP_BRD_ANIM_NextLine

			; Check for End of Board HEIGHT
				LD	B, (IX+BRD_HEIGHT)			; Height
				SLA	B							; Multiply by 2 (using half Ball height)
					DEC	B
				LD	A, (BOARDS_DROP_ANIM_CNT)	
				CP	B
				RET	Z
		
			HALT
;	3			EDGE PX
					CALL_DROP_EDGE_ANIM_PIXELS
			HALT
;		1		BRD CL odd
					CALL_DROP_BRD_ANIM_COLOR_ODD
;	3			EDGE CL
					CALL_DROP_EDGE_ANIM_COLOR
;	4			INC EDGE
					BOARDS_DROP_EDGE_ANIM_NextLine

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

			HALT
;		1		BRD PX odd
					CALL_DROP_BRD_ANIM_PIXELS_ODD
;		2		INC BRD
					BOARDS_DROP_BRD_ANIM_NextLine

PLAY1_JUMP_START

			HALT
;	4			EDGE PX
					CALL_DROP_EDGE_ANIM_PIXELS
					
			HALT
;		2		BRD CL even
					CALL_DROP_BRD_ANIM_COLOR_EVEN
;	4			EDGE CL
					CALL_DROP_EDGE_ANIM_COLOR
;	5			INC EDGE
					BOARDS_DROP_EDGE_ANIM_NextLine

			; ; Check for End of Board HEIGHT
			; LD	B, (IX+BRD_HEIGHT)			; Height
			; SLA	B							; Multiply by 2 (using half Ball height)
			; LD	A, (BOARDS_DROP_EDGE_ANIM_CNT)	
			; CP	B
		; JP NZ, PLAY1_DROP_ANIM_NEXT
		JP PLAY1_DROP_ANIM_NEXT
;	;------------------------------- LOOP End, NOTE: Must end on BRD even	
;RET


;DEPRECATED
GameInitDraw_1Player

	LD IX, BOARD1
		CALL BoardInitDraw
	
	JP WaitPressAnyKey
;RET



;--------------------
GameEnd_2Players
;--------------------

	LD	IX, BOARD1
	LD	A, (IX+BRD_GAME_STATE)
	CP	GAME_STATE_LOST
	JP	NZ, GameEnd_2P_CheckP2

	; Player 1 LOST

	; Check if Player 2 Also Lost
	LD	IX, BOARD2
	LD	A, (IX+BRD_GAME_STATE)
	CP	GAME_STATE_LOST
	JP	Z, GameDraw

; FALLTROUGH

;--------------------
GameLost_1Player
;--------------------
	LD IX, BOARD1

	CALL GameLost
	
	; CALL CLOWN_LOOSE_ANIM P1

	CALL WaitNoKeyPressed
	CALL WaitPressAnyKey
	CALL WaitNoKeyPressed
RET
	
GameEnd_2P_CheckP2
	LD	IX, BOARD2
	LD	A, (IX+BRD_GAME_STATE)
	CP	GAME_STATE_LOST
	CALL Z, GameLost	

	; CALL CLOWN_LOOSE_ANIM P2

	CALL WaitNoKeyPressed
	CALL WaitPressAnyKey
	CALL WaitNoKeyPressed
RET

;--------------------
GameDraw
;--------------------
	LD IX, BOARD1
	CALL GameLost

	LD IX, BOARD2
	CALL GameLost

	; CALL CLOWN_LOOSE_ANIM P1
	
	; CALL CLOWN_LOOSE_ANIM P2

	CALL WaitNoKeyPressed
	CALL WaitPressAnyKey
	CALL WaitNoKeyPressed
RET

;--------------------
GameLost
;--------------------
; Inputs:
;	IX - Board Structure, of Player that LOST

	CALL BoardUpdateLastRow

;###############################
;     Animation Logic STEPS
;###############################

; Counters
;	Brd
;-------------------------------
;	RESET Anim Counter
;	GOTO JUMP START (Must start ODD)
;	;------------------------------- LOOP Start
;		HALT
;	1		BRD CL odd
;	1		BRD PX odd
;	2		INC BRD
; JUMP START
;		HALT
;	2		BRD CL even
;	2		BRD PX odd
;	3		INC BRD
;	;------------------------------- LOOP End, NOTE: Must end on BRD even


; Implementation
;-------------------------------
;	Brd
;	0
			BOARDS_DROP_BRD_ANIM_Reset
			JP PLAY1_LOST_ANIM_START

;	;------------------------------- LOOP Start
PLAY1_LOST_ANIM_NEXT
		HALT
;	1		BRD CL odd
				CALL_LOST_ANIM_COLOR_ODD
;	1		BRD PX odd
				CALL_LOST_ANIM_PIXELS_ODD
;	2		INC BRD
				BOARDS_DROP_BRD_ANIM_NextLine

  ; CALL WaitPressAnyKey
  ; CALL WaitNoKeyPressed

PLAY1_LOST_ANIM_START
		HALT
;	2		BRD CL even
				CALL_LOST_ANIM_COLOR_EVEN
;	2		BRD PX even
				CALL_LOST_ANIM_PIXELS_EVEN
;	3		INC BRD
				BOARDS_DROP_BRD_ANIM_NextLine

  ; CALL WaitPressAnyKey
  ; CALL WaitNoKeyPressed

			; Check for End of Board HEIGHT
			LD	B, (IX+BRD_HEIGHT)			; Height
			SLA	B							; Multiply by 2 (using half Ball height)
			DEC	B							; We stop on an EVEN boundary
			LD	A, (BOARDS_DROP_ANIM_CNT)
			CP	B
		JP NZ, PLAY1_LOST_ANIM_NEXT
;	;------------------------------- LOOP End, NOTE: Must end on BRD even	

RET


; ===== 2 Players =====

GameInitWithAnim_2Players
; Inputs:
;	A  = Player 1 Opponent Character
;	A' = Player 2 Opponent Character

	; Player 1
	;LD	A, FOOL
	LD IX, BOARD1
	LD BC, #0B07	; H x W
	LD DE, BOARD1_DATA
	LD HL, #0800	; Y = 8, X = 0
		CALL BoardInit

	LD	A, 9	;5
		CALL BoardAddLineTotal

	; Player 2
	;LD	A, WORLD
	EX AF, AF'	; get Player 2 Char
	LD IX, BOARD2
	LD BC, #0B07	; H x W
	LD DE, BOARD2_DATA
	LD HL, #0890	; Y = 8, X = 144
		CALL BoardInit	

	LD	A, 9	;5
		CALL BoardAddLineTotal

GameDropAnim_2Players

;###############################
;     Animation Logic STEPS
;###############################

; Counters
;	E	Brd
;-------------------------------
;			HALT
;	1	0		EDGE PX1
;	1	0		EDGE PX2
;			HALT
;	1			EDGE CL1
;	1			EDGE CL2
;	2			INC EDGE
;			HALT
;		0		; BRD PX1 odd - Do nothing
;		0		; BRD PX2 odd - Do nothing
;		0		; INC BRD - DO nothing
; GOTO JUMP START
;			HALT
;	2			EDGE PX1
;	2			EDGE PX2
;			HALT
;		0		BRD CL1 even
;		0		BRD CL2 even
;	2			EDGE CL1
;	2			EDGE CL1
;	3			INC EDGE
;	;------------------------------- LOOP Start
;			HALT
;		0		BRD PX1 even
;		0		BRD PX2 even
;		1		INC BRD
;			HALT
;	3			EDGE PX1
;	3			EDGE PX2
;			HALT
;		1		BRD CL1 odd
;		1		BRD CL2 odd
;	3			EDGE CL1
;	3			EDGE CL2
;	4			INC EDGE
;			HALT
;		1		BRD PX1 odd
;		1		BRD PX2 odd
;		2		INC BRD
; JUMP START
;			HALT
;	4			EDGE PX1
;	4			EDGE PX2
;			HALT
;		2		BRD CL1 even
;		2		BRD CL2 even
;	4			EDGE CL1
;	4			EDGE CL2
;	5			INC EDGE
;	;------------------------------- LOOP End, NOTE: Must end on BRD even



; Implementation
;-------------------------------
			BOARDS_DROP_BRD_ANIM_Reset
			BOARDS_DROP_EDGE_ANIM_Reset

;	E	Brd
			HALT
;	1	0		EDGE PX
				LD	IX, BOARD1
					CALL_DROP_EDGE_ANIM_PIXELS
				LD	IX, BOARD2
					CALL_DROP_EDGE_ANIM_PIXELS
			HALT
;		0		; BRD CL odd - Do nothing
;	1			EDGE CL
				LD	IX, BOARD1
					CALL_DROP_EDGE_ANIM_COLOR
				LD	IX, BOARD2
					CALL_DROP_EDGE_ANIM_COLOR
;	1			INC EDGE
					BOARDS_DROP_EDGE_ANIM_NextLine

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

			HALT
;				; BRD PX odd - Do nothing
;		0		; INC BRD - DO nothing
; GOTO JUMP START
			JP	PLAY2_JUMP_START
;			HALT
;	1			EDGE PX
;			HALT
;		0		BRD CL even
;	1			EDGE CL
;	2			INC EDGE
;	;------------------------------- LOOP Start

PLAY2_DROP_ANIM_NEXT

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

			HALT
;		0		BRD PX even
				LD	IX, BOARD1
					CALL_DROP_BRD_ANIM_PIXELS_EVEN
				LD	IX, BOARD2
					CALL_DROP_BRD_ANIM_PIXELS_EVEN
;		1		INC BRD
					BOARDS_DROP_BRD_ANIM_NextLine

			; Check for End of Board HEIGHT
				LD	B, (IX+BRD_HEIGHT)			; Height
				SLA	B							; Multiply by 2 (using half Ball height)
					DEC B
				LD	A, (BOARDS_DROP_ANIM_CNT)	
				CP	B
				RET Z

			HALT
;	3			EDGE PX
				LD	IX, BOARD1
					CALL_DROP_EDGE_ANIM_PIXELS
				LD	IX, BOARD2
					CALL_DROP_EDGE_ANIM_PIXELS
			HALT
;		1		BRD CL odd
				LD	IX, BOARD1
					CALL_DROP_BRD_ANIM_COLOR_ODD
				LD	IX, BOARD2
					CALL_DROP_BRD_ANIM_COLOR_ODD
;	3			EDGE CL
				LD	IX, BOARD1
					CALL_DROP_EDGE_ANIM_COLOR
				LD	IX, BOARD2
					CALL_DROP_EDGE_ANIM_COLOR
;	4			INC EDGE
					BOARDS_DROP_EDGE_ANIM_NextLine

 ; CALL WaitPressAnyKey
 ; CALL WaitNoKeyPressed

			HALT
;		1		BRD PX odd
				LD	IX, BOARD1
					CALL_DROP_BRD_ANIM_PIXELS_ODD
				LD	IX, BOARD2
					CALL_DROP_BRD_ANIM_PIXELS_ODD
;		2		INC BRD
					BOARDS_DROP_BRD_ANIM_NextLine

PLAY2_JUMP_START

			HALT
;	4			EDGE PX
				LD	IX, BOARD1
					CALL_DROP_EDGE_ANIM_PIXELS
				LD	IX, BOARD2
					CALL_DROP_EDGE_ANIM_PIXELS
					
			HALT
;		2		BRD CL even
				LD	IX, BOARD1
					CALL_DROP_BRD_ANIM_COLOR_EVEN
				LD	IX, BOARD2
					CALL_DROP_BRD_ANIM_COLOR_EVEN
;	4			EDGE CL
				LD	IX, BOARD1
					CALL_DROP_EDGE_ANIM_COLOR
				LD	IX, BOARD2
					CALL_DROP_EDGE_ANIM_COLOR
;	5			INC EDGE
					BOARDS_DROP_EDGE_ANIM_NextLine

			; ; Check for End of Board HEIGHT
			; LD	B, (IX+BRD_HEIGHT)			; Height
			; SLA	B							; Multiply by 2 (using half Ball height)
			; LD	A, (BOARDS_DROP_EDGE_ANIM_CNT)	
			; CP	B
		;JP NZ, PLAY2_DROP_ANIM_NEXT
		JP	PLAY2_DROP_ANIM_NEXT
;	;------------------------------- LOOP End, NOTE: Must end on BRD even	
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
include "_LIB_\Joystick.asm"

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

	; Update Frame Counter
	LD HL, borderCounter
	INC (HL)

	HALT	; sync before update Board
	
	LD A, RED
	OUT (ULA),A

		LD IX, BOARD1
		CALL BoardUpdateAll

	LD A, YELLOW
	OUT (ULA),A

		;LD A, ; BRD_ANIM_STATE

		LD IX, BOARD1
		LD	A, (borderCounter) 
		CALL BoardStepAnim
		CALL BoardUpdateCursor

	; After Visual Update, Check if user Lost
	;------------------------------
		; Check Game State
			LD	A, (IX+BRD_GAME_STATE)
			CP	GAME_STATE_RUNNING	
			JP Z, PLAY1_RUNNING
		
			;CP	GAME_STATE_LOST
			;JP	Z, GameLost_1Player
		
			JP GameLost_1Player
			
			; CP	GAME_STATE_DRAW
			; JP	Z, GameLost_1Player
			
			; CP	GAME_STATE_WON
			; JP	Z, GameWon_1Player

		;RET ?

PLAY1_RUNNING

;	LD	IX, BOARD1
	LD	DE, BOARD_PATTERN_SINGLE
	CALL	BoardInjectLine

	; Get New Key State
	CALL	SINCLAIR1_DRIVER	;KEMPSTON_DRIVER	;CURSOR_DRIVER
	CALL	BoardProcessUserInput
	CALL	BoardProcessPop

	LD A, WHITE
	OUT (ULA),A

	CALL BoardPushPullAnim
	
	CALL PowerUpAnim

	;----------
	; Press SPACE to LEAVE
	;----------
	LD BC, KBRDBS ; Read Last Row Right (B,N,M,SS,Space)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYSP
	RET Z

	;----------
	; DEBUG
	;----------
	CALL	PLAY1_DEBUG

JP PLAY1_LOOP


; ===== Dual Player Game Loop =====
PLAY2
	; Clear Screen (Black on Black)
	LD A, BLACK<<3 + BLACK	; BLACK INK on BLACK PAPER
	CALL CLSC
	CALL CLS0


	LD	A, WORLD	; Player 2 Opponent Character
	EX	AF, AF'
	LD	A, FOOL		; Player 1 Opponent Character
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

	; Update Frame Counter
	LD HL, borderCounter
	INC (HL)

	HALT	; sync before update Board

	LD A, RED
	OUT (ULA),A

		LD IX, BOARD1
		CALL BoardUpdateAll

	LD A, MAGENTA
	OUT (ULA),A

		LD IX, BOARD2
		CALL BoardUpdateAll


	LD A, GREEN
	OUT (ULA),A

		;LD A, ; BRD_ANIM_STATE

		LD IX, BOARD1
		LD	A, (borderCounter)
		CALL BoardStepAnim
		CALL BoardUpdateCursor

	LD A, CYAN
	OUT (ULA),A

		LD IX, BOARD2
		LD	A, (borderCounter)
		DEC A					; Force P2 to update in different frame (1 sooner)
		CALL BoardStepAnim
		CALL BoardUpdateCursor

	; After Visual Update, Check if user Lost
	;------------------------------
		; Check Game State (P2)
			;LD	IX, BOARD2
			LD	A, (IX+BRD_GAME_STATE)
			CP	GAME_STATE_RUNNING	
			JP	NZ, GameEnd_2Players

		; Check Game State (P1)
			LD	IX, BOARD1
			LD	A, (IX+BRD_GAME_STATE)
			CP	GAME_STATE_RUNNING
			JP NZ, GameEnd_2Players

PLAY2_RUNNING

	LD A, BLACK
	OUT (ULA),A

	LD	IX, BOARD1
	LD	DE, BOARD_PATTERN_DUAL	;BOARD_PATTERN1
	CALL	BoardInjectLine

	CALL	SINCLAIR1_DRIVER
	CALL	BoardProcessUserInput
	CALL	BoardProcessPop


	LD IX, BOARD2
	LD	DE, BOARD_PATTERN_DUAL	;BOARD_PATTERN_MAGICIAN
	CALL	BoardInjectLine

	CALL	SINCLAIR2_DRIVER
	CALL	BoardProcessUserInput
	CALL	BoardProcessPop

	LD A, YELLOW
	OUT (ULA),A

	LD	IX, BOARD1
	CALL BoardPushPullAnim

	LD A, WHITE
	OUT (ULA),A

	LD	IX, BOARD2
	CALL BoardPushPullAnim

	CALL PowerUpAnim

	
	;----------
	; Press SPACE to LEAVE
	;----------
	LD BC, KBRDBS ; Read Last Row Right (B,N,M,SS,Space)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYSP
	RET Z

	;----------
	; DEBUG
	;----------
	CALL PLAY2_DEBUG
	
JP PLAY2_LOOP
;RET

PowerUpAnim
	LD A, BLUE
	OUT (ULA),A
	
	LD	A, (borderCounter)	; 13T
	AND	0x03	; 2 Bits

	ADD	A, A	; * 2
	ADD A, A	; * 4
	ADD	A, A	; * 8
	ADD	A, A	; *16

	LD	HL, POWER_UP_ANIM_TAB
	ADD A, L
	LD	L, A	; HL points to correct Anim Frame
	
	LD	DE, POWER_UP_BUBBLES_START
	LD	BC, 16

PowerUpAnim_loop
	LDI
	LDI
	LDI
	LDI
	JP	PE,	PowerUpAnim_loop
RET


include "Board.asm"

;----------
PLAY1_DEBUG
;----------
	
	; Press T to TransformStone on Player 1 with RED Bubbles
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYT

	LD A, B_R		; RED Bubble
	CALL Z, BoardTransformStone


	; Press E to BoardPullAnim on Player 1
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYE

	CALL Z, BoardUpdateLastRow	;	BoardProcessPop

	; ; Press W to BoardPullAnim on Player 1
	; LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	; IN A,(C)
	; OR #E0			;Set Bits765
	; CP KEYW

	; CALL Z, BoardPullAnim


	; Press Q to BoardPullAnim on Player 1
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYQ

	LD	A, 1
	CALL Z,  BoardAddLineTotal

RET

;----------
PLAY2_DEBUG
;----------

	; Press T to TransformStone on Player 1 with RED Bubbles
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYT

	; TODO Optimize this out
	LD IX, BOARD1
	LD A, B_R		; RED Bubble
	CALL Z, BoardTransformStone

	; Press G to TransformStone on Player 2 with BLUE Bubbles
	LD BC, KBRDAG	; Read Numbers A to G Row (G,F,D,S,A)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYG

	; TODO Optimize this out
	LD IX, BOARD2
	LD A, B_B		; BLUE Bubble
	CALL Z, BoardTransformStone


	; Press Q to BoardPullAnim on Player 1
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYQ

	LD	IX, BOARD1
	LD	A, 1
	CALL Z,  BoardAddLineTotal	

	; Press A to BoardPullAnim on Player 1
	LD BC, KBRDAG	; Read Numbers A to G Row (G,F,D,S,A)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYA

	LD	IX, BOARD2
	LD	A, 1
	CALL Z,  BoardAddLineTotal	

RET


ORG #A000

include "_DATA_.symbol"
incbin "_DATA_.bin"

include "BoardVars.asm"
include "Roll-3D.asm"