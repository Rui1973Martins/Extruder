
include "_REF_\COLORS.asm"

ORG #A000

; NOTE: Bubbles, must be 256 bytes aligned
include "_DATA_\Bubbles.asm"
include "_DATA_\Arrow.asm"

ClownAnimator1_TAB
	DEFW	ClownIdleAnimator1_win		; WIN
	DEFW	ClownIdleAnimFrames			; WIN FRAMES TAB

	DEFW	ClownLoseAnimator1			; LOSE
	DEFW	ClownLoseAnimFrames			; LOSE FRAMES TAB

	DEFW	ClownIdleAnimator1_running	; RUNNING
	DEFW	ClownIdleAnimFrames			; RUNNING FRAMES TAB

ClownAnimator2_TAB
	DEFW	ClownIdleAnimator2_win		; WIN
	DEFW	ClownIdleAnimFrames			; WIN FRAMES TAB

	DEFW	ClownLoseAnimator2			; LOSE
	DEFW	ClownLoseAnimFrames			; LOSE FRAMES TAB

	DEFW	ClownIdleAnimator2_running	; RUNNING
	DEFW	ClownIdleAnimFrames			; RUNNING FRAMES TAB

;include "_DATA_\Clown.asm"
include "_DATA_\ClownIdle.asm"
include "_DATA_\ClownErase.asm"
include "_DATA_\ClownLose.asm"
include "_DATA_\Char-Tiles.asm"

