BACONLIB の存在確認

calslt		:= 0x001C
enaslt		:= 0x0024
ramad1		:= 0xF342
blibslot	:= 0xF3D3
signature	:= 0x4010

check_blib:
			; 出現させる
			ld		a, [blibslot]
			ld		h, 0x40
			call	enaslt
			; チェック
			ld		bc, 8
			ld		hl, signature
			ld		de, signature_ref
		_check_blib_loop:
			ld		a, [de]
			inc		de
			cpi
			jr		nz, _check_blib_exit
			jp		pe, _check_blib_loop
		_check_blib_exit:
			push	af
			; スロットを元に戻す
			ld		a, [ramad1]
			ld		h, 0x40
			call	enaslt
			ei
			pop		af
			ret							; Zf = 1 見つかった、Zf = 0 見つからなかった
signature_ref:
			db		"BACONLIB"

call_blib:
			ld		ix, [blibslot - 1]
			jp		calslt





asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_blib", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_CONSTANT, "[blibslot]" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "h", COPERAND_TYPE::CONSTANT, "0x40" );
asm_line.set( CMNEMONIC_TYPE::CALL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "enaslt", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bc", COPERAND_TYPE::CONSTANT, "8" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "hl", COPERAND_TYPE::LABEL, "signature" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "de", COPERAND_TYPE::LABEL, "signature_ref" );
asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_check_blib_loop", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_REGISTER, "[de]" );
asm_line.set( CMNEMONIC_TYPE::INC		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "de", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::CPI       , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::JR		, CCONDITION::NZ,   COPERAND_TYPE::LABEL, "_check_blib_exit", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::JP		, CCONDITION::PE,   COPERAND_TYPE::LABEL, "_check_blib_loop", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_check_blib_exit", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::PUSH		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "af", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_CONSTANT, "[ramad1]" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "h", COPERAND_TYPE::CONSTANT, "0x40" );
asm_line.set( CMNEMONIC_TYPE::CALL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "enaslt", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::EI        , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::POP		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "af", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::RET       , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "signature_ref", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::DEFB		, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "\"BACONLIB\"", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "ix", COPERAND_TYPE::MEMORY_CONSTANT, "[blibslot - 1]" );
asm_line.set( CMNEMONIC_TYPE::JP		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "calslt", COPERAND_TYPE::NONE, "" );
