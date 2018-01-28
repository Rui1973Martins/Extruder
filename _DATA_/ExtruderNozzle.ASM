ExtruderNozzle:
	DEFB 2,8;WxH
	DEFW EXTRUDER_NOZZLE_C, EXTRUDER_NOZZLE_PX
;	DEFW #0000 	; Dummy, to make Strut 8x multiple
	
;GRAPHIC DATA:
;Pixel Size:      ( 16,   8)
;Char Size:       (  2,   1)
;Sort Priorities: X char, Char line
;Data Outputted:  Gfx+Attr
;Interleave:      Sprite
;Mask:            No

EXTRUDER_NOZZLE_PX:
	DEFB	0x7F,0xF2,0x7F,0xF2,0x00,0x00,0x3F,0xE4
	DEFB	0x00,0x00,0x1F,0xC8,0x00,0x00,0x0F,0x90

EXTRUDER_NOZZLE_C:
	DEFB	0x47,0x07