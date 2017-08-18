BUBBLE_TAB_C_REG_SIZE EQU 2

; WARNING: This File MUST be 256 boundary aligned, for BUBBLE_TAB_C_COMPACT to be used as expected
BUBBLE_TAB_C_COMPACT
; Color definitions for bubbles
BUBBLE_EMPTY	DEFB	0x49,0x09,0x09,0x49
BUBBLE_RED		DEFB	0x4A,0x0A,0x0A,0x4A
BUBBLE_GREEN	DEFB	0x4C,0x0C,0x0C,0x4C
BUBBLE_CYAN		DEFB	0x4D,0x0D,0x0D,0x4D
BUBBLE_YELLOW	DEFB	0x4E,0x0F,0x0E,0x4E
BUBBLE_WHITE	DEFB	0x4F,0x0F,0x0F,0x4F
; EXTRA COLORS
BUBBLE_BLACK	DEFB	0x48,0x08,0x08,0x48
BUBBLE_MAGENTA	DEFB	0x4B,0x0B,0x0B,0x4B

BUBBLE_TAB_C
BubbleEmptyC	
	DEFW BUBBLE_EMPTY
BubbleRedC
	DEFW BUBBLE_RED
BubbleGreenC
	DEFW BUBBLE_GREEN
BubbleCyanC
	DEFW BUBBLE_CYAN
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

BubbleCyan
	DEFB 2,16;WxH
	DEFW BUBBLE_CYAN, BUBBLE_PX
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

; ----- Pixel Data and Colors -----

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx+Attr
;Interleave:      Sprite
;Mask:            No

BUBBLE_PX
	DEFB	0x03,0xC0,0x0C,0x30,0x30,0x0C,0x20,0x04,0x4C,0x02,0x4C,0x02,0x80,0x01,0x80,0x01
	DEFB	0x80,0x01,0x80,0x01,0x40,0x02,0x40,0x12,0x20,0x24,0x31,0x8C,0x0C,0x30,0x03,0xC0
