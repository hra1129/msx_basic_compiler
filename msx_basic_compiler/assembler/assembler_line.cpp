// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include "assembler_line.h"
#include <cstring>
#include <map>
#include <algorithm>

struct CCOMMAND_TYPE {
	int		parameter_type = 0;
	std::string		s_name;
};

std::map< CMNEMONIC_TYPE, CCOMMAND_TYPE > command_list = {
	{ CMNEMONIC_TYPE::COMMENT,    { 1, ";" } },
	{ CMNEMONIC_TYPE::LABEL,	  { 1, "LABEL" } },
	{ CMNEMONIC_TYPE::CONSTANT,	  { 1, "CONSTANT" } },
	{ CMNEMONIC_TYPE::LD,		  { 2, "LD" } },
	{ CMNEMONIC_TYPE::EX,		  { 2, "EX" } },
	{ CMNEMONIC_TYPE::EXX,		  { 0, "EXX" } },
	{ CMNEMONIC_TYPE::PUSH,		  { 1, "PUSH" } },
	{ CMNEMONIC_TYPE::POP,		  { 1, "POP" } },
	{ CMNEMONIC_TYPE::JP,		  { 4, "JP" } },
	{ CMNEMONIC_TYPE::JR,		  { 1, "JR" } },
	{ CMNEMONIC_TYPE::CALL,		  { 1, "CALL" } },
	{ CMNEMONIC_TYPE::RET,		  { 0, "RET" } },
	{ CMNEMONIC_TYPE::RR,		  { 1, "RR" } },
	{ CMNEMONIC_TYPE::RL,		  { 1, "RL" } },
	{ CMNEMONIC_TYPE::RRC,		  { 1, "RRC" } },
	{ CMNEMONIC_TYPE::RLC,		  { 1, "RLC" } },
	{ CMNEMONIC_TYPE::SRA,		  { 1, "SRA" } },
	{ CMNEMONIC_TYPE::SRL,		  { 1, "SRL" } },
	{ CMNEMONIC_TYPE::SLA,		  { 1, "SLA" } },
	{ CMNEMONIC_TYPE::BIT,		  { 1, "BIT" } },
	{ CMNEMONIC_TYPE::RES,		  { 1, "RES" } },
	{ CMNEMONIC_TYPE::SET,		  { 1, "SET" } },
	{ CMNEMONIC_TYPE::CPL,		  { 0, "CPL" } },
	{ CMNEMONIC_TYPE::CP,		  { 3, "CP" } },
	{ CMNEMONIC_TYPE::AND,		  { 3, "AND" } },
	{ CMNEMONIC_TYPE::OR,		  { 3, "OR" } },
	{ CMNEMONIC_TYPE::XOR,		  { 3, "XOR" } },
	{ CMNEMONIC_TYPE::NEG,		  { 0, "NEG" } },
	{ CMNEMONIC_TYPE::INC,		  { 1, "INC" } },
	{ CMNEMONIC_TYPE::DEC,		  { 1, "DEC" } },
	{ CMNEMONIC_TYPE::ADD,		  { 2, "ADD" } },
	{ CMNEMONIC_TYPE::ADC,		  { 2, "ADC" } },
	{ CMNEMONIC_TYPE::SUB,		  { 2, "SUB" } },
	{ CMNEMONIC_TYPE::SBC,		  { 2, "SBC" } },
	{ CMNEMONIC_TYPE::CCF,		  { 0, "CCF" } },
	{ CMNEMONIC_TYPE::SCF,		  { 0, "SCF" } },
	{ CMNEMONIC_TYPE::LDIR,		  { 0, "LDIR" } },
	{ CMNEMONIC_TYPE::LDDR,		  { 0, "LDDR" } },
	{ CMNEMONIC_TYPE::CPI,		  { 0, "CPI" } },
	{ CMNEMONIC_TYPE::CPD,		  { 0, "CPD" } },
	{ CMNEMONIC_TYPE::OUT,		  { 2, "OUT" } },
	{ CMNEMONIC_TYPE::IN,		  { 2, "IN" } },
	{ CMNEMONIC_TYPE::OTIR,		  { 0, "OTIR" } },
	{ CMNEMONIC_TYPE::OUTI,		  { 0, "OUTI" } },
	{ CMNEMONIC_TYPE::OTDR,		  { 0, "OTDR" } },
	{ CMNEMONIC_TYPE::OUTD,		  { 0, "OUTD" } },
	{ CMNEMONIC_TYPE::INIR,		  { 0, "INIR" } },
	{ CMNEMONIC_TYPE::INI,		  { 0, "INI" } },
	{ CMNEMONIC_TYPE::INDR,		  { 0, "INDR" } },
	{ CMNEMONIC_TYPE::IND,		  { 0, "IND" } },
	{ CMNEMONIC_TYPE::HALT,		  { 0, "HALT" } },
	{ CMNEMONIC_TYPE::DJNZ,		  { 1, "DJNZ" } },
	{ CMNEMONIC_TYPE::ORG,		  { 1, "ORG" } },
	{ CMNEMONIC_TYPE::DEFB,		  { 1, "DEFB" } },
	{ CMNEMONIC_TYPE::DEFW,		  { 1, "DEFW" } },
	{ CMNEMONIC_TYPE::RST,        { 1, "RST" } },
	{ CMNEMONIC_TYPE::RLCA,       { 0, "RLCA" } },
	{ CMNEMONIC_TYPE::RRCA,       { 0, "RRCA" } },
	{ CMNEMONIC_TYPE::EI,         { 0, "EI" } },
	{ CMNEMONIC_TYPE::DI,         { 0, "DI" } },
};

std::map< CCONDITION, std::string > condition_list = {
	{ CCONDITION::NONE,			"" },
	{ CCONDITION::Z,			"Z, " },
	{ CCONDITION::NZ,			"NZ, " },
	{ CCONDITION::C,			"C, " },
	{ CCONDITION::NC,			"NC, " },
	{ CCONDITION::PE,			"PE, " },
	{ CCONDITION::PO,			"PO, " },
	{ CCONDITION::P,			"P, " },
	{ CCONDITION::M,			"M, " },
};

std::map< CCONDITION, std::string > condition_list_for_ret = {
	{ CCONDITION::NONE,			"" },
	{ CCONDITION::Z,			"Z" },
	{ CCONDITION::NZ,			"NZ" },
	{ CCONDITION::C,			"C" },
	{ CCONDITION::NC,			"NC" },
	{ CCONDITION::PE,			"PE" },
	{ CCONDITION::PO,			"PO" },
	{ CCONDITION::P,			"P" },
	{ CCONDITION::M,			"M" },
};

// --------------------------------------------------------------------
std::map< std::string, CMNEMONIC_TYPE > command_name_list = {
	{ ";",			CMNEMONIC_TYPE::COMMENT },
	{ "LABEL",		CMNEMONIC_TYPE::LABEL },
	{ "CONSTANT",	CMNEMONIC_TYPE::CONSTANT },
	{ "LD",			CMNEMONIC_TYPE::LD },
	{ "EX",			CMNEMONIC_TYPE::EX },
	{ "EXX",		CMNEMONIC_TYPE::EXX },
	{ "PUSH",		CMNEMONIC_TYPE::PUSH },
	{ "POP",		CMNEMONIC_TYPE::POP },
	{ "JP",			CMNEMONIC_TYPE::JP },
	{ "JR",			CMNEMONIC_TYPE::JR },
	{ "CALL",		CMNEMONIC_TYPE::CALL },
	{ "RET",		CMNEMONIC_TYPE::RET },
	{ "RR",			CMNEMONIC_TYPE::RR },
	{ "RL",			CMNEMONIC_TYPE::RL },
	{ "RRC",		CMNEMONIC_TYPE::RRC },
	{ "RLC",		CMNEMONIC_TYPE::RLC },
	{ "SRA",		CMNEMONIC_TYPE::SRA },
	{ "SRL",		CMNEMONIC_TYPE::SRL },
	{ "SLA",		CMNEMONIC_TYPE::SLA },
	{ "BIT",		CMNEMONIC_TYPE::BIT },
	{ "RES",		CMNEMONIC_TYPE::RES },
	{ "SET",		CMNEMONIC_TYPE::SET },
	{ "CPL",		CMNEMONIC_TYPE::CPL },
	{ "CP",			CMNEMONIC_TYPE::CP },
	{ "AND",		CMNEMONIC_TYPE::AND },
	{ "OR",			CMNEMONIC_TYPE::OR },
	{ "XOR",		CMNEMONIC_TYPE::XOR },
	{ "NEG",		CMNEMONIC_TYPE::NEG },
	{ "INC",		CMNEMONIC_TYPE::INC },
	{ "DEC",		CMNEMONIC_TYPE::DEC },
	{ "ADD",		CMNEMONIC_TYPE::ADD },
	{ "ADC",		CMNEMONIC_TYPE::ADC },
	{ "SUB",		CMNEMONIC_TYPE::SUB },
	{ "SBC",		CMNEMONIC_TYPE::SBC },
	{ "CCF",		CMNEMONIC_TYPE::CCF },
	{ "SCF",		CMNEMONIC_TYPE::SCF },
	{ "LDIR",		CMNEMONIC_TYPE::LDIR },
	{ "LDDR",		CMNEMONIC_TYPE::LDDR },
	{ "CPI",		CMNEMONIC_TYPE::CPI },
	{ "CPD",		CMNEMONIC_TYPE::CPD },
	{ "OUT",		CMNEMONIC_TYPE::OUT },
	{ "IN",			CMNEMONIC_TYPE::IN },
	{ "OTIR",		CMNEMONIC_TYPE::OTIR },
	{ "OUTI",		CMNEMONIC_TYPE::OUTI },
	{ "OTDR",		CMNEMONIC_TYPE::OTDR },
	{ "OUTD",		CMNEMONIC_TYPE::OUTD },
	{ "INIR",		CMNEMONIC_TYPE::INIR },
	{ "INI",		CMNEMONIC_TYPE::INI },
	{ "INDR",		CMNEMONIC_TYPE::INDR },
	{ "IND",		CMNEMONIC_TYPE::IND },
	{ "HALT",		CMNEMONIC_TYPE::HALT },
	{ "DJNZ",		CMNEMONIC_TYPE::DJNZ },
	{ "ORG",		CMNEMONIC_TYPE::ORG },
	{ "DEFB",		CMNEMONIC_TYPE::DEFB },
	{ "DEFW",		CMNEMONIC_TYPE::DEFW },
	{ "RST",		CMNEMONIC_TYPE::RST },
	{ "RLCA",		CMNEMONIC_TYPE::RLCA },
	{ "RRCA",		CMNEMONIC_TYPE::RRCA },
	{ "EI",			CMNEMONIC_TYPE::EI },
	{ "DI",			CMNEMONIC_TYPE::DI },
};

std::map< std::string, CCONDITION > condition_name_list = {
	{ "",	CCONDITION::NONE,	},
	{ "Z",	CCONDITION::Z,		},
	{ "NZ",	CCONDITION::NZ,		},
	{ "C",	CCONDITION::C,		},
	{ "NC",	CCONDITION::NC,		},
	{ "PE",	CCONDITION::PE,		},
	{ "PO",	CCONDITION::PO,		},
	{ "P",	CCONDITION::P,		},
	{ "M",	CCONDITION::M,		},
};

// --------------------------------------------------------------------
void CASSEMBLER_LINE::set( const CMNEMONIC_TYPE &t, const CCONDITION &cond, const COPERAND_TYPE &o1t, const std::string &s_o1, const COPERAND_TYPE &o2t, const std::string &s_o2 ) {
	this->type = t;
	this->condition = cond;
	this->operand1.type = o1t;
	this->operand1.s_value = s_o1;
	this->operand2.type = o2t;
	this->operand2.s_value = s_o2;
}

// --------------------------------------------------------------------
COPERAND_TYPE CASSEMBLER_LINE::detect_operand_type( const std::string s_operand ) {

	if( s_operand == "" ) {
		return COPERAND_TYPE::NONE;
	}
	if( s_operand[ 0 ] == '[' ) {
		return COPERAND_TYPE::MEMORY;
	}
	if( s_operand == "A" || s_operand == "B" || s_operand == "C" || s_operand == "D" || s_operand == "E" || s_operand == "H" || s_operand == "L" ) {
		return COPERAND_TYPE::REGISTER;
	}
	if( s_operand == "AF" || s_operand == "AF'" || s_operand == "BC" || s_operand == "DE" || s_operand == "HL" || s_operand == "SP" || s_operand == "IX" || s_operand == "IY" ) {
		return COPERAND_TYPE::REGISTER;
	}
	return COPERAND_TYPE::CONSTANT;
}

// --------------------------------------------------------------------
void CASSEMBLER_LINE::set( const char *p_mnemonic, const char *p_cond, const char *p_operand1, const char *p_operand2 ) {
	std::string s_mnemonic = p_mnemonic;
	std::string s_cond = p_cond;
	std::string s_operand1 = p_operand1;
	std::string s_operand2 = p_operand2;

	std::transform( s_mnemonic.begin(), s_mnemonic.end(), s_mnemonic.begin(), ::toupper );
	std::transform( s_cond.begin(),     s_cond.end(),     s_cond.begin(),     ::toupper );
	std::transform( s_operand1.begin(), s_operand1.end(), s_operand1.begin(), ::toupper );
	std::transform( s_operand2.begin(), s_operand2.end(), s_operand2.begin(), ::toupper );

	this->type = command_name_list[ s_mnemonic ];
	this->condition = condition_name_list[ s_cond ];
	this->operand1.type = this->detect_operand_type( s_operand1 );
	this->operand1.s_value = s_operand1;
	this->operand2.type = this->detect_operand_type( s_operand2 );
	this->operand2.s_value = s_operand2;
}

// --------------------------------------------------------------------
std::string CASSEMBLER_LINE::convert_operand( std::string s ) {

	return s;
}

// --------------------------------------------------------------------
std::string CASSEMBLER_LINE::convert_operand_hl( std::string s ) {

	return s;
}

// --------------------------------------------------------------------
std::string CASSEMBLER_LINE::convert_length( std::string s, size_t length ) {

	if( s.size() < length ) {
		for( size_t i = s.size(); i < length; i++ ) {
			s = s + ' ';
		}
	}
	return s;
}

// --------------------------------------------------------------------
std::string CASSEMBLER_LINE::convert_condition( CCONDITION condition ) {

	return condition_list[ condition ];
}

// --------------------------------------------------------------------
bool CASSEMBLER_LINE::save( FILE *p_file ) {

	if( this->type == CMNEMONIC_TYPE::LABEL ) {
		fprintf( p_file, "%s:\n", this->operand1.s_value.c_str() );
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::COMMENT ) {
		fprintf( p_file, "; %s\n", this->operand1.s_value.c_str() );
		return true;
	}
	if( this->type == CMNEMONIC_TYPE::CONSTANT ) {
		fprintf( p_file, "%s= %s\n", this->convert_length( this->operand1.s_value, 32 ).c_str(), this->operand2.s_value.c_str() );
		return true;
	}

	if( this->type == CMNEMONIC_TYPE::DEFB ) {
		int i = 0;
	}

	CCOMMAND_TYPE command_type = command_list[ this->type ];
	switch( command_type.parameter_type ) {
	case 0:	//	オペランド無し
		fprintf( p_file, "        %s%s\n",
			convert_length( command_type.s_name ).c_str(), 
			condition_list_for_ret[ this->condition ].c_str() );
		return true;
	case 1:	//	オペランド1個
		fprintf( p_file, "        %s%s%s\n", 
				convert_length( command_type.s_name ).c_str(), 
				convert_condition( this->condition ).c_str(),
				convert_operand( this->operand1.s_value ).c_str() );
		return true;
	case 2:	//	オペランド2個
		fprintf( p_file, "        %s%s, %s\n", 
				convert_length( command_type.s_name ).c_str(), 
				convert_operand( this->operand1.s_value ).c_str(), 
				convert_operand( this->operand2.s_value ).c_str() );
		return true;
	case 3:	//	ZMA ではオペランド2個だけど、M80 では1個
		fprintf( p_file, "        %s%s, %s\n", 
				convert_length( command_type.s_name ).c_str(), 
				this->operand1.s_value.c_str(), 
				this->operand2.s_value.c_str() );
		return true;
	case 4:	//	オペランド1個、オペランドが HL の場合は、(HL) に置き換える
		fprintf( p_file, "        %s%s%s\n", 
			convert_length( command_type.s_name ).c_str(), 
			convert_condition( this->condition ).c_str(),
			convert_operand_hl( this->operand1.s_value ).c_str() );
		return true;
	default:
		break;
	}
	return false;
}
