_sub_input_all_blank:
	; �߂�A�h���X (�^��񂪓����Ă���A�h���X) ���Ƃ��Ă���
	pop		bc
_sub_input_all_blank_loop:
	ld		a, [bc]					; �^����ǂ� 0:�[��, 2:����, 3:������, 4:�P���x, 8:�{���x
	inc		bc
	or		a, a
	jr		z, _sub_input_all_blank_exit
	cp		a, 3
	jr		nz, _sub_input_all_blank_put
	; �����񂾂����ꍇ�́A��قǉ��������ɒǉ����Ă���A"" ���l�߂�
	pop		hl						; �ϐ��̃A�h���X
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
	pop		hl						; �ϐ��̃A�h���X
	ld		e, 0
_sub_input_all_blank_fill:
	ld		[hl], e
	inc		hl
	dec		a
	jr		nz, _sub_input_all_blank_fill
	jr		_sub_input_all_blank_loop
_sub_input_all_blank_exit:
	