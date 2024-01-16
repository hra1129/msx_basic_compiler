BIOS_CALSLT         	:= 0x0001C
bios_decmul				:= 0x027e6
bios_int				:= 0x030cf
blib_get_sin_table		:= 0x040de
bios_line				:= 0x058FC
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
work_circle_prev_cxoff1	:= work_buf + 78	;	1�O�� cxoff (�������a * COS)
work_circle_prev_cyoff1	:= work_buf + 80	;	1�O�� cyoff (�������a * SIN)
work_circle_prev_cxoff2	:= work_buf + 82	;	1�O�� cxoff (�������a * SIN)
work_circle_prev_cyoff2	:= work_buf + 84	;	1�O�� cyoff (�������a * COS)
work_circle_cxoff1		:= work_buf + 86	;	1�O�� cxoff (�������a * COS)
work_circle_cyoff1		:= work_buf + 88	;	1�O�� cyoff (�������a * SIN)
work_circle_cxoff2		:= work_buf + 90	;	1�O�� cxoff (�������a * SIN)
work_circle_cyoff2		:= work_buf + 92	;	1�O�� cyoff (�������a * COS)

WORK_ARG                := 0x0F847

bios_chgmod				:= 0x0005F

work_gxpos				:= 0x0FCB3
work_gypos				:= 0x0FCB5
work_aspect				:= 0x0F931			;	�䗦 single real
work_cpcnt				:= 0x0F939			;	�J�n�_ single real
work_crcsum				:= 0x0F93D			;	�I���_ single real
work_csclxy				:= 0x0F941			;	�~�ʂ̕���\
work_cxoff				:= 0x0F945			;	�������a
work_cyoff				:= 0x0F947			;	�������a
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
			ld			[work_circle_centerx], hl
			ld			hl, 106
			ld			[work_circle_centery], hl
			; ���a
			ld			hl, 100
			ld			[work_circle_radiusx], hl
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
			ld			de, 100
			call		_sub_circle_mul
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
			ld			de, 100
			call		_sub_circle_mul
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
			LD		HL, [work_circle_radiusx]		;	�������a
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
			LD		[work_circle_radiusy], HL
	;	sin�e�[�u�����Q�b�g����
			LD		IX, blib_get_sin_table
			CALL	call_blib
	;	���a�����l
			LD		HL, [work_circle_radiusx]
			LD		[work_circle_cxoff1], HL
			LD		[work_circle_cyoff2], HL
			LD		HL, 0
			LD		[work_circle_cxoff2], HL
			LD		[work_circle_cyoff1], HL
	;	�� = 0����45��
			LD		B, L					; B = 1
			INC		B
			PUSH	BC
	_sub_circle_theta_loop:
			LD		A, B
	;		���O�̒l�� prev �ֈړ�
			LD		HL, work_circle_cxoff1
			LD		DE, work_circle_prev_cxoff1
			LD		BC, 8
			LDIR
	;		X1 = cos�� * �������a, Y2 = cos�� * �������a
			CALL	_sub_circle_cos			; HL = cos��
			PUSH	HL
			LD		DE, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		[work_circle_cxoff1], HL
			POP		HL
			LD		DE, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		[work_circle_cyoff2], HL
	;		Y1 = sin��* �������a, X2 = sin�� * �������a
			POP		AF
			PUSH	AF
			CALL	_sub_circle_sin			; HL = sin��
			PUSH	HL
			LD		DE, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		[work_circle_cyoff1], HL
			POP		HL
			LD		DE, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		[work_circle_cxoff2], HL
	;		��0�ی� (0�`90��)
	_sub_circle_quadrant0_process:
			LD		A, [work_circle_quadrant0]
			OR		A, A
			JR		NZ, _sub_circle_quadrant1_process
			POP		BC
			PUSH	BC
			LD		A, 3
			CALL	_sub_circle_quadrant_process
	;		��1�ی� (90�`180��)
	_sub_circle_quadrant1_process:
			LD		A, [work_circle_quadrant1]
			OR		A, A
			JR		NZ, _sub_circle_quadrant2_process
			POP		BC
			PUSH	BC
			LD		A, 128
			SUB		A, B
			LD		B, A
			LD		A, 2
			CALL	_sub_circle_quadrant_process
	;		��2�ی� (180�`270��)
	_sub_circle_quadrant2_process:
			LD		A, [work_circle_quadrant2]
			OR		A, A
			JR		NZ, _sub_circle_quadrant3_process
			POP		AF
			PUSH	AF
			ADD		A, 128
			LD		B, A
			LD		A, 1
			CALL	_sub_circle_quadrant_process
	;		��3�ی� (270�`360��)
	_sub_circle_quadrant3_process:
			LD		A, [work_circle_quadrant3]
			OR		A, A
			JR		NZ, _sub_circle_quadrant_end
			POP		AF
			PUSH	AF
			NEG
			LD		B, A
			XOR		A, A
			CALL	_sub_circle_quadrant_process

	_sub_circle_quadrant_end:
			POP		BC
			INC		B
			BIT		5, B
			JP		NZ, _sub_circle_line_process
			PUSH	BC


			JP		_sub_circle_theta_loop

	; A �� bit0 �� 0 �Ȃ� X�������]�Abit1 �� 0 �Ȃ� Y�������]
	; B �Ɋp�x 0�`31 (0���`45��)
	_sub_circle_quadrant_process:
			PUSH	AF
			; �n�_X1
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_cxoff1]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_cx1
	_sub_circle_quadrant_process_sub_cx1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_cx1
	_sub_circle_quadrant_process_add_cx1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_cx1:
			LD		[work_gxpos], HL

			; �n�_Y1
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_cyoff1]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_cy1
	_sub_circle_quadrant_process_sub_cy1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_cy1
	_sub_circle_quadrant_process_add_cy1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_cy1:
			LD		[work_gypos], HL
			POP		AF

			PUSH	AF
			; �I�_X1
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_prev_cxoff1]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_pcx1
	_sub_circle_quadrant_process_sub_pcx1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcx1
	_sub_circle_quadrant_process_add_pcx1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcx1:
			LD		C, L
			LD		B, H

			; �I�_Y1
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_prev_cyoff1]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_pcy1
	_sub_circle_quadrant_process_sub_pcy1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcy1
	_sub_circle_quadrant_process_add_pcy1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcy1:
			EX		DE, HL

			CALL	bios_line
			POP		AF

			PUSH	AF
			; �n�_X2
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_cxoff2]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_cx2
	_sub_circle_quadrant_process_sub_cx2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_cx2
	_sub_circle_quadrant_process_add_cx2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_cx2:
			LD		[work_gxpos], HL

			; �n�_Y2
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_cyoff2]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_cy2
	_sub_circle_quadrant_process_sub_cy2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_cy2
	_sub_circle_quadrant_process_add_cy2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_cy2:
			LD		[work_gypos], HL
			POP		AF

			PUSH	AF
			; �I�_X2
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_prev_cxoff2]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_pcx2
	_sub_circle_quadrant_process_sub_pcx2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcx2
	_sub_circle_quadrant_process_add_pcx2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcx2:
			LD		C, L
			LD		B, H

			; �I�_Y2
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_prev_cyoff2]
			RRCA
			JR		C, _sub_circle_quadrant_process_add_pcy2
	_sub_circle_quadrant_process_sub_pcy2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcy2
	_sub_circle_quadrant_process_add_pcy2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcy2:
			EX		DE, HL

			CALL	bios_line
			POP		AF
			RET

	_sub_circle_line_process:
			RET

	;	HL = HL * DE >> 8  ��HL=�����t��, DE=��������
	;	   = (HL * E >> 8) + HL * D
	_sub_circle_mul:
			LD		C, E
			LD		B, D
			EX		DE, HL
			LD		HL, 0
			LD		A, 8
	_sub_circle_mul_1st8bit:
			SLA		L
			RL		H
			SLA		C
			JR		NC, _sub_circle_mul_1st8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_1st8bit_skip1:
			DEC		A
			JR		NZ, _sub_circle_mul_1st8bit
			LD		L, H
			LD		A, H
			LD		H, 0
			ADD		A, A
			JR		NC, _sub_circle_mul_2nd8bit
			DEC		H
	_sub_circle_mul_2nd8bit:
			SRL		B
			JR		NC, _sub_circle_mul_2nd8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_2nd8bit_skip1:
			SLA		E
			RL		D
			INC		B
			DJNZ	_sub_circle_mul_2nd8bit
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
