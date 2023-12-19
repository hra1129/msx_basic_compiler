; =============================================================================
;	NEWSTT で BASIC の END命令を実行したらどうなるのか？
;		戻ってくる？それともBASICプロンプトにとんでっちゃう？
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
		db		0x00		; 端末
end_address:
