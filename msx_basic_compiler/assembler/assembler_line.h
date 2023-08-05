// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include <string>

#ifndef __ASSEMBLER_LINE_H__
#define __ASSEMBLER_LINE_H__

enum class CMNEMONIC_TYPE {
	COMMENT,					//	コメント行または空行
	LABEL,						//	ラベル行  label:
	CONSTANT,					//	定数宣言  constant_variable equ 0
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
	CONSTANT,				//	1234h
	MEMORY_CONSTANT,		//	(1234h)
	REGISTER,				//	HL
	MEMORY_REGISTER,		//	(HL)
};

class COPERAND {
public:
	COPERAND_TYPE		type;
	std::string			s_value;
};

class CASSEMBLER_LINE {
public:
	CMNEMONIC_TYPE		type;
	CCONDITION			condition;
	COPERAND			operand1;
	COPERAND			operand2;
};

#endif
