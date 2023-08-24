memo:
	https://www.msx.org/wiki/BASIC_Routines_In_Main-ROM

CALL IOTGET( �f�o�C�X�p�X, �ϐ� )

�f�o�C�X�p�X�𑗂�T�u���[�`��
	HL: ������̃A�h���X [HL] ����, [HL+1 ... ] ������

iot_set_device_path:
		LD		C, 8
		; �f�o�C�X�p�X���M�J�n�R�}���h
		LD		A, 0xE0
		OUT		[C], A
		LD		A, 1
		OUT		[C], A
		LD		A, 0x53
		OUT		[C], A

		LD		A, 0xC0
		OUT		[C], A
		; ������̒������擾
		LD		A, [HL]
_iot_set_device_path_loop1:
		LD		B, A
		CP		A, 64							; 64�����ȏ�̏ꍇ�͓��ʏ��������{����
		JR		C, _iot_set_device_path_skip
		SUB		A, 63
		LD		B, 0x7F							; ���ʏ����������R�[�h
_iot_set_device_path_skip:
		OUT		[C], B
		LD		D, A
		LD		A, B
		AND		A, 0x3F
		LD		B, A
_iot_set_device_path_loop2:
		INC		HL
		LD		A, [HL]
		OUT		[C], A
		DJNZ	_iot_set_device_path_loop2
		LD		A, D
		SUB		A, 63
		JR		Z, _iot_set_device_path_exit
		JR		NC, _iot_set_device_path_loop1
_iot_set_device_path_exit:
		IN		A, [C]
		RLCA									; �G���[�Ȃ� Cf = 1, ����Ȃ� Cf = 0
		RET		NC
		LD		E, 0x13
		JP		0x406F							; bios_errhand

; HL ... �擾�����l
iotget_integer:
		; ��M�R�}���h���M
		LD		A, 0xE0
		OUT		[8], A
		LD		A, 0x01
		OUT		[8], A
		; �����^���ʃR�[�h���M
		LD		A, 0x01
		OUT		[8], A
		; ��M�J�n
		LD		A, 0x80
		OUT		[8], A
		IN		A, [8]		; �������� 2 ���Ԃ��Ă���
		IN		L, [8]
		IN		H, [8]
		RET

; HL ... �擾�����l
iotget_string:
		; ��M�R�}���h���M
		LD		A, 0xE0
		OUT		[8], A
		LD		A, 0x01
		OUT		[8], A
		; ������^���ʃR�[�h���M
		LD		A, 0x03
		OUT		[8], A
		; ��M�J�n
		LD		A, 0x80
		OUT		[8], A
		IN		A, [8]		; ������
		CALL	allocate_string
		OR		A, A
		RET		Z			; ���� 0 �Ȃ牽�����Ȃ�
		PUSH	HL
		LD		B, A
_iotget_string_loop:
		INC		HL
		IN		A, [8]
		LD		[HL], A
		DJNZ	_iotget_string_loop
		POP		HL
		RET
