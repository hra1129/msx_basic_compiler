;	HL ... ������z��̎��̂̐擪 (�v�f (0,0,...,0) �̃A�h���X)
;	DE ... �l�߂�T�C�Y (byte��)

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
