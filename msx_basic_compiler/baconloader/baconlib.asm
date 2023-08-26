; =============================================================================
;	MSX-BACON Library
; -----------------------------------------------------------------------------
;	Copyright (C)2023 HRA!
; =============================================================================

rslreg		:= 0x0138
calbas		:= 0x0159
errhand		:= 0x406F					; BIOS の BASICエラー処理ルーチン E にエラーコード。戻ってこない。
blibslot	:= 0xF3D3
buf			:= 0xF55E
fnkstr		:= 0xF87F					; ファンクションキーの文字列 16文字 x 10個
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

			ld		a, 0xc0
			out		[c], a
			; 文字列の長さを取得
			ld		a, [hl]
	_iot_set_device_path_loop1:
			ld		b, a
			cp		a, 64							; 64文字以上の場合は特別処理を実施する
			jr		c, _iot_set_device_path_skip
			sub		a, 63
			ld		b, 0x7f							; 特別処理を示すコード
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
			rlca									; エラーなら cf = 1, 正常なら cf = 0
			ret		nc
			; エラー
			ld		e, error_device_IO
			ld		ix, errhand
			jp		calbas
			endscope

; =============================================================================
;	IOTGET (INTEGER)
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
;	IOTGET (STRING)
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
