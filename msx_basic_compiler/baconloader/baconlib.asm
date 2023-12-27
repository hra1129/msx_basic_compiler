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
errhand		:= 0x406F					; BIOS の BASICエラー処理ルーチン E にエラーコード。戻ってこない。
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
fnkstr		:= 0xF87F					; ファンクションキーの文字列 16文字 x 10個
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
;		sub_xxxx なアドレスは、今後の修正などで変更になる恐れがありますので、
;		blib_entries にある blib_xxxx を CALL すること。
;		ここのアドレス値は維持されます。
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
;	ROMカートリッジで用意した場合の初期化ルーチン
;	bacon_loader でロードした場合も、ロード時にここが呼ばれる
; =============================================================================
init_address::
			scope	update_blibslt
			; BLIBSLOT を更新する
			; -- プライマリスロットレジスタを読んで、Page1 のスロットを得る
			call	rslreg				; Get Primary Slot Register
			rrca
			rrca
			and		a, 0b0000_0011
			ld		b, a
			; -- そのスロットが拡張されているか調べる
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
;		A ... DOSバージョン, 0: DOS無し, 1: DOS1, 2: DOS2
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
			; DOSバージョンを調べる
			ld		c, _dosver
			call	bdos
			or		a, a						; エラー発生 (DOS1でもDOS2でもない) か？
			jr		z, _s1
			xor		a, a						; DOSが無い場合は、A=0
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
;		MSX-BASIC の KEY LIST 相当の動作
; =============================================================================
			scope	sub_key_list
sub_key_list::
			ei
			ld		hl, fnkstr			; ファンクションキー文字列の場所
			ld		de, 16				; 1つのキーは 16文字
			ld		b, 10				; 10個のキーを表示する
	_loop_key:
			push	hl
	_loop_char:
			ld		a, [hl]
			inc		hl
			or		a, a
			jr		z, _exit_char
			cp		a, 2				; グラフィック文字のプレコード以外のコントロール文字は置換する
			jr		c, _no_replace
			cp		a, 32
			jr		nc, _no_replace
			ld		a, 32				; スペースに置換
	_no_replace:
			rst		0x18				; 1文字表示。レジスタ全保存。
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
;		HL ... デバイスパス文字列 (BASIC形式)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		デバイスパス文字列を送信する。
; =============================================================================
			scope	_send_device_path
_send_device_path::
			ld		c, 8
			; デバイスパス送信開始コマンド
			ld		a, 0xe0
			out		[c], a
			ld		a, 1
			out		[c], a
			ld		a, 0x53
			out		[c], a
			; このまま _send_string へ続く
			endscope

; =============================================================================
;	_send_string
;	input:
;		HL ... 送信文字列 (BASIC形式)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		送信文字列を送信する。
; =============================================================================
			scope	_send_string
_send_string::
			ld		a, 0xc0
			out		[c], a
			; 文字列の長さを取得
			ld		a, [hl]
	_iot_send_string_loop1:
			ld		b, a
			cp		a, 64							; 64文字以上の場合は特別処理を実施する
			jr		c, _iot_send_string_skip
			sub		a, 63
			ld		b, 0x7f							; 特別処理を示すコード
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
			rlca									; エラーなら cf = 1, 正常なら cf = 0
			ret		nc
			; エラー
			ld		e, error_device_IO
			ld		ix, errhand
			jp		calbas
			endscope

; =============================================================================
;	CALL IOTGET( DEVPATH$, INT_VAR )
;	input:
;		HL ... デバイスパス文字列 (BASIC形式)
;	output:
;		HL
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC の _IOTGET( HL, DE ) 相当の動作
; =============================================================================
			scope	sub_iotget_int
sub_iotget_int::
			ei
			call	_send_device_path
			; 受信コマンド送信
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; 整数型識別コード送信
			ld		a, 0x01
			out		[c], a
			; 受信開始
			ld		a, 0x80
			out		[c], a
			in		a, [c]				; 多分長さ 2 が返ってくる
			in		l, [c]
			in		h, [c]
			ret
			endscope

; =============================================================================
;	CALL IOTGET( DEVPATH$, STR_VAR$ )
;	input:
;		HL ... デバイスパス文字列 (BASIC形式)
;	output:
;		HL ... 得られた文字列のアドレス (BASIC形式)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC の _IOTGET( HL, DE ) 相当の動作
; =============================================================================
			scope	sub_iotget_str
sub_iotget_str::
			ei
			call	_send_device_path
			; 受信コマンド送信
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; 文字列型識別コード送信
			ld		a, 0x03
			out		[c], a
			; 受信開始
			ld		a, 0x80
			out		[c], a
			in		b, [c]				; 文字列の長さ
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
;		HL ... デバイスパス文字列 (BASIC形式)
;		DE ... 送信する数値
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC の _IOTPUT( HL, DE ) 相当の動作
; =============================================================================
			scope	sub_iotput_int
sub_iotput_int::
			ei
			push	de
			call	_send_device_path
			; 受信コマンド送信
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; 整数型識別コード送信
			ld		a, 0x41
			out		[c], a
			; 送信開始
			pop		de
			ld		a, 0xc0
			out		[c], a
			ld		a, 0x02			; 長さ 2
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
;		HL ... デバイスパス文字列 (BASIC形式)
;		DE ... 送信する文字列 (BASIC形式)
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		IoT-BASIC の _IOTPUT( HL, DE ) 相当の動作
; =============================================================================
			scope	sub_iotput_str
sub_iotput_str::
			ei
			push	de
			call	_send_device_path
			; 受信コマンド送信
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; 文字列型識別コード送信
			ld		a, 0x43
			out		[c], a
			; 送信開始
			pop		hl
			jp		_send_string
			endscope

; =============================================================================
;	STRCMP
;	input:
;		HL ... 文字列1 (BASIC形式)
;		DE ... 文字列2 (BASIC形式)
;	output:
;		HL < DE ... C = 1, Z = 0
;		HL = DE ... C = 0, Z = 1
;		HL > DE ... C = 0, Z = 0
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		文字列 HL - DE を求める
; =============================================================================
			scope	sub_strcmp
sub_strcmp::
			ld		b, [hl]				; B = [HL] の長さ
			ld		a, [de]				; C = [DE] の長さ
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
			; C がまだ残っているので HL < DE と判断。
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
;		HL .... 入力された文字 (BASIC形式)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		何も入力されていなければ "" が返る
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
;		HL .... STR$ (BASIC形式)
;		C ..... 文字数 N
;	output:
;		HL .... 切り取られた文字列 (BASIC形式)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		何も入力されていなければ "" が返る
; =============================================================================
			scope	sub_right
sub_right::
			ex		de, hl
			ld		hl, buf
			ld		[hl], c
			inc		c
			dec		c
			ret		z				; もし、N=0 なら長さ 0 の文字列を返す

			ld		a, [de]			; 文字列の長さ
			inc		de
			cp		a, c			; もし、STR$の長さよりも N の方が大きければ、まるまる返す
			jr		nc, skip
			ld		c, a
			ld		[hl], c			; 長さを更新
	skip:

			ex		de, hl			; HL = ターゲット文字列, DE = BUF
			sub		a, c			; A = 文字列長 - N  ※かならず0以上。負にはならない。
			ld		e, a			; DE = 文字列長 - N
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
;		HL .... STR$ (BASIC形式)
;		C ..... 文字数 N
;	output:
;		HL .... 切り取られた文字列 (BASIC形式)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		何も入力されていなければ "" が返る
; =============================================================================
			scope	sub_left
sub_left::
			ex		de, hl			; DE = STR$
			ld		hl, buf			; HL = BUF
			ld		[hl], c			; 切り取る長さを設定
			inc		c
			dec		c
			ret		z				; もし、N=0 なら長さ 0 の文字列を返す

			ld		a, [de]			; 文字列の長さ
			inc		de
			cp		a, c			; もし、STR$の長さよりも N の方が大きければ、まるまる返す
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
;		HL .... STR$ (BASIC形式)
;		B ..... 位置 N (先頭の文字は 1)
;		C ..... 文字数 M (切り出し長)
;	output:
;		HL .... 切り取られた文字列 (BASIC形式)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		何も入力されていなければ "" が返る
; =============================================================================
			scope	sub_mid
sub_mid::
			ld		a, [hl]
			cp		a, b
			jr		c, ret_blank			; 位置が右からはみ出してる場合は空文字列を返す
			or		a, a
			jr		z, ret_blank			; そもそも空文字列が指定されてる場合は空文字列を返す
			inc		c
			dec		c
			jr		z, ret_blank			; そもそも 切り出し長 0 が指定されてる場合は空文字列を返す

			; 切り出し先頭位置へ移動
			ld		e, b
			ld		d, 0
			add		hl, de					; HL = HL + (B - 1) + 1    : 文字列長を示す 1byte のフィールドがあるので +1

			; 残りの文字数と、文字数 M を比較する
			dec		b
			sub		a, b
			jr		z, ret_blank			; 残りの文字数が 0 なら空文字列を返す
			cp		a, c
			jr		nc, skip				; 残りの文字数の方が少なかった場合は、そのまま。多かった場合は、切り出し長を残りの文字数に置換
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
;		A ..... VDP()レジスタ番号 n
;		B ..... 書き込むデータ
;	output:
;		none
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		n は、BASIC の VDP(n) の n である。V9938/9958 の R#x, S#y の x や y じゃない
;		ので注意すること。
;		n が、存在しない番号の場合、何もせずに戻る。
; =============================================================================
			scope	sub_wrvdp
sub_wrvdp::
			cp		a, 8
			ret		z				; n = 8 の場合は何もしない
			ccf
			sbc		a, 0
			ld		c, a
			jp		wrtvdp
			endscope

; =============================================================================
;	m = VDP( n )
;	input:
;		A ..... VDP()レジスタ番号 n
;	output:
;		HL .... 読み出したデータ
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		n は、BASIC の VDP(n) の n である。V9938/9958 の R#x, S#y の x や y じゃない
;		ので注意すること。
;		n が、存在しない番号の場合、A に不定を返す。
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
;		L ..... 設定する幅 n
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
			; 幅に変更があるか調べる
			ld		a, [linlen]
			cp		a, l
			ret		z					; 変更が無ければ何もしない
			; MSX1か？
			ld		a, [romver]
			or		a, a
			jr		nz, _skip0
			; 幅40まで
			ld		a, l
			or		a, a
			jp		z, err_illegal_function_call
			cp		a, 41
			jp		nc, err_illegal_function_call
		_skip0:
			; 画面モードを調べる
			ld		a, [oldscr]
			or		a, a
			ld		a, l
			jr		z, _skip1
			; SCREEN0 でなければ 幅32まで
			cp		a, 33
			jp		nc, err_illegal_function_call
		_skip1:
			; SCREEN0 なら 幅80まで
			cp		a, 81
			jp		nc, err_illegal_function_call
		_skip2:
			; 画面クリア
			ld		a, 0x0C
			rst		0x18
			; 幅更新
			ld		a, l
			ld		[linlen], a
			call	update_clmlst
			; 画面モードチェック
			ld		a, [oldscr]
			dec		a
			ld		a, l
			jr		nz, _skip3
			; SCREEN1 の場合
			ld		[linl32], a
			; 画面クリア
			ld		a, 0x0C
			rst		0x18
			ret
		_skip3:
			; SCREEN0 の場合
			ld		a, [linl40]
			ld		h, 41
			cp		a, h
			ld		a, l
			ld		[linl40], a
			; 画面クリア
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
			; CHGMDP で SCREEN0 のモードセット
			xor		a, a
			ld		ix, chgmdp
			jp		extrom

			; clmlst 更新
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
;		HL ...	X位置 (0～511)
;		E ....	Y位置 (0～255)
;		D ....	MaskMode
;		B ....	PageMode
;		A ....	bit0: X位置 有効1, 無効0
;				bit1: Y位置 有効1, 無効0
;				bit2: MaskMode 有効1, 無効0
;				bit3: PageMode 有効1, 無効0
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
			; 垂直スクロール位置 R#23
			and		a, 0x02
			ld		[buf+0], a
			ld		a, e
			ld		[buf+1], a
			; 水平スクロール位置 R#26, R#27
			ld		a, c
			and		a, 0x01
			ld		[buf+2], a
			ld		[buf+3], hl
			; マスクモード
			ld		a, c
			and		a, 0x04
			ld		[buf+5], a
			ld		a, d
			ld		[buf+6], a
			; ページモード
			ld		a, c
			and		a, 0x08
			ld		[buf+7], a
			ld		a, b
			ld		[buf+8], a
			; 垂直スクロール位置 R#23
			ld		a, [buf+0]
			or		a, a
			jr		z, _skip_r23
			ld		a, [buf+1]
			ld		c, 23
			ld		b, a
			call	wrtvdp
		_skip_r23:
			; 水平スクロール位置 R#26, R#27
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
			; マスクモード、ページモード R#25
			ld		a, [buf+5]
			ld		c, a
			ld		a, [buf+7]
			or		a, c
			ret		z						; マスクもページも指定無しなら何もしない
			; R#25 の現在の値を保持
			ld		a, [rg25sav]
			ld		b, a
			and		a, 0xFC
			ld		c, a					; C = XXXX_XX00
			ld		a, b
			and		a, 0x03
			ld		b, a					; B = 0000_00XX
			; マスクモードの更新
			ld		a, [buf+5]
			or		a, a
			jr		z, _skip_r25_mask		; マスクの指定が省略ならスルー
			ld		a, b
			and		a, 0b1111_1101
			ld		b, a
			ld		a, [buf+6]
			or		a, a
			jr		z, _skip_r25_mask
			inc		b
			inc		b
		_skip_r25_mask:
			; ページモード
			ld		a, [buf+7]
			or		a, a
			jr		z, _skip_r25_page		; ページの指定が省略ならスルー
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
;		E ..... スプライト番号
;		HL .... セットする文字列 (BASIC形式)
;	output:
;		HL .... スプライトジェネレーターテーブルのアドレス
;	break:
;		all
;	comment:
;		set page で描画ページに指定されている方（つまり書き込み対象の方）の
;		アドレスを返す。
;		文字列が短い場合、足りない分は 00h が詰められる。
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

			; VRAMアドレスを設定
			ld		a, [romver]
			or		a, a
			jr		z, _skip0
			call	nstwrt
			jr		_skip1
		_skip0:
			call	setwrt
		_skip1:

			; 1スプライトのサイズは、8x8 なら 8byte, 16x16 なら 32byte
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

			; 文字列を流し込む
			pop		hl
			ld		c, [hl]				; 文字列長
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
;		A ..... スプライト番号
;		B ..... X座標
;		C ..... Y座標
;		D ..... 色
;		E ..... パターン番号
;		L ..... パラメータ有効フラグ (0:無効, 1:有効)
;		        bit0: 座標
;		        bit1: パターン番号
;		        bit2: 色
;	output:
;		none
;	break:
;		all
;	comment:
;		スプライトモード2であれば、CCビットが立っているスプライトを一緒に動かす
; =============================================================================
			scope	sub_putsprite
sub_putsprite::
			ei
			ld		h, a				; H = スプライト番号
			ld		a, [scrmod]
			dec		a
			cp		a, 12
			jp		nc, err_syntax
			cp		a, 3
			jr		nc, _sprite_mode2
	_sprite_mode1:
			; スプライトアトリビュートを求める
			ld		a, h				; A = スプライト番号
			push	de					; パターンと色保存
			push	hl					; フラグ保存
			call	calatr
			pop		de					; フラグ復帰
			ld		a, e				; A = フラグ
			; 座標指定
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
			out		[vdpport0], a		; Y座標
			ld		a, b
			out		[vdpport0], a		; X座標
			ld		a, e
	_skip_pos1:
			inc		hl
			inc		hl
			; パターン
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
			add		a, a				; 16x16 の場合は、4倍する
			add		a, a
	_skip_pat1_0:
			out		[vdpport0], a		; パターン
			ld		a, e
	_skip_pat1:
			inc		hl
			; 色
			rrca
			jr		nc, _skip_col1
			ld		a, l
			out		[vdpport1], a
			ld		a, h
			or		a, 0x40
			out		[vdpport1], a
			ld		a, b
			out		[vdpport0], a		; 色
	_skip_col1:
			ei
			ret
	_sprite_mode2:
			; スプライトアトリビュートを求める
			ld		a, h
			ld		[buf + 0], a
			push	de					; パターンと色保存
			push	hl					; フラグ保存
			call	calatr
			pop		de					; フラグ復帰
			ld		a, e				; A = フラグ
			; 座標指定
			rrca
			jr		nc, _skip_pos2
			ld		e, a
			call	nstwrt
			ld		a, c
			out		[vdpport0], a		; Y座標
			ld		a, b
			out		[vdpport0], a		; X座標
			ld		a, e
	_skip_pos2:
			inc		hl
			inc		hl
			; パターン
			pop		bc
			rrca
			jr		nc, _skip_pat2

			ld		e, a
			call	nstwrt
			ld		a, [rg1sav]			; 0bXXXX_XXSX : Sprite Size S:0=8x8, 1=16x16
			and		a, 0b0000_0010
			ld		a, c
			jr		z, _skip_pat2_0
			add		a, a				; 16x16 の場合は、4倍する
			add		a, a
	_skip_pat2_0:
			out		[vdpport0], a		; パターン
			ld		a, e
	_skip_pat2:
			; 色
			rrca
			jr		nc, _skip_col2
			; カラーテーブル( 4[byte] * 32[plane] = 128[byte] )のアドレスを求める
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
			out		[vdpport0], a		; 色
			djnz	_loop1
	_skip_col2:
			ret
			endscope

; =============================================================================
;	COLOR SPRITE (A)=L
;	input:
;		A ..... スプライト番号
;		L ..... 色
;	output:
;		none
;	break:
;		all
;	comment:
;		MSX-BASIC 1.0 ではサポートしていないが、このルーチンは MSX1 でも利用可能
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
			call	calatr				; スプライトアトリビュートのアドレスを HL に取得
			ld		a, c				; A = 色
			inc		hl
			inc		hl
			inc		hl
			call	wrtvrm				; VRAMへ書き込み
			ret
	_sprite_mode2:
			xor		a, a
			call	calatr				; スプライトアトリビュートの先頭アドレスを HL に取得
			dec		h
			dec		h					; スプライトカラーテーブルのアドレスに変換
			ld		a, b				; スプライトプレーン番号
			rlca
			rlca
			rlca
			rlca
			ld		l, a
			adc		a, h
			ld		h, a				; HL = カラーテーブルのアドレス
			ld		a, c				; A = 色
			ld		bc, 16
			jp		bigfil
			endscope

; =============================================================================
;	COLOR SPRITE$ (A)=HL
;	input:
;		A ..... スプライト番号
;		HL .... 色文字列
;	output:
;		none
;	break:
;		all
;	comment:
;		スプライトモード2の画面モードでのみ有効
; =============================================================================
			scope	sub_colorsprite_str
sub_colorsprite_str::
			ld		b, a
			ld		a, [scrmod]
			cp		a, 4
			ret		c
			push	hl
			xor		a, a
			call	calatr				; スプライトアトリビュートの先頭アドレスを HL に取得
			dec		h
			dec		h					; スプライトカラーテーブルのアドレスに変換
			ld		a, b				; スプライトプレーン番号
			rlca
			rlca
			rlca
			rlca
			ld		l, a
			adc		a, h
			ld		h, a				; HL = カラーテーブルのアドレス
			call	nstwrt
			; 長さを調べる
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
;		A ..... TAB() の引数
;	output:
;		none
;	break:
;		all
;	comment:
;		桁位置が A になるまでスペースを出す
; =============================================================================
			scope	sub_tab
sub_tab::
			ld		e, a
			ld		a, [csrx]
			dec		a						; csrx が +1 の位置なので 0基準に戻す
	_loop:
			cp		a, e					; CP 現在の桁位置, 目標桁位置
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
;		BUF に書式文字列のアドレス, BUF+2以降にパラメータを格納して呼ぶ
; =============================================================================
			scope	sub_using
sub_using::
			ei
			; 書式文字列の長さとアドレスを得る
			ld		hl, [buf]
			ld		a, [hl]
			or		a, a
			jp		z, err_illegal_function_call		; 書式文字列が長さ 0 なら Illegal function call
			inc		hl
			ld		b, a
			; 引数のアドレス
			ld		de, buf+2
			; 1文字得て書式文字か調べる
			; 書式の開始文字は、!(21) #(23) &(26) *(2A) +(2B) .(2E) @(40) \(5C)
	main_loop:
			; HL = 書式, DE = 引数
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
			; 書式ではない文字
	no_format:
			rst		0x18
			jr		main_loop

			; -----------------------------------------------------------------
			; 数値の書式
			; #(23) *(2A) +(2B) -(2D) .(2E) \(5C)
	number_format:
			; pufout へ渡すフォーマット情報を初期化
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
			jr		z, no_format				; * で終わってる場合は単独の * 扱い

			ld		a, [hl]
			cp		a, '*'
			ld		a, '*'
			jr		nz, no_format				; NZ なら * が 1個だけなので書式ではない

			ld		a, 2
			ld		[dectm2 + 1], a				; 整数部 2桁から開始
			xor		a, a
			ld		[dectm2], a					; 小数部 0桁
			ld		a, 0b1010_0000				; * 詰め指定
			ld		[deccnt], a
			inc		hl							; 2個目の * の分
			dec		b
			jr		nz, detect_yen

			; -----------------------------------------------------------------
			; 引数の数値を DAC へコピーして pufout を呼ぶ
	put_number:
			ex		de, hl						; DE = 書式, HL = 引数
			ld		a, [hl]						; A = 引数の型
			or		a, a
			ret		z							; 引数がないので終了
			cp		a, 3
			jp		z, err_type_mismatch		; フラグ不変: 文字列ならエラー
			ld		[valtyp], a					; フラグ不変: 2:整数, 4:単精度, 8:倍精度のいずれか
			push	de							; フラグ不変: 書式の参照位置を保存
			push	bc							; フラグ不変: サイズ情報を保存
			inc		hl							; フラグ不変
			; ブロック転送
			ld		de, dac						; フラグ不変
			jr		nc, pufout_skip				; 整数の場合 Cy=1, 単精度・倍精度の場合 Cy=0
			inc		e							; DAC=F7F6h なので E にだけ 2 足せば充分
			inc		e
		pufout_skip:
			ld		c, a
			ld		b, 0
			ldir
			push	hl							; 引数の参照位置を保存
			; pufout 呼び出し
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
			pop		de							; 引数の参照位置を復帰
			pop		bc							; サイズ情報を復帰
			pop		hl							; 書式の参照位置を復帰
			jp		main_loop

			; -----------------------------------------------------------------
			; 通貨記号 ￥ (**￥ の￥)
	detect_yen:
			ld		a, [hl]
			cp		a, 0x5C
			jr		nz, detect_sharp				; ￥ が無ければ **###、あれば **￥###

			inc		hl
			dec		b
			ld		a, 3
			ld		[dectm2 + 1], a				; 整数部 3桁から開始
			ld		a, 0b1011_0000				; * 詰め指定, ￥ 詰め指定
			ld		[deccnt], a
			jr		detect_sharp

			; -----------------------------------------------------------------
			; 通貨記号 ￥￥
	detect_yenyen:
			inc		b
			dec		b
			jp		z, no_format				; ￥ で終わってる場合は単独の ￥ 扱い

			ld		a, [hl]
			cp		a, 0x5C
			ld		a, 0x5C
			jp		z, no_format				; ￥ が 1個だけなので書式ではない

			ld		a, 2
			ld		[dectm2 + 1], a				; 整数部 2桁から開始
			xor		a, a
			ld		[dectm2], a					; 小数部 0桁
			ld		a, 0b1001_0000				; ￥ 詰め指定
			ld		[deccnt], a
			inc		hl							; 2個目の ￥ の分
			dec		b

			; -----------------------------------------------------------------
			; 数値記号 #
	detect_sharp:
			ld		a, [dectm2 + 1]				; 整数部の桁数追加分を数える
			ld		c, a
			xor		a, a						; '.' ではない値にする
			inc		b
			dec		b
			jr		z, put_number				; 書式文字列がここで終わっていれば桁検出スキップ
			; 整数部の桁数検出
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
			jr		nz, detect_sharp_exit_all	; '.' が無ければ小数部は存在しないのでスキップ
			ld		a, 1						; 小数点の分の 1
			ld		[dectm2], a
			inc		hl
			dec		b
			jp		z, put_number				; 書式が終わっていればここで検出おしまい
			; 小数部の桁数検出
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
			jp		z, put_number				; 書式が終わっていればここで検出おしまい
	detect_sharp_exit_all:

			; -----------------------------------------------------------------
			; 指数部 ^^^^
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
			inc		a							; 指数表示指定
			ld		[deccnt], a

			pop		af
			pop		af
			jr		detect_post_flag_skip_pop
	detect_post_flag:
			pop		hl
			pop		bc

			; -----------------------------------------------------------------
			; 後置符号 +, -
	detect_post_flag_skip_pop:
			inc		b
			dec		b
			jp		z, put_number

			ld		a, [deccnt]
			and		a, 0b0000_1000				; 正の場合も符号付けるフラグが付いてれば、前置フラグが存在してるので、後置はただの記号。
			jp		nz, put_number

			ld		a, [hl]
			cp		a, '+'
			jr		nz, detect_post_flag_minus

			ld		a, [deccnt]
			or		a, 0b0000_1100				; 正の場合も符号付けるフラグ、後ろに符号を付けるフラグ
			jr		detect_post_flag_exit

	detect_post_flag_minus:
			cp		a, '-'
			jp		nz, put_number

			ld		a, [deccnt]
			or		a, 0b0000_0100				; 後ろに符号を付けるフラグ
	detect_post_flag_exit:
			ld		[deccnt], a
			inc		hl
			dec		b
			jp		put_number

			; -----------------------------------------------------------------
			; 前置符号 +
	detect_pre_flag_plus:
			ld		a, [deccnt]
			or		a, 0b0000_1000				; 正の場合も符号付けるフラグ
			ld		[deccnt], a
			ld		a, 1
			ld		[dectm2+1], a
			jp		detect_sharp

			; -----------------------------------------------------------------
			; 文字列の書式 @
	string_format:
			ex		de, hl					; HL = 引数, DE = 書式
			ld		a, [hl]
			or		a, a
			ret		z						; 引数型が 0 なら終わり
			cp		a, 3					; 引数型が 3 でなければ Type mismatch
			jp		nz, err_type_mismatch
			push	de						; 書式のアドレスを保存
			push	bc
			inc		hl
			ld		e, [hl]
			inc		hl
			ld		d, [hl]					; DE = @ にはめ込む文字列のアドレス
			inc		hl
			ex		de, hl					; HL = はめ込む文字列, DE = 引数
			ld		b, [hl]					; B = はめ込む文字列の文字数
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
			pop		hl						; 書式のアドレスを復帰
			jp		main_loop

			; -----------------------------------------------------------------
			; 桁制限付き文字列の書式 &&
	string_column_format:
			; 最初の & が書式の最後の場合、単なる記号として処理
			inc		b
			dec		b
			jp		z, no_format
			; 2つ目の & が存在するかチェックする
			ld		c, b
			push	hl						; 書式の現在位置を保存
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
			pop		hl						; 書式の現在位置を復帰
			ld		a, '&'
			jp		no_format
	string_column_found:
			; 引数が文字列か調べる
			ex		de, hl					; HL = 引数
			ld		a, [hl]
			or		a, a
			ret		z						; 引数型が 0 なら終わり
			cp		a, 3					; 引数型が 3 でなければ Type mismatch
			jp		nz, err_type_mismatch

			inc		hl
			ld		e, [hl]
			inc		hl
			ld		d, [hl]					; DE = && にはめ込む文字列のアドレス
			inc		hl
			ex		[sp], hl				; HL = 書式, スタック = 引数

			ld		a, [de]					; && にはめ込む文字列の長さ
			inc		de
			or		a, a					; && にはめ込む文字列が "" なら、最初からスペース挿入
			ld		b, a
			jr		nz, replace_first
			; && にはめ込む文字列が "" の場合
			ld		a, ' '
			inc		b
			jr		replace_first_is_space

	replace_first:
			; 最初の & の分の出力
			ld		a, [de]					; && にはめ込む文字
			inc		de
	replace_first_is_space:
			rst		0x18					; 1文字出力
			dec		b						; && にはめ込む文字列を 1文字消費
			jr		z, insert_space

	replace_loop:
			ld		a, [de]					; && にはめ込む文字
			inc		de
			rst		0x18					; 1文字出力

			ld		a, [hl]					; 書式上の文字
			inc		hl
			dec		c						; 書式文字列を 1文字消費
			cp		a, '&'
			jp		z, string_column_exit

			djnz	replace_loop			; && にはめ込む文字がなくなるまで繰り返す

	insert_space:
			ld		a, ' '					; && にはめ込む文字
			rst		0x18					; 1文字出力

			ld		a, [hl]					; 書式上の文字
			inc		hl
			dec		c						; 書式文字列を 1文字消費
			cp		a, '&'
			jp		nz, insert_space

	string_column_exit:
			pop		de
			ld		b, c
			jp		main_loop

			; -----------------------------------------------------------------
			; 文字の書式 !
	char_format:
			ex		de, hl					; HL = 引数, DE = 書式
			ld		a, [hl]
			or		a, a
			ret		z						; 引数型が 0 なら終わり
			cp		a, 3					; 引数型が 3 でなければ Type mismatch
			jp		nz, err_type_mismatch

			push	de						; 書式のアドレスを保存
			inc		hl
			ld		e, [hl]
			inc		hl
			ld		d, [hl]					; DE = @ にはめ込む文字列のアドレス
			inc		hl
			ex		de, hl					; HL = はめ込む文字列, DE = 引数
			ld		a, [hl]					; A = はめ込む文字列の文字数
			inc		hl

			or		a, a
			ld		a, ' '					; 長さ 0 の文字列だった場合は、' ' を指定したことにする
			jr		z, blank_string
			ld		a, [hl]
	blank_string:
			rst		0x18
			pop		hl						; 書式のアドレスを復帰
			jp		main_loop

			; -----------------------------------------------------------------
			; 書式文字列から 1文字得る
	get_one:
			inc		b
			dec		b
			jr		nz, get_one_normal
			; 書式文字列を全て処理した場合、まだ引数が残っているかチェック
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
;		DE ... 元となる文字列
;		HL ... 元となる文字列の中から探す文字列
;	output:
;		HL ... 見つけた位置
;	break:
;		all
;	comment:
;		先頭が 1、見つからなかった場合は 0
; =============================================================================
			scope	sub_instr
sub_instr::
			ld		a, [de]
			ld		b, [hl]
			sub		a, b					; A = 先頭から探索する文字数
			jr		c, _not_found			; 探す文字列の方が長ければ、一致するはずがない
			ld		c, 1					; 現在の位置
			inc		b
			dec		b
			jr		z, _match_wo_pop
			inc		a
			ld		b, a					; 残り探索位置
			inc		de						; 先頭の文字位置 (元の文字列)

	_search_loop:
			push	hl
			push	de
			push	bc
			; 着目位置における文字列の一致確認
			ld		b, [hl]					; 文字数
			inc		hl						; 先頭の文字位置 (探す文字列)
	_compare:
			ld		a, [de]
			cp		a, [hl]
			jr		nz, _no_match
			inc		de
			inc		hl
			djnz	_compare
	_match:
			pop		hl						; スタック捨て
			pop		hl						; スタック捨て
			pop		hl						; スタック捨て
	_match_wo_pop:
			ld		l, c
			ld		h, 0
			ret

			; 一致しなかった場合
	_no_match:
			pop		bc
			pop		de
			pop		hl
			inc		de						; 次の位置へ遷移
			inc		c						; 次の位置へ遷移
			djnz	_search_loop

			; 一致する場所が一つも無かった
	_not_found:
			ld		hl, 0					; 0 を返す
			ret
			endscope

; =============================================================================
;	新しいFCBを生成する
;	input:
;		HL ... ファイル名
;		DE ... FCB用のメモリのアドレス (37bytes)
;	output:
;		none
;	break:
;		all
;	comment:
;		ワイルドカード '*' は、'?' に展開する
; =============================================================================
			scope	sub_setup_fcb
sub_setup_fcb::
			; 中身をクリアする
			push	hl
			push	de
			ld		l, e
			ld		h, d
			inc		de
			ld		bc, 36
			ld		[hl], 0
			ldir
			; カレントドライブ取得
			ld		c, _CURDRV
			call	bdos
			inc		a
			pop		de
			pop		hl
			ld		[de], a
			; ドライブ名の存在チェック
			ld		a, [hl]
			inc		hl
			ld		c, a				; C = 長さ
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
			; ファイル名(Max 8文字) のコピー
		copy_file_name:
			inc		de					; DE: ファイル名
			ld		b, 8				; B: ファイル名の最大サイズ
			inc		c					; つじつま合わせ
		copy_file_name_loop:
			dec		c
			jr		z, fill_name_padding	; ファイル名のコピーは終わった
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
			; ピッタリ8文字の名前が指定されている場合に . があるかチェック
			ld		a, [hl]
			cp		a, '.'
			jr		nz, copy_ext_name
			inc		hl
			jr		copy_ext_name
			; ファイル名の残りをワイルドカードで埋める
		copy_ext_name_skip_wildcard:
			ld		a, '?'
			inc		hl
			jr		copy_ext_name_skip_dot_loop
			; ファイル名の残りの隙間をスキップ
		fill_name_padding:
			dec		hl					; '.' を読み飛ばす処理のつじつま合わせ
			inc		c					; '.' を読み飛ばす処理のつじつま合わせ
		copy_ext_name_skip_dot:
			ld		a, ' '
		copy_ext_name_skip_dot_loop:
			ld		[de], a				; 隙間は ' ' で埋める
			inc		de					; 拡張子の位置まで移動
			djnz	copy_ext_name_skip_dot_loop
			inc		hl					; '.' を読み飛ばす
			dec		c					; '.' を読み飛ばす
			; 拡張子(Max 3文字) のコピー
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
			; * を ? に置換
		copy_ext_name_padding_wildcard:
			ld		a, '?'
			jr		copy_ext_name_padding_loop
			; 拡張子が 3文字未満ならパディング
		copy_ext_name_padding:
			dec		b
			jr		z, copy_name_finish
		fill_ext_padding:
			ld		a, ' '
		copy_ext_name_padding_loop:
			ld		[de], a
			inc		de
			djnz	copy_ext_name_padding_loop
			; ファイル名以外のフィールドを初期化する
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
			jr		z, check_error_exit		; 不正な記号には一致しなかった
			cp		a, b
			scf
			jr		z, check_error_exit		; 不正な記号に一致した
			inc		hl
			jr		check_error_char_loop
	check_error_exit:
			ld		a, b
			pop		bc
			pop		hl
			ret		c						; エラーなら抜ける
	toupper:
			cp		a, 'a'
			jr		c, toupper_exit
			cp		a, 'z'+1
			jr		nc, toupper_exit
			and		a, 0b1101_1111			; a → A ... z → Z
	toupper_exit:
			or		a, a					; Cf = 0
			ret
	error_char:
			db		":\"\\^|<>,./ ", 0
			endscope

; =============================================================================
;	ファイルを開く
;	input:
;		HL ... ファイル名
;		DE ... FCB用のメモリのアドレス (37bytes)
;	output:
;		A .... 00h: 成功, FFh: 失敗
;	break:
;		all
;	comment:
;		既に存在するファイルを開く
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
;	ファイルを作る
;	input:
;		HL ... ファイル名
;		DE ... FCB用のメモリのアドレス (37bytes)
;	output:
;		A .... 00h: 成功, FFh: 失敗
;	break:
;		all
;	comment:
;		存在しなければ生成し、存在していれば作り直す
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
;	ファイルを閉じる
;	input:
;		HL ... 開いたFCB
;	output:
;		A .... 00h: 成功, FFh: 失敗
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
;	ファイルを読む
;	input:
;		HL ... 開いたFCB
;		DE ... 読み出し結果を格納するアドレス
;		BC ... 読み出すサイズ
;	output:
;		A .... 00h: 成功, 01h: 失敗またはEOF
;		HL ... 実際に読んだバイト数
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_fread
sub_fread::
			push	bc					; サイズ
			push	hl					; FCB
			; 転送先アドレスの指定
			ld		c, _SETDTA
			call	bdos
			; 読み出し
			pop		de					; FCB
			pop		hl					; サイズ = レコード数 (1レコード 1byte設定)
			ld		c, _RDBLK
			jp		bdos
			endscope

; =============================================================================
;	ファイルへ書き込む
;	input:
;		HL ... 開いたFCB
;		DE ... 書き出す内容が格納されているアドレス
;		BC ... 書き出すサイズ
;	output:
;		A .... 00h: 成功, 01h: 失敗
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_fwrite
sub_fwrite::
			push	bc					; サイズ
			push	hl					; FCB
			; 転送元アドレスの指定
			ld		c, _SETDTA
			call	bdos
			; 読み出し
			pop		de					; FCB
			pop		hl					; サイズ = レコード数 (1レコード 1byte設定)
			ld		c, _WRBLK
			jp		bdos
			endscope

; =============================================================================
;	BLOAD ファイル名,S
;	input:
;		HL ... ファイル名
;		DE ... 読みだし用バッファ
;		BC ... 読みだし用バッファのサイズ
;	output:
;		none
;	break:
;		all
;	comment:
;		読みだし用バッファは、最低でも 128byte 必要
; =============================================================================
			scope	sub_bload_s
sub_bload_s::
			ei
			ld		[buffer_address], de
			ld		[buffer_size], bc
			; ファイルを開く
			ld		de, buf				; FCB を buf に置く
			call	sub_fopen
			or		a, a
			jp		nz, err_file_not_found
			; ヘッダを読み出す
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fread
			or		a, a
			jp		nz, err_bad_file_mode
			ld		a, [bsave_head_signature]
			cp		a, 0xFE
			jp		nz, err_bad_file_mode
			; サイズを求める
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			ld		[bsave_head_size], hl
			; VRAMアドレスをセットする
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
			; バッファに読み出す
			ld		hl, [buffer_size]
			ld		de, [bsave_head_size]
			rst		0x20						; CP HL, DE
			ld		bc, [buffer_size]
			jr		c, skip1
			ld		bc, [bsave_head_size]
		skip1:
			ld		hl, buf
			ld		de, [buffer_address]
			push	bc							; 読み出すサイズ
			call	sub_fread
			pop		bc							; 読み出すサイズ
			or		a, a
			sbc		hl, bc
			jp		nz, err_device_io			; 指定のサイズ読めなかった場合は Device I/O Error
			; 読んだサイズ分を VRAM へ転送する
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
			; ファイルを閉じる
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
;		HL ... ファイル名
;	output:
;		HL ... 実行開始アドレス
;		DE ... 先頭アドレス
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_bload
sub_bload::
			ei
			; ファイルを開く
			ld		de, buf				; FCB を buf に置く
			call	sub_fopen
			or		a, a
			jp		nz, err_file_not_found
			; ヘッダを読み出す
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fread
			or		a, a
			jp		nz, err_bad_file_mode
			ld		a, [bsave_head_signature]
			cp		a, 0xFE
			jp		nz, err_bad_file_mode
			; サイズを求める
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			ld		[bsave_head_size], hl
			; 読み出す
			ld		bc, [bsave_head_size]
			ld		hl, buf
			ld		de, [bsave_head_start]
			push	bc							; 読み出すサイズ
			call	sub_fread
			pop		bc							; 読み出すサイズ
			or		a, a
			sbc		hl, bc
			jp		nz, err_device_io			; 指定のサイズ読めなかった場合は Device I/O Error
			; ファイルを閉じる
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
;	MID$( 文字列変数, 書き替え位置, 書き替え文字数 ) = 書き替える文字
;	input:
;		HL ... 文字列変数のアドレス(書き替える場所)
;		DE ... 上書きする文字列のアドレス
;		B .... 書き替え位置 (先頭は 1)
;		C .... 書き替え文字数 (省略時は 255)
;	output:
;		HLの文字列が書き替えられる
;	break:
;		all
;	comment:
;		HL の値は保存される
; =============================================================================
			scope	sub_mid_cmd
sub_mid_cmd::
			; B = 0 はエラー
			inc		b
			dec		b
			jp		z, err_illegal_function_call
			; 書き替え位置 B がはみ出してないかチェック
			ld		a, [hl]								; 文字列変数に格納されている文字列の長さ
			cp		a, b
			jp		c, err_illegal_function_call
			; 書き替え文字数が文字列端を越えていないかチェック
			ld		a, b
			dec		a
			add		a, c
			jr		c, adjust_size
			cp		a, [hl]
			jr		c, after_adjust_size
		adjust_size:
			; 文字列端を越えている場合はそこまでの長さに切り詰める
			ld		a, [hl]
			sub		a, b
			inc		a
			ld		c, a
		after_adjust_size:
			; 上書きする文字列 DE が、書き替える長さ C より短いか調べる
			ld		a, [de]
			cp		a, c
			jr		nc, after_adjust_size2
			; 短かったので、書き替える長さを置き換える
			ld		c, a
		after_adjust_size2:
			; 書き替える長さが 0 になった場合、何もしない
			inc		c
			dec		c
			ret		z
			push	hl
			; 書き替える位置へポインタを移動
			ld		a, l
			add		a, b
			ld		l, a
			ld		a, h
			ld		b, 0
			adc		a, b
			; 書き替え処理
			inc		de
			ex		de, hl
			ldir
			pop		hl
			ret
			endscope

; =============================================================================
;	BSAVE HL
;	input:
;		HL ... ファイル名
;		DE ... 開始アドレス、終了アドレス、実行アドレスが格納されているアドレス
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
			; ファイルを開く
			push	de
			ld		de, buf				; FCB を buf に置く
			call	sub_fcreate
			or		a, a
			jp		nz, err_device_io
			pop		hl
			; ヘッダを作る
			ld		de, bsave_head_start
			ld		bc, 6
			ldir
			ld		a, 0xFE
			ld		[bsave_head_signature], a
			; ヘッダを書き出す
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; 書き出すサイズを計算 (bsave_head_end - bsave_head_start + 1)
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			inc		hl
			ld		c, l
			ld		b, h
			; 書き出す
			ld		hl, buf				; FCB
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; ファイルを閉じる
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
;		HL ... ファイル名
;		DE ... 開始アドレス、終了アドレス、実行アドレス、ワークエリア開始アドレス、終了アドレスが格納されているアドレス
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
			; ファイルを開く
			push	de
			ld		de, buf				; FCB を buf に置く
			call	sub_fcreate
			or		a, a
			jp		nz, err_device_io
			pop		hl
			; ヘッダを作る
			ld		de, bsave_head_start
			ld		bc, 10
			ldir
			ld		a, 0xFE
			ld		[bsave_head_signature], a
			; ヘッダを書き出す
			ld		hl, buf				; FCB
			ld		de, bsave_head
			ld		bc, 7
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; ワークエリアサイズを計算
			ld		hl, [bsave_work_end]
			ld		de, [bsave_work_start]
			or		a, a
			sbc		hl, de
			ld		[bsave_work_size], hl
			; 書き出すサイズを計算 (bsave_head_end - bsave_head_start + 1)
			ld		hl, [bsave_head_end]
			ld		de, [bsave_head_start]
			sbc		hl, de
			ld		[bsave_data_size], hl
			; VRAMアドレスをセット
			ld		hl, [bsave_head_start]
			ld		a, [romver]
			or		a, a
			jr		z, skip1
			call	nsetrd					; VRAM ADDRESSセット for MSX2/2+/turboR
			jr		loop
		skip1:
			call	setrd					; VRAM ADDRESSセット for MSX1
		loop:
			; 残りサイズを計算
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
			; 書き出す
			ld		hl, buf					; FCB
			pop		bc						; size
			pop		de						; work
			call	sub_fwrite
			or		a, a
			jp		nz, err_device_io
			; 書き終えたか？
			ld		bc, [bsave_data_size]
			ld		a, c
			or		a, b
			jr		nz, loop
			; ファイルを閉じる
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
;		HL ... 上書きされる変数のアドレス
;		DE ... 上書きする文字列
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_lset
sub_lset::
			; 変数のアドレスから文字列アドレスを取得
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; 長さを比べる
			ex		de, hl			; DE = 上書きされる文字列, HL = 上書きする文字列
			ld		a, [de]			; A = 上書きされる文字列の長さ
			ld		c, [hl]			; C = 上書きする文字列の長さ
			ld		b, a
			cp		a, c
			jr		nc, skip		; 上書きする文字列が短ければ skip
			; A > C の場合 : 上書きされる文字列の方が短い場合
			ld		c, a			; 上書きする文字列の長さを、上書きされる文字列の長さに切り詰める
		skip:
			ld		a, b			; A は HL の文字列の長さ
			sub		a, c
			inc		c
			dec		c
			inc		de
			jr		z, skip_fill	; 更新が 0 なら何もしない
			; 文字列をコピーする
			ld		b, 0
			inc		hl
			ldir
		skip_fill:
			; 残りをスペースで埋める
			or		a, a			; 残りが無い場合は何もしない
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
;		HL ... 上書きされる変数のアドレス
;		DE ... 上書きする文字列
;	output:
;		none
;	break:
;		all
;	comment:
;		none
; =============================================================================
			scope	sub_rset
sub_rset::
			; 変数のアドレスから文字列アドレスを取得
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; 長さを比べる
			ex		de, hl			; DE = 上書きされる文字列, HL = 上書きする文字列
			ld		a, [de]			; A = 上書きされる文字列の長さ
			ld		c, [hl]			; C = 上書きする文字列の長さ
			ld		b, a
			cp		a, c
			jr		nc, skip		; 上書きする文字列が短ければ skip
			; A > C の場合 : 上書きされる文字列の方が短い場合
			ld		c, a			; 上書きする文字列の長さを、上書きされる文字列の長さに切り詰める
		skip:
			ld		a, b			; A は HL の文字列の長さ
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
			; 残りを指定の文字列に置き換える
			ldir
			ret
			endscope

; =============================================================================
;	BASE(HL)
;	input:
;		HL ... 番号
;	output:
;		HL ... アドレス
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
			; MSX1 のモードの場合
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
			; SCREEN5～6
			ld		h, screen5_base >> 8
			add		a, a
			add		a, screen5_base & 0xFF
			jr		finish
	screen78_mode:
			call	mod5
			; SCREEN7～12
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
;		HL .... 入力された文字列を格納するメモリ ( [HL+0]:サイズ, [HL+1]～[HL+1+サイズ]:文字列 )
;	output:
;		HL .... 入力された文字 (BASIC形式)
;	break:
;		A, B, C, D, E, H, L, F
;	comment:
;		[HL+1]～[HL+1+サイズ] は上書きされる
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
;	IRND (※BACON独自関数)
;	input:
;		none
;	output:
;		HL .... 乱数
;	break:
;		all
;	comment:
;		-32768～32767 の乱数を返す
;		MSX-BASIC標準の RND() のワークエリアである RNDX を使うため、
;		両方使う場合は要注意
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
;	IRANDOMIZE (※BACON独自関数)
;	input:
;		none
;	output:
;		HL .... 初期値
;	break:
;		all
;	comment:
;		乱数を初期化する
;		MSX-BASIC標準の RND() のワークエリアである RNDX を使うため、
;		両方使う場合は要注意
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
;	POKES アドレス, 文字列 (※BACON独自関数)
;	input:
;		HL .... アドレス
;		DE .... 文字列
;	output:
;		HL .... 文字列
;	break:
;		all
;	comment:
;		アドレスへ文字列を書き込む
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
;	PEEKS$( アドレス, 文字数 ) (※BACON独自関数)
;	input:
;		HL .... アドレス
;		DE .... 文字列
;	output:
;		HL .... 文字列 (※確保済みの文字列領域に上書きする)
;	break:
;		all
;	comment:
;		アドレスから読み出して文字列を返す
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
;	VPOKES アドレス, 文字列 (※BACON独自関数)
;	input:
;		HL .... アドレス
;		DE .... 文字列
;	output:
;		HL .... 文字列
;	break:
;		all
;	comment:
;		アドレスへ文字列を書き込む
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
;	VPEEKS$( アドレス, 文字数 ) (※BACON独自関数)
;	input:
;		HL .... アドレス
;		DE .... 文字列
;	output:
;		HL .... 文字列 (※確保済みの文字列領域に上書きする)
;	break:
;		all
;	comment:
;		アドレスから読み出して文字列を返す
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
;	HEXCHR$( 文字列 ) (※BACON独自関数)
;	input:
;		HL .... 入力文字列
;	output:
;		HL .... 変換結果の文字列
;	break:
;		all
;	comment:
;		入力文字列の 2文字を2桁の16進数と見なして結果へ格納。これを全文字に行う。
;		16進数以外の文字が入っていた場合の挙動は不定。
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
;	CHRHEX$( 文字列 ) (※BACON独自関数)
;	input:
;		HL .... 入力文字列
;	output:
;		HL .... 変換結果の文字列のアドレス
;	break:
;		all
;	comment:
;		入力文字列の文字コードを 16進数文字列に変換する。これを全文字に行う。
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
;	FILES <ワイルドカード>
;	input:
;		HL .... ワイルドカード文字列 (0000h を指定すると *.* になる)
;	output:
;		none
;	break:
;		all
;	comment:
;		DiskBASIC1.x の FILES 相当。DiskBASIC2.x の FILES,L には非対応。
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
			; FCB生成
			ld		de, find_file_name
			call	sub_setup_fcb

			; 転送元アドレスの指定 (見つけたファイルの FCB が格納される)
			ld		de, find_file_name_fcb
			ld		c, _SETDTA
			call	bdos

			; カーソルが左端に居るか調べる
			ld		a, [csrx]				; 左端は 1 (0ではないので要注意)
			dec		a
			jr		nz, skip_print_crlf
			; カーソルが左端にないので改行する
			ld		hl, data_crlf
			call	sub_puts
		skip_print_crlf:

			; 最初の検索
			ld		de, buf
			ld		c, _SFIRST
			call	bdos
			or		a, a
			jr		nz, end_files			; 失敗した場合 (1つもヒットしない場合)、何もしない。

		loop:
			; 見つけたファイルを表示する
			call	put_one_file
			; 次のファイルを検索
			ld		c, _SNEXT
			call	bdos
			or		a, a
			jr		nz, end_files
			; 次を表示できる位置か確認
			ld		a, [csrx]				; 左端を 1 とする X座標
			ld		b, a
			ld		a, [linlen]				; WIDTH n の n
			sub		a, b
			cp		a, 13
			jr		nc, loop
			; これ以上右に表示できないので改行
		put_return:
			ld		hl, data_crlf
			call	sub_puts
			jr		loop

		end_files:
			; カーソルが左端でなければ改行
			ld		a, [csrx]				; 左端は 1 (0ではないので要注意)
			dec		a
			jr		z, finish
			; カーソルが左端にないので改行する
			ld		hl, data_crlf
			call	sub_puts
		finish:
			ret

			; ファイル名を一つ分表示する
		put_one_file:
			; 左端か？
			ld		a, [csrx]
			dec		a
			jr		z, put_name
			; 左端でないので ' ' を表示
			ld		a, ' '
			rst		0x18
			; ファイル名 8文字
		put_name:
			ld		a, 8
			ld		hl, find_file_name_fcb
			ld		[hl], a
			call	sub_puts
			; 拡張子が空っぽか調べる
			ld		hl, [find_file_name_fcb + 1 + 8]
			ld		a, [find_file_name_fcb + 1 + 10]
			or		a, l
			or		a, h
			; 空っぽでなければ '.' を、空っぽなら ' ' を表示する
			cp		a, ' '
			jr		z, blank_ext
			ld		a, '.'
		blank_ext:
			rst		0x18
			; 拡張子 3文字
			ld		a, 3
			ld		hl, find_file_name_fcb + 1 + 8 - 1
			ld		[hl], a
			call	sub_puts
			ret
			endscope

; =============================================================================
;	PUTS
;	input:
;		HL .... 表示する文字列
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
;	KILL <ワイルドカード>
;	input:
;		HL .... ワイルドカード文字列
;	output:
;		none
;	break:
;		all
;	comment:
;		ファイルを削除する
; =============================================================================
			scope	sub_kill
sub_kill::
			; FCB生成
			ld		de, buf
			call	sub_setup_fcb

			; ファイルを削除する
			ld		de, buf
			ld		c, _FDEL
			call	bdos
			ret
			endscope

; =============================================================================
;	NAME <ワイルドカード> AS <ワイルドカード>
;	input:
;		HL .... ワイルドカード文字列
;		DE .... ワイルドカード文字列
;	output:
;		none
;	break:
;		all
;	comment:
;		ファイル名を変更する
; =============================================================================
			scope	sub_name
sub_name::
			; FCB生成
			push	de
			ld		de, buf
			call	sub_setup_fcb
			pop		hl
			ld		de, buf + 16
			call	sub_setup_fcb

			; ファイルを変更する
			ld		de, buf
			ld		c, _FREN
			call	bdos
			ret
			endscope

; =============================================================================
;	COPY <ワイルドカード1> TO <ワイルドカード2>
;	input:
;		HL .... ワイルドカード1文字列
;		DE .... ワイルドカード2文字列
;		buffer_start .... 作業用バッファの先頭アドレス
;		buffer_end ...... 作業用バッファの終了アドレス (ここは含まない)
;	output:
;		none
;	break:
;		all
;	comment:
;		ファイルをコピーする。
;		buffer_start, buffer_end に 0xC000, 0xE000 を指定すると、0xC000～0xDFFF
;		が作業用に使われる。
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
			; 先に転送先を変換する
			ex		de, hl
			ld		de, replace_name
			call	sub_setup_fcb
			; 次に転送元を変換する
			pop		hl
			ld		de, find_file_name
			call	sub_setup_fcb
			; 転送元アドレスの指定 (見つけたファイルの FCB が格納される)
			ld		de, find_file_name_fcb
			ld		c, _SETDTA
			call	bdos
			; ワークのサイズを求める
			ld		hl, [buffer_end]
			ld		de, [buffer_start]
			or		a, a
			sbc		hl, de
			ld		[buffer_size], hl

			; 最初の検索
			ld		de, find_file_name
			ld		c, _SFIRST
			call	bdos
			or		a, a
			jr		nz, end_files			; 失敗した場合 (1つもヒットしない場合)、何もしない。

		loop:
			; 見つけたファイルをコピーする
			call	copy_one_file
			; 次のファイルを検索
			ld		c, _SNEXT
			call	bdos
			or		a, a
			jr		z, loop

		end_files:
			ret

			; ファイルを一つコピーする
		copy_one_file:
			; FCBをコピーする
			ld		hl, find_file_name_fcb
			ld		de, copy_file_name_fcb
			ld		bc, 37
			ldir
			; copy_file_name_fcb の方を replace_name のルールで書き替える
			ld		b, 1 + 11					; ドライブ番号もここでコピーしてしまう。ドライブ番号は '?' に一致しないのでコピーされる。
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
			; DTA を指定のワークに更新する
			ld		de, [buffer_start]
			ld		c, _SETDTA
			call	bdos
			; 転送元をオープン
			ld		de, find_file_name_fcb
			ld		c, _FOPEN
			call	bdos
			; 転送先をオープン
			ld		de, copy_file_name_fcb
			ld		c, _FMAKE
			call	bdos
			; レコード長を 1 にする
			ld		hl, 1
			ld		[find_file_name_fcb + 14], hl
			ld		[copy_file_name_fcb + 14], hl
			; ランダムレコードの設定
			dec		hl
			ld		[find_file_name_fcb + 33], hl
			ld		[copy_file_name_fcb + 33], hl
			ld		[find_file_name_fcb + 35], hl
			ld		[copy_file_name_fcb + 35], hl
			; 転送元のサイズ(32bit)を取得
			ld		hl, [find_file_name_fcb + 16]
			ld		[remain_file_size + 0], hl
			ld		hl, [find_file_name_fcb + 18]
			ld		[remain_file_size + 2], hl
			; 転送ループ
		loop2:
			ld		de, [buffer_size]
			ld		hl, remain_file_size + 3
			ld		a, [hl]
			dec		hl
			or		a, [hl]
			jr		nz, do_read						; 残りサイズの bit31～bit16 が 非0 なら buffer_size 目一杯読み込む。
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
			; 読み込み
			ex		de, hl
			ld		de, find_file_name_fcb
			ld		c, _RDBLK
			call	bdos
			push	hl
			; 書き込み
			ld		de, copy_file_name_fcb
			ld		c, _WRBLK
			call	bdos
			pop		hl
			or		a, a
			jp		nz, err_device_io
			; 残り容量を計算する
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
			; ファイルを閉じる
			ld		de, find_file_name_fcb
			ld		c, _FCLOSE
			call	bdos
			ld		de, copy_file_name_fcb
			ld		c, _FCLOSE
			call	bdos
			; DTA を find_file_name_fcb へ戻してから戻る
			ld		de, find_file_name_fcb
			ld		c, _SETDTA
			call	bdos
			ret
			endscope

; =============================================================================
;	COPY <配列変数名> TO <ファイル名>
;	input:
;		HL .... 配列変数のアドレス
;		DE .... ファイル名
;	output:
;		none
;	break:
;		all
;	comment:
;		配列変数の内容をファイルへ書き出す。
;		配列変数のサイズ・次元数・要素数のフィールドは書き出さない。
;		変数の値が格納されている領域のみ保存する。
;		[HL] --> [size:2][次元数:1][要素数1:2][要素数2:2]...[実体]
;		※ [フィールド名:バイト数]
; =============================================================================
			scope	sub_copy_array_to_file
file_size		= buf
array_data		= file_size + 2
fcb				= array_data + 2

sub_copy_array_to_file::
			ei
			push	de
			; 配列変数のサイズフィールドのアドレスを得る
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; サイズ情報を得る
			ld		e, [hl]
			inc		hl
			ld		d, [hl]
			inc		hl
			; 次元数を得る
			ld		c, [hl]
			inc		hl
			ld		b, 0
			; 要素数フィールドを読み飛ばす
			add		hl, bc
			add		hl, bc
			; サイズも計算
			ex		de, hl
			dec		hl			; 次元数フィールド 1 の分
			or		a, a
			sbc		hl, bc
			sbc		hl, bc
			ld		[file_size], hl
			ld		[array_data], de
			; ファイルを開く
			pop		hl			; ファイル名
			ld		de, fcb
			call	sub_fcreate
			or		a, a
			jp		nz, err_device_io
			; ファイルへ書き出す
			ld		bc, [file_size]
			ld		de, [array_data]
			ld		hl, fcb
			call	sub_fwrite
			; ファイルを閉じる
			ld		de, fcb
			ld		c, _FCLOSE
			jp		bdos
			endscope

; =============================================================================
;	配列変数の実体のアドレスとサイズを計算
;	input:
;		HL .... 配列変数のアドレス
;	output:
;		HL .... 実体のサイズ
;		DE .... 実体のアドレス
; =============================================================================
			scope	sub_calc_array
sub_calc_array::
			; 配列変数のサイズフィールドのアドレスを得る
			ld		a, [hl]
			inc		hl
			ld		h, [hl]
			ld		l, a
			; サイズ情報を得る
			ld		e, [hl]
			inc		hl
			ld		d, [hl]
			inc		hl
			; 次元数を得る
			ld		c, [hl]
			inc		hl
			ld		b, 0
			; 要素数フィールドを読み飛ばす
			add		hl, bc
			add		hl, bc
			; サイズも計算
			ex		de, hl
			dec		hl			; 次元数フィールド 1 の分
			or		a, a
			sbc		hl, bc
			sbc		hl, bc
			ret
			endscope

; =============================================================================
;	COPY <ファイル名> TO <配列変数名>
;	input:
;		HL .... 配列変数のアドレス
;		DE .... ファイル名
;	output:
;		none
;	break:
;		all
;	comment:
;		ファイルを読み出して配列変数へ読み出す。
;		配列変数のサイズ・次元数・要素数のフィールドは変更しない。
;		配列変数より大きなファイルが指定されても、配列変数のサイズ分しか読まない。
;		[HL] --> [size:2][次元数:1][要素数1:2][要素数2:2]...[実体]
;		※ [フィールド名:バイト数]
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
			; ファイルを開く
			pop		hl			; ファイル名
			ld		de, fcb
			call	sub_fopen
			or		a, a
			jp		nz, err_device_io
			; ファイルから読み出す
			ld		bc, [file_size]
			ld		de, [array_data]
			ld		hl, fcb
			call	sub_fread
			; ファイルを閉じる
			ld		de, fcb
			ld		c, _FCLOSE
			jp		bdos
			endscope

; =============================================================================
;	ARGの計算
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
			; NY の方向判定
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
			; NX の方向判定
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
;	VDP COMMANDの選択
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
			; TPSET ではないので、常に論理転送(LMMM)
	_lmmm:
			ld			a, 0x90
			ld			[BBT_LOGOP], a
			ret
	_set_command:
			; SCREEN5, 7 は 0b00000001		0101 0111
			; SCREEN6 は    0b00000011		0110
			; SCREEN8 は    0b00000000		1000
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _hmmm			; SCREEN8以上は HMMM
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
;		VDPコマンドが終わるまで待つ
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
;		ARG は、NX, NY の符号から自動設定される
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
;		HL ................ 配列変数のアドレス
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
;		ARG は、NX, NY の符号から自動設定される
; =============================================================================
			scope	sub_copy_pos_to_array
array_address	= BBT_LOGOP + 1
array_size		= array_address + 2
sub_copy_pos_to_array::
			; 配列のアドレス・サイズを計算
			call		sub_calc_array
			ld			[array_size], hl
			ld			[array_address], de
			; ARGを計算 (NX, NY の符号の処理)
			call		sub_set_arg
			; サイズを計算 (pixel count)
			call		sub_get_byte_size
			ld			de, [array_size]
			ex			de, hl
			or			a, a
			ld			bc, 4
			sbc			hl, bc					; サイズ情報分
			jp			c, err_illegal_function_call		; 4byteに満たない場合エラー
			rst			0x20					; CP HL, DE  : 配列サイズ, 画素数(byte換算)
			jp			c, err_illegal_function_call		; 配列のサイズの方が小さい場合はエラー
			push		de						; 画素数(byte換算) を保存
			; VDP Command をセット
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
			; サイズ情報を記録
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
			; 画面モードで分岐
			pop			de					; 画素数(byte換算) を復帰
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
			; TRビットや CEビットのチェックは行わない。VDPの方が速い。
			; C = vdpport1, B = 破壊, A = ゲットした値
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
			; サイズを比較
			ld			a, [scrmod]
			cp			a, 8
			jr			nc, _adjust_end
			ccf
			inc			hl						; 小数部繰り上げ
			rr			h
			rr			l
			rrca
			jr			c, _adjust_end
			inc			hl						; 小数部繰り上げ
			or			a, a
			rr			h
			rr			l
		_adjust_end:
			ret
			endscope

; =============================================================================
;	COPY ARRAY,DIR TO (X3,Y3), DPAGE,LOP
;	input:
;		HL ................ 配列変数のアドレス
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
;			0: 始点(DX, DY)
;			1: 始点(DX, DY) 左右反転
;			2: 始点(DX, DY) 上下反転
;			3: 始点(DX, DY) 上下左右反転
;			4: 始点(DX, DY)
;			5: 始点(DX+NX-1,DY) 左右反転
;			6: 始点(DX,DY+NY-1) 上下反転
;			7: 始点(DX+NX-1,DY+NY-1) 上下左右反転
; =============================================================================
			scope		sub_copy_array_to_pos
array_size		= BBT_LOGOP + 1
array_address	= array_size + 2

sub_copy_array_to_pos::
			; 配列のアドレス・サイズを計算
			ld			[BBT_ARG], a
			call		sub_calc_array
			ld			[array_size], hl
			ld			[array_address], de
			; NX, NY を設定
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
			ld			b, h				; BC = 画素数
			ld			a, [BBT_ARG]
			call		sub_adjust_dir
			pop			hl
			; コマンド設定
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
			; R#17 = 36 (オートインクリメント)
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
			; R#17 = 44 (非オートインクリメント)
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
;		HL ....................... ファイル名のアドレス
;		buffer_start(0xF55E:2) ... バッファーの先頭アドレス（このアドレスは含む）
;		buffer_end(0xF560:2) ..... バッファーの終了アドレス（このアドレスは含まない）
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
;		ARG は、NX, NY の符号から自動設定される
;		buffer_start以上、buffer_end未満の範囲をファイル書き込み用のバッファとして
;		使用する。
; =============================================================================
			scope	sub_copy_pos_to_file
buffer_start	= buf					; F55E
buffer_end		= buffer_start + 2		; F560
buffer_size		= BBT_LOGOP + 2
remain_size		= buffer_size + 2		; 書き込むべき残り byte数
transfer_size	= remain_size + 2
fcb				= transfer_size + 2
sub_copy_pos_to_file::
			; バッファーサイズを計算
			push		hl
			ld			hl, [buffer_end]
			ld			de, [buffer_start]
			or			a, a
			sbc			hl, de
			ld			[buffer_size], hl
			; ARGを計算 (NX, NY の符号の処理)
			call		sub_set_arg
			; ファイルを開く
			pop			hl
			ld			de, fcb
			call		sub_fcreate
			or			a, a
			jp			nz, err_device_io
			; サイズ情報を書き出す
			ld			hl, fcb
			ld			de, BBT_NX
			ld			bc, 4
			call		sub_fwrite
			; サイズを計算 (pixel count)
			call		sub_get_byte_size
			ld			[remain_size], hl
			; VDP Command をセット
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
			; 画面モードで分岐
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
			call		sub_vdpcmd_get_one_pixel		; Aにゲットした値, Cに vdpport1 をセットして呼ぶ。Bは破壊
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
			; ファイルに書き出す
			ld			hl, fcb
			ld			de, [buffer_start]
			ld			bc, [transfer_size]
			call		sub_fwrite
			; 残りがあるかチェック
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
			; ファイルに書き出す
			ld			hl, fcb
			ld			de, [buffer_start]
			ld			bc, [transfer_size]
			call		sub_fwrite
			; 残りがあるかチェック
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
			; ファイルに書き出す
			ld			hl, fcb
			ld			de, [buffer_start]
			ld			bc, [transfer_size]
			call		sub_fwrite
			; 残りがあるかチェック
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
			; 転送サイズを計算する
	_calc_transfer_size:
			ld			hl, [buffer_size]
			ld			de, [remain_size]
			rst			0x20
			jr			nc, _small_remain_size		; buffer_size ≧ remain_size なら _small_remain_size へ
			; buffer_size < remain_size の場合
			ld			[transfer_size], hl			; 転送サイズ = buffer_size
			ccf
			ex			de, hl
			sbc			hl, de
			ld			[remain_size], hl			; remain_size から buffer_size を削減 (transfer_size へ移動)
			ld			de, [transfer_size]
			ld			hl, [buffer_start]
			ret
	_small_remain_size:
			ld			[transfer_size], de			; 転送サイズ = remain_size
			ld			hl, 0
			ld			[remain_size], hl			; remain_size を 0 にする (transfer_size へ全て移動)
			ld			de, [transfer_size]
			ld			hl, [buffer_start]
			ret
			endscope

; =============================================================================
;	DIR に対応した ARG の設定と、DX, DY の位置調整
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
;			0: 始点(DX, DY)
;			1: 始点(DX, DY) 左右反転
;			2: 始点(DX, DY) 上下反転
;			3: 始点(DX, DY) 上下左右反転
;			4: 始点(DX, DY)
;			5: 始点(DX+NX-1,DY) 左右反転
;			6: 始点(DX,DY+NY-1) 上下反転
;			7: 始点(DX+NX-1,DY+NY-1) 上下左右反転
; =============================================================================
			scope		sub_adjust_dir
sub_adjust_dir::
			; DIR に応じて微調整
			bit			2, a
			jr			z, _skip_adjust
			; 水平方向の微調整
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
;		BC ..... 掛けられる数
;		DE ..... 掛ける数
;	output:
;		HL ..... BC * DE
;	break:
;		all
;	comment:
;		桁あふれは起こらない値が設定されている前提
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
