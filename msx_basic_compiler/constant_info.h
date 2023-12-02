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
#include "string_value.h"
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
	std::string		s_label;
	int				i_value;
	char			r_value[8] = {};
	CSTRING			s_value;

	CCONSTANT(): type( CCONSTANT_TYPE::DOUBLE_REAL ), s_label(""), i_value(0), s_value() {
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
			sprintf( s_name, "%02X", p_image[i] );
			s_label = s_label + s_name;
		}
		this->type = type;
		this->s_label = s_label;
		return s_label;
	}

	void set_string( CSTRING s_image ) {
		this->type = CCONSTANT_TYPE::STRING;
		this->s_value = s_image;
	}

	bool string_compare( CCONSTANT &p ) {
		if( this->type != CCONSTANT_TYPE::STRING ) {
			return false;
		}
		if( this->s_value.length != p.s_value.length ) {
			return false;
		}
		if( memcmp( this->s_value.image, p.s_value.image, this->s_value.length ) != 0 ) {
			return false;
		} 
		return true;
	}
};

// --------------------------------------------------------------------
class CCONSTANT_INFO {
public:
	//	空文字列のラベル
	std::string s_blank_string;

	//	定義済みの数値定数のリスト
	std::map< std::string, CCONSTANT > dictionary;

	//	定義済みの文字列定数のリスト
	std::map< std::string, CCONSTANT > string_list;
	unsigned int string_label = 0;

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

	std::string add( const CSTRING &value ) {
		CCONSTANT r_value;

		r_value.set_string( value );
		for( auto &p: string_list ) {
			if( r_value.string_compare( p.second ) ) {
				return p.second.s_label;
			}
		}
		std::string s_label = "str_" + std::to_string( this->string_label );
		this->string_label++;
		r_value.s_label = s_label;
		string_list[ s_label ] = r_value;
		return s_label;
	}

	void dump( CASSEMBLER_LIST &asm_list, COPTIONS options ) {
		std::string s;
		int i;
		char s_name[16];
		CASSEMBLER_LINE asm_line;

		for( auto it = dictionary.begin(); it != dictionary.end(); it++ ) {
			switch( it->second.type ) {
			case CCONSTANT_TYPE::SINGLE_REAL:
				s = "";
				for( i = 0; i < 4; i++ ) {
					sprintf( s_name, "%s0x%02X", ((i==0) ? "": ", "), (int)it->second.r_value[i] & 255 );
					s = s + s_name;
				}
				asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, it->first, COPERAND_TYPE::NONE, "" );
				asm_list.const_single_area.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s, COPERAND_TYPE::NONE, "" );
				asm_list.const_single_area.push_back( asm_line );
				break;
			case CCONSTANT_TYPE::DOUBLE_REAL:
				s = "";
				for( i = 0; i < 8; i++ ) {
					sprintf( s_name, "%s0x%02X", ((i==0) ? "": ", "), (int)it->second.r_value[i] & 255 );
					s = s + s_name;
				}
				asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, it->first, COPERAND_TYPE::NONE, "" );
				asm_list.const_double_area.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s, COPERAND_TYPE::NONE, "" );
				asm_list.const_double_area.push_back( asm_line );
				break;
			default:
				break;
			}
		}

		for( auto it = string_list.begin(); it != string_list.end(); it++ ) {
			sprintf( s_name, "0x%02X", (int)it->second.s_value.length & 255 );
			s = s_name;
			for( i = 0; i < (int)it->second.s_value.length; i++ ) {
				sprintf( s_name, ", 0x%02X", (int)it->second.s_value.image[i] & 255 );
				s = s + s_name;
			}
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, it->first, COPERAND_TYPE::NONE, "" );
			asm_list.const_string_area.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s, COPERAND_TYPE::NONE, "" );
			asm_list.const_string_area.push_back( asm_line );
		}
	}
};

#endif
