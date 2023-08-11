bios_cls = 0x000C3
bios_chgmod = 0x0005F
bios_chgmodp = 0x001B5
bios_extrom = 0x0015F
bios_imult = 0x03193
bios_chgclr = 0x00062
work_forclr = 0x0F3E9
work_bakclr = 0x0F3EA
work_bdrclr = 0x0F3EB
line_100:
	CALL	bios_cls
	LD		HL, 2
	PUSH	HL
	LD		HL, 3
	PUSH	HL
	LD		HL, 2
	POP		DE
	CALL	bios_imult
	POP		DE
	ADD		HL, DE
	PUSH	HL
	LD		HL, 4
	POP		DE
	EX		DE, HL
	OR		A, A
	SBC		HL, DE
	LD		A, L
	LD		IX, bios_chgmodp
	CALL	bios_extrom
	LD		HL, 15
	LD		A, L
	LD		[work_forclr], A
	LD		HL, 0
	LD		A, L
	LD		[work_bakclr], A
	LD		HL, 0
	LD		A, L
	LD		[work_bdrclr], A
	CALL	bios_chgclr
	LD		HL, 64432
	PUSH	HL
	LD		HL, 0
	LD		A, L
	POP		HL
	LD		[HL], A
	CALL	line_1000
	JP		line_200
	; --- MAIN LOOP --------
line_140:
line_150:
line_160:
	JP		line_140
line_190:
	; -- START
line_200:
	JP		line_140
line_1000:
	RET
line_1100:
	CALL	bios_cls
	POP		HL
	JP		line_100
