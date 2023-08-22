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
	LD			E, L
	LD			D, H						; 転送先アドレス
	ADD			HL, BC						; 転送元アドレス
	EX			DE, HL
	PUSH		HL
	LD			HL, [heap_next]
	OR			A, A
	SBC			HL, DE
	LD			C, L
	LD			B, H						; 転送サイズ = heap_next - 転送元アドレス
	POP			HL
	EX			DE, HL
	LD			[heap_move_size], BC		; サイズを保存
	LD			[heap_remap_address], HL	; 転送元アドレスを保存
	LD			[heap_next], DE				; 新しい heap_next
	LD			A, B
	OR			C
	JR			Z, _free_heap_loop1
	LDIR									; 内容を移動する
	LD			[heap_next], DE				; 新しい heap_next
	; vars_***, vara_***, varsa_*** をリロケート
	LD			HL, vars_area_start
_free_heap_loop1:
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
	LD			DE, varsa_area_end
	RST			0x20						; CP 探索中のアドレス, varsa_area_end
	JR			C, _free_heap_loop1
	; varsa_*** の指し示す先をリロケート
	; ★T.B.D.
	RET
