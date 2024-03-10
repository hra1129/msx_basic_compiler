_sub_input_all_blank:
	; 戻りアドレス (型情報が入っているアドレス) をとってくる
	pop		bc
_sub_input_all_blank_loop:
	ld		a, [bc]					; 型情報を読む 0:端末, 2:整数, 3:文字列, 4:単精度, 8:倍精度
	inc		bc
	or		a, a
	jr		z, _sub_input_all_blank_exit
	cp		a, 3
	jr		nz, _sub_input_all_blank_put
	; 文字列だった場合は、後ほど解放する候補に追加してから、"" を詰める
	pop		hl						; 変数のアドレス
	ld		e, [hl]
	inc		hl
	ld		d, [hl]
	ld		[hl], str_0 >> 8
	dec		hl
	ld		[hl], str_0 & 255
	ld		hl, SVARS_INPUT_FREE_STR0
_sub_input_all_blank_regist_loop:
	ld		a, [hl]
	inc		hl
	or		a, [hl]
	jr		z, _sub_input_all_blank_regist
	inc		hl
	jr		_sub_input_all_blank_regist_loop
_sub_input_all_blank_regist:
	ld		[hl], d
	dec		hl
	ld		[hl], e
	jr		_sub_input_all_blank_loop
_sub_input_all_blank_put:
	pop		hl						; 変数のアドレス
	ld		e, 0
_sub_input_all_blank_fill:
	ld		[hl], e
	inc		hl
	dec		a
	jr		nz, _sub_input_all_blank_fill
	jr		_sub_input_all_blank_loop
_sub_input_all_blank_exit:
	