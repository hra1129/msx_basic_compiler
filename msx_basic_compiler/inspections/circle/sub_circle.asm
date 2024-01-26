BIOS_CALSLT         	:= 0x0001C
bios_frcsng				:= 0x02FB2
bios_decmul				:= 0x027e6
bios_frcint				:= 0x02f8a
blib_get_sin_table		:= 0x040de
bios_line				:= 0x058FC
WORK_BLIBSLOT			:= 0x0F3D3
work_rg9sav				:= 0x0FFE8
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
work_savea				:= 0x0F942			;	���g�p
work_savem				:= 0x0F944			;	0: �J�n�p > �I���p�A1: �J�n�p < �I���p
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
			; �䗦
			ld			hl, single_0p5
			ld			de, work_aspect
			call		ld_de_hl_for_single
			; �F
			ld			a, 15
			call		bios_setatr

			; ���a
			ld			hl, 25
			ld			[work_circle_radiusx], hl
			; �J�n�_
			ld			hl, single_0
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; �I���_
			ld			hl, single_1
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; �`��
			call		sub_circle

			; ���a
			ld			hl, 50
			ld			[work_circle_radiusx], hl
			; �J�n�_
			ld			hl, single_1
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; �I���_
			ld			hl, single_2
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; �`��
			call		sub_circle

			; ���a
			ld			hl, 100
			ld			[work_circle_radiusx], hl
			; �J�n�_
			ld			hl, single_1
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; �I���_
			ld			hl, single_0
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; �`��
			call		sub_circle

			; ���a
			ld			hl, 150
			ld			[work_circle_radiusx], hl
			; �J�n�_
			ld			hl, single_2
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; �I���_
			ld			hl, single_1
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; �`��
			call		sub_circle
			RET
single_0:
			defb		0x00, 0x00, 0x00, 0x00
single_1:
			defb		0x41, 0x10, 0x00, 0x00
single_2:
			defb		0x41, 0x20, 0x00, 0x00
single_0p5:
			defb		0x40, 0x50, 0x00, 0x00
single_407437:
			defb		0x42, 0x40, 0x74, 0x37

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
ld_dac_single_real:
			LD			DE, WORK_DAC
			LD			BC, 4
			LDIR
			LD			[WORK_DAC+4], BC
			LD			[WORK_DAC+6], BC
			LD			A, 8
			LD			[WORK_VALTYP], A
			RET

; Circle routine --------------------------------------------------------------
sub_circle::
	;	�������a���v�Z����
			LD		HL, work_aspect					;	�䗦
			CALL	ld_arg_single_real
			LD		HL, [work_circle_radiusx]		;	�������a
			LD		[work_dac + 2], HL
			LD		A, 2
			LD		[work_valtyp], A
			CALL	bios_frcsng
			CALL	bios_decmul
			CALL	bios_frcint
			LD		HL, [work_dac + 2]
			LD		A, [work_aspct2]
			RLCA
			JR		NC, _sub_circle_skip1
			SRL		H
			RR		L
	_sub_circle_skip1:
			LD		[work_circle_radiusy], HL
	;	�J�n�p�� 0�`255 �ɕϊ�����
			LD		HL, work_cpcnt
			CALL	ld_arg_single_real
			LD		HL, single_407437
			CALL	ld_dac_single_real
			LD		A, 4
			LD		[work_valtyp], A
			CALL	bios_decmul
			CALL	bios_frcint
			LD		A, [work_dac + 2]
			LD		[work_cpcnt], A
	;	�I���p�� 0�`255 �ɕϊ�����
			LD		HL, work_crcsum
			CALL	ld_arg_single_real
			LD		HL, single_407437
			CALL	ld_dac_single_real
			LD		A, 4
			LD		[work_valtyp], A
			CALL	bios_decmul
			CALL	bios_frcint
			LD		A, [work_dac + 2]
			LD		[work_crcsum], A
	;	�J�n�p�ƏI���p�̑召����
			LD		B, A					; B = �I���p
			LD		A, [work_cpcnt]			; A = �J�n�p
			CP		A, B
			LD		A, 0
			RLA
			LD		[work_savem], A
	;	sin�e�[�u�����Q�b�g����
			LD		IX, blib_get_sin_table
			CALL	call_blib
	;	���a�����l
			LD		HL, [work_circle_radiusx]
			LD		[work_circle_cxoff1], HL
			LD		HL, [work_circle_radiusy]
			LD		[work_circle_cyoff2], HL
			LD		HL, 0
			LD		[work_circle_cxoff2], HL
			LD		[work_circle_cyoff1], HL
	;	�� = 0����45��
			LD		A, [work_csclxy]
			LD		B, A
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
			LD		BC, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		[work_circle_cxoff1], HL
			POP		HL
			LD		BC, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		[work_circle_cyoff2], HL
	;		Y1 = sin��* �������a, X2 = sin�� * �������a
			POP		AF
			PUSH	AF
			CALL	_sub_circle_sin			; HL = sin��
			PUSH	HL
			LD		BC, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		[work_circle_cyoff1], HL
			POP		HL
			LD		BC, [work_circle_radiusx]
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
			XOR		A, A
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
			LD		A, 1
			CALL	_sub_circle_quadrant_process

	_sub_circle_quadrant_end:
			POP		BC
			BIT		5, B
			JP		NZ, _sub_circle_line_process
			LD		A, [work_csclxy]
			ADD		A, B
			LD		B, A
			PUSH	BC
			JP		_sub_circle_theta_loop

	; B ���`��Ώۂ��ǂ������ׂ�
	; Cy = 0: �Ώ�, 1: ��Ώ�
	_sub_circle_check_angle:
			; �J�n�_�ƏI���_�̑召�֌W�́H
			LD		A, [work_savem]
			OR		A, A
			JR		Z, _sub_circle_check_angle_cond_or
	_sub_circle_check_angle_cond_and:
			; �J�n�_���傫�����H
			LD		A, [work_cpcnt]
			OR		A, A								; 0�̏ꍇ�͑Ώی��
			JR		Z, _sub_circle_check_angle_left1
			CP		A, B
			CCF
			RET		C									; ���ړ_ �� �J�n�_ �Ȃ��Ώ�
	_sub_circle_check_angle_left1:
			; �J�n�_�����傫���B�ł́A�I���_��菬�������H
			LD		A, [work_crcsum]
			OR		A, A								; 0�̏ꍇ�͖������őΏ�
			RET		Z
			CP		A, B
			RET											; ���ړ_ �� �I���_ �Ȃ��Ώ�
	_sub_circle_check_angle_cond_or:
			; �J�n�_���傫�����H
			LD		A, [work_cpcnt]
			CP		A, B
			CCF
			RET		NC									; ���ړ_ �� �J�n�_ �Ȃ�Ώ�
			; �J�n�_�����������B�ł́A�I���_��菬�������H
			LD		A, [work_crcsum]
			CP		A, B
			RET											; ���ړ_ �� �I���_ �Ȃ��Ώ�

	; A �� bit0 �� 0 �Ȃ� X�������]�Abit1 �� 0 �Ȃ� Y�������]
	; B �Ɋp�x 0�`31 (0���`45��)
	_sub_circle_quadrant_process:
			PUSH	BC
			PUSH	AF
			LD		C, A
			CALL	_sub_circle_check_angle
			JR		C, _sub_circle_quadrant_line1_skip
			LD		A, C
			; �n�_X1
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_cxoff1]
			RRCA										; A �� bit0 �� Cy ��
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
			RRCA										; A �� bit1 �� Cy ��
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
			RRCA										; A �� bit0 �� Cy ��
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
			RRCA										; A �� bit1 �� Cy ��
			JR		C, _sub_circle_quadrant_process_add_pcy1
	_sub_circle_quadrant_process_sub_pcy1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcy1
	_sub_circle_quadrant_process_add_pcy1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcy1:
			EX		DE, HL

			CALL	_sub_circle_draw_line
	_sub_circle_quadrant_line1_skip:
			POP		AF
			POP		BC

			PUSH	AF
			LD		C, A
			LD		A, B
			XOR		A, 63
			LD		B, A
			CALL	_sub_circle_check_angle
			JR		C, _sub_circle_quadrant_line2_skip
			LD		A, C
			; �n�_X2
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_cxoff2]
			RRCA										; A �� bit0 �� Cy ��
			JR		NC, _sub_circle_quadrant_process_add_cx2
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
			RRCA										; A �� bit1 �� Cy ��
			JR		NC, _sub_circle_quadrant_process_add_cy2
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
			RRCA										; A �� bit0 �� Cy ��
			JR		NC, _sub_circle_quadrant_process_add_pcx2
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
			RRCA										; A �� bit1 �� Cy ��
			JR		NC, _sub_circle_quadrant_process_add_pcy2
	_sub_circle_quadrant_process_sub_pcy2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcy2
	_sub_circle_quadrant_process_add_pcy2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcy2:
			EX		DE, HL

			CALL	_sub_circle_draw_line
	_sub_circle_quadrant_line2_skip:
			POP		AF
			RET

	_sub_circle_draw_line:
			LD		HL, [work_gxpos]
			CALL	_sub_circle_x_clip
			LD		[work_gxpos], HL
			LD		L, C
			LD		H, B
			JR		C, _sub_circle_x_reject_check
			CALL	_sub_circle_x_clip
			LD		C, L
			LD		B, H
			JR		_sub_circle_draw_line_y
	_sub_circle_x_reject_check:
			CALL	_sub_circle_x_clip
			LD		C, L
			LD		B, H
			JR		NC, _sub_circle_draw_line_y
			LD		A, [work_gxpos+1]
			XOR		A, B
			RET		Z								; X1 �� X2 ���N���b�s���O���āA�������l�Ȃ�`��s�v
	_sub_circle_draw_line_y:
			LD		HL, [work_gypos]
			CALL	_sub_circle_y_clip
			LD		[work_gypos], HL
			LD		L, E
			LD		H, D
			JR		C, _sub_circle_y_reject_check
			CALL	_sub_circle_y_clip
			LD		E, L
			LD		D, H
			JP		bios_line
	_sub_circle_y_reject_check:
			CALL	_sub_circle_y_clip
			LD		E, L
			LD		D, H
			JP		NC, bios_line
			LD		A, [work_gypos+1]
			XOR		A, B
			JP		NZ, bios_line
			RET

	; HL �ɓ����Ă��� X���W���N���b�v
	; �N���b�s���O�����ꍇ�ACy=1 �Ŗ߂�
	_sub_circle_x_clip:
			LD		A, H
			RLA
			JR		NC, _sub_circle_x_clip_skip1
			LD		HL, 0
			RET									; ������ 0 �ɃN���b�v�����ꍇ�BCy=1 �Ŗ߂�
	_sub_circle_x_clip_skip1:
			LD		A, [work_aspct1 + 1]
			DEC		A
			CP		A, H
			RET		NC							; 0�`255 (511) �͈̔͂𒴂��Ă��Ȃ��ꍇ�� Cy=0 �Ŗ߂�
			LD		HL, [work_aspct1]
			DEC		HL
			SCF
			RET									; 255 (511) �ɒu������ Cy=1 �Ŗ߂�

	; HL �ɓ����Ă��� Y���W���N���b�v
	; �N���b�s���O�����ꍇ�ACy=1 �Ŗ߂�
	_sub_circle_y_clip:
			LD		A, H
			RLA
			JR		NC, _sub_circle_y_clip_skip1
			LD		HL, 0
			RET									; ������ 0 �ɃN���b�v�����ꍇ�BCy=1 �Ŗ߂�
	_sub_circle_y_clip_skip1:
			LD		A, H
			OR		A, A
			JR		Z, _sub_circle_y_clip_skip2
			LD		HL, 211
			LD		A, [work_rg9sav]
			RLA
			RET		C							; 211�ɃN���b�v�����ꍇ�BCy=1 �Ŗ߂�
			LD		L, 191
			CCF
			RET									; 191�ɃN���b�v�����ꍇ�BCy=1 �Ŗ߂�
	_sub_circle_y_clip_skip2:
			LD		A, L
			CP		A, 192
			CCF
			RET		NC							; �N���b�v�̕K�v�������ꍇ�BCy=0 �Ŗ߂�B
			LD		A, [work_rg9sav]
			RLA
			JR		NC, _sub_circle_y_clip_192
			LD		A, L
			CP		A, 212
			CCF
			RET		NC							; �N���b�v�̕K�v�������ꍇ�BCy=0 �Ŗ߂�B
			LD		L, 211
			RET									; 211�ɃN���b�v�����ꍇ�BCy=1 �Ŗ߂�B
	_sub_circle_y_clip_192:
			LD		L, 191
			SCF
			RET									; 191�ɃN���b�v�����ꍇ�BCy=1 �Ŗ߂�B

	_sub_circle_line_process:
			RET

	;	HL = HL * BC >> 8  ��HL=�����t��, BC=��������
	;	   = (HL * C >> 8) + HL * B
	_sub_circle_mul:
			LD		A, H
			OR		A, A
			PUSH	AF								; �����Ȃ� S=1
			JP		P, _sub_circle_skip_abs
			CPL
			LD		H, A
			LD		A, L
			CPL
			LD		L, A
			INC		HL
	_sub_circle_skip_abs:
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
			RL		L
			LD		L, H
			LD		H, 0
			JR		NC, _sub_circle_mul_2nd8bit
			INC		HL
	_sub_circle_mul_2nd8bit:
			SRL		B
			JR		NC, _sub_circle_mul_2nd8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_2nd8bit_skip1:
			SLA		E
			RL		D
			INC		B
			DJNZ	_sub_circle_mul_2nd8bit
			POP		AF
			RET		P
			LD		A, H
			CPL
			LD		H, A
			LD		A, L
			CPL
			LD		L, A
			INC		HL
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
