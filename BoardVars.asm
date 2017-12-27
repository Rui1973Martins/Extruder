

BRD_HEIGHT 		EQU	 0	; Height
BRD_WIDTH		EQU	 1	; Width
BRD_BUF			EQU  2	; BOARD_DATA Addr
BRD_BUF_H		EQU	 2	; BOARD_DATA High
BRD_BUF_L		EQU	 3 	; BOARD_DATA Low
BRD_POS			EQU  4	; Screen POSITION
 BRD_POS_X		EQU  4	; Screen POSITION X
 BRD_POS_Y		EQU	 5	; Screen POSITION Y
BRD_LINE_TOT	EQU  6	; LineTotal
BRD_LINE_CNT	EQU  7	; LineCount
BRD_CUR_X		EQU  8	; Cursor (in Chars) relative to START POSITION_X
BRD_ANIM		EQU  9	; Clown Animation Sequence (With and without ball)
 BRD_ANIM_L		EQU  9	; Clown Animation Sequence Low
 BRD_ANIM_H		EQU 10	; Clown Animation Sequence High 
BRD_ANIM_STATE	EQU 11	; Animation State Frame
BRD_OVFLOW_Base_L	EQU 12	; Overflow Tab Base Address Low, used to loop back.
BRD_OVFLOW_Base_H	EQU 13	; Overflow Tab Base Address High, used to loop back.
BRD_OVFLOW_TAB_L	EQU	14	; Opponent Overflow Tab Address Low (This will change during updates)
BRD_OVFLOW_TAB_H	EQU	15	; Opponent Overflow Tab Address High
BRD_OVFLOW_CNT		EQU 16	; Opponent Overflow Count Down, Initialized to OVERFLOW_PATTERN_SIZE
BRD_COMBO_CNT		EQU	17	; Opponent Combo Count (0 = no combo, positive = combo counting)
BRD_FLAGS		EQU	18	; flags
	BRD_FLAG_COMBO	EQU 0x01	; If 1, Defines that a COMBO is in progress ( used as MASK on BRD_FLAGS)


BOARD1
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD1_DATA
	DEFW #0800	; Screen POSITION Y,X
	DEFB 0		; LineTotal
	DEFB 0		; LineCount
	DEFB 0		; Cursor (in Chars)
	DEFW ClownIdleAnimator1	; Clown Animation Sequence
	DEFB 0		; Animation State Frame
	DEFW #0000	; Overflow Pattern Table Base Address
	DEFW #0000	; Overflow Pattern Table Address
	DEFB 0		; Overflow Pattern Count Down (Should be initialized to OVERFLOW_PATTERN_SIZE)
	DEFB 0		; Opponent Combo Count
	DEFB #0		; flags


BOARD2
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD2_DATA
	DEFW #0890	; Screen POSITION Y,X
	DEFB 0		; LineTotal
	DEFB 0		; LineCount
	DEFB 0		; Cursor (in Chars)
	DEFW ClownIdleAnimator2	; Clown Animation Sequence
	DEFB 0		; Animation State Frame
	DEFW #0000	; Overflow Pattern Table Base Address
	DEFW #0000	; Overflow Pattern Table Address
	DEFB 0		; Overflow Pattern Count Down (Should be initialized to OVERFLOW_PATTERN_SIZE)
	DEFB 0		; Opponent Combo Count
	DEFB #0		; flags


;Shared Vars
BOARDS_DROP_ANIM_CNT	DEFB	#00		; Used to control Board Vertical Drop Animation


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

; This arrangement, allows us to process game logic faster since vertical positions are adjacent

BOARD1_DATA
	REPT 11*7
		DEFB #00
	ENDM


BOARD2_DATA
	REPT 11*7
		DEFB #00
	ENDM


BOARD_DATA_END_MARKER
	DEFB #FF	

	
;include "Patterns.asm"

; Used to keep generated Ball Colors history, so that both players get the same values
; TODO, Can't we use ROM DATA for generation ?
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
