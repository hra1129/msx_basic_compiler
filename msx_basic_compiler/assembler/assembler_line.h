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

enum class CMNEMONIC_TYPE: int {
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
	ORG,
	DEFB,
	DEFW,
	RST,
	RLCA,
	RRCA,
	DI,
	EI,
};

enum class CCONDITION: int {
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

enum class COPERAND_TYPE: int {	//	ex.
	NONE,						//	なし
	CONSTANT,					//	1234h
	MEMORY_CONSTANT,			//	(1234h)
	REGISTER,					//	HL
	MEMORY_REGISTER,			//	(HL)
	LABEL,						//	LABEL1
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

	void set( const CMNEMONIC_TYPE &t, const CCONDITION &cond, const COPERAND_TYPE &o1t, const std::string &s_o1, const COPERAND_TYPE &o2t, const std::string &s_o2 );
	std::string convert_operand( std::string s, COUTPUT_TYPES out_type );
	std::string convert_operand_hl( std::string s, COUTPUT_TYPES out_type );
	std::string convert_length( std::string s, size_t length = 12 );
	std::string convert_condition( CCONDITION condition );
	bool save( FILE *p_file, COUTPUT_TYPES output_type );

	CASSEMBLER_LINE() {
		this->type = CMNEMONIC_TYPE::COMMENT;
		this->condition = CCONDITION::NONE;
	}
};

#endif
