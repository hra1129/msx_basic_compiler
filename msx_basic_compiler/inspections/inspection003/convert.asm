; =============================================================================
;	���l�𕶎���ɕϊ�����e�X�g
; -----------------------------------------------------------------------------
;	2023/Aug/15th
; =============================================================================

		db		0xFE
		dw		start_address
		dw		end_address
		dw		start_address


FOUT	:= 0x3425						; DataPack �ɋL�ڂ� 3225h �͌�L�B
DAC		:= 0xF7F6
VALTYP	:= 0xF663

		org		0xC000
start_address:
		;----------------------------------------------------------------------
		ld		hl, DBLVAL1
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 4					; �P���x���� ����
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�

		;----------------------------------------------------------------------
		ld		hl, DBLVAL1
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; �{���x���� ����
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�

		;----------------------------------------------------------------------
		ld		hl, DBLVAL2
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 4					; �P���x���� ����
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�

		;----------------------------------------------------------------------
		ld		hl, DBLVAL2
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; �{���x���� ����
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�

		;----------------------------------------------------------------------
		ld		hl, DBLVAL3
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 2					; ���� ��
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�

		;----------------------------------------------------------------------
		ld		hl, DBLVAL4
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 2					; ���� ��
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�

		;----------------------------------------------------------------------
		ld		hl, DBLVAL5
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; �{���x
		ld		[VALTYP], a

		call	FOUT					; ������ϊ�
		ret

DBLVAL1:	;	99999.999999999
		db		0x00 | 0xC5				; ����, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99

DBLVAL2:	;	99999.999999999
		db		0x00 | 0x45				; ����, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99

DBLVAL3:	;	���� 12345
		db		0x00
		db		0x00
		dw		12345
		db		0x00
		db		0x00
		db		0x00
		db		0x00

DBLVAL4:	;	���� -100
		db		0x00
		db		0x00
		dw		-100
		db		0x00
		db		0x00
		db		0x00
		db		0x00

DBLVAL5:	;	99999.999999999
		db		0x00 | 0x7F				; ����, E+63
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
end_address:
