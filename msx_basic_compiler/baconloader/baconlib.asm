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
errhand		:= 0x406F					; BIOS の BASICエラー処理ルーチン E にエラーコード。戻ってこない。
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
fnkstr		:= 0xF87F					; ファンクションキーの文字列 16文字 x 10個
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
			push	de
			call	_send_device_path
			; 受信コマンド送信
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; 整数型識別コード送信
			ld		a, 0x01
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
			push	de
			call	_send_device_path
			; 受信コマンド送信
			ld		a, 0xe0
			out		[c], a
			ld		a, 0x01
			out		[c], a
			; 文字列型識別コード送信
			ld		a, 0x03
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
			ld		h, a
			ld		a, [scrmod]
			dec		a
			cp		a, 12
			jp		nc, err_syntax
			cp		a, 3
			jr		nc, _sprite_mode2
	_sprite_mode1:
			; スプライトアトリビュートを求める
			ld		a, h
			push	de					; パターンと色保存
			push	hl					; フラグ保存
			call	calatr
			pop		de					; フラグ復帰
			ld		a, e
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
