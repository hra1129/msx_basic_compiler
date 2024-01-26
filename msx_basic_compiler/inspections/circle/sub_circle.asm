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
work_circle_centerx		:= work_buf + 70	;	中心座標X
work_circle_centery		:= work_buf + 72	;	中心座標Y
work_circle_radiusx		:= work_buf + 74	;	水平半径
work_circle_radiusy		:= work_buf + 76	;	垂直半径
work_circle_prev_cxoff1	:= work_buf + 78	;	1つ前の cxoff (水平半径 * COS)
work_circle_prev_cyoff1	:= work_buf + 80	;	1つ前の cyoff (垂直半径 * SIN)
work_circle_prev_cxoff2	:= work_buf + 82	;	1つ前の cxoff (水平半径 * SIN)
work_circle_prev_cyoff2	:= work_buf + 84	;	1つ前の cyoff (垂直半径 * COS)
work_circle_cxoff1		:= work_buf + 86	;	1つ前の cxoff (水平半径 * COS)
work_circle_cyoff1		:= work_buf + 88	;	1つ前の cyoff (垂直半径 * SIN)
work_circle_cxoff2		:= work_buf + 90	;	1つ前の cxoff (水平半径 * SIN)
work_circle_cyoff2		:= work_buf + 92	;	1つ前の cyoff (垂直半径 * COS)

WORK_ARG                := 0x0F847

bios_chgmod				:= 0x0005F

work_gxpos				:= 0x0FCB3
work_gypos				:= 0x0FCB5
work_aspect				:= 0x0F931			;	比率 single real
work_cpcnt				:= 0x0F939			;	開始点 single real
work_crcsum				:= 0x0F93D			;	終了点 single real
work_csclxy				:= 0x0F941			;	円弧の分解能
work_savea				:= 0x0F942			;	未使用
work_savem				:= 0x0F944			;	0: 開始角 > 終了角、1: 開始角 < 終了角
work_cxoff				:= 0x0F945			;	水平半径
work_cyoff				:= 0x0F947			;	垂直半径
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
			; 中心座標
			ld			hl, 128
			ld			[work_circle_centerx], hl
			ld			hl, 106
			ld			[work_circle_centery], hl
			; 比率
			ld			hl, single_0p5
			ld			de, work_aspect
			call		ld_de_hl_for_single
			; 色
			ld			a, 15
			call		bios_setatr

			; 半径
			ld			hl, 25
			ld			[work_circle_radiusx], hl
			; 開始点
			ld			hl, single_0
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; 終了点
			ld			hl, single_1
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; 描画
			call		sub_circle

			; 半径
			ld			hl, 50
			ld			[work_circle_radiusx], hl
			; 開始点
			ld			hl, single_1
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; 終了点
			ld			hl, single_2
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; 描画
			call		sub_circle

			; 半径
			ld			hl, 100
			ld			[work_circle_radiusx], hl
			; 開始点
			ld			hl, single_1
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; 終了点
			ld			hl, single_0
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; 描画
			call		sub_circle

			; 半径
			ld			hl, 150
			ld			[work_circle_radiusx], hl
			; 開始点
			ld			hl, single_2
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; 終了点
			ld			hl, single_1
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; 描画
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
	;	垂直半径を計算する
			LD		HL, work_aspect					;	比率
			CALL	ld_arg_single_real
			LD		HL, [work_circle_radiusx]		;	水平半径
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
	;	開始角を 0～255 に変換する
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
	;	終了角を 0～255 に変換する
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
	;	開始角と終了角の大小判定
			LD		B, A					; B = 終了角
			LD		A, [work_cpcnt]			; A = 開始角
			CP		A, B
			LD		A, 0
			RLA
			LD		[work_savem], A
	;	sinテーブルをゲットする
			LD		IX, blib_get_sin_table
			CALL	call_blib
	;	半径初期値
			LD		HL, [work_circle_radiusx]
			LD		[work_circle_cxoff1], HL
			LD		HL, [work_circle_radiusy]
			LD		[work_circle_cyoff2], HL
			LD		HL, 0
			LD		[work_circle_cxoff2], HL
			LD		[work_circle_cyoff1], HL
	;	θ = 0°→45°
			LD		A, [work_csclxy]
			LD		B, A
			PUSH	BC
	_sub_circle_theta_loop:
			LD		A, B
	;		直前の値を prev へ移動
			LD		HL, work_circle_cxoff1
			LD		DE, work_circle_prev_cxoff1
			LD		BC, 8
			LDIR
	;		X1 = cosθ * 水平半径, Y2 = cosθ * 垂直半径
			CALL	_sub_circle_cos			; HL = cosθ
			PUSH	HL
			LD		BC, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		[work_circle_cxoff1], HL
			POP		HL
			LD		BC, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		[work_circle_cyoff2], HL
	;		Y1 = sinθ* 垂直半径, X2 = sinθ * 水平半径
			POP		AF
			PUSH	AF
			CALL	_sub_circle_sin			; HL = sinθ
			PUSH	HL
			LD		BC, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		[work_circle_cyoff1], HL
			POP		HL
			LD		BC, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		[work_circle_cxoff2], HL
	;		第0象限 (0～90°)
	_sub_circle_quadrant0_process:
			LD		A, [work_circle_quadrant0]
			OR		A, A
			JR		NZ, _sub_circle_quadrant1_process
			POP		BC
			PUSH	BC
			LD		A, 3
			CALL	_sub_circle_quadrant_process
	;		第1象限 (90～180°)
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
	;		第2象限 (180～270°)
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
	;		第3象限 (270～360°)
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

	; B が描画対象かどうか調べる
	; Cy = 0: 対象, 1: 非対象
	_sub_circle_check_angle:
			; 開始点と終了点の大小関係は？
			LD		A, [work_savem]
			OR		A, A
			JR		Z, _sub_circle_check_angle_cond_or
	_sub_circle_check_angle_cond_and:
			; 開始点より大きいか？
			LD		A, [work_cpcnt]
			OR		A, A								; 0の場合は対象候補
			JR		Z, _sub_circle_check_angle_left1
			CP		A, B
			CCF
			RET		C									; 着目点 ＜ 開始点 なら非対象
	_sub_circle_check_angle_left1:
			; 開始点よりも大きい。では、終了点より小さいか？
			LD		A, [work_crcsum]
			OR		A, A								; 0の場合は無条件で対象
			RET		Z
			CP		A, B
			RET											; 着目点 ＞ 終了点 なら非対象
	_sub_circle_check_angle_cond_or:
			; 開始点より大きいか？
			LD		A, [work_cpcnt]
			CP		A, B
			CCF
			RET		NC									; 着目点 ＞ 開始点 なら対象
			; 開始点よりも小さい。では、終了点より小さいか？
			LD		A, [work_crcsum]
			CP		A, B
			RET											; 着目点 ＞ 終了点 なら非対象

	; A の bit0 が 0 なら X符号反転、bit1 が 0 なら Y符号反転
	; B に角度 0～31 (0°～45°)
	_sub_circle_quadrant_process:
			PUSH	BC
			PUSH	AF
			LD		C, A
			CALL	_sub_circle_check_angle
			JR		C, _sub_circle_quadrant_line1_skip
			LD		A, C
			; 始点X1
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_cxoff1]
			RRCA										; A の bit0 を Cy へ
			JR		C, _sub_circle_quadrant_process_add_cx1
	_sub_circle_quadrant_process_sub_cx1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_cx1
	_sub_circle_quadrant_process_add_cx1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_cx1:
			LD		[work_gxpos], HL

			; 始点Y1
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_cyoff1]
			RRCA										; A の bit1 を Cy へ
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
			; 終点X1
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_prev_cxoff1]
			RRCA										; A の bit0 を Cy へ
			JR		C, _sub_circle_quadrant_process_add_pcx1
	_sub_circle_quadrant_process_sub_pcx1:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcx1
	_sub_circle_quadrant_process_add_pcx1:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcx1:
			LD		C, L
			LD		B, H

			; 終点Y1
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_prev_cyoff1]
			RRCA										; A の bit1 を Cy へ
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
			; 始点X2
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_cxoff2]
			RRCA										; A の bit0 を Cy へ
			JR		NC, _sub_circle_quadrant_process_add_cx2
	_sub_circle_quadrant_process_sub_cx2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_cx2
	_sub_circle_quadrant_process_add_cx2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_cx2:
			LD		[work_gxpos], HL

			; 始点Y2
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_cyoff2]
			RRCA										; A の bit1 を Cy へ
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
			; 終点X2
			LD		HL, [work_circle_centerx]
			LD		DE, [work_circle_prev_cxoff2]
			RRCA										; A の bit0 を Cy へ
			JR		NC, _sub_circle_quadrant_process_add_pcx2
	_sub_circle_quadrant_process_sub_pcx2:
			SBC		HL, DE
			JR		_sub_circle_quadrant_process_set_pcx2
	_sub_circle_quadrant_process_add_pcx2:
			ADD		HL, DE
	_sub_circle_quadrant_process_set_pcx2:
			LD		C, L
			LD		B, H

			; 終点Y2
			LD		HL, [work_circle_centery]
			LD		DE, [work_circle_prev_cyoff2]
			RRCA										; A の bit1 を Cy へ
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
			RET		Z								; X1 も X2 もクリッピングして、かつ同じ値なら描画不要
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

	; HL に入っている X座標をクリップ
	; クリッピングした場合、Cy=1 で戻る
	_sub_circle_x_clip:
			LD		A, H
			RLA
			JR		NC, _sub_circle_x_clip_skip1
			LD		HL, 0
			RET									; 負数を 0 にクリップした場合。Cy=1 で戻る
	_sub_circle_x_clip_skip1:
			LD		A, [work_aspct1 + 1]
			DEC		A
			CP		A, H
			RET		NC							; 0～255 (511) の範囲を超えていない場合は Cy=0 で戻る
			LD		HL, [work_aspct1]
			DEC		HL
			SCF
			RET									; 255 (511) に置換して Cy=1 で戻る

	; HL に入っている Y座標をクリップ
	; クリッピングした場合、Cy=1 で戻る
	_sub_circle_y_clip:
			LD		A, H
			RLA
			JR		NC, _sub_circle_y_clip_skip1
			LD		HL, 0
			RET									; 負数を 0 にクリップした場合。Cy=1 で戻る
	_sub_circle_y_clip_skip1:
			LD		A, H
			OR		A, A
			JR		Z, _sub_circle_y_clip_skip2
			LD		HL, 211
			LD		A, [work_rg9sav]
			RLA
			RET		C							; 211にクリップした場合。Cy=1 で戻る
			LD		L, 191
			CCF
			RET									; 191にクリップした場合。Cy=1 で戻る
	_sub_circle_y_clip_skip2:
			LD		A, L
			CP		A, 192
			CCF
			RET		NC							; クリップの必要が無い場合。Cy=0 で戻る。
			LD		A, [work_rg9sav]
			RLA
			JR		NC, _sub_circle_y_clip_192
			LD		A, L
			CP		A, 212
			CCF
			RET		NC							; クリップの必要が無い場合。Cy=0 で戻る。
			LD		L, 211
			RET									; 211にクリップした場合。Cy=1 で戻る。
	_sub_circle_y_clip_192:
			LD		L, 191
			SCF
			RET									; 191にクリップした場合。Cy=1 で戻る。

	_sub_circle_line_process:
			RET

	;	HL = HL * BC >> 8  ※HL=符号付き, BC=符号無し
	;	   = (HL * C >> 8) + HL * B
	_sub_circle_mul:
			LD		A, H
			OR		A, A
			PUSH	AF								; 負数なら S=1
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
	;	cosθを返す: A = θ (0:0°～255:359°) → A = cosθ
	_sub_circle_cos:
			SUB		A, 64
	;	sinθを返す: A = θ (0:0°～255:359°) → A = sinθ
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
			ADD		A, work_buf & 0x0FF		; 繰り上がりは発生しない
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
