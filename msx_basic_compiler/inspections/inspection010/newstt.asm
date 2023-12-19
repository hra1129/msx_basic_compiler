; =============================================================================
;	NEWSTT �� BASIC �� END���߂����s������ǂ��Ȃ�̂��H
;		�߂��Ă���H����Ƃ�BASIC�v�����v�g�ɂƂ�ł����Ⴄ�H
; -----------------------------------------------------------------------------
;	2023/Nov/26th
; =============================================================================

		db		0xFE
		dw		start_address
		dw		end_address
		dw		start_address


NEWSTT	:= 0x4601

		org		0xC000
start_address:
		;----------------------------------------------------------------------
		ld		hl, BASIC_PROG
		call	NEWSTT

		ld		hl, STR1
	loop:
		ld		a, [hl]
		or		a, a
		jr		z, exit
		rst		0x18
		inc		hl
		jr		loop
	exit:
		ret

STR1:
		db		"returned.", 10, 13, 0

BASIC_PROG:
		db		':'
		db		0x81		; END
		db		0x00		; �[��
end_address:
