;Shared Vars
;BOARDS_POWER_UP_ANIM_CNT	DEFB	#00		; Used to control Power Cycle Animation (0 to 3)
BOARDS_DROP_ANIM_CNT		DEFB	#00		; Used to control Board Vertical Drop Animation
BOARDS_DROP_EDGE_ANIM_CNT	DEFB	#00		; Used to control Board Vertical Drop EDGE Animation

; Board Object definion
;=======================
BRD_HEIGHT					EQU	 0	; Height
BRD_WIDTH					EQU	 1	; Width
BRD_BUF						EQU  2	; BOARD_DATA Addr
BRD_BUF_H					EQU	 2	; BOARD_DATA High
BRD_BUF_L					EQU	 3 	; BOARD_DATA Low

BRD_POS						EQU  4	; Screen POSITION
 BRD_POS_X					EQU  4	; Screen POSITION X
 BRD_POS_Y					EQU	 5	; Screen POSITION Y

BRD_USER_CTRL_LAST			EQU	 6	; User InputCtrl Last read
BRD_USER_CTRL_NEW			EQU	 7	; User InputCtrl recent read

BRD_LINE_TOT				EQU  8	; LineTotal
BRD_LINE_CNT				EQU  9	; LineCount
BRD_CUR_X					EQU 10	; Cursor (in Chars) relative to START POSITION_X

BRD_ANIM					EQU 11	; Clown Animation Sequence (With and without ball)
 BRD_ANIM_L					EQU 11	; Clown Animation Sequence Low
 BRD_ANIM_H					EQU 12	; Clown Animation Sequence High 
BRD_ANIM_STATE				EQU 13	; Animation State Frame

BRD_ATTACK_Base_L			EQU 14	; ATTACK Tab Base Address Low, used to loop back.
BRD_ATTACK_Base_H			EQU 15	; ATTACK Tab Base Address High, used to loop back.

BRD_ATTACK_TAB_L			EQU	16	; Opponent ATTACK Tab Address Low (This will change during updates)
BRD_ATTACK_TAB_H			EQU	17	; Opponent ATTACK Tab Address High

BRD_ATTACK_CNT				EQU 18	; Opponent ATTACK Count Down, Initialized to ATTACK_PATTERN_SIZE
BRD_COMBO_CNT				EQU	19	; Opponent Combo Count (0 = no combo, positive = combo counting)

BRD_FLAGS					EQU	20	; FLAGS
			; Flag bits for BRD_FLAGS
				BRD_FLAG_NONE		EQU 0x00	; Used to initialize MASK of BRD_FLAGS
				BRD_FLAG_COMBO		EQU 0x01	; If 1, Defines that a COMBO is in progress ( used as MASK on BRD_FLAGS)
				BRD_FLAG_WRAP		EQU 0x02	; If 1, Board Margins should wrap

BRD_PUSH_PULL_COLOR			EQU 21	; used to keep Pushing and Pulling Item Color
BRD_PUSH_PULL_CNT			EQU 22	; Number of balls being hold by clown (does not include, animating balls)
BRD_PUSH_PULL_ANIM_STATE	EQU 23	; used to animate Pushing and Pulling Items
			; Push Pull (PP) Anim States	Uses Bits 5..3
				PP_ANIM_STATE_STOPPED		EQU 0x00
				PP_ANIM_STATE_PULLING		EQU	0x10
				PP_ANIM_STATE_PUSHING		EQU	0x20
				
				PP_ANIM_STATE_ROLL_UP		EQU 0x40

BRD_PULL_ANIM_COL_BASE		EQU 24	; PULL Anim Columm BASE Addr. Points to the Bottom most row of PULL Column
 BRD_PULL_ANIM_COL_BASE_L	EQU 24	; PULL Anim Columm BASE Addr (Low )
 BRD_PULL_ANIM_COL_BASE_H	EQU 25	; PULL Anim Columm BASE Addr (High)

BRD_PULL_ANIM_COL_ADDR		EQU 26	; PULL Anim Columm Addr. Used to animate balls on column (towards Clown)
 BRD_PULL_ANIM_COL_ADDR_L	EQU 26	; PULL Anim Columm Addr (Low )
 BRD_PULL_ANIM_COL_ADDR_H	EQU 27	; PULL Anim Columm Addr (High)

 ; NOTE: Since we can be PULLing while still PUSHing
BRD_PUSH_ANIM_COL_BASE		EQU 28	; PUSH Anim Columm BASE Addr. Points to the Bottom? most row of PUSH Column
 BRD_PUSH_ANIM_COL_BASE_L	EQU 28	; PUSH Anim Columm BASE Addr (Low )
 BRD_PUSH_ANIM_COL_BASE_H	EQU 29	; PUSH Anim Columm BASE Addr (High)

BRD_PUSH_ANIM_COL_ADDR		EQU 30	; PUSH Anim Columm Addr. Used to animate balls on column (away from Clown)
 BRD_PUSH_ANIM_COL_ADDR_L	EQU 30	; PUSH Anim Columm Addr (Low )
 BRD_PUSH_ANIM_COL_ADDR_H	EQU 31	; PUSH Anim Columm Addr (High)

BRD_GAME_STATE				EQU 32	; Game State
			; Possible Board Game States
				GAME_STATE_RUNNING	EQU	0x00	; During Game Play
				GAME_STATE_LOST		EQU 0x01	; Player LOST	(Red	Ball)
				GAME_STATE_DRAW		EQU 0x03	; It's a DRAW	(Blue	Ball)
				GAME_STATE_WON		EQU 0x02	; Player WON	(Green	Ball)

BRD_PUSH_PULL_INSERT_CNT	EQU 33	; Number of balls Already pushed by clown (used for animating balls)

BRD_CUR_X_LAST				EQU 34	; Last version of BRD_CUR_X

BRD_POP_ANIM				EQU 35	; Pop Animation State control
BRD_POP_CNT					EQU 36	; Counts the Number of Balls during POPing
BRD_ROLL_UP_CNT				EQU	37	; Counts how many roll ups were done in a single frame

BRD_POWER_UP_BITVAR			EQU	38	; Bitwise variable to Save Activated POWER UP Colors
			; Possible POWER UP colors (more than one bit can be set)
				POWER_UP_BIT_RED	EQU	0
				POWER_UP_BIT_GREEN	EQU	1
				POWER_UP_BIT_BLUE	EQU	2
				POWER_UP_BIT_YELLOW	EQU	3

BRD_CUR_Y					EQU 39	; Cursor/Clown Y Position


;----------------------
; Actual Board objects
;----------------------
BOARD1
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD1_DATA
	DEFW #0800	; Screen POSITION Y,X
	DEFB 0		; User Input Last
	DEFB 0		; User Input New
	DEFB 0		; LineTotal
	DEFB 0		; LineCount
	DEFB 0		; Cursor (in Chars)
	DEFW ClownIdleAnimator1	; Clown Animation Sequence
	DEFB 0		; Animation State Frame
	DEFW #0000	; ATTACK Pattern Table Base Address
	DEFW #0000	; ATTACK Pattern Table Address
	DEFB 0		; ATTACK Pattern Count Down (Should be initialized to ATTACK_PATTERN_SIZE)
	DEFB 0		; Opponent Combo Count
	DEFB #0		; flags
	DEFB B_0	; Current PUSH/PULL Color
	DEFB 0		; Number of Balls in Clown Hands
	DEFB 0		; PUSH/PULL AnimState

	DEFW #0000	; PULL Col Start Animation BASE (Bottom row Item)
	DEFW #0000	; PULL Col Start Animation (Bottom)

	DEFW #0000	; PUSH Col Start Animation BASE (Bottom row Item)
	DEFW #0000	; PUSH Col Start Animation (Top)

	DEFB GAME_STATE_RUNNING; Game State
	DEFB 0		; PUSH PULL Insert Count
	DEFB 0		; Last Cursor (in Chars)
	DEFB 0		; Pop Anim State
	DEFB 0		; Pop Count
	DEFB 0		; ROLL UP Count
	DEFB 0		; Bitwise POWER UP Colors
	DEFB 0		; Cursor Y (Constant after init)
;----------------------

;----------------------
BOARD2
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD2_DATA
	DEFW #0890	; Screen POSITION Y,X
	DEFB 0		; User Input Last
	DEFB 0		; User Input New
	DEFB 0		; LineTotal
	DEFB 0		; LineCount
	DEFB 0		; Cursor (in Chars)
	DEFW ClownIdleAnimator2	; Clown Animation Sequence
	DEFB 0		; Animation State Frame
	DEFW #0000	; ATTACK Pattern Table Base Address
	DEFW #0000	; ATTACK Pattern Table Address
	DEFB 0		; ATTACK Pattern Count Down (Should be initialized to ATTACK_PATTERN_SIZE)
	DEFB 0		; Opponent Combo Count
	DEFB #0		; flags
	DEFB B_0	; Current PUSH/PULL Color
	DEFB 0		; Number of Balls in Clown Hands
	DEFB 0		; PUSH/PULL AnimState

	DEFW #0000	; PULL Col Start Animation BASE (Bottom row Item)
	DEFW #0000	; PULL Col Start Animation (Bottom)

	DEFW #0000	; PUSH Col Start Animation BASE (Bottom row Item)
	DEFW #0000	; PUSH Col Start Animation (Top)

	DEFB GAME_STATE_RUNNING; Game State
	DEFB 0		; PUSH PULL Insert Count
	DEFB 0		; Last Cursor (in Chars)
	DEFB 0		; Pop Anim State
	DEFB 0		; Pop Count
	DEFB 0		; ROLL UP Count
	DEFB 0		; Bitwise POWER UP Colors
	DEFB 0		; Cursor Y (Constant after init)
;----------------------


; In single player mode, Board1, will extend into board 2 buffer,
; since single board has a larger area (11 x 13)
; NOTE: (11 x 13) is less than 2 x (11 x 7), hence board will fit

; Organization :
;	Board data is organized by columns first, and then rows

; 	In a board (11 x 7) we have 7 columns, of 11 items each.
;	So each item is located with following formula
;		Column * Height + Row

; Example:
;	item with index 14, is the item at Column 1 and Row 3, since ((1) * 11 + (3) = 14)

; This arrangement, allows us to process game logic faster since vertical positions (same column rows) are adjacent

; ALIGN to 256 boundary, by reaching the next boundary, when necessary
ALIGNED_BOARD_DATA_HIGH EQU HIGH($)
ALIGNED_BOARD_DATA_LOW EQU LOW($)
ORG	( (ALIGNED_BOARD_DATA_LOW = 0 ? 0 : 256 ) + 256 * ALIGNED_BOARD_DATA_HIGH )

BOARD1_LEFT_FENCE
	REPT 11
		DEFB #00	; These will never be changed in 1 or 2 Player mode
	ENDM
;Buffer FENCES are used to simplify and speed up POP MATCH search
; hence avoiding to check for left and right margins

BOARD1_DATA
	REPT 11*7
		DEFB #00
	ENDM

BOARDS_INTER_FENCE
	REPT 11
		DEFB #00	; These will never be changed in 2 Player mode, Must be cleared before
	ENDM

BOARD2_DATA
	REPT 11*7
		DEFB #00
	ENDM

BOARD2_RIGHT_FENCE
	REPT 11
		DEFB #00	; These will never be changed in 1 or 2 Player mode
	ENDM

BOARDS_DATA_END_MARKER
	DEFB #FF	

	
;include "Patterns.asm"

; Used to keep generated Ball Colors history, so that both players get the same values
; TODO, Can't we use ROM DATA, or program DATA for generation ?
; Or use 2 PSEUDO RANDOM generators, seeded with the same seed, so that they generate the same content, in distinct time.
; OR defined a Reference table, and use walking pointers (with pre-defined Offsets at start), so that sequence is the same for both players.
; Would avoid having to keep a copy of the items.
BOARD_GEN_HISTORY
	REPT 11*7*2	; Must be enough to keep the entire game input (MAX 250 per user ?)
		DEFB #00	
	ENDM


; ALIGN to 256 boundary, by reaching the next boundary, when necessary
ALIGNED_PATTERN_DATA_HIGH EQU HIGH($)
ALIGNED_PATTERN_DATA_LOW EQU LOW($)
ORG	( (ALIGNED_PATTERN_DATA_LOW = 0 ? 0 : 256 ) + 256 * ALIGNED_PATTERN_DATA_HIGH )

include "Patterns.asm"
include "Injection.asm"
