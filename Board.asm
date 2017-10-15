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

	PUSH BC

	JR BoardUpdate_COL
	
 BoardUpdate_LOOP

	PUSH BC		; TODO, can it be further optimized ?
		; CALL BoardColNextBuf	; Trashes BC
		; INLINED
			LD	B, 0
			LD	C, (IX+BRD_HEIGHT)	; TODO: Optimize by self modify this code into a LD C, nn, updated at start
			ADD	HL, BC

	; CALL BoardColNextPos
	; INLINED
		LD	A, #10		; TODO, Increment Column
		ADD	A, E
		LD	E, A	

 BoardUpdate_COL
	PUSH DE
	PUSH HL

	; TODO: Optimize, by taking into account that we know how Y increment is done
	; Hence we only NEED to CALC once the screen address, and then we can just update screen address
	
	; CALL BoardDrawCol
	; INLINE Function
			; BoardDrawCol
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
					LD	A, (IX+BRD_HEIGHT)	; Height	; TODO: Optimize by self modify this code into a LD A, nn, updated at start
				DEC A ; HACK, avoid updating last row, since it's mostly never full, since last row is for bursting/loosing


				JP	BoardDrawCol_JP1	; Absolute JP is Faster
				; TODO ? Optimize, if JP0 and JP1 is only a single byte instruction, maybe
				; we can add a single byte here, instead of a Jump, that will include the next byte as part of the
				; current instruction, saving us a JUMP (10T), by doing something smaller (LD ?, nn ;7T)
				; NOTE: probably not worth it, since this is not inside the critical inner loop
				
			 BoardDrawCol_JP0
								
				;Next Data Row (same Column)
				INC	HL

			 BoardDrawCol_JP1

				EX AF, AF'	;  4T	; Save Counter

				PUSH HL		; Start of Sprite Color Data

				LD A, (HL)	; Bubble Item
				
				; Determine BUBBLE_TAB_C_COMPACT index LOW ADDR
				ADD	A, A		; *2 
				ADD	A, A		; *4 

				LD H, HIGH BUBBLE_TAB_C_COMPACT	; HL Points to Bitmap Struct
				LD L, A
				
					; CALL B_CBlit_H2W2
					; INLINED, Specific Optimized code for Sprite 2x2

					;	LD A,(HL)	; Color Data
					;	INC HL							
					;	LD H,(HL)
					;	LD L,A
					;	; TODO These 4 lines above, to load HL, could be optimized OUT
					;	; using special alignment, ensuring H for Ball colors would be the same for all BUBBLE_* colors

						; LOOP Completely UNROLLED for 2x2								
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

				POP HL

				EX AF, AF'				; 4T	; Recover counter
				DEC A					; 4T
				JP NZ, BoardDrawCol_JP0	; 10T				
			;RET

	POP HL	; TODO for optimization purposes, we can delay this POP into BoardUpdate_LOOP and exit, to free HL
	POP DE	; TODO for optimization purposes, we can delay this POP into BoardUpdate_LOOP and exit, to free DE
	POP BC
	
	DJNZ BoardUpdate_LOOP
RET


BoardStepAnim
	INC	(IX+BRD_ANIM_STATE)	; Step counter
	
	LD	HL, ClownIdleAnimFrames
	LD	A, (IX+BRD_ANIM_STATE)
	AND (HL)	; MASK
	RLA			; simplification from  SLA A, since Carry is clear
	RLA			; x4
	LD	E, A
	LD	D, 0
	INC HL
	INC HL	; point to frames
	ADD HL, DE
	
	LD	C, (IX+BRD_ANIM)
	LD	B, (IX+BRD_ANIM+1)
	LD	DE, 2
	EX DE, HL	; Save HL
		ADD	HL, BC
	EX	DE, HL

	; Replace PX address in Animator
	LDI	; CL Address
	LDI
	LDI	; Px Address
	LDI
	; NOTE could instead of updating animator Address, try to enter bliter with X and Y setup and HL pointing to start of CL and PX
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
	;LD	HL, ClownIdleAnimator ; Clown0
	LD	L, (IX+BRD_ANIM)	; Low
	LD	H, (IX+BRD_ANIM+1)	; High
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
		; CALL BoardColNextBuf
		; INLINED
			LD	B, 0
			LD	C, (IX+BRD_HEIGHT)
			ADD	HL, BC
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

