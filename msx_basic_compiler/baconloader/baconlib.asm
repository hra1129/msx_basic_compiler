; =============================================================================
;	MSX-BACON Library
; -----------------------------------------------------------------------------
;	Copyright (C)2023 HRA!
; =============================================================================

_dosver		:= 0x6F
vdpport0	:= 0x98
vdpport1	:= 0x99
vdpport2	:= 0x9A
vdpport3	:= 0x9B
calslt		:= 0x001C
enaslt		:= 0x0024
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
fout		:= 0x3425
pufout		:= 0x3426
errhand		:= 0x406F					; BIOS �� BASIC�G���[�������[�`�� E �ɃG���[�R�[�h�B�߂��Ă��Ȃ��B
ramad1		:= 0xF342
bdos		:= 0xf37d
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
cliksw		:= 0xF3DB
csry		:= 0xF3DC
csrx		:= 0xF3DD
cnsdfg		:= 0xF3DE
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
valtyp		:= 0xF663
parm2		:= 0xF750
dectm2		:= 0xF7F2
deccnt		:= 0xF7F4
dac			:= 0xF7F6
fnkstr		:= 0xF87F					; �t�@���N�V�����L�[�̕����� 16���� x 10��
dfpage		:= 0xFAF5
acpage		:= 0xFAF6
linwrk		:= 0xFC18
scrmod		:= 0xFCAF
oldscr		:= 0xFCB0
mainrom		:= 0xFCC1
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

; BDOS function call
_TERM0		:= 0x00
_CONIN		:= 0x01
_CONOUT		:= 0x02
_AUXIN		:= 0x03
_AUXOUT		:= 0x04
_LSTOUT		:= 0x05
_DIRIO		:= 0x06
_DIRIN		:= 0x07
_INNOE		:= 0x08
_STROUT		:= 0x09
_BUFIN		:= 0x0A
_CONST		:= 0x0B
_CPMVER		:= 0x0C
_DSKRST		:= 0x0D
_SELDSK		:= 0x0E
_FOPEN		:= 0x0F
_FCLOSE		:= 0x10
_SFIRST		:= 0x11
_SNEXT		:= 0x12
_FDEL		:= 0x13
_RDSEQ		:= 0x14
_WRSEQ		:= 0x15
_FMAKE		:= 0x16
_FREN		:= 0x17
_LOGIN		:= 0x18
_CURDRV		:= 0x19
_SETDTA		:= 0x1A
_ALLOC		:= 0x1B
_RDRND		:= 0x21
_WRRND		:= 0x22
_FSIZE		:= 0x23
_SETRND		:= 0x24
_WRBLK		:= 0x26
_RDBLK		:= 0x27
_WRSER		:= 0x28
_GDATE		:= 0x2A
_SDATE		:= 0x2B
_GTIME		:= 0x2C
_STIME		:= 0x2D
_VERIFY		:= 0x2E
_RDABS		:= 0x2F
_WRABS		:= 0x30
_DPARM		:= 0x31
_FFIRST		:= 0x40
_FNEXT		:= 0x41
_FNEW		:= 0x42

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
	blib_tab:
			jp		sub_tab
	blib_using:
			jp		sub_using
	blib_init_ncalbas:
			jp		sub_init_ncalbas
	blib_instr:
			jp		sub_instr
	blib_bload:
			jp		sub_bload
	blib_bload_s:
			jp		sub_bload_s
	blib_setup_fcb:
			jp		sub_setup_fcb
	blib_fopen:
			jp		sub_fopen
	blib_fcreate:
			jp		sub_fcreate
	blib_fclose:
			jp		sub_fclose
	blib_fread:
			jp		sub_fread
	blib_fwrite:
			jp		sub_fwrite
	blib_mid_cmd:
			jp		sub_mid_cmd

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

ncalbas_trans::
			org		parm2
			scope	ncalbas
ncalbas::
			push	af
			push	bc
			push	de
			push	hl
ncalbas_mainrom := $+1
			ld		a, 0
			ld		h, 0x40
			call	enaslt
			pop		hl
			pop		de
			pop		bc
			pop		af

ncalbas_address	:= $+1
			call	0

			push	af
			push	bc
			push	de
			push	hl
ncalbas_blibslot := $+1
			ld		a, 0
			ld		h, 0x40
			call	enaslt
			pop		hl
			pop		de
			pop		bc
			pop		af
			ei
			ret
ncalbas_end::
			endscope
			org		ncalbas_trans + (ncalbas_end - ncalbas)

; =============================================================================
;	INITIALIZE NCALBAS
;	input:
;		none
;	output:
;		A ... DOS�o�[�W����, 0: DOS����, 1: DOS1, 2: DOS2
;	break:
;		all
; =============================================================================
			scope	sub_init_ncalbas
sub_init_ncalbas::
			ld		hl, ncalbas_trans
			ld		de, ncalbas
			ld		bc, ncalbas_end - ncalbas
			ldir
			ld		a, [mainrom]
			ld		[ncalbas_mainrom], a
			ld		a, [blibslot]
			ld		[ncalbas_blibslot], a
			; DOS�o�[�W�����𒲂ׂ�
			ld		c, _dosver
			call	bdos
			or		a, a						; �G���[���� (DOS1�ł�DOS2�ł��Ȃ�) ���H
			jr		z, _s1
			xor		a, a						; DOS�������ꍇ�́AA=0
			jr		_dosver_exit
		_s1:
			ld		a, b
			or		a, a
			jr		nz, _dosver_exit
			inc		a
		_dosver_exit:
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
			ld		a, 0x41
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
			ld		a, 0x43
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
			ld		h, a				; H = �X�v���C�g�ԍ�
			ld		a, [scrmod]
			dec		a
			cp		a, 12
			jp		nc, err_syntax
			cp		a, 3
			jr		nc, _sprite_mode2
	_sprite_mode1:
			; �X�v���C�g�A�g���r���[�g�����߂�
			ld		a, h				; A = �X�v���C�g�ԍ�
			push	de					; �p�^�[���ƐF�ۑ�
			push	hl					; �t���O�ۑ�
			call	calatr
			pop		de					; �t���O���A
			ld		a, e				; A = �t���O
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
			; �X�v���C�g�A�g���r���[�g�����߂�
			ld		a, h
			ld		[buf + 0], a
			push	de					; �p�^�[���ƐF�ۑ�
			push	hl					; �t���O�ۑ�
			call	calatr
			pop		de					; �t���O���A
			ld		a, e				; A = �t���O
			; ���W�w��
			rrca
			jr		nc, _skip_pos2
			ld		e, a
			call	nstwrt
			ld		a, c
			out		[vdpport0], a		; Y���W
			ld		a, b
			out		[vdpport0], a		; X���W
			ld		a, e
	_skip_pos2:
			inc		hl
			inc		hl
			; �p�^�[��
			pop		bc
			rrca
			jr		nc, _skip_pat2

			ld		e, a
			call	nstwrt
			ld		a, [rg1sav]			; 0bXXXX_XXSX : Sprite Size S:0=8x8, 1=16x16
			and		a, 0b0000_0010
			ld		a, c
			jr		z, _skip_pat2_0
			add		a, a				; 16x16 �̏ꍇ�́A4�{����
			add		a, a
	_skip_pat2_0:
			out		[vdpport0], a		; �p�^�[��
			ld		a, e
	_skip_pat2:
			; �F
			rrca
			jr		nc, _skip_col2
			; �J���[�e�[�u��( 4[byte] * 32[plane] = 128[byte] )�̃A�h���X�����߂�
			;	             Attribute   Color
			;	SCREEN 4   : 1E00h-1E7Fh 1C00h-1DFFh
			;	SCREEN 5,6 : 7600h-767Fh 7400h-75FFh
			;	SCREEN 7-12: FA00h-FA7Fh F800h-F9FFh
			ld		a, h
			and		a, 0xFC
			rrca
			ld		h, a
			ld		a, l
			and		a, 0x7C
			add		a, a
			add		a, a
			ld		l, a
			rl		h
			call	nstwrt
			ld		a, b
			ld		b, 16
	_loop1:
			out		[vdpport0], a		; �F
			djnz	_loop1
	_skip_col2:
			ret
			endscope

; =============================================================================
;	PRINT TAB(A)
;	input:
;		A ..... TAB() �̈���
;	output:
;		none
;	break:
;		all
;	comment:
;		���ʒu�� A �ɂȂ�܂ŃX�y�[�X���o��
; =============================================================================
			scope	sub_tab
sub_tab::
			ld		e, a
			ld		a, [csrx]
			dec		a						; csrx �� +1 �̈ʒu�Ȃ̂� 0��ɖ߂�
	_loop:
			cp		a, e					; CP ���݂̌��ʒu, �ڕW���ʒu
			ret		nc
			ld		c, a
			ld		a, ' '
			rst		0x18
			ld		a, c
			inc		a
			jr		_loop
			endscope

; =============================================================================
;	PRINT USING <buf>
;	input:
;		none
;	output:
;		none
;	break:
;		all
;	comment:
;		BUF �ɏ���������̃A�h���X, BUF+2�ȍ~�Ƀp�����[�^���i�[���ČĂ�
; =============================================================================
			scope	sub_using
sub_using::
			; ����������̒����ƃA�h���X�𓾂�
			ld		hl, [buf]
			ld		a, [hl]
			or		a, a
			jp		z, err_illegal_function_call		; ���������񂪒��� 0 �Ȃ� Illegal function call
			inc		hl
			ld		b, a
			; �����̃A�h���X
			ld		de, buf+2
			; 1�������ď������������ׂ�
			; �����̊J�n�����́A!(21) #(23) &(26) *(2A) +(2B) .(2E) @(40) \(5C)
	main_loop:
			; HL = ����, DE = ����
			call	get_one
			cp		a, ','						; 0x2C
			jr		z, no_format
			jr		nc, search_r

			;		[0x00:0x2B]: !(21) #(23) &(26) *(2A) +(2B)
		search_l:
			cp		a, '&'						; 0x26
			jp		z, string_column_format
			jr		nc, search_lr

			;		[0x00:0x25]: !(21) #(23)
		search_ll:
			cp		a, '#'
			jr		z, number_format
			cp		a, '!'
			jp		z, char_format
			jr		no_format

			;		[0x27:0x2B]: *(2A) +(2B)
		search_lr:
			cp		a, '*'
			jr		nc, number_format
			jr		no_format

			;		[0x2D:0xFF]: .(2E) @(40) \(5C)
		search_r:
			cp		a, '.'
			jr		z, number_format
			cp		a, '\\'
			jp		z, detect_yenyen
			cp		a, '@'
			jp		z, string_format

			; -----------------------------------------------------------------
			; �����ł͂Ȃ�����
	no_format:
			rst		0x18
			jr		main_loop

			; -----------------------------------------------------------------
			; ���l�̏���
			; #(23) *(2A) +(2B) -(2D) .(2E) \(5C)
	number_format:
			; pufout �֓n���t�H�[�}�b�g����������
			ld		c, a
			ld		a, 0b1000_0000
			ld		[deccnt], a
			xor		a, a
			ld		[dectm2], a
			ld		[dectm2 + 1], a
			ld		a, c

			cp		a, '*'
			jr		z, number_format_asterisk
			cp		a, '+'
			jp		z, detect_pre_flag_plus
			dec		hl
			inc		b
			jp		detect_sharp

			; *(2A): *### **###
	number_format_asterisk:
			inc		b
			dec		b
			jr		z, no_format				; * �ŏI����Ă�ꍇ�͒P�Ƃ� * ����

			ld		a, [hl]
			cp		a, '*'
			ld		a, '*'
			jr		nz, no_format				; NZ �Ȃ� * �� 1�����Ȃ̂ŏ����ł͂Ȃ�

			ld		a, 2
			ld		[dectm2 + 1], a				; ������ 2������J�n
			xor		a, a
			ld		[dectm2], a					; ������ 0��
			ld		a, 0b1010_0000				; * �l�ߎw��
			ld		[deccnt], a
			inc		hl							; 2�ڂ� * �̕�
			dec		b
			jr		nz, detect_yen

			; -----------------------------------------------------------------
			; �����̐��l�� DAC �փR�s�[���� pufout ���Ă�
	put_number:
			ex		de, hl						; DE = ����, HL = ����
			ld		a, [hl]						; A = �����̌^
			or		a, a
			ret		z							; �������Ȃ��̂ŏI��
			cp		a, 3
			jp		z, err_type_mismatch		; �t���O�s��: ������Ȃ�G���[
			ld		[valtyp], a					; �t���O�s��: 2:����, 4:�P���x, 8:�{���x�̂����ꂩ
			push	de							; �t���O�s��: �����̎Q�ƈʒu��ۑ�
			push	bc							; �t���O�s��: �T�C�Y����ۑ�
			inc		hl							; �t���O�s��
			; �u���b�N�]��
			ld		de, dac						; �t���O�s��
			jr		nc, pufout_skip				; �����̏ꍇ Cy=1, �P���x�E�{���x�̏ꍇ Cy=0
			inc		e							; DAC=F7F6h �Ȃ̂� E �ɂ��� 2 �����Ώ[��
			inc		e
		pufout_skip:
			ld		c, a
			ld		b, 0
			ldir
			push	hl							; �����̎Q�ƈʒu��ۑ�
			; pufout �Ăяo��
			ld		a, [deccnt]
			ld		bc, [dectm2]
			ld		hl, pufout
			ld		[ncalbas_address], hl
			call	ncalbas
	pufout_loop:
			ld		a, [hl]
			or		a, a
			jr		z, pufout_loop_exit
			rst		0x18
			inc		hl
			jr		pufout_loop
	pufout_loop_exit:
			pop		de							; �����̎Q�ƈʒu�𕜋A
			pop		bc							; �T�C�Y���𕜋A
			pop		hl							; �����̎Q�ƈʒu�𕜋A
			jp		main_loop

			; -----------------------------------------------------------------
			; �ʉ݋L�� �� (**�� �́�)
	detect_yen:
			ld		a, [hl]
			cp		a, 0x5C
			jr		nz, detect_sharp				; �� ��������� **###�A����� **��###

			inc		hl
			dec		b
			ld		a, 3
			ld		[dectm2 + 1], a				; ������ 3������J�n
			ld		a, 0b1011_0000				; * �l�ߎw��, �� �l�ߎw��
			ld		[deccnt], a
			jr		detect_sharp

			; -----------------------------------------------------------------
			; �ʉ݋L�� ����
	detect_yenyen:
			inc		b
			dec		b
			jp		z, no_format				; �� �ŏI����Ă�ꍇ�͒P�Ƃ� �� ����

			ld		a, [hl]
			cp		a, 0x5C
			ld		a, 0x5C
			jp		z, no_format				; �� �� 1�����Ȃ̂ŏ����ł͂Ȃ�

			ld		a, 2
			ld		[dectm2 + 1], a				; ������ 2������J�n
			xor		a, a
			ld		[dectm2], a					; ������ 0��
			ld		a, 0b1001_0000				; �� �l�ߎw��
			ld		[deccnt], a
			inc		hl							; 2�ڂ� �� �̕�
			dec		b

			; -----------------------------------------------------------------
			; ���l�L�� #
	detect_sharp:
			ld		a, [dectm2 + 1]				; �������̌����ǉ����𐔂���
			ld		c, a
			xor		a, a						; '.' �ł͂Ȃ��l�ɂ���
			inc		b
			dec		b
			jr		z, put_number				; ���������񂪂����ŏI����Ă���Ό����o�X�L�b�v
			; �������̌������o
	detect_sharp_loop:
			ld		a, [hl]
			cp		a, '#'
			jr		nz, detect_sharp_exit
			inc		hl
			inc		c
			djnz	detect_sharp_loop
	detect_sharp_exit:
			cp		a, '.'
			ld		a, c
			ld		[dectm2 + 1], a
			jr		nz, detect_sharp_exit_all	; '.' ��������Ώ������͑��݂��Ȃ��̂ŃX�L�b�v
			ld		a, 1						; �����_�̕��� 1
			ld		[dectm2], a
			inc		hl
			dec		b
			jp		z, put_number				; �������I����Ă���΂����Ō��o�����܂�
			; �������̌������o
			ld		c, a
	detect_sharp_loop_2nd:
			ld		a, [hl]
			cp		a, '#'
			jr		nz, detect_sharp_exit_2nd
			inc		hl
			inc		c
			djnz	detect_sharp_loop_2nd
	detect_sharp_exit_2nd:
			ld		a, c
			ld		[dectm2], a
			inc		b
			dec		b
			jp		z, put_number				; �������I����Ă���΂����Ō��o�����܂�
	detect_sharp_exit_all:

			; -----------------------------------------------------------------
			; �w���� ^^^^
			push	bc
			push	hl
			ld		a, [hl]
			cp		a, '^'
			jr		nz, detect_post_flag
			dec		b
			jr		z, detect_post_flag
			inc		hl

			ld		a, [hl]
			cp		a, '^'
			jr		nz, detect_post_flag
			dec		b
			jr		z, detect_post_flag
			inc		hl

			ld		a, [hl]
			cp		a, '^'
			jr		nz, detect_post_flag
			dec		b
			jr		z, detect_post_flag
			inc		hl

			ld		a, [hl]
			cp		a, '^'
			jr		nz, detect_post_flag
			dec		b
			inc		hl

			ld		a, [deccnt]
			inc		a							; �w���\���w��
			ld		[deccnt], a

			pop		af
			pop		af
			jr		detect_post_flag_skip_pop
	detect_post_flag:
			pop		hl
			pop		bc

			; -----------------------------------------------------------------
			; ��u���� +, -
	detect_post_flag_skip_pop:
			inc		b
			dec		b
			jp		z, put_number

			ld		a, [deccnt]
			and		a, 0b0000_1000				; ���̏ꍇ�������t����t���O���t���Ă�΁A�O�u�t���O�����݂��Ă�̂ŁA��u�͂����̋L���B
			jp		nz, put_number

			ld		a, [hl]
			cp		a, '+'
			jr		nz, detect_post_flag_minus

			ld		a, [deccnt]
			or		a, 0b0000_1100				; ���̏ꍇ�������t����t���O�A���ɕ�����t����t���O
			jr		detect_post_flag_exit

	detect_post_flag_minus:
			cp		a, '-'
			jp		nz, put_number

			ld		a, [deccnt]
			or		a, 0b0000_0100				; ���ɕ�����t����t���O
	detect_post_flag_exit:
			ld		[deccnt], a
			inc		hl
			dec		b
			jp		put_number

			; -----------------------------------------------------------------
			; �O�u���� +
	detect_pre_flag_plus:
			ld		a, [deccnt]
			or		a, 0b0000_1000				; ���̏ꍇ�������t����t���O
			ld		[deccnt], a
			ld		a, 1
			ld		[dectm2+1], a
			jp		detect_sharp

			; -----------------------------------------------------------------
			; ������̏��� @
	string_format:
			ex		de, hl					; HL = ����, DE = ����
			ld		a, [hl]
			or		a, a
			ret		z						; �����^�� 0 �Ȃ�I���
			cp		a, 3					; �����^�� 3 �łȂ���� Type mismatch
			jp		nz, err_type_mismatch
			push	de						; �����̃A�h���X��ۑ�
			push	bc
			inc		hl
			ld		e, [hl]
			inc		hl
			ld		d, [hl]					; DE = @ �ɂ͂ߍ��ޕ�����̃A�h���X
			inc		hl
			ex		de, hl					; HL = �͂ߍ��ޕ�����, DE = ����
			ld		b, [hl]					; B = �͂ߍ��ޕ�����̕�����
			inc		hl

			inc		b
			jr		string_loop_1st
	string_loop:
			ld		a, [hl]
			inc		hl
			rst		0x18
	string_loop_1st:
			djnz	string_loop
			pop		bc
			pop		hl						; �����̃A�h���X�𕜋A
			jp		main_loop

			; -----------------------------------------------------------------
			; �������t��������̏��� &&
	string_column_format:
			; �ŏ��� & �������̍Ō�̏ꍇ�A�P�Ȃ�L���Ƃ��ď���
			inc		b
			dec		b
			jp		z, no_format
			; 2�ڂ� & �����݂��邩�`�F�b�N����
			ld		c, b
			push	hl						; �����̌��݈ʒu��ۑ�
	string_column_check:
			ld		a, [hl]
			cp		a, '&'
			jr		z, string_column_found
			cp		a, ' '
			jr		nz, string_column_not_found
			inc		hl
			djnz	string_column_check
	string_column_not_found:
			ld		b, c
			pop		hl						; �����̌��݈ʒu�𕜋A
			ld		a, '&'
			jp		no_format
	string_column_found:
			; �����������񂩒��ׂ�
			ex		de, hl					; HL = ����
			ld		a, [hl]
			or		a, a
			ret		z						; �����^�� 0 �Ȃ�I���
			cp		a, 3					; �����^�� 3 �łȂ���� Type mismatch
			jp		nz, err_type_mismatch

			inc		hl
			ld		e, [hl]
			inc		hl
			ld		d, [hl]					; DE = && �ɂ͂ߍ��ޕ�����̃A�h���X
			inc		hl
			ex		[sp], hl				; HL = ����, �X�^�b�N = ����

			ld		a, [de]					; && �ɂ͂ߍ��ޕ�����̒���
			inc		de
			or		a, a					; && �ɂ͂ߍ��ޕ����� "" �Ȃ�A�ŏ�����X�y�[�X�}��
			ld		b, a
			jr		nz, replace_first
			; && �ɂ͂ߍ��ޕ����� "" �̏ꍇ
			ld		a, ' '
			inc		b
			jr		replace_first_is_space

	replace_first:
			; �ŏ��� & �̕��̏o��
			ld		a, [de]					; && �ɂ͂ߍ��ޕ���
			inc		de
	replace_first_is_space:
			rst		0x18					; 1�����o��
			dec		b						; && �ɂ͂ߍ��ޕ������ 1��������
			jr		z, insert_space

	replace_loop:
			ld		a, [de]					; && �ɂ͂ߍ��ޕ���
			inc		de
			rst		0x18					; 1�����o��

			ld		a, [hl]					; ������̕���
			inc		hl
			dec		c						; ����������� 1��������
			cp		a, '&'
			jp		z, string_column_exit

			djnz	replace_loop			; && �ɂ͂ߍ��ޕ������Ȃ��Ȃ�܂ŌJ��Ԃ�

	insert_space:
			ld		a, ' '					; && �ɂ͂ߍ��ޕ���
			rst		0x18					; 1�����o��

			ld		a, [hl]					; ������̕���
			inc		hl
			dec		c						; ����������� 1��������
			cp		a, '&'
			jp		nz, insert_space

	string_column_exit:
			pop		de
			ld		b, c
			jp		main_loop

			; -----------------------------------------------------------------
			; �����̏��� !
	char_format:
			ex		de, hl					; HL = ����, DE = ����
			ld		a, [hl]
			or		a, a
			ret		z						; �����^�� 0 �Ȃ�I���
			cp		a, 3					; �����^�� 3 �łȂ���� Type mismatch
			jp		nz, err_type_mismatch

			push	de						; �����̃A�h���X��ۑ�
			inc		hl
			ld		e, [hl]
			inc		hl
			ld		d, [hl]					; DE = @ �ɂ͂ߍ��ޕ�����̃A�h���X
			inc		hl
			ex		de, hl					; HL = �͂ߍ��ޕ�����, DE = ����
			ld		a, [hl]					; A = �͂ߍ��ޕ�����̕�����
			inc		hl

			or		a, a
			ld		a, ' '					; ���� 0 �̕����񂾂����ꍇ�́A' ' ���w�肵�����Ƃɂ���
			jr		z, blank_string
			ld		a, [hl]
	blank_string:
			rst		0x18
			pop		hl						; �����̃A�h���X�𕜋A
			jp		main_loop

			; -----------------------------------------------------------------
			; ���������񂩂� 1��������
	get_one:
			inc		b
			dec		b
			jr		nz, get_one_normal
			; �����������S�ď��������ꍇ�A�܂��������c���Ă��邩�`�F�b�N
			ld		a, [de]
			or		a, a
			jr		nz, go_next
			pop		hl
			ret
	go_next:
			ld		hl, [buf]
			ld		b, [hl]
			inc		hl
	get_one_normal:
			ld		a, [hl]
			dec		b
			inc		hl
			ret
			endscope

; =============================================================================
;	INSTR( DE, HL )
;	input:
;		DE ... ���ƂȂ镶����
;		HL ... ���ƂȂ镶����̒�����T��������
;	output:
;		HL ... �������ʒu
;	break:
;		all
;	comment:
;		�擪�� 1�A������Ȃ������ꍇ�� 0
; =============================================================================
			scope	sub_instr
sub_instr::
			ld		a, [de]
			ld		b, [hl]
			sub		a, b					; A = �擪����T�����镶����
			jr		c, _not_found			; �T��������̕���������΁A��v����͂����Ȃ�
			ld		c, 1					; ���݂̈ʒu
			inc		b
			dec		b
			jr		z, _match_wo_pop
			inc		a
			ld		b, a					; �c��T���ʒu
			inc		de						; �擪�̕����ʒu (���̕�����)

	_search_loop:
			push	hl
			push	de
			push	bc
			; ���ڈʒu�ɂ����镶����̈�v�m�F
			ld		b, [hl]					; ������
			inc		hl						; �擪�̕����ʒu (�T��������)
	_compare:
			ld		a, [de]
			cp		a, [hl]
			jr		nz, _no_match
			inc		de
			inc		hl
			djnz	_compare
	_match:
			pop		hl						; �X�^�b�N�̂�
			pop		hl						; �X�^�b�N�̂�
			pop		hl						; �X�^�b�N�̂�
	_match_wo_pop:
			ld		l, c
			ld		h, 0
			ret

			; ��v���Ȃ������ꍇ
	_no_match:
			pop		bc
			pop		de
			pop		hl
			inc		de						; ���̈ʒu�֑J��
			inc		c						; ���̈ʒu�֑J��
			djnz	_search_loop

			; ��v����ꏊ�������������
	_not_found:
			ld		hl, 0					; 0 ��Ԃ�
			ret
			endscope

; =============================================================================
;	�V����FCB�𐶐�����
;	input:
;		HL ... �t�@�C����
;		DE ... FCB�p�̃������̃A�h���X (37bytes)
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_setup_fcb
sub_setup_fcb::
			; ���g���N���A����
			push	hl
			push	de
			ld		l, e
			ld		h, d
			inc		de
			ld		bc, 36
			ld		[hl], 0
			ldir
			; �J�����g�h���C�u�擾
			ld		c, _CURDRV
			call	bdos
			inc		a
			pop		de
			pop		hl
			ld		[de], a
			; �h���C�u���̑��݃`�F�b�N
			ld		a, [hl]
			inc		hl
			ld		c, a				; C = ����
			cp		a, 3
			jr		c, copy_file_name
			inc		hl
			ld		a, [hl]				; 2nd char
			dec		hl
			cp		a, ':'
			jr		nz, copy_file_name
			ld		a, [hl]				; 1st char
			or		a, a
			jp		m, copy_file_name
			and		a, 0b1101_1111
			cp		a, 'H'+1
			jr		nc, copy_file_name
			sub		a, 'A'
			jr		c, copy_file_name
			inc		a
			ld		[de], a				; Driver Number 1:A, 2:B, ... 8:H
			inc		hl
			inc		hl
			dec		c
			dec		c
			; �t�@�C����(Max 8����) �̃R�s�[
		copy_file_name:
			inc		de					; DE: �t�@�C����
			ld		b, 8				; B: �t�@�C�����̍ő�T�C�Y
			inc		c					; ���܍��킹
		copy_file_name_loop:
			dec		c
			jr		z, copy_name_finish	; �t�@�C�����̃R�s�[�͏I�����
			ld		a, [hl]
			cp		a, '.'
			jr		z, copy_ext_name_skip_dot
			call	check_error_char
			jp		c, err_bad_file_name
			ld		[de], a
			inc		hl
			inc		de
			djnz	copy_file_name_loop
			jr		copy_ext_name
			; �t�@�C�����̎c��̌��Ԃ��X�L�b�v
		copy_ext_name_skip_dot:
			ld		a, ' '
		copy_ext_name_skip_dot_loop:
			ld		[de], a				; ���Ԃ� ' ' �Ŗ��߂�
			inc		de					; �g���q�̈ʒu�܂ňړ�
			djnz	copy_ext_name_skip_dot_loop
			inc		hl					; '.' ��ǂݔ�΂�
			; �g���q(Max 3����) �̃R�s�[
		copy_ext_name:
			ld		b, 3
		copy_ext_name_loop:
			ld		a, [hl]
			call	check_error_char
			jp		c, err_bad_file_name
			ld		[de], a
			inc		hl
			inc		de
			dec		c
			jr		z, copy_ext_name_padding
			djnz	copy_ext_name_loop
			jr		copy_name_finish
			; �g���q�� 3���������Ȃ�p�f�B���O
		copy_ext_name_padding:
			dec		b
			jr		z, copy_name_finish
			ld		a, ' '
		copy_ext_name_padding_loop:
			ld		[de], a
			inc		de
			djnz	copy_ext_name_padding_loop
			; �t�@�C�����ȊO�̃t�B�[���h������������
		copy_name_finish:
			ret

	check_error_char:
			push	hl
			push	bc
			ld		hl, error_char
			ld		b, a
	check_error_char_loop:
			ld		a, [hl]
			or		a, a
			jr		z, check_error_exit		; �s���ȋL���ɂ͈�v���Ȃ�����
			cp		a, b
			scf
			jr		z, check_error_exit		; �s���ȋL���Ɉ�v����
			inc		hl
			jr		check_error_char_loop
	check_error_exit:
			ld		a, b
			pop		bc
			pop		hl
			ret		c						; �G���[�Ȃ甲����
	toupper:
			cp		a, 'a'
			jr		c, toupper_exit
			cp		a, 'z'+1
			jr		nc, toupper_exit
			and		a, 0b1101_1111			; a �� A ... z �� Z
	toupper_exit:
			or		a, a					; Cf = 0
			ret
	error_char:
			db		":\"\\^|<>,./*? ", 0
			endscope

; =============================================================================
;	�t�@�C�����J��
;	input:
;		HL ... �t�@�C����
;		DE ... FCB�p�̃������̃A�h���X (37bytes)
;	output:
;		A .... 00h: ����, FFh: ���s
;	break:
;		all
;	comment:
;		���ɑ��݂���t�@�C�����J��
; =============================================================================
			scope	sub_fopen
sub_fopen::
			push	de
			call	sub_setup_fcb
			pop		de
			push	de
			ld		c, _FOPEN
			call	bdos
			pop		hl
			ld		de, 14
			add		hl, de
			push	af
			ld		a, 1
			ld		[hl], a
			dec		a
			inc		hl
			ld		[hl], a
			pop		af
			ret
			endscope

; =============================================================================
;	�t�@�C�������
;	input:
;		HL ... �t�@�C����
;		DE ... FCB�p�̃������̃A�h���X (37bytes)
;	output:
;		A .... 00h: ����, FFh: ���s
;	break:
;		all
;	comment:
;		���݂��Ȃ���ΐ������A���݂��Ă���΍�蒼��
; =============================================================================
			scope	sub_fcreate
sub_fcreate::
			push	de
			call	sub_setup_fcb
			pop		de
			push	de
			ld		c, _FMAKE
			call	bdos
			pop		hl
			ld		de, 14
			add		hl, de
			push	af
			ld		a, 1
			ld		[hl], a
			dec		a
			inc		hl
			ld		[hl], a
			pop		af
			ret
			endscope

; =============================================================================
;	�t�@�C�������
;	input:
;		HL ... �J����FCB
;	output:
;		A .... 00h: ����, FFh: ���s
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_fclose
sub_fclose::
			ld		c, _FCLOSE
			ex		de, hl
			jp		bdos
			endscope

; =============================================================================
;	�t�@�C����ǂ�
;	input:
;		HL ... �J����FCB
;		DE ... �ǂݏo�����ʂ��i�[����A�h���X
;		BC ... �ǂݏo���T�C�Y
;	output:
;		A .... 00h: ����, 01h: ���s�܂���EOF
;		HL ... ���ۂɓǂ񂾃o�C�g��
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_fread
sub_fread::
			push	bc					; �T�C�Y
			push	hl					; FCB
			; �]����A�h���X�̎w��
			ld		c, _SETDTA
			call	bdos
			; �ǂݏo��
			pop		de					; FCB
			pop		hl					; �T�C�Y = ���R�[�h�� (1���R�[�h 1byte�ݒ�)
			ld		c, _RDBLK
			jp		bdos
			endscope

; =============================================================================
;	�t�@�C���֏�������
;	input:
;		HL ... �J����FCB
;		DE ... �����o�����e���i�[����Ă���A�h���X
;		BC ... �����o���T�C�Y
;	output:
;		A .... 00h: ����, 01h: ���s
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_fwrite
sub_fwrite::
			push	bc					; �T�C�Y
			push	hl					; FCB
			; �]�����A�h���X�̎w��
			ld		c, _SETDTA
			call	bdos
			; �ǂݏo��
			pop		de					; FCB
			pop		hl					; �T�C�Y = ���R�[�h�� (1���R�[�h 1byte�ݒ�)
			ld		c, _WRBLK
			jp		bdos
			endscope

; =============================================================================
;	BLOAD �t�@�C����,S
;	input:
;		HL ... �t�@�C����
;		DE ... �ǂ݂����p�o�b�t�@
;		BC ... �ǂ݂����p�o�b�t�@�̃T�C�Y
;	output:
;		none
;	break:
;		all
;	comment:
;		�ǂ݂����p�o�b�t�@�́A�Œ�ł� 128byte �K�v
; =============================================================================
			scope	sub_bload_s
sub_bload_s::
			ld		[buffer_address], de
			ld		[buffer_size], bc
			; �t�@�C�����J��
			ld		de, buf				; FCB �� buf �ɒu��
			call	sub_fopen
			or		a, a
			jp		nz, err_file_not_found
			; �w�b�_��ǂݏo��
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fread
			or		a, a
			jp		nz, err_bad_file_mode
			ld		a, [bsave_head_signature]
			cp		a, 0xFE
			jp		nz, err_bad_file_mode
			; �T�C�Y�����߂�
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			ld		[bsave_head_size], hl
			; VRAM�A�h���X���Z�b�g����
			ld		hl, [bsave_head_start]
			ld		a, [scrmod]
			cp		a, 5
			jr		nc, screen5over
		screen5under:
			call	setwrt
			jr		exit_setwrt
		screen5over:
			call	nstwrt
		exit_setwrt:
		load_loop:
			; �o�b�t�@�ɓǂݏo��
			ld		hl, [buffer_size]
			ld		de, [bsave_head_size]
			rst		0x20						; CP HL, DE
			ld		bc, [buffer_size]
			jr		c, skip1
			ld		bc, [bsave_head_size]
		skip1:
			ld		hl, buf
			ld		de, [buffer_address]
			push	bc							; �ǂݏo���T�C�Y
			call	sub_fread
			pop		bc							; �ǂݏo���T�C�Y
			or		a, a
			sbc		hl, bc
			jp		nz, err_device_io			; �w��̃T�C�Y�ǂ߂Ȃ������ꍇ�� Device I/O Error
			; �ǂ񂾃T�C�Y���� VRAM �֓]������
			ld		hl, [buffer_address]
			ld		de, [bsave_head_size]
		transfer_loop:
			ld		a, [hl]
			out		[ vdpport0 ], a
			inc		hl
			dec		de
			dec		bc
			ld		a, c
			or		a, b
			jr		nz, transfer_loop
			ld		[bsave_head_size], de
			ld		a, e
			or		a, d
			jr		nz, load_loop
			; �t�@�C�������
			ld		hl, buf
			jp		sub_fclose

	bsave_head				= buf + 37
	bsave_head_signature	= bsave_head
	bsave_head_start		= bsave_head + 1
	bsave_head_end			= bsave_head + 3
	bsave_head_size			= bsave_head + 5
	buffer_address			= bsave_head + 7
	buffer_size				= bsave_head + 9
			endscope

; =============================================================================
;	BLOAD HL
;	input:
;		HL ... �t�@�C����
;	output:
;		HL ... ���s�J�n�A�h���X
;		DE ... �擪�A�h���X
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_bload
sub_bload::
			; �t�@�C�����J��
			ld		de, buf				; FCB �� buf �ɒu��
			call	sub_fopen
			or		a, a
			jp		nz, err_file_not_found
			; �w�b�_��ǂݏo��
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fread
			or		a, a
			jp		nz, err_bad_file_mode
			ld		a, [bsave_head_signature]
			cp		a, 0xFE
			jp		nz, err_bad_file_mode
			; �T�C�Y�����߂�
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			ld		[bsave_head_size], hl
			; �ǂݏo��
			ld		bc, [bsave_head_size]
			ld		hl, buf
			ld		de, [bsave_head_start]
			push	bc							; �ǂݏo���T�C�Y
			call	sub_fread
			pop		bc							; �ǂݏo���T�C�Y
			or		a, a
			sbc		hl, bc
			jp		nz, err_device_io			; �w��̃T�C�Y�ǂ߂Ȃ������ꍇ�� Device I/O Error
			; �t�@�C�������
			ld		hl, buf
			call	sub_fclose
			ld		hl, [bsave_head_exec]
			ld		de, [bsave_head_start]
			ret

	bsave_head				= buf + 37
	bsave_head_signature	= bsave_head
	bsave_head_start		= bsave_head + 1
	bsave_head_end			= bsave_head + 3
	bsave_head_exec			= bsave_head + 5
	bsave_head_size			= bsave_head + 7
			endscope

; =============================================================================
;	MID$( ������ϐ�, �����ւ��ʒu, �����ւ������� ) = �����ւ��镶��
;	input:
;		HL ... ������ϐ��̃A�h���X(�����ւ���ꏊ)
;		DE ... �㏑�����镶����̃A�h���X
;		B .... �����ւ��ʒu (�擪�� 1)
;		C .... �����ւ������� (�ȗ����� 255)
;	output:
;		HL�̕����񂪏����ւ�����
;	break:
;		all
;	comment:
;		HL �̒l�͕ۑ������
; =============================================================================
			scope	sub_mid_cmd
sub_mid_cmd::
			; B = 0 �̓G���[
			inc		b
			dec		b
			jp		z, err_illegal_function_call
			; �����ւ��ʒu B ���͂ݏo���ĂȂ����`�F�b�N
			ld		a, [hl]								; ������ϐ��Ɋi�[����Ă��镶����̒���
			cp		a, b
			jp		c, err_illegal_function_call
			; �����ւ���������������[���z���Ă��Ȃ����`�F�b�N
			ld		a, b
			dec		a
			add		a, c
			jr		c, adjust_size
			cp		a, [hl]
			jr		nc, after_adjust_size
		adjust_size:
			; ������[���z���Ă���ꍇ�͂����܂ł̒����ɐ؂�l�߂�
			ld		a, [hl]
			sub		a, b
			inc		a
			ld		c, a
		after_adjust_size:
			; �㏑�����镶���� DE ���A�����ւ��钷�� C ���Z�������ׂ�
			ld		a, [de]
			cp		a, c
			jr		nc, after_adjust_size2
			; �Z�������̂ŁA�����ւ��钷����u��������
			ld		c, a
		after_adjust_size2:
			; �����ւ��钷���� 0 �ɂȂ����ꍇ�A�������Ȃ�
			inc		c
			dec		c
			ret		z
			push	hl
			; �����ւ���ʒu�փ|�C���^���ړ�
			ld		a, l
			add		a, b
			ld		l, a
			ld		a, h
			ld		b, 0
			adc		a, b
			; �����ւ�����
			inc		de
			ex		de, hl
			ldir
			pop		hl
			ret
			endscope

; =============================================================================
			scope	error_handler
err_syntax::
			ld		e, 2
err_illegal_function_call	:= $+1
			ld		bc, 0x051E
err_type_mismatch			:= $+1
			ld		bc, 0x0D1E
err_device_io				:= $+1
			ld		bc,	0x131E
err_file_not_found			:= $+1
			ld		bc, 0x351E
err_bad_file_name			:= $+1
			ld		bc, 0x381E
err_bad_file_mode			:= $+1
			ld		bc, 0x3D1E
			ld		iy, [exptbl - 1]		; MAIN-ROM SLOT
			ld		ix, 0x406F				; ERRHNDR
			jp		calslt
			endscope
