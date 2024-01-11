BIOS_CALSLT         	:= 0x0001C
bios_decmul				:= 0x027e6
bios_int				:= 0x030cf
blib_get_sin_table		:= 0x040de
WORK_BLIBSLOT			:= 0x0F3D3
work_aspct1				:= 0x0f40b
work_aspct2				:= 0x0f40d
work_buf				:= 0x0f55e
work_valtyp				:= 0x0f663
work_dac				:= 0x0f7f6
work_scrmod				:= 0x0fcaf
work_circle_x_shift		:= work_buf + 65
work_circle_quadrant0	:= work_buf + 66
work_circle_quadrant1	:= work_buf + 67
work_circle_quadrant2	:= work_buf + 68
work_circle_quadrant3	:= work_buf + 69
work_circle_centerx		:= work_buf + 70	;	���S���WX
work_circle_centery		:= work_buf + 72	;	���S���WY
work_circle_radiusx		:= work_buf + 74	;	�������a
work_circle_radiusy		:= work_buf + 76	;	�������a
work_circle_prev_cxoff	:= work_buf + 78	;	1�O�� cxoff
work_circle_prev_cyoff	:= work_buf + 80	;	1�O�� cyoff

WORK_ARG                := 0x0F847

bios_chgmod				:= 0x0005F

work_gxpos				:= 0x0FCB3
work_gypos				:= 0x0FCB5
work_aspect				:= 0x0F931			;	�䗦 single real
work_cxoff				:= 0x0F945			;	�����I�t�Z�b�g
work_cyoff				:= 0x0F947			;	�����I�t�Z�b�g
work_cpcnt				:= 0x0F939			;	�J�n�_ single real
work_crcsum				:= 0x0F93D			;	�I���_ single real
work_csclxy				:= 0x0F941			;	���[�v��
bios_setatr				:= 0x0011A

			DEFB		0XFE
			DEFW		START_ADDRESS
			DEFW		END_ADDRESS
			DEFW		START_ADDRESS

			ORG			0xA000
START_ADDRESS::
			; SCREEN 5
			ld			a, 5
			call		bios_chgmod
			; ���S���W
			ld			hl, 128
			ld			[work_gxpos], hl
			ld			hl, 106
			ld			[work_gypos], hl
			; ���a
			ld			hl, 100
			ld			[work_cxoff], hl
			; �J�n�_
			ld			hl, single_0
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; �I���_
			ld			hl, single_0
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; �䗦
			ld			hl, single_1
			ld			de, work_aspect
			; �F
			ld			a, 15
			call		bios_setatr
			; �`��
			call		sub_circle
loop:
			jr			loop
			RET
single_0:
			defb		0x00, 0x00, 0x00, 0x00
single_1:
			defb		0x41, 0x10, 0x00, 0x00

; -----------------------------------------------------------------------------
ld_de_hl_for_single:
			ld			bc, 4
			ldir
			ret
; -----------------------------------------------------------------------------
call_blib::
			LD			iy, [work_blibslot - 1]
			CALL		bios_calslt
			EI
			RET
; -----------------------------------------------------------------------------
ld_arg_single_real:
			LD			DE, WORK_ARG
			LD			BC, 4
			LDIR
			LD			[WORK_ARG+4], BC
			LD			[WORK_ARG+6], BC
			LD			A, 8
			LD			[WORK_VALTYP], A
			RET
; -----------------------------------------------------------------------------
			scope		test_001_sin_cos
test_001_sin_cos::
	;	sin�e�[�u�����Q�b�g����
			LD			IX, blib_get_sin_table
			CALL		call_blib
			xor			a, a
			ld			de, result_table
	loop:
			push		de
			push		af
			call		_sub_circle_cos
			pop			af
			pop			de
			ex			de, hl
			ld			[hl], e
			inc			hl
			ld			[hl], d
			inc			hl
			ex			de, hl

			push		de
			push		af
			call		_sub_circle_sin
			pop			af
			pop			de
			ex			de, hl
			ld			[hl], e
			inc			hl
			ld			[hl], d
			inc			hl
			ex			de, hl

			inc			a
			jr			nz, loop
			ret

result_table:
			space		256*2*2
			endscope

; Circle routine --------------------------------------------------------------
sub_circle::
	;	�������a���v�Z����
			LD		HL, [work_cxoff]		;	�������a
			LD		[work_dac + 2], HL
			LD		A, 2
			LD		[work_valtyp], A
			LD		DE, work_aspect		;	�䗦
			CALL	ld_arg_single_real
			CALL	bios_decmul
			CALL	bios_int
			LD		HL, [work_dac + 2]
			LD		A, [work_aspct2]
			RLCA
			JR		NC, _sub_circle_skip1
			SRL		H
			RR		L
	_sub_circle_skip1:
			LD		[work_cyoff], HL
			;	SCREEN6 or 7 �Ȃ� [buf+65] = 1, ����ȊO�� 0
			LD		A, [work_aspct1 + 1]
			RRCA
			LD		[work_circle_x_shift], A
			LD		C, A
			;	���S�_�̈ʒu�ɂ��A�~��4�ی��̕`��ΏۊO�𔻒� buf+66 = [0] ... buf+69 = [3] (0�Ȃ�ΏہA0�ȊO�Ȃ�ΏۊO)
			LD		A, [work_gxpos + 1]
			LD		B, A
			AND		A, 0x80
			ld		hl, work_circle_quadrant1
			LD		[hl], A		;	[1]
			inc		hl
			LD		[hl], A		;	[2]
			inc		hl
			LD		A, B
			INC		C
			DEC		C
			JR		Z, _sub_circle_skip2
			RRCA
	_sub_circle_skip2:
			AND		A, 0x7F
			LD		[work_circle_quadrant0], A		;	[0]
			LD		[hl], A							;	[3]

			LD		A, [work_gypos + 1]
			LD		B, A
			LD		HL, work_circle_quadrant0
			AND		A, 0x80
			LD		C, A
			OR		A, [HL]
			LD		[HL], A					;	[0]
			INC		HL
			LD		A, C
			OR		A, [HL]
			LD		[HL], A					;	[1]
			INC		HL

			LD		A, B
			AND		A, 0x7F
			ld		c, a
			OR		A, [HL]
			ld		[hl], a					;	[2]
			inc		hl
			LD		A, C
			OR		A, [HL]
			LD		[HL], A					;	[3]
			INC		HL

	;	�傫�����̔��a�����ĉ~�̕���\�����߂�
			ld		hl, [work_cxoff]
			ld		de, [work_cyoff]
			rst		0x20					; CP HL, DE
			jr		c, _sub_circle_bigger_hl
			ex		de, hl
	_sub_circle_bigger_hl:
			

	;	sin�e�[�u�����Q�b�g����
			LD		IX, blib_get_sin_table
			CALL	call_blib
	;	�� = 45����0��
			LD		B, 32
	_sub_circle_theta_loop:
	;		X1 = cos�� * �������a + ���SX���W
			PUSH	BC
			LD		A, B
			CALL	_sub_circle_cos			; HL = cos��
			LD		DE, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		DE, [work_circle_centerx]
			ADD		HL, DE
			LD		[work_cxoff], HL
	;		Y1 = sin��* �������a + ���SY���W
			POP		AF
			PUSH	AF
			CALL	_sub_circle_sin			; HL = sin��
			LD		DE, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		DE, [work_circle_centery]
			ADD		HL, DE
			LD		[work_cyoff], HL
	;		���̊p�x
	

	;	HL = HL * DE >> 8
	_sub_circle_mul:
			LD		C, L
			LD		B, H
			LD		HL, 0
			LD		A, 8
	_sub_circle_mul_1st8bit:
			SRL		B
			RR		C
			JR		NC, _sub_circle_mul_1st8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_1st8bit_skip1:
			DEC		A
			JR		NZ, _sub_circle_mul_1st8bit
			LD		L, H
			LD		H, 0
	_sub_circle_mul_2nd8bit:
			SRL		B
			RR		C
			JR		NC, _sub_circle_mul_2nd8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_2nd8bit_skip1:
			LD		A, C
			OR		A, B
			JR		NZ, _sub_circle_mul_2nd8bit
			RET
	;	cos�Ƃ�Ԃ�: A = �� (0:0���`255:359��) �� A = cos��
	_sub_circle_cos:
			SUB		A, 64
	;	sin�Ƃ�Ԃ�: A = �� (0:0���`255:359��) �� A = sin��
	_sub_circle_sin:
			LD		B, A
			AND		A, 0x3F
			LD		A, B
			JR		Z, _sub_circle_sin_special
			BIT		6, A
			JR		Z, _sub_circle_sin_skip1
			NEG
	_sub_circle_sin_skip1:
			AND		A, 0x3F
			ADD		A, work_buf & 0x0FF		; �J��オ��͔������Ȃ�
			LD		L, A
			LD		H, work_buf >> 8
			LD		A, [HL]
			LD		H, 0
			LD		L, A
			RL		B
			RET		C
			CPL
			DEC		H
			LD		L, A
			INC		HL
			ret
	_sub_circle_sin_special:
			LD		HL, 0
			BIT		6, A
			RET		Z
			INC		H
			RLA
			RET		C
			DEC		H
			DEC		H
			RET
END_ADDRESS:
