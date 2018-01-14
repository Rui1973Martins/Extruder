Tile0_Wall1
	DEFB 1,9;WxH
	DEFW TILE0_C, TILE0_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple

Tile1_Wall2
	DEFB 1,8;WxH
	DEFW TILE1_C, TILE1_PX
	DEFW #0000 	; Dummy, to make Strut 8x multiple
	
;GRAPHIC DATA:
;Pixel Size:      (  8,  64)
;Char Size:       (  1,   8)
;Sort Priorities: Char line, Y char
;Data Outputted:  Gfx+Attr
;Interleave:      Sprite
;Mask:            No

TILES_PX:
TILE0_PX:
	DEFB	$FF,$55,$00,$00,$00,$00,$00,$00

TILE1_PX:
	DEFB	$FF,$55,$18,$10,$18,$10,$18,$10

TILE_n_PX:
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00

TILES_C:
TILE0_C:
	DEFB	$16

TILE1_C:
	DEFB	$17

TILE_n_C:	
	DEFB	$38,$38,$38,$38,$38,$38