; =============================================================================
;	�^�ϊ��I�[�o�[�t���[�e�X�g
;	Type conversion test on MATHPACK
; -----------------------------------------------------------------------------
;	2023/Aug/11th
; =============================================================================

		db		0xFE
		dw		start_address
		dw		end_address
		dw		start_address


FRCINT	:= 0x2F8A
DAC		:= 0xF7F6
VALTYP	:= 0xF663

		org		0xC000
start_address:
		ld		hl, DBLVAL
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; �{���x����
		ld		[VALTYP], a

		call	FRCINT					; �����ɕϊ�
		ret

DBLVAL:	;	99999.999999999
		db		0x00 | 0x45				; ����, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
end_address:
