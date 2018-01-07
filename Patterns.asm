; Attack PATTERN Tables

BOARD_ATTACK_PATTERN_FOOL
	DEFB		B_W,	B_W,	B_W,	B_W,	B_W,	B_W,	B_W
	DEFB		B_Y,	B_Y,	B_Y,	B_Y,	B_Y,	B_Y,	B_Y
	DEFB		B_W,	B_W,	B_W,	B_W,	B_W,	B_W,	B_W
	DEFB		B_R,	B_R,	B_R,	B_R,	B_R,	B_R,	B_R
	DEFB		B_B,	B_Y,	B_Y,	B_G,	B_R,	B_R,	B_B
	DEFB		B_B,	B_B,	B_Y,	B_G,	B_G,	B_R,	B_R
	DEFB		B_R,	B_B,	B_Y,	B_Y,	B_G,	B_G,	B_R
	DEFB		B_R,	B_B,	B_B,	B_Y,	B_Y,	B_G,	B_G
; defined in reverse order, to match visual output 
; Visual output intended
; TOP of screen
	;7		r	b	b	y	y	g	g
	;6		r	b	y	y	g	g	r
	;5		b	b	y	g	g	r	r
	;4		b	y	y	g	r	r	b
	;3		r	r	r	r	r	r	r
	;2		w	w	w	w	w	w	w
	;1		y	y	y	y	y	y	y
	;0		w	w	w	w	w	w	w
; BOTTOM of screen	

	
BOARD_ATTACK_PATTERN_STAR;
	DEFB		B_Y,	B_Y,	B_B,	B_R,	B_B,	B_Y,	B_Y
	DEFB		B_B,	B_B,	B_R,	B_W,	B_R,	B_B,	B_B
	DEFB		B_G,	B_W,	B_R,	B_R,	B_R,	B_W,	B_G
	DEFB		B_G,	B_W,	B_W,	B_G,	B_W,	B_W,	B_G
	DEFB		B_G,	B_B,	B_Y,	B_G,	B_R,	B_B,	B_Y
	DEFB		B_R,	B_B,	B_Y,	B_G,	B_B,	B_Y,	B_G
	DEFB		B_R,	B_B,	B_Y,	B_G,	B_B,	B_Y,	B_G
	DEFB		B_R,	B_R,	B_R,	B_R,	B_B,	B_Y,	B_G
; defined in reverse order, to match visual output 
; Visual output intended 
; TOP of screen
	;7		r	r	r	r	b	y	g
	;6		r	b	y	g	b	y	g
	;5		r	b	y	g	b	y	g
	;4		g	b	y	g	r	b	y
	;3		g	w	w	g	w	w	g
	;2		g	w	r	r	r	w	g
	;1		b	b	r	w	r	b	b	
	;0		y	y	b	r	b	y	y
; BOTTOM of screen	


BOARD_ATTACK_PATTERN_CHARIOT
	DEFB		B_Y,	B_R,	B_G,	B_W,	B_Y,	B_R,	B_B
	DEFB		B_G,	B_W,	B_Y,	B_G,	B_B,	B_W,	B_R	
	DEFB		B_G,	B_W,	B_Y,	B_G,	B_B,	B_W,	B_R
	DEFB		B_Y,	B_R,	B_G,	B_W,	B_Y,	B_R,	B_B
	DEFB		B_W,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_W
	DEFB		B_W,	B_G,	B_B,	B_G,	B_B,	B_G,	B_W
	DEFB		B_W,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_W
	DEFB		B_W,	B_B,	B_G,	B_B,	B_G,	B_B,	B_W
; defined in reverse order, to match visual output 
; Visual output intended
; TOP of screen
	;7		w	b	g	b	g	b	w
	;6		w	y	r	y	r	y	w
	;5		w	g	b	g	b	g	w
	;4		w	y	r	y	r	y	w
	;3		y	r	g	w	y	r	b
	;2		g	w	y	g	b	w	r
	;1		g	w	y	g	b	w	r	
	;0		y	r	g	w	y	r	b
; BOTTOM of screen	


BOARD_ATTACK_PATTERN_PRIESTESS
	DEFB		B_R,	B_B,	B_B,	B_Y,	B_G,	B_G,	B_R
	DEFB		B_W,	B_G,	B_G,	B_W,	B_B,	B_B,	B_W
	DEFB		B_R,	B_W,	B_W,	B_Y,	B_W,	B_W,	B_R	
	DEFB		B_W,	B_G,	B_G,	B_W,	B_B,	B_B,	B_W
	DEFB		B_G,	B_G,	B_R,	B_R,	B_R,	B_Y,	B_Y
	DEFB		B_B,	B_B,	B_G,	B_Y,	B_Y,	B_R,	B_R
	DEFB		B_R,	B_R,	B_Y,	B_G,	B_G,	B_B,	B_B
	DEFB		B_Y,	B_Y,	B_B,	B_B,	B_B,	B_G,	B_G
; defined in reverse order, to match visual output 
; Visual output intended
; TOP of screen
	;7		y	y	b	b	b	g	g
	;6		r	r	y	g	g	b	b
	;5		b	b	g	y	y	r	r
	;4		g	g	r	r	r	y	y
	;3		w	g	g	w	b	b	w	
	;2		r	w	w	y	w	w	r
	;1		w	g	g	w	b	b	w	
	;0		r	b	b	y	g	g	r
; BOTTOM of screen	


BOARD_ATTACK_PATTERN_JUSTICE
	DEFB		B_Y,	B_Y,	B_G,	B_G,	B_G,	B_Y,	B_Y
	DEFB		B_W,	B_B,	B_B,	B_R,	B_B,	B_B,	B_W
	DEFB		B_B,	B_W,	B_G,	B_B,	B_G,	B_W,	B_B
	DEFB		B_Y,	B_G,	B_Y,	B_R,	B_Y,	B_G,	B_R
	DEFB		B_B,	B_G,	B_B,	B_Y,	B_B,	B_G,	B_B
	DEFB		B_G,	B_R,	B_B,	B_W,	B_B,	B_R,	B_G
	DEFB		B_B,	B_G,	B_R,	B_Y,	B_R,	B_G,	B_B
	DEFB		B_R,	B_W,	B_B,	B_B,	B_B,	B_W,	B_R
; defined in reverse order, to match visual output 
; Visual output intended
; TOP of screen
	;7		r	w	b	b	b	w	r
	;6		b	g	r	y	r	g	b
	;5		g	r	b	w	b	r	g
	;4		b	g	b	y	b	g	b
	;3		y	g	y	r	y	g	r	
	;2		b	w	g	b	g	w	b
	;1		w	b	b	r	b	b	w	
	;0		y	y	g	g	g	y	y
; BOTTOM of screen	

	
BOARD_ATTACK_PATTERN_MAGICIAN
	DEFB		B_W,	B_B,	B_Y,	B_B,	B_Y,	B_B,	B_W
	DEFB		B_Y,	B_W,	B_G,	B_R,	B_G,	B_W,	B_Y
	DEFB		B_W,	B_R,	B_B,	B_G,	B_B,	B_R,	B_W
	DEFB		B_R,	B_W,	B_R,	B_Y,	B_R,	B_W,	B_R
	DEFB		B_G,	B_Y,	B_W,	B_B,	B_W,	B_R,	B_G
	DEFB		B_R,	B_B,	B_G,	B_W,	B_G,	B_B,	B_Y
	DEFB		B_B,	B_Y,	B_W,	B_R,	B_W,	B_Y,	B_B
	DEFB		B_Y,	B_G,	B_B,	B_W,	B_R,	B_G,	B_Y
; defined in reverse order, to match visual output 
; Visual output intended
; TOP of screen
	;7		y	g	b	w	r	g	y
	;6		b	y	w	r	w	y	b
	;5		r	b	g	w	g	b	y
	;4		g	y	w	b	w	r	g
	;3		r	w	r	y	r	w	r	
	;2		w	r	b	g	b	r	w
	;1		y	w	g	r	g	w	y	
	;0		w	b	y	b	y	b	w
; BOTTOM of screen	

	
BOARD_ATTACK_PATTERN_WORLD;
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
	DEFB		B_B,	B_G,	B_R,	B_W,	B_R,	B_G,	B_B
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
	DEFB		B_W,	B_Y,	B_B,	B_G,	B_B,	B_Y,	B_W
	DEFB		B_W,	B_Y,	B_B,	B_G,	B_B,	B_Y,	B_W
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
	DEFB		B_B,	B_G,	B_R,	B_W,	B_R,	B_G,	B_B
	DEFB		B_Y,	B_B,	B_G,	B_R,	B_G,	B_B,	B_Y
; defined in reverse order, to match visual output 
; Visual output intended
; TOP of screen
	;7		y	b	g	r	g	b	y
	;6		b	g	r	w	r	g	b
	;5		y	b	g	r	g	b	y
	;4		w	y	b	g	b	y	w
	;3		w	y	b	g	b	y	w
	;2		y	b	g	r	g	b	y
	;1		b	g	r	w	r	g	b	
	;0		y	b	g	r	g	b	y
; BOTTOM of screen	



; EXTRA CHARACTERS	
; ================	
BOARD_ATTACK_PATTERN_DEVIL;
	DEFB		B_B,	B_B,	B_R,	B_R,	B_G,	B_G,	B_W
	DEFB		B_G,	B_G,	B_Y,	B_Y,	B_B,	B_B,	B_R
	DEFB		B_Y,	B_Y,	B_W,	B_W,	B_Y,	B_Y,	B_W
	DEFB		B_W,	B_W,	B_R,	B_R,	B_W,	B_W,	B_R
	DEFB		B_G,	B_G,	B_B,	B_B,	B_R,	B_R,	B_Y
	DEFB		B_B,	B_B,	B_R,	B_R,	B_Y,	B_Y,	B_G

	DEFB		B_0,	B_0,	B_0,	B_0,	B_0,	B_0,	B_0
	DEFB		B_0,	B_0,	B_0,	B_0,	B_0,	B_0,	B_0
; defined in reverse order, to match visual output 
; Visual output intended 
; TOP of screen
	;7		O	O	O	O	O	O	O	; still missing
	;6		O	O	O	O	O	O	O	; still missing

	;5		b	b	r	r	y	y	g
	;4		g	g	b	b	r	r	y
	;3		w	w	r	r	w	w	r
	;2		y	y	w	w	y	y	w
	;1		g	g	y	y	b	b	r	
	;0		b	b	r	r	g	g	w
; BOTTOM of screen	


BOARD_ATTACK_PATTERN_STRENGTH
	DEFB		B_W,	B_G,	B_W,	B_B,	B_W,	B_G,	B_W
	DEFB		B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y
	DEFB		B_W,	B_B,	B_W,	B_G,	B_W,	B_B,	B_W
	DEFB		B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R
	DEFB		B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y
	DEFB		B_B,	B_G,	B_B,	B_G,	B_B,	B_G,	B_B
	DEFB		B_R,	B_Y,	B_R,	B_Y,	B_R,	B_Y,	B_R
	DEFB		B_G,	B_B,	B_G,	B_B,	B_G,	B_B,	B_G
; defined in reverse order, to match visual output 
; Visual output intended 
; TOP of screen
	;7		g	b	g	b	g	b	G
	;6		r	y	r	y	r	y	r
	;5		b	g	b	g	b	g	b
	;4		y	r	y	r	y	r	y
	;3		r	y	r	y	r	y	r
	;2		w	b	w	g	w	b	w
	;1		y	r	y	r	y	r	y	
	;0		w	g	w	b	w	g	w
; BOTTOM of screen	


BOARD_ATTACK_PATTERN_EMPRESS;
	DEFB		B_W,	B_B,	B_G,	B_W,	B_Y,	B_R,	B_W
	DEFB		B_B,	B_W,	B_Y,	B_R,	B_G,	B_W,	B_R
	DEFB		B_R,	B_G,	B_W,	B_B,	B_W,	B_Y,	B_B
	DEFB		B_Y,	B_W,	B_B,	B_Y,	B_G,	B_W,	B_R
	DEFB		B_B,	B_W,	B_G,	B_R,	B_Y,	B_W,	B_R
	DEFB		B_R,	B_Y,	B_W,	B_B,	B_W,	B_G,	B_B
	DEFB		B_G,	B_W,	B_B,	B_Y,	B_R,	B_W,	B_Y
	DEFB		B_W,	B_Y,	B_R,	B_G,	B_G,	B_B,	B_W
; defined in reverse order, to match visual output 
; Visual output intended 
; TOP of screen
	;7		w	y	r	g	g	b	w
	;6		g	w	b	y	r	w	y
	;5		r	y	w	b	w	g	b
	;4		b	w	g	r	y	w	r
	;3		y	w	b	y	g	w	r
	;2		r	g	w	b	w	y	b
	;1		b	w	y	r	g	w	r
	;0		w	b	g	w	y	r	w
; BOTTOM of screen	
	

; WARNING COPIED FROM EMPRESS, NOT REVERSE-ENGINEERED YET
BOARD_ATTACK_PATTERN_BLACK_PIERROT
	DEFB		B_W,	B_B,	B_G,	B_W,	B_Y,	B_R,	B_W
	DEFB		B_B,	B_W,	B_Y,	B_R,	B_G,	B_W,	B_R
	DEFB		B_R,	B_G,	B_W,	B_B,	B_W,	B_Y,	B_B
	DEFB		B_Y,	B_W,	B_B,	B_Y,	B_G,	B_W,	B_R
	DEFB		B_B,	B_W,	B_G,	B_R,	B_Y,	B_W,	B_R
	DEFB		B_R,	B_Y,	B_W,	B_B,	B_W,	B_G,	B_B
	DEFB		B_G,	B_W,	B_B,	B_Y,	B_R,	B_W,	B_Y
	DEFB		B_W,	B_Y,	B_R,	B_G,	B_G,	B_B,	B_W
; defined in reverse order, to match visual output 
; Visual output intended 
; TOP of screen
	;7		w	y	r	g	g	b	w
	;6		g	w	b	y	r	w	y
	;5		r	y	w	b	w	g	b
	;4		b	w	g	r	y	w	r
	;3		y	w	b	y	g	w	r
	;2		r	g	w	b	w	y	b
	;1		b	w	y	r	g	w	r
	;0		w	b	g	w	y	r	w
; BOTTOM of screen	



ATTACK_PATTERN_SIZE	EQU	7*8	; amount of entries in an ATTACK table, 7 row items times 8 lines.

BOARD_ATTACK_PATTERN_TAB_COUNT	EQU	11 ; Number of ATTACK Patterns in table, or table size

BOARD_ATTACK_PATTERN_TAB
	DEFW	BOARD_ATTACK_PATTERN_DEVIL
	DEFW	BOARD_ATTACK_PATTERN_FOOL
	DEFW	BOARD_ATTACK_PATTERN_STAR
	DEFW	BOARD_ATTACK_PATTERN_CHARIOT
	DEFW	BOARD_ATTACK_PATTERN_PRIESTESS
	DEFW	BOARD_ATTACK_PATTERN_JUSTICE
	DEFW	BOARD_ATTACK_PATTERN_MAGICIAN
	DEFW	BOARD_ATTACK_PATTERN_WORLD
	DEFW	BOARD_ATTACK_PATTERN_STRENGTH
	DEFW	BOARD_ATTACK_PATTERN_EMPRESS
	DEFW	BOARD_ATTACK_PATTERN_BLACK_PIERROT

