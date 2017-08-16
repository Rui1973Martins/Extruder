; Game Board Structure
; DEFB height
; DEFB width
; DEFW Buffer * (pointer) with (H x W) entries (1 byte for each?)
; DEFW screen start position (YX)
; DEFB LineTotal (Total New Lines to be inserted ) 
; DEFB LineCount (Count New Lines ALREADY inserted)
; DEFB Cursor or Clown Relative Pos (Defaults to Centered, to Width)
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

	; Center at middle
	LD A, C					; Cursor or Clown POS 
	SRA A					; Integer Divide By 2
	; since we start at 0, and Sprite has width, discard this
	;INC A					; Divide by 2, + 1 will center (with Odd Width)
	LD (IX+BRD_CUR_X), A	; Cursor or Clown POS 

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

	; CALL BoardDrawCol
	; INLINE Function
			BoardDrawCol
			; Inputs:
			;	IX = Board Structure
			;	HL = Column Start Buffer 
			;	DE = Column Start Position (Y, X)
				
				; CALL ColorADA	; Update DE to Color Address
						; ; UNROLL CALL
						LD A,D
						RRA;Dump 3
						RRA
						RRA
						RRA;->D->E
						RR E
						RRA;->D->E
						RR E
						RRA;->D->E
						RR E
						AND #03;High
						OR  #58;Addr
						LD D,A

				;LD	B, (IX+BRD_HEIGHT)	; Height
				; ALTERNATIVE to BC PUSH + POP
					LD	A, (IX+BRD_HEIGHT)	; Height
					EX AF, AF'	; Save Counter

				LD	C, #10	; Y Increm

				JP	BoardDrawCol_JP1	; Absolute JP is Faster

				
			 BoardDrawCol_JP0
				; ALTERNATIVE to BC PUSH + POP
					EX AF, AF'	;  4T	; Save Counter
				
				; ; Increment Y Position
				; LD	A, D	; 4T
				; ADD	A, C 	; 7T
				; LD	D, A	; 4T
								; 15T Total inlcuding push + pop -=> 15 + 10 + 11 = 36T
				
				;Next Data Row (same Column)
				INC	HL

			 BoardDrawCol_JP1

				PUSH HL		; Start of Sprite Color Data

				LD A, (HL)	; Bubble Item
				
				; Determine BUBBLE_TAB ndex
				ADD	A, A		; *2 

				LD H, HIGH BUBBLE_TAB_C	; HL Points to Bitmap Struct
				LD L, A
				
					;CALL B_CBlit_H2W2
						; INLINED, Specific Ottimized code for Sprite 2x2

							LD A,(HL)	; Color Data
							INC HL							
							LD H,(HL)
							LD L,A
							; TODO These 4 lines above, to load HL, could be optimized OUT
							; using special alignment, ensuring H for Ball colors would be the same as the one in BUBBLE_TAB_C
							; and ahving BUBBLE_TAB_C only having one Byte with the low byte of each Color Address.

							; LOOP Completly UNROLLED for 2x2								
									LDI
									LDI

								LD	BC,#0020-2	; Optimized for Width 2
								EX	DE, HL		;SaveHL
								ADD	HL, BC
								EX	DE, HL		;RestHL and DE

									LDI			; 16T
									LDI			; 16T

								LD	BC,#0020-2	; 10T		Optimized for Width 2
								EX	DE, HL		;  4T		SaveHL
								ADD	HL, BC		; 11T
								EX	DE, HL		;  4T		RestHL and DE
												; 29T Total
						;RET	
							; Alternative LOOP (Slower ?)
								; LD	BC,#0020-2	; 10T	; Optimized for Width 2

								; LD (DE),A	;  7T
								; INC D		;  4T
								; LD (DE),A	;  7T
								; INC DE	;  6T
											; 24T
								
								; EX	DE, HL		;  4T	;SaveHL
								; ADD	HL, BC		; 11T
								; EX	DE, HL		;  4T	;RestHL and DE
													; 19T Total
													
								; LD (DE),A
								; INC 
								; LD (DE),A
								; INC DE
								
								; EX	DE, HL		;SaveHL
								; ADD	HL, BC
								; EX	DE, HL		;RestHL and DE

				POP HL

				; POP BC				; 10Y				
				;DJNZ BoardDrawCol_JP0	; 13T
				; ALTERNATIVE to BC PUSH + POP 
					EX AF, AF'				; 4T	; Recover counter
					DEC A					; 4T
					JP NZ, BoardDrawCol_JP0	; 10T
				
			;RET

	POP HL
	POP DE
	POP BC
	
	DJNZ BoardUpdate_LOOP
RET




BoardDrawCursor
; Inputs:
;	IX = Board Structure

	LD D, (IX+BRD_POS_Y)	; Start Position Y
	LD E, (IX+BRD_POS_X)	; Start Position X

	LD A, (IX+BRD_CUR_X)	; Cursor X (in Chars)
	ADD A, A				; * 2
	ADD A, A				; * 4
	ADD A, A				; * 8	
	ADD A, A				; * 16	A = ( ItemWidth * Cur_X ) (in Pixels)	
	
	ADD A, E				;       A = ( ItemWidth * Cur_X ) + Position_X
	LD	E, A				; ABS X   = ( ItemWidth * Cur_X ) + Position_X				
	
; TODO; OPtimize this, by pre-calc this in BoardInit
		LD B, (IX+BRD_HEIGHT )	; Height
		LD C, 16				; Two chars height per Item
		LD A, D					; Start Position Y

	 BoardDrawCursor_MUL
		ADD A, C
		DJNZ BoardDrawCursor_MUL	; A = Height * ItemHeight, (in Pixels)
		
		SUB (3*8)				; Subtract 3 Chars height (1.5 * Item Height)
; TODO END
	LD D, A					; Y = Position_Y + (Height * 8) , (in Pixels )
	
	; DE has position YX
	
	; TODO Draw Current Clown Frame 
	LD	HL, Clown0
	CALL Blit0
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
		LD A, C	; Yellow
		AND #07	; Mask
		
		PUSH HL	
			CALL BoardColInject
		POP HL

	POP BC

 BoardInjectLine_NEXT

	DJNZ BoardInjectLine_LOOP

RET

