; =============================================================================
;	���Z���Z�̌^�m�F
; -----------------------------------------------------------------------------
;	2023/Aug/15th
; =============================================================================

		db		0xFE
		dw		start_address
		dw		end_address
		dw		start_address


DECADD	:= 0x269A
DAC		:= 0xF7F6
VALTYP	:= 0xF663
ARG		:= 0xF847
MOVFM	:= 0x2EBE						; DAC��[HL] �P���x
MAF		:= 0x2C4D						; ARG��DAC  �{���x

		org		0xC000
start_address:
		ld		hl, DBLVAL1
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		hl, DBLVAL1
		ld		de, ARG
		ld		bc, 8
		ldir

		ld		a, 4					; �P���x����
		ld		[VALTYP], a

		call	DECADD					; ���Z���Z

		ld		hl, DBLVAL2
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		hl, DBLVAL2
		ld		de, ARG
		ld		bc, 8
		ldir

		ld		a, 4					; �P���x����
		ld		[VALTYP], a

		call	DECADD					; ���Z���Z

		ld		hl, DBLVAL2
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		hl, DBLVAL2
		ld		de, ARG
		ld		bc, 8
		ldir

		ld		a, 8					; �{���x����
		ld		[VALTYP], a

		call	DECADD					; ���Z���Z

		ld		hl, DBLVAL3
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		hl, DBLVAL3
		ld		de, ARG
		ld		bc, 8
		ldir

		ld		a, 4					; �P���x����
		ld		[VALTYP], a

		call	DECADD					; ���Z���Z

		ld		hl, DBLVAL2
		call	MOVFM
		call	MAF
		ld		hl, DBLVAL2
		call	MOVFM
		call	DECADD
		ret

DBLVAL1:	;	99999.999999999
		db		0x00 | 0x45				; ����, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x00
		db		0x00
		db		0x00
		db		0x00

DBLVAL2:	;	99999.999999999
		db		0x00 | 0x45				; ����, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99

DBLVAL3:	;	99999.999999999
		db		0x00 | 0x45				; ����, E+5
		db		0x01
		db		0x01
		db		0x01
		db		0x01
		db		0x01
		db		0x01
		db		0x01
end_address:
