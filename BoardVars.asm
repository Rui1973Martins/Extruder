BRD_HEIGHT 		EQU	0	; Height
BRD_WIDTH		EQU	1	; Width
BRD_BUF			EQU 2	; BOARD_DATA Addr
BRD_BUF_H		EQU	2	; BOARD_DATA High
BRD_BUF_L		EQU	3 	; BOARD_DATA Low
BRD_POS			EQU 4	; Screen POSITION
BRD_POS_X		EQU 4	; Screen POSITION X
BRD_POS_Y		EQU	5	; Screen POSITION Y
BRD_LINE_TOT	EQU 6	; LineTotal
BRD_LINE_CNT	EQU 7	; LineCount
BRD_CUR_X		EQU 8	; Cursor (in Chars) relative to START POSITION_X
BRD_ANIM		EQU 9	; Clown Animation Sequence (With and without ball)
BRD_ANIM_STATE	EQU 11	; Animation State Frame
BRD_FLAGS		EQU	12	; flags


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
	DEFB #0		; flags


;Shared Vars
BOARDS_DROP_ANIM_CNT	DEFB	#00		; Used to control BOard Vertical Drop Animation


BOARD_PATTERN_SINGLE	DEFB	16,15,5,2,1,1,0,1,1,2,5,15,16

BOARD_PATTERN_DUAL	DEFB		0,0,0,0,0,0,0
BOARD_PATTERN1	DEFB	3,2,1,0,1,2,3
BOARD_PATTERN2	DEFB	2,1,1,0,1,1,2

BOARD_PATTERN_FOOL
	DEFB	0,	0,	0,	0,	0,	0,	0	; Zero Rebased from		1,	1,	1,	1,	1,	1,	1
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O	O	O	O	O
	;2		O	O	O	O	O	O	O
	;1		O	O	O	O	O	O	O
	;0		O	O	O	O	O	O	O

BOARD_PATTERN_STAR	; NOTE SAME as CHARIOT
	DEFB	6,	4,	2,	0,	1,	3,	5	; Zero Rebased from		7,	5,	3,	1,	2,	4,	6
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5			O	O	O	O	O	O
	;4			O	O	O	O	O	
	;3				O	O	O	O	
	;2				O	O	O		
	;1					O	O		
	;0					O			

BOARD_PATTERN_CHARIOT
	DEFB	6,	4,	2,	0,	1,	3,	5	; Zero Rebased from		7,	5,	3,	1,	2,	4,	6
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5			O	O	O	O	O	O
	;4			O	O	O	O	O	
	;3				O	O	O	O	
	;2				O	O	O		
	;1					O	O		
	;0					O			

BOARD_PATTERN_PRIESTESS
	DEFB	3,	0,	3,	4,	3,	0,	3 	; Zero Rebased from		4,	1,	4,	5,	4,	1,	4
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O		O	O	O
	;2			O				O	
	;1			O				O	
	;0			O				O	

BOARD_PATTERN_JUSTICE
	DEFB	3,	3,	1,	0,	1,	3,	3 	; Zero Rebased from		4,	4,	2,	1,	2,	4,	4
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O	O	O	O	O
	;2				O	O	O		
	;1				O	O	O		
	;0					O			
	
BOARD_PATTERN_MAGICIAN
	DEFB	4,	1,	0,	2,	0,	1,	4 	; Zero Rebased from		5,	2,	1,	3,	1,	2,	5
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3			O	O	O	O	O	
	;2			O	O	O	O	O	
	;1			O	O		O	O	
	;0				O		O		

BOARD_PATTERN_WORLD
	DEFB	0,	1,	2,	3,	3,	3,	3 	; Zero Rebased from		1,	2,	3,	4,	4,	4,	4
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O	O	O	O	O
	;2		O	O	O
	;1		O	O
	;0		O

	
;BOARD_PATTERN_MOON
;	DEFB	1,	2,	3,	4,	3,	2,	1	
;	;8		O	O	O	O	O	O	O
;	;7		O	O	O	O	O	O	O
;	;6		O	O	O	O	O	O	O
;	;5		O	O	O	O	O	O	O
;	;4		O	O	O	O	O	O	O
;	;3		O	O	O		O	O	O
;	;2		O	O				O	O
;	;1		O						O


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
	
; Used to keep generated Ball Colors history, so that both players get the same values
; TODO, Can't we use ROM DATA for generation ?
; Would avoid having to keep a copy of the items.
BOARD_GEN_HISTORY
	REPT 11*7*2	; Must be enough to keep the entire game input (MAX 250 per user ?)
		DEFB #00
	ENDM

