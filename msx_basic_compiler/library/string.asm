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
	LD			E, L
	LD			D, H						; �]����A�h���X
	ADD			HL, BC						; �]�����A�h���X
	EX			DE, HL
	PUSH		HL
	LD			HL, [heap_next]
	OR			A, A
	SBC			HL, DE
	LD			C, L
	LD			B, H						; �]���T�C�Y = heap_next - �]�����A�h���X
	POP			HL
	EX			DE, HL
	LD			[heap_move_size], BC		; �T�C�Y��ۑ�
	LD			[heap_remap_address], HL	; �]�����A�h���X��ۑ�
	LD			[heap_next], DE				; �V���� heap_next
	LD			A, B
	OR			C
	JR			Z, _free_heap_loop1
	LDIR									; ���e���ړ�����
	LD			[heap_next], DE				; �V���� heap_next
	; vars_***, vara_***, varsa_*** �������P�[�g
	LD			HL, vars_area_start
_free_heap_loop1:
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
	LD			DE, varsa_area_end
	RST			0x20						; CP �T�����̃A�h���X, varsa_area_end
	JR			C, _free_heap_loop1
	; varsa_*** �̎w��������������P�[�g
	; ��T.B.D.
	RET
