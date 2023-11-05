; =============================================================================
;	MSX-BACON LOADER
; -----------------------------------------------------------------------------
;	Copyroght (C)2023 HRA!
; =============================================================================

init		:= 0x4002

			db		0xFE
			dw		start_address
			dw		end_address
			dw		start_address

			org		0x9000
start_address::
			; Page 1 を DRAM に切り替える
			ld		a, [ramad1]
			ld		h, 0x40
			call	enaslt

			; ROMイメージを Page1 へコピーする
			ld		hl, transfer_source_start
			ld		de, rom_image_start
			ld		bc, rom_image_size
			ldir

			; 初期化ルーチンを呼ぶ
			ld		hl, ret_address
			push	hl
			ld		hl, [init]
			jp		hl
ret_address:

			; Page 1 を BIOS へ戻す
			ld		a, [mainrom]
			ld		h, 0x40
			call	enaslt

			; puts message
			ld		hl, s_loader_message
	_puts_loop:
			ld		a, [hl]
			or		a, a
			jr		z, _puts_exit
			rst		0x18
			inc		hl
			jr		_puts_loop
	_puts_exit:
			ei
			ret
s_loader_message:
			db		"MSX-BACON Library installed.", 13, 10
			db		"Copyright (C)2023 HRA!", 13, 10, 0

transfer_source_start:
			org		0x4000
rom_image_start::
			include	"baconlib.asm"
rom_image_end::
rom_image_size	:= rom_image_end - rom_image_start

			org		transfer_source_start + rom_image_size
end_address::
