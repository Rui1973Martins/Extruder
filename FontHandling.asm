FPrtStr
; HL = String Addr (FF terminated)
; DE = YX Position
	LD	A, (HL)
	CP	STR_Z
	RET	Z		; Exit condition (FF terminated)

	;HALT

	PUSH HL
		PUSH DE
			CALL FPrtC
		POP DE
		
		LD	A, 8
		ADD	A, E
		LD	E, A	; Next Char
		
	POP HL
	
	INC	HL
JP FPrtStr

	
FDraw
	LD C,'a'
    LD B,26
NxtC
	LD A,26
	SUB B
	RLCA;*8
	RLCA
	RLCA

	LD D,#50;Y
	LD E,A;X

	LD A,C
	INC C

	;HALT

	;PUSH DE
	PUSH BC
		CALL FPrtC
	POP BC
	;POP DE
    DJNZ NxtC
RET


;	DE = Y,X	A = Char ['A' ... 'Z']
FPrtC
	CP 'Z'+1
	RET P
	SUB '0'
	RET M
	LD HL,FNData	; FData => Alphabet; FNData => Numbers and Akphabet
;		JP PrtC		;CALL PrtC
; FALL THROUGH
;RET

; HL = Font Pixel Data (FData => Alphabet; FNData => Numbers)
PrtC
	LD B,0
	SLA A;*8
	RL B
	SLA A
	RL B
	SLA A
	RL B
	LD C,A

	ADD HL,BC
	LD IX,Font	;Font = Temp M_Blit0 DataStructure
	LD (IX+4),L
	LD (IX+5),H
	LD HL,Font
		JP PxBlit0	;CALL M_Blit0
		;JP Blit0
;RET
