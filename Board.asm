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
; HL = GameBoard Pointer to DataStructure (Should use IX instead)
; D = Height (in items)
; E = Width (in items)
; BC = Pointer free buffer for (H x W) entries

; Output: Initializes Board Data Structure
;	Keeps HL and DE
;	Trashes A and BC

	PUSH HL
	
	; Init Dimensions
	LD (HL), D	; Height
	INC HL
	LD (HL), E	; Width
	INC HL

	; Init Buffer
	LD (HL), B	; LOW  Buffer pointer
	INC HL
	LD (HL), C	; HIGH Buffer Pointer

	; WARNING:
	;	Position is not initialized YET
	;	Flags is not initialized YET
	
	LD H, B		; HL = BC = buffer
	LD L, C

	LD B, D		; Height	
	LD C, E		; Width

	LD A, #00	; EMPTY Slot

BoardInit_JP1
	LD (HL), A
	INC HL	
	DJNZ	BoardInit_JP1

	DEC C
	JP NZ,	BoardInit_JP1
	
	POP HL
RET

	
BoardDraw; COLOR
; Inputs:
;	IX = Board Structure
	
	LD C, (IX+0)	; Height
	LD B, (IX+1)	; Width

	LD E, (IX+4)	; Start Position HIGH
	LD D, (IX+5)	; Start Position LOW

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

	LD HL, BubbleWhite ; BubbleMissing
	CALL CBlit	; Blits once plus A extra times

	POP DE
	POP BC

	DJNZ BoardDraw_JP0
RET