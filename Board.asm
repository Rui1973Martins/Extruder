DEBUG_ATTR_LOCATION1	EQU	+32*23+ATTR
DEBUG_ATTR_LOCATION2	EQU	+32*23+ATTR+1

; Characters
DEVIL			EQU	 0
FOOL			EQU  1
STAR			EQU  2
CHARIOT			EQU  3
PRIESTESS		EQU  4
JUSTICE			EQU  5
MAGICIAN		EQU  6
WORLD			EQU  7
STRENGTH		EQU  8
EMPRESS			EQU  9
BLACK_PIERROT	EQU 10

; Bubble Codes
B_0	EQU 0	; Empty code (if used on Attack Patterns, means TODO/UNKNOWN)
B_R	EQU	1	; r = red
B_G	EQU	2	; g = green
B_B	EQU	3	; b = blue
B_Y	EQU	4	; y = yellow
B_W	EQU	5	; w = white/Cristal/ROCK
B_M	EQU	6	; m = multicolor ?
B_X	EQU	7	; x = undestructable bubble (must be trasnformed/compacted by another ball being thrown)

BUBBLE_PAPER_COLOR_TAB
	DEFB	0x00
	DEFB	0x10	; RED		for B_R
	DEFB	0x20	; GREEN		for B_R
	DEFB	0x08	; BLUE		for B_B
	DEFB	0x30	; YELLOW	for B_Y
	DEFB	0x78	; WHITE		for B_W
	DEFB	0x18	; MULTICOL	for B_M
	DEFB	0x38	; Black		for B_X


OPPONENT_1P_VS_CPU_TAB_SIZE	EQU BLACK_PIERROT+1
OPPONENT_1P_VS_CPU_TAB
	DEFB	FOOL
	DEFB	STAR
	DEFB	DEVIL
	DEFB	CHARIOT
	DEFB	PRIESTESS
	DEFB	JUSTICE
	DEFB	MAGICIAN
	DEFB	WORLD
	DEFB	STRENGTH
	DEFB	EMPRESS



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
; A = Opponent Character
; B = Height (in items)
; C = Width (in items)
; DE = Pointer free buffer for (H x W) entries
; HL = START POSITION Y,X 

; Output: Initializes Board Data Structure
;	Trashes A and BC

	; Init Dimensions
	LD (IX+BRD_HEIGHT), B	; Height
	LD (IX+BRD_WIDTH ), C	; Width

	; Init Buffer
	LD (IX+BRD_BUF_H), D	; Buffer pointer HIGH
	LD (IX+BRD_BUF_L), E	; Buffer Pointer LOW

	; Init Screen Position
	LD (IX+BRD_POS_Y), H	; Buffer pointer HIGH
	LD (IX+BRD_POS_X), L	; Buffer Pointer LOW

	LD (IX+BRD_LINE_TOT), 0	; New LineTotal
	LD (IX+BRD_LINE_CNT), 0	; New LineCount

	; Init Attack Tab
	; NOTE: This block could eventualy be refactored to an outside function, would save PUSH/POP, but would cost another CALL/RET
	PUSH DE
		LD	D,	0

		; Make sure we are within valid range (0 to BOARD_ATTACK_PATTERN_TAB_COUNT)

		; Check Upper Boundary
		CP	BOARD_ATTACK_PATTERN_TAB_COUNT
		JP	M, BoardInit_CheckLowerBoundary ; Jump if less than BOARD_ATTACK_PATTERN_TAB_COUNT

		XOR A							; Clear to default 0 (Default could be input as A', and use EX AF, AF' intead )
		JR BoardInit_AttackTab

BoardInit_CheckLowerBoundary
		CP D
		JP	P, BoardInit_AttackTab 		; Jump if greater than or EQUAL to zero
		
		XOR A							; Clear to default 0

BoardInit_AttackTab
		ADD A, A						; Mutiply by 2		
		LD	E, A

		LD	HL, BOARD_ATTACK_PATTERN_TAB
		ADD HL, DE

		LD	A, (HL)
		LD	(IX+BRD_ATTACK_Base_L), A
		LD	(IX+BRD_ATTACK_TAB_L), A
		INC	HL
		LD	A, (HL)
		LD	(IX+BRD_ATTACK_Base_H), A
		LD	(IX+BRD_ATTACK_TAB_H), A
	POP DE

	; RESET ATTACK_PATTERN Count Down Counter
	LD	A, ATTACK_PATTERN_SIZE
	LD	(IX+BRD_ATTACK_CNT), A


	; Center Clown XPos at middle
	LD A, C						; Width 
	SRA A						; Integer Divide By 2
	; since we start at 0, and Sprite has width, discard this
	;INC A						; Divide by 2, + 1 will center (with Odd Width)
	LD (IX+BRD_CUR_X), A		; Cursor or Clown POS 
	LD (IX+BRD_CUR_X_LAST), A	; Cursor or Clown POS 

	; WARNING:
	;	Flags is not initialized YET
	
	LD A, #00	; EMPTY Slot

	LD	H,	B	; Save B
	
BoardInit_JP0	; Clear Board Buffer Contents
	LD	B,	H	; Restore B
	
BoardInit_JP1
	LD (DE), A
	INC DE	
	DJNZ	BoardInit_JP1

	DEC C
	JP NZ,	BoardInit_JP0

	;--------------------
	; CALC Cursor Y
	;--------------------		
		LD A, (IX+BRD_POS_Y)	; Start Position Y
		LD B, (IX+BRD_HEIGHT )	; Height
		LD C, 16				; Two chars height per Item

	 BoardInitCur_MUL
		ADD A, C
		DJNZ BoardInitCur_MUL	; A = Height * ItemHeight, (in Pixels)

		SUB (3*8)				; Subtract 3 Chars height (1.5 * Item Height)
		LD	(IX+BRD_CUR_Y), A	; Cursor Y (Constant after init)

	;--------------------
	; Reset several Vars
	;--------------------
	XOR	A
	LD	(IX+BRD_COMBO_CNT), A	; RESET Combo
	LD	(IX+BRD_FLAGS), A		; RESET Flags to BRD_FLAG_NONE

	;XOR A								; B_0
	LD	(IX+BRD_PUSH_PULL_COLOR), A

	;LD	A, PP_ANIM_STATE_STOPPED	 	; = 0x00
	LD	(IX+BRD_PUSH_PULL_ANIM_STATE), A

	; We could clear the PULL/PUSH BASE/ADDR fields, but should not be needed,
	; since we control access through BRD_PUSH_PULL_ANIM_STATE

	; XOR	A
	LD	(IX+BRD_PUSH_PULL_INSERT_CNT), A

	; LD A, GAME_STATE_RUNNING	; GAME_STATE_ROLL_IN
	LD	(IX+BRD_GAME_STATE), A

	LD	(IX+BRD_POP_ANIM), A	; 0 = No pop Anim active
RET


BoardSetFlags				; TODO: This could be inlined, using a MACRO
; Inputs:
;	IX = Board Structure
;	A = Flag contents to set
	LD	(IX+BRD_FLAGS), A
RET


;--------------------
BoardDropAnimLine_Color
;--------------------
; Inputs:
;	IX = Board Structure
;	HL = Bubble Sprite Addr (ODD/EVEN)
; 	 A = Anim Line
	
	ADD A, A	; *2
	ADD A, A	; *4
	ADD A, A	; *8	Half Ball height
;	ADD A, A	; *16	Actual Ball height 
	
	ADD A, (IX+BRD_POS_Y)	; Start Position Y
	LD D, A
	LD E, (IX+BRD_POS_X)	; Start Position X
	
	LD B, (IX+BRD_WIDTH )	; Width
	
 BoardDropAnimLineColor_JP0

	PUSH BC							; Save Counters
		PUSH HL						; Sprite
			PUSH DE					; POSITION YX
				CALL B_CBlitM_W2_0
			POP DE
			
			;CALC Next Column
			LD HL, #0010			; Width of a Ball
			ADD HL,DE
			EX DE, HL				; DE = New (Column) Position

		POP HL
	POP BC		; TODO: Optimize this out, using DEC (var) instead

	DJNZ BoardDropAnimLineColor_JP0
RET


;--------------------
BoardDropAnimLine_Pixels
;--------------------
; Inputs:
;	IX = Board Structure
;	HL = Sprite
;	 A = Anim Line
	
	ADD A, A	; *2
	ADD A, A	; *4
	ADD A, A	; *8	Half Ball height
;	ADD A, A	; *16	Actual Ball height 
	
	ADD A, (IX+BRD_POS_Y)	; Start Position Y
	LD D, A
	LD E, (IX+BRD_POS_X)	; Start Position X

	LD B, (IX+BRD_WIDTH )	; Width
	
 BoardDropAnimLinePx_JP0

	PUSH BC						; Save Counters
		PUSH HL					; Sprite
			PUSH DE				; POSITION YX
				CALL PxBlit0	; Blits Pixels Only
			POP DE

			;CALC Next Column
			LD HL, #0010		; Width of a Ball
			ADD HL,DE
			EX DE, HL			; DE = New (Column) Position

		POP HL
	POP BC			; TODO: Optimize this out, using DEC (var) instead

	DJNZ BoardDropAnimLinePx_JP0
RET


; DEPRECATED
;--------------------
BoardInitDraw;
;--------------------
; Inputs:
;	IX = Board Structure
	
	LD C, (IX+BRD_HEIGHT)	; Height
	LD B, (IX+BRD_WIDTH )	; Width

	LD D, (IX+BRD_POS_Y)	; Start Position Y
	LD E, (IX+BRD_POS_X)	; Start Position X

	JP BoardInitDraw_JP1

 BoardInitDraw_JP0
	;CALC Next Column
	LD HL, #0010			; Width of a Ball
	ADD HL,DE
	EX DE, HL				; DE = New (Column) Position

 BoardInitDraw_JP1
	LD A, C
	DEC A					; amount of times to repeat

	PUSH BC					; Save Counters
		PUSH DE				; POSITION YX
			LD HL, BubbleEmpty
			CALL Blit	; Blits Full Column (1 + A times)
		POP DE
	POP BC

	DJNZ BoardInitDraw_JP0
RET


;--------------------
BoardColNextPos
;--------------------
; Inputs:
;	DE = Column Start Position (Y, X)

	LD	A, #10		; TODO, Increment Column
	ADD	A, E
	LD	E, A	

RET	; FALLTHROUGH ?


;--------------------
BoardColNextBuf
;--------------------
; Inputs:
;	HL = Column Start Buffer

	LD	B, 0
	LD	C, (IX+BRD_HEIGHT)
	ADD	HL, BC
RET

;--------------------
BoardUpdateLastRow	; HalfRow
;--------------------
; Inputs:
;	IX = Board Structure

;Setup required startup data, in sync with BoardUpdateAll

	;LD B, (IX+BRD_WIDTH )	; Width
	LD	B, 1			; Just one Row
	
		LD	C, (IX+BRD_HEIGHT)	; NOTE: Optimized to be in PUSH BC

	LD D, (IX+BRD_POS_Y)	; Start Position Y
	LD E, (IX+BRD_POS_X)	; Start Position X
	LD H, (IX+BRD_BUF_H)	; Col Buffer
	LD L, (IX+BRD_BUF_L)	; Col Buffer

	PUSH BC
		; Buffer - Last Row of first column
			LD	B, 0
			;LD	C, (IX+BRD_HEIGHT)
			DEC C			;Last Row of first column
			ADD	HL, BC

		; Screen Y - Last Row
		LD	B, #10		; Increment in Pixels per Row Item (16x16)
		LD	A, D
BoardUpdateLastRow_multiply
		ADD	A, C
		DJNZ	BoardUpdateLastRow_multiply		
		LD	D, A	

	POP BC					; BC contents needed in inner loop
	PUSH BC

	JR BoardUpdateLastRow_COL	; Reuse BoardUpdateAll Main Loop

BoardUpdateLastRow_LOOP

	PUSH BC		; TODO, can it be further optimized ?
		; CALL BoardColNextBuf	; Trashes BC
		; INLINED
			LD	B, 0
			;LD	C, (IX+BRD_HEIGHT)	; TODO: Optimize by self modify this code into a LD C, nn, updated at start
			ADD	HL, BC

	; Next Y Row
	; INLINED
		LD	A, #10		; Increment in Pixels per Row
		ADD	A, D
		LD	D, A	

 BoardUpdateLastRow_COL
		PUSH DE
			PUSH HL

		; TODO: Optimize, by taking into account that we know how Y increment is done
		; Hence we only NEED to CALC once the screen address, and then we can just update screen address
		
		; CALL BoardDrawRow
		; INLINE Function
			; BoardDrawRow
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

				; ALTERNATIVE to BC PUSH + POP
				LD	A, (IX+BRD_WIDTH)		; WIDTH	; TODO: Optimize by self modify this code into a LD A, nn, updated at start

				LD	B, 0					; Constant for inner Loop
				JP	BoardUpdateLastRow_JP1	; Absolute JP is Faster
				
			 BoardUpdateLastRow_JP0
						
				;Next Data Row (Next Column)						
				;LD	B, 0				; Moved outside inner loop, since it is constant
				;LD	C, (IX+BRD_HEIGHT)
				INC C
				INC C	; Compensate for 2 LDIs
				ADD	HL, BC

			 BoardUpdateLastRow_JP1

				EX AF, AF'	;  4T	; Save Counter

				PUSH HL		; Start of Sprite Color Data

					LD A, (HL)	; Bubble Item
					
					; Determine BUBBLE_TAB_C_COMPACT index LOW ADDR
					ADD	A, A		; *2 
					ADD	A, A		; *4 

					LD L, A
					LD H, HIGH BUBBLE_TAB_C_COMPACT	; HL Points to Bitmap Struct
				
					; CALL B_CBlit_H2W2
					; INLINED, Specific Optimized code for Sprite 2x1 (half height)

						; LOOP Completely UNROLLED for 2x1								
							; --------------------
							; NOTE: Updating ball top half ONLY 
								LDI
								LDI

							; (DE) Next Screen ADDR (to the right) is correct
							
							; (HL) Update Buffer Attr Addr
				POP HL

				EX AF, AF'				; 4T	; Recover counter
				DEC A					; 4T
				JP NZ, BoardUpdateLastRow_JP0	; 10T				
			;RET

			POP HL	; TODO for optimization purposes, we can delay this POP into BoardUpdate_LOOP and exit, to free HL
		POP DE	; TODO for optimization purposes, we can delay this POP into BoardUpdate_LOOP and exit, to free DE
	POP BC
	
	DJNZ BoardUpdateLastRow_LOOP
RET
;--------------------

	
;--------------------
BoardUpdateAll
;--------------------
; Inputs:
;	IX = Board Structure

	LD B, (IX+BRD_WIDTH )	; Width

		LD	C, (IX+BRD_HEIGHT)	; NOTE: Optimized to be in PUSH BC

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
			;LD	C, (IX+BRD_HEIGHT)	; TODO: Optimize by self modify this code into a LD C, nn, updated at start
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
				DEC A ; Do not update last row, since it's used only to show when user lost by board overflow.


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

				LD L, A
				LD H, HIGH BUBBLE_TAB_C_COMPACT	; HL Points to Bitmap Struct
				
					; CALL B_CBlit_H2W2
					; INLINED, Specific Optimized code for Sprite 2x2

					;	LD A,(HL)	; Color Data
					;	INC HL							
					;	LD H,(HL)
					;	LD L,A
					;	; TODO These 4 lines above, to load HL, could be optimized OUT
					;	; using special alignment, ensuring H for Ball colors would be the same for all BUBBLE_* colors

						; LOOP Completely UNROLLED for 2x2								
							; --------------------
						
								; LDI
								; LDI

							; LD	BC,#0020-2	; Optimized for Width 2
							; EX	DE, HL		;SaveHL
							; ADD	HL, BC
							; EX	DE, HL		;RestHL and DE

								; LDI			; 16T
								; LDI			; 16T

							; LD	BC,#0020-2	; 10T		Optimized for Width 2
							; EX	DE, HL		;  4T		SaveHL
							; ADD	HL, BC		; 11T
							; EX	DE, HL		;  4T		RestHL and DE
											; 29T Total

							; --------------------
							; NOTE: Can optimize further, making use of B or C,
							; not being use, except for LDI
							; NOTE: B = 0 (From top), and 4 LDI, will not change that, IF C is big enough
								LDI
								LDI

							LD A, #20-2		; 7T
							ADD A, E		; 4T
							LD E, A			; 4T
							JP	NC, TEST_X1	; 10T
								INC D
							TEST_X1

								LDI			; 16T
								LDI			; 16T

							LD A, #20-2		; 7T
							ADD A, E		; 4T
							LD E, A			; 4T
;Will Never Overflow HERE	JP	NC, TEST_X2	; 10T
;								INC D
;							TEST_X2

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
; Inputs:
;	IX = Board Structure
;	 A = Frame Counter

	;Only change frame in multiples of 4
	; TODO: Better use a frame count down for each Clown frame,
	; since it provides speed control
	AND 0x07
	XOR 0x04
	RET NZ
	
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
		ADD	HL, BC			; We can optimize, by eventually keeping a direct pointer to the position.
	EX	DE, HL

	; Replace PX address in Animator
	LDI	; CL Address
	LDI
	LDI	; Px Address
	LDI
	; NOTE could instead of updating animator Address, try to enter bliter with X and Y setup and HL pointing to start of CL and PX
RET

; ------------------------------------------------------
; NEXT CODE must be reviewed to be included
; ------------------------------------------------------
; LookupAlignedTabMacro MACRO ADDR
		; LD H, HIGH(ADDR)
		; SLA A	;*2
		; LD L,A
		; LD A,(HL)
		; INC HL
		; LD H,(HL)
		; LD L,A
; ENDM
; ; ------------------------------------------------------
; L_ANIM
		; LD L,(IX+6)
		; LD H,(IX+7)		; Anim Structure Addr
		; LD A,(FRAME)	; Frame Number
; LO_ANIM			; Alternative entry point
		; AND (HL)		; Mask - Anim Structure,first byte
		; LD C,A
		; LD A,(HL)		; Shift Mask Right until first bit Set
; ANIMSK		RRA			; While bit0 = 0
			; JR C,ANITAB 
				; SRL C	;   Shift right 
			; JR ANIMSK	; end While
; ANITAB	INC HL			; Reserved Byte
		; INC HL			; First Frame Record Addr
		; SLA C;*4		; Frame Record size = 4
		; SLA C
		; LD B,0
		; ADD HL,BC		; New Frame Number
		; EX DE,HL		; SaveHL
		; LD A,(IX+REC_SPRITE)		; Graphic Index/Type
			; ;CALL LookupSpriteTab
			; LookupAlignedTabMacro LevelSpriteAlignedTab

		; EX DE,HL		; Restore HL
		; INC DE			; DE = Sprite Height (Pixels)
		; INC DE			; DE = Sprite Color Addr
		; LDI				; Replace Sprite Color Addr
		; LDI
		; LDI				; Replace Sprite Pixel Addr
		; LDI
	; RET
; ------------------------------------------------------
; END of to be reviewed
; ------------------------------------------------------


BoardClearCursor
; Inputs:
;	IX = Board Structure

	LD D, (IX+BRD_POS_Y)	; Start Position Y
	LD E, (IX+BRD_POS_X)	; Start Position X

	LD A, (IX+BRD_CUR_X_LAST)	; Cursor X LAST(in Chars)
	ADD A, A				; * 2
	ADD A, A				; * 4
	ADD A, A				; * 8	
	ADD A, A				; * 16	A = ( ItemWidth * Cur_X ) (in Pixels)	

	ADD A, E				;       A = ( ItemWidth * Cur_X ) + Position_X
	LD	E, A				; ABS X   = ( ItemWidth * Cur_X ) + Position_X				
	
	LD	D, (IX+BRD_CUR_Y)		; D = Cursor Y

	; DE has position YX

	; TODO Draw Current Clown Frame	
	LD	HL, ClownErase
	CALL Blit0

	; UPDATE Control variable
	LD	A, (IX+BRD_CUR_X)
	LD	(IX+BRD_CUR_X_LAST), A
RET


BoardUpdateCursor
; Inputs:
;	IX = Board Structure

	LD	A, (IX+BRD_CUR_X_LAST)	; Cursor X LAST(in Chars)
	CP	(IX+BRD_CUR_X)			; Cursor X(in Chars)

	CALL NZ, BoardClearCursor		; TODO: Optimize
; FALL Through

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
	
	LD	D, (IX+BRD_CUR_Y)		; D = Cursor Y

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

	LD	B, (IX+BRD_HEIGHT)	; TODO: We can Load B directly, if we do not need C to have the height
	
	EX AF, AF'		; Save as previous

 BoardColInject_LOOP
	LD A, (HL)
	CP B_0			; B_0 = BOARD EMPTY SPOT

	JP Z, BoardColInject_INSERT
	
	EX AF, AF'		; Swap Existing with previous
	LD (HL), A

	;INC HL			; TODO, we could move this to start of loop, if it allows for faster processing on last element.
					; Could also be replaced with "INC L", if full board play buffer is aligned to 256, and not larger than 256 positions
	INC	L
	
	DJNZ BoardColInject_LOOP	; Exit if end of Column Height
	
BoardColInject_LOST
	;IF we reached the End of the Board, user LOST
	;-------------------------
	LD	A, GAME_STATE_LOST
	JP BoardGameSetState
;RET

 BoardColInject_INSERT
	EX AF, AF'		; Insert new Item
	LD (HL), A

	; If we reached the last ROW (FENCE), user LOST
	LD	A, B
	CP	1			; Last Element
	RET	NZ
	
JP BoardColInject_LOST


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
		;LD A, C	; Yellow
		; Determine Next Color Randomly, (1 to 4)
		;	LD A, R	; Yellow
		;	AND #03	; Mask
		;	INC A
		CALL BoardAttackNext
		
		
		PUSH HL	
			CALL BoardColInject
		POP HL

	POP BC

 BoardInjectLine_NEXT

	DJNZ BoardInjectLine_LOOP

RET


; This function, will extract the next ball color, from the "opponent" character Attack table
BoardAttackNext
; Inputs:
;	IX = Board Structure
; outputs:
; 	A = New Item
; Trashes: A', BC

	LD	B, (IX+BRD_ATTACK_TAB_H)
	LD	C, (IX+BRD_ATTACK_TAB_L)

	LD	A, (BC)
	EX	AF,	AF'		; Save Value

	;Set next item pointer, to be available on next call
	INC BC		; TODO make sure that these tables 7x8 will never cross a 256 boundary, to optimized this to INC C

	;Determine, if we need to loop back
	DEC (IX+BRD_ATTACK_CNT)
	
	JP NZ, BoardAttackNext_Value
		
BoardAttackNext_Reset
	LD	B, (IX+BRD_ATTACK_Base_H) 
	LD	C, (IX+BRD_ATTACK_Base_L)

	LD	A, ATTACK_PATTERN_SIZE
	LD	(IX+BRD_ATTACK_CNT), A
	
	
BoardAttackNext_Value
	LD	(IX+BRD_ATTACK_TAB_H), B	; Update High part only 
	LD	(IX+BRD_ATTACK_TAB_L), C	; Update Low part only 

	EX	AF,	AF'		; Restore Value
	; Do we need to clean up data ?
	; we do not, since that is already been cleaned
	;AND #03	; Mask
	;INC A
RET


;------------------------
BoardProcessPop
;------------------------
; Inputs:
;	IX = Board Structure
; outputs:
; Trashes: A', BC, HL

	LD	A, (IX+BRD_POP_ANIM)		; Item to replace
	CP	BUBBLE_POP
	RET	M							; Any Value Lower means Animation STOPPED

	LD	E, A						; E = Item to replace
	INC A							; A = Replacement Item 
	CP	BUBBLE_POP_END
	JP	P,	BoardProcessPop_end

	LD	(IX+BRD_POP_ANIM), A		; Update Anim
	JP	BoardTransformAll			; CALL and Exit

BoardProcessPop_end
		LD	A, B_0					; Replace with Empty Item
		LD	(IX+BRD_POP_ANIM), A	; Stop POP Anim
		CALL	BoardTransformAll	; CALL and Exit

		; TODO
		; Acount how many were changed ?
		; Scoring, COMBO Calcs
RET


;------------------------
BoardTransformStone
;------------------------
	LD	E, B_W				;B_W = White Bubble = Stone
; FALL Through

;------------------------
BoardTransformAll
;------------------------
; Inputs:
;	IX = Board Structure
;	A = Replacement Item
;	E = Item to Replace
; outputs:
; Trashes: A', BC, HL

	LD	H, (IX+BRD_BUF_H)	; Buffer
	LD	L, (IX+BRD_BUF_L)

	LD	C, (IX+BRD_WIDTH )	; Width

 BoardTransformStone_LOOP
	CALL	BoardColReplace	; TODO: Inline if possible

	DEC C
	JP NZ,	BoardTransformStone_LOOP
RET


;------------------------
BoardColReplace	; Replaces an item by another
;------------------------
; Inputs:
;	IX = Board Structure
; 	A = New Item (replacement)
;	E = Item to Replace
;	HL = Column Start Buffer 

	LD B, (IX+BRD_HEIGHT)	
	EX AF, AF'		; Save replacement

 BoardColReplace_LOOP
	LD A, (HL)
	CP E						; Equal to Item to replace ?

	JR NZ, BoardColReplace_NEXT

	EX AF, AF'					; Swap Existing with Replacement
	LD (HL), A
	EX AF, AF'		; TODO Optimize, use D instead, since it's free.

BoardColReplace_NEXT
;	CP	B_0			; B_0 = EMPTY SLOT
;	JR	Z, BoardColReplace_NEXT_COL

	INC HL

	DJNZ BoardColReplace_LOOP	; Exit if end of Column Height
	EX	AF, AF'					; Restore replacement
RET
BoardColReplace_NEXT_COL
	INC HL

	DJNZ BoardColReplace_NEXT_COL	; Exit if end of Column Height
	EX	AF, AF'					; Restore replacement
RET


;========================
; User input processing
;========================

;------------------------
BoardProcessUserInput
;------------------------
; Inputs:
;	IX = Board Structure
;	A = New User Input
; TRASHES:

	; Save old NEW as LAST key state
	LD	C, (IX+BRD_USER_CTRL_NEW)
	LD	(IX+BRD_USER_CTRL_LAST), C

	; Save Driver result
	LD	(IX+BRD_USER_CTRL_NEW), A
	LD	B,	A

	; We CAN NOT Move, if:
	;	- a PULL is in progress
	; 	- a PUSH is in progress
	LD	A, (IX+BRD_PUSH_PULL_ANIM_STATE)
	;CP	PP_ANIM_STATE_STOPPED		; Hence NOT PP_ANIM_STATE_PULLING and NOT PP_ANIM_STATE_PUSHING
	AND A
	RET NZ
	
	; Process User Keys
	BOARD_INPUT_TEST_LEFT
		LD	A, B			; Restore New
		AND CTRL_LEFT
		JR Z, BOARD_INPUT_TEST_RIGHT 
							; On NEW  Key LEFT was ON  (1)
		LD	A, C			; Restore LAST
		AND CTRL_LEFT		; On LAST Key LEFT was OFF (0)
		;PUSH BC
			CALL Z, BoardGoLeft
		;POP BC

		; NOTE: Reloading will be faster (19T), then PUSH + POP ( 11T + 10T ),
		; if only one of the registers is messed up (B or C, but not both)
		;LD	C, (IX+BRD_USER_CTRL_LAST)

	BOARD_INPUT_TEST_RIGHT
		LD	A, B			; Restore New
		AND CTRL_RIGHT
		JR Z, BOARD_INPUT_TEST_PULL 
							; On NEW  Key RIGHT is ON  (1)
		LD	A, C			; Restore LAST
		AND CTRL_RIGHT		; On LAST Key RIGHT was OFF
		;; PUSH BC
			CALL Z, BoardGoRight
		;; POP BC

	BOARD_INPUT_TEST_PULL
		LD	A, B			; Restore New
		AND CTRL_DOWN
		JR Z, BOARD_INPUT_TEST_PUSH 
							; On NEW  Key PULL is ON  (1)
		LD	A, C			; Restore LAST
		AND CTRL_DOWN		; On LAST Key PULL was OFF
		;; PUSH BC
			CALL Z, BoardPullStart
		;; POP BC

	BOARD_INPUT_TEST_PUSH
		LD	A, B			; Restore New
		AND CTRL_UP
		JR Z, BOARD_INPUT_TEST_OTHERS 
							; On NEW  Key PUSH is ON  (1)
		LD	A, C			; Restore LAST
		AND CTRL_UP			; On LAST Key PUSH was OFF
		;; PUSH BC
			CALL Z, BoardPushStart
		;; POP BC

	BOARD_INPUT_TEST_OTHERS		; TODO: Optimize this out, if not needed.
RET
	
	
;------------------------
BoardGoLeft
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?
;	
	LD	A, (IX+BRD_CUR_X)		; Load current position once
	LD	(IX+BRD_CUR_X_LAST), A	; Update with previous value
	AND A						; Check if position is zero
	JP	NZ,	BoardGoLeftNoWrap	

	LD	A, (IX+BRD_FLAGS)
	AND	BRD_FLAG_WRAP
	RET	Z
	
	LD	A,	(IX+BRD_WIDTH)		; New position ( Right Most position +1 )

BoardGoLeftNoWrap

	DEC	A
	LD	(IX+BRD_CUR_X), A
RET


;------------------------
BoardGoRight
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?
;	
	LD	A, (IX+BRD_CUR_X)		; Load current position once
	LD	(IX+BRD_CUR_X_LAST), A	; Update with previous value
	INC	A
	CP	(IX+BRD_WIDTH)			; Check if position is WIDTH
	JP	NZ,	BoardGoRightNoWrap	

	LD	A, (IX+BRD_FLAGS)
	AND	BRD_FLAG_WRAP
	RET	Z
	
	XOR	A						; New position ( Left Most position )

BoardGoRightNoWrap

	LD	(IX+BRD_CUR_X), A

RET

;------------------------
BoardPullStart
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?

	LD	A, (IX+BRD_PUSH_PULL_ANIM_STATE)

	; TODO: Do we need these extra tests ?
	; we could just test the PP_ANIM_STATE_STOPPED case, and exit if different

	CP	PP_ANIM_STATE_PUSHING
	JP	Z,	BoardPushing

	CP	PP_ANIM_STATE_PULLING
	JP	Z,	BoardPulling

;	CP	PP_ANIM_STATE_STOPPED
;	JP	Z, BoardPullStarting

	BoardPullStarting

		; Get Cursor/Clown Position
		LD	B, (IX+BRD_CUR_X)	; Relative value
		INC	B					; We Need to start from the end of the Column
		
		; Get Column Address (using Clown position)
		LD	L, (IX+BRD_BUF_L)
		LD	H, (IX+BRD_BUF_H)

		; Multiply				; TODO Optimize using Shift Carry method, only 4 bits needed for Width
		LD	C, (IX+BRD_HEIGHT)
		XOR	A
	BoardPullStarting_MULT_1
		; NOTE: B is always > 0, due to the INC B above.
		ADD	A, C
		DJNZ	BoardPullStarting_MULT_1

		;--------------------
		DEC	A	; WARNING: We use the LAST ROW as FENCE, so DO NOT TOUCH.
		;--------------------

		LD	E, A
		LD	D, 0		
		ADD	HL, DE				; Get Address of intended Column last element +1 

		
		; Get Column NEAREST Color
		LD B, C					; Height
		;--------------------
		DEC B	; WARNING: We use the LAST ROW as FENCE, so DO NOT TOUCH.
		;--------------------
		
		; Save Col Anim BASE Addr
		DEC	HL
		LD (IX+BRD_PULL_ANIM_COL_BASE_L), L
		LD (IX+BRD_PULL_ANIM_COL_BASE_H), H

		JP	BoardPullStarting_inFindColor

	BoardPullStarting_FindColor
		DEC	HL

	BoardPullStarting_inFindColor
		LD	A, (HL)
		CP	B_0			; Empty Ball
		JP	NZ, BoardPullStarting_CheckColor

		DJNZ BoardPullStarting_FindColor

		; TODO: Could BEEP, signaling ERROR
		RET				; No Ball Found, so nothing to PULL

	BoardPullStarting_CheckColor	
		LD	C, B		; Save Index
		LD	B, A		; A contains NEAREST Color
		
		; If No Active Color (i.e. Clown has not started a pull yet)
		LD	A, (IX+BRD_PUSH_PULL_COLOR)
		CP	B_0			; Empty Ball
		
		JP	NZ,	BoardPullStarting_CheckNearest
		
		;	TODO: But we must check if it's an acceptable Color (Between 7..1)
		; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		EX	AF, AF'
			LD	A, B
			CP	BUBBLE_POP
			RET	P			; Exit IF >= BUBBLE_POP
		EX	AF, AF'
		; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

		;	Set active color to NEAREST Color
		LD	(IX+BRD_PUSH_PULL_COLOR), B
		JP	BoardPullStarting_NewPull	; 10T

	BoardPullStarting_CheckNearest
		; IF Active Color != NEAREST Color
		CP	B			; 4T	; A -=> Active Color		; B -=> NEAREST Color
		RET	NZ			; 5T or 11T	if Exit ?	SHOULD BEEP ERROR and EXIT ?

	BoardPullStarting_NewPull
		; Start New Pull
		; NOTES:
		; HL	-=> first Ball of Current Active Color
		;  A	-=> ACTIVE Color
		;  B	-=> NEAREST Color
		; ( A == B ) should be true


		; B = NEAREST Color
;		LD	A, B	; Save NEAREST Color			; This can be saved for PullAnim, to be simpler

;		LD	B, C	; Restore Index count
;		LD	C, A	; Save Active Color

		; Save Anim Item Bottom Addr
		LD (IX+BRD_PULL_ANIM_COL_ADDR_L), L
		LD (IX+BRD_PULL_ANIM_COL_ADDR_H), H

		; DEBUG
		LD DE, DEBUG_ATTR_LOCATION1
		CALL BoardDebugActiveColor		

	; TODO: WE DO NOT NEED TO MARK, when Starting a PULL
	; This loop can me removed
;	; BoardPullStarting_Mark
;		OR	0x08	; Active HIGH Color
;		
;		LD	(HL), A	; Set NEAREST to Active HIGH Color
;
;		DEC HL
;		LD	A, (HL)	; validate if next color is the same.
;		CP	C
;		JP	NZ, BoardPullStarting_Anim
;		DJNZ	BoardPullStarting_Mark
		
	BoardPullStarting_Anim			
		; Set Anim State to PP_ANIM_STATE_PULLING
		LD	(IX+BRD_PUSH_PULL_ANIM_STATE), PP_ANIM_STATE_PULLING
	RET

	BoardPulling
	RET

	BoardPushing
	RET
	
	BoardPopping
	RET
	

RET


;------------------------
BoardPullAnim
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?

	; Get Anim Col Bottom BASE Address
	;LD	E, (IX+BRD_PULL_ANIM_COL_BASE_L)
	;LD	D, (IX+BRD_PULL_ANIM_COL_BASE_H)

	; Get Anim Col Bottom Address
	LD	L, (IX+BRD_PULL_ANIM_COL_ADDR_L)
	LD	H, (IX+BRD_PULL_ANIM_COL_ADDR_H)

	LD	E, L			; Copy Addr
	LD	D, H

	; Get PULL_COLOR
	LD	C, (IX+BRD_PUSH_PULL_COLOR)

	; IF Addr = BASE, we reached the bottom.
	LD	A, E
	CP	(IX+BRD_PULL_ANIM_COL_BASE_L)	; Comparing for L provides for a quicker exit
	JP	NZ,	BoardPullAnim_enterLoop
	LD	A, D
	CP	(IX+BRD_PULL_ANIM_COL_BASE_H)
	JP	NZ, BoardPullAnim_enterLoop

BoardPullAnim_bottom
	LD	A, (DE)			; Retrieve Bottom Ball	
	;CP	B_0				; B_0 = 0
	AND A				;	IF BALL is Empty

	;		Goto End PULL
	JP	Z,	BoardPullStop
	
	;	ELSE
	;		Increment Clown Ball Count
	INC	(IX+BRD_PUSH_PULL_CNT)

	JP	BoardPullAnim_inBottom

	; Iterate while Board (HL) Color = PULL Color
BoardPullAnim_loop
; DEPRECATED COPY, since we only need to copy the first and last
; All others are guaranteed to be identical
;	LD	(DE), A						; Move Ball one position down

	DEC	DE							; prepare next Position
BoardPullAnim_inBottom
	DEC	HL
				; NOTE: TODO: We MUST CHECK Array Column Bounds limit
	LD	A, (HL)						; Check if there are more balls to move.
	CP	C
	JP	Z, BoardPullAnim_loop	; Exit if no more Balls

BoardPullAnim_endLoop
	XOR	A							; B_0
	LD	(DE), A						; Clear (last) Position
RET

BoardPullAnim_enterLoop
	INC	DE							; Update Position for next call
	LD	(IX+BRD_PULL_ANIM_COL_ADDR_L), E	
	LD	(IX+BRD_PULL_ANIM_COL_ADDR_H), D

	LD	A, (HL)						; Retrieve Ball
	LD	(DE), A						; Move NEAREST/First Ball one position down
	JP	BoardPullAnim_loop
;--------------------	
	
	
;------------------------
BoardPullStop
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?

	XOR A
	;LD	A, PP_ANIM_STATE_STOPPED	 	; = 0x00
	LD	(IX+BRD_PUSH_PULL_ANIM_STATE), A
	
	; TODO: Optimize by calculating HL = IX+BC for start location, and then clear and inc ?
	; Clearing THESE Pointers can be optional, if they are NOT tested in any other ANIM_STATE except PULLING (and kept EQUAL on Exit)
	LD	(IX+BRD_PULL_ANIM_COL_BASE_L), A		; Clear COL BASE
	LD	(IX+BRD_PULL_ANIM_COL_BASE_H), A
	
	LD	(IX+BRD_PULL_ANIM_COL_ADDR_L), A		; Clear COL ADDR
	LD	(IX+BRD_PULL_ANIM_COL_ADDR_H), A
RET


;------------------------
BoardPushStart
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?

	; IF ANIM_STATE != STOPPED
	;	Exit
		LD	A, (IX+BRD_PUSH_PULL_ANIM_STATE)
		AND	A						; 0X00 = PP_ANIM_STATE_STOPPED
		RET NZ						; Not Equal

	; IF Active_COLOR == B_0
	;	Exit
		LD	A, (IX+BRD_PUSH_PULL_COLOR)
		AND	A						; 0 = B_0
		RET	Z						; Equal

	;	EX	AF, AF'					; Save Active Color

	; IF PULL count == 0
	;	Exit
		LD	A, (IX+BRD_PUSH_PULL_CNT)
		AND	A
		RET	Z

	; Reset INSERT CNT (Just to be sure)
		XOR	A
		LD	(IX+BRD_PUSH_PULL_INSERT_CNT), A

	; Get Cursor/Clown Position
		LD	B, (IX+BRD_CUR_X)	; Relative value
		INC	B					; We Need to start from the end of the Column

	; Get Column Address (using Clown position)
		LD	L, (IX+BRD_BUF_L)	; TODO: We can not Optimize to "LD L, 0" since 256 bytes aligned, due two Board 2, not starting at LOW(0)
		LD	H, (IX+BRD_BUF_H)

		; Multiply				; TODO Optimize using Shift Carry method, only 4 bits needed for Width
		LD	C, (IX+BRD_HEIGHT)
	;	XOR	A					; Init to Zero (NOTE: Code be removed, if XOR A above is present)

	BoardPushStarting_MULT_1
		; NOTE: B is always > 0, due to the INC B above.
		ADD	A, C
		DJNZ	BoardPushStarting_MULT_1	; TODO: One loop could be saved, by LD A, C, and remove INC B

		;--------------------
		DEC	A	; WARNING: We use the LAST ROW as FENCE, so DO NOT TOUCH.
		;--------------------

		LD	E, A
		LD	D, 0				; TODO: Optimize this ADD, since 256 byte aligned
		ADD	HL, DE				; Get Address of intended Column last element +1 

	; Set ADDR & BASE			; We keep element +1 So we can call BoardPushAnim to set bottom item
		LD	(IX+BRD_PUSH_ANIM_COL_ADDR_L), L
		LD	(IX+BRD_PUSH_ANIM_COL_ADDR_H), H

		;PUSH HL				; Save ADDR

		LD	E, C				; E = Height
		SBC	HL, DE				; First Column Position = Subtract Height

		LD	(IX+BRD_PUSH_ANIM_COL_BASE_L), L
		LD	(IX+BRD_PUSH_ANIM_COL_BASE_H), H

		;EX	DE, HL				; DE = BASE
		;POP HL					; Restore ADDR

	; Set Active Color
	;	EX	AF, AF'				; Restore Active Color
	;	LD	(IX+BRD_PUSH_PULL_COLOR), A

	; Set Anim state to PUSHING
		LD	A, PP_ANIM_STATE_PUSHING
		LD	(IX+BRD_PUSH_PULL_ANIM_STATE), A

	; Place First Ball and Decrement
		; NOTE: delegate this to PushAnim, since several conditions must be verified,
		; like check if there is any free space

; FALL Through
		;CALL	BoardPushAnim
;RET


;------------------------
BoardPushAnim
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?

	; Get Addr
		LD L, (IX+BRD_PUSH_ANIM_COL_ADDR_L)
		LD H, (IX+BRD_PUSH_ANIM_COL_ADDR_H)

	; IF BASE == ADDR
		LD	A, L
		CP	(IX+BRD_PUSH_ANIM_COL_BASE_L)	; Comparing for L provides for a quicker exit
		JP	NZ,	BoardPushAnim_checkSpace
		LD	A, H
		CP	(IX+BRD_PUSH_ANIM_COL_BASE_H)
		JP	NZ, BoardPushAnim_checkSpace

	;	Check CNT and Exit
		JP	BoardPushAnim_checkCountExit

BoardPushAnim_checkSpace	
	; 	Update ADDR = ADDR-1
		DEC HL

	; IF Free Space is NOT available (POSITON != EMPTY) at (ADDR-1)
		LD	A, (HL)
		AND	A							; 0 = B_0
	;	Check CNT and Exit
		JP	NZ,	BoardPushAnim_checkCountExit

	; All Required Conditions met, to Push one Ball into Column
	; Push One Ball into Column (new ADDR)
	;	Fill Active Color Ball
		LD	A, (IX+BRD_PUSH_PULL_COLOR)
		LD	(HL), A
		LD	(IX+BRD_PUSH_ANIM_COL_ADDR_L), L
		LD	(IX+BRD_PUSH_ANIM_COL_ADDR_H), H		

	; IF BALL CNT == 0
		LD	A, (IX+BRD_PUSH_PULL_CNT)
		AND	A
		JP	NZ,	BoardPushAnim_countDown

	; 	Iterate/Find Last (Could be bottom of Column)
		LD	C, (IX+BRD_PUSH_PULL_INSERT_CNT)
		LD	B, 0
		ADD	HL, BC

	;	Insert Empty Spot
		XOR	A
		LD	(HL), A

	;	EXIT
		RET

	; ELSE
BoardPushAnim_countDown
	;	DEC BALL CNT
		DEC	A							; a = (IX+BRD_PUSH_PULL_CNT)
		LD	(IX+BRD_PUSH_PULL_CNT), A	; Would there be any advantage in using "DEC (IX+n)" ?
		INC	(IX+BRD_PUSH_PULL_INSERT_CNT)
	RET
	; ;	Check End condition
	; ;	IF BALL CNT != 0
	; ;		EXIT
		; RET	NZ
	; ;	ELSE
	; ;		JP Stop Push
		; JP	BoardPushStop

BoardPushAnim_checkCountExit
	; Check and Exit
	; Assumed no spaceleft to insert Balls
	; IF BALL CNT != 0 (> 0)
		LD	A, (IX+BRD_PUSH_PULL_CNT)
		AND	A
		JR	Z, BoardPushStop	

	;	Signal Player LOST and Exit
	;	Signal Player LOST
		LD	A, GAME_STATE_LOST;
		CALL	BoardGameSetState

	;	Stop Push
; FALL Through
;		CALL BoardPushStop
;RET

;------------------------
BoardPushStop
;------------------------
; Inputs:
;	IX = Board Structure
; Trashes: ?

	; IF CNT reached ZERO, We injected Everything
	; (TODO REVIEW THIS), since we can pop remaining CNT if >= 3
	LD	A, (IX+BRD_PUSH_PULL_CNT)
	AND	A
	JP	NZ, BoardPushStop_continue

	; If It's Ice/Stone (B_W), it DOES NOT POP, so can never MATCH3
	LD	A, B_W
	CP	(IX+BRD_PUSH_PULL_COLOR)
	CALL NZ,	BoardMatch3

BoardPushStop_continue
	XOR A
	LD	(IX+BRD_PUSH_PULL_CNT), A				; Required, when loose condition !?
;	LD	(IX+BRD_PUSH_PULL_INSERT_CNT), A		; Reset

	;LD	A, B_0;
	LD	(IX+BRD_PUSH_PULL_COLOR), A
	
	;LD	A, PP_ANIM_STATE_STOPPED	 			; = 0x00
	LD	(IX+BRD_PUSH_PULL_ANIM_STATE), A

	; TODO: Optimize by calculating HL = IX+BC for start location, and then clear and inc ?
	; Clearing THESE Pointers can be optional, if they are NOT tested in any other ANIM_STATE except PUSHING (and kept EQUAL on Exit)
;	LD	(IX+BRD_PUSH_ANIM_COL_BASE_L), A		; Clear COL BASE
;	LD	(IX+BRD_PUSH_ANIM_COL_BASE_H), A

;	LD	(IX+BRD_PUSH_ANIM_COL_ADDR_L), A		; Clear COL ADDR
;	LD	(IX+BRD_PUSH_ANIM_COL_ADDR_H), A

	; DEBUG
	LD DE, DEBUG_ATTR_LOCATION1
	CALL BoardDebugActiveColor

RET


;------------------------
BoardPushPullAnim
;------------------------
; Inputs:
;	IX = Board Structure
;	DE = Attr Address

	LD	A, (IX+BRD_PUSH_PULL_ANIM_STATE)

	CP	PP_ANIM_STATE_PUSHING
	JP	Z,	BoardPushAnim

	CP	PP_ANIM_STATE_PULLING
	JP	Z,	BoardPullAnim

RET


;------------------------
BoardAutoColUpStart
;------------------------
; Inputs:
;	IX = Board Structure

RET

;------------------------
BoardAutoColUpAnim
;------------------------
; Inputs:
;	IX = Board Structure
; 	HK = Column BASE Addr
; Trashes: ?

	; Get Addr
		LD L, (IX+BRD_PUSH_ANIM_COL_ADDR_L)
		LD H, (IX+BRD_PUSH_ANIM_COL_ADDR_H)

	; IF BASE == ADDR
		LD	A, L
		CP	(IX+BRD_PUSH_ANIM_COL_BASE_L)	; Comparing for L provides for a quicker exit
		JP	NZ,	BoardAutoColUpAnim_checkSpace
		LD	A, H
		CP	(IX+BRD_PUSH_ANIM_COL_BASE_H)
		JP	NZ, BoardAutoColUpAnim_checkSpace

	;	Check CNT and Exit
		JP	BoardAutoColUpAnim_checkCountExit

BoardAutoColUpAnim_checkSpace	
	; 	Update ADDR = ADDR-1
		DEC HL

	; IF Free Space is NOT available (POSITON != EMPTY) at (ADDR-1)
		LD	A, (HL)
		AND	A							; 0 = B_0
	;	Check CNT and Exit
		JP	NZ,	BoardAutoColUpAnim_checkCountExit

	; All Required Conditions met, to Push one Ball into Column
	; Push One Ball into Column (new ADDR)
	;	Fill Active Color Ball
		LD	A, (IX+BRD_PUSH_PULL_COLOR)
		LD	(HL), A
		LD	(IX+BRD_PUSH_ANIM_COL_ADDR_L), L
		LD	(IX+BRD_PUSH_ANIM_COL_ADDR_H), H		

	; IF BALL CNT == 0
		LD	A, (IX+BRD_PUSH_PULL_CNT)
		AND	A
		JP	NZ,	BoardAutoColUpAnim_countDown

	; 	Iterate/Find Last (Could be bottom of Column)
		LD	C, (IX+BRD_PUSH_PULL_INSERT_CNT)
		LD	B, 0
		ADD	HL, BC

	;	Insert Empty Spot
		XOR	A
		LD	(HL), A

	;	EXIT
		RET

	; ELSE
BoardAutoColUpAnim_countDown
	;	DEC BALL CNT
		DEC	A							; a = (IX+BRD_PUSH_PULL_CNT)
		LD	(IX+BRD_PUSH_PULL_CNT), A	; Would there be any advantage in using "DEC (IX+n)" ?
		INC	(IX+BRD_PUSH_PULL_INSERT_CNT)
	RET
	; ;	Check End condition
	; ;	IF BALL CNT != 0
	; ;		EXIT
		; RET	NZ
	; ;	ELSE
	; ;		JP Stop Push
		; JP	BoardPushStop

BoardAutoColUpAnim_checkCountExit
	; Check and Exit
	; Assumed no spaceleft to insert Balls
	; IF BALL CNT != 0 (> 0)
		LD	A, (IX+BRD_PUSH_PULL_CNT)
		AND	A
		JR	Z, BoardAutoColUpStop	

	;	Signal Player LOST and Exit
	;	Signal Player LOST
		LD	A, GAME_STATE_LOST;
		CALL	BoardGameSetState

	;	Stop Push
; FALL Through
;		CALL BoardPushStop
;RET


;------------------------
BoardAutoColUpStop
;------------------------
; Inputs:
;	IX = Board Structure

RET


;------------------------
BoardMatch3
;------------------------
; Inputs:
;	IX = Board Structure
;	DE = Attr Address

	; We depend on last Push Stop location
		LD	L, (IX+BRD_PUSH_ANIM_COL_ADDR_L)
		LD	H, (IX+BRD_PUSH_ANIM_COL_ADDR_H)

	; And Actual Insert Count
		LD	A, (IX+BRD_PUSH_PULL_INSERT_CNT)
		LD	C, A					; Save INSERT_CNT
		CP	3;						; 3 Balls vertically is the minimum requirement


	; Check Early exit
		JP	P, BoardMatch3_startSweepMark		; If 3 or more, start Mark & Sweep

	; IF BASE == ADDR
		LD	A, L
		CP	(IX+BRD_PUSH_ANIM_COL_BASE_L)	; Comparing for L provides for a quicker exit
		JP	NZ,	BoardMatch3_extendUp
		LD	A, H
		CP	(IX+BRD_PUSH_ANIM_COL_BASE_H)
		JP	NZ, BoardMatch3_extendUp

	;	Impossible to POP, Exit
		RET

BoardMatch3_extendUp
	; Check if Insert + Some balls in the board, reaches 3
;;	PUSH HL								; Keep original Position

	LD	A, L
	SUB (IX+BRD_PUSH_ANIM_COL_BASE_L)	; BASE must be =< ADDR, to give a positive result
	LD	B, A							; B = Difference to BASE

	LD	A, (IX+BRD_PUSH_PULL_COLOR)
BoardMatch3_checkUp

	DEC	HL
	CP	(HL)							; TODO: Account for same Color PowerUp Ball
	JP	NZ,	BoardMatch3_checkPreMatch
	INC C
	DJNZ	BoardMatch3_checkUp			; TODO, Optimize, not Efficient if many balls match, we only need 3

	;DEC	HL								; Compensate for next INC HL
	JP	BoardMatch3_checkMatch

BoardMatch3_checkPreMatch
	INC HL								; Adjust to last Valid Position

BoardMatch3_checkMatch
;;	POP HL								; Restore ADDR
;	EX	AF, AF'							; Cache Color

	LD	A, C							; C = COLOR CNT
	CP	3;								; 3 Balls vertically is the minimum requirement
	JP	P, BoardMatch3_startSweepMark		; If 3 or more, start Mark & Sweep

	RET

BoardMatch3_startSweepMark
	; (HL + C -1) points to first Match Ball

	; WARNING: This data is not always true
	; A' = Active Color

	LD	A, L
	ADD A, C
	DEC	A

	LD	L, A							; HL = First Ball of Match

	CALL BoardMatch3_sweepMark

	LD	(IX+BRD_POP_ANIM), BUBBLE_POP
RET

;------------------------
BoardMatch3_sweepMark
;------------------------
; NOTE: When this function is called, we already now, there are at least 3 items matching vertically
	; TODO: MUST Check Boundaries

	LD	(IX+BRD_POP_CNT), 0		; Reset Pop Count

	LD	B, (IX+BRD_HEIGHT)
	LD	C, (IX+BRD_PUSH_PULL_COLOR)		; Get Active/Match Color

BoardMatch3_sweepMarkCenter
	LD	A, (HL)							; Current Ball
	AND	BUBBLE_POP_MASK
	CP	B_W								; Trigger Ice/Stone
	JP NZ,	BoardMatch3_sweepMarkActive

	PUSH HL
		PUSH BC
			LD	A, C					; A = C = Active Color
			CALL BoardTransformStone
		POP BC
	POP HL
	LD	A, (HL)							; Restore Current Ball

	; TODO, Make this re-launch in the next frame, (same HL, C=Active Color)
	; So that user can see the Ice/Stone Transform.

BoardMatch3_sweepMarkActive
	CP	C
	RET NZ

	; MATCH, SO MARK
	LD	(HL), BUBBLE_POP					; Mark Ball
	INC	(IX+BRD_POP_CNT)					; Must INC POP Count

	; Search DOWN direction
	PUSH HL
		INC L								; 256 aligned and limited, no need INC HL
		CALL BoardMatch3_sweepMarkCenter	; Search Depth First
	POP HL

	; Search UP direction
	PUSH HL
		DEC L								; 256 aligned and limited, no need DEC HL
		CALL BoardMatch3_sweepMarkCenter	; Search Depth First
	POP HL

	; Search LEFT direction
	PUSH HL
		LD	A, L
		SUB	B								; = (IX+BRD_HEIGHT)
		LD	L, A
		; TODO: Check Bounds before call
		CALL BoardMatch3_sweepMarkCenter	; Search Depth First
	POP HL

	; Search RIGHT direction
	PUSH HL
		LD	A, B							; = (IX+BRD_HEIGHT)
		ADD	A, L
		LD	L, A
		; TODO: Check Bounds before call
		CALL BoardMatch3_sweepMarkCenter	; Search Depth First
	POP HL

RET


;------------------------
BoardGameSetState
;------------------------
; Inputs:
;	IX = Board Structure
;	 A = New Game State 
; Trashes: A

	; Keep new State
	LD	(IX+BRD_GAME_STATE), A

	; DEBUG
	LD DE, DEBUG_ATTR_LOCATION2
	CALL BoardDebugBubbleColor

; BoardProcessGameState
	; CP	GAME_STATE_ROLL_IN
	; JP	Z, BoardRollingStart

	; CP	GAME_STATE_RUNNING
	; JP	Z, BoardRunningStart

	; CP	GAME_STATE_LOST
	; JP	Z, BoardRollingStart

	; CP	GAME_STATE_DRAW
	; JP	Z, BoardDrawStart

	; CP	GAME_STATE_WON
	; JP	Z, BoardWonStart

RET

;------------------------
BoardDebugActiveColor
;------------------------
; Inputs:
;	IX = Board Structure
;	DE = Attr Address
;	 A = Color
; Trashes: A

	LD	A, (IX+BRD_PUSH_PULL_COLOR)	; Active Color	
; FAll Through

;------------------------
BoardDebugBubbleColor
;------------------------
; Inputs:
;	DE = Attr Address
;	 A = Color
; Trashes: Nothing

	PUSH HL
		PUSH BC
			PUSH AF
				LD	HL, BUBBLE_PAPER_COLOR_TAB
				LD	C, A				; Color	
				LD	B, 0
				ADD	HL, BC
				LD	A, (HL)
				LD	(DE), A
			POP	AF
		POP	BC
	POP	HL
RET