// --------------------------------------------------------------------
//	Constant information
// ====================================================================
//	2023/Aug/5th  t.hara
// --------------------------------------------------------------------

#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include "single_real.h"
#include "double_real.h"
#include "assembler/assembler_list.h"

#ifndef __CONSTANT_INFO_H__
#define __CONSTANT_INFO_H__

// --------------------------------------------------------------------
enum class CCONSTANT_TYPE {
	INTEGER,
	SINGLE_REAL,
	DOUBLE_REAL,
	STRING,
};

// --------------------------------------------------------------------
class CCONSTANT {
public:
	CCONSTANT_TYPE	type;
	std::string		s_name;
	int				i_value;
	char			r_value[8] = {};
	std::string		s_value;

	CCONSTANT(): type( CCONSTANT_TYPE::DOUBLE_REAL ), s_name(""), i_value(0), s_value("") {
	}

	std::string set_real( const unsigned char *p_image, CCONSTANT_TYPE type ) {
		int i, l;
		char s_name[16];

		std::string s_label = "const_";
		if( type == CCONSTANT_TYPE::SINGLE_REAL ) {
			l = 4;
		}
		else {
			l = 8;
		}
		for( i = 0; i < l; i++ ) {
			this->r_value[i] = p_image[i];
			sprintf_s( s_name, "%02X", p_image[i] );
			s_label = s_label + s_name;
		}
		this->type = type;
		return s_label;
	}
};

// --------------------------------------------------------------------
class CCONSTANT_INFO {
public:

	//	使用されている定数のリスト
	std::map< std::string, CCONSTANT > dictionary;

	std::string add( const CSINGLE_REAL &value ) {
		CCONSTANT r_value;
		std::string s_label;

		s_label = r_value.set_real( value.image, CCONSTANT_TYPE::SINGLE_REAL );
		if( dictionary.count( s_label ) == 0 ) {
			dictionary[ s_label ] = r_value;
		}
		return s_label;
	}

	std::string add( const CDOUBLE_REAL &value ) {
		CCONSTANT r_value;
		std::string s_label;

		s_label = r_value.set_real( value.image, CCONSTANT_TYPE::DOUBLE_REAL );
		if( dictionary.count( s_label ) == 0 ) {
			dictionary[ s_label ] = r_value;
		}
		return s_label;
	}

	void dump( CASSEMBLER_LIST &asm_list, COPTIONS options ) {
		std::string s;
		int i;
		char s_name[16];
		CASSEMBLER_LINE asm_line;

		for( auto it = dictionary.begin(); it != dictionary.end(); it++ ) {
			switch( it->second.type ) {
			case CCONSTANT_TYPE::INTEGER:
				break;
			case CCONSTANT_TYPE::SINGLE_REAL:
				s = "";
				for( i = 0; i < 4; i++ ) {
					if( options.output_type == COUTPUT_TYPES::ZMA ) {
						sprintf_s( s_name, "%s0x%02X", ((i==0) ? "": ", "), it->second.r_value[i] );
					}
					else {
						sprintf_s( s_name, "%s0%02Xh", ((i==0) ? "": ", "), it->second.r_value[i] );
					}
					s = s + s_name;
				}
				asm_line.type = CMNEMONIC_TYPE::LABEL;
				asm_line.operand1.s_value = it->first;
				asm_line.operand1.type = COPERAND_TYPE::LABEL;
				asm_list.const_single_area.push_back( asm_line );

				asm_line.type = CMNEMONIC_TYPE::DEFB;
				asm_line.operand1.s_value = s;
				asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
				asm_list.const_single_area.push_back( asm_line );
				break;
			case CCONSTANT_TYPE::DOUBLE_REAL:
				s = "";
				for( i = 0; i < 8; i++ ) {
					if( options.output_type == COUTPUT_TYPES::ZMA ) {
						sprintf_s( s_name, "%s0x%02X", ((i==0) ? "": ", "), it->second.r_value[i] );
					}
					else {
						sprintf_s( s_name, "%s0%02Xh", ((i==0) ? "": ", "), it->second.r_value[i] );
					}
					s = s + s_name;
				}
				asm_line.type = CMNEMONIC_TYPE::LABEL;
				asm_line.operand1.s_value = it->first;
				asm_line.operand1.type = COPERAND_TYPE::LABEL;
				asm_list.const_single_area.push_back( asm_line );

				asm_line.type = CMNEMONIC_TYPE::DEFB;
				asm_line.operand1.s_value = s;
				asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
				asm_list.const_double_area.push_back( asm_line );
				break;
			case CCONSTANT_TYPE::STRING:
				break;
			default:
				break;
			}
		}
	}
};

#endif
