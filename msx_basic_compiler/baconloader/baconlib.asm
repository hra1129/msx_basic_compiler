; =============================================================================
;	MSX-BACON Library
; -----------------------------------------------------------------------------
;	Copyright (C)2023 HRA!
; =============================================================================

chget		:= 0x009F
rslreg		:= 0x0138
calbas		:= 0x0159
errhand		:= 0x406F					; BIOS �� BASIC�G���[�������[�`�� E �ɃG���[�R�[�h�B�߂��Ă��Ȃ��B
blibslot	:= 0xF3D3
putpnt		:= 0xF3F8
getpnt		:= 0xF3FA
buf			:= 0xF55E
fnkstr		:= 0xF87F					; �t�@���N�V�����L�[�̕����� 16���� x 10��
exptbl		:= 0xFCC1

; BASIC error codes
error_syntax					:= 2
error_illegal_function_call		:= 5
error_overflow					:= 6
error_out_of_memory				:= 7
error_subscript_out_of_range	:= 9
error_redimensioned_array		:= 10
error_division_by_zero			:= 11
error_type_mismatch				:= 13
error_out_of_string_space		:= 14
error_string_too_long			:= 15
error_device_IO					:= 19

			org		0x4000

			db		"AB"				; +0000 id
			dw		init_address		; +0002 init
			dw		0					; +0004 statement
			dw		0					; +0006 device
			dw		0					; +0008 text
			dw		0					; +000A reserved0
			dw		0					; +000C reserved1
			dw		0					; +000E reserved2

			db		"BACONLIB"			; Singnature

; =============================================================================
;	MSX-BACON Library Routine public entries
;		sub_xxxx �ȃA�h���X�́A����̏C���ȂǂŕύX�ɂȂ鋰�ꂪ����܂��̂ŁA
;		blib_entries �ɂ��� blib_xxxx �� CALL ���邱�ƁB
;		�����̃A�h���X�l�͈ێ�����܂��B
; =============================================================================
blib_entries::
	blib_key_list:
			jp		sub_key_list
	blib_iotget_int:
			jp		sub_iotget_int
	blib_iotget_str:
			jp		sub_iotget_str
	blib_iotput_int:
			jp		sub_iotput_int
	blib_iotput_str:
			jp		sub_iotput_str
	blib_strcmp:
			jp		sub_strcmp
	blib_inkey:
			jp		sub_inkey
	blib_right:
			jp		sub_right
	blib_left:
			jp		sub_left
	blib_mid:
			jp		sub_mid

; =============================================================================
;	ROM�J�[�g���b�W�ŗp�ӂ����ꍇ�̏��������[�`��
;	bacon_loader �Ń��[�h�����ꍇ���A���[�h���ɂ������Ă΂��
; =============================================================================
init_address::
			scope	update_blibslt
			; BLIBSLOT ���X�V����
			; -- �v���C�}���X���b�g���W�X�^��ǂ�ŁAPage1 �̃X���b�g�𓾂�
			call	rslreg				; Get Primary Slot Register
			rrca
			rrca
			and		a, 0b0000_0011
			ld		b, a
			; -- ���̃X���b�g���g������Ă��邩���ׂ�
			add		a, exptbl & 255
			ld		l, a
			ld		h, exptbl >> 8		; HL = EXPTBL + A
			ld		a, [hl]
			and		a, 0x80
			or		a, b
			ld		b, a
			inc		hl
			inc		hl
			inc		hl
			inc		hl
			ld		a, [hl]
			and		a, 0b0000_1100
			or		a, b
			ld		[blibslot], a
			ret
			endscope

; =============================================================================
;	KEY LIST
;	input:
;		none
;	output:
;		none
;	break:
;		A, B, D, E, H, L, F
;	comment:
;		MSX-BASIC �� KEY LIST �����̓���
; =============================================================================
			scope	sub_key_list
sub_key_list::
			ld		hl, fnkstr			; �t�@���N�V�����L�[������̏ꏊ
			ld		de, 16				; 1�̃L�[�� 16����
			ld		b, 10				; 10�̃L�[��\������
	_loop_key:
			push	hl
	_loop_char:
			ld		a, [hl]
			inc		hl
			or		a, a
			jr		z, _exit_char
			cp		a, 2				; �O���t�B�b�N�����̃v���R�[�h�ȊO�̃R���g���[�������͒u������
			jr		c, _no_replace
			cp		a, 32
			jr		nc, _no_replace
			ld		a, 32				; �X�y�[�X�ɒu��
	_no_replace:
			rst		0x18				; 1�����\���B���W�X�^�S�ۑ��B
			jr		_loop_char
	_exit_char:
			ld		a, 13
			rst		0x18
			ld		a, 10
			rst		0x18
			pop		hl
			add		hl, de
			djnz	_loop_key
			ret
			endscope

; =============================================================================
;	_send_device_path
;	input:
;		HL ... �f�o�C�X�p�X������ (BASIC�`��)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		�f�o�C�X�p�X������𑗐M����B
; =============================================================================
			scope	_send_device_path
_send_device_path::
			ld		c, 8
			; �f�o�C�X�p�X���M�J�n�R�}���h
			ld		a, 0xe0
			out		[c], a
			ld		a, 1
			out		[c], a
			ld		a, 0x53
			out		[c], a
			; ���̂܂� _send_string �֑���
			endscope

; =============================================================================
;	_send_string
;	input:
;		HL ... ���M������ (BASIC�`��)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		���M������𑗐M����B
; =============================================================================
			scope	_send_string
_send_string::
			ld		a, 0xc0
			out		[c], a
			; ������̒������擾
			ld		a, [hl]
	_iot_send_string_loop1:
			ld		b, a
			cp		a, 64							; 64�����ȏ�̏ꍇ�͓��ʏ��������{����
			jr		c, _iot_send_string_skip
			sub		a, 63
			ld		b, 0x7f							; ���ʏ����������R�[�h
	_iot_send_string_skip:
			out		[c], b
			ld		d, a
			ld		a, b
			and		a, 0x3f
			ld		b, a
	_iot_send_string_loop2:
			inc		hl
			ld		a, [hl]
			out		[c], a
			djnz	_iot_send_string_loop2
			ld		a, d
			sub		a, 63
			jr		z, _iot_send_string_exit
			jr		nc, _iot_send_string_loop1
	_iot_send_string_exit:
			in		a, [c]
			rlca									; �G���[�Ȃ� cf = 1, ����Ȃ� cf = 0
			ret		nc
			; �G���[
			ld		e, error_device_IO
			ld		ix, errhand
			jp		calbas
			endscope

; =============================================================================
;	CALL IOTGET( DEVPATH$, INT_VAR )
;	input:
;		HL ... �f�o�C�X�p�X������ (BASIC�`��)
;	output:
;		HL
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC �� _IOTGET( HL, DE ) �����̓���
; =============================================================================
			scope	sub_iotget_int
sub_iotget_int::
			call	_send_device_path
			; ��M�R�}���h���M
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; �����^���ʃR�[�h���M
			ld		a, 0x01
			out		[c], a
			; ��M�J�n
			ld		a, 0x80
			out		[c], a
			in		a, [c]				; �������� 2 ���Ԃ��Ă���
			in		l, [c]
			in		h, [c]
			ret
			endscope

; =============================================================================
;	CALL IOTGET( DEVPATH$, STR_VAR$ )
;	input:
;		HL ... �f�o�C�X�p�X������ (BASIC�`��)
;	output:
;		HL ... ����ꂽ������̃A�h���X (BASIC�`��)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC �� _IOTGET( HL, DE ) �����̓���
; =============================================================================
			scope	sub_iotget_str
sub_iotget_str::
			call	_send_device_path
			; ��M�R�}���h���M
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; ������^���ʃR�[�h���M
			ld		a, 0x03
			out		[c], a
			; ��M�J�n
			ld		a, 0x80
			out		[c], a
			in		b, [c]				; ������̒���
			ld		hl, buf
			ld		[hl], b
	_loop:
			inc		hl
			in		a, [c]
			ld		[hl], a
			djnz	_loop
			ld		hl, buf
			ret
			endscope

; =============================================================================
;	CALL IOTPUT( DEVPATH$, INT )
;	input:
;		HL ... �f�o�C�X�p�X������ (BASIC�`��)
;		DE ... ���M���鐔�l
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC �� _IOTPUT( HL, DE ) �����̓���
; =============================================================================
			scope	sub_iotput_int
sub_iotput_int::
			push	de
			call	_send_device_path
			; ��M�R�}���h���M
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; �����^���ʃR�[�h���M
			ld		a, 0x01
			out		[c], a
			; ���M�J�n
			pop		de
			ld		a, 0xc0
			out		[c], a
			ld		a, 0x02			; ���� 2
			out		[c], a
			out		[c], e
			out		[c], d
			xor		a, a
			out		[c], a
			ret
			endscope

; =============================================================================
;	CALL IOTPUT( DEVPATH$, STR$ )
;	input:
;		HL ... �f�o�C�X�p�X������ (BASIC�`��)
;		DE ... ���M���镶���� (BASIC�`��)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC �� _IOTPUT( HL, DE ) �����̓���
; =============================================================================
			scope	sub_iotput_str
sub_iotput_str::
			push	de
			call	_send_device_path
			; ��M�R�}���h���M
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; ������^���ʃR�[�h���M
			ld		a, 0x03
			out		[c], a
			; ���M�J�n
			pop		hl
			jp		_send_string
			endscope

; =============================================================================
;	STRCMP
;	input:
;		HL ... ������1 (BASIC�`��)
;		DE ... ������2 (BASIC�`��)
;	output:
;		HL < DE ... C = 1, Z = 0
;		HL = DE ... C = 0, Z = 1
;		HL > DE ... C = 0, Z = 0
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		������ HL - DE �����߂�
; =============================================================================
			scope	sub_strcmp
sub_strcmp::
			ld		b, [hl]				; B = [HL] �̒���
			ld		a, [de]				; C = [DE] �̒���
			ld		c, a
			inc		hl
			inc		de
			ex		de, hl

			inc		b
			inc		c
			dec		c
			jr		z, _loop_end
			jr		_loop_start
	_loop:
			ld		a, [de]
			cp		a, [hl]
			ret		c
			ret		nz
			inc		hl
			inc		de
			dec		c
			jr		z, _loop_end
	_loop_start:
			djnz	_loop
			; C ���܂��c���Ă���̂� HL < DE �Ɣ��f�B
			scf
			ret
	_loop_end:
			dec		b
			ret
			endscope

; =============================================================================
;	INKEY$
;	input:
;		none
;	output:
;		HL .... ���͂��ꂽ���� (BASIC�`��)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		�������͂���Ă��Ȃ���� "" ���Ԃ�
; =============================================================================
			scope	sub_inkey
sub_inkey::
			di
			ld		hl, [getpnt]
			ld		a, [putpnt]
			sub		a, l
			jr		z, no_key
		found_key:
			call	chget
			ld		hl, buf+1
			ld		[hl], a
			dec		hl
			ld		[hl], 1
			ret
		no_key:
			ld		hl, buf
			ld		[hl], a
			ei
			ret
			endscope

; =============================================================================
;	RIGHT$( STR$, N )
;	input:
;		HL .... STR$ (BASIC�`��)
;		C ..... ������ N
;	output:
;		HL .... �؂���ꂽ������ (BASIC�`��)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		�������͂���Ă��Ȃ���� "" ���Ԃ�
; =============================================================================
			scope	sub_right
sub_right::
			ex		de, hl
			ld		hl, buf
			ld		[hl], c
			inc		c
			dec		c
			ret		z				; �����AN=0 �Ȃ璷�� 0 �̕������Ԃ�

			ld		a, [de]			; ������̒���
			inc		de
			cp		a, c			; �����ASTR$�̒������� N �̕����傫����΁A�܂�܂�Ԃ�
			jr		nc, skip
			ld		c, a
			ld		[hl], c			; �������X�V
	skip:

			ex		de, hl			; HL = �^�[�Q�b�g������, DE = BUF
			sub		a, c			; A = ������ - N  �����Ȃ炸0�ȏ�B���ɂ͂Ȃ�Ȃ��B
			ld		e, a			; DE = ������ - N
			ld		d, 0
			ld		b, d
			add		hl, de
			ld		de, buf + 1
			ldir

			ld		hl, buf
			ret
			endscope

; =============================================================================
;	LEFT$( STR$, N )
;	input:
;		HL .... STR$ (BASIC�`��)
;		C ..... ������ N
;	output:
;		HL .... �؂���ꂽ������ (BASIC�`��)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		�������͂���Ă��Ȃ���� "" ���Ԃ�
; =============================================================================
			scope	sub_left
sub_left::
			ex		de, hl			; DE = STR$
			ld		hl, buf			; HL = BUF
			ld		[hl], c			; �؂��钷����ݒ�
			inc		c
			dec		c
			ret		z				; �����AN=0 �Ȃ璷�� 0 �̕������Ԃ�

			ld		a, [de]			; ������̒���
			inc		de
			cp		a, c			; �����ASTR$�̒������� N �̕����傫����΁A�܂�܂�Ԃ�
			jr		nc, skip
			ld		c, a
	skip:
			ld		[hl], c
			ld		a, c
			or		a, a
			ret		z
			ld		b, 0
			inc		hl
			ex		de, hl
			ldir
			ld		hl, buf
			ret
			endscope

; =============================================================================
;	MID$( STR$, N, M )
;	input:
;		HL .... STR$ (BASIC�`��)
;		B ..... �ʒu N (�擪�̕����� 1)
;		C ..... ������ M (�؂�o����)
;	output:
;		HL .... �؂���ꂽ������ (BASIC�`��)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		�������͂���Ă��Ȃ���� "" ���Ԃ�
; =============================================================================
			scope	sub_mid
sub_mid::
			ld		a, [hl]
			cp		a, b
			jr		c, ret_blank			; �ʒu���E����͂ݏo���Ă�ꍇ�͋󕶎����Ԃ�
			or		a, a
			jr		z, ret_blank			; ���������󕶎��񂪎w�肳��Ă�ꍇ�͋󕶎����Ԃ�
			inc		c
			dec		c
			jr		z, ret_blank			; �������� �؂�o���� 0 ���w�肳��Ă�ꍇ�͋󕶎����Ԃ�

			; �؂�o���擪�ʒu�ֈړ�
			ld		e, b
			ld		d, 0
			add		hl, de					; HL = HL + (B - 1) + 1    : �����񒷂����� 1byte �̃t�B�[���h������̂� +1

			; �c��̕������ƁA������ M ���r����
			dec		b
			sub		a, b
			jr		z, ret_blank			; �c��̕������� 0 �Ȃ�󕶎����Ԃ�
			cp		a, c
			jr		nc, skip				; �c��̕������̕������Ȃ������ꍇ�́A���̂܂܁B���������ꍇ�́A�؂�o�������c��̕������ɒu��
			ld		c, a
	skip:
			ld		a, c
			ld		de, buf
			ld		[de], a
			or		a, a
			ret		z
			ld		b, 0
			inc		de
			ldir
			ld		hl, buf
			ret

	ret_blank:
			ld		hl, buf
			ld		[hl], 0
			ret
			endscope
