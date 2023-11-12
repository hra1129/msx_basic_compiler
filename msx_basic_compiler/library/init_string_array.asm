;	HL ... 文字列配列の実体の先頭 (要素 (0,0,...,0) のアドレス)
;	DE ... 詰めるサイズ (byte数)

init_string_array::
		ld		bc, str_0
	_init_string_array_loop:
		ld		[hl], c
		inc		hl
		ld		[hl], b
		inc		hl
		dec		de
		dec		de
		ld		a, e
		or		a, d
		jr		nz, _init_string_array_loop
		ret
