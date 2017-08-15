; Game Board Structure
; DEFB height
; DEFB width
; DEFW Buffer * (pointer) with (H x W) entries (1 byte for each?)
; DEFW screen start position (YX)
; DEFB flags


; Functions/Methods for a game board
;====================================

BoardInit
; Inputs:
; IX = GameBoard Pointer to Data Structure
; B = Height (in items)
; C = Width (in items)
; DE = Pointer free buffer for (H x W) entries

; Output: Initializes Board Data Structure
;	Trashes A and BC

	; Init Dimensions
	LD (IX+BRD_HEIGHT), B	; Height
	LD (IX+BRD_WIDTH ), C	; Width

	; Init Buffer
	LD (IX+BRD_BUF_H), D	; Buffer pointer HIGH
	LD (IX+BRD_BUF_L), E	; Buffer Pointer LOW

	; WARNING:
	;	Position is not initialized YET
	;	Flags is not initialized YET
	
	LD A, #00	; EMPTY Slot

BoardInit_JP1
	LD (DE), A
	INC DE	
	DJNZ	BoardInit_JP1

	DEC C
	JP NZ,	BoardInit_JP1	
RET

	
BoardInitDraw; COLOR
; Inputs:
;	IX = Board Structure
	
	LD C, (IX+BRD_HEIGHT)	; Height
	LD B, (IX+BRD_WIDTH )	; Width

	LD D, (IX+BRD_POS_Y)	; Start Position Y
	LD E, (IX+BRD_POS_X)	; Start Position X

	JP BoardDraw_JP1

BoardDraw_JP0
	;CALC Next Column
	LD HL, #0010
	ADD HL,DE
	EX DE, HL

BoardDraw_JP1
	LD A, C
	DEC A	; amount of times to repeat

	PUSH BC	; Save Counters
	PUSH DE	; POSITION YX

	LD HL, BubbleEmpty
	CALL Blit	; Blits Full Column (1 + A times)

	POP DE
	POP BC

	DJNZ BoardDraw_JP0
RET

BoardDrawCol
; Inputs:
;	IX = Board Structure
;	HL = Column Start Buffer 
;	DE = Column Start Position (Y, X)
	
	LD	B, (IX+BRD_HEIGHT)	; Height

	LD	C, #10	; Y Increm
	JR	BoardDrawCol_JP1

BoardDrawCol_JP0

	; Increment Y Position
	LD	A, D
	ADD	A, C 
	LD	D, A
	
	;Next Data Row (same Column)
	INC	HL

BoardDrawCol_JP1

	PUSH HL
	PUSH DE	; POSITION YX
	PUSH BC	; Save Counters

	LD A, (HL)	; Bubble Item
	
	; Determine BUBBLE_TAB ndex
	ADD	A, A	; *2 
	ADD	A, A	; *4
	ADD	A, A	; *8

	LD H, HIGH BUBBLE_TAB	; HL Points to Bitmap Struct
	LD L, A
	
	CALL Blit0

	POP BC
	POP DE
	POP HL

	DJNZ BoardDrawCol_JP0
RET


BoardPressCol	; Adds another item into specific col
; Inputs:
;	IX = Board Structure
; 	A = New Item (previous)
;	? = Row Index

	LD C, (IX+BRD_HEIGHT)
	LD B, C
	
	LD H, (IX+BRD_BUF_H)
	LD L, (IX+BRD_BUF_L)
	
	EX AF, AF'	; Save index

BoardPressCol_LOOP
	LD A, (HL)
	CP #00

	JP Z, BoardPressCol_LAST
	
	EX AF, AF'	;	Swap Existing with previous
	LD (HL), A

	INC HL

	DJNZ BoardPressCol_LOOP	; Exit if end of Column Height

	RET	

BoardPressCol_LAST
	EX AF, AF'	;	Insert new Item
	LD (HL), A
	
RET