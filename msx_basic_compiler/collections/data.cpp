// --------------------------------------------------------------------
//	Compiler collection: Data
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "data.h"
#include <cctype>

// --------------------------------------------------------------------
int CDATA::hexchar( int c ) {

	if( isdigit( c & 255 ) ) {
		return c - '0';
	}
	c = c | 0x60;
	if( isalpha( c & 255 ) && (c <= 'f' ) ) {
		return c - 'a' + 10;
	}
	return -1;
}

// --------------------------------------------------------------------
std::string CDATA::hexdata( CCOMPILE_INFO *p_info, std::string s_data ) {
	std::string s_result;

	if( (s_data.size() & 1) != 0 ) {
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
		return s_result;
	}

	size_t i;
	int d, dd;
	for( i = 0; i < s_data.size(); i += 2 ) {
		//	上位桁
		dd = this->hexchar( s_data[i+0] );
		if( dd == -1 ) {
			p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
			return s_result;
		}
		d = dd << 4;
		//	下位桁
		dd = this->hexchar( s_data[i+1] );
		if( dd == -1 ) {
			p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
			return s_result;
		}
		d = d | dd;
		s_result.push_back( (char) d );
	}

	return s_result;
}

// --------------------------------------------------------------------
std::string CDATA::bindata( CCOMPILE_INFO *p_info, std::string s_data ) {
	std::string s_result;

	if( (s_data.size() & 7) != 0 ) {
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
		return s_result;
	}

	size_t i, j;
	int d, dd;
	for( i = 0; i < s_data.size(); i += 8 ) {
		d = 0;
		for( j = 0; j < 8; j++ ) {
			//	上位桁
			dd = this->hexchar( s_data[i+j] );
			if( dd == -1 || dd >= 2 ) {
				p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
				return s_result;
			}
			d = (d << 1) | dd;
		}
		s_result.push_back( (char) d );
	}

	return s_result;
}

// --------------------------------------------------------------------
//  DATA データ
bool CDATA::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	CSTRING value;
	std::string s_label;
	std::string s_data;
	int mode;		//	0: data, 1: hexdata, 2: bindata

	if( p_info->list.p_position->s_word != "DATA" && p_info->list.p_position->s_word != "HEXDATA" && p_info->list.p_position->s_word != "BINDATA" ) {
		return false;
	}
	if( p_info->list.p_position->s_word == "HEXDATA" ) {
		mode = 1;
	}
	else if( p_info->list.p_position->s_word == "BINDATA" ) {
		mode = 2;
	}
	else {
		mode = 0;
	}
	p_info->list.p_position++;

	//	RESTORE用の行番号ラベルを割り付ける
	bool has_data_label = false;
	for( auto i: p_info->assembler_list.data_lines ) {
		if( line_no == i ) {
			has_data_label = true;
			break;
		}
	}
	if( !has_data_label ) {
		s_label = "data_" + std::to_string( line_no );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.datas.push_back( asm_line );
		p_info->assembler_list.data_lines.push_back( line_no );
	}

	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::STRING ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		s_data = p_info->list.p_position->s_word;
		if( mode == 1 ) {
			s_data = this->hexdata( p_info, s_data );
		}
		else if( mode == 2 ) {
			s_data = this->bindata( p_info, s_data );
		}
		value.set( s_data );
		s_label = p_info->constants.add( value );
		asm_line.set( "DEFW", "", s_label, "" );
		p_info->assembler_list.datas.push_back( asm_line );
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::RESERVED_WORD && p_info->list.p_position->s_word != "," ) {
			break;
		}
		p_info->list.p_position++;
	}
	return true;
}
