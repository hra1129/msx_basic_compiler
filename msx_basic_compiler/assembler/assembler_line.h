// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <string>
#include <cstring>
#include "../basic_types.h"

#ifndef __ASSEMBLER_LINE_H__
#define __ASSEMBLER_LINE_H__

enum class CMNEMONIC_TYPE {
	COMMENT,					//	�R�����g�s�܂��͋�s
	LABEL,						//	���x���s  label:
	CONSTANT,					//	�萔�錾  constant_variable equ 0
	LD,
	EX,
	EXX,
	PUSH,
	POP,
	JP,
	JR,
	CALL,
	RET,
	RR,
	RL,
	RRC,
	RLC,
	SRA,
	SRL,
	SLA,
	BIT,
	RES,
	SET,
	CPL,
	CP,
	AND,
	OR,
	XOR,
	NEG,
	INC,
	DEC,
	ADD,
	SUB,
	SBC,
	CCF,
	SCF,
	LDIR,
	LDDR,
	CPI,
	CPD,
	OUT,
	IN,
	OTIR,
	OUTI,
	OTDR,
	OUTD,
	INIR,
	INI,
	INDR,
	IND,
	HALT,
	DJNZ,
};

enum class CCONDITION {
	NONE,
	Z,
	NZ,
	C,
	NC,
	PE,
	PO,
	P,
	M,
};

enum class COPERAND_TYPE {	//	ex.
	NONE,					//	�Ȃ�
	CONSTANT,				//	1234h
	MEMORY_CONSTANT,		//	(1234h)
	REGISTER,				//	HL
	MEMORY_REGISTER,		//	(HL)
	LABEL,					//	LABEL1
};

class COPERAND {
public:
	COPERAND_TYPE		type;
	std::string			s_value;

	COPERAND() {
		this->type = COPERAND_TYPE::NONE;
	}
};

class CASSEMBLER_LINE {
public:
	CMNEMONIC_TYPE		type;
	CCONDITION			condition;
	COPERAND			operand1;
	COPERAND			operand2;

	CASSEMBLER_LINE() {
		this->type = CMNEMONIC_TYPE::COMMENT;
		this->condition = CCONDITION::NONE;
	}

	bool save( FILE *p_file, COUTPUT_TYPES output_type );
};

#endif
