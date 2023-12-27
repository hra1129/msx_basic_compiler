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
wrtvrm		:= 0x004D
setrd		:= 0x0050
setwrt		:= 0x0053
filvrm		:= 0x0056
ldirmv		:= 0x0059
ldirvm		:= 0x005C
chgmod		:= 0x005F
calpat		:= 0x0084
calatr		:= 0x0087
chget		:= 0x009F
rslreg		:= 0x0138
calbas		:= 0x0159
extrom		:= 0x015F
bigfil		:= 0x016B
nsetrd		:= 0x016E
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
rndx		:= 0xF857
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

BBT_SX		:= 0xF562
BBT_SY		:= 0xF564
BBT_DX		:= 0xF566
BBT_DY		:= 0xF568
BBT_NX		:= 0xF56A
BBT_NY		:= 0xF56C
BBT_CLR		:= 0xF56E
BBT_ARG		:= 0xF56F
BBT_LOGOP	:= 0xF570

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
	blib_bsave:
			jp		sub_bsave
	blib_bsave_s:
			jp		sub_bsave_s
	blib_lset:
			jp		sub_lset
	blib_rset:
			jp		sub_rset
	blib_base:
			jp		sub_base
	blib_input:
			jp		sub_input
	blib_irnd:
			jp		sub_irnd
	blib_irandomize:
			jp		sub_irandomize
	blib_pokes:
			jp		sub_pokes
	blib_peeks:
			jp		sub_peeks
	blib_vpokes:
			jp		sub_vpokes
	blib_vpeeks:
			jp		sub_vpeeks
	blib_hexchr:
			jp		sub_hexchr
	blib_chrhex:
			jp		sub_chrhex
	blib_files:
			jp		sub_files
	blib_puts:
			jp		sub_puts
	blib_kill:
			jp		sub_kill
	blib_name:
			jp		sub_name
	blib_colorsprite:
			jp		sub_colorsprite
	blib_colorsprite_str:
			jp		sub_colorsprite_str
	blib_copy_file_to_file:
			jp		sub_copy_file_to_file
	blib_copy_array_to_file:
			jp		sub_copy_array_to_file
	blib_copy_file_to_array:
			jp		sub_copy_file_to_array
	blib_copy_pos_to_pos:
			jp		sub_copy_pos_to_pos
	blib_copy_pos_to_array:
			jp		sub_copy_pos_to_array
	blib_copy_array_to_pos:
			jp		sub_copy_array_to_pos
	blib_copy_pos_to_file:
			jp		sub_copy_pos_to_file
	blib_umul:
			jp		sub_umul

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
			ei
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
			ei
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
			ei
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
			ei
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
			ei
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
			ei
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
			ei
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
			ei
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
;	COLOR SPRITE (A)=L
;	input:
;		A ..... �X�v���C�g�ԍ�
;		L ..... �F
;	output:
;		none
;	break:
;		all
;	comment:
;		MSX-BASIC 1.0 �ł̓T�|�[�g���Ă��Ȃ����A���̃��[�`���� MSX1 �ł����p�\
; =============================================================================
			scope	sub_colorsprite
sub_colorsprite::
			ld		b, a
			ld		c, l
			ld		a, [scrmod]
			cp		a, 4
			jr		nc, _sprite_mode2
	_sprite_mode1:
			ld		a, b
			call	calatr				; �X�v���C�g�A�g���r���[�g�̃A�h���X�� HL �Ɏ擾
			ld		a, c				; A = �F
			inc		hl
			inc		hl
			inc		hl
			call	wrtvrm				; VRAM�֏�������
			ret
	_sprite_mode2:
			xor		a, a
			call	calatr				; �X�v���C�g�A�g���r���[�g�̐擪�A�h���X�� HL �Ɏ擾
			dec		h
			dec		h					; �X�v���C�g�J���[�e�[�u���̃A�h���X�ɕϊ�
			ld		a, b				; �X�v���C�g�v���[���ԍ�
			rlca
			rlca
			rlca
			rlca
			ld		l, a
			adc		a, h
			ld		h, a				; HL = �J���[�e�[�u���̃A�h���X
			ld		a, c				; A = �F
			ld		bc, 16
			jp		bigfil
			endscope

; =============================================================================
;	COLOR SPRITE$ (A)=HL
;	input:
;		A ..... �X�v���C�g�ԍ�
;		HL .... �F������
;	output:
;		none
;	break:
;		all
;	comment:
;		�X�v���C�g���[�h2�̉�ʃ��[�h�ł̂ݗL��
; =============================================================================
			scope	sub_colorsprite_str
sub_colorsprite_str::
			ld		b, a
			ld		a, [scrmod]
			cp		a, 4
			ret		c
			push	hl
			xor		a, a
			call	calatr				; �X�v���C�g�A�g���r���[�g�̐擪�A�h���X�� HL �Ɏ擾
			dec		h
			dec		h					; �X�v���C�g�J���[�e�[�u���̃A�h���X�ɕϊ�
			ld		a, b				; �X�v���C�g�v���[���ԍ�
			rlca
			rlca
			rlca
			rlca
			ld		l, a
			adc		a, h
			ld		h, a				; HL = �J���[�e�[�u���̃A�h���X
			call	nstwrt
			; �����𒲂ׂ�
			pop		hl
			ld		c, [hl]
			ld		b, 16
			inc		c
			dec		c
			jr		z, _fill2
	_loop1:
			inc		hl
			ld		a, [hl]
			out		[vdpport0], a
			dec		c
			jr		z, _fill
			djnz	_loop1
			ret
	_fill:
			dec		b
			ret		z
	_fill2:
			xor		a, a
	_loop2:
			out		[vdpport0], a
			djnz	_loop2
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
			ei
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
;		���C���h�J�[�h '*' �́A'?' �ɓW�J����
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
			jr		z, fill_name_padding	; �t�@�C�����̃R�s�[�͏I�����
			ld		a, [hl]
			cp		a, '.'
			jr		z, copy_ext_name_skip_dot
			cp		a, '*'
			jr		z, copy_ext_name_skip_wildcard
			call	check_error_char
			jp		c, err_bad_file_name
			ld		[de], a
			inc		hl
			inc		de
			djnz	copy_file_name_loop
			; �s�b�^��8�����̖��O���w�肳��Ă���ꍇ�� . �����邩�`�F�b�N
			ld		a, [hl]
			cp		a, '.'
			jr		nz, copy_ext_name
			inc		hl
			jr		copy_ext_name
			; �t�@�C�����̎c������C���h�J�[�h�Ŗ��߂�
		copy_ext_name_skip_wildcard:
			ld		a, '?'
			inc		hl
			jr		copy_ext_name_skip_dot_loop
			; �t�@�C�����̎c��̌��Ԃ��X�L�b�v
		fill_name_padding:
			dec		hl					; '.' ��ǂݔ�΂������̂��܍��킹
			inc		c					; '.' ��ǂݔ�΂������̂��܍��킹
		copy_ext_name_skip_dot:
			ld		a, ' '
		copy_ext_name_skip_dot_loop:
			ld		[de], a				; ���Ԃ� ' ' �Ŗ��߂�
			inc		de					; �g���q�̈ʒu�܂ňړ�
			djnz	copy_ext_name_skip_dot_loop
			inc		hl					; '.' ��ǂݔ�΂�
			dec		c					; '.' ��ǂݔ�΂�
			; �g���q(Max 3����) �̃R�s�[
		copy_ext_name:
			ld		b, 3
			inc		c
			dec		c
			jr		z, fill_ext_padding
		copy_ext_name_loop:
			ld		a, [hl]
			cp		a, '*'
			jr		z, copy_ext_name_padding_wildcard
			call	check_error_char
			jp		c, err_bad_file_name
			ld		[de], a
			inc		hl
			inc		de
			dec		c
			jr		z, copy_ext_name_padding
			djnz	copy_ext_name_loop
			jr		copy_name_finish
			; * �� ? �ɒu��
		copy_ext_name_padding_wildcard:
			ld		a, '?'
			jr		copy_ext_name_padding_loop
			; �g���q�� 3���������Ȃ�p�f�B���O
		copy_ext_name_padding:
			dec		b
			jr		z, copy_name_finish
		fill_ext_padding:
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
			db		":\"\\^|<>,./ ", 0
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
			ld		de, 33-15
			add		hl, de
			ld		[hl], a
			inc		hl
			ld		[hl], a
			inc		hl
			ld		[hl], a
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
			ld		de, 33-15
			add		hl, de
			ld		[hl], a
			inc		hl
			ld		[hl], a
			inc		hl
			ld		[hl], a
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
			ei
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
			ei
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
			jr		c, after_adjust_size
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
;	BSAVE HL
;	input:
;		HL ... �t�@�C����
;		DE ... �J�n�A�h���X�A�I���A�h���X�A���s�A�h���X���i�[����Ă���A�h���X
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_bsave
sub_bsave::
			ei
			; �t�@�C�����J��
			push	de
			ld		de, buf				; FCB �� buf �ɒu��
			call	sub_fcreate
			or		a, a
			jp		nz, err_device_io
			pop		hl
			; �w�b�_�����
			ld		de, bsave_head_start
			ld		bc, 6
			ldir
			ld		a, 0xFE
			ld		[bsave_head_signature], a
			; �w�b�_�������o��
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; �����o���T�C�Y���v�Z (bsave_head_end - bsave_head_start + 1)
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			inc		hl
			ld		c, l
			ld		b, h
			; �����o��
			ld		hl, buf				; FCB
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; �t�@�C�������
			ld		hl, buf
			call	sub_fclose
			ret

	bsave_head				= buf + 37
	bsave_head_signature	= bsave_head
	bsave_head_start		= bsave_head + 1
	bsave_head_end			= bsave_head + 3
	bsave_head_exec			= bsave_head + 5
	bsave_head_size			= bsave_head + 7
			endscope

; =============================================================================
;	BSAVE HL,S
;	input:
;		HL ... �t�@�C����
;		DE ... �J�n�A�h���X�A�I���A�h���X�A���s�A�h���X�A���[�N�G���A�J�n�A�h���X�A�I���A�h���X���i�[����Ă���A�h���X
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_bsave_s
sub_bsave_s::
			ei
			; �t�@�C�����J��
			push	de
			ld		de, buf				; FCB �� buf �ɒu��
			call	sub_fcreate
			or		a, a
			jp		nz, err_device_io
			pop		hl
			; �w�b�_�����
			ld		de, bsave_head_start
			ld		bc, 10
			ldir
			ld		a, 0xFE
			ld		[bsave_head_signature], a
			; �w�b�_�������o��
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; ���[�N�G���A�T�C�Y���v�Z
			ld		hl, [bsave_work_end]
			ld		de, [bsave_work_start]
			or		a, a
			sbc		hl, de
			ld		[bsave_work_size], hl
			; �����o���T�C�Y���v�Z (bsave_head_end - bsave_head_start + 1)
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			ld		[bsave_data_size], hl
			; VRAM�A�h���X���Z�b�g
			ld		hl, [bsave_head_start]
			ld		a, [romver]
			or		a, a
			jr		z, skip1
			call	nsetrd					; VRAM ADDRESS�Z�b�g for MSX2/2+/turboR
			jr		loop
		skip1:
			call	setrd					; VRAM ADDRESS�Z�b�g for MSX1
		loop:
			; �c��T�C�Y���v�Z
			ld		hl, [bsave_data_size]
			ld		de, [bsave_work_size]
			or		a, a
			sbc		hl, de
			jr		c, work_is_big
		data_is_big:
			ld		[bsave_data_size], hl
			ld		c, e
			ld		b, d
			jr		skip2
		work_is_big:
			ld		bc, [bsave_data_size]
			ld		hl, 0
			ld		[bsave_data_size], hl
		skip2:
			ld		hl, [bsave_work_start]
			push	hl
			push	bc
		vram_read:
			in		a, [vdpport0]
			ld		[hl], a
			inc		hl
			dec		bc
			ld		a, c
			or		a, b
			jr		nz, vram_read
			; �����o��
			ld		hl, buf					; FCB
			pop		bc						; size
			pop		de						; work
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; �����I�������H
			ld		bc, [bsave_data_size]
			ld		a, c
			or		a, b
			jr		nz, loop
			; �t�@�C�������
			ld		hl, buf
			call	sub_fclose
			ret

	bsave_head				= buf + 37
	bsave_head_signature	= bsave_head
	bsave_head_start		= bsave_head + 1
	bsave_head_end			= bsave_head + 3
	bsave_head_exec			= bsave_head + 5
	bsave_work_start		= bsave_head + 7
	bsave_work_end			= bsave_head + 9
	bsave_data_size			= bsave_head + 11
	bsave_work_size			= bsave_head + 13
			endscope

; =============================================================================
;	LSET HL=DE
;	input:
;		HL ... �㏑�������ϐ��̃A�h���X
;		DE ... �㏑�����镶����
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_lset
sub_lset::
			; �ϐ��̃A�h���X���當����A�h���X���擾
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; �������ׂ�
			ex		de, hl			; DE = �㏑������镶����, HL = �㏑�����镶����
			ld		a, [de]			; A = �㏑������镶����̒���
			ld		c, [hl]			; C = �㏑�����镶����̒���
			ld		b, a
			cp		a, c
			jr		nc, skip		; �㏑�����镶���񂪒Z����� skip
			; A > C �̏ꍇ : �㏑������镶����̕����Z���ꍇ
			ld		c, a			; �㏑�����镶����̒������A�㏑������镶����̒����ɐ؂�l�߂�
		skip:
			ld		a, b			; A �� HL �̕�����̒���
			sub		a, c
			inc		c
			dec		c
			inc		de
			jr		z, skip_fill	; �X�V�� 0 �Ȃ牽�����Ȃ�
			; ��������R�s�[����
			ld		b, 0
			inc		hl
			ldir
		skip_fill:
			; �c����X�y�[�X�Ŗ��߂�
			or		a, a			; �c�肪�����ꍇ�͉������Ȃ�
			ret		z
			ld		b, a
			ld		a, ' '
		loop:
			ld		[de], a
			inc		de
			djnz	loop
			ret
			endscope

; =============================================================================
;	RSET HL=DE
;	input:
;		HL ... �㏑�������ϐ��̃A�h���X
;		DE ... �㏑�����镶����
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_rset
sub_rset::
			; �ϐ��̃A�h���X���當����A�h���X���擾
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; �������ׂ�
			ex		de, hl			; DE = �㏑������镶����, HL = �㏑�����镶����
			ld		a, [de]			; A = �㏑������镶����̒���
			ld		c, [hl]			; C = �㏑�����镶����̒���
			ld		b, a
			cp		a, c
			jr		nc, skip		; �㏑�����镶���񂪒Z����� skip
			; A > C �̏ꍇ : �㏑������镶����̕����Z���ꍇ
			ld		c, a			; �㏑�����镶����̒������A�㏑������镶����̒����ɐ؂�l�߂�
		skip:
			ld		a, b			; A �� HL �̕�����̒���
			inc		de
			inc		hl
			sub		a, c
			jr		z, fill_end
		fill:
			ld		b, a
			ld		a, ' '
		loop1:
			ld		[de], a
			inc		de
			djnz	loop1
		fill_end:
			inc		c
			dec		c
			ret		z
			; �c����w��̕�����ɒu��������
			ldir
			ret
			endscope

; =============================================================================
;	BASE(HL)
;	input:
;		HL ... �ԍ�
;	output:
;		HL ... �A�h���X
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_base
sub_base::
			ld		a, l
			cp		a, 20
			jr		nc, msx2_mode
			; MSX1 �̃��[�h�̏ꍇ
			ld		h, 0xF3
			add		a, a
			add		a, 0xB3
	finish:
			ld		l, a
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			ret
	msx2_mode:
			sub		a, 20
			cp		a, 5
			jr		nc, screen56_mode
			; SCREEN4
			ld		h, screen4_base >> 8
			add		a, a
			add		a, screen4_base & 0xFF
			jr		finish
	screen56_mode:
			cp		a, 15
			jr		nc, screen78_mode
			call	mod5
			; SCREEN5�`6
			ld		h, screen5_base >> 8
			add		a, a
			add		a, screen5_base & 0xFF
			jr		finish
	screen78_mode:
			call	mod5
			; SCREEN7�`12
			ld		h, screen7_base >> 8
			add		a, a
			add		a, screen7_base & 0xFF
			jr		finish
	mod5:
			sub		a, 5
			jr		nc, mod5
			add		a, 5
			ret
	screen4_base:
			dw		0x1800			; Name Table
			dw		0x2000			; Color Table
			dw		0x0000			; Pattern Generator Table
			dw		0x1E00			; Sprite Attribute Table
			dw		0x3800			; Sprite Pattern Generator Table
	screen5_base:
			dw		0x0000			; Name Table
			dw		0x0000			; Color Table
			dw		0x0000			; Pattern Generator Table
			dw		0x7600			; Sprite Attribute Table
			dw		0x7800			; Sprite Pattern Generator Table
	screen7_base:
			dw		0x0000			; Name Table
			dw		0x0000			; Color Table
			dw		0x0000			; Pattern Generator Table
			dw		0xFA00			; Sprite Attribute Table
			dw		0xF000			; Sprite Pattern Generator Table
			endscope

; =============================================================================
;	INKEY$
;	input:
;		HL .... ���͂��ꂽ��������i�[���郁���� ( [HL+0]:�T�C�Y, [HL+1]�`[HL+1+�T�C�Y]:������ )
;	output:
;		HL .... ���͂��ꂽ���� (BASIC�`��)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		[HL+1]�`[HL+1+�T�C�Y] �͏㏑�������
; =============================================================================
			scope	sub_input
sub_input::
			ei
			ld		a, [hl]
			or		a, a
			ret		z
			push	hl
			ld		b, a
			inc		hl
		loop:
			call	chget
			ld		[hl], a
			inc		hl
			djnz	loop
			pop		hl
			ret
			endscope

; =============================================================================
;	IRND (��BACON�Ǝ��֐�)
;	input:
;		none
;	output:
;		HL .... ����
;	break:
;		all
;	comment:
;		-32768�`32767 �̗�����Ԃ�
;		MSX-BASIC�W���� RND() �̃��[�N�G���A�ł��� RNDX ���g�����߁A
;		�����g���ꍇ�͗v����
; =============================================================================
			scope	sub_irnd
sub_irnd::
			ld		hl, [rndx + 2]
			ld		de, [rndx + 4]
			ld		a, l
			xor		a, 0x53
			rrca
			add		a, 29
			xor		a, d
			rlca
			ld		l, a
			ld		a, h
			xor		a, 0xA8
			rlca
			add		a, 53
			xor		a, e
			rlca
			ld		h, a
			ld		[rndx + 4], hl
			ld		[rndx + 2], de
			ret
			endscope

; =============================================================================
;	IRANDOMIZE (��BACON�Ǝ��֐�)
;	input:
;		none
;	output:
;		HL .... �����l
;	break:
;		all
;	comment:
;		����������������
;		MSX-BASIC�W���� RND() �̃��[�N�G���A�ł��� RNDX ���g�����߁A
;		�����g���ꍇ�͗v����
; =============================================================================
			scope	sub_irandomize
sub_irandomize::
			ld		a, l
			xor		a, 0x43
			rrca
			ld		d, a
			ld		a, h
			xor		a, 0x52
			rlca
			ld		e, a
			ld		[rndx + 2], de
			xor		a, 0x3C
			rrca
			ld		h, a
			xor		a, l
			add		a, 19
			ld		l, a
			ld		[rndx + 4], hl
			ret
			endscope

; =============================================================================
;	POKES �A�h���X, ������ (��BACON�Ǝ��֐�)
;	input:
;		HL .... �A�h���X
;		DE .... ������
;	output:
;		HL .... ������
;	break:
;		all
;	comment:
;		�A�h���X�֕��������������
; =============================================================================
			scope	sub_pokes
sub_pokes::
			ld		a, [de]
			or		a, a
			ret		z

			push	de
			inc		de
			ex		de, hl
			ld		c, a
			ld		b, 0
			ldir
			pop		hl
			ret
			endscope

; =============================================================================
;	PEEKS$( �A�h���X, ������ ) (��BACON�Ǝ��֐�)
;	input:
;		HL .... �A�h���X
;		DE .... ������
;	output:
;		HL .... ������ (���m�ۍς݂̕�����̈�ɏ㏑������)
;	break:
;		all
;	comment:
;		�A�h���X����ǂݏo���ĕ������Ԃ�
; =============================================================================
			scope	sub_peeks
sub_peeks::
			ld		a, [de]
			or		a, a
			ret		z

			push	de
			inc		de
			ld		c, a
			ld		b, 0
			ldir
			pop		hl
			ret
			endscope

; =============================================================================
;	VPOKES �A�h���X, ������ (��BACON�Ǝ��֐�)
;	input:
;		HL .... �A�h���X
;		DE .... ������
;	output:
;		HL .... ������
;	break:
;		all
;	comment:
;		�A�h���X�֕��������������
; =============================================================================
			scope	sub_vpokes
sub_vpokes::
			ld		a, [de]
			or		a, a
			ret		z

			push	de
			inc		de
			ex		de, hl
			ld		c, a
			ld		b, 0
			call	ldirvm
			pop		hl
			ret
			endscope

; =============================================================================
;	VPEEKS$( �A�h���X, ������ ) (��BACON�Ǝ��֐�)
;	input:
;		HL .... �A�h���X
;		DE .... ������
;	output:
;		HL .... ������ (���m�ۍς݂̕�����̈�ɏ㏑������)
;	break:
;		all
;	comment:
;		�A�h���X����ǂݏo���ĕ������Ԃ�
; =============================================================================
			scope	sub_vpeeks
sub_vpeeks::
			ld		a, [de]
			or		a, a
			ret		z

			push	de
			inc		de
			ld		c, a
			ld		b, 0
			call	ldirmv
			pop		hl
			ret
			endscope

; =============================================================================
;	HEXCHR$( ������ ) (��BACON�Ǝ��֐�)
;	input:
;		HL .... ���͕�����
;	output:
;		HL .... �ϊ����ʂ̕�����
;	break:
;		all
;	comment:
;		���͕������ 2������2����16�i���ƌ��Ȃ��Č��ʂ֊i�[�B�����S�����ɍs���B
;		16�i���ȊO�̕����������Ă����ꍇ�̋����͕s��B
; =============================================================================
			scope	sub_hexchr
sub_hexchr::
			ld		a, [hl]
			and		a, 0xFE
			ret		z

			ld		de, buf
			rrca
			ld		b, a
			ld		[de], a

			inc		de
			inc		hl
		loop:
			ld		a, [hl]
			call	hexchr
			add		a, a
			add		a, a
			add		a, a
			add		a, a
			ld		c, a
			inc		hl
			ld		a, [hl]
			inc		hl
			call	hexchr
			or		a, c
			ld		[de], a
			inc		de
			djnz	loop
			ld		hl, buf
			ret
		hexchr:
			cp		a, '9' + 1
			jr		nc, is_alpha
			sub		a, '0'
			ret
		is_alpha:
			or		a, 0x60
			sub		a, 'a'-10
			ret
			endscope

; =============================================================================
;	CHRHEX$( ������ ) (��BACON�Ǝ��֐�)
;	input:
;		HL .... ���͕�����
;	output:
;		HL .... �ϊ����ʂ̕�����̃A�h���X
;	break:
;		all
;	comment:
;		���͕�����̕����R�[�h�� 16�i��������ɕϊ�����B�����S�����ɍs���B
; =============================================================================
			scope	sub_chrhex
sub_chrhex::
			ld		a, [hl]
			or		a, a
			ret		z

			ld		de, buf
			ld		b, a
			add		a, a
			ld		[de], a

			inc		de
			inc		hl
		loop:
			ld		a, [hl]
			inc		hl
			ld		c, a
			rrca
			rrca
			rrca
			rrca
			and		a, 0x0F
			call	chrhex
			ld		[de], a
			inc		de
			ld		a, c
			and		a, 0x0F
			call	chrhex
			ld		[de], a
			inc		de
			djnz	loop
			ld		hl, buf
			ret
		chrhex:
			cp		a, 10
			jr		nc, is_alpha
			add		a, '0'
			ret
		is_alpha:
			add		a, 'A'-10
			ret
			endscope

; =============================================================================
;	FILES <���C���h�J�[�h>
;	input:
;		HL .... ���C���h�J�[�h������ (0000h ���w�肷��� *.* �ɂȂ�)
;	output:
;		none
;	break:
;		all
;	comment:
;		DiskBASIC1.x �� FILES �����BDiskBASIC2.x �� FILES,L �ɂ͔�Ή��B
; =============================================================================
			scope	sub_files
find_file_name		= buf
find_file_name_fcb	= find_file_name + 37

sub_files::
			ei
			; HL=0 ?
			ld		a, l
			or		a, h
			jr		nz, skip
			ld		hl, wildcard_all
		skip:
			; FCB����
			ld		de, find_file_name
			call	sub_setup_fcb

			; �]�����A�h���X�̎w�� (�������t�@�C���� FCB ���i�[�����)
			ld		de, find_file_name_fcb
			ld		c, _SETDTA
			call	bdos

			; �J�[�\�������[�ɋ��邩���ׂ�
			ld		a, [csrx]				; ���[�� 1 (0�ł͂Ȃ��̂ŗv����)
			dec		a
			jr		nz, skip_print_crlf
			; �J�[�\�������[�ɂȂ��̂ŉ��s����
			ld		hl, data_crlf
			call	sub_puts
		skip_print_crlf:

			; �ŏ��̌���
			ld		de, buf
			ld		c, _SFIRST
			call	bdos
			or		a, a
			jr		nz, end_files			; ���s�����ꍇ (1���q�b�g���Ȃ��ꍇ)�A�������Ȃ��B

		loop:
			; �������t�@�C����\������
			call	put_one_file
			; ���̃t�@�C��������
			ld		c, _SNEXT
			call	bdos
			or		a, a
			jr		nz, end_files
			; ����\���ł���ʒu���m�F
			ld		a, [csrx]				; ���[�� 1 �Ƃ��� X���W
			ld		b, a
			ld		a, [linlen]				; WIDTH n �� n
			sub		a, b
			cp		a, 13
			jr		nc, loop
			; ����ȏ�E�ɕ\���ł��Ȃ��̂ŉ��s
		put_return:
			ld		hl, data_crlf
			call	sub_puts
			jr		loop

		end_files:
			; �J�[�\�������[�łȂ���Ή��s
			ld		a, [csrx]				; ���[�� 1 (0�ł͂Ȃ��̂ŗv����)
			dec		a
			jr		z, finish
			; �J�[�\�������[�ɂȂ��̂ŉ��s����
			ld		hl, data_crlf
			call	sub_puts
		finish:
			ret

			; �t�@�C����������\������
		put_one_file:
			; ���[���H
			ld		a, [csrx]
			dec		a
			jr		z, put_name
			; ���[�łȂ��̂� ' ' ��\��
			ld		a, ' '
			rst		0x18
			; �t�@�C���� 8����
		put_name:
			ld		a, 8
			ld		hl, find_file_name_fcb
			ld		[hl], a
			call	sub_puts
			; �g���q������ۂ����ׂ�
			ld		hl, [find_file_name_fcb + 1 + 8]
			ld		a, [find_file_name_fcb + 1 + 10]
			or		a, l
			or		a, h
			; ����ۂłȂ���� '.' ���A����ۂȂ� ' ' ��\������
			cp		a, ' '
			jr		z, blank_ext
			ld		a, '.'
		blank_ext:
			rst		0x18
			; �g���q 3����
			ld		a, 3
			ld		hl, find_file_name_fcb + 1 + 8 - 1
			ld		[hl], a
			call	sub_puts
			ret
			endscope

; =============================================================================
;	PUTS
;	input:
;		HL .... �\�����镶����
;	output:
;		none
;	break:
;		A, B, H, L, F
;	comment:
;		none
; =============================================================================
			scope	sub_puts
sub_puts::
			ld		b, [hl]
			inc		b
			dec		b
			ret		z
		loop:
			inc		hl
			ld		a, [hl]
			rst		0x18
			djnz	loop
			ret
			endscope

; =============================================================================
;	KILL <���C���h�J�[�h>
;	input:
;		HL .... ���C���h�J�[�h������
;	output:
;		none
;	break:
;		all
;	comment:
;		�t�@�C�����폜����
; =============================================================================
			scope	sub_kill
sub_kill::
			; FCB����
			ld		de, buf
			call	sub_setup_fcb

			; �t�@�C�����폜����
			ld		de, buf
			ld		c, _FDEL
			call	bdos
			ret
			endscope

; =============================================================================
;	NAME <���C���h�J�[�h> AS <���C���h�J�[�h>
;	input:
;		HL .... ���C���h�J�[�h������
;		DE .... ���C���h�J�[�h������
;	output:
;		none
;	break:
;		all
;	comment:
;		�t�@�C������ύX����
; =============================================================================
			scope	sub_name
sub_name::
			; FCB����
			push	de
			ld		de, buf
			call	sub_setup_fcb
			pop		hl
			ld		de, buf + 16
			call	sub_setup_fcb

			; �t�@�C����ύX����
			ld		de, buf
			ld		c, _FREN
			call	bdos
			ret
			endscope

; =============================================================================
;	COPY <���C���h�J�[�h1> TO <���C���h�J�[�h2>
;	input:
;		HL .... ���C���h�J�[�h1������
;		DE .... ���C���h�J�[�h2������
;		buffer_start .... ��Ɨp�o�b�t�@�̐擪�A�h���X
;		buffer_end ...... ��Ɨp�o�b�t�@�̏I���A�h���X (�����͊܂܂Ȃ�)
;	output:
;		none
;	break:
;		all
;	comment:
;		�t�@�C�����R�s�[����B
;		buffer_start, buffer_end �� 0xC000, 0xE000 ���w�肷��ƁA0xC000�`0xDFFF
;		����Ɨp�Ɏg����B
; =============================================================================
			scope	sub_copy_file_to_file
buffer_start		= buf
buffer_end			= buffer_start + 2
buffer_size			= buffer_end + 2
remain_file_size	= buffer_size + 2
find_file_name		= remain_file_size + 4
find_file_name_fcb	= find_file_name + 37
copy_file_name_fcb	= find_file_name_fcb + 37
replace_name		= copy_file_name_fcb + 37

sub_copy_file_to_file::
			ei
			push	hl
			; ��ɓ]�����ϊ�����
			ex		de, hl
			ld		de, replace_name
			call	sub_setup_fcb
			; ���ɓ]������ϊ�����
			pop		hl
			ld		de, find_file_name
			call	sub_setup_fcb
			; �]�����A�h���X�̎w�� (�������t�@�C���� FCB ���i�[�����)
			ld		de, find_file_name_fcb
			ld		c, _SETDTA
			call	bdos
			; ���[�N�̃T�C�Y�����߂�
			ld		hl, [buffer_end]
			ld		de, [buffer_start]
			or		a, a
			sbc		hl, de
			ld		[buffer_size], hl

			; �ŏ��̌���
			ld		de, find_file_name
			ld		c, _SFIRST
			call	bdos
			or		a, a
			jr		nz, end_files			; ���s�����ꍇ (1���q�b�g���Ȃ��ꍇ)�A�������Ȃ��B

		loop:
			; �������t�@�C�����R�s�[����
			call	copy_one_file
			; ���̃t�@�C��������
			ld		c, _SNEXT
			call	bdos
			or		a, a
			jr		z, loop

		end_files:
			ret

			; �t�@�C������R�s�[����
		copy_one_file:
			; FCB���R�s�[����
			ld		hl, find_file_name_fcb
			ld		de, copy_file_name_fcb
			ld		bc, 37
			ldir
			; copy_file_name_fcb �̕��� replace_name �̃��[���ŏ����ւ���
			ld		b, 1 + 11					; �h���C�u�ԍ��������ŃR�s�[���Ă��܂��B�h���C�u�ԍ��� '?' �Ɉ�v���Ȃ��̂ŃR�s�[�����B
			ld		hl, replace_name
			ld		de, copy_file_name_fcb
		replace_loop:
			ld		a, [hl]
			cp		a, '?'
			jr		z, not_replace
			ld		[de], a
		not_replace:
			inc		hl
			inc		de
			djnz	replace_loop
			; DTA ���w��̃��[�N�ɍX�V����
			ld		de, [buffer_start]
			ld		c, _SETDTA
			call	bdos
			; �]�������I�[�v��
			ld		de, find_file_name_fcb
			ld		c, _FOPEN
			call	bdos
			; �]������I�[�v��
			ld		de, copy_file_name_fcb
			ld		c, _FMAKE
			call	bdos
			; ���R�[�h���� 1 �ɂ���
			ld		hl, 1
			ld		[find_file_name_fcb + 14], hl
			ld		[copy_file_name_fcb + 14], hl
			; �����_�����R�[�h�̐ݒ�
			dec		hl
			ld		[find_file_name_fcb + 33], hl
			ld		[copy_file_name_fcb + 33], hl
			ld		[find_file_name_fcb + 35], hl
			ld		[copy_file_name_fcb + 35], hl
			; �]�����̃T�C�Y(32bit)���擾
			ld		hl, [find_file_name_fcb + 16]
			ld		[remain_file_size + 0], hl
			ld		hl, [find_file_name_fcb + 18]
			ld		[remain_file_size + 2], hl
			; �]�����[�v
		loop2:
			ld		de, [buffer_size]
			ld		hl, remain_file_size + 3
			ld		a, [hl]
			dec		hl
			or		a, [hl]
			jr		nz, do_read						; �c��T�C�Y�� bit31�`bit16 �� ��0 �Ȃ� buffer_size �ڈ�t�ǂݍ��ށB
			dec		hl
			ld		a, [hl]
			dec		hl
			ld		l, [hl]
			ld		h, a
			sbc		hl, de
			jr		nc, do_read
			add		hl, de
			ex		de, hl
		do_read:
			; �ǂݍ���
			ex		de, hl
			ld		de, find_file_name_fcb
			ld		c, _RDBLK
			call	bdos
			push	hl
			; ��������
			ld		de, copy_file_name_fcb
			ld		c, _WRBLK
			call	bdos
			pop		hl
			or		a, a
			jp		nz, err_device_io
			; �c��e�ʂ��v�Z����
			ex		de, hl
			ld		hl, [remain_file_size]
			sbc		hl, de
			ld		[remain_file_size], hl
			ld		a, l
			or		a, h
			ld		de, 0
			ld		hl, [remain_file_size + 2]
			sbc		hl, de
			ld		[remain_file_size + 2], hl
			or		a, l
			or		a, h
			jr		nz, loop2
			; �t�@�C�������
			ld		de, find_file_name_fcb
			ld		c, _FCLOSE
			call	bdos
			ld		de, copy_file_name_fcb
			ld		c, _FCLOSE
			call	bdos
			; DTA �� find_file_name_fcb �֖߂��Ă���߂�
			ld		de, find_file_name_fcb
			ld		c, _SETDTA
			call	bdos
			ret
			endscope

; =============================================================================
;	COPY <�z��ϐ���> TO <�t�@�C����>
;	input:
;		HL .... �z��ϐ��̃A�h���X
;		DE .... �t�@�C����
;	output:
;		none
;	break:
;		all
;	comment:
;		�z��ϐ��̓��e���t�@�C���֏����o���B
;		�z��ϐ��̃T�C�Y�E�������E�v�f���̃t�B�[���h�͏����o���Ȃ��B
;		�ϐ��̒l���i�[����Ă���̈�̂ݕۑ�����B
;		[HL] --> [size:2][������:1][�v�f��1:2][�v�f��2:2]...[����]
;		�� [�t�B�[���h��:�o�C�g��]
; =============================================================================
			scope	sub_copy_array_to_file
file_size		= buf
array_data		= file_size + 2
fcb				= array_data + 2

sub_copy_array_to_file::
			ei
			push	de
			; �z��ϐ��̃T�C�Y�t�B�[���h�̃A�h���X�𓾂�
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; �T�C�Y���𓾂�
			ld		e, [hl]
			inc		hl
			ld		d, [hl]
			inc		hl
			; �������𓾂�
			ld		c, [hl]
			inc		hl
			ld		b, 0
			; �v�f���t�B�[���h��ǂݔ�΂�
			add		hl, bc
			add		hl, bc
			; �T�C�Y���v�Z
			ex		de, hl
			dec		hl			; �������t�B�[���h 1 �̕�
			or		a, a
			sbc		hl, bc
			sbc		hl, bc
			ld		[file_size], hl
			ld		[array_data], de
			; �t�@�C�����J��
			pop		hl			; �t�@�C����
			ld		de, fcb
			call	sub_fcreate
			or		a, a
			jp		nz, err_device_io
			; �t�@�C���֏����o��
			ld		bc, [file_size]
			ld		de, [array_data]
			ld		hl, fcb
			call	sub_fwrite
			; �t�@�C�������
			ld		de, fcb
			ld		c, _FCLOSE
			jp		bdos
			endscope

; =============================================================================
;	�z��ϐ��̎��̂̃A�h���X�ƃT�C�Y���v�Z
;	input:
;		HL .... �z��ϐ��̃A�h���X
;	output:
;		HL .... ���̂̃T�C�Y
;		DE .... ���̂̃A�h���X
; =============================================================================
			scope	sub_calc_array
sub_calc_array::
			; �z��ϐ��̃T�C�Y�t�B�[���h�̃A�h���X�𓾂�
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; �T�C�Y���𓾂�
			ld		e, [hl]
			inc		hl
			ld		d, [hl]
			inc		hl
			; �������𓾂�
			ld		c, [hl]
			inc		hl
			ld		b, 0
			; �v�f���t�B�[���h��ǂݔ�΂�
			add		hl, bc
			add		hl, bc
			; �T�C�Y���v�Z
			ex		de, hl
			dec		hl			; �������t�B�[���h 1 �̕�
			or		a, a
			sbc		hl, bc
			sbc		hl, bc
			ret
			endscope

; =============================================================================
;	COPY <�t�@�C����> TO <�z��ϐ���>
;	input:
;		HL .... �z��ϐ��̃A�h���X
;		DE .... �t�@�C����
;	output:
;		none
;	break:
;		all
;	comment:
;		�t�@�C����ǂݏo���Ĕz��ϐ��֓ǂݏo���B
;		�z��ϐ��̃T�C�Y�E�������E�v�f���̃t�B�[���h�͕ύX���Ȃ��B
;		�z��ϐ����傫�ȃt�@�C�����w�肳��Ă��A�z��ϐ��̃T�C�Y�������ǂ܂Ȃ��B
;		[HL] --> [size:2][������:1][�v�f��1:2][�v�f��2:2]...[����]
;		�� [�t�B�[���h��:�o�C�g��]
; =============================================================================
			scope	sub_copy_file_to_array
file_size		= buf
array_data		= file_size + 2
fcb				= array_data + 2

sub_copy_file_to_array::
			ei
			push	de
			call	sub_calc_array
			ld		[file_size], hl
			ld		[array_data], de
			; �t�@�C�����J��
			pop		hl			; �t�@�C����
			ld		de, fcb
			call	sub_fopen
			or		a, a
			jp		nz, err_device_io
			; �t�@�C������ǂݏo��
			ld		bc, [file_size]
			ld		de, [array_data]
			ld		hl, fcb
			call	sub_fread
			; �t�@�C�������
			ld		de, fcb
			ld		c, _FCLOSE
			jp		bdos
			endscope

; =============================================================================
;	ARG�̌v�Z
;	input:
;		NX(0xF56A:2) ...... X2
;		NY(0xF56C:2) ...... Y2
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_set_arg
sub_set_arg::
			ld		b, 0
			; NY �̕�������
			ld		hl, [BBT_NY]
			ld		a, h
			rlca
			jr		nc, skip1
			inc		b
			inc		b
			xor		a, a
			ld		e, a
			ld		d, a
			ex		de, hl
			sbc		hl, de
			ld		[BBT_NY], hl
		skip1:
			; NX �̕�������
			ld		hl, [BBT_NX]
			ld		a, h
			rlca
			jr		nc, skip2
			inc		b
			xor		a, a
			ld		e, a
			ld		d, a
			ex		de, hl
			sbc		hl, de
			ld		[BBT_NX], hl
		skip2:
			ld		a, b
			rlca
			rlca
			ld		[BBT_ARG], a
			ret
			endscope

; =============================================================================
;	VDP COMMAND�̑I��
;	input:
;		SX(0xF562:2) ...... X1
;		NX(0xF56A:2) ...... X2
;		DX(0xF566:2) ...... X3
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_set_command
sub_set_command::
			ld			a, [BBT_LOGOP]
			or			a, a
			jr			z, _set_command
			; TPSET �ł͂Ȃ��̂ŁA��ɘ_���]��(LMMM)
	_lmmm:
			ld			a, 0x90
			ld			[BBT_LOGOP], a
			ret
	_set_command:
			; SCREEN5, 7 �� 0b00000001		0101 0111
			; SCREEN6 ��    0b00000011		0110
			; SCREEN8 ��    0b00000000		1000
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _hmmm			; SCREEN8�ȏ�� HMMM
			rrca
			ld			a, 3				; SCREEN6
			jr			nc, _skip
			rrca
	_skip:
			ld			b, a
			ld			hl, BBT_SX
			ld			a, [hl]
			inc			hl
			inc			hl
			or			a, [hl]
			inc			hl
			inc			hl
			or			a, [hl]
			and			a, b
			jr			nz, _lmmm
	_hmmm:
			ld			a, 0xD0
			ld			[BBT_LOGOP], a
			ret
			endscope

; =============================================================================
;	Wait VDP Command
;	input:
;		none
;	output:
;		none
;	break:
;		all
;	comment:
;		VDP�R�}���h���I���܂ő҂�
; =============================================================================
			scope	sub_wait_vdp_command
sub_wait_vdp_command::
			ld			bc, 0x8F00 | vdpport1
			; R#15 = 2
	_loop:
			ld			a, 2
			di
			out			[c], a
			out			[c], b
			in			a, [c]
			ld			d, a
			; R#15 = 0
			xor			a, a
			out			[c], a
			out			[c], b
			ei
			rrc			d
			ret			nc
			jr			_loop
			endscope

; =============================================================================
;	COPY (X1,Y1)-STEP(X2,Y2),SPAGE TO (X3,Y3),DPAGE,LOP
;	input:
;		SX(0xF562:2) ...... X1
;		SY(0xF564:2) ...... Y1, SPAGE
;		DX(0xF566:2) ...... X3
;		DY(0xF568:2) ...... Y3, DPAGE
;		NX(0xF56A:2) ...... X2
;		NY(0xF56C:2) ...... Y2
;		LOGOP(0xF570:1) ... LOP
;	output:
;		none
;	break:
;		all
;	comment:
;		ARG �́ANX, NY �̕������玩���ݒ肳���
; =============================================================================
			scope	sub_copy_pos_to_pos
sub_copy_pos_to_pos::
			call		sub_set_arg
			call		sub_set_command
			call		sub_wait_vdp_command
			; R#17 = 32
			ld			a, 32
			di
			out			[vdpport1], a
			ld			a, 0x80 | 17
			out			[vdpport1], a
			ld			b, 46 - 32 + 1
			inc			c
			inc			c
			ld			hl, BBT_SX
			otir
			ei
			ret
			endscope

; =============================================================================
;	COPY (X1,Y1)-STEP(X2,Y2),SPAGE TO ARRAY
;	input:
;		HL ................ �z��ϐ��̃A�h���X
;		SX(0xF562:2) ...... X1
;		SY(0xF564:2) ...... Y1, SPAGE
;		DX(0xF566:2) ...... X3
;		DY(0xF568:2) ...... Y3, DPAGE
;		NX(0xF56A:2) ...... X2
;		NY(0xF56C:2) ...... Y2
;	output:
;		none
;	break:
;		all
;	comment:
;		ARG �́ANX, NY �̕������玩���ݒ肳���
; =============================================================================
			scope	sub_copy_pos_to_array
array_address	= BBT_LOGOP + 1
array_size		= array_address + 2
sub_copy_pos_to_array::
			; �z��̃A�h���X�E�T�C�Y���v�Z
			call		sub_calc_array
			ld			[array_size], hl
			ld			[array_address], de
			; ARG���v�Z (NX, NY �̕����̏���)
			call		sub_set_arg
			; �T�C�Y���v�Z (pixel count)
			call		sub_get_byte_size
			ld			de, [array_size]
			ex			de, hl
			or			a, a
			ld			bc, 4
			sbc			hl, bc					; �T�C�Y���
			jp			c, err_illegal_function_call		; 4byte�ɖ����Ȃ��ꍇ�G���[
			rst			0x20					; CP HL, DE  : �z��T�C�Y, ��f��(byte���Z)
			jp			c, err_illegal_function_call		; �z��̃T�C�Y�̕����������ꍇ�̓G���[
			push		de						; ��f��(byte���Z) ��ۑ�
			; VDP Command ���Z�b�g
			ld			a, 0b10100000			; LMCM
			ld			[BBT_LOGOP], a
			call		sub_wait_vdp_command
			; R#17 = 32
			ld			a, 32
			di
			out			[vdpport1], a
			ld			a, 0x80 | 17
			out			[vdpport1], a
			ld			b, 46 - 32 + 1
			inc			c
			inc			c
			ld			hl, BBT_SX
			otir
			ei
			; �T�C�Y�����L�^
			ld			hl, [array_address]
			ld			de, [BBT_NX]
			ld			[hl], e
			inc			hl
			ld			[hl], d
			inc			hl
			ld			de, [BBT_NX]
			ld			[hl], e
			inc			hl
			ld			[hl], d
			inc			hl
			; ��ʃ��[�h�ŕ���
			pop			de					; ��f��(byte���Z) �𕜋A
			ld			c, vdpport1
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _screen8over
			rrca
			jr			nc, _screen6
		_screen5or7:
			push		hl
			call		sub_vdpcmd_get_one_pixel
			add			a, a
			add			a, a
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			pop			hl
			ld			[hl], a
			inc			hl
			dec			de
			ld			a, e
			or			a, d
			jr			nz, _screen5or7
			jr			_finish
		_screen8over:
			call		sub_vdpcmd_get_one_pixel
			ld			[hl], a
			inc			hl
			dec			de
			ld			a, e
			or			a, d
			jr			nz, _screen8over
			jr			_finish
		_screen6:
			push		hl
			call		sub_vdpcmd_get_one_pixel
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			add			a, a
			add			a, a
			pop			hl
			ld			[hl], a
			inc			hl
			dec			de
			ld			a, e
			or			a, d
			jr			nz, _screen6
		_finish:
			ld			a, 0
			di
			out			[c], a
			ld			a, 0x80 | 46
			out			[c], a
			ei
			ret
			; TR�r�b�g�� CE�r�b�g�̃`�F�b�N�͍s��Ȃ��BVDP�̕��������B
			; C = vdpport1, B = �j��, A = �Q�b�g�����l
sub_vdpcmd_get_one_pixel::
			ld			a, 7
			di
			out			[c], a
			ld			a, 0x8F
			out			[c], a
			in			b, [c]
			xor			a, a
			out			[c], a
			ld			a, 0x8F
			out			[c], a
			ei
			ld			a, b
			ret

sub_get_byte_size::
			ld			bc, [BBT_NX]
			ld			de, [BBT_NY]
			call		sub_umul
			; �T�C�Y���r
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _adjust_end
			ccf
			inc			hl						; �������J��グ
			rr			h
			rr			l
			rrca
			jr			c, _adjust_end
			inc			hl						; �������J��グ
			or			a, a
			rr			h
			rr			l
		_adjust_end:
			ret
			endscope

; =============================================================================
;	COPY ARRAY,DIR TO (X3,Y3), DPAGE,LOP
;	input:
;		HL ................ �z��ϐ��̃A�h���X
;		A ................. DIR
;		DX(0xF566:2) ...... X3
;		DY(0xF568:2) ...... Y3, DPAGE
;		LOGOP(0xF570:1) ... LOP
;	output:
;		none
;	break:
;		all
;	comment:
;		DIR
;			0: �n�_(DX, DY)
;			1: �n�_(DX, DY) ���E���]
;			2: �n�_(DX, DY) �㉺���]
;			3: �n�_(DX, DY) �㉺���E���]
;			4: �n�_(DX, DY)
;			5: �n�_(DX+NX-1,DY) ���E���]
;			6: �n�_(DX,DY+NY-1) �㉺���]
;			7: �n�_(DX+NX-1,DY+NY-1) �㉺���E���]
; =============================================================================
			scope		sub_copy_array_to_pos
array_size		= BBT_LOGOP + 1
array_address	= array_size + 2

sub_copy_array_to_pos::
			; �z��̃A�h���X�E�T�C�Y���v�Z
			ld			[BBT_ARG], a
			call		sub_calc_array
			ld			[array_size], hl
			ld			[array_address], de
			; NX, NY ��ݒ�
			ex			de, hl
			ld			c, [hl]
			inc			hl
			ld			b, [hl]
			inc			hl
			ld			[BBT_NX], bc
			ld			e, [hl]
			inc			hl
			ld			d, [hl]
			inc			hl
			ld			[BBT_NY], de
			push		hl
			call		sub_umul
			ld			c, l
			ld			b, h				; BC = ��f��
			ld			a, [BBT_ARG]
			call		sub_adjust_dir
			pop			hl
			; �R�}���h�ݒ�
			ld			a, [BBT_LOGOP]
			or			a, 0b1011_0000		; LMMC
			ld			[BBT_LOGOP], a
			; BPP
			dec			bc
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _screen8over
			rrca
			jr			c, _screen5or7
		_screen6:
			ld			d, [hl]
			rlc			d
			rlca
			rlc			d
			rlca
			ld			[BBT_CLR], a
			call		_run_command
			ld			a, c
			or			a, b
			jr			z, _finish
			jr			_screen6_start
		_screen6_loop:
			ld			d, [hl]
			rlc			d
			rlca
			rlc			d
			rlca
			out			[vdpport3], a
			dec			bc
			ld			a, c
			or			a, b
			jr			z, _finish
		_screen6_start:
			rlc			d
			rlca
			rlc			d
			rlca
			out			[vdpport3], a
			dec			bc
			ld			a, c
			or			a, b
			jr			z, _finish
			rlc			d
			rlca
			rlc			d
			rlca
			out			[vdpport3], a
			dec			bc
			ld			a, c
			or			a, b
			jr			z, _finish
			rlc			d
			rlca
			rlc			d
			rlca
			out			[vdpport3], a
			inc			hl
			dec			bc
			ld			a, c
			or			a, b
			jr			nz, _screen6_loop
			jr			_finish

		_screen5or7:
			ld			a, [hl]
			rlca
			rlca
			rlca
			rlca
			ld			[BBT_CLR], a
			call		_run_command
			ld			a, c
			or			a, b
			jr			z, _finish
			jr			_screen5or7_start
		_screen5or7_loop:
			ld			a, [hl]
			rlca
			rlca
			rlca
			rlca
			out			[vdpport3], a
			dec			bc
			ld			a, c
			or			a, b
			jr			z, _finish
		_screen5or7_start:
			ld			a, [hl]
			out			[vdpport3], a
			inc			hl
			dec			bc
			ld			a, c
			or			a, b
			jr			nz, _screen5or7_loop
		_finish:
			ld			a, 0
			di
			out			[c], a
			ld			a, 0x80 | 46
			out			[c], a
			ei
			ret

		_screen8over:
			ld			a, [hl]
			inc			hl
			ld			[BBT_CLR], a
			call		_run_command
			ld			a, c
			or			a, b
			jr			z, _finish
		_screen8_loop:
			ld			a, [hl]
			out			[vdpport3], a
			inc			hl
			dec			bc
			ld			a, c
			or			a, b
			jr			nz, _screen8_loop
			jr			_finish

		_run_command:
			; R#17 = 36 (�I�[�g�C���N�������g)
			push		hl
			push		bc
			ld			a, 36
			di
			out			[vdpport1], a
			ld			a, 0x80 | 17
			out			[vdpport1], a
			ld			b, 46 - 36 + 1
			ld			c, vdpport3
			ld			hl, BBT_DX
			otir
			; R#17 = 44 (��I�[�g�C���N�������g)
			ld			a, 0x80 | 44
			out			[vdpport1], a
			ld			a, 0x80 | 17
			out			[vdpport1], a
			ei
			pop			bc
			pop			hl
			ret
			endscope

; =============================================================================
;	COPY (X1,Y1)-STEP(X2,Y2),SPAGE TO FILE
;	input:
;		HL ....................... �t�@�C�����̃A�h���X
;		buffer_start(0xF55E:2) ... �o�b�t�@�[�̐擪�A�h���X�i���̃A�h���X�͊܂ށj
;		buffer_end(0xF560:2) ..... �o�b�t�@�[�̏I���A�h���X�i���̃A�h���X�͊܂܂Ȃ��j
;		SX(0xF562:2) ............. X1
;		SY(0xF564:2) ............. Y1, SPAGE
;		DX(0xF566:2) ............. X3
;		DY(0xF568:2) ............. Y3, DPAGE
;		NX(0xF56A:2) ............. X2
;		NY(0xF56C:2) ............. Y2
;	output:
;		none
;	break:
;		all
;	comment:
;		ARG �́ANX, NY �̕������玩���ݒ肳���
;		buffer_start�ȏ�Abuffer_end�����͈̔͂��t�@�C���������ݗp�̃o�b�t�@�Ƃ���
;		�g�p����B
; =============================================================================
			scope	sub_copy_pos_to_file
buffer_start	= buf					; F55E
buffer_end		= buffer_start + 2		; F560
buffer_size		= BBT_LOGOP + 2
remain_size		= buffer_size + 2		; �������ނׂ��c�� byte��
transfer_size	= remain_size + 2
fcb				= transfer_size + 2
sub_copy_pos_to_file::
			; �o�b�t�@�[�T�C�Y���v�Z
			push		hl
			ld			hl, [buffer_end]
			ld			de, [buffer_start]
			or			a, a
			sbc			hl, de
			ld			[buffer_size], hl
			; ARG���v�Z (NX, NY �̕����̏���)
			call		sub_set_arg
			; �t�@�C�����J��
			pop			hl
			ld			de, fcb
			call		sub_fcreate
			or			a, a
			jp			nz, err_device_io
			; �T�C�Y���������o��
			ld			hl, fcb
			ld			de, BBT_NX
			ld			bc, 4
			call		sub_fwrite
			; �T�C�Y���v�Z (pixel count)
			call		sub_get_byte_size
			ld			[remain_size], hl
			; VDP Command ���Z�b�g
			ld			a, 0b10100000			; LMCM
			ld			[BBT_LOGOP], a
			call		sub_wait_vdp_command
			; R#17 = 32
			ld			a, 32
			di
			out			[vdpport1], a
			ld			a, 0x80 | 17
			out			[vdpport1], a
			ld			b, 46 - 32 + 1
			inc			c
			inc			c
			ld			hl, BBT_SX
			otir
			ei
			; ��ʃ��[�h�ŕ���
			ld			c, vdpport1
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _screen8over
			rrca
			jr			nc, _screen6
		_screen5or7:
			call		_calc_transfer_size
		_screen5or7_loop:
			push		hl
			call		sub_vdpcmd_get_one_pixel		; A�ɃQ�b�g�����l, C�� vdpport1 ���Z�b�g���ČĂԁBB�͔j��
			add			a, a
			add			a, a
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			pop			hl
			ld			[hl], a
			inc			hl
			dec			de
			ld			a, e
			or			a, d
			jr			nz, _screen5or7_loop
			; �t�@�C���ɏ����o��
			ld			hl, fcb
			ld			de, [buffer_start]
			ld			bc, [transfer_size]
			call		sub_fwrite
			; �c�肪���邩�`�F�b�N
			ld			de, [remain_size]
			ld			a, e
			or			a, d
			jr			nz, _screen5or7
			jr			_finish
		_screen8over:
			call		_calc_transfer_size
		_screen8over_loop:
			call		sub_vdpcmd_get_one_pixel
			ld			[hl], a
			inc			hl
			dec			de
			ld			a, e
			or			a, d
			jr			nz, _screen8over_loop
			; �t�@�C���ɏ����o��
			ld			hl, fcb
			ld			de, [buffer_start]
			ld			bc, [transfer_size]
			call		sub_fwrite
			; �c�肪���邩�`�F�b�N
			ld			de, [remain_size]
			ld			a, e
			or			a, d
			jr			nz, _screen8over
			jr			_finish
		_screen6:
			call		_calc_transfer_size
		_screen6_loop:
			push		hl
			call		sub_vdpcmd_get_one_pixel
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			add			a, a
			add			a, a
			ld			l, a
			call		sub_vdpcmd_get_one_pixel
			or			a, l
			add			a, a
			add			a, a
			pop			hl
			ld			[hl], a
			inc			hl
			dec			de
			ld			a, e
			or			a, d
			jr			nz, _screen6_loop
			; �t�@�C���ɏ����o��
			ld			hl, fcb
			ld			de, [buffer_start]
			ld			bc, [transfer_size]
			call		sub_fwrite
			; �c�肪���邩�`�F�b�N
			ld			de, [remain_size]
			ld			a, e
			or			a, d
			jr			nz, _screen6
		_finish:
			ld			a, 0
			di
			out			[c], a
			ld			a, 0x80 | 46
			out			[c], a
			ei
			ld			hl, fcb
			call		sub_fclose
			ret
			; �]���T�C�Y���v�Z����
	_calc_transfer_size:
			ld			hl, [buffer_size]
			ld			de, [remain_size]
			rst			0x20
			jr			nc, _small_remain_size		; buffer_size �� remain_size �Ȃ� _small_remain_size ��
			; buffer_size < remain_size �̏ꍇ
			ld			[transfer_size], hl			; �]���T�C�Y = buffer_size
			ccf
			ex			de, hl
			sbc			hl, de
			ld			[remain_size], hl			; remain_size ���� buffer_size ���팸 (transfer_size �ֈړ�)
			ld			de, [transfer_size]
			ld			hl, [buffer_start]
			ret
	_small_remain_size:
			ld			[transfer_size], de			; �]���T�C�Y = remain_size
			ld			hl, 0
			ld			[remain_size], hl			; remain_size �� 0 �ɂ��� (transfer_size �֑S�Ĉړ�)
			ld			de, [transfer_size]
			ld			hl, [buffer_start]
			ret
			endscope

; =============================================================================
;	DIR �ɑΉ����� ARG �̐ݒ�ƁADX, DY �̈ʒu����
;	input:
;		A ................. DIR
;		DX(0xF566:2) ...... X3
;		DY(0xF568:2) ...... Y3, DPAGE
;		NX(0xF56A:2) ...... X2
;		NY(0xF56C:2) ...... Y2
;	output:
;		none
;	break:
;		AF, DE, HL
;	comment:
;		DIR
;			0: �n�_(DX, DY)
;			1: �n�_(DX, DY) ���E���]
;			2: �n�_(DX, DY) �㉺���]
;			3: �n�_(DX, DY) �㉺���E���]
;			4: �n�_(DX, DY)
;			5: �n�_(DX+NX-1,DY) ���E���]
;			6: �n�_(DX,DY+NY-1) �㉺���]
;			7: �n�_(DX+NX-1,DY+NY-1) �㉺���E���]
; =============================================================================
			scope		sub_adjust_dir
sub_adjust_dir::
			; DIR �ɉ����Ĕ�����
			bit			2, a
			jr			z, _skip_adjust
			; ���������̔�����
		_adjust_x:
			bit			0, a
			jr			z, _adjust_y
			ld			hl, [BBT_DX]
			ld			de, [BBT_NX]
			add			hl, de
			dec			hl
			ld			[BBT_DX], hl
		_adjust_y:
			bit			1, a
			jr			z, _skip_adjust
			ld			hl, [BBT_DY]
			ld			de, [BBT_NY]
			add			hl, de
			dec			hl
			ld			[BBT_DY], hl
		_skip_adjust:
			rlca
			rlca
			and			a, 0b0000_1100
			ld			[BBT_ARG], a
			ret
			endscope

; =============================================================================
;	UMUL  HL = BC * DE
;	input:
;		BC ..... �|�����鐔
;		DE ..... �|���鐔
;	output:
;		HL ..... BC * DE
;	break:
;		all
;	comment:
;		�����ӂ�͋N����Ȃ��l���ݒ肳��Ă���O��
; =============================================================================
			scope	sub_umul
sub_umul::
			ld		hl, 0
		loop:
			srl		d
			rr		e
			jr		nc, skip_add
			add		hl, bc
		skip_add:
			sla		c
			rl		b
			ld		a, d
			or		e
			jr		nz, loop
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

			scope	public_data
data_crlf::
			db		2, 0x0A, 0x0D
wildcard_all::
			db		3, "*.*"
			endscope
