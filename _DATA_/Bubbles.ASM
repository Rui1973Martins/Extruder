BUBBLE_TAB_C_REG_SIZE EQU 2

; WARNING: This File MUST be 256 boundary aligned, for BUBBLE_TAB_C_COMPACT to be used as expected
BUBBLE_TAB_C_COMPACT
; Color definitions for bubbles
BUBBLE_EMPTY	DEFB	0x49,0x09,0x09,0x49	; IDX = 0
BUBBLE_RED		DEFB	0x4B,0x0B,0x0B,0x4B ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
BUBBLE_GREEN	DEFB	0x4C,0x0C,0x0C,0x4C	; IDX = 2
BUBBLE_BLUE		DEFB	0x4D,0x0D,0x0D,0x4D	; IDX = 3 
BUBBLE_YELLOW	DEFB	0x4E,0x0E,0x0E,0x4E	; IDX = 4
BUBBLE_BLACK	DEFB	0x48,0x08,0x08,0x48	; IDX = 5
BUBBLE_WHITE	DEFB	0x4F,0x0F,0x0F,0x4F	; IDX = 6	; EXTRA COLORS
BUBBLE_MAGENTA	DEFB	0x4B,0x0B,0x0B,0x4B	; IDX = 7

BUBBLE_BASE_MASK	EQU 0x07

POWER_UP_BUBBLES_BIT	EQU 3		; Bit3 = 0x08, Must Match BUBBLE_POP definition
POWER_UP_BUBBLES		EQU 0x08	
POWER_UP_BUBBLES_MASK	EQU 0x0F	; NEEDED ?

	DUMMY_0				DEFB	0x4F,0x08,0x08,0x4F	; IDX = 0 (+8)
POWER_UP_BUBBLES_START
	PWUP_BUBBLE_RED		DEFB	0x4B,0x0B,0x0B,0x4B ; IDX = 1 (+8)	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	PWUP_BUBBLE_GREEN	DEFB	0x4C,0x0C,0x0C,0x4C	; IDX = 2 (+8)
	PWUP_BUBBLE_BLUE	DEFB	0x4D,0x0D,0x0D,0x4D	; IDX = 3 (+8)
	PWUP_BUBBLE_YELLOW	DEFB	0x4E,0x0E,0x0E,0x4E	; IDX = 4 (+8)

POWER_UP_BUBBLES_END	EQU POWER_UP_BUBBLES + 4
	DUMMY_1				DEFB	0x4F,0x08,0x08,0x4F	; IDX = 5 (+8)
	DUMMY_2				DEFB	0x4F,0x08,0x08,0x4F	; IDX = 6 (+8)
	DUMMY_3				DEFB	0x4F,0x08,0x08,0x4F	; IDX = 7 (+8)
;	DUMMY_4				DEFB	0x4F,0x08,0x08,0x4F	; IDX = 8

BUBBLE_POP_BIT	EQU    4			; Bit4 = 0x10, Must Match BUBBLE_POP definition
BUBBLE_POP		EQU 0x10
BUBBLE_POP_MASK	EQU 0x1F

;Generic Burst Color Codes
				DEFB	0x7E,0x7E,0x7E,0x7E	; IDX = 8+0
				DEFB	0x75,0x75,0x75,0x75	; IDX = 8+1
				DEFB	0x6C,0x2C,0x2C,0x6C	; IDX = 8+2
				DEFB	0x5A,0x1A,0x1A,0x5A	; IDX = 8+3
				DEFB	0x51,0x11,0x11,0x51	; IDX = 8+4
				DEFB	0x52,0x12,0x12,0x52	; IDX = 8+5
BUBBLE_POP_END	EQU	BUBBLE_POP + 6

				DEFB    0x48,0x08,0x08,0x48	; IDX = 8+6,	DUMMY SPACE FILLER
				DEFB    0x48,0x08,0x08,0x48	; IDX = 8+7, DUMMY SPACE FILLER

POWER_UP_XOR_TAB
; XOR to Black
	; PWUP_XOR_RED		DEFB	0x03,0x03,0x03,0x03 ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	; PWUP_XOR_GREEN	DEFB	0x04,0x04,0x04,0x04	; IDX = 2
	; PWUP_XOR_BLUE		DEFB	0x05,0x05,0x05,0x05	; IDX = 3 
	; PWUP_XOR_YELLOW	DEFB	0x06,0x06,0x06,0x06	; IDX = 4
;XOR to White
	; PWUP_XOR_RED	DEFB	0x04,0x04,0x04,0x04 ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	; PWUP_XOR_GREEN	DEFB	0x03,0x03,0x03,0x03	; IDX = 2
	; PWUP_XOR_BLUE	DEFB	0x02,0x02,0x02,0x02	; IDX = 3 
	; PWUP_XOR_YELLOW	DEFB	0x01,0x01,0x01,0x01	; IDX = 4

	
POWER_UP_ANIM_TAB
	PWUP_0_RED		DEFB	0x4B,0x0B,0x0F,0x4F ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	PWUP_0_GREEN	DEFB	0x4C,0x0C,0x0F,0x4F	; IDX = 2
	PWUP_0_BLUE		DEFB	0x4D,0x0D,0x0F,0x4F	; IDX = 3 
	PWUP_0_YELLOW	DEFB	0x4E,0x0E,0x0F,0x4F	; IDX = 4

	PWUP_1_RED		DEFB	0x4B,0x0F,0x0B,0x4F ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	PWUP_1_GREEN	DEFB	0x4C,0x0F,0x0C,0x4F	; IDX = 2
	PWUP_1_BLUE		DEFB	0x4D,0x0F,0x0D,0x4F	; IDX = 3 
	PWUP_1_YELLOW	DEFB	0x4E,0x0F,0x0E,0x4F	; IDX = 4

	PWUP_2_RED		DEFB	0x4F,0x0F,0x0B,0x4B ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	PWUP_2_GREEN	DEFB	0x4F,0x0F,0x0C,0x4C	; IDX = 2
	PWUP_2_BLUE		DEFB	0x4F,0x0F,0x0D,0x4D	; IDX = 3 
	PWUP_2_YELLOW	DEFB	0x4F,0x0F,0x0E,0x4E	; IDX = 4

	PWUP_3_RED		DEFB	0x4F,0x0B,0x0F,0x4B ; IDX = 1	;Magenta replaces RED => 0x4A,0x0A,0x0A,0x4A
	PWUP_3_GREEN	DEFB	0x4F,0x0C,0x0F,0x4C	; IDX = 2
	PWUP_3_BLUE		DEFB	0x4F,0x0D,0x0F,0x4D	; IDX = 3 
	PWUP_3_YELLOW	DEFB	0x4F,0x0E,0x0F,0x4E	; IDX = 4

ICE_STONE_ANIM_TAB
	ICE_GLOW1		DEFB	0x4F,0x08,0x08,0x48	; IDX = 1
	ICE_GLOW2		DEFB	0x48,0x0F,0x0F,0x48	; IDX = 2 
	ICE_GLOW3		DEFB	0x48,0x08,0x08,0x4F	; IDX = 3
	ICE_GLOW_NONE	DEFB	0x48,0x08,0x08,0x48 ; IDX = 4
	
BUBBLE_TAB_C	; DEPRECATED ? Using BUBBLE_TAB_C_COMPACT instead, avoids indirection of BUBBLE_color
BubbleEmptyC	
	DEFW BUBBLE_EMPTY
BubbleRedC
	DEFW BUBBLE_RED
BubbleGreenC
	DEFW BUBBLE_GREEN
BubbleBlueC
	DEFW BUBBLE_BLUE
BubbleYellowC
	DEFW BUBBLE_YELLOW
BubbleWhiteC
	DEFW BUBBLE_WHITE
BubbleBlackC
	DEFW BUBBLE_BLACK
BubbleMagentaC
	DEFW BUBBLE_MAGENTA

	
BUBBLE_TAB_REG_SIZE EQU 8


BUBBLE_TAB	
BubbleEmpty
	DEFB 2,16;WxH
	DEFW BUBBLE_EMPTY, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple
	
BubbleRed
	DEFB 2,16;WxH
	DEFW BUBBLE_RED, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleGreen
	DEFB 2,16;WxH
	DEFW BUBBLE_GREEN, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleBlue
	DEFB 2,16;WxH
	DEFW BUBBLE_BLUE, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleYellow
	DEFB 2,16;WxH
	DEFW BUBBLE_YELLOW, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleWhite
	DEFB 2,16;WxH
	DEFW BUBBLE_WHITE, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleBlack
	DEFB 2,16;WxH
	DEFW BUBBLE_BLACK, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleMagenta
	DEFB 2,16;WxH
	DEFW BUBBLE_MAGENTA, BUBBLE_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

; Used For Board Fill	
BubbleEmptyTop
	DEFB 2,8;WxH
	DEFW BUBBLE_EMPTY, BUBBLE_TOP_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

BubbleEmptyBottom
	DEFB 2,8;WxH
	DEFW BUBBLE_EMPTY+2, BUBBLE_BOTTOM_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

; ----- Pixel Data and Colors -----

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx+Attr
;Interleave:      Sprite
;Mask:            No

BUBBLE_PX
BUBBLE_TOP_PX
	DEFB	0x03,0xC0,0x0C,0x70,0x30,0x18,0x26,0x0C
	DEFB	0x4E,0x06,0x4C,0x06,0x88,0x03,0x80,0x03
BUBBLE_BOTTOM_PX
	DEFB	0x80,0x03,0xC0,0x03,0x40,0x16,0x60,0x26
	DEFB	0x31,0x8C,0x1C,0x38,0x0F,0xF0,0x03,0xC0

;alternative

; BUBBLE_PX
; BUBBLE_TOP_PX
	; DEFB	0x03,0xC0,0x0C,0x30,0x10,0x08,0x20,0x04,0x4C,0x02,0x4C,0x02,0x80,0x01,0x80,0x01
; BUBBLE_BOTTOM_PX
	; DEFB	0x80,0x01,0x80,0x01,0x40,0x02,0x40,0x12,0x20,0x24,0x11,0x88,0x0C,0x30,0x03,0xC0
