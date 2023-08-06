bios_cls = 0x000C3
line_100:
	CALL	bios_cls
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
	POP	HL
	JP		line_100
