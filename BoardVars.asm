BOARD1
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD1_DATA
	DEFW #0000	; START POSITION YX
	DEFB #0		; flags


BOARD2
	DEFB 0		; Height
	DEFB 0		; Width
	DEFW #0000	; BOARD2_DATA
	DEFW #0090	; START POSITION YX
	DEFB #0		; flags

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