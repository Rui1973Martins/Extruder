
; High Bright and Low Bright
HB_	EQU 0x40
LB_	EQU 0x00

ROLL_BRIGHT_MASK	EQU HB_
ROLL_LENGTH_MASK	EQU 0x1F
ROLL_COLOR_MASK		EQU 0xBF

; OFFSET, BRIGHT_LENGTH, BRIGHT_LENGTH
; BRIGHT LENGTH
; bit7	= ?
; bit6	= Bright
; bit5	= ?
; bit4.. bit0 = length

ROLL_TABLE
; Format1 in the Beginning
	DEFB	2	,     2,     1, LB_+1	; X Offset, Y Offset, Lines, BR_LENGTH
	DEFB	1	,     1,     3, LB_+3	; X Offset, Y Offset, Lines, BR_LENGTH
; Format2 in the middle
	DEFB	0	, LB_+4, LB_+0, LB_+0	; X Offset, BR_LENGTH Left, BR_LENGTH Center, BR_LENGTH Right
	DEFB	1	, LB_+0, HB_+1, LB_+3
	DEFB	2	, LB_+0, HB_+2, LB_+2
	DEFB	3	, LB_+0, HB_+3, LB_+1
	DEFB	4	, LB_+0, HB_+4, LB_+0
	DEFB	1+08, LB_+1, HB_+3, LB_+0
	DEFB	2+12, LB_+2, HB_+2, LB_+0
	DEFB	3+16, LB_+3, HB_+1, LB_+0
	DEFB	4+20, LB_+4, HB_+0, LB_+0	; X Offset, BR_LENGTH Left, BR_LENGTH Center, BR_LENGTH Right
; Format1 in the Ending
	DEFB	4+20,     1,     3, LB_+3	; X Offset, Y Offset, Lines, BR_LENGTH
	DEFB	4+21,     2,     1, LB_+1	; X Offset, Y Offset, Lines, BR_LENGTH


ROLL_MIN	EQU		2
ROLL_MAX	EQU		11
ROLL_LEN	EQU	ROLL_MIN + ROLL_MAX-ROLL_MIN + ROLL_MIN

ROLL_DELTA	EQU	5

ROLL_LENGTH EQU ROLL_LEN + (8*ROLL_DELTA) + 4


Cardinal_LETTER ; Useful for DEBUG
	DEFB	0x15;  # # #
	DEFB	0x0A;   # # 
	DEFB	0x15;  # # #
	DEFB	0x0A;   # #
	DEFB	0x15;  # # #

E_LETTER
	DEFB	0x1F;  #####
	DEFB	0x10;  #
	DEFB	0x1C;  ###
	DEFB	0x10;  #
	DEFB	0x1F;  #####

X_LETTER
	DEFB	0x11;  #   #
	DEFB	0x0A;   # #
	DEFB	0x04;    #
	DEFB	0x0A;   # #
	DEFB	0x11;  #   #

T_LETTER
	DEFB	0x1F;  #####
	DEFB	0x04;    #  
	DEFB	0x04;    #
	DEFB	0x04;    #
	DEFB	0x04;    #

R_LETTER
	DEFB	0x1E;  ####
	DEFB	0x11;  #   #
	DEFB	0x1F;  #####
	DEFB	0x12;  #  #
	DEFB	0x11;  #   #

U_LETTER
	DEFB	0x11;  #   #
	DEFB	0x11;  #   #
	DEFB	0x11;  #   #
	DEFB	0x11;  #   #
	DEFB	0x0E;   ###

D_LETTER
	DEFB	0x1E;  ####
	DEFB	0x11;  #   #
	DEFB	0x11;  #   #
	DEFB	0x11;  #   #
	DEFB	0x1E;  ####


ROLL_COUNTERS
	ROLL1_CNT
		DEFB	ROLL_LEN
		DEFB	RED<<3+BLACK
		DEFW	E_LETTER

	ROLL2_CNT
		DEFB	ROLL_LEN + (1*ROLL_DELTA)
		DEFB	YELLOW<<3+BLACK
		DEFW	X_LETTER

	ROLL3_CNT
		DEFB	ROLL_LEN + (2*ROLL_DELTA)
		DEFB	GREEN<<3+BLACK
		DEFW	T_LETTER

	ROLL4_CNT
		DEFB	ROLL_LEN + (3*ROLL_DELTA)
		DEFB	CYAN<<3+BLACK
		DEFW	R_LETTER

	ROLL5_CNT
		DEFB	ROLL_LEN + (4*ROLL_DELTA)
		DEFB	RED<<3+BLACK
		DEFW	U_LETTER

	ROLL6_CNT
		DEFB	ROLL_LEN + (5*ROLL_DELTA)
		DEFB	YELLOW<<3+BLACK
		DEFW	D_LETTER

	ROLL7_CNT
		DEFB	ROLL_LEN + (6*ROLL_DELTA)
		DEFB	GREEN<<3+BLACK
		DEFW	E_LETTER

	ROLL8_CNT
		DEFB	ROLL_LEN + (7*ROLL_DELTA)
		DEFB	CYAN<<3+BLACK
		DEFW	R_LETTER


;-----------------
RollDraw
;-----------------
	LD	DE, ATTR+2
	LD	IX, ROLL1_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar

	LD	DE, ATTR+2
	LD	IX, ROLL2_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar

	LD	DE, ATTR+2
	LD	IX, ROLL3_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar

	LD	DE, ATTR+2
	LD	IX, ROLL4_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar
	
	LD	DE, ATTR+2
	LD	IX, ROLL5_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar
	
	LD	DE, ATTR+2
	LD	IX, ROLL6_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar
	
	LD	DE, ATTR+2
	LD	IX, ROLL7_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar
	
	LD	DE, ATTR+2
	LD	IX, ROLL8_CNT
		LD	A, (IX+1)
		LD	L, (IX+2)
		LD	H, (IX+3)		
	CALL	RollDrawChar
RET

;-----------------
RollDrawChar
;-----------------
; Inputs:
;	DE = ATTR Addr Start
;	HL = Char Data
;	 A = Color

	EX	AF, AF'
		LD	A, (IX+0)					; Get count/index

		; INC	A								; Inc and Check for WRAP
		; CP	ROLL_LENGHT
		; JP	M,	RollDraw_setCnt
			; XOR A
			
		DEC	A								; Dec and Check for WRAP
		JP	P,	RollDraw_setCnt
			LD A, ROLL_LENGTH

RollDraw_setCnt
		LD	(IX+0), A					; Next count/index

		CP	ROLL_LEN
		RET P	; CALL another function

		LD	C, A						; Index

		CP	ROLL_MIN
		;RET M
		;JP M, RollDrawCharEnd	; Special End Case
		JP	P, RollDraw_continue1

			;EX AF, AF'
			LD	A,(HL)			; Set Char Data Param
			JP	RollDrawCharEnd

RollDraw_continue1

		CP	ROLL_MAX
		;RET P
		;JP P, RollDrawCharEnd	; Special End Case
		JP	M, RollDraw_continue2

			;EX AF, AF'
			LD	A,(HL)			; Set Char Data Param
			JP	RollDrawCharEnd
		
RollDraw_continue2
		LD	B, 5
	EX AF, AF'

RollDraw_charLoop
	PUSH AF
		EX	AF, AF'					; Set Color Param
		PUSH BC
			PUSH HL
				PUSH DE
					LD	A,(HL)		; Set Char Data Param
					CALL RollDrawCharLine
				POP DE

				; Calc Next Line
				LD	HL, 32
				ADD HL, DE
				EX	DE, HL			;	Next Line Addr

			POP	HL
			INC HL					; Next Char Data
		POP BC
	POP AF

	DJNZ	RollDraw_charLoop
RET


;-----------------
RollDrawCharEnd
;-----------------
; Inputs:
; DE  = ATTR Addr Start
;  C  = ROLL Index
;  A' = Color
;  A  = CHAR Data Line (do we need this ?)

; Only supports 5 Bit Fonts
; ;	AND	A		; Clear Carry
	; RLA		; Trash Bit 7
	; RLA		; Trash Bit 6
	; RLA		; Trash Bit 5

;	PUSH AF							; Save CHAR Data

		LD	A, C					; Index

		LD	HL,	ROLL_TABLE; Access Roll Table with index
		ADD	A, A	; *2
		ADD	A, A	; *4
		LD	B, 0
		LD	C, A
		ADD	HL, BC

		LD	A, (HL)					; X Offset
		INC HL

		EX	DE, HL
			; Get New ATTR Position
			;LD	B, 0
			LD	C, A
			ADD HL, BC
		EX	DE, HL					; DE = New Screen Position, After Offset

; POP AF

;--------------------------------
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data (DEPRECATED FOR NOW)

	LD	B, (HL)						; Y Offset

	INC HL	
	LD	C, (HL)						; Lines

	INC	HL
	LD	A, (HL)						; BRIGHT_LENGTH

	EX	DE, HL					; DE = Result

		LD	D, 0
		LD	E, 32					; Next Line
		
		; NOTE: Y Offset is always larger than 0, so no need to check for zero.
RollDrawCharEnd_offsetY	
		ADD HL, DE
		DJNZ	RollDrawCharEnd_offsetY
		
	EX	DE, HL					; DE = Result

	LD	L, A						; BRIGHT_LENGTH
	AND	ROLL_LENGTH_MASK
	RET Z	; Just to safe for now
	;JP	Z, RollDrawCharEnd_drawBlockLineEnd	; Should Never Happen, ALWAYS > 0
	
	LD	B, A						; Length

	LD	A, L
	AND	ROLL_BRIGHT_MASK
	LD	L, A						; Bright

	LD	A, B
	EX	AF, AF'						; Restore Color, Saving Counter

		AND	ROLL_COLOR_MASK			; Clear Color Bright
		OR	L						; Apply Bright

		EX	DE, HL					; DE into -> HL

		LD	D, 0
		LD	E, 32

RollDrawCharEnd_drawBlock
		EX	AF, AF'						; Restore Counter, Saving Color
		LD	B, A 
		EX	AF, AF'						; Restore Color, Saving Counter

		PUSH HL
RollDrawCharEnd_drawBlockLine		; Write Color Band
			LD	(HL), A
			INC	HL
			DJNZ	RollDrawCharEnd_drawBlockLine
		POP HL

		ADD	HL, DE					; Next Line
		
		DEC C
		JP	NZ,	RollDrawCharEnd_drawBlock
		
	;EX	AF, AF'						; Save Color
RET


;-----------------
RollDrawCharLine
;-----------------
; DE  = ATTR Addr Start
;  C  = ROLL Index
;  A' = Color
;  A  = CHAR Data Line

; Only supports 5 Bit Fonts
;	AND	A		; Clear Carry
	RLA		; Trash Bit 7
	RLA		; Trash Bit 6
	RLA		; Trash Bit 5

	PUSH AF							; Save CHAR Data

		LD	A, C					; Index

		LD	HL,	ROLL_TABLE; Access Roll Table with index
		ADD	A, A	; *2
		ADD	A, A	; *4
		LD	B, 0
		LD	C, A
		ADD	HL, BC

		LD	A, (HL)					; Offset
		INC HL

		EX	DE, HL
			; Get New ATTR Position
			;LD	B, 0
			LD	C, A
			ADD HL, BC
		EX	DE, HL					; DE = New Screen Position, After Offset

	POP	AF							; Restore CHAR Data

	LD	B, 5						; Total of 5 bits to process

	PUSH AF
	PUSH BC
	PUSH DE
	PUSH HL
		CALL Roll_PASS1_Data_loop
	POP HL
	POP DE
	POP BC
	POP AF

	CALL Roll_PASS2_Data_loop
RET
	
Roll_PASS1_Data_loop
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data
	
;;;	PUSH HL							; Keep Start Of Data
	PUSH BC
		RLA							; Higher CHAR Data bit -> into Carry
		PUSH AF						; Save CHAR Data
			JP	NC,	Roll_PASS1_Data_OFF

Roll_PASS1_Data_ON
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_PASS1_Band1_ON			
			LD	A, (HL)				; BRIGHT_LENGTH
			LD	C, A				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_PASS1_Band2_ON	; Nothing to do

			LD	B, A				; Length

			LD	A, C
			AND	ROLL_BRIGHT_MASK
			LD	C, A				; Bright

			EX	AF, AF'				; Restore Color

				AND	ROLL_COLOR_MASK		; Clear Color Bright
				OR	C					; Apply Bright

				PUSH DE
Roll_PASS1_Band1_ON_incLoop					; Write Color Band
					LD	(DE), A
					INC	DE
					DJNZ	Roll_PASS1_Band1_ON_incLoop
				POP DE

			EX	AF, AF'				; Save Color

Roll_PASS1_Band2_ON
			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_PASS1_Band3_ON	; Nothing to do

			LD	B, A				; Length

Roll_PASS1_Band2_ON_loop			; Step Color Band
				INC	DE
				DJNZ	Roll_PASS1_Band2_ON_loop

Roll_PASS1_Band3_ON
			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			LD	C, A				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_PASS1_Data_ON_check	; Nothing to do

			LD	B, A				; Length

			LD	A, C
			AND	ROLL_BRIGHT_MASK
			LD	C, A				; Bright

			EX	AF, AF'				; Restore Color

				AND	ROLL_COLOR_MASK		; Clear Color Bright
				OR	C					; Apply Bright

				PUSH DE
Roll_PASS1_Band3_ON_incLoop					; Write Color Band
					LD	(DE), A
					INC	DE
					DJNZ	Roll_PASS1_Band3_ON_incLoop
				POP DE

			EX	AF, AF'				; Save Color

Roll_PASS1_Data_ON_check
		POP AF
	POP BC
;;;	POP HL
	DEC HL
	DEC HL
	DJNZ	Roll_PASS1_Data_loop
RET

Roll_PASS1_Data_OFF
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_PASS1_Band1_OFF
Roll_PASS1_Band2_OFF
			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_PASS1_Band3_OFF		; Nothing to do
				LD	B, A				; Length
Roll_PASS1_Band2_OFF_loop					; Write Color Band
				INC	DE
			DJNZ	Roll_PASS1_Band2_OFF_loop

Roll_PASS1_Band3_OFF
Roll_PASS1_Data_OFF_check
		POP AF
	POP BC
;;;	POP HL
	DEC HL
	
	DJNZ	Roll_PASS1_Data_loop
RET


; ###################################################################


Roll_PASS2_Data_loop
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_PASS2_Offset
;	PUSH BC
	LD	C, B
	PUSH AF
		LD	A, (HL)				; BRIGHT_LENGTH
		INC HL
		AND	ROLL_LENGTH_MASK
		JP	Z, Roll_PASS2_Data_offset_JP1	; Nothing to do

		LD	B, A				; Length

Roll_PASS2_Offset_incLoop					; Write Color Band
		INC	DE
		DJNZ	Roll_PASS2_Offset_incLoop

Roll_PASS2_Data_offset_JP1
	POP AF
;	POP BC
	LD B, C

Roll_PASS2_Data_innerLoop
;	PUSH HL							; Keep Start Of Data
	PUSH BC
		RLA							; Higher CHAR Data bit -> into Carry
		PUSH AF						; Save CHAR Data
			JP	NC,	Roll_PASS2_Data_OFF

Roll_PASS2_Data_ON
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_PASS2_Band1_ON			
Roll_PASS2_Band2_ON
			LD	A, (HL)				; BRIGHT_LENGTH
			LD	C, A				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_PASS2_Band3_ON	; Nothing to do

			LD	B, A				; Length

			LD	A, C 
			AND	ROLL_BRIGHT_MASK
			LD	C, A				; Bright

			EX	AF, AF'				; Restore Color

				AND	ROLL_COLOR_MASK		; Clear Color Bright
				OR	C					; Apply Bright

Roll_PASS2_Band2_ON_loop					; Write Color Band
				LD	(DE), A
				INC	DE
				DJNZ	Roll_PASS2_Band2_ON_loop

			EX	AF, AF'				; Save Color

Roll_PASS2_Band3_ON
Roll_PASS2_Data_ON_check
		POP AF
	POP BC
;	POP HL

	DJNZ	Roll_PASS2_Data_innerLoop
RET

Roll_PASS2_Data_OFF
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_PASS2_Band1_OFF
Roll_PASS2_Band2_OFF
;			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_PASS2_Band3_OFF		; Nothing to do
				LD	B, A				; Length
Roll_PASS2_Band2_OFF_loop					; Write Color Band
				INC	DE
			DJNZ	Roll_PASS2_Band2_OFF_loop

Roll_PASS2_Band3_OFF
Roll_PASS2_Data_OFF_check
		POP AF
		; RRA	; Recover
	POP BC
;	POP HL

	DJNZ	Roll_PASS2_Data_innerLoop
RET
