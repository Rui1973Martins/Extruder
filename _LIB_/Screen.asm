INCSY
		LD A,D
		OR #F8
		INC A
		JR Z,INCSY543
		INC D
	RET					;END
INCSY543
		LD A,E
		OR #1F
		INC A
		LD A,E
		JR Z,INCSY76
		ADD A,#20
		LD E,A
		LD A,D
		JR INCSYO
INCSY76
		AND #1F
		LD E,A
		LD A,D
		ADD A,#08
INCSYO
		AND #F8
		LD D,A
RET


PixelAD
		LD A,H
		AND #7
		OR #40
		LD D,A
		LD A,H
		RRA
		RRA
		RRA
		AND #18
		OR D
		LD D,A
		LD A,H
		RLA
		RLA
		AND #E0
		LD E,A
		LD A,L
		RRA
		RRA
		RRA
		AND #1F
		OR E
		LD E,A
RET


ColorAD
		SRL D;0->D
		SCF;c=1
		RR  D;1->D
		SCF;c=1
		RR  D;1->D
		SRL D;0->D->E
		RR E
		SCF;c=1
		RR  D;1->D->E
		RR  E
		SRL D;0->D->E
		RR  E
RET

ColorADA
		LD A,D
		RRA;Dump 3
		RRA
		RRA
		RRA;->D->E
		RR E
		RRA;->D->E
		RR E
		RRA;->D->E
		RR E
		AND #03;High
		OR  #58;Addr
		LD D,A
RET


M_REPPY	DEFB 0
M_REPCY	DEFB 0
M_BLITW	DEFW 0
M_BLITH	DEFB 0
	
REPPY	DEFB 0
REPCY	DEFB 0
BLITW	DEFW 0
BLITH	DEFB 0


B_CBlitM_H2W2_0
	XOR A
B_CBlitM_H2W2
	INC HL		; pass Over Width (fixed)
	INC HL
	; FallTrough

; WARNING: Entry Point
B_CBlit_H2W2		; Specific Ottimized code for Width 2

	LD A,(HL)	; Color
	INC HL
	LD H,(HL)
	LD L,A
	
	AND A	; RESET Carry
		;CALL ColorADA
			; UNROLL CALL
			LD A,D
			RRA;Dump 3
			RRA
			RRA
			RRA;->D->E
			RR E
			RRA;->D->E
			RR E
			RRA;->D->E
			RR E
			AND #03;High
			OR  #58;Addr
			LD D,A

	LD A, 2		;Height in Chars
	AND	#1F
	JR	NZ, $+2+1
		INC A
	LD	B, A
	EX	AF, AF'	;SaveA
	LD	A, B

	; LOOP Completly UNROLLED
 		; Specific Ottimized code for Width 2
			LDI	; LDIR
			LDI

		LD	BC,#0020-2	; Optimized for Width 2
		EX	DE, HL		;SaveHL
		ADD	HL, BC
		EX	DE, HL		;RestHL and DE

			LDI	; LDIR
			LDI

		; LD	BC,#0020-2	; Optimized for Width 2
		; EX	DE, HL		;SaveHL
		; ADD	HL, BC
		; EX	DE, HL		;RestHL and DE
	RET
	
; ===== ===== =====	

B_CBlitM_W2_0
	XOR A
B_CBlitM_W2
	INC HL		; pass Over Width (fixed)
	LD A,(HL)
	EX AF, AF'	; Store Height
	INC HL
	; FallTrough

; WARNING: Entry Point
B_CBlit_W2		; Specific Ottimized code for Width 2
	LD A,(HL)	; Color
	INC HL
	LD H,(HL)
	LD L,A
		;CALL ColorADA
			; UNROLL CALL
			LD A,D
			RRA;Dump 3
			RRA
			RRA
			RRA;->D->E
			RR E
			RRA;->D->E
			RR E
			RRA;->D->E
			RR E
			AND #03;High
			OR  #58;Addr
			LD D,A

	EX AF, AF'	;restore Height		;LD A,(M_BLITH)
	RRA			; / 2
	RRA			; / 4
	RRA			; / 8
	AND	#1F
	JR	NZ, $+2+1
		INC A
	LD	B, A
	EX	AF, AF';SaveA
	LD	A, B
 B_CBlit_W2_L
	; Specific Ottimized code for Width 2
			LDI	; LDIR
			LDI
		EX	DE, HL		;SaveHL
		LD	BC,#0020-2	; Optimized for Width 2
		ADD	HL, BC
		EX	DE, HL		;RestHL and DE

		DEC A
		JR NZ,B_CBlit_W2_L
	RET
	
; ===== ===== =====	


M_CBlitM0
	XOR A
M_CBlitM
	;LD (M_REPPY),A
	LD (M_REPCY),A
	LD A,(HL)
	LD (M_BLITW),A
	INC HL
	LD A,(HL)
	LD (M_BLITH),A
	INC HL
	; FallTrough

; WARNING: Entry Point
M_CBlit
	LD A,(HL);Col
	INC HL
	LD H,(HL)
	LD L,A
		CALL ColorADA
	LD A,(M_BLITH)
	RRA;/8
	RRA
	RRA
	AND #1F
	JR NZ,$+2+1
		INC A
	LD B,A
	EX AF,AF';SaveA
	LD A,B
	PUSH HL;Loop
M_CBlitL
		LD BC,(M_BLITW)
		PUSH DE
			LDIR
			EX DE,HL;SaveHL
		POP HL;DE
		;LD BC,#0020
		LD C,#20;B=0
		ADD HL,BC
		EX DE,HL;RestHL
		DEC A
		JR NZ,M_CBlitL
	POP HL
	LD A,(M_REPCY)
	DEC A
   RET M
	LD (M_REPCY),A
	EX AF,AF'
	JR M_CBlitL-1-1-1-1
	
; ===== ===== =====	

; ----- ----- ------	

PxBlit0		; Similar to Blit0, except only Pixels are processed (PBlit)
	XOR A
PxBlit		; Similar to Blit, except only Pixels are processed (PBlit)

; IMPORTANT: Next code is clonned from start of PBlit (must be kept synchronized/equal with it)
	LD (REPCY),A
	LD (REPPY),A
	LD A,(HL)
	LD (BLITW),A
	INC HL
	LD A,(HL)
	LD (BLITH),A
	INC HL
	PUSH HL
	; Enter Blit existing code
	JP ReEntryPBlit

Blit0
	XOR A
Blit
	LD (REPCY),A
	LD (REPPY),A
	LD A,(HL)
	LD (BLITW),A
	INC HL
	LD A,(HL)
	LD (BLITH),A
	INC HL
	PUSH HL
StartReEntryPBlit
		PUSH DE					; 1 byte ()
			;CBlit
				LD A,(HL);Col	; 1 byte ()
				INC HL
				LD H,(HL)
				LD L,A
					CALL ColorADA
				LD A,(BLITH)
				RRA;/8
				RRA
				RRA
				AND #1F
				JR NZ,CBlitLoop0
					INC A
			CBlitLoop0
				LD B,A
				EX AF,AF';SaveA
				LD A,B
				PUSH HL;Loop
					JP CBlitLoopEntry
			CBlitLoop
					; Advance DE
					LD C,#20;B=0	;LD BC,#0020
					ADD HL,BC
					EX DE,HL	;RestHL

			CBlitLoopEntry
					LD BC,(BLITW)
					PUSH DE
						LDIR
						EX DE,HL;SaveHL
					POP HL;DE
					DEC A
					JP NZ,CBlitLoop

					EX DE,HL
				POP HL
				LD A,(REPCY)
				DEC A
			JP M,CBLITEnd
				LD (REPCY),A
				
					; Advance DE
					EX DE,HL	;SaveHL
					LD C,#20;B=0	;LD BC,#0020
					ADD HL,BC
					EX DE,HL	;RestHL
					
				EX AF,AF'
				JP CBlitLoop0
			CBLITEnd

		POP DE
ReEntryPBlit
		EX DE,HL
		CALL PixelAD
	POP HL
    INC HL
    INC HL
PBlit
	LD A,(HL);Px
	INC HL
	LD H,(HL)
	LD L,A
PBlitLoop0
	PUSH HL
		LD A,(BLITH)
		JP PBlitLoopEntry
PBlitLoop
		; Advance DE
		EX AF,AF'
			;PART INLINE
			LD A,D;INCSY
			OR #F8
			INC A
			JP NZ,PBlit_X1
				CALL INCSY543
				JP PBlit_X2
			PBlit_X1
				INC D
			PBlit_X2
		EX AF,AF'

PBlitLoopEntry
		LD BC,(BLITW)
		PUSH DE
			;LDI
			LDIR
		POP DE
		DEC A
        JP NZ,PBlitLoop
    POP HL
	LD A,(REPPY)
	DEC A;
RET M
    LD (REPPY),A

		; Advance DE
		EX AF,AF'
			;PART INLINE
			LD A,D;INCSY
			OR #F8
			INC A
			JP NZ,PBlit_J11
				CALL INCSY543
				JP PBlit_J12
			PBlit_J11
				INC D
			PBlit_J12
		EX AF,AF'

	JP PBlitLoop0;	PBlitL-3-1


RBLIT0
		XOR A
RBLIT
		LD (REPPY),A
		LD A,(HL)		;Width	(Bytes)
		LD (RCBLITW),A
		LD (RPBlitW),A
		INC HL
		LD A,(HL)		;Height	(Px)
		LD (BLITH),A
		INC HL
		PUSH HL
			PUSH DE
				;CALL RCBLIT
				RCBLIT
						LD A,(HL)
						INC HL
						LD B,(HL)
						LD C,A		;Color Addr

						INC HL		;Pixel Addr Low
						INC HL		;Pixel Addr High
						INC HL		; Multiply
						; LOAD Mult, and Divide by 8 = (Width/8) * Height
						LD A,(HL)
						RRA;/8
						RRA
						RRA
						AND #1F
						DEC A	;?
						LD L,A
						LD H,0
						ADD HL,BC
						
							CALL ColorADA	; input = DE; Output = DE; trashes A

						LD A,(BLITH)
						RRA;/8
						RRA
						RRA
						AND #1F
						JR NZ,RCBLITI
							INC A
					RCBLITI
						LD BC,(RCBLITW)	; NOTE: only less significant 8 bits are used.
						EX DE,HL
							ADD HL,BC
						EX DE,HL
						DEC DE
						;LD BC,(RCBLITW)		;Optimized Out
						JP RCBlitLoopEntry
					RCBlitLoop
						EX DE,HL		;SaveHL
							LD C,#20;B=0	;LD BC,#0020
							ADD HL,BC
					RCBLITW EQU $+1
							LD BC,#0000		;(BLITW)
							ADD HL,BC
						EX DE,HL		;RestHL
					RCBlitLoopEntry
							LDD		;Optimizer
						LDDR
						DEC A
						JP NZ,RCBlitLoop
				;RET
				RCBlitEnd

			POP DE
			EX DE,HL
				CALL PixelAD
		POP HL
		INC HL
		INC HL
RPBLIT
		LD C,(HL);Px
		INC HL
		LD B,(HL)
		PUSH HL
			LD L,C
			LD H,B
			DEC HL
		POP BC;Mult
		INC BC
		LD A,(BC)
		LD C,A
		LD B,0
		ADD HL,BC
		LD BC,(RPBlitW)
		EX DE,HL
		ADD HL,BC
		EX DE,HL
		DEC DE
		LD  A,(BLITH)
		JP RPBlitLoopEntry
RPBlitLoop
		INC DE;FixBUG
		EX AF,AF'
		;PartINLINE
		LD A,D;INCSY
		OR #F8
		INC A
		JP NZ,RPBLIT_X1
			CALL INCSY543
			JP RPBLIT_X2
	RPBLIT_X1
			INC D
	RPBLIT_X2
		EX AF,AF'
		DEC DE;FixBUG
	RPBlitW EQU $+1
		LD BC,0;(BLITW)
		EX DE,HL
		ADD HL,BC
		EX DE,HL
RPBlitLoopEntry
			LDD		;Optimizer
		LDDR
		DEC A
		JP NZ,RPBlitLoop
RET

XBlit0
		XOR A	; Set NO RepeatY <=> 0
XBlit
		EX AF, AF'	; Save RepeatY
		PUSH HL
		EX DE,HL
			CALL PixelAD
		POP HL
ZBLIT 
		PUSH HL
			LD C,(HL);WidthB
			INC HL
			LD H,(HL);Height
XLINEL0		 XOR A;0
			LD B,C
			LD L,E;Save dE
XLINEL	 	LD (DE),A
			INC DE
			DJNZ XLINEL
			LD E,L;Load dE
			;Part INLINE
			LD A,D;INCSY
			OR #F8
			INC A
			JP NZ,XBlit_X1
				CALL INCSY543
				JP XBlit_X2
		XBlit_X1
				INC D
		XBlit_X2
			DEC H
			JP NZ,XLINEL0
		POP HL
		EX AF, AF'	; Restore RepeatY
		OR A
	RET Z
		DEC A
		EX AF,AF'	; Save RepeatY
		JP ZBLIT
;RET


;BLITCOFX DEFW 0	;Offset X
;BLITCDTX DEFW 0	; Delta X
;BLITCRMX DEFW 0	;Remind X

BlitClip
		LD A,(BLITCDTX)		; DeltaWidth
			LD (CBlitCDTX),A		; Copy DeltaWidth
		LD C,A
		LD A,(HL)			; Width
		SUB C				; Width - DeltaWidth
		LD (BLITCRMX),A		; Reminder = Width - DeltaWidth

		INC HL
		LD A,(HL)			; Height
		LD (BLITH),A		; Save Height
		;EX AF,AF'			; Save Height

		INC HL
		PUSH HL
			PUSH DE			

				;CALL CBlitClip
						LD A,(HL)
						INC HL
						LD H,(HL)
						LD L,A		; Color Data Addr
							CALL ColorADA

						LD A,(BLITH)
						RRA;/8
						RRA
						RRA
						AND #1F
						JR NZ,CBlitClipLoop0;$+2+1
							INC A
				CBlitClipLoop0
					;CBlitCOFX EQU $+1
						LD BC,(BLITCOFX)
						ADD HL,BC			; ClipStart = ColorData + ClipOffset
						JP CBlitClipLoopEntry
				CBlitClipLoop
						LD C,#20;B=0	;LD BC,#0020
						ADD HL,BC
						EX DE,HL
					;CBLITCRMX EQU $+1
						LD BC,(BLITCRMX)		; BC = Reminder
						ADD HL,BC				; Advance Source by Reminder
				CBlitClipLoopEntry
					CBlitCDTX EQU $+1
						LD BC,0	;(CBlitCDTX)		; DeltaWidth
						PUSH DE
							LDIR				; Copy DeltaWidth Bytes
							EX DE,HL			;Save HL
						POP HL;DE
						DEC A					; --Height
						JP NZ,CBlitClipLoop
				;END
			POP DE
			EX DE,HL
				CALL PixelAD
		POP HL
		INC HL
		INC HL
PBlitClip
		LD C,(HL)
		INC HL
		LD H,(HL)
		LD L,C			; HL = PixelData addr
	BLITCOFX EQU $+1
		LD BC,0	;(BLITCOFX)
		ADD HL,BC			; ClipStart = PixelData + ClipOffset
		LD A,(BLITH)		; Restore Height
		JP PBlitClipLoopEntry
PBlitClipLoop
		EX AF,AF'				; Save Height
		;PartINLINE				; Increment Screen Y
		LD A,D;INCSY
		OR #F8
		INC A
		JP NZ,PBlitClip_X1
			CALL INCSY543
			JP PBlitClip_X2
	PBlitClip_X1
			INC D
	PBlitClip_X2
		EX AF,AF'				; Restore Height
	BLITCRMX EQU $+1
		LD BC,0	;(BLITCRMX)		; BC = Reminder
		ADD HL,BC				; Advance Source by Reminder
PBlitClipLoopEntry
	BLITCDTX EQU $+1
		LD BC,0	;(BLITCDTX)		; DeltaWidth
		PUSH DE
			LDIR				; Copy DeltaWidth Bytes
		POP DE
		DEC A					; --Height
		JP NZ,PBlitClipLoop
RET