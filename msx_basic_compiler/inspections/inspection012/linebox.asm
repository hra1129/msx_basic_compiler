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
LINE		:= 0x58FC
LINEBOX		:= 0x58C1
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
		; LINE(10,20)-(200,100)
		ld		hl, 10
		ld		[GXPOS], HL
		ld		hl, 20
		ld		[GYPOS], HL
		ld		bc, 200
		ld		de, 100
		call	LINEBOX
		; COLOR 1
		ld		a, 1			; çï
		call	SETATR
		; LINE(200,20)-(10,100)
		ld		hl, 200
		ld		[GXPOS], HL
		ld		hl, 20
		ld		[GYPOS], HL
		ld		bc, 10
		ld		de, 100
		call	LINE
	loop:
		jp		loop
end_address:
