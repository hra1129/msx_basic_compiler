memo:
	https://www.msx.org/wiki/BASIC_Routines_In_Main-ROM

CALL IOTGET( デバイスパス, 変数 )

デバイスパスを送るサブルーチン
	HL: 文字列のアドレス [HL] 長さ, [HL+1 ... ] 文字列

iot_set_device_path:
		LD		C, 8
		; デバイスパス送信開始コマンド
		LD		A, 0xE0
		OUT		[C], A
		LD		A, 1
		OUT		[C], A
		LD		A, 0x53
		OUT		[C], A

		LD		A, 0xC0
		OUT		[C], A
		; 文字列の長さを取得
		LD		A, [HL]
_iot_set_device_path_loop1:
		LD		B, A
		CP		A, 64							; 64文字以上の場合は特別処理を実施する
		JR		C, _iot_set_device_path_skip
		SUB		A, 63
		LD		B, 0x7F							; 特別処理を示すコード
_iot_set_device_path_skip:
		OUT		[C], B
		LD		D, A
		LD		A, B
		AND		A, 0x3F
		LD		B, A
_iot_set_device_path_loop2:
		INC		HL
		LD		A, [HL]
		OUT		[C], A
		DJNZ	_iot_set_device_path_loop2
		LD		A, D
		SUB		A, 63
		JR		Z, _iot_set_device_path_exit
		JR		NC, _iot_set_device_path_loop1
_iot_set_device_path_exit:
		IN		A, [C]
		RLCA									; エラーなら Cf = 1, 正常なら Cf = 0
		RET		NC
		LD		E, 0x13
		JP		0x406F							; bios_errhand

; HL ... 取得した値
iotget_integer:
		; 受信コマンド送信
		LD		A, 0xE0
		OUT		[8], A
		LD		A, 0x01
		OUT		[8], A
		; 整数型識別コード送信
		LD		A, 0x01
		OUT		[8], A
		; 受信開始
		LD		A, 0x80
		OUT		[8], A
		IN		A, [8]		; 多分長さ 2 が返ってくる
		IN		L, [8]
		IN		H, [8]
		RET

; HL ... 取得した値
iotget_string:
		; 受信コマンド送信
		LD		A, 0xE0
		OUT		[8], A
		LD		A, 0x01
		OUT		[8], A
		; 文字列型識別コード送信
		LD		A, 0x03
		OUT		[8], A
		; 受信開始
		LD		A, 0x80
		OUT		[8], A
		IN		A, [8]		; 文字列長
		CALL	allocate_string
		OR		A, A
		RET		Z			; 長さ 0 なら何もしない
		PUSH	HL
		LD		B, A
_iotget_string_loop:
		INC		HL
		IN		A, [8]
		LD		[HL], A
		DJNZ	_iotget_string_loop
		POP		HL
		RET
