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
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
		this->datas.push_back( asm_line );
	}
	
	CSTRING value;
	value.set( s_value );
	s_label = p_constants->add( value );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
	this->datas.push_back( asm_line );
}


// --------------------------------------------------------------------
void CASSEMBLER_LIST::push_hl( CEXPRESSION_TYPE type ) {
	CASSEMBLER_LINE asm_line;

	switch( type ) {
	default:
	case CEXPRESSION_TYPE::INTEGER:
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		this->body.push_back( asm_line );
		break;
	case CEXPRESSION_TYPE::SINGLE_REAL:
		this->activate_push_single_real_hl();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "push_single_real_hl", COPERAND_TYPE::NONE, "" );
		this->body.push_back( asm_line );
		break;
	case CEXPRESSION_TYPE::DOUBLE_REAL:
		this->activate_push_double_real_hl();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "push_double_real_hl", COPERAND_TYPE::NONE, "" );
		this->body.push_back( asm_line );
		break;
	case CEXPRESSION_TYPE::STRING:
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
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
//		pop		bc
//		ld		e, [hl]
//		inc		hl
//		ld		d, [hl]
//		inc		hl
//		push	de
//		ld		e, [hl]
//		inc		hl
//		ld		d, [hl]
//		push	de
//		push	bc
//		ret
//
void CASSEMBLER_LIST::activate_push_single_real_hl( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "push_single_real_hl" ) ) {
		return;
	}
	this->subrouines_list.push_back( "push_single_real_hl" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "push_single_real_hl", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//		push_double_real_dac:
//		pop		bc
//		ld		e, [hl]
//		inc		hl
//		ld		d, [hl]
//		inc		hl
//		push		de
//		ld		e, [hl]
//		inc		hl
//		ld		d, [hl]
//		inc		hl
//		push		de
//		ld		e, [hl]
//		inc		hl
//		ld		d, [hl]
//		inc		hl
//		push		de
//		ld		e, [hl]
//		inc		hl
//		ld		d, [hl]
//		push		de
//		push		bc
//		ret
//
void CASSEMBLER_LIST::activate_push_double_real_hl( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "push_double_real_hl" ) ) {
		return;
	}
	this->subrouines_list.push_back( "push_double_real_hl" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "push_double_real_hl", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_single_real_arg:
//		pop		bc
//		pop		hl
//		ld		[work_arg+0], hl
//		pop		hl
//		ld		[work_arg+2], hl
//		ld		hl, 0
//		ld		[work_arg+4], hl
//		ld		[work_arg+6], hl
//		push	bc
//		ret
//
void CASSEMBLER_LIST::activate_pop_single_real_arg( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_single_real_arg" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_single_real_arg" );
	this->add_label( "work_arg", "0x0f847" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_arg", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+2]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+0]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "HL", COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+4]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+6]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_convert_to_integer( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "convert_to_integer" ) ) {
		return;
	}
	this->subrouines_list.push_back( "convert_to_integer" );

	this->add_label( "work_dac_int", "0x0f7f8" );
	this->add_label( "bios_frcint", "0x02f8a" );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "convert_to_integer", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcint", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
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
	this->add_label( "work_dac_int", "0x0f7f8" );
	this->add_label( "work_arg", "0x0f7f6" );
	this->add_label( "bios_fcomp", "0x02f21" );
	this->add_label( "bios_decsub", "0x0268c" );
	this->add_label( "bios_frcint", "0x02f8a" );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "convert_to_integer_from_sngle_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_single_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	もし DAC < 32768! なら → A = -1 なら、普通に FRCINT で変換。(-32768 より小さければ、FRCINT が Overflow 出す。)
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "0x3245" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "0x8076" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_fcomp", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "convert_to_integer", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	HL = int(DAC - 32768!) xor &H8000
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label_32768 );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decsub", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcint", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "[work_dac_int]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "0x80" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
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

	this->activate_ld_dac_single_real();
	this->activate_ld_arg_single_real();
	this->activate_convert_to_integer();

	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_dac_int", "0x0f7f8" );
	this->add_label( "work_arg", "0x0f7f6" );
	this->add_label( "bios_fcomp", "0x02f21" );
	this->add_label( "bios_decsub", "0x0268c" );
	this->add_label( "bios_frcint", "0x02f8a" );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "convert_to_integer_from_double_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_double_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	もし DAC < 32768! なら → A = -1 なら、普通に FRCINT で変換。(-32768 より小さければ、FRCINT が Overflow 出す。)
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "0x3245" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "0x8076" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_fcomp", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "convert_to_integer", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	HL = int(DAC - 32768!) xor &H8000
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label_32768 );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_decsub", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_frcint", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "[work_dac_int]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "0x80" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_single_real_dac:
//		pop		bc
//		pop		hl
//		ld		[work_dac+0], hl
//		pop		hl
//		ld		[work_dac+2], hl
//		ld		hl, 0
//		ld		[work_dac+4], hl
//		ld		[work_dac+6], hl
//		push	bc
//		ret
//
void CASSEMBLER_LIST::activate_pop_single_real_dac( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_single_real_dac" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_single_real_dac" );
	this->add_label( "work_dac", "0x0f7f6" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_single_real_dac", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+2]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+0]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "HL", COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+4]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+6]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_single_real_arg:
//		pop		bc
//		pop		hl
//		ld		[work_arg+0], hl
//		pop		hl
//		ld		[work_arg+2], hl
//		ld		hl, 0
//		ld		[work_arg+4], hl
//		ld		[work_arg+6], hl
//		push	bc
//		ret
//
void CASSEMBLER_LIST::activate_pop_double_real_arg( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_double_real_arg" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_double_real_arg" );
	this->add_label( "work_arg", "0x0f847" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_double_real_arg", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+6]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+4]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+2]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+0]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	pop_double_real_dac:
//		pop		bc
//		pop		hl
//		ld		[work_dac+0], hl
//		pop		hl
//		ld		[work_dac+2], hl
//		pop		hl
//		ld		[work_dac+4], hl
//		pop		hl
//		ld		[work_dac+6], hl
//		push	bc
//		ret
//
void CASSEMBLER_LIST::activate_pop_double_real_dac( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "pop_double_real_dac" ) ) {
		return;
	}
	this->subrouines_list.push_back( "pop_double_real_dac" );
	this->add_label( "work_dac", "0x0f7f6" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "pop_double_real_dac", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+6]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+4]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+2]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+0]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_ld_dac_single_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_dac_single_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_dac_single_real" );
	this->add_label( "work_dac", "0x0f7f6" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_single_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+4]", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac+6]", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_ld_dac_double_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_dac_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_dac_double_real" );
	this->add_label( "work_dac", "0x0f7f6" );
	this->add_label( "work_valtyp", "0x0f663" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_double_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[work_valtyp]", COPERAND_TYPE::NONE, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_ld_arg_single_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_arg_single_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_arg_single_real" );
	this->add_label( "work_arg", "0x0f847" );
	this->add_label( "work_valtyp", "0x0f663" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_single_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_arg" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+4]", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_arg+6]", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[work_valtyp]", COPERAND_TYPE::NONE, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_ld_arg_double_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_arg_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_arg_double_real" );
	this->add_label( "work_arg", "0x0f847" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "work_arg" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_ld_de_single_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_de_single_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_de_single_real" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_de_single_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_ld_de_double_real( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "ld_de_double_real" ) ) {
		return;
	}
	this->subrouines_list.push_back( "ld_de_double_real" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_de_double_real", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_puts( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "puts" ) ) {
		return;
	}
	this->subrouines_list.push_back( "puts" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "puts", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::Z, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_puts_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_puts_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_spc( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "spc" ) ) {
		return;
	}
	this->subrouines_list.push_back( "spc" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "spc", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "32" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_spc_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_spc_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_REGISTER, "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_REGISTER, "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_REGISTER, "[heap_end]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::LABEL, "_allocate_string_error", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_allocate_string_error", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "7" );			//	Out of memory.
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_errhand", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_free_string( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "free_string" ) ) {
		return;
	}
	this->subrouines_list.push_back( "free_string" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "heap_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::C, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NC, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::NONE, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_heap", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_heap", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_remap_address]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_move_size]", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_remap_address]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_free_heap_loop0", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop0", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]", COPERAND_TYPE::REGISTER, "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "vars_area_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop1", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_remap_address]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, "_free_heap_loop1_next", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_move_size]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[HL]", COPERAND_TYPE::MEMORY_REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[HL]", COPERAND_TYPE::MEMORY_REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop1_next", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "varsa_area_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, "_free_heap_loop1", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	★T.B.D.
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "copy_string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "str", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_fout", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "fout_adjust", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_str_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_str_loop_exit", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_str_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_str_loop_exit", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[HL]", COPERAND_TYPE::NONE, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_single_real_is_zero( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "single_real_is_zero" ) ) {
		return;
	}
	this->subrouines_list.push_back( "single_real_is_zero" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "single_real_is_zero", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_double_real_is_zero( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "double_real_is_zero" ) ) {
		return;
	}
	this->subrouines_list.push_back( "double_real_is_zero" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "double_real_is_zero", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
bool CASSEMBLER_LIST::save_sub( FILE *p_file, std::vector< CASSEMBLER_LINE > *p_list, COUTPUT_TYPES output_type ) {
	bool b_result = true;
	std::vector< CASSEMBLER_LINE >::iterator p;

	for( p = p_list->begin(); p != p_list->end(); p++ ) {
		b_result = p->save( p_file, output_type ) && b_result;
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
	asm_line.set( CMNEMONIC_TYPE::CONSTANT, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_name, COPERAND_TYPE::CONSTANT, s_value );
	this->define_labels.push_back( asm_line );
}

// --------------------------------------------------------------------
bool CASSEMBLER_LIST::save( const std::string s_file_name, COUTPUT_TYPES output_type ) {
	FILE *p_file;
	bool result = true;

	fopen_s( &p_file, s_file_name.c_str(), "w" );
	if( p_file == NULL ) {
		fprintf( stderr, "ERROR: Cannot create the '%s'.\n", s_file_name.c_str() );
		return false;
	}

	result &= this->save_sub( p_file, &(this->header), output_type );
	result &= this->save_sub( p_file, &(this->define_labels), output_type );
	result &= this->save_sub( p_file, &(this->body), output_type );
	result &= this->save_sub( p_file, &(this->subroutines), output_type );
	result &= this->save_sub( p_file, &(this->datas), output_type );
	result &= this->save_sub( p_file, &(this->const_single_area), output_type );
	result &= this->save_sub( p_file, &(this->const_double_area), output_type );
	result &= this->save_sub( p_file, &(this->const_string_area), output_type );
	result &= this->save_sub( p_file, &(this->variables_area), output_type );
	result &= this->save_sub( p_file, &(this->footer), output_type );
	fclose( p_file );

	return result;
}
