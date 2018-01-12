
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
	DEFB	0	, LB_+4, LB_+0, LB_+0
	DEFB	1	, LB_+0, HB_+1, LB_+3
	DEFB	2	, LB_+0, HB_+2, LB_+2
	DEFB	3	, LB_+0, HB_+3, LB_+1
	DEFB	4	, LB_+0, HB_+4, LB_+0
	DEFB	1+08, LB_+1, HB_+3, LB_+0
	DEFB	2+12, LB_+2, HB_+2, LB_+0
	DEFB	3+16, LB_+3, HB_+1, LB_+0
	DEFB	4+20, LB_+4, HB_+0, LB_+0

ROLL_MIN	EQU	 0
ROLL_MAX	EQU  8
ROLL_LEN	EQU ROLL_MAX-ROLL_MIN+1

ROLL_DELTA	EQU 8

ROLL_LENGHT EQU ROLL_LEN + (3*ROLL_DELTA)

E_LETTER
	DEFB	0x1F
	DEFB	0x10
	DEFB	0x1C
	DEFB	0x10
	DEFB	0x1F

X_LETTER
	DEFB	0x11
	DEFB	0x0A
	DEFB	0x04
	DEFB	0x0A
	DEFB	0x11

T_LETTER
	DEFB	0x0E
	DEFB	0x04
	DEFB	0x04
	DEFB	0x04
	DEFB	0x04

O_LETTER
	DEFB	0x15
	DEFB	0x0A
	DEFB	0x15
	DEFB	0x0A
	DEFB	0x15


ROLL_COUNTERS
	ROLL1_CNT
		DEFB	ROLL_LEN
		DEFB	RED<<3+BLACK
		DEFW	E_LETTER
	ROLL2_CNT
		DEFB	ROLL_LEN + (1*ROLL_DELTA)
		DEFB	GREEN<<3+BLACK
		DEFW	E_LETTER

	ROLL3_CNT
		DEFB	ROLL_LEN + (2*ROLL_DELTA)
		DEFB	CYAN<<3+BLACK
		DEFW	T_LETTER

	ROLL4_CNT
		DEFB	ROLL_LEN + (3*ROLL_DELTA)
		DEFB	YELLOW<<3+BLACK
		DEFW	O_LETTER

;-----------------
RollDraw
;-----------------
	LD	DE, ATTR+2
	LD	IX, ROLL1_CNT
		LD	A, RED<<3+BLACK
		LD	HL, E_LETTER
	CALL	RollDrawChar

	LD	DE, ATTR+2
	LD	IX, ROLL2_CNT
		LD	A, GREEN<<3+BLACK
		LD	HL, X_LETTER
	CALL	RollDrawChar

	LD	DE, ATTR+2
	LD	IX, ROLL3_CNT
		LD	A, CYAN<<3+BLACK
		LD	HL, T_LETTER
	CALL	RollDrawChar

	LD	DE, ATTR+2
	LD	IX, ROLL4_CNT
		LD	A, YELLOW<<3+BLACK
		LD	HL, O_LETTER
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
		LD	C, A

		; INC	A								; Inc and Check for WRAP
		; CP	ROLL_LEN
		; JP	M,	RollDraw_setCnt
			; XOR A
			
		DEC	A								; Dec and Check for WRAP
		JP	P,	RollDraw_setCnt

;			LD A, ROLL_LEN-1
			LD A, ROLL_LENGHT

RollDraw_setCnt
		LD	(IX+0), A					; Next count/index
		CP	ROLL_MAX
		RET P

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

RollDrawCharLine
; DE  = ATTR Addr Start
;  C  = ROLL Index
;  A' = Color
;  A  = CHAR Data Line

; Only supports 5 Bit Fonts
	; SLA	A
	; SLA	A
	; SLA	A
	AND	A		; Clear Carry
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

		PUSH HL
			; Get New ATTR Position
			LD	H, 0
			LD	L, A
			ADD HL, DE

			EX	DE, HL				; DE = New Screen Position, After Offset
		POP HL

	POP	AF							; Restore CHAR Data

	LD	B, 5						; Total of 5 bits to process

Roll_Data_loop
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data
	
	PUSH HL							; Keep Start Of Data
	PUSH BC
		RLA							; Higher CHAR Data bit -> into Carry
		PUSH AF						; Save CHAR Data
			JP	NC,	Roll_bit_OFF

Roll_bit_ON
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_Band1_ON
		POP	AF
		RRA							; Look Behind
		PUSH AF
			JP	C, Roll_Band2_ON
			
			LD	A, (HL)				; BRIGHT_LENGTH
			LD	C, A				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_Band2_ON	; Nothing to do

			LD	B, A				; Length

			LD	A, ROLL_BRIGHT_MASK
			AND	C
			LD	C, A				; Bright

			EX	AF, AF'				; Restore Color

				AND	ROLL_COLOR_MASK		; Clear Color Bright
				OR	C					; Apply Bright
				; A now contains correct Color Brightness

Roll_Band1_ON_loop					; Write Color Band

				LD	(DE), A
				INC	DE
				DJNZ	Roll_Band1_ON_loop

			EX	AF, AF'				; Save Color

Roll_Band2_ON
		POP AF
		RLA	; Recover
		PUSH AF

			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			LD	C, A				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_Band3_ON		; Nothing to do

			LD	B, A				; Length

			LD	A, C 
			AND	ROLL_BRIGHT_MASK
			LD	C, A				; Bright

			EX	AF, AF'				; Restore Color

				AND	ROLL_COLOR_MASK		; Clear Color Bright
				OR	C					; Apply Bright

Roll_Band2_ON_loop					; Write Color Band
				LD	(DE), A
				INC	DE
				DJNZ	Roll_Band2_ON_loop
				; A now contains correct Color Brightness

			EX	AF, AF'				; Save Color

Roll_Band3_ON
		POP	AF
		RLA							; Look Ahead
		PUSH AF
			JP	C, Roll_Data_ON_check

			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			LD	C, A				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_Data_ON_check	; Nothing to do

			LD	B, A				; Length

			LD	A, C
			AND	ROLL_BRIGHT_MASK
			LD	C, A				; Bright

			EX	AF, AF'				; Restore Color

				AND	ROLL_COLOR_MASK		; Clear Color Bright
				OR	C					; Apply Bright

Roll_Band3_ON_loop					; Write Color Band
				LD	(DE), A
				INC	DE
				DJNZ	Roll_Band3_ON_loop

			EX	AF, AF'				; Save Color

Roll_Data_ON_check

		POP AF
		RRA	; Recover
	POP BC
	POP HL
	DJNZ	Roll_Data_loop
RET

Roll_bit_OFF
; DE = Char Start ATTR Addr
; HL = Indexed Table Data pointer
;  A' = Color
;  A  = CHAR Data

Roll_Band1_OFF
		POP	AF
		RRA							; Look Behind
		PUSH AF
			JP	C, Roll_Band2_OFF

			LD	A, (HL)				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_Band2_OFF	; Nothing to do
				LD	B, A				; Length
Roll_Band1_OFF_loop					; Write Color Band
				INC	DE
			DJNZ	Roll_Band1_OFF_loop

Roll_Band2_OFF
		POP	AF
		RLA							; Recover
		PUSH AF

			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_Band3_OFF		; Nothing to do
				LD	B, A				; Length
Roll_Band2_OFF_loop					; Write Color Band
				INC	DE
			DJNZ	Roll_Band2_OFF_loop

Roll_Band3_OFF
		POP	AF
		RLA							; Look Ahead
		PUSH AF
			JP	C, Roll_Data_OFF_check

			INC HL
			LD	A, (HL)				; BRIGHT_LENGTH
			AND	ROLL_LENGTH_MASK
			JP	Z, Roll_Data_OFF_check	; Nothing to do
				LD	B, A				; Length
Roll_Band3_OFF_loop					; Write Color Band
				DEC	DE
			DJNZ	Roll_Band3_OFF_loop

Roll_Data_OFF_check
		POP AF
		RRA	; Recover
	POP BC
	POP HL
	;DJNZ	Roll_Data_loop
	DEC B
	JP	NZ, Roll_Data_loop
RET





