; E .... 文字数
; HL ... 反復文字列のアドレス
string:
		ld		a, [hl]
		or		a, a
		inc		hl				; フラグ不変
		ld		a, [hl]			; フラグ不変
		jp		nz, string_skip
		ld		e, 5
		jp		bios_errhand
string_skip:
		push	af
		ld		a, e
		call	allocate_string
		pop		af
		push	hl
		inc		hl
		ld		b, c
		inc		b
		jr		string_loop_enter
string_loop:
		ld		[hl], a
		inc		hl
string_loop_enter:
		djnz	string_loop
		pop		hl
		ret
