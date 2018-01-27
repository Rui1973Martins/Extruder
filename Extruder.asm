DEBUG		EQU 1
DEBUG_SFX	EQU	1

include "_REF_\REF.asm"
include "_REF_\KEYBOARD.asm"

include "Macros.asm"
	
ORG #6000
JP MENU_ENTRY

borderCounter DEFB BLACK

include "CharBlitter.ASM"

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

JOY_DRIVER_TAB
	DEFW	KEMPSTON_DRIVER
	DEFW	FULLER_DRIVER
	DEFW	CURSOR_DRIVER
	DEFW	SINCLAIR1_DRIVER
	DEFW	SINCLAIR2_DRIVER
	DEFW	KEYBOARD_DRIVER
;	DEFW	CPU_DRIVER

GetJoyDriver
;	 A = Player Ctrl
; Outputs
;	DE = Joy Driver Addr

	LD	HL, JOY_DRIVER_TAB
	EX	DE, HL

	ADD	A, A	; *2

	LD	H, 0
	LD	L, A
	
	ADD	HL, DE

	LD	E, (HL)
	INC	HL
	LD	D, (HL)
RET

	
SetJoyDrivers
	LD	A,(CtrlP1)
	CALL	SetJoyDriverP1

	LD	A,(CtrlP2)
	;CALL	SetJoyDriverP2
; FALL THROUGH
;RET

	
SetDriverP2
;	 A = Player Ctrl
	CALL	GetJoyDriver

	LD	A, E		;DE =  Joy Driver Addr
	LD	(PLAY2_P2_DRIVER), A	; LOW Byte

	LD	A, D
	LD	(PLAY2_P2_DRIVER+1), A	; HIGH Byte
RET


SetJoyDriverP1
;	 A = Player Ctrl
	CALL	GetJoyDriver

	;DE =  Joy Driver Addr
	LD	A, E
	LD	(PLAY1_DRIVER), A		; LOW Byte
	LD	(PLAY2_P1_DRIVER), A	; LOW Byte

	LD	A, D
	LD	(PLAY1_DRIVER+1), A		; HIGH Byte
	LD	(PLAY2_P1_DRIVER+1), A	; HIGH Byte
RET


MENU_DELTA	EQU 4
MENU_ROW_TITLE	EQU (( 5*8) + MENU_DELTA )
MENU_ROW1		EQU (( 7*8) + MENU_DELTA )
MENU_ROW2		EQU (( 9*8) + MENU_DELTA )
MENU_ROW3		EQU ((11*8) + MENU_DELTA )
MENU_ROW4		EQU ((13*8) + MENU_DELTA )
MENU_ROW5		EQU ((15*8) + MENU_DELTA )
MENU_ROW6		EQU ((17*8) + MENU_DELTA )
MENU_ROW7		EQU ((19*8) + MENU_DELTA )

PxBlitControlMenu
; Inputs:
;	 E = X position
;	HL = Title Message Addr

	PUSH DE
		LD	D, MENU_ROW_TITLE	; Y 
		CALL FPrtStr
	POP DE

	LD	D, MENU_ROW1	; Y 
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE
	PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A
	
		LD	HL, CtrlItem1
			CALL FPrtStr
	POP DE

	LD	D, MENU_ROW2	; Y 
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE
	PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A

		LD	HL, CtrlItem2
			CALL FPrtStr
	POP DE

	LD	D, MENU_ROW3	; Y 
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE
	PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A

		LD	HL, CtrlItem3
			CALL FPrtStr
	POP DE

	LD	D, MENU_ROW4	; Y 
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE	
	PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A

		LD	HL, CtrlItem4
			CALL FPrtStr
	POP DE

	LD	D, MENU_ROW5	; Y
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE
	PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A

		LD	HL, CtrlItem5
			CALL FPrtStr
	POP DE

	LD	D, MENU_ROW6	; Y
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE
	PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A

		LD	HL, CtrlItem6
			CALL FPrtStr
	POP DE

	LD	D, MENU_ROW7	; Y
	PUSH DE
		LD	HL, MenuItem	
		CALL	PxBlit0
	POP DE
	;PUSH DE
		LD	A, 2*8
		ADD	A, E
		LD	E, A
		
		LD	HL, CtrlItem7

			JP	FPrtStr ; CALL FPrtStr
	; POP DE
;RET

STR_Z 	EQU	0x00
CtrlPlayer1		DB	"PLAYER 1", STR_Z
CtrlPlayer2		DB	"PLAYER 2", STR_Z

CtrlItem1		DB	"KEMPSTON", STR_Z
CtrlItem2		DB	"FULLER", STR_Z
CtrlItem3		DB	"CURSOR PROTEK", STR_Z
CtrlItem4		DB	"SINCLAIR 1", STR_Z
CtrlItem5		DB	"SINCLAIR 2", STR_Z
CtrlItem6		DB	"KEYBOARD", STR_Z
CtrlItem7		DB	"CPU", STR_Z

CTRL_KEMPSTON	EQU	0
CTRL_FULLER		EQU	1
CTRL_CURSOR		EQU	2
CTRL_SINCLAIR1	EQU	3
CTRL_SINCLAIR2	EQU	4
CTRL_KEYBOARD	EQU	5
CTRL_CPU		EQU 6

CTRL_SELECTION_MAX	EQU CTRL_KEYBOARD	; CTRL_CPU

CtrlP1	DEFB	CTRL_SINCLAIR2	; P1 Default Control Selection
CtrlP2	DEFB	CTRL_SINCLAIR1	; P2 Default Control Selection



MENU_LINETOP_TITLE_P1_C		DEFB	-8,0x44, #FF 
MENU_LINEBOT_TITLE_P1_C		DEFB	-8,0x42, #FF 

MENU_LINETOP_TITLE_P2_C		DEFB	-8,0x45, #FF 
MENU_LINEBOT_TITLE_P2_C		DEFB	-8,0x42, #FF 

MENU_LINETOP_HIGHLIGHT_C	DEFB	0x46,0x43,-13,0x47, #FF 
MENU_LINEBOT_HIGHLIGHT_C	DEFB	0x44,0x45,-13,0x44, #FF 

MENU_LINETOP_LOWLIGHT_C		DEFB	0x00,0x00,-13,0x07, #FF 
MENU_LINEBOT_LOWLIGHT_C		DEFB	0x00,0x00,-13,0x05, #FF 


LenCBlit
;	 A = color
;	 B = Count
;	DE = YX

	CALL ColorAD	; Only changes DE

LenCBlit_loop
;	DE = Target Addr
	LD	(DE), A
	INC	E
	DJNZ	LenCBlit_loop
RET

LenRLE_CBlit
;	HL = RLE Data Addr
;	DE = YX

	CALL ColorADA

LenRLE_CBlit_loop
	LD	A, (HL)
	CP	0xFF
	RET	Z

	CP	0
	JP	P, LenRLE_CBlit_copy
	
	; Found count
	NEG
	LD	B, A
	INC	HL
	LD	A, (HL)
		CALL	LenCBlit_loop
	JR	LenRLE_CBlit_next
	
LenRLE_CBlit_copy
	LD	(DE), A
	INC	E

LenRLE_CBlit_next
	INC	HL
	JR	LenRLE_CBlit_loop	
RET



CBlitMenuIndex
;	 A = ItemIndex
;	 C = MenuIndex
;	DE = YX
	
	LD	B, A
	ADD	A, A	; * 2
	ADD	A, A	; * 4
	ADD	A, A	; * 8
	ADD	A, A	; *16
	
	ADD	A, D
	LD	D, A
	
	LD	A, B
	CP	C		; If selected Menu Item, HighLight
	JP	Z, CBlitMenuHighlight

	;CALL	CBlitMenuHighlight
; FALL THROUGH
; RET

CBlitMenuLowlight
;	DE	; YX
;
		PUSH DE
	LINETOP_C	EQU $+1
			LD	HL, MENU_LINETOP_LOWLIGHT_C
			CALL	LenRLE_CBlit
		POP DE
		LD	A, 8
		ADD	A, D
		LD	D, A	; Next Line	
		;PUSH DE
	LINEBOT_C	EQU $+1
			LD	HL, MENU_LINEBOT_LOWLIGHT_C
			CALL	LenRLE_CBlit
		;POP DE
RET

CBlitMenuHighlight
;	DE	; YX
;
		PUSH DE
			LD	HL, MENU_LINETOP_HIGHLIGHT_C
			CALL	LenRLE_CBlit
		POP DE
		LD	A, 8
		ADD	A, D
		LD	D, A	; Next Line	
		;PUSH DE
			LD	HL, MENU_LINEBOT_HIGHLIGHT_C
			CALL	LenRLE_CBlit
		;POP DE
RET


CBlitControlMenu
; Inputs:
;	 E = X position
;	 C = CtrlType
; 	HL = Line Tittle Color Addr

	LD	A, C
	EX AF, AF'	; Save CtrlType
	
	LD	D, MENU_ROW_TITLE
	PUSH DE
		LD	HL, MENU_LINETOP_TITLE_P1_C
		CALL	LenRLE_CBlit
	POP	DE
	
	LD	A, 8
	ADD	A, D
	LD	D, A	; Next Line
	PUSH DE
		LD	HL, MENU_LINEBOT_TITLE_P1_C
		CALL	LenRLE_CBlit
	POP	DE

	EX AF, AF'		; Restore CtrlType
	LD	C, A

	LD	D, MENU_ROW1
	LD	B, CTRL_SELECTION_MAX+1
CBlitControlMenu_loop
	PUSH	BC
		PUSH DE
			LD	A, CTRL_SELECTION_MAX+1
			SUB B		; A = Index
			CALL	CBlitMenuIndex
		POP DE
	POP	BC
	DJNZ	CBlitControlMenu_loop	
RET


DrawMenu
	LD A, BLACK<<3 + BLACK	; BLACK INK on BLACK PAPER
	CALL CLSC
	CALL CLS0

	LD	E, 0*8	;	Char Column 00 
	LD	HL, CtrlPlayer1		;   Title String Addr
		CALL PxBlitControlMenu

	LD	E, 16*8	;	Char Column 16 
	LD	HL, CtrlPlayer2		;   Title String Addr
		CALL PxBlitControlMenu

	HALT

	LD	A, (CtrlP1)
	LD	C, A
	LD	E, 0*8	;	Char Column 00 
		CALL CBlitControlMenu

	LD	A, (CtrlP2)
	LD	C, A
	LD	E, 16*8	;	Char Column 16
		CALL CBlitControlMenu

	;CALL FDraw

	HALT
	
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
	; LD A, BLACK<<3 + BLACK	; BLACK INK on BLACK PAPER
	; CALL CLSC
	; CALL CLS0

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

	CALL	sfxPlay0

	CALL PLAY1
	CALL WaitNoKeyPressed

	JP MENU_ENTRY
	
MENU_PLAY2

	CALL	sfxPlay0

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

DrawFrame_1P
	LD	HL, SingleTilesTab
	LD	(RLEIndexTab),HL

	LD	HL, Blit0
	LD	(RLEBlitFunc), HL

	LD	DE, 0x00;DE = Y,X
	LD	HL, SingleTabRLE	;TableData
		JP RLETabBlit

GameInitWithAnim_1Player
	; Player 1
	LD	A, FOOL
	LD IX, BOARD1
	LD BC, #0B0D	; H x W
	LD DE, BOARD1_DATA
	LD HL, #0818	; Y = 8, X = 24
		CALL BoardInit

	; Set Clown Animator
	LD	HL, ClownAnimator1_TAB
	CALL BoardUpdateAnimator

	LD	A, BRD_FLAG_WRAP
		CALL BoardSetFlags

	; Clear Fences
		CALL	BoardClearFenceLeft
		LD	HL, +( 0x0B * 0x0D + BOARD1_DATA)
		CALL	BoardClearFence

	CALL DrawFrame_1P
		
	LD	B, 	DIFFICULTY_1PLAYER_MEDIUM
	CALL	BoardTimingInit_1Player

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
GameEnd_1Player
;--------------------
	LD IX, BOARD1

	CALL GameLost

	; Set Clown Animator
	LD	HL, ClownAnimator1_TAB
	CALL	BoardUpdateAnimator
	CALL	BoardStepAnim_Force	
	
GameEnd_1P_waitLoop
	CALL	BoardUpdateCursor
	
	LD HL, borderCounter
	INC (HL)

	HALT

	LD	A, (borderCounter) 
	CALL	BoardStepAnim	

	; Check for any key pressed
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !
	JR	NZ,	GameEnd_1P_waitEnd

	JR GameEnd_1P_waitLoop	

GameEnd_1P_waitEnd	

	CALL WaitPressAnyKey
	CALL WaitNoKeyPressed
RET

;--------------------
GameEnd_2Players
;--------------------

	LD	IX, BOARD1
	LD	A, (IX+BRD_GAME_STATE)
	CP	GAME_STATE_LOST
	JP	NZ, GameEnd_2P_WON_P1_LOST_P2

	; Player 1 LOST
	; Check if Player 2 Also Lost
	LD	IX, BOARD2
	LD	A, (IX+BRD_GAME_STATE)
	CP	GAME_STATE_LOST
	JP	Z, GameDraw

GameEnd_2P_LOST_P1_WON_P2

	; Player 1 LOST
	LD IX, BOARD1
	CALL	GameLost
	CALL	BoardTextLose

	; Set Clown Animator
	LD	HL, ClownAnimator1_TAB
	CALL	BoardUpdateAnimator
	CALL	BoardStepAnim_Force	

	; Player 2 WON
	LD	IX,	BOARD2
	CALL	BoardTextWin
	
	JP	Game2P_waitLoop
	
GameEnd_2P_WON_P1_LOST_P2
	; Player 2 LOST
	LD	IX, BOARD2
	;LD	A, (IX+BRD_GAME_STATE)
	;CP	GAME_STATE_LOST
	;CALL Z, GameLost	
	CALL	GameLost	
	CALL	BoardTextLose
	
	; Set Clown Animator
	LD	HL, ClownAnimator2_TAB
	CALL	BoardUpdateAnimator
	CALL	BoardStepAnim_Force	

	; Player 1 WON
	LD IX, BOARD1
	CALL	BoardTextWin

	JP	Game2P_waitLoop

;--------------------
GameDraw
;--------------------
	LD IX, BOARD1
		CALL	GameLost

		; Set Clown Animator
		LD	HL, ClownAnimator1_TAB
		CALL	BoardUpdateAnimator
		CALL	BoardStepAnim_Force	

		CALL	BoardUpdateCursor

	LD IX, BOARD2
		CALL	GameLost

		; Set Clown Animator
		LD	HL, ClownAnimator2_TAB
		CALL	BoardUpdateAnimator
		CALL	BoardStepAnim_Force	

		CALL	BoardUpdateCursor
; FALL THROUGH

Game2P_waitLoop
	LD IX, BOARD1
		CALL	BoardUpdateCursor
		; TODO: CALL CLOWN_LOOSE_ANIM P2
	LD IX, BOARD2
		CALL	BoardUpdateCursor

	LD HL, borderCounter
	INC (HL)

	HALT

	;LD IX, BOARD2
	LD	A, (borderCounter) 
	CALL	BoardStepAnim	

	LD IX, BOARD1
	LD	A, (borderCounter) 
	CALL	BoardStepAnim	

	; Check for any key pressed
	XOR A
	IN A,(ULA)	; Read All Keys - Check for any Key pressed
	AND #1F ; Test only 5 Keys
	CP #1F	; If Not Zero, some key was pressed !
	JR	NZ,	Game2P_waitEnd

	JR Game2P_waitLoop

Game2P_waitEnd

	CALL WaitPressAnyKey
	CALL WaitNoKeyPressed
RET

;--------------------
GameLost
;--------------------
; Inputs:
;	IX - Board Structure, of Player that LOST

	CALL	BoardUpdateLastRow
	CALL	BoardAdjustCursorPos
	CALL	BoardUpdateCursor

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

	; Set Clown Animator
	LD	HL, ClownAnimator1_TAB
	CALL BoardUpdateAnimator
		
	; Player 2
	;LD	A, WORLD
	EX AF, AF'	; get Player 2 Char
	LD IX, BOARD2
	LD BC, #0B07	; H x W
	LD DE, BOARD2_DATA
	LD HL, #0890	; Y = 8, X = 144
		CALL BoardInit	

	; Set Clown Animator
	LD	HL, ClownAnimator2_TAB
	CALL BoardUpdateAnimator

	; Clear all Fence buffers
	CALL	BoardClearFenceLeft
	CALL	BoardClearFenceInter
	CALL	BoardClearFenceRight

	CALL	BoardTimingInit_2Players
	
	; Insert a few lines to start
	LD	IX, BOARD1
	LD	A, 3
		CALL BoardAddLineTotal

	LD	IX, BOARD2
	LD	A, 3
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


include "FontHandling.asm"

include "_DATA_\font.asm"


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

	CALL SetJoyDrivers

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

	CALL	BoardTimingTick
	JP	NZ,	PLAY1_SYNC
	
	;	LD	IX, BOARD1
		LD	A, 1
		CALL BoardAddLineTotal

PLAY1_SYNC		
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
		
			JP GameEnd_1Player
			
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
PLAY1_DRIVER	EQU $+1
	CALL	SINCLAIR1_DRIVER	;KEMPSTON_DRIVER	;CURSOR_DRIVER
	CALL	BoardProcessUserInput
	CALL	BoardProcessPop

	LD A, WHITE
	OUT (ULA),A

	CALL BoardPushPullAnim

	; COMMENT TO DEBUG by HAND
	CALL BoardRollUpAnim

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

	CALL SetJoyDrivers

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

	CALL BoardTimingTick
	JP	NZ, PLAY2_SYNC
	
		LD	IX, BOARD1
		LD	A, 1
		CALL BoardAddLineTotal

		LD	IX, BOARD2
		LD	A, 1
		CALL BoardAddLineTotal

PLAY2_SYNC
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

PLAY2_P1_DRIVER	EQU	$+1
	CALL	SINCLAIR2_DRIVER
	CALL	BoardProcessUserInput
	CALL	BoardProcessPop


	LD IX, BOARD2
	LD	DE, BOARD_PATTERN_DUAL	;BOARD_PATTERN_MAGICIAN
	CALL	BoardInjectLine

PLAY2_P2_DRIVER	EQU	$+1
	CALL	SINCLAIR1_DRIVER
	CALL	BoardProcessUserInput
	CALL	BoardProcessPop

	LD A, YELLOW
	OUT (ULA),A

	LD	IX, BOARD1
	CALL BoardPushPullAnim

	CALL BoardRollUpAnim


	LD A, WHITE
	OUT (ULA),A

	LD	IX, BOARD2
	CALL BoardPushPullAnim

	CALL BoardRollUpAnim


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
	LD	B, A
	AND	0x03		; Process once, every 4 frames
	RET NZ

	LD	A, B

	AND	0x0C	; 2 Bits
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

	
	; Press R to BoardPullAnim on Player 1
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYR

	CALL Z, BoardUpdateLastRow	;	BoardProcessPop


	; Press E to BoardPullAnim on Player 1
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYE

	CALL Z, BoardRollUpAnim	;	BoardProcessPop


	; Press W to BoardPullAnim on Player 1
	LD BC, KBRDQT	; Read Numbers Q to T Row (T,R,E,W,Q)
	IN A,(C)
	OR #E0			;Set Bits765
	CP KEYW

	CALL Z, BoardRollUpStart


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
include "SFX.asm"

SFX_MENU		EQU 0
SFX_START		EQU 1
SFX_DROP		EQU 2
SFX_NOT			EQU 3
SFX_PULL		EQU 4
SFX_PUSH		EQU 5
SFX_HIT			EQU 6
SFX_MATCH		EQU 7
