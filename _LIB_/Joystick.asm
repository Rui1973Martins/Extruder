; User Control Data Structure
UserCtrl	DEFB #00

; Same definition as KEMPSTON
;CTRL_FIRE2	EQU #20	;	Bit5 = FIRE2
CTRL_FIRE	EQU #10	;	Bit4 = FIRE1		returns 1 when ACTIVE, 0 otherwise
CTRL_UP		EQU #08	;	Bit3 = UP			returns 1 when ACTIVE, 0 otherwise
CTRL_DOWN	EQU #04	;	Bit2 = DOWN			returns 1 when ACTIVE, 0 otherwise
CTRL_LEFT	EQU #02	;	Bit1 = LEFT			returns 1 when ACTIVE, 0 otherwise
CTRL_RIGHT	EQU #01	;	Bit0 = RIGHT		returns 1 when ACTIVE, 0 otherwise
; --- Significance ---
; bit = 0 => OFF / NOT PRESSED / NOT ACTIVE
; bit = 1 =>  ON /     PRESSED /     ACTIVE
CTRL_MASK	EQU CTRL_FIRE + CTRL_UP + CTRL_DOWN + CTRL_LEFT + CTRL_RIGHT

;-----------------------------------------
KEMPSTON_PORT	EQU	#001F	; 31 Decimal
;-----------------------------------------
;CTRL_FIRE2	EQU #20	;	Bit5 = FIRE2
KEMPSTON_FIRE	EQU #10	;	Bit4 = FIRE1	returns 1 when ACTIVE, 0 otherwise
KEMPSTON_UP		EQU #08	;	Bit3 = UP		returns 1 when ACTIVE, 0 otherwise
KEMPSTON_DOWN	EQU #04	;	Bit2 = DOWN		returns 1 when ACTIVE, 0 otherwise
KEMPSTON_LEFT	EQU #02	;	Bit1 = LEFT		returns 1 when ACTIVE, 0 otherwise
KEMPSTON_RIGHT	EQU #01	;	Bit0 = RIGHT	returns 1 when ACTIVE, 0 otherwise
; --- Significance ---
; bit = 0 => OFF / NOT PRESSED / NOT ACTIVE
; bit = 1 =>  ON /     PRESSED /     ACTIVE
KEMPSTON_MASK	EQU KEMPSTON_FIRE + KEMPSTON_UP + KEMPSTON_DOWN + KEMPSTON_LEFT + KEMPSTON_RIGHT


;-----------------------------------------
FULLER_PORT	EQU	#007F	; 127 Decimal
;-----------------------------------------
FULLER_FIRE		EQU #80	;	Bit7 = FIRE1	returns 0 when ACTIVE, 1 otherwise
FULLER_DUMMY6	EQU #40	;	Bit6 = DUMMY	Interface should ALWAYS return 1 = OFF
FULLER_DUMMY5	EQU #20	;	Bit5 = DUMMY	Interface should ALWAYS return 1 = OFF
FULLER_DUMMY4	EQU #10	;	Bit4 = DUMMY	Interface should ALWAYS return 1 = OFF
FULLER_RIGHT	EQU #08	;	Bit0 = RIGHT	returns 0 when ACTIVE, 1 otherwise
FULLER_LEFT		EQU #04	;	Bit1 = LEFT		returns 0 when ACTIVE, 1 otherwise
FULLER_DOWN		EQU #02	;	Bit1 = DOWN		returns 0 when ACTIVE, 1 otherwise
FULLER_UP		EQU #01	;	Bit0 = UP		returns 0 when ACTIVE, 1 otherwise
; --- Significance ---
; bit = 1 => OFF / NOT PRESSED / NOT ACTIVE
; bit = 0 =>  ON /     PRESSED /     ACTIVE
FULLER_MASK     EQU FULLER_FIRE + FULLER_RIGHT + FULLER_LEFT + FULLER_DOWN + FULLER_UP

;-----------------------------------------
; CURSOR Keys / PROTEK
;-----------------------------------------
CURSOR_PORT1	EQU #F7FE; bits correspond to keys 5,4,3,2,1 (only "5" is needed)
CURSOR_PORT2	EQU #EFFE; bit corresponde to Keys 6,7,8,9,0 (key "9" is not needed)
;-----------------------------------------
CURSOR_P1_LEFT	EQU #10;	Bit4 = LEFT

CURSOR_P2_DOWN	EQU	#10;	Bit4 = DOWN
CURSOR_P2_UP	EQU	#08;	Bit3 = UP
CURSOR_P2_RIGHT	EQU #04;	Bit2 = RIGHT
CURSOR_P2_DUMMY	EQU #02;	Bit1 = _DUMMY_
CURSOR_P2_FIRE	EQU #01;	Bit0 = FIRE
; --- Significance ---
; bit = 1 => OFF / NOT PRESSED / NOT ACTIVE
; bit = 0 =>  ON /     PRESSED /     ACTIVE
CURSOR_P2_MASK	EQU CURSOR_P2_DOWN + CURSOR_P2_UP + CURSOR_P2_RIGHT + CURSOR_P2_FIRE


;-----------------------------------------
SINCLAIR1_PORT	EQU #EFFE; 61438	SINCLAIR2 (Port 2/Interface 1)
;KBRD60 			EQU #EFFE; dec 6,7,8,9,0
;-----------------------------------------

SINCLAIR1_DUMMY7	EQU #80	;	Bit7 can be anything due to floating bus
SINCLAIR1_DUMMY6	EQU #40	;	Bit6 can be anything due to floating bus
SINCLAIR1_DUMMY5	EQU #20	;	Bit5 can be anything due to floating bus
SINCLAIR1_LEFT		EQU #10	;	Bit4 = LEFT
SINCLAIR1_RIGHT		EQU #08	;	Bit3 = RIGHT
SINCLAIR1_DOWN		EQU #04	;	Bit2 = DOWN
SINCLAIR1_UP		EQU #02	;	Bit1 = UP
SINCLAIR1_FIRE 		EQU #01	;	Bit0 = FIRE
; --- Significance ---
; bit = 1 => OFF / NOT PRESSED / NOT ACTIVE
; bit = 0 =>  ON /     PRESSED /     ACTIVE
SINCLAIR1_MASK		EQU SINCLAIR1_LEFT + SINCLAIR1_RIGHT + SINCLAIR1_DOWN + SINCLAIR1_UP + SINCLAIR1_FIRE

;-----------------------------------------
SINCLAIR2_PORT	EQU	#F7FE; 63486 dec	SINCLAIR1 (Port 1/Interface 2)
;KBRD15 			EQU #F7FE;5,4,3,2,1
;-----------------------------------------

SINCLAIR2_DUMMY7	EQU #80	;	Bit7 can be anything due to floating bus
SINCLAIR2_DUMMY6	EQU #40	;	Bit6 can be anything due to floating bus
SINCLAIR2_DUMMY5	EQU #20	;	Bit5 can be anything due to floating bus
SINCLAIR2_FIRE 		EQU #10	;	Bit4 = FIRE
SINCLAIR2_UP		EQU #08	;	Bit3 = UP
SINCLAIR2_DOWN		EQU #04	;	Bit2 = DOWN
SINCLAIR2_RIGHT		EQU #02	;	Bit1 = RIGHT
SINCLAIR2_LEFT		EQU #01	;	Bit0 = LEFT
; --- Significance ---
; bit = 1 => OFF / NOT PRESSED / NOT ACTIVE
; bit = 0 =>  ON /     PRESSED /     ACTIVE
SINCLAIR2_MASK		EQU SINCLAIR2_FIRE + SINCLAIR2_UP + SINCLAIR2_DOWN + SINCLAIR2_RIGHT + SINCLAIR2_LEFT


KEMPSTON_DRIVER
	LD BC,KEMPSTON_PORT 
	IN A,(C)

	AND KEMPSTON_MASK		; Nothing else needs to be done.
;	LD (UserCtrl),A
RET

; CURSOR_P1_LEFT	EQU #10;	Bit4 = LEFT

; CURSOR_P2_DOWN	EQU	#10;	Bit4 = DOWN
; CURSOR_P2_UP	EQU	#08;	Bit3 = UP
; CURSOR_P2_RIGHT	EQU #04;	Bit2 = RIGHT
; CURSOR_P2_DUMMY	EQU #02;	Bit1 = _DUMMY_
; CURSOR_P2_FIRE	EQU #01;	Bit0 = FIRE

; CTRL_FIRE	EQU #10	;	Bit4 = FIRE1		returns 1 when ACTIVE, 0 otherwise
; CTRL_UP		EQU #08	;	Bit3 = UP			returns 1 when ACTIVE, 0 otherwise
; CTRL_DOWN	EQU #04	;	Bit2 = DOWN			returns 1 when ACTIVE, 0 otherwise
; CTRL_LEFT	EQU #02	;	Bit1 = LEFT			returns 1 when ACTIVE, 0 otherwise
; CTRL_RIGHT	EQU #01	;	Bit0 = RIGHT		returns 1 when ACTIVE, 0 otherwise

CURSOR_DRIVER	; Same as PROTEK and AGF
	LD BC,CURSOR_PORT1
	IN A,(C)
	CPL		; Invert logic, to match UserCtrl/Kempston
	
	AND CURSOR_P1_LEFT	; Get single bit from this port
	RRCA
	LD E,A
	
	LD BC,CURSOR_PORT2
	IN A,(C)
	CPL		; Invert logic, to match UserCtrl/Kempston
	
	LD B,A
	AND CTRL_UP
	LD C,A
	
	LD A,B
	AND CURSOR_P2_MASK - CURSOR_P2_UP ; Clear UP Bit, to replace with LEFT bit
	OR E						; Include CURSOR_P1_LEFT
	RRCA
	RRCA
	LD B,A
	AND CTRL_DOWN + CTRL_LEFT + CTRL_RIGHT
	OR C
	LD C,A
	
	LD A,B
	RRCA
	RRCA
	AND CTRL_FIRE
	OR C	
	
;	LD (UserCtrl),A 
RET


SINCLAIR2_DRIVER
	LD BC,SINCLAIR2_PORT
	IN A,(C)
	CPL		; Invert logic, to match UserCtrl/Kempston
	AND SINCLAIR2_MASK

	LD B,A
	AND SINCLAIR2_FIRE + SINCLAIR2_UP + SINCLAIR2_DOWN
	LD C,A
	
	LD A,B
	RRCA
	AND CTRL_RIGHT
	OR C
	LD C,A
	
	LD A,B
	RLCA
	AND CTRL_LEFT
	OR C

;	LD (UserCtrl),A
RET


SINCLAIR1_DRIVER
	LD BC,SINCLAIR1_PORT
	IN A,(C)
	CPL		; Invert logic, to match UserCtrl/Kempston
	AND SINCLAIR1_MASK

	LD B,A

	AND SINCLAIR1_DOWN
	LD C,A

	LD A,B
	AND SINCLAIR1_LEFT + SINCLAIR1_RIGHT + SINCLAIR1_UP + SINCLAIR1_FIRE
	RRCA
	RRCA
	RRCA
	LD B,A
	AND CTRL_LEFT + CTRL_RIGHT
	OR C
	LD C,A	; C contains ?, ?, DOWN, LEFT, RIGHT

	LD A,B
	RRCA
	LD B,A
	AND CTRL_FIRE
	OR C
	LD C,A
	
	LD A,B
	RRCA
	RRCA
	AND CTRL_UP
	OR C

;	LD (UserCtrl),A
RET


FULLER_DRIVER
	LD BC,FULLER_PORT
	IN A,(C)
	CPL		; Invert logic, to match UserCtrl/Kempston

	RRCA
	LD B,A
	AND CTRL_LEFT
	LD C,A
	
	LD A,B
	RRCA
	RRCA
	LD B,A
	AND CTRL_FIRE + CTRL_RIGHT
	OR C
	LD C,A
	
	LD A,B
	RRCA
	LD B,A
	AND CTRL_UP
	OR C
	LD C,A
	
	LD A,B
	RRCA
	AND CTRL_DOWN
	OR C
	
;	LD (UserCtrl),A	
RET


KEYBOARD_DRIVER
		XOR A			; RESET Temporary Register
		EX AF,AF'

KB_RIGHT
	KB_RIGHT_ROW EQU $+1
		LD A,(KEYBUF+5)
	KB_RIGHT_KEY EQU $+1
		CP KEYP
		JR NZ,KB_LEFT
			EX AF,AF'
				OR CTRL_RIGHT
			EX AF,AF'

KB_LEFT
	KB_LEFT_ROW EQU $+1
		LD A,(KEYBUF+5)
	KB_LEFT_KEY EQU $+1
		CP KEYO
		JR NZ,KB_UP
			EX AF,AF'
				OR CTRL_LEFT
			EX AF,AF'

KB_UP
	KB_UP_ROW EQU $+1
		LD A,(KEYBUF+2)
	KB_UP_KEY EQU $+1
		CP KEYQ
		JR NZ,KB_DOWN
			EX AF,AF'
				OR CTRL_UP
			EX AF,AF'

KB_DOWN
	KB_DOWN_ROW EQU $+1
		LD A,(KEYBUF+1)
	KB_DOWN_KEY EQU $+1
		CP KEYA
		JR NZ,KB_FIRE
			EX AF,AF'
				OR CTRL_DOWN
			EX AF,AF'

KB_FIRE
	KB_FIRE_ROW EQU $+1
		LD A,(KEYBUF+7)
	KB_FIRE_KEY EQU $+1
		CP KEYSP
		JR NZ,KDONE
			EX AF,AF'
				OR CTRL_FIRE
			EX AF,AF'

KDONE
		EX AF,AF'
;		LD (UserCtrl),A
RET
