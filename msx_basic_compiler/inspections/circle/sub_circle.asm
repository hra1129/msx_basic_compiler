BIOS_CALSLT         	:= 0x0001C
bios_decmul				:= 0x027e6
bios_int				:= 0x030cf
blib_get_sin_table		:= 0x040de
WORK_BLIBSLOT			:= 0x0F3D3
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
work_circle_prev_cxoff	:= work_buf + 78	;	1つ前の cxoff
work_circle_prev_cyoff	:= work_buf + 80	;	1つ前の cyoff

WORK_ARG                := 0x0F847

bios_chgmod				:= 0x0005F

work_gxpos				:= 0x0FCB3
work_gypos				:= 0x0FCB5
work_aspect				:= 0x0F931			;	比率 single real
work_cxoff				:= 0x0F945			;	水平オフセット
work_cyoff				:= 0x0F947			;	垂直オフセット
work_cpcnt				:= 0x0F939			;	開始点 single real
work_crcsum				:= 0x0F93D			;	終了点 single real
work_csclxy				:= 0x0F941			;	ループ回数
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
			ld			[work_gxpos], hl
			ld			hl, 106
			ld			[work_gypos], hl
			; 半径
			ld			hl, 100
			ld			[work_cxoff], hl
			; 開始点
			ld			hl, single_0
			ld			de, work_cpcnt
			call		ld_de_hl_for_single
			; 終了点
			ld			hl, single_0
			ld			de, work_crcsum
			call		ld_de_hl_for_single
			; 比率
			ld			hl, single_1
			ld			de, work_aspect
			; 色
			ld			a, 15
			call		bios_setatr
			; 描画
			call		sub_circle
loop:
			jr			loop
			RET
single_0:
			defb		0x00, 0x00, 0x00, 0x00
single_1:
			defb		0x41, 0x10, 0x00, 0x00

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
			scope		test_001_sin_cos
test_001_sin_cos::
	;	sinテーブルをゲットする
			LD			IX, blib_get_sin_table
			CALL		call_blib
			xor			a, a
			ld			de, result_table
	loop:
			push		de
			push		af
			call		_sub_circle_cos
			pop			af
			pop			de
			ex			de, hl
			ld			[hl], e
			inc			hl
			ld			[hl], d
			inc			hl
			ex			de, hl

			push		de
			push		af
			call		_sub_circle_sin
			pop			af
			pop			de
			ex			de, hl
			ld			[hl], e
			inc			hl
			ld			[hl], d
			inc			hl
			ex			de, hl

			inc			a
			jr			nz, loop
			ret

result_table:
			space		256*2*2
			endscope

; Circle routine --------------------------------------------------------------
sub_circle::
	;	垂直半径を計算する
			LD		HL, [work_cxoff]		;	水平半径
			LD		[work_dac + 2], HL
			LD		A, 2
			LD		[work_valtyp], A
			LD		DE, work_aspect		;	比率
			CALL	ld_arg_single_real
			CALL	bios_decmul
			CALL	bios_int
			LD		HL, [work_dac + 2]
			LD		A, [work_aspct2]
			RLCA
			JR		NC, _sub_circle_skip1
			SRL		H
			RR		L
	_sub_circle_skip1:
			LD		[work_cyoff], HL
			;	SCREEN6 or 7 なら [buf+65] = 1, それ以外は 0
			LD		A, [work_aspct1 + 1]
			RRCA
			LD		[work_circle_x_shift], A
			LD		C, A
			;	中心点の位置により、円の4象限の描画対象外を判定 buf+66 = [0] ... buf+69 = [3] (0なら対象、0以外なら対象外)
			LD		A, [work_gxpos + 1]
			LD		B, A
			AND		A, 0x80
			ld		hl, work_circle_quadrant1
			LD		[hl], A		;	[1]
			inc		hl
			LD		[hl], A		;	[2]
			inc		hl
			LD		A, B
			INC		C
			DEC		C
			JR		Z, _sub_circle_skip2
			RRCA
	_sub_circle_skip2:
			AND		A, 0x7F
			LD		[work_circle_quadrant0], A		;	[0]
			LD		[hl], A							;	[3]

			LD		A, [work_gypos + 1]
			LD		B, A
			LD		HL, work_circle_quadrant0
			AND		A, 0x80
			LD		C, A
			OR		A, [HL]
			LD		[HL], A					;	[0]
			INC		HL
			LD		A, C
			OR		A, [HL]
			LD		[HL], A					;	[1]
			INC		HL

			LD		A, B
			AND		A, 0x7F
			ld		c, a
			OR		A, [HL]
			ld		[hl], a					;	[2]
			inc		hl
			LD		A, C
			OR		A, [HL]
			LD		[HL], A					;	[3]
			INC		HL

	;	大きい方の半径を見て円の分解能を決める
			ld		hl, [work_cxoff]
			ld		de, [work_cyoff]
			rst		0x20					; CP HL, DE
			jr		c, _sub_circle_bigger_hl
			ex		de, hl
	_sub_circle_bigger_hl:
			

	;	sinテーブルをゲットする
			LD		IX, blib_get_sin_table
			CALL	call_blib
	;	θ = 45°→0°
			LD		B, 32
	_sub_circle_theta_loop:
	;		X1 = cosθ * 水平半径 + 中心X座標
			PUSH	BC
			LD		A, B
			CALL	_sub_circle_cos			; HL = cosθ
			LD		DE, [work_circle_radiusx]
			CALL	_sub_circle_mul
			LD		DE, [work_circle_centerx]
			ADD		HL, DE
			LD		[work_cxoff], HL
	;		Y1 = sinθ* 垂直半径 + 中心Y座標
			POP		AF
			PUSH	AF
			CALL	_sub_circle_sin			; HL = sinθ
			LD		DE, [work_circle_radiusy]
			CALL	_sub_circle_mul
			LD		DE, [work_circle_centery]
			ADD		HL, DE
			LD		[work_cyoff], HL
	;		次の角度
	

	;	HL = HL * DE >> 8
	_sub_circle_mul:
			LD		C, L
			LD		B, H
			LD		HL, 0
			LD		A, 8
	_sub_circle_mul_1st8bit:
			SRL		B
			RR		C
			JR		NC, _sub_circle_mul_1st8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_1st8bit_skip1:
			DEC		A
			JR		NZ, _sub_circle_mul_1st8bit
			LD		L, H
			LD		H, 0
	_sub_circle_mul_2nd8bit:
			SRL		B
			RR		C
			JR		NC, _sub_circle_mul_2nd8bit_skip1
			ADD		HL, DE
	_sub_circle_mul_2nd8bit_skip1:
			LD		A, C
			OR		A, B
			JR		NZ, _sub_circle_mul_2nd8bit
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
