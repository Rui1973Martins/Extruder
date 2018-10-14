
ChangeBlitFunc	; HL points to parameters (function to set)
	LD	C, (HL)
	INC	HL
	LD	B, (HL)
	INC	HL
	LD	(RLEBlitFunc), BC
	JR	RLETabBlit		; TODO optimize this by comment if possible, to flow through

; Run Length Encoding Table Blit
RLETabBlit
	LD	B, 1
RLETabBlitLen
	LD	A, (HL)
	INC	HL
	AND	A
	JP	P, RLEBlitLoop0
	CP	-2
	JP	Z, ChangeBlitFunc
	CP	-1
   RET	Z				; Function Exit 
	NEG					; Reverse Count into a positive value
	LD	B, A	;CNT
	JR	RLETabBlitLen	;RLETabBlit+2
RLEBlitLoop0
	PUSH	HL
RLEBlitLoop
		LD	C, A
		AND	A
		JR	Z, RLEBlitNxt
		PUSH	DE
		PUSH	BC
			ADD	A, A		;SLA A	;*2 IDX
			LD	C, A
			LD	B, 0
		RLEIndexTab EQU $+1
			LD	HL, #0000;(RLEIndexTab); Pointer to Run Length Encoding Table
			ADD	HL, BC
			LD	B, (HL)
			INC	HL
			LD	H, (HL)
			LD	L, B
		RLEBlitFunc equ $+1
			CALL	Blit0
		POP	BC
		POP	DE
RLEBlitNxt
		LD	A, E
		ADD	A, 8
		LD	E, A
		JP	NC, RLEBlitContinue		; Frequent Jump, hence use JP, instead of JR, since it's faster
		LD	A, D
		ADD	A, 8
		LD	D, A
RLEBlitContinue
		LD	A, C
		DJNZ	RLEBlitLoop
	POP	HL
	JR	RLETabBlit
