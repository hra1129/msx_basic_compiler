; 文字列の解放処理
;	HL ..... 解放対象の文字列のアドレス
;
;	文字列が、HEAP上に無かった場合は、何もせずに戻る。
;
free_string:
	; heap上の値か？それとも定数か？
	LD			DE, heap_start
	RST			0x20						; CP HL,DE
	RET			C							; 定数なら何もせずに戻る
	LD			DE, [heap_next]
	RST			0x20						; CP HL,DE
	RET			NC							; BIOSワークなら何もせずに戻る
	; 解放サイズを BC に入れる
	LD			C, [HL]
	LD			B, 0
	INC			BC
	JP			free_heap

; HEAP上の領域を開放する
;	HL ..... 解放する領域のアドレス
;	BC ..... 解放するサイズ
free_heap:
	PUSH		HL							; 転送先アドレス
	ADD			HL, BC						; 転送元アドレス, Cy = 0
	EX			DE, HL
	LD			HL, [heap_next]
	SBC			HL, DE
	LD			C, L
	LD			B, H						; 転送サイズ = heap_next - 転送元アドレス
	POP			HL
	EX			DE, HL
	LD			[heap_move_size], BC		; サイズを保存
	LD			[heap_remap_address], HL	; 転送元アドレスを保存
	LD			A, C
	OR			A, B
	JR			Z, _free_heap_loop0
	LDIR									; 内容を移動する
_free_heap_loop0:
	LD			[heap_next], DE				; 新しい heap_next
	; vars_***, vara_***, varsa_*** をリロケート
	LD			HL, vars_area_start
_free_heap_loop1:
	LD			DE, varsa_area_end
	RST			0x20						; CP 探索中のアドレス, varsa_area_end
	JR			NC, _free_heap_loop1_end
	; 文字列変数が保持するアドレス値を DE に得る
	LD			E, [HL]
	INC			HL
	LD			D, [HL]
	PUSH		HL
	; heap_remap_address 以上の値なら対象
	LD			HL, [heap_remap_address]
	EX			DE, HL
	RST			0x20						; CP 文字列のアドレス, heap_remap_address
	JR			C, _free_heap_loop1_next	; 対象外なら飛ぶ
	; 対象のアドレスなので処理する
	LD			HL, [heap_move_size]
	EX			DE, HL
	SBC			HL, DE
	POP			DE
	EX			DE, HL
	DEC			HL
	LD			[HL], E
	INC			HL
	LD			[HL], D
	PUSH		HL
_free_heap_loop1_next:
	; 次の変数の処理
	POP			HL
	INC			HL
	JR			_free_heap_loop1
_free_heap_loop1_end:
	; varsa_*** の指し示す先をリロケート
	LD			HL, varsa_area_start
_free_heap_loop2:
	LD			DE, varsa_area_end
	RST			0x20						; CP 探索中のアドレス, varsa_area_end
	RET			NC
	; 文字列配列変数が保持するアドレス値を DE に得る
	LD			E, [HL]
	INC			HL
	LD			D, [HL]
	INC			HL
	PUSH		HL
	; 実体のアドレスに変換する
	EX			DE, HL
	LD			E, [HL]						; DE = サイズ
	INC			HL
	LD			D, [HL]
	INC			HL
	LD			C, [HL]						; BC = 次元数
	INC			HL
	LD			B, 0
	ADD			HL, BC
	ADD			HL, BC						; Cy = 0
	EX			DE, HL						; サイズから、要素数格納領域の分を減らす
	SBC			HL, BC						; Cy = 0
	SBC			HL, BC						; Cy = 0
	RR			H
	RR			L							; HL = HL >> 1 次元数分の 1 はここで消滅
	LD			C, L
	LD			B, H
	EX			DE, HL
	; 文字列配列変数１つ分
_free_heap_sarray_elements:
	LD			E, [HL]
	INC			HL
	LD			D, [HL]
	PUSH		HL
	; 文字列配列変数の中の要素１つ分
	; heap_remap_address 以上の値なら対象
	LD			HL, [heap_remap_address]
	EX			DE, HL
	RST			0x20						; CP 文字列のアドレス, heap_remap_address
	JR			C, _free_heap_loop2_next	; 対象外なら飛ぶ
	; 対象のアドレスなので処理する
	LD			HL, [heap_move_size]
	SBC			HL, DE
	POP			DE
	EX			DE, HL
	DEC			HL
	LD			[HL], E
	INC			HL
	LD			[HL], D
	PUSH		HL
_free_heap_loop2_next:
	POP			HL
	INC			HL
	DEC			BC
	LD			A, C
	OR			A, B
	JR			NZ, _free_heap_sarray_elements
	POP			HL
	JR			_free_heap_loop2

===============================================================================
DIM宣言無し数値配列の確保
	D .... 次元数
	HL ... 配列変数のアドレス
	BC ... 確保するサイズ ( 2 + 1 + 2*B + (11^B)*要素サイズ
	
	HL は維持される。
===============================================================================
check_array:
	; アドレスが 0 かどうか調べる
	ld			a, [hl]
	inc			hl
	or			a, [hl]
	dec			hl
	ret			nz						; 既に確保されている(0でない)ので何もせずに戻る

	push		de						; 次元数保存
	push		hl						; 配列のアドレス保存
	push		bc						; サイズ保存
	call		allocate_heap			; サイズBC のメモリを確保して、HLにアドレスを得る
	pop			bc						; サイズ復帰
	pop			de						; 配列のアドレス復帰
	pop			af						; 次元数復帰
	ex			de, hl
	push		hl						; 配列のアドレス保存
	ld			[hl], e
	inc			hl
	ld			[hl], d
	ex			de, hl

	dec			bc						; [サイズ]フィールドの分は、[サイズ]フィールドに格納する値には含まないので 2減らす
	dec			bc
	ld			[hl], c					; [サイズ]フィールドへの書き込み
	inc			hl
	ld			[hl], b
	inc			hl
	ld			[hl], a					; [次元]フィールドへの書き込み
	ld			b, a
	ld			de, 11
_loop:									; 次元数繰り返し 11 を書き込む（要素数フィールド)
	ld			[hl], e
	inc			hl
	ld			[hl], d
	inc			hl
	djnz		_loop
	pop			hl						; 配列のアドレス復帰
	ret

===============================================================================
DIM宣言無し文字列配列の確保
	D .... 次元数
	HL ... 配列変数のアドレス
	BC ... 確保するサイズ ( 2 + 1 + 2*B + (11^B)*要素サイズ
	
	HL は維持される。
===============================================================================
check_sarray:
	; アドレスが 0 かどうか調べる
	ld			a, [hl]
	inc			hl
	or			a, [hl]
	dec			hl
	ret			nz						; 既に確保されている(0でない)ので何もせずに戻る

	push		de						; 次元数保存
	push		hl						; 配列のアドレス保存
	push		bc						; サイズ保存
	call		allocate_heap			; サイズBC のメモリを確保して、HLにアドレスを得る
	pop			bc						; サイズ復帰
	pop			de						; 配列のアドレス復帰
	pop			af						; 次元数復帰
	ex			de, hl
	push		hl						; 配列のアドレス保存
	ld			[hl], e
	inc			hl
	ld			[hl], d
	ex			de, hl

	dec			bc						; [サイズ]フィールドの分は、[サイズ]フィールドに格納する値には含まないので 2減らす
	dec			bc
	ld			[hl], c					; [サイズ]フィールドへの書き込み
	inc			hl
	ld			[hl], b
	inc			hl
	ld			[hl], a					; [次元]フィールドへの書き込み
	or			a, a
	rr			b						; [次元]フィールド分の 1 によって奇数になっているが、ここで消滅する
	rr			c
	ld			de, 11
_loop:									; 次元数繰り返し 11 を書き込む（要素数フィールド)
	ld			[hl], e
	inc			hl
	ld			[hl], d
	inc			hl
	dec			bc						; 要素数を引く
	dec			a
	jr			nz, _loop
	; 空文字列を詰める
	ld			de, str_0				; 空文字ラベル
	ld			[hl], e
	inc			hl
	ld			[hl], d
	inc			hl
	ld			e, l
	ld			d, h
	dec			hl
	dec			hl
	dec			bc
	ldir
	pop			hl						; 配列のアドレス復帰
	ret
