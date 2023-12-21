// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_operator_equ.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_OPERATOR_EQU::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return nullptr;
	}
	p = this->p_left->optimization( p_info );
	if( p != nullptr ) {
		delete (this->p_left);
		this->p_left = p;
	}

	p = this->p_right->optimization( p_info );
	if( p != nullptr ) {
		delete (this->p_right);
		this->p_right = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_EQU::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	std::string s_label;

	if( this->p_left == nullptr || this->p_right == nullptr ) {
		return;
	}
	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_info );
	p_info->assembler_list.push_hl( this->p_left->type );
	this->p_right->compile( p_info );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚Í•K‚¸®”
	this->type_adjust_2op( p_info, this->p_left, this->p_right );

	if( this->type == CEXPRESSION_TYPE::STRING ) {
		//	•¶Žš—ñ‚Ìê‡
		p_info->assembler_list.activate_free_string();
		s_label = p_info->get_auto_label();
		p_info->assembler_list.add_label( "blib_strcmp", "0x04027" );
		asm_line.set( "POP", "", "DE", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "EX", "", "DE", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "PUSH", "", "HL", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "PUSH", "", "DE", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "IX", "blib_strcmp" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "HL", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "PUSH", "", "AF", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "free_string", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "AF", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "HL", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "PUSH", "", "AF", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "free_string", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "POP", "", "AF", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "JR", "NZ", s_label, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "DEC", "", "HL", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LABEL", "", s_label, "" );
		p_info->assembler_list.body.push_back( asm_line );
		this->type = CEXPRESSION_TYPE::INTEGER;
		return;
	}
	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		//	‚±‚Ì‰‰ŽZŽq‚ª®”‚Ìê‡
		p_info->assembler_list.add_label( "bios_icomp", "0x02f4d" );
		asm_line.set( "POP", "", "DE", "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "bios_icomp", "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	‚±‚Ì‰‰ŽZŽq‚ªŽÀ”‚Ìê‡
		p_info->assembler_list.add_label( "bios_xdcomp", "0x02f5c" );
		asm_line.set( "CALL", "", "bios_xdcomp", "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( "AND", "", "A", "1" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "DEC", "", "A", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "H", "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "L", "A" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
