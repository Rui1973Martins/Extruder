BRD_HEIGHT 	EQU	0
BRD_WIDTH	EQU	1
BRD_BUF_H	EQU	2
BRD_BUF_L	EQU	3 
BRD_POS_X	EQU 4
BRD_POS_Y	EQU	5
BRD_LINE_TOT	EQU 6
BRD_LINE_CNT	EQU 7
BRD_CUR_X	EQU 8
BRD_FLAGS	EQU	9

BOARD1
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD1_DATA
	DEFW #0800	; START POSITION Y,X
	DEFB 0		; LineTotal
	DEFB 0		; LineCount
	DEFB 0		; Cursor (in Chars)
	DEFB #0		; flags


BOARD2
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD2_DATA
	DEFW #0890	; START POSITION Y,X
	DEFB 0		; LineTotal
	DEFB 0		; LineCount
	DEFB 0		; Cursor (in Chars)
	DEFB #0		; flags


BOARD_PATTERN1	DEFB 3,2,1,0,1,2,3
BOARD_PATTERN2	DEFB 2,1,1,0,1,1,2

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