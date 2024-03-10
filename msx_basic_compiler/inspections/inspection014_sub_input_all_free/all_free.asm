_sub_input_all_free:
	ld		de, 0
	ld		hl, svars_input_free_str0
	ld		a, 7
_sub_input_all_free_loop:
	ld		c, [hl]		; BC = svars_input_free_str[7-a]
	inc		hl
	ld		b, [hl]
	or		a, a
	ex		de, hl
	sbc		hl, bc		; if de >= bc then _sub_input_all_free_no_swap
	ex		de, hl
	jr		nc, _sub_input_all_free_no_swap
	ld		e, c
	ld		d, b
	ld		[hl], b
	dec		hl
	ld		[hl], c
	inc		hl
_sub_input_all_free_no_swap:
	inc		hl
	dec		a
	jr		nz, _sub_input_all_free_loop
	ld		a, e
	or		a, d
	ret		z
	ex		de, hl
	call	free_string
	jr		_sub_input_all_free
