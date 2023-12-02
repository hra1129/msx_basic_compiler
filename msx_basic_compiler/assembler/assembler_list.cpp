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

	//	���Ƀf�[�^���x����z�u�����s�ԍ����H
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
	//	���� DAC < 32768! �Ȃ� �� A = -1 �Ȃ�A���ʂ� FRCINT �ŕϊ��B(-32768 ��菬������΁AFRCINT �� Overflow �o���B)
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

	this->activate_ld_dac_double_real();
	this->activate_ld_arg_double_real();
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
	//	���� DAC < 32768! �Ȃ� �� A = -1 �Ȃ�A���ʂ� FRCINT �ŕϊ��B(-32768 ��菬������΁AFRCINT �� Overflow �o���B)
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
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_arg_double_real", COPERAND_TYPE::NONE, "" );
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
	this->add_label( "work_valtyp", "0x0f663" );
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
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
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
//	A �ɕ����� 1�`255 �����ČĂԁB HL �Ɋm�ۂ����A�h���X��Ԃ��B
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
//	BC �Ɋm�ۂ���T�C�Y�����ČĂԁB HL �Ɋm�ۂ����A�h���X��Ԃ��B
void CASSEMBLER_LIST::activate_allocate_heap( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "allocate_heap" ) ) {
		return;
	}
	this->subrouines_list.push_back( "allocate_heap" );
	this->add_label( "bios_errhand", "0x0406F" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_heap", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_REGISTER, "[heap_next]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, "_allocate_heap_error", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_REGISTER, "[heap_end]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::LABEL, "_allocate_heap_error", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::REGISTER, "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::REGISTER, "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_allocate_heap_error", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
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
void CASSEMBLER_LIST::activate_free_array( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "free_array" ) ) {
		return;
	}
	this->subrouines_list.push_back( "free_array" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_array", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );				//	[�T�C�Y] �� 2byte ��ǉ�
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_heap", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_sarray", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	�z�񂻂̂��̂̃A�h���X��ۑ�
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_sarray_loop", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::REGISTER, "_free_sarray_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_move_size]", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_remap_address]", COPERAND_TYPE::REGISTER, "HL" );
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
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
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
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "varsa_area_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::LABEL, "_free_heap_loop1_end", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_move_size]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop1_next", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop1", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop1_end", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "varsa_area_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop2", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "varsa_area_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NC, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	���̂̃A�h���X�ɕϊ�����
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "BC" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	//	������z��ϐ��P��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_sarray_elements", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	������z��ϐ��̒��̗v�f�P��
	//	heap_remap_address �ȏ�̒l�Ȃ�Ώ�
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_remap_address]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x20", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, "_free_heap_loop2_next", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	//	�Ώۂ̃A�h���X�Ȃ̂ŏ�������
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[heap_move_size]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop2_next", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_free_heap_sarray_elements", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_free_heap_loop2", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	�V���Ɋm�ۂ���������z��ɁA�󕶎�����l�߂�
//	HL ... ������z��̎��̂̐擪 (�v�f (0,0,...,0) �̃A�h���X)
//	DE ... �l�߂�T�C�Y (byte��)
void CASSEMBLER_LIST::activate_init_string_array( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "init_string_array" ) ) {
		return;
	}
	this->subrouines_list.push_back( "init_string_array" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "init_string_array", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::LABEL, "str_0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_init_string_array_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_init_string_array_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
//	[HL] �̕�������i�[�ł���̈���m�ۂ��ăR�s�[��AHL�ɃA�h���X��Ԃ��B
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
void CASSEMBLER_LIST::activate_string( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "string" ) ) {
		return;
	}
	this->activate_allocate_string();
	this->add_label( "bios_errhand", "0x0406F" );
	this->subrouines_list.push_back( "string" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "string_skip", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::CONSTANT, "5" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_errhand", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string_skip", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_string", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string_loop_enter", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string_loop_enter", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "string_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
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
void CASSEMBLER_LIST::activate_check_array( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "check_array" ) ) {
		return;
	}
	this->activate_allocate_heap();
	this->subrouines_list.push_back( "check_array" );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,            "check_array",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "A",                COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "A",                COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,   CCONDITION::NZ,   COPERAND_TYPE::NONE,             "",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,  CCONDITION::NONE, COPERAND_TYPE::LABEL,            "allocate_heap",    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "AF",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",               COPERAND_TYPE::REGISTER,  "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER,  "[HL]",             COPERAND_TYPE::REGISTER,  "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER,  "[HL]",             COPERAND_TYPE::REGISTER,  "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",               COPERAND_TYPE::REGISTER,  "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",               COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",              COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",              COPERAND_TYPE::REGISTER, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",              COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "B",                 COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "DE",                COPERAND_TYPE::CONSTANT, "11" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_array_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",              COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",              COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ,  CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_array_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,   CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                  COPERAND_TYPE::NONE, "" );
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

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,            "check_sarray",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "A",                  COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "A",                  COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,   CCONDITION::NZ,   COPERAND_TYPE::NONE,             "",                   COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,  CCONDITION::NONE, COPERAND_TYPE::LABEL,            "allocate_heap",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "AF",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::REGISTER,  "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER,  "[HL]",               COPERAND_TYPE::REGISTER,  "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER,  "[HL]",               COPERAND_TYPE::REGISTER,  "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::REGISTER,  "HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "C" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,	       "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "A",                   COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RR,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "B",                   COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RR,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "C",                   COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "DE",                  COPERAND_TYPE::CONSTANT, "11" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,            "_check_sarray_loop", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "BC",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "A",                   COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR,    CCONDITION::NZ, COPERAND_TYPE::LABEL,            "_check_sarray_loop",  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "DE",                  COPERAND_TYPE::LABEL, p_constants->s_blank_string );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "E" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]",                COPERAND_TYPE::REGISTER, "D" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "E",                   COPERAND_TYPE::REGISTER, "L" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "D",                   COPERAND_TYPE::REGISTER, "H" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "BC",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR,  CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "HL",                  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,   CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_calc_array_top( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "calc_array_top" ) ) {
		return;
	}
	this->subrouines_list.push_back( "calc_array_top" );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,            "calc_array_top",     COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	//	�ϐ��̎w���������ǂ�
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "E",                  COPERAND_TYPE::REGISTER,        "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "D",                  COPERAND_TYPE::REGISTER,        "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::REGISTER,        "HL" );
	this->subroutines.push_back( asm_line );
	//	�T�C�Y�t�B�[���h��ǂݔ�΂�
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	//	�������t�B�[���h���擾
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "E",                  COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "D",                  COPERAND_TYPE::CONSTANT,        "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::REGISTER,        "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ADD,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::REGISTER,        "DE" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "A",                  COPERAND_TYPE::REGISTER,        "E" );
	this->subroutines.push_back( asm_line );
	//	�߂�A�h���X���X�^�b�N���� DE �֑Ҕ�
	asm_line.set( CMNEMONIC_TYPE::POP,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	//	�ŏ��̗v�f�̃A�h���X���X�^�b�N�֐ς�
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	//	�v�f���t�B�[���h��ǂݎ���ăX�^�b�N�ɐς�
	asm_line.set( CMNEMONIC_TYPE::JR,    CCONDITION::NONE, COPERAND_TYPE::LABEL,            "_calc_array_top_l2", COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,            "_calc_array_top_l1", COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "B",                  COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "HL",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,    CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "C",                  COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "BC",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL,            "_calc_array_top_l2", COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "A",                  COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR,    CCONDITION::NZ,   COPERAND_TYPE::LABEL,            "_calc_array_top_l1", COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,         "DE",                 COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,   CCONDITION::NONE, COPERAND_TYPE::NONE,             "",                   COPERAND_TYPE::NONE,            "" );
	this->subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CASSEMBLER_LIST::activate_comma( void ) {
	CASSEMBLER_LINE asm_line;

	if( this->is_registered_subroutine( "print_comma" ) ) {
		return;
	}
	this->subrouines_list.push_back( "print_comma" );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "print_comma", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_clmlst]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_csrx]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE,COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C,COPERAND_TYPE::LABEL, "_print_comma_loop1", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE,COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "10" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE,COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "13" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_print_comma_loop1", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SUB, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "14" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::LABEL, "_print_comma_loop1", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::NEG, CCONDITION::NONE,COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT , "' '" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_print_comma_loop2", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x18", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_print_comma_loop2", COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "sub_input",                   COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "bios_qinlin",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_string_loop",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::REGISTER, "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "3" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_sub_input_string",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_number",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::REGISTER, "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "bios_fin",                    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "d" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_sub_input_redo_from_start",  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_skip_white",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_sub_input_number_branch",    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "','" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_sub_input_number_branch",    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_redo_from_start",  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_number_branch",    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[de]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_sub_input_single_real",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NC,   COPERAND_TYPE::LABEL,           "_sub_input_double_real",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "bios_frcint",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac + 2]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "[hl]",                        COPERAND_TYPE::REGISTER, "e" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "[hl]",                        COPERAND_TYPE::REGISTER, "d" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_next_data",            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_single_real",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "bios_frcsng",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::CONSTANT, "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::CONSTANT, "4" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_next_data",            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_double_real",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "bios_frcdbl",                 COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::CONSTANT, "work_dac" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::CONSTANT, "8" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_next_data",            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_string",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::REGISTER, "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_skip_white",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "'\"'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_get_quote_string",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_normal_string",          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "e",                           COPERAND_TYPE::REGISTER, "l" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "d",                           COPERAND_TYPE::REGISTER, "h" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "c",                           COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_normal_string_loop",     COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_get_string_loop_exit",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "','" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_get_string_loop_exit",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "c",                           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_normal_string_loop",     COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_quote_string",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "e",                           COPERAND_TYPE::REGISTER, "l" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "d",                           COPERAND_TYPE::REGISTER, "h" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "c",                           COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_quote_string_loop",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_get_string_loop_exit",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "'\"'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_get_string_loop_exit",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "c",                           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_quote_string_loop",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_string_loop_exit",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "c" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_get_quote_string_zero",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "allocate_string",             COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "b",                           COPERAND_TYPE::CONSTANT, "0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,   CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::REGISTER, "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_copy_string",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_get_quote_string_zero",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "bc",                          COPERAND_TYPE::CONSTANT, "str_0" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_copy_string",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::REGISTER, "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[hl]",                        COPERAND_TYPE::REGISTER, "c" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[hl]",                        COPERAND_TYPE::REGISTER, "b" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::REGISTER, "hl" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_next_data",            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "'\"'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NZ,    COPERAND_TYPE::LABEL,          "_check_next_data2",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_next_data2",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_skip_white",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_check_next_parameter",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "de",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[de]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::Z,    COPERAND_TYPE::LABEL,           "_sub_input_extra_ignored",    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_string_loop",      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_check_next_parameter",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::REGISTER, "a" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, 	CCONDITION::Z,    COPERAND_TYPE::NONE,            "",                            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_retype",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "'?'" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "0x18",                        COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "sub_input",                   COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_redo_from_start",  COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::CONSTANT, "_str_redo_from_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "puts",                        COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_retype",           COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_str_redo_from_start",        COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "18",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "\"?Redo from start\"",        COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "13, 10",                      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_extra_ignored",    COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "hl",                          COPERAND_TYPE::CONSTANT, "_str_extra_ignored" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,           "puts",                        COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,  CCONDITION::NONE, COPERAND_TYPE::NONE,            "",                            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_str_extra_ignored",          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "16",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "\"?Extra ignored\"",          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT,        "13, 10",                      COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_skip_white",       COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, 	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::MEMORY_REGISTER, "[hl]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CP,	CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "a",                           COPERAND_TYPE::CONSTANT, "' '" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,  CCONDITION::NZ,   COPERAND_TYPE::NONE,            "",                            COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,  CCONDITION::NONE, COPERAND_TYPE::REGISTER,        "hl",                          COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, 	CCONDITION::NONE, COPERAND_TYPE::LABEL,           "_sub_input_skip_white",       COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,		"sub_bload_r",					COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,  "HL",							COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "restore_h_erro",				COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "restore_h_timi",				COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL,       "HL",							COPERAND_TYPE::NONE, "sub_bload_r_trans_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL,       "DE",							COPERAND_TYPE::NONE, "sub_bload_r_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL,       "BC",							COPERAND_TYPE::NONE, "sub_bload_r_trans_end - sub_bload_r_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE,      "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER,  "HL",							COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "sub_bload_r_trans",			COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE,	    "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "setup_h_timi",					COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "setup_h_erro",					COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE,	    "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE,	    "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"sub_bload_r_trans_start",		COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ORG,		CCONDITION::NONE,	COPERAND_TYPE::CONSTANT,	"work_buf + 50",				COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"sub_bload_r_trans",			COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"iy",							COPERAND_TYPE::MEMORY_CONSTANT,	"[work_blibslot - 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"ix",							COPERAND_TYPE::LABEL,			"blib_bload" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"bios_calslt",					COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"hl",							COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,		CCONDITION::NONE,	COPERAND_TYPE::NONE,		"",								COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"sub_bload_r_trans_end",		COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ORG,		CCONDITION::NONE,	COPERAND_TYPE::CONSTANT,	"sub_bload_r_trans_start + sub_bload_r_trans_end - sub_bload_r_trans", COPERAND_TYPE::NONE,			"" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE, COPERAND_TYPE::LABEL,		"sub_bload",					COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER,  "HL",							COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "restore_h_erro",				COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "restore_h_timi",				COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL,       "HL",							COPERAND_TYPE::NONE, "sub_bload_trans_start" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL,       "DE",							COPERAND_TYPE::NONE, "sub_bload_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::LABEL,       "BC",							COPERAND_TYPE::NONE, "sub_bload_trans_end - sub_bload_trans" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE,      "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER,	"HL",							COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "sub_bload_trans",				COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE,	    "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "setup_h_timi",					COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,     "setup_h_erro",					COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE,	    "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE,	    "",								COPERAND_TYPE::NONE, "" );
	this->subroutines.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"sub_bload_trans_start",		COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ORG,		CCONDITION::NONE,	COPERAND_TYPE::CONSTANT,	"work_buf + 50",				COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"sub_bload_trans",				COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"iy",							COPERAND_TYPE::MEMORY_CONSTANT,	"[work_blibslot - 1]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"ix",							COPERAND_TYPE::LABEL,			"blib_bload" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"bios_calslt",					COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"hl",							COPERAND_TYPE::MEMORY_CONSTANT,	"[work_himem]" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"de",							COPERAND_TYPE::REGISTER,		"HL" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RST,		CCONDITION::NONE,	COPERAND_TYPE::CONSTANT,	"0x20",							COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,		CCONDITION::NC,		COPERAND_TYPE::NONE,		"",								COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,	"HL",							COPERAND_TYPE::LABEL,			"_bload_basic_end" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"bios_newstt",					COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"_bload_basic_end",				COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB,		CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"':', 0x81, 0x00",				COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,		"sub_bload_trans_end",			COPERAND_TYPE::NONE,			"" );
	this->subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ORG,		CCONDITION::NONE,	COPERAND_TYPE::CONSTANT,	"sub_bload_trans_start + sub_bload_trans_end - sub_bload_trans", COPERAND_TYPE::NONE,			"" );
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

	//	���ɑ��݂��Ă��郉�x���Ȃ̂����ׂ�
	for( auto &p: this->label_list ) {
		if( p == s_name ) {
			//	���݂��Ă���ꍇ�͉������Ȃ�
			return;
		}
	}
	//	���X�g�ɒǉ�����
	this->label_list.push_back( s_name );

	CASSEMBLER_LINE asm_line;
	asm_line.set( CMNEMONIC_TYPE::CONSTANT, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_name, COPERAND_TYPE::CONSTANT, s_value );
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
