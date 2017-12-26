BOARD_PATTERN_SINGLE	DEFB	16,15,5,2,1,1,0,1,1,2,5,15,16

BOARD_PATTERN_DUAL	DEFB	0,0,0,0,0,0,0

BOARD_PATTERN1		DEFB	3,2,1,0,1,2,3
BOARD_PATTERN2		DEFB	2,1,1,0,1,1,2


BOARD_PATTERN_FOOL
	DEFB	0,	0,	0,	0,	0,	0,	0	; Zero Rebased from		1,	1,	1,	1,	1,	1,	1
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O	O	O	O	O
	;2		O	O	O	O	O	O	O
	;1		O	O	O	O	O	O	O
	;0		O	O	O	O	O	O	O

BOARD_PATTERN_STAR	; NOTE SAME as CHARIOT
	DEFB	6,	4,	2,	0,	1,	3,	5	; Zero Rebased from		7,	5,	3,	1,	2,	4,	6
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5			O	O	O	O	O	O
	;4			O	O	O	O	O	
	;3				O	O	O	O	
	;2				O	O	O		
	;1					O	O		
	;0					O			

BOARD_PATTERN_CHARIOT
	DEFB	6,	4,	2,	0,	1,	3,	5	; Zero Rebased from		7,	5,	3,	1,	2,	4,	6
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5			O	O	O	O	O	O
	;4			O	O	O	O	O	
	;3				O	O	O	O	
	;2				O	O	O		
	;1					O	O		
	;0					O			

BOARD_PATTERN_PRIESTESS
	DEFB	3,	0,	3,	4,	3,	0,	3 	; Zero Rebased from		4,	1,	4,	5,	4,	1,	4
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O		O	O	O
	;2			O				O	
	;1			O				O	
	;0			O				O	

BOARD_PATTERN_JUSTICE
	DEFB	3,	3,	1,	0,	1,	3,	3 	; Zero Rebased from		4,	4,	2,	1,	2,	4,	4
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O	O	O	O	O
	;2				O	O	O		
	;1				O	O	O		
	;0					O			
	
BOARD_PATTERN_MAGICIAN
	DEFB	4,	1,	0,	2,	0,	1,	4 	; Zero Rebased from		5,	2,	1,	3,	1,	2,	5
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3			O	O	O	O	O	
	;2			O	O	O	O	O	
	;1			O	O		O	O	
	;0				O		O		

BOARD_PATTERN_WORLD
	DEFB	0,	1,	2,	3,	3,	3,	3 	; Zero Rebased from		1,	2,	3,	4,	4,	4,	4
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O
	;5		O	O	O	O	O	O	O
	;4		O	O	O	O	O	O	O
	;3		O	O	O	O	O	O	O
	;2		O	O	O
	;1		O	O
	;0		O

	
;BOARD_PATTERN_MOON
;	DEFB	1,	2,	3,	4,	3,	2,	1	
;	;8		O	O	O	O	O	O	O
;	;7		O	O	O	O	O	O	O
;	;6		O	O	O	O	O	O	O
;	;5		O	O	O	O	O	O	O
;	;4		O	O	O	O	O	O	O
;	;3		O	O	O		O	O	O
;	;2		O	O				O	O
;	;1		O						O


; OVERFLOW PATTERN codes
B_0	EQU 0	; DUMMY code, to mark unknown
B_R	EQU	1	; r = red
B_G	EQU	2	; g = green
B_B	EQU	3	; b = blue
B_Y	EQU	4	; y = yellow
B_W	EQU	5	; w = white/Cristal/ROCK
B_M	EQU	6	; m = multicolor ?
B_X	EQU	7	; x = undistructable bubble (must be trasnformed/compacted by another ball being thrown)


BOARD_OVERFLOW_PATTERN_FOOL
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_R,	B_R,	B_R,	B_Y,	B_Y,	B_G,	B_G
	DEFB		B_R,	B_B,	B_Y,	B_Y,	B_G,	B_G,	B_R
	DEFB		B_B,	B_B,	B_Y,	B_G,	B_G,	B_R,	B_R
	DEFB		B_B,	B_Y,	B_Y,	B_G,	B_R,	B_R,	B_B
	DEFB		B_R,	B_R,	B_R,	B_R,	B_R,	B_R,	B_R
	DEFB		B_W,	B_W,	B_W,	B_W,	B_W,	B_W,	B_W
	DEFB		B_Y,	B_Y,	B_Y,	B_Y,	B_Y,	B_Y,	B_Y
	DEFB		B_W,	B_W,	B_W,	B_W,	B_W,	B_W,	B_W
; BOTTOM of screen	
; Visual output intended
	;7		r	b	b	y	y	g	g
	;6		r	b	y	y	g	g	r
	;5		b	b	y	g	g	r	r
	;4		b	y	y	g	r	r	b
	;3		r	r	r	r	r	r	r
	;2		w	w	w	w	w	w	w
	;1		y	y	y	y	y	y	y
	;0		w	w	w	w	w	w	w


BOARD_OVERFLOW_PATTERN_STAR;
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_R,	B_R,	B_R,	B_R,	B_B,	B_Y,	B_G
	DEFB		B_R,	B_B,	B_Y,	B_G,	B_B,	B_Y,	B_G
	DEFB		B_R,	B_B,	B_Y,	B_G,	B_B,	B_Y,	B_G
	DEFB		B_G,	B_B,	B_Y,	B_G,	B_R,	B_B,	B_Y
	DEFB		B_G,	B_W,	B_W,	B_G,	B_W,	B_W,	B_G
	DEFB		B_G,	B_W,	B_R,	B_R,	B_R,	B_W,	B_G
	DEFB		B_B,	B_B,	B_R,	B_W,	B_R,	B_B,	B_B
	DEFB		B_Y,	B_Y,	B_B,	B_R,	B_B,	B_Y,	B_Y

; BOTTOM of screen	
; Visual output intended 
	;7		r	r	r	r	b	y	g
	;6		r	b	y	g	b	y	g
	;5		r	b	y	g	b	y	g
	;4		g	b	y	g	r	b	y
	;3		g	w	w	g	w	w	g
	;2		g	w	r	r	r	w	g
	;1		b	b	r	w	r	b	b	
	;0		y	y	b	r	b	y	y


BOARD_OVERFLOW_PATTERN_CHARIOT
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_W,	B_B,	B_G,	B_B,	B_G,	B_B,	B_W
	DEFB		B_W,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_W
	DEFB		B_W,	B_G,	B_B,	B_G,	B_B,	B_G,	B_W
	DEFB		B_W,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_W
	DEFB		B_Y,	B_R,	B_G,	B_W,	B_Y,	B_R,	B_B
	DEFB		B_G,	B_W,	B_Y,	B_G,	B_B,	B_W,	B_R
	DEFB		B_G,	B_W,	B_Y,	B_G,	B_B,	B_W,	B_R	
	DEFB		B_Y,	B_R,	B_G,	B_W,	B_Y,	B_R,	B_B
; BOTTOM of screen	
; Visual output intended
	;7		w	b	g	b	g	b	w
	;6		w	y	r	y	r	y	w
	;5		w	g	b	g	b	g	w
	;4		w	y	r	y	r	y	w
	;3		y	r	g	w	y	r	b
	;2		g	w	y	g	b	w	r
	;1		g	w	y	g	b	w	r	
	;0		y	r	g	w	y	r	b


BOARD_OVERFLOW_PATTERN_PRIESTESS
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_Y,	B_Y,	B_B,	B_B,	B_B,	B_G,	B_G
	DEFB		B_R,	B_R,	B_Y,	B_G,	B_G,	B_B,	B_B
	DEFB		B_B,	B_B,	B_G,	B_Y,	B_Y,	B_R,	B_R
	DEFB		B_G,	B_G,	B_R,	B_R,	B_R,	B_Y,	B_Y
	DEFB		B_W,	B_G,	B_G,	B_W,	B_B,	B_B,	B_W
	DEFB		B_R,	B_W,	B_W,	B_Y,	B_W,	B_W,	B_R	
	DEFB		B_W,	B_G,	B_G,	B_W,	B_B,	B_B,	B_W
	DEFB		B_R,	B_B,	B_B,	B_Y,	B_G,	B_G,	B_R
; BOTTOM of screen	
; Visual output intended
	;7		y	y	b	b	b	g	g
	;6		r	r	y	g	g	b	b
	;5		b	b	g	y	y	r	r
	;4		g	g	r	r	r	y	y
	;3		w	g	g	w	b	b	w	
	;2		r	w	w	y	w	w	r
	;1		w	g	g	w	b	b	w	
	;0		r	b	b	y	g	g	r



BOARD_OVERFLOW_PATTERN_JUSTICE
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_R,	B_W,	B_B,	B_B,	B_B,	B_W,	B_R
	DEFB		B_B,	B_G,	B_R,	B_Y,	B_R,	B_G,	B_B
	DEFB		B_G,	B_R,	B_B,	B_W,	B_B,	B_R,	B_G
	DEFB		B_B,	B_G,	B_B,	B_Y,	B_B,	B_G,	B_B
	DEFB		B_Y,	B_G,	B_Y,	B_R,	B_Y,	B_G,	B_R
	DEFB		B_B,	B_W,	B_G,	B_B,	B_G,	B_W,	B_B
	DEFB		B_W,	B_B,	B_B,	B_R,	B_B,	B_B,	B_W
	DEFB		B_Y,	B_Y,	B_G,	B_G,	B_G,	B_Y,	B_Y
; BOTTOM of screen	
; Visual output intended
	;7		r	w	b	b	b	w	r
	;6		b	g	r	y	r	g	b
	;5		g	r	b	w	b	r	g
	;4		b	g	b	y	b	g	b
	;3		y	g	y	r	y	g	r	
	;2		b	w	g	b	g	w	b
	;1		w	b	b	r	b	b	w	
	;0		y	y	g	g	g	y	y


BOARD_OVERFLOW_PATTERN_MAGICIAN
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_Y,	B_G,	B_B,	B_W,	B_R,	B_G,	B_Y
	DEFB		B_B,	B_Y,	B_W,	B_R,	B_W,	B_Y,	B_B
	DEFB		B_R,	B_B,	B_G,	B_W,	B_G,	B_B,	B_Y
	DEFB		B_G,	B_Y,	B_W,	B_B,	B_W,	B_R,	B_G
	DEFB		B_R,	B_W,	B_R,	B_Y,	B_R,	B_W,	B_R
	DEFB		B_W,	B_R,	B_B,	B_G,	B_B,	B_R,	B_W
	DEFB		B_Y,	B_W,	B_G,	B_R,	B_G,	B_W,	B_Y
	DEFB		B_W,	B_B,	B_Y,	B_B,	B_Y,	B_B,	B_W
; BOTTOM of screen	
; Visual output intended
	;7		y	g	b	w	r	g	y
	;6		b	y	w	r	w	y	b
	;5		r	b	g	w	g	b	y
	;4		g	y	w	b	w	r	g
	;3		r	w	r	y	r	w	r	
	;2		w	r	b	g	b	r	w
	;1		y	w	g	r	g	w	y	
	;0		w	b	y	b	y	b	w

	
BOARD_OVERFLOW_PATTERN_WORLD;
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
	DEFB		B_B,	B_G,	B_R,	B_W,	B_R,	B_G,	B_B
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
	DEFB		B_W,	B_Y,	B_B,	B_G,	B_B,	B_Y,	B_W
	DEFB		B_W,	B_Y,	B_B,	B_G,	B_B,	B_Y,	B_W
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
	DEFB		B_B,	B_G,	B_R,	B_W,	B_R,	B_G,	B_B
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
; BOTTOM of screen	
; Visual output intended
	;7		y	b	g	r	g	b	y
	;6		b	g	r	w	r	g	b
	;5		y	b	g	r	g	b	y
	;4		w	y	b	g	b	y	w
	;3		w	y	b	g	b	y	w
	;2		y	b	g	r	g	b	y
	;1		b	g	r	w	r	g	b	
	;0		y	b	g	r	g	b	y


; EXTRA CHARACTERS	
	
BOARD_OVERFLOW_PATTERN_DEVIL;
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_0,	B_0,	B_0,	B_0,	B_0,	B_0,	B_0
	DEFB		B_0,	B_0,	B_0,	B_0,	B_0,	B_0,	B_0

	DEFB		B_B,	B_B,	B_R,	B_R,	B_Y,	B_Y,	B_G
	DEFB		B_G,	B_G,	B_B,	B_B,	B_R,	B_R,	B_Y
	DEFB		B_W,	B_W,	B_R,	B_R,	B_W,	B_W,	B_R
	DEFB		B_Y,	B_Y,	B_W,	B_W,	B_Y,	B_Y,	B_W
	DEFB		B_G,	B_G,	B_Y,	B_Y,	B_B,	B_B,	B_R
	DEFB		B_B,	B_B,	B_R,	B_R,	B_G,	B_G,	B_W
; BOTTOM of screen	
; Visual output intended 
	;7		O	O	O	O	O	O	O
	;6		O	O	O	O	O	O	O

	;5		b	b	r	r	y	y	g
	;4		g	g	b	b	r	r	y
	;3		w	w	r	r	w	w	r
	;2		y	y	w	w	y	y	w
	;1		g	g	y	y	b	b	r	
	;0		b	b	r	r	g	g	w


BOARD_OVERFLOW_PATTERN_STRENGTH
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_G,	B_B,	B_G,	B_B,	B_G,	B_B,	B_G
	DEFB		B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R
	DEFB		B_B,	B_G,	B_B,	B_G,	B_B,	B_G,	B_B
	DEFB		B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y
	DEFB		B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R
	DEFB		B_W,	B_B,	B_W,	B_G,	B_W,	B_B,	B_W
	DEFB		B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y
	DEFB		B_W,	B_G,	B_W,	B_B,	B_W,	B_G,	B_W
; BOTTOM of screen	
; Visual output intended 
	;7		g	b	g	b	g	b	G
	;6		r	y	r	y	r	y	r
	;5		b	g	b	g	b	g	b
	;4		y	r	y	r	y	r	y
	;3		r	y	r	y	r	y	r
	;2		w	b	w	g	w	b	w
	;1		y	r	y	r	y	r	y	
	;0		w	g	w	b	w	g	w


BOARD_OVERFLOW_PATTERN_EMPRESS;
; define in reverse order, to match visual output 
; TOP of screen
	DEFB		B_W,	B_Y,	B_R,	B_G,	B_G,	B_B,	B_W
	DEFB		B_G,	B_W,	B_B,	B_Y,	B_R,	B_W,	B_Y
	DEFB		B_R,	B_Y,	B_W,	B_B,	B_W,	B_G,	B_B
	DEFB		B_B,	B_W,	B_G,	B_R,	B_Y,	B_W,	B_R
	DEFB		B_Y,	B_W,	B_B,	B_Y,	B_G,	B_W,	B_R
	DEFB		B_R,	B_G,	B_W,	B_B,	B_W,	B_0,	B_B
	DEFB		B_B,	B_W,	B_Y,	B_R,	B_G,	B_W,	B_R
	DEFB		B_W,	B_B,	B_G,	B_W,	B_Y,	B_R,	B_W
; BOTTOM of screen	
; Visual output intended 
	;7		w	y	r	g	g	b	w
	;6		g	w	b	y	r	w	y
	;5		r	y	w	b	w	g	b
	;4		b	w	g	r	y	w	r
	;3		y	w	b	y	g	w	r
	;2		r	g	w	b	w	y	b
	;1		b	w	y	r	g	w	r
	;0		w	b	g	w	y	r	w
