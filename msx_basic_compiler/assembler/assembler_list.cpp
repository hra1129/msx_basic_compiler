// --------------------------------------------------------------------
//	MSX-BASIC compiler
// ====================================================================
//	2023/July/20th  t.hara 
// --------------------------------------------------------------------

#include "assembler_list.h"
#include "../constant_info.h"
#include "../single_real.h"
#include "../double_real.h"
#include <cstdio>

// --------------------------------------------------------------------
bool CASSEMBLER_LIST::add_subroutines( const std::string s_name ) {

	if( this->is_registered_subroutine( s_name ) ) {
		return false;
	}
	this->subrouines_list.push_back( s_name );
	return true;
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::add_data( int line_no, const std::string s_value, CCONSTANT_INFO *p_constants ) {
	CASSEMBLER_LINE asm_line;
	bool has_label = false;
	std::string s_label;

	//	既にデータラベルを配置した行番号か？
	for( auto i: this->data_lines ) {
		if( i == line_no ) {
			has_label = true;
			break;
		}
	}
	if( !has_label ) {
		this->data_lines.push_back( line_no );
		s_label = "data_" + std::to_string( line_no );
		asm_line.set( "LABEL", "", s_label, "" );
		this->datas.push_back( asm_line );
	}
	
	CSTRING value;
	value.set( s_value );
	s_label = p_constants->add( value );
	asm_line.set( "DEFW", "", s_label, "" );
	this->datas.push_back( asm_line );
}


// --------------------------------------------------------------------
void CASSEMBLER_LIST::push_hl( CEXPRESSION_TYPE type ) {
	CASSEMBLER_LINE asm_line;

	switch( type ) {
	default:
	case CEXPRESSION_TYPE::INTEGER:
		asm_line.set( "PUSH", "", "HL", "" );
		this->body.push_back( asm_line );
		break;
	case CEXPRESSION_TYPE::SINGLE_REAL:
		this->activate_push_single_real_hl();
		asm_line.set( "CALL", "", "push_single_real_hl", "" );
		this->body.push_back( asm_line );
		break;
	case CEXPRESSION_TYPE::DOUBLE_REAL:
		this->activate_push_double_real_hl();
		asm_line.set( "CALL", "", "push_double_real_hl", "" );
		this->body.push_back( asm_line );
		break;
	case CEXPRESSION_TYPE::STRING:
		asm_line.set( "PUSH", "", "HL", "" );
		this->body.push_back( asm_line );
		break;
	}
}

// --------------------------------------------------------------------
bool CASSEMBLER_LIST::is_registered_subroutine( std::string s_search_name ) {

	for( auto &p: this->subrouines_list ) {
		if( p == s_search_name ) {
			return true;
		}
	}
	return false;
}

// --------------------------------------------------------------------
//	push_single_real_hl:
void CASSEMBLER_LIST::activate_push_single_real_hl( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "push_single_real_hl" ) ) {
		return;
	}
	this->subrouines_list.push_back( "push_single_real_hl" );
	asm_line.set( "LABEL", "", "push_single_real_hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//		push_double_real_dac:
void CASSEMBLER_LIST::activate_push_double_real_hl( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "push_double_real_hl" ) ) {
		return;
	}
	this->subrouines_list.push_back( "push_double_real_hl" );
	asm_line.set( "LABEL", "", "push_double_real_hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_single_real_arg:
void CASSEMBLER_LIST::activate_pop_single_real_arg( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_single_real_arg" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_single_real_arg" );
	this->add_label( "work_arg", "0x0f847" );
	asm_line.set( "LABEL", "", "pop_single_real_arg", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+2]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+0]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+4]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+6]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_convert_to_integer( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "convert_to_integer" ) ) {
		return;
	}
	this->subrouines_list.push_back( "convert_to_integer" );

	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "bios_frcint", "0x02f8a" );

	asm_line.set( "LABEL", "", "convert_to_integer", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcint", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_convert_to_integer_from_sngle_real( CCONSTANT_INFO *p_constants ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "convert_to_integer_from_sngle_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "convert_to_integer_from_sngle_real" );

	CSINGLE_REAL value;
	value.set( "32768!" );
	std::string s_label_32768 = p_constants->add( value );

	this->activate_ld_dac_single_real();
	this->activate_ld_arg_single_real();
	this->activate_convert_to_integer();

	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_arg", "0x0f7f6" );
	this->add_label( "bios_fcomp", "0x02f21" );
	this->add_label( "bios_decsub", "0x0268c" );
	this->add_label( "bios_frcint", "0x02f8a" );

	asm_line.set( "LABEL", "", "convert_to_integer_from_sngle_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_dac_single_real", "" );
	this->subroutines.push_back( asm_line );
	//	もし DAC < 32768! なら → A = -1 なら、普通に FRCINT で変換。(-32768 より小さければ、FRCINT が Overflow 出す。)
	asm_line.set( "LD", "", "BC", "0x3245" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "0x8076" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_fcomp", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "A", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "convert_to_integer", "" );
	this->subroutines.push_back( asm_line );
	//	HL = int(DAC - 32768!) xor &H8000
	asm_line.set( "LD", "", "HL", s_label_32768 );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_arg_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_decsub", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcint", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "0x80" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "H", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_convert_to_integer_from_double_real( CCONSTANT_INFO *p_constants ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "convert_to_integer_from_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "convert_to_integer_from_double_real" );

	CSINGLE_REAL value;
	value.set( "32768!" );
	std::string s_label_32768 = p_constants->add( value );

	this->activate_ld_dac_double_real();
	this->activate_ld_arg_double_real();
	this->activate_convert_to_integer();

	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_arg", "0x0f7f6" );
	this->add_label( "bios_fcomp", "0x02f21" );
	this->add_label( "bios_decsub", "0x0268c" );
	this->add_label( "bios_frcint", "0x02f8a" );

	asm_line.set( "LABEL", "", "convert_to_integer_from_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_dac_double_real", "" );
	this->subroutines.push_back( asm_line );
	//	もし DAC < 32768! なら → A = -1 なら、普通に FRCINT で変換。(-32768 より小さければ、FRCINT が Overflow 出す。)
	asm_line.set( "LD", "", "BC", "0x3245" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "0x8076" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_fcomp", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "A", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "convert_to_integer", "" );
	this->subroutines.push_back( asm_line );
	//	HL = int(DAC - 32768!) xor &H8000
	asm_line.set( "LD", "", "HL", s_label_32768 );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_arg_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_decsub", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcint", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "0x80" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "H", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_single_real_dac:
void CASSEMBLER_LIST::activate_pop_single_real_dac( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_single_real_dac" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_single_real_dac" );
	this->add_label( "work_dac", "0x0f7f6" );
	asm_line.set( "LABEL", "", "pop_single_real_dac", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+2]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+0]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+4]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+6]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_single_real_arg:
void CASSEMBLER_LIST::activate_pop_double_real_arg( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_double_real_arg" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_double_real_arg" );
	this->add_label( "work_arg", "0x0f847" );
	asm_line.set( "LABEL", "", "pop_double_real_arg", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+6]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+4]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+2]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+0]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_double_real_dac:
void CASSEMBLER_LIST::activate_pop_double_real_dac( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_double_real_dac" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_double_real_dac" );
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_valtyp", "0x0f663" );
	asm_line.set( "LABEL", "", "pop_double_real_dac", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+6]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+4]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+2]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+0]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_valtyp]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	single real [HL] → [DAC]
void CASSEMBLER_LIST::activate_ld_dac_single_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_dac_single_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_dac_single_real" );
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_valtyp", "0x0f663" );
	asm_line.set( "LABEL", "", "ld_dac_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_valtyp]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+4]", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac+6]", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	double real [HL] → [DAC]
void CASSEMBLER_LIST::activate_ld_dac_double_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_dac_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_dac_double_real" );
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_valtyp", "0x0f663" );
	asm_line.set( "LABEL", "", "ld_dac_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_valtyp]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	single real [HL] → [ARG]
void CASSEMBLER_LIST::activate_ld_arg_single_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_arg_single_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_arg_single_real" );
	this->add_label( "work_arg", "0x0f847" );
	this->add_label( "work_valtyp", "0x0f663" );
	asm_line.set( "LABEL", "", "ld_arg_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "work_arg" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+4]", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_arg+6]", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_valtyp]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	double real [HL] → [ARG]
void CASSEMBLER_LIST::activate_ld_arg_double_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_arg_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_arg_double_real" );
	this->add_label( "work_arg", "0x0f847" );
	asm_line.set( "LABEL", "", "ld_arg_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "work_arg" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	single real [HL] → [DE]
void CASSEMBLER_LIST::activate_ld_de_single_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_de_single_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_de_single_real" );
	asm_line.set( "LABEL", "", "ld_de_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	double real [HL] → [DE]
void CASSEMBLER_LIST::activate_ld_de_double_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_de_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_de_double_real" );
	asm_line.set( "LABEL", "", "ld_de_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_puts( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "puts" ) ) {
		return;
	}
	this->subrouines_list.push_back( "puts" );
	asm_line.set( "LABEL", "", "puts", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "B", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "B", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "Z", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_puts_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DJNZ", "", "_puts_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_spc( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "spc" ) ) {
		return;
	}
	this->subrouines_list.push_back( "spc" );
	asm_line.set( "LABEL", "", "spc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "32" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_spc_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DJNZ", "", "_spc_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	A に文字列長 1～255 を入れて呼ぶ。 HL に確保したアドレスを返す。
void CASSEMBLER_LIST::activate_allocate_string( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "allocate_string" ) ) {
		return;
	}
	this->subrouines_list.push_back( "allocate_string" );
	this->add_label( "bios_errhand", "0x0406F" );
	asm_line.set( "LABEL", "", "allocate_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[heap_end]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "_allocate_string_error", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[heap_next]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_allocate_string_error", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "7" );			//	Out of memory.
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "bios_errhand", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	BC に確保するサイズを入れて呼ぶ。 HL に確保したアドレスを返す。
void CASSEMBLER_LIST::activate_allocate_heap( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "allocate_heap" ) ) {
		return;
	}
	this->subrouines_list.push_back( "allocate_heap" );
	this->add_label( "bios_errhand", "0x0406F" );
	asm_line.set( "LABEL", "", "allocate_heap", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "C", "_allocate_heap_error", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[heap_end]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "_allocate_heap_error", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[heap_next]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_allocate_heap_error", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "7" );			//	Out of memory.
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "bios_errhand", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_free_string( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "free_string" ) ) {
		return;
	}
	this->subrouines_list.push_back( "free_string" );
	asm_line.set( "LABEL", "", "free_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "heap_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "C", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NC", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "free_heap", "" );
	this->subroutines.push_back( asm_line );
	this->activate_free_heap();
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_free_array( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "free_array" ) ) {
		return;
	}
	this->subrouines_list.push_back( "free_array" );
	asm_line.set( "LABEL", "", "free_array", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "heap_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "C", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NC", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "BC", "" );				//	[サイズ] の 2byte を追加
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "free_heap", "" );
	this->subroutines.push_back( asm_line );
	this->activate_free_heap();
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_free_sarray( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "free_sarray" ) ) {
		return;
	}
	this->activate_free_string();
	this->subrouines_list.push_back( "free_sarray" );
	asm_line.set( "LABEL", "", "free_sarray", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "heap_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "C", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NC", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );				//	配列そのもののアドレスを保存
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "H", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "L", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SBC", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_sarray_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "_free_sarray_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "free_heap", "" );
	this->subroutines.push_back( asm_line );
	this->activate_free_heap();
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_free_heap( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "free_heap" ) ) {
		return;
	}
	this->subrouines_list.push_back( "free_heap" );
	asm_line.set( "LABEL", "", "free_heap", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[heap_move_size]", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[heap_remap_address]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SBC", "", "HL", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_free_heap_loop0", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_heap_loop0", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[heap_next]", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "vars_area_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_heap_loop1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "varsa_area_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "_free_heap_loop1_end", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[heap_remap_address]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "C", "_free_heap_loop1_next", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[heap_move_size]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SBC", "", "HL", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_heap_loop1_next", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_free_heap_loop1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_heap_loop1_end", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "varsa_area_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_heap_loop2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "varsa_area_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NC", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	//	実体のアドレスに変換する
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SBC", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SBC", "", "HL", "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "H", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "L", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	//	文字列配列変数１つ分
	asm_line.set( "LABEL", "", "_free_heap_sarray_elements", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	//	文字列配列変数の中の要素１つ分
	//	heap_remap_address 以上の値なら対象
	asm_line.set( "LD", "", "HL", "[heap_remap_address]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "C", "_free_heap_loop2_next", "" );
	this->subroutines.push_back( asm_line );
	//	対象のアドレスなので処理する
	asm_line.set( "LD", "", "HL", "[heap_move_size]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SBC", "", "HL", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_free_heap_loop2_next", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "_free_heap_sarray_elements", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_free_heap_loop2", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	新たに確保した文字列配列に、空文字列を詰める
//	HL ... 文字列配列の実体の先頭 (要素 (0, 0, ..., 0) のアドレス)
//	DE ... 詰めるサイズ (byte数)
void CASSEMBLER_LIST::activate_init_string_array( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "init_string_array" ) ) {
		return;
	}
	this->subrouines_list.push_back( "init_string_array" );
	asm_line.set( "LABEL", "", "init_string_array", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "str_0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_init_string_array_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "_init_string_array_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	[HL] の文字列を格納できる領域を確保してコピー後、HLにアドレスを返す。
void CASSEMBLER_LIST::activate_copy_string( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "copy_string" ) ) {
		return;
	}
	this->activate_allocate_string();
	this->subrouines_list.push_back( "copy_string" );
	asm_line.set( "LABEL", "", "copy_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );

}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_str( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "str" ) ) {
		return;
	}
	this->subrouines_list.push_back( "str" );
	this->add_label( "bios_fout", "0x03425" );
	asm_line.set( "LABEL", "", "str", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_fout", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "fout_adjust", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_str_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_str_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "B", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_str_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_str_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_string( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "string" ) ) {
		return;
	}
	this->activate_allocate_string();
	this->add_label( "bios_errhand", "0x0406F" );
	this->subrouines_list.push_back( "string" );
	asm_line.set( "LABEL", "", "string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "string_skip", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "5" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "bios_errhand", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "string_skip", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "AF", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "AF", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "B", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "string_loop_enter", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "string_loop_enter", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DJNZ", "", "string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_single_real_is_zero( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "single_real_is_zero" ) ) {
		return;
	}
	this->subrouines_list.push_back( "single_real_is_zero" );
	asm_line.set( "LABEL", "", "single_real_is_zero", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_double_real_is_zero( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "double_real_is_zero" ) ) {
		return;
	}
	this->subrouines_list.push_back( "double_real_is_zero" );
	asm_line.set( "LABEL", "", "double_real_is_zero", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_check_array( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "check_array" ) ) {
		return;
	}
	this->activate_allocate_heap();
	this->subrouines_list.push_back( "check_array" );

	asm_line.set( "LABEL", "", "check_array", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NZ", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_heap", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "AF", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "11" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_check_array_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DJNZ", "", "_check_array_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_check_sarray( CCONSTANT_INFO *p_constants ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "check_sarray" ) ) {
		return;
	}
	this->activate_allocate_heap();
	this->subrouines_list.push_back( "check_sarray" );

	asm_line.set( "LABEL", "", "check_sarray", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NZ", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_heap", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "AF", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "B", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "C", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "11" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_check_sarray_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "A", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "_check_sarray_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", p_constants->s_blank_string );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_calc_array_top( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "calc_array_top" ) ) {
		return;
	}
	this->subrouines_list.push_back( "calc_array_top" );

	asm_line.set( "LABEL", "", "calc_array_top", "" );
	this->subroutines.push_back( asm_line );
	//	変数の指し示す先を読む
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	//	サイズフィールドを読み飛ばす
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	//	次元数フィールドを取得
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "HL", "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "E" );
	this->subroutines.push_back( asm_line );
	//	戻りアドレスをスタックから DE へ待避
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	//	最初の要素のアドレスをスタックへ積む
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	//	要素数フィールドを読み取ってスタックに積む
	asm_line.set( "JR", "", "_calc_array_top_l2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_calc_array_top_l1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "BC", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_calc_array_top_l2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "A", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "_calc_array_top_l1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_comma( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "print_comma" ) ) {
		return;
	}
	this->subrouines_list.push_back( "print_comma" );
	asm_line.set( "LABEL", "", "print_comma", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_clmlst]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_csrx]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "NONE", "A", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "A", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "C", "_print_comma_loop1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "NONE", "A", "10" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "NONE", "A", "13" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_print_comma_loop1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SUB", "", "A", "14" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "_print_comma_loop1", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "NEG", "NONE", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "' '" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_print_comma_loop2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DJNZ", "", "_print_comma_loop2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_sub_input( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_input" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_input" );
	this->activate_puts();
	this->activate_allocate_string();
	this->add_label( "bios_qinlin", "0x00B4" );
	this->add_label( "bios_fin", "0x3299" );
	this->add_label( "bios_frcint", "0x2f8a" );
	this->add_label( "bios_frcsng", "0x2fb2" );
	this->add_label( "bios_frcdbl", "0x303a" );
	this->add_label( "work_dac", "0xf7f6" );
	this->add_label( "work_valtyp", "0xf663" );
	asm_line.set( "LABEL", "", "sub_input", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_qinlin", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "3" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_sub_input_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_number", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_fin", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "d" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "Z", "_sub_input_redo_from_start", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "_sub_input_skip_white", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_sub_input_number_branch", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "', '" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_sub_input_number_branch", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "_sub_input_redo_from_start", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_number_branch", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[de]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "Z", "_sub_input_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "_sub_input_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcint", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "de", "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[hl]", "e" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[hl]", "d" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_check_next_data", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcsng", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "hl", "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "bc", "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_check_next_data", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcdbl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "hl", "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "bc", "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_check_next_data", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "_sub_input_skip_white", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "'\"'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_get_quote_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_get_normal_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "e", "l" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "d", "h" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "c", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_get_normal_string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_get_string_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "', '" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_get_string_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "c", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_get_normal_string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_get_quote_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "e", "l" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "d", "h" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "c", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_get_quote_string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_get_string_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "'\"'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_get_string_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "c", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_get_quote_string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_get_string_loop_exit", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "c" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_get_quote_string_zero", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "b", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "bc", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_sub_input_copy_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_get_quote_string_zero", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "bc", "str_0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_copy_string", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[hl]", "c" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[hl]", "b" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_check_next_data", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "'\"'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NZ", "_check_next_data2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_check_next_data2", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "_sub_input_skip_white", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_check_next_parameter", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "de", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[de]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_sub_input_extra_ignored", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "_sub_input_string_loop", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_check_next_parameter", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "a", "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "Z", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_retype", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "'?'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "sub_input", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_redo_from_start", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "hl", "_str_redo_from_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "puts", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_sub_input_retype", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_str_redo_from_start", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "18", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "\"?Redo from start\"", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "13, 10", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_extra_ignored", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "hl", "_str_extra_ignored" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "puts", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_str_extra_ignored", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "16", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "\"?Extra ignored\"", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "13, 10", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_input_skip_white", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "a", "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "a", "' '" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NZ", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "", "_sub_input_skip_white", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_bload_r( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_bload_r" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_bload_r" );
	this->add_label( "work_buf", "0x0F55E" );
	this->add_label( "work_himem", "0x0FC4A" );
	this->add_label( "blib_bload", "0x04054" );
	asm_line.set( "LABEL", "", "sub_bload_r", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "restore_h_erro", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "restore_h_timi", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "sub_bload_r_trans_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "sub_bload_r_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "sub_bload_r_trans_end - sub_bload_r_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "sub_bload_r_trans", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DI", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "setup_h_timi", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "setup_h_erro", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EI", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );

	asm_line.set( "LABEL", "", "sub_bload_r_trans_start", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ORG", "", "work_buf + 50", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_bload_r_trans", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "iy", "[work_blibslot - 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "ix", "blib_bload" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_calslt", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "hl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_bload_r_trans_end", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ORG", "", "sub_bload_r_trans_start + sub_bload_r_trans_end - sub_bload_r_trans", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_bload( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_bload" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_bload" );
	this->add_label( "work_buf", "0x0F55E" );
	this->add_label( "work_himem", "0x0FC4A" );
	this->add_label( "blib_bload", "0x04054" );
	asm_line.set( "LABEL", "", "sub_bload", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "restore_h_erro", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "restore_h_timi", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "sub_bload_trans_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "sub_bload_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "sub_bload_trans_end - sub_bload_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "sub_bload_trans", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DI", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "setup_h_timi", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "setup_h_erro", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EI", "", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "", "", "" );
	this->subroutines.push_back( asm_line );

	asm_line.set( "LABEL", "", "sub_bload_trans_start", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ORG", "", "work_buf + 50", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_bload_trans", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "iy", "[work_blibslot - 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "ix", "blib_bload" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_calslt", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "hl", "[work_himem]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "de", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RST", "", "0x20", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET", "NC", "", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "_bload_basic_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_newstt", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_bload_basic_end", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEFB", "", "':', 0x81, 0x00", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_bload_trans_end", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ORG", "", "sub_bload_trans_start + sub_bload_trans_end - sub_bload_trans", "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_paint( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_paint" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_paint" );

	this->add_label( "work_forclr", "0x0F3E9" );
	this->add_label( "work_brdatr", "0x0FCB2" );
	this->add_label( "work_gxpos", "0x0FCB3" );
	this->add_label( "work_gypos", "0x0FCB5" );
	this->add_label( "work_scrmod", "0x0FCAF" );
	this->add_label( "work_atrbyt", "0x0F3F2" );
	this->add_label( "bios_setatr", "0x0011A" );
	this->add_label( "bios_paint", "0x059E3" );
	this->add_label( "subrom_paint", "0x0266E" );
	this->add_label( "bios_extrom", "0x0015F" );

	asm_line.set( "COMMENT", "", "Paint subroutine" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_paint" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "[work_gxpos]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[work_gypos]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_brdatr]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_scrmod]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CP", "", "A", "5" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "sub_paint_vdpcmd" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "COMMENT", "", "Case of SCREEN2...4 (Without VDP Command)" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_atrbyt]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JP", "", "bios_paint" );
	this->subroutines.push_back( asm_line );

	asm_line.set( "COMMENT", "", "Case of SCREEN5...12 (With VDP Command)" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_paint_vdpcmd" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_brdatr]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "IX", "subrom_paint" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_extrom" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EI" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_read_string(void) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_read_string" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_read_string" );

	asm_line.set( "COMMENT", "", "Read data for string" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_read_string" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[data_ptr]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[data_ptr]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_val(void) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_val" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_val" );

	this->add_label( "bios_fin", "0x3299" );
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_buf", "0x0f55e" );

	asm_line.set( "COMMENT", "", "Val function" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_val" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "work_buf" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LDIR" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[DE]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "work_buf" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_fin", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_read_integer(void) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_read_integer" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_read_integer" );

	this->activate_val();
	this->add_label( "bios_frcint", "0x2f8a" );
	this->add_label( "work_dac", "0x0f7f6" );

	asm_line.set( "COMMENT", "", "Read data for integer" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_read_integer" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[data_ptr]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[data_ptr]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "sub_val", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcint", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_read_single(void) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_read_single" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_read_single" );

	this->activate_val();
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "bios_frcsng", "0x2fb2" );
	this->activate_ld_de_single_real();

	asm_line.set( "COMMENT", "", "Read data for single-real value" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_read_single" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[data_ptr]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[data_ptr]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "sub_val", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcsng", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_de_single_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_read_double(void) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_read_double" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_read_double" );

	this->activate_val();
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "bios_frcdbl", "0x303a" );
	this->activate_ld_de_double_real();

	asm_line.set( "COMMENT", "", "Read data for double-real value" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_read_double" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[data_ptr]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[data_ptr]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "sub_val", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_frcdbl", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_de_double_real", "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RET" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_circle( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "sub_circle" ) ) {
		return;
	}
	this->subrouines_list.push_back( "sub_circle" );
	this->activate_ld_arg_single_real();

	this->add_label( "work_aspct1", "0x0f40b" );
	this->add_label( "work_aspct2", "0x0f40d" );
	this->add_label( "work_valtyp", "0x0f663" );
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "blib_get_sin_table", "0x40de" );
	this->add_label( "bios_decmul", "0x027e6" );
	this->add_label( "bios_int", "0x030cf" );
	this->add_label( "work_buf", "0x0f55e" );
	this->add_label( "work_scrmod", "0x0fcaf" );
	this->add_label( "blib_get_sin_table", "0x040de" );

	asm_line.set( "COMMENT", "", "Circle routine" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "sub_circle" );
	this->subroutines.push_back( asm_line );
	//	垂直半径を計算する
	asm_line.set( "LD", "", "HL", "[work_cxoff]" );		//	水平半径
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_dac + 2]", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "2" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_valtyp]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "work_aspect" );		//	比率
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "ld_arg_single_real" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_decmul" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "bios_int" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_aspct2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RLCA" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "NC", "_sub_circle_skip1" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "SRL", "", "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RR", "", "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_circle_skip1" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_cyoff]", "HL" );
	this->subroutines.push_back( asm_line );
	//	SCREEN6 or 7 なら [bug+65] = 1, それ以外は 0
	asm_line.set( "LD", "", "A", "[work_aspct1 + 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RRCA" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_buf + 65]", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "A" );
	this->subroutines.push_back( asm_line );
	//	中心点の位置により、円の4象限の描画対象外を判定 buf+66 = [0] ... buf+69 = [3] (0なら対象、0以外なら対象外)
	asm_line.set( "LD", "", "A", "[work_gxpos + 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "AND", "", "A", "0x80" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_buf + 67]", "A" );		//	[1]
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_buf + 68]", "A" );		//	[2]
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "DEC", "", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "JR", "Z", "_sub_circle_skip1" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "RRCA" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_circle_skip1" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "AND", "", "A", "0x7F" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_buf + 66]", "A" );		//	[0]
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[work_buf + 69]", "A" );		//	[3]
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[work_gypos + 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "B", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "HL", "work_buf + 66" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "AND", "", "A", "0x80" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "C", "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "A" );					//	[0]
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "A" );					//	[1]
	this->subroutines.push_back( asm_line );
	asm_line.set( "INC", "", "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LD", "", "A", "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "AND", "", "A", "0x7F" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "OR", "", "A", "[HL]" );
	this->subroutines.push_back( asm_line );




	//	sinテーブルをゲットする
	asm_line.set( "LD", "", "IX", "blib_get_sin_table" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	this->subroutines.push_back( asm_line );
	//	θ = 45°→0°
	asm_line.set( "LD", "", "B", "32" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "LABEL", "", "_sub_circle_theta_loop" );
	this->subroutines.push_back( asm_line );
	//		VX = cosθ = sin(90° -θ), VY = sinθ
	asm_line.set( "LD", "", "A", "work_buf & 0x0FF" );
	this->subroutines.push_back( asm_line );
	asm_line.set( "ADD", "", "A", "B" );
	this->subroutines.push_back( asm_line );



}

// --------------------------------------------------------------------
bool CASSEMBLER_LIST::save_sub( FILE *p_file, std::vector< CASSEMBLER_LINE > *p_list ) {
	bool b_result = true;
	std::vector< CASSEMBLER_LINE >::iterator p;

	for( p = p_list->begin(); p != p_list->end(); p++ ) {
		b_result = p->save( p_file ) && b_result;
	}
	return b_result;
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::add_label( const std::string s_name, const std::string s_value ) {

	//	既に存在しているラベルなのか調べる
	for( auto &p: this->label_list ) {
		if( p == s_name ) {
			//	存在している場合は何もしない
			return;
		}
	}
	//	リストに追加する
	this->label_list.push_back( s_name );

	CASSEMBLER_LINE asm_line;
	asm_line.set( "CONSTANT", "", s_name, s_value );
	this->define_labels.push_back( asm_line );
}

// --------------------------------------------------------------------
bool CASSEMBLER_LIST::save( const std::string s_file_name ) {
	FILE *p_file;
	bool result = true;

	p_file = fopen( s_file_name.c_str(), "w" );
	if( p_file == NULL ) {
		fprintf( stderr, "ERROR: Cannot create the '%s'.\n", s_file_name.c_str() );
		return false;
	}

	result &= this->save_sub( p_file, &(this->header) );
	result &= this->save_sub( p_file, &(this->define_labels) );
	result &= this->save_sub( p_file, &(this->body) );
	result &= this->save_sub( p_file, &(this->subroutines) );
	result &= this->save_sub( p_file, &(this->datas) );
	result &= this->save_sub( p_file, &(this->const_single_area) );
	result &= this->save_sub( p_file, &(this->const_double_area) );
	result &= this->save_sub( p_file, &(this->const_string_area) );
	result &= this->save_sub( p_file, &(this->variables_area) );
	result &= this->save_sub( p_file, &(this->footer) );
	fclose( p_file );

	return result;
}
