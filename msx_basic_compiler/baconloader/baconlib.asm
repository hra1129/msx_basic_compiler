; =============================================================================
;	MSX-BACON Library
; -----------------------------------------------------------------------------
;	Copyright (C)2023 HRA!
; =============================================================================

vdpport0	:= 0x98
vdpport1	:= 0x99
vdpport2	:= 0x9A
vdpport3	:= 0x9B
calslt		:= 0x001C
romver		:= 0x002D
wrtvdp		:= 0x0047
setwrt		:= 0x0053
calpat		:= 0x0084
calatr		:= 0x0087
chget		:= 0x009F
rslreg		:= 0x0138
calbas		:= 0x0159
extrom		:= 0x015F
nstwrt		:= 0x0171
errhand		:= 0x406F					; BIOS �� BASIC�G���[�������[�`�� E �ɃG���[�R�[�h�B�߂��Ă��Ȃ��B
linl40		:= 0xF3AE
linl32		:= 0xF3AF
linlen		:= 0xF3B0
clmlst		:= 0xF3B2
txtnam		:= 0xf3b3
txtcol		:= 0xf3b5
txtcgp		:= 0xf3b7
txtatr		:= 0xf3b9
txtpat		:= 0xf3bb
t32nam		:= 0xf3bd
t32col		:= 0xf3bf
t32cgp		:= 0xf3c1
t32atr		:= 0xf3c3
t32pat		:= 0xf3c5
grpnam		:= 0xf3c7
grpcol		:= 0xf3c9
grpcgp		:= 0xf3cb
grpatr		:= 0xf3cd
grppat		:= 0xf3cf
mltnam		:= 0xf3d1
mltcol		:= 0xf3d3
mltcgp		:= 0xf3d5
mltatr		:= 0xf3d7
mltpat		:= 0xf3d9
blibslot	:= 0xF3D3
rg0sav		:= 0xF3DF
rg1sav		:= 0xF3E0
rg2sav		:= 0xF3E1
rg3sav		:= 0xF3E2
rg4sav		:= 0xF3E3
rg5sav		:= 0xF3E4
rg6sav		:= 0xF3E5
rg7sav		:= 0xF3E6
statfl		:= 0xF3E7
putpnt		:= 0xF3F8
getpnt		:= 0xF3FA
buf			:= 0xF55E
fnkstr		:= 0xF87F					; �t�@���N�V�����L�[�̕����� 16���� x 10��
dfpage		:= 0xFAF5
acpage		:= 0xFAF6
scrmod		:= 0xFCAF
oldscr		:= 0xFCB0
exptbl		:= 0xFCC1
rg8sav		:= 0xFFE7
rg9sav		:= 0xFFE8
rg10sav		:= 0xFFE9
rg11sav		:= 0xFFEA
rg12sav		:= 0xFFEB
rg13sav		:= 0xFFEC
rg14sav		:= 0xFFED
rg15sav		:= 0xFFEE
rg16sav		:= 0xFFEF
rg17sav		:= 0xFFF0
rg18sav		:= 0xFFF1
rg19sav		:= 0xFFF2
rg20sav		:= 0xFFF3
rg21sav		:= 0xFFF4
rg22sav		:= 0xFFF5
rg23sav		:= 0xFFF6
rg25sav		:= 0xFFFA
rg26sav		:= 0xFFFB
rg27sav		:= 0xFFFC

; SUB-ROM entry
chgmdp		:= 0x01B5

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
	blib_wrvdp:
			jp		sub_wrvdp
	blib_rdvdp:
			jp		sub_rdvdp
	blib_width:
			jp		sub_width
	blib_setscroll:
			jp		sub_setscroll
	blib_setsprite:
			jp		sub_setsprite
	blib_putsprite:
			jp		sub_putsprite

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

; =============================================================================
;	VDP( n ) = m
;	input:
;		A ..... VDP()���W�X�^�ԍ� n
;		B ..... �������ރf�[�^
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		n �́ABASIC �� VDP(n) �� n �ł���BV9938/9958 �� R#x, S#y �� x �� y ����Ȃ�
;		�̂Œ��ӂ��邱�ƁB
;		n ���A���݂��Ȃ��ԍ��̏ꍇ�A���������ɖ߂�B
; =============================================================================
			scope	sub_wrvdp
sub_wrvdp::
			cp		a, 8
			ret		z				; n = 8 �̏ꍇ�͉������Ȃ�
			ccf
			sbc		a, 0
			ld		c, a
			jp		wrtvdp
			endscope

; =============================================================================
;	m = VDP( n )
;	input:
;		A ..... VDP()���W�X�^�ԍ� n
;	output:
;		HL .... �ǂݏo�����f�[�^
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		n �́ABASIC �� VDP(n) �� n �ł���BV9938/9958 �� R#x, S#y �� x �� y ����Ȃ�
;		�̂Œ��ӂ��邱�ƁB
;		n ���A���݂��Ȃ��ԍ��̏ꍇ�AA �ɕs���Ԃ��B
; =============================================================================
			scope	sub_rdvdp
sub_rdvdp::
			or		a, a
			jp		m, _status_read
			cp		a, 25
			jr		nc, _vdp26_28
			cp		a, 8
			jr		z, _vdp8
			jr		c, _vdp0_7
	_vdp9_23:
			ld		hl, rg8sav - 9
			add		a, l
			ld		l, a
			ld		a, [hl]
			ld		l, a
			ld		h, 0
			ret
	_vdp26_28:
			ld		hl, rg25sav - 26
			add		a, l
			ld		l, a
			ld		a, [hl]
			ld		l, a
			ld		h, 0
			ret
	_vdp0_7:
			ld		hl, rg0sav
			add		a, l
			ld		l, a
			ld		a, [hl]
			ld		l, a
			ld		h, 0
			ret
	_vdp8:
			ld		a, [statfl]
			ld		l, a
			ld		h, 0
			ret
	_status_read:
			ld		c, vdpport0 + 1
			neg
			di
			; R#15 = A
			out		[c], a
			ld		a, 15 | 0x80
			out		[c], a
			; B = S#n
			in		b, [c]
			; R#15 = rg15sav
			ld		a, [rg15sav]
			out		[c], a
			ld		a, 15 | 0x80
			out		[c], a
			ei
			ld		l, b
			ld		h, 0
			ret
			endscope

; =============================================================================
;	WIDTH n
;	input:
;		L ..... �ݒ肷�镝 n
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;
; =============================================================================
			scope	sub_width
sub_width::
			; ���ɕύX�����邩���ׂ�
			ld		a, [linlen]
			cp		a, l
			ret		z					; �ύX��������Ή������Ȃ�
			; MSX1���H
			ld		a, [romver]
			or		a, a
			jr		nz, _skip0
			; ��40�܂�
			ld		a, l
			or		a, a
			jp		z, err_illegal_function_call
			cp		a, 41
			jp		nc, err_illegal_function_call
		_skip0:
			; ��ʃ��[�h�𒲂ׂ�
			ld		a, [oldscr]
			or		a, a
			ld		a, l
			jr		z, _skip1
			; SCREEN0 �łȂ���� ��32�܂�
			cp		a, 33
			jp		nc, err_illegal_function_call
		_skip1:
			; SCREEN0 �Ȃ� ��80�܂�
			cp		a, 81
			jp		nc, err_illegal_function_call
		_skip2:
			; ��ʃN���A
			ld		a, 0x0C
			rst		0x18
			; ���X�V
			ld		a, l
			ld		[linlen], a
			call	update_clmlst
			; ��ʃ��[�h�`�F�b�N
			ld		a, [oldscr]
			dec		a
			ld		a, l
			jr		nz, _skip3
			; SCREEN1 �̏ꍇ
			ld		[linl32], a
			; ��ʃN���A
			ld		a, 0x0C
			rst		0x18
			ret
		_skip3:
			; SCREEN0 �̏ꍇ
			ld		a, [linl40]
			ld		h, 41
			cp		a, h
			ld		a, l
			ld		[linl40], a
			; ��ʃN���A
			ld		a, 0x0C
			rst		0x18
			ld		a, l
			jr		c, _skip4
			cp		a, h
			ret		nc
			ld		h, a
		_skip4:
			cp		a, h
			ret		c
			; CHGMDP �� SCREEN0 �̃��[�h�Z�b�g
			xor		a, a
			ld		ix, chgmdp
			jp		extrom

			; clmlst �X�V
		update_clmlst:
			sub		a, 14
			jr		nc, update_clmlst
			add		a, 0x1C
			neg
			add		a, l
			ld		[clmlst], a
			ret
			endscope

; =============================================================================
;	SET SCROLL X, Y, MaskMode, PageMode
;	input:
;		HL ...	X�ʒu (0�`511)
;		E ....	Y�ʒu (0�`255)
;		D ....	MaskMode
;		B ....	PageMode
;		A ....	bit0: X�ʒu �L��1, ����0
;				bit1: Y�ʒu �L��1, ����0
;				bit2: MaskMode �L��1, ����0
;				bit3: PageMode �L��1, ����0
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;
; =============================================================================
			scope	sub_setscroll
sub_setscroll::
			ld		c, a
			; �����X�N���[���ʒu R#23
			and		a, 0x02
			ld		[buf+0], a
			ld		a, e
			ld		[buf+1], a
			; �����X�N���[���ʒu R#26, R#27
			ld		a, c
			and		a, 0x01
			ld		[buf+2], a
			ld		[buf+3], hl
			; �}�X�N���[�h
			ld		a, c
			and		a, 0x04
			ld		[buf+5], a
			ld		a, d
			ld		[buf+6], a
			; �y�[�W���[�h
			ld		a, c
			and		a, 0x08
			ld		[buf+7], a
			ld		a, b
			ld		[buf+8], a
			; �����X�N���[���ʒu R#23
			ld		a, [buf+0]
			or		a, a
			jr		z, _skip_r23
			ld		a, [buf+1]
			ld		c, 23
			ld		b, a
			call	wrtvdp
		_skip_r23:
			; �����X�N���[���ʒu R#26, R#27
			ld		a, [buf+2]
			or		a, a
			jr		z, _skip_r26
			ld		hl, [buf+3]
			ld		a, l
			and		a, 7
			xor		a, 7
			ld		b, a
			ld		c, 27
			call	wrtvdp
			ld		a, l
			and		a, 0xF8
			ld		l, a
			rr		h
			rr		l
			rr		h
			rr		l
			rr		h
			rr		l
			ld		b, l
			ld		c, 26
			call	wrtvdp
		_skip_r26:
			; �}�X�N���[�h�A�y�[�W���[�h R#25
			ld		a, [buf+5]
			ld		c, a
			ld		a, [buf+7]
			or		a, c
			ret		z						; �}�X�N���y�[�W���w�薳���Ȃ牽�����Ȃ�
			; R#25 �̌��݂̒l��ێ�
			ld		a, [rg25sav]
			ld		b, a
			and		a, 0xFC
			ld		c, a					; C = XXXX_XX00
			ld		a, b
			and		a, 0x03
			ld		b, a					; B = 0000_00XX
			; �}�X�N���[�h�̍X�V
			ld		a, [buf+5]
			or		a, a
			jr		z, _skip_r25_mask		; �}�X�N�̎w�肪�ȗ��Ȃ�X���[
			ld		a, b
			and		a, 0b1111_1101
			ld		b, a
			ld		a, [buf+6]
			or		a, a
			jr		z, _skip_r25_mask
			inc		b
			inc		b
		_skip_r25_mask:
			; �y�[�W���[�h
			ld		a, [buf+7]
			or		a, a
			jr		z, _skip_r25_page		; �y�[�W�̎w�肪�ȗ��Ȃ�X���[
			ld		a, b
			and		a, 0b1111_1110
			ld		b, a
			ld		a, [buf+8]
			or		a, a
			jr		z, _skip_r25_page
			inc		b
		_skip_r25_page:
			ld		a, c
			or		a, b
			ld		b, a
			ld		c, 25
			jp		wrtvdp
			endscope

; =============================================================================
;	SPRITE$(E)=HL
;	input:
;		E ..... �X�v���C�g�ԍ�
;		HL .... �Z�b�g���镶���� (BASIC�`��)
;	output:
;		HL .... �X�v���C�g�W�F�l���[�^�[�e�[�u���̃A�h���X
;	break:
;		all
;	comment:
;		set page �ŕ`��y�[�W�Ɏw�肳��Ă�����i�܂菑�����ݑΏۂ̕��j��
;		�A�h���X��Ԃ��B
;		�����񂪒Z���ꍇ�A����Ȃ����� 00h ���l�߂���B
; =============================================================================
			scope	sub_setsprite
sub_setsprite::
			ld		a, [scrmod]
			dec		a
			cp		a, 12
			jp		nc, err_syntax
			ld		a, e
			push	hl
			call	calpat

			; VRAM�A�h���X��ݒ�
			ld		a, [romver]
			or		a, a
			jr		z, _skip0
			call	nstwrt
			jr		_skip1
		_skip0:
			call	setwrt
		_skip1:

			; 1�X�v���C�g�̃T�C�Y�́A8x8 �Ȃ� 8byte, 16x16 �Ȃ� 32byte
			ld		a, [rg1sav]			; 0bXXXX_XXSX : Sprite Size S:0=8x8, 1=16x16
			rlca
			rlca
			rlca
			rlca
			and		a, 32
			jr		nz, _skip2
			ld		a, 8
		_skip2:
			ld		b, a

			; ������𗬂�����
			pop		hl
			ld		c, [hl]				; ������
			inc		c
			dec		c
			jr		z, _skip3
		_loop1:
			inc		hl
			ld		a, [hl]
			out		[vdpport0], a
			dec		b
			ret		z
			dec		c
			jr		nz, _loop1
		_skip3:
			xor		a, a
		_loop2:
			out		[vdpport0], a
			dec		b
			jr		nz, _loop2
			ret
			endscope

; =============================================================================
;	PUT SPRITE A,(B,C),D,E
;	input:
;		A ..... �X�v���C�g�ԍ�
;		B ..... X���W
;		C ..... Y���W
;		D ..... �F
;		E ..... �p�^�[���ԍ�
;		L ..... �p�����[�^�L���t���O (0:����, 1:�L��)
;		        bit0: ���W
;		        bit1: �p�^�[���ԍ�
;		        bit2: �F
;	output:
;		none
;	break:
;		all
;	comment:
;		�X�v���C�g���[�h2�ł���΁ACC�r�b�g�������Ă���X�v���C�g���ꏏ�ɓ�����
; =============================================================================
			scope	sub_putsprite
sub_putsprite::
			ld		h, a
			ld		a, [scrmod]
			dec		a
			cp		a, 12
			jp		nc, err_syntax
			cp		a, 3
			jr		nc, _sprite_mode2
	_sprite_mode1:
			; �X�v���C�g�A�g���r���[�g�����߂�
			ld		a, h
			push	de					; �p�^�[���ƐF�ۑ�
			push	hl					; �t���O�ۑ�
			call	calatr
			pop		de					; �t���O���A
			ld		a, e
			; ���W�w��
			rrca
			di
			jr		nc, _skip_pos1
			ld		e, a
			ld		a, l
			out		[vdpport1], a
			ld		a, h
			or		a, 0x40
			out		[vdpport1], a
			ld		a, c
			out		[vdpport0], a		; Y���W
			ld		a, b
			out		[vdpport0], a		; X���W
			ld		a, e
	_skip_pos1:
			inc		hl
			inc		hl
			; �p�^�[��
			pop		bc
			rrca
			jr		nc, _skip_pat1

			ld		e, a
			ld		a, l
			out		[vdpport1], a
			ld		a, h
			or		a, 0x40
			out		[vdpport1], a
			ld		a, [rg1sav]			; 0bXXXX_XXSX : Sprite Size S:0=8x8, 1=16x16
			and		a, 0b0000_0010
			ld		a, c
			jr		z, _skip_pat1_0
			add		a, a				; 16x16 �̏ꍇ�́A4�{����
			add		a, a
	_skip_pat1_0:
			out		[vdpport0], a		; �p�^�[��
			ld		a, e
	_skip_pat1:
			inc		hl
			; �F
			rrca
			jr		nc, _skip_col1
			ld		a, l
			out		[vdpport1], a
			ld		a, h
			or		a, 0x40
			out		[vdpport1], a
			ld		a, b
			out		[vdpport0], a		; �F
	_skip_col1:
			ei
			ret
	_sprite_mode2:
			ret
			endscope

; =============================================================================
			scope	error_handler
err_syntax::
			ld		e, 2
err_illegal_function_call	:= $+1
			ld		bc, 0x051E
			ld		iy, [exptbl - 1]		; MAIN-ROM SLOT
			ld		ix, 0x406F				; ERRHNDR
			jp		calslt
			endscope
