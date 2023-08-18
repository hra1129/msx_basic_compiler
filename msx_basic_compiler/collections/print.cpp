// --------------------------------------------------------------------
//	Compiler collection: Print
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "print.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  PRINT
//	PRINT ® [[;|,] ® | TAB(n) | SPC(n) ]
bool CPRINT::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	bool has_semicolon;

	if( p_info->list.p_position->s_word != "PRINT" && p_info->list.p_position->s_word != "LPRINT" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.p_position->s_word == "LPRINT" ) {
		p_info->assembler_list.add_label( "work_prtflg", "0x0f416" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "1" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_prtflg]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	has_semicolon = false;
	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "SPC(" ) {
			//	SPC(n) ‚Ìê‡
			p_info->list.p_position++;
			p_info->assembler_list.activate_spc();
			if( exp.compile( p_info ) ) {
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "spc", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				return false;
			}
			if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				return false;
			}
			p_info->list.p_position++;
			has_semicolon = false;
			exp.release();
		}
		else if( p_info->list.p_position->s_word == "TAB(" ) {
			//	TAB(n) ‚Ìê‡
			p_info->list.p_position++;
			//	šT.B.D.
			has_semicolon = false;
			exp.release();
		}
		else if( p_info->list.p_position->s_word == "," ) {
			//	, ‚Ìê‡
			p_info->list.p_position++;
			//	šT.B.D.
			has_semicolon = false;
		}
		else if( p_info->list.p_position->s_word == "USING" ) {
			//	USING ‚Ìê‡
			p_info->list.p_position++;
			//	šT.B.D.
			has_semicolon = false;
		}
		else if( p_info->list.p_position->s_word == ";" ) {
			//	; ‚Ìê‡
			p_info->list.p_position++;
			has_semicolon = true;
		}
		else if( exp.compile( p_info, CEXPRESSION_TYPE::UNKNOWN ) ) {
			//	®‚Ìê‡
			switch( exp.get_type() ) {
			default:
			case CEXPRESSION_TYPE::INTEGER:
				//	šT.B.D.
				break;
			case CEXPRESSION_TYPE::SINGLE_REAL:
				//	šT.B.D.
				break;
			case CEXPRESSION_TYPE::DOUBLE_REAL:
				//	šT.B.D.
				break;
			case CEXPRESSION_TYPE::STRING:
				p_info->assembler_list.activate_puts();
				p_info->assembler_list.activate_free_string();
				asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "free_string", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			}
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return false;
		}
	}

	if( p_info->list.is_command_end() && !has_semicolon ) {
		//	ÅŒã‚Ì‰üs
		CSTRING value;
		static const char image[] = { 13, 10 };
		value.set( 2, image );
		std::string s_label = p_info->constants.add( value );
		p_info->assembler_list.activate_puts();
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "puts", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	if( p_info->list.p_position->s_word == "LPRINT" ) {
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_prtflg]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
