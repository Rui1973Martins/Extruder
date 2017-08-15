CLSC0
		LD A,#07;BlackWhite
CLSC
		LD DE,ATTR
		LD BC,#0003
CLSCLoop			;Alternative Entry point: A = fill byte, DE = start addr, BC = bytes to write (B * C)
		LD (DE),A
		INC DE
		DJNZ CLSCLoop
		DEC C
		JP NZ,CLSCLoop
	RET


CLS0
		LD A,#00
CLS
		LD DE,SCRN
		LD BC,#0018
CLSLoop				;Alternative Entry point: A = fill byte, DE = start addr, BC = bytes to write (B * C)
		LD (DE),A
		INC DE
		DJNZ CLSLoop
		DEC C
		JP NZ,CLSLoop
	RET