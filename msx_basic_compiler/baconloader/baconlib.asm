; =============================================================================
;	MSX-BACON Library
; -----------------------------------------------------------------------------
;	Copyright (C)2023 HRA!
; =============================================================================

rslreg		:= 0x0138
calbas		:= 0x0159
errhand		:= 0x406F					; BIOS �� BASIC�G���[�������[�`�� E �ɃG���[�R�[�h�B�߂��Ă��Ȃ��B
blibslot	:= 0xF3D3
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

			ld		a, 0xc0
			out		[c], a
			; ������̒������擾
			ld		a, [hl]
	_iot_set_device_path_loop1:
			ld		b, a
			cp		a, 64							; 64�����ȏ�̏ꍇ�͓��ʏ��������{����
			jr		c, _iot_set_device_path_skip
			sub		a, 63
			ld		b, 0x7f							; ���ʏ����������R�[�h
	_iot_set_device_path_skip:
			out		[c], b
			ld		d, a
			ld		a, b
			and		a, 0x3f
			ld		b, a
	_iot_set_device_path_loop2:
			inc		hl
			ld		a, [hl]
			out		[c], a
			djnz	_iot_set_device_path_loop2
			ld		a, d
			sub		a, 63
			jr		z, _iot_set_device_path_exit
			jr		nc, _iot_set_device_path_loop1
	_iot_set_device_path_exit:
			in		a, [c]
			rlca									; �G���[�Ȃ� cf = 1, ����Ȃ� cf = 0
			ret		nc
			; �G���[
			ld		e, error_device_IO
			ld		ix, errhand
			jp		calbas
			endscope

; =============================================================================
;	IOTGET (INTEGER)
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
;	IOTGET (STRING)
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
