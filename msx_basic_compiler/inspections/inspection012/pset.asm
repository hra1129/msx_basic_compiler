; =============================================================================
;	ê¸Çï`âÊÇ∑ÇÈÉeÉXÉg
; -----------------------------------------------------------------------------
;	2023/Dec/10th
; =============================================================================

		db		0xFE
		dw		start_address
		dw		end_address
		dw		start_address

CHGMOD		:= 0x005F
SETATR		:= 0x011A
PSET		:= 0x57F5
GXPOS		:= 0xFCB3
GYPOS		:= 0xFCB5

		org		0xC000
start_address:
		; SCREEN2
		ld		a, 2
		call	CHGMOD
		; COLOR 8
		ld		a, 8			; ê‘
		call	SETATR
		; PSET(10,20)
		ld		bc, 10
		ld		de, 20
		call	PSET
	loop:
		jp		loop
end_address:
