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


ERHNDR	:= 0x406F

		org		0xC000
start_address:
		;----------------------------------------------------------------------
		ld		e, 0
		call	ERHNDR
		ret

end_address: