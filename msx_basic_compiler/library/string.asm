; ������̉������
;	HL ..... ����Ώۂ̕�����̃A�h���X
;
;	�����񂪁AHEAP��ɖ��������ꍇ�́A���������ɖ߂�B
;
free_string:
	; heap��̒l���H����Ƃ��萔���H
	LD			DE, heap_start
	RST			0x20						; CP HL,DE
	RET			C							; �萔�Ȃ牽�������ɖ߂�
	LD			DE, [heap_next]
	RST			0x20						; CP HL,DE
	RET			NC							; BIOS���[�N�Ȃ牽�������ɖ߂�
	; ����T�C�Y�� BC �ɓ����
	LD			C, [HL]
	LD			B, 0
	INC			BC
	JP			free_heap

; HEAP��̗̈���J������
;	HL ..... �������̈�̃A�h���X
;	BC ..... �������T�C�Y
free_heap:
	PUSH		HL							; �]����A�h���X
	ADD			HL, BC						; �]�����A�h���X, Cy = 0
	EX			DE, HL
	LD			HL, [heap_next]
	SBC			HL, DE
	LD			C, L
	LD			B, H						; �]���T�C�Y = heap_next - �]�����A�h���X
	POP			HL
	EX			DE, HL
	LD			[heap_move_size], BC		; �T�C�Y��ۑ�
	LD			[heap_remap_address], HL	; �]�����A�h���X��ۑ�
	LD			A, C
	OR			A, B
	JR			Z, _free_heap_loop0
	LDIR									; ���e���ړ�����
_free_heap_loop0:
	LD			[heap_next], DE				; �V���� heap_next
	; vars_***, vara_***, varsa_*** �������P�[�g
	LD			HL, vars_area_start
_free_heap_loop1:
	LD			DE, varsa_area_end
	RST			0x20						; CP �T�����̃A�h���X, varsa_area_end
	JR			NC, _free_heap_loop1_end
	; ������ϐ����ێ�����A�h���X�l�� DE �ɓ���
	LD			E, [HL]
	INC			HL
	LD			D, [HL]
	PUSH		HL
	; heap_remap_address �ȏ�̒l�Ȃ�Ώ�
	LD			HL, [heap_remap_address]
	EX			DE, HL
	RST			0x20						; CP ������̃A�h���X, heap_remap_address
	JR			C, _free_heap_loop1_next	; �ΏۊO�Ȃ���
	; �Ώۂ̃A�h���X�Ȃ̂ŏ�������
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
	; ���̕ϐ��̏���
	POP			HL
	INC			HL
	JR			_free_heap_loop1
_free_heap_loop1_end:
	; varsa_*** �̎w��������������P�[�g
	LD			HL, varsa_area_start
_free_heap_loop2:
	LD			DE, varsa_area_end
	RST			0x20						; CP �T�����̃A�h���X, varsa_area_end
	RET			NC
	; ������z��ϐ����ێ�����A�h���X�l�� DE �ɓ���
	LD			E, [HL]
	INC			HL
	LD			D, [HL]
	INC			HL
	PUSH		HL
	; ���̂̃A�h���X�ɕϊ�����
	EX			DE, HL
	LD			E, [HL]						; DE = �T�C�Y
	INC			HL
	LD			D, [HL]
	INC			HL
	LD			C, [HL]						; BC = ������
	INC			HL
	LD			B, 0
	ADD			HL, BC
	ADD			HL, BC						; Cy = 0
	EX			DE, HL
	SBC			HL, BC						; Cy = 0
	SBC			HL, BC						; Cy = 0
	RRC			H
	RRC			L
	LD			C, L
	LD			B, H
	EX			DE, HL
	; ������z��ϐ��P��
_free_heap_sarray_elements:
	LD			E, [HL]
	INC			HL
	LD			D, [HL]
	PUSH		HL
	; ������z��ϐ��̒��̗v�f�P��
	; heap_remap_address �ȏ�̒l�Ȃ�Ώ�
	LD			HL, [heap_remap_address]
	EX			DE, HL
	RST			0x20						; CP ������̃A�h���X, heap_remap_address
	JR			C, _free_heap_loop2_next	; �ΏۊO�Ȃ���
	; �Ώۂ̃A�h���X�Ȃ̂ŏ�������
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
DIM�錾�������l�z��̊m��
	D .... ������
	HL ... �z��ϐ��̃A�h���X
	BC ... �m�ۂ���T�C�Y ( 2 + 1 + 2*B + (11^B)*�v�f�T�C�Y
	
	HL �͈ێ������B
===============================================================================
check_array:
	; �A�h���X�� 0 ���ǂ������ׂ�
	ld			a, [hl]
	inc			hl
	or			a, [hl]
	dec			hl
	ret			nz						; ���Ɋm�ۂ���Ă���(0�łȂ�)�̂ŉ��������ɖ߂�

	push		de						; �������ۑ�
	push		hl						; �z��̃A�h���X�ۑ�
	push		bc						; �T�C�Y�ۑ�
	call		allocate_heap			; �T�C�YBC �̃��������m�ۂ��āAHL�ɃA�h���X�𓾂�
	pop			bc						; �T�C�Y���A
	pop			de						; �z��̃A�h���X���A
	pop			af						; ���������A
	ex			de, hl
	push		hl						; �z��̃A�h���X�ۑ�
	ld			[hl], e
	inc			hl
	ld			[hl], d
	ex			de, hl

	dec			bc						; [�T�C�Y]�t�B�[���h�̕��́A[�T�C�Y]�t�B�[���h�Ɋi�[����l�ɂ͊܂܂Ȃ��̂� 2���炷
	dec			bc
	ld			[hl], c					; [�T�C�Y]�t�B�[���h�ւ̏�������
	inc			hl
	ld			[hl], b
	inc			hl
	ld			[hl], a					; [����]�t�B�[���h�ւ̏�������
	ld			b, a
	ld			de, 11
_loop:									; �������J��Ԃ� 11 ���������ށi�v�f���t�B�[���h)
	ld			[hl], e
	inc			hl
	ld			[hl], d
	inc			hl
	djnz		_loop
	pop			hl						; �z��̃A�h���X���A
	ret

===============================================================================
DIM�錾����������z��̊m��
	D .... ������
	HL ... �z��ϐ��̃A�h���X
	BC ... �m�ۂ���T�C�Y ( 2 + 1 + 2*B + (11^B)*�v�f�T�C�Y
	
	HL �͈ێ������B
===============================================================================
check_sarray:
	; �A�h���X�� 0 ���ǂ������ׂ�
	ld			a, [hl]
	inc			hl
	or			a, [hl]
	dec			hl
	ret			nz						; ���Ɋm�ۂ���Ă���(0�łȂ�)�̂ŉ��������ɖ߂�

	push		de						; �������ۑ�
	push		hl						; �z��̃A�h���X�ۑ�
	push		bc						; �T�C�Y�ۑ�
	call		allocate_heap			; �T�C�YBC �̃��������m�ۂ��āAHL�ɃA�h���X�𓾂�
	pop			bc						; �T�C�Y���A
	pop			de						; �z��̃A�h���X���A
	pop			af						; ���������A
	ex			de, hl
	push		hl						; �z��̃A�h���X�ۑ�
	ld			[hl], e
	inc			hl
	ld			[hl], d
	ex			de, hl

	dec			bc						; [�T�C�Y]�t�B�[���h�̕��́A[�T�C�Y]�t�B�[���h�Ɋi�[����l�ɂ͊܂܂Ȃ��̂� 2���炷
	dec			bc
	ld			[hl], c					; [�T�C�Y]�t�B�[���h�ւ̏�������
	inc			hl
	ld			[hl], b
	inc			hl
	ld			[hl], a					; [����]�t�B�[���h�ւ̏�������
	or			a, a
	rr			b						; [����]�t�B�[���h���� 1 �ɂ���Ċ�ɂȂ��Ă��邪�A�����ŏ��ł���
	rr			c
	ld			de, 11
_loop:									; �������J��Ԃ� 11 ���������ށi�v�f���t�B�[���h)
	ld			[hl], e
	inc			hl
	ld			[hl], d
	inc			hl
	dec			bc						; �v�f��������
	dec			a
	jr			nz, _loop
	; �󕶎�����l�߂�
	ld			de, str_0				; �󕶎����x��
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
	pop			hl						; �z��̃A�h���X���A
	ret
