; =============================================================================
;	数値を文字列に変換するテスト
; -----------------------------------------------------------------------------
;	2023/Aug/15th
; =============================================================================

		db		0xFE
		dw		start_address
		dw		end_address
		dw		start_address


FOUT	:= 0x3425						; DataPack に記載の 3225h は誤記。
DAC		:= 0xF7F6
VALTYP	:= 0xF663

		org		0xC000
start_address:
		;----------------------------------------------------------------------
		ld		hl, DBLVAL1
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 4					; 単精度実数 負数
		ld		[VALTYP], a

		call	FOUT					; 文字列変換

		;----------------------------------------------------------------------
		ld		hl, DBLVAL1
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; 倍精度実数 負数
		ld		[VALTYP], a

		call	FOUT					; 文字列変換

		;----------------------------------------------------------------------
		ld		hl, DBLVAL2
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 4					; 単精度実数 正数
		ld		[VALTYP], a

		call	FOUT					; 文字列変換

		;----------------------------------------------------------------------
		ld		hl, DBLVAL2
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; 倍精度実数 正数
		ld		[VALTYP], a

		call	FOUT					; 文字列変換

		;----------------------------------------------------------------------
		ld		hl, DBLVAL3
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 2					; 整数 正
		ld		[VALTYP], a

		call	FOUT					; 文字列変換

		;----------------------------------------------------------------------
		ld		hl, DBLVAL4
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 2					; 整数 負
		ld		[VALTYP], a

		call	FOUT					; 文字列変換

		;----------------------------------------------------------------------
		ld		hl, DBLVAL5
		ld		de, DAC
		ld		bc, 8
		ldir

		ld		a, 8					; 倍精度
		ld		[VALTYP], a

		call	FOUT					; 文字列変換
		ret

DBLVAL1:	;	99999.999999999
		db		0x00 | 0xC5				; 負数, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99

DBLVAL2:	;	99999.999999999
		db		0x00 | 0x45				; 正数, E+5
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99

DBLVAL3:	;	整数 12345
		db		0x00
		db		0x00
		dw		12345
		db		0x00
		db		0x00
		db		0x00
		db		0x00

DBLVAL4:	;	整数 -100
		db		0x00
		db		0x00
		dw		-100
		db		0x00
		db		0x00
		db		0x00
		db		0x00

DBLVAL5:	;	99999.999999999
		db		0x00 | 0x7F				; 正数, E+63
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
		db		0x99
end_address:
