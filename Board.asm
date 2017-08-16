; Game Board Structure
; DEFB height
; DEFB width
; DEFW Buffer * (pointer) with (H x W) entries (1 byte for each?)
; DEFW screen start position (YX)
; DEFB LineTotal (Total New Lines to be inserted ) 
; DEFB LineCount (Count New Lines ALREADY inserted)
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

	LD (IX+BRD_LINE_TOT), 0	; New LineTotal
	LD (IX+BRD_LINE_CNT), 0	; New LineCount
	
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

	JP BoardInitDraw_JP1

 BoardInitDraw_JP0
	;CALC Next Column
	LD HL, #0010
	ADD HL,DE
	EX DE, HL

 BoardInitDraw_JP1
	LD A, C
	DEC A	; amount of times to repeat

	PUSH BC	; Save Counters
	PUSH DE	; POSITION YX

	LD HL, BubbleEmpty
	CALL Blit	; Blits Full Column (1 + A times)

	POP DE
	POP BC

	DJNZ BoardInitDraw_JP0
RET


BoardColNextPos
; Inputs:
;	DE = Column Start Position (Y, X)

	LD	A, #10		; TODO, Increment Column
	ADD	A, E
	LD	E, A	

RET	; FALLTHROUGH ?


BoardColNextBuf
; Inputs:
;	HL = Column Start Buffer

	LD	B, 0
	LD	C, (IX+BRD_HEIGHT)
	ADD	HL, BC
RET


BoardUpdateAll
; Inputs:
;	IX = Board Structure

	LD B, (IX+BRD_WIDTH )	; Width

	LD D, (IX+BRD_POS_Y)	; Start Position Y
	LD E, (IX+BRD_POS_X)	; Start Position X
	LD H, (IX+BRD_BUF_H)	; Col Buffer
	LD L, (IX+BRD_BUF_L)	; Col Buffer

	JR BoardUpdate_COL
	
 BoardUpdate_LOOP

	CALL BoardColNextPos
	PUSH BC		; TODO, Need to optimize this, to not trash BC, or process it in another way
		CALL BoardColNextBuf	; Trashes BC
	POP BC

 BoardUpdate_COL
	PUSH BC
	PUSH DE
	PUSH HL

	CALL BoardDrawCol

	POP HL
	POP DE
	POP BC
	
	DJNZ BoardUpdate_LOOP

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


BoardColInject	; Adds another item into specific col
; Inputs:
;	IX = Board Structure
; 	A = New Item (previous)
;	HL = Column Start Buffer 

	LD C, (IX+BRD_HEIGHT)
	LD B, C
		
	EX AF, AF'	; Save index

 BoardColInject_LOOP
	LD A, (HL)
	CP #00

	JP Z, BoardColInject_LAST
	
	EX AF, AF'	;	Swap Existing with previous
	LD (HL), A

	INC HL

	DJNZ BoardColInject_LOOP	; Exit if end of Column Height

	RET	

 BoardColInject_LAST
	EX AF, AF'	;	Insert new Item
	LD (HL), A
	
RET


BoardAddLineTotal
; Inputs:
;	IX = Board Structure
; 	A = Lines to ADD

	LD	C, (IX+BRD_LINE_TOT)	; LineTotal
	ADD	A, C
	LD	(IX+BRD_LINE_TOT), A	; LineTotal += A 
RET
	
	
BoardInjectLine
; Inputs:
;	IX = Board Structure
; 	A = New Item (previous)
; ?	HL = Column Start Buffer 
;	DE = LineData Pointer
	
	LD	C, (IX+BRD_LINE_CNT)	; LineCount (always <= LineTotal)
	LD	A, (IX+BRD_LINE_TOT)	; LineTotal
	CP	C
	RET Z						; ( LineTotal - LineCount ) == 0
	JP	P, BoardInjectLine_JP1	; ( LineTotal - LineCount )  > 0

	; Reset Line Info
	LD	(IX+BRD_LINE_TOT), 0	; Reset LineTotal
	LD	(IX+BRD_LINE_CNT), 0	; Reset LineCount
	RET
	
BoardInjectLine_JP1
	
	INC C						; Must be true before ( LineTotal > LineCount )
	LD	(IX+BRD_LINE_CNT), C	; LineCount++

	LD	B, (IX+BRD_WIDTH)	; Width

	LD H, (IX+BRD_BUF_H)	; Buffer
	LD L, (IX+BRD_BUF_L)

	JR	BoardInjectLine_TEST
	
 BoardInjectLine_LOOP
 
    INC DE

	PUSH BC
		CALL BoardColNextBuf
	POP BC
	
 BoardInjectLine_TEST
 
	LD	A, (DE)				; New Line Rule, Example: ( 3 2 2 1 2 2 3 )
	CP	C					; LineCount

	JP	P,	BoardInjectLine_NEXT	; BoardInjectLine_DO

 BoardInjectLine_DO	
	; Positive or Zero, Injects
	PUSH BC

		; Determine Next Color from History
		LD A, 4	; Yellow
		
		PUSH HL	
			CALL BoardColInject
		POP HL

	POP BC

 BoardInjectLine_NEXT

	DJNZ BoardInjectLine_LOOP

RET

