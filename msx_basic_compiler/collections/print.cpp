// --------------------------------------------------------------------
//	Compiler collection: Print
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "print.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
bool CPRINT::exec_using( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int offset;
	bool has_parameter, is_semicolon;

	//	‘®•¶š—ñ
	p_info->assembler_list.add_label( "work_buf", "0x0f55e" );
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_buf]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return false;
	}
	offset = 2;
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_buf+2" );
	p_info->assembler_list.body.push_back( asm_line );
	//	‘®‚Æˆø”‚ÌŠÔ‚ÍƒZƒ~ƒRƒƒ“‚Ì‚İ
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ";" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return false;
	}
	p_info->list.p_position++;
	has_parameter = false;
	//	ˆø”
	for(;;) {
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( exp.compile( p_info, CEXPRESSION_TYPE::UNKNOWN ) ) {
			//	DE‚É‰‰ZŒ‹‰ÊAHL‚ÉBUF‚ÌŠi”[æ
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			//	Œ^‚É‰‚¶‚ÄŠi”[•û–@‚ªˆÙ‚È‚é
			switch( exp.get_type() ) {
			case CEXPRESSION_TYPE::INTEGER:
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "2" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "E" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "D" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 3;
				break;
			case CEXPRESSION_TYPE::STRING:
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "3" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "E" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "D" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 3;
				break;
			case CEXPRESSION_TYPE::SINGLE_REAL:
				p_info->assembler_list.activate_ld_de_single_real();
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "4" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_single_real", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 5;
				break;
			case CEXPRESSION_TYPE::DOUBLE_REAL:
				p_info->assembler_list.activate_ld_de_double_real();
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "8" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_double_real", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 9;
				break;
			default:
				p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
				return false;
			}
			has_parameter = true;
			exp.release();
		}
		else {
			if( !has_parameter ) {
				p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
				return false;
			}
		}
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->s_word != "," && p_info->list.p_position->s_word != ";" ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return false;
		}
		is_semicolon = (p_info->list.p_position->s_word == ";");
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			if( is_semicolon ) {
				p_info->list.p_position--;
			}
			break;
		}
	}
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "0" );
	p_info->assembler_list.body.push_back( asm_line );
	offset++;
	if( offset > 258 ) {
		//	ˆø”‚ª‘½‚·‚¬‚Ä BUF ‚ğˆì‚ê‚½ê‡
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
	}
	p_info->assembler_list.add_label( "blib_using", "0x0404b" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "blib_using" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}

// --------------------------------------------------------------------
//  PRINT
//	PRINT ® [[;|,] ® | TAB(n) | SPC(n) ]
bool CPRINT::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	bool has_semicolon;
	bool is_printer = false;
	std::string s_label;
	std::string s_label_crlf;
	static const char image[] = { 13, 10 };
	CSTRING value;

	if( p_info->list.p_position->s_word != "PRINT" && p_info->list.p_position->s_word != "LPRINT" ) {
		return false;
	}

	p_info->assembler_list.add_label( "work_prtflg", "0x0f416" );
	if( p_info->list.p_position->s_word == "LPRINT" ) {
		//	LPRINT ‚Ìê‡
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "1" );
		p_info->assembler_list.body.push_back( asm_line );
		is_printer = true;
	}
	else {
		//	PRINT ‚Ìê‡
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_prtflg]", COPERAND_TYPE::REGISTER, "A" );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->list.p_position++;
	p_info->assembler_list.activate_puts();

	value.set( 2, image );
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
			p_info->assembler_list.add_label( "blib_tab", "0x04048" );
			if( exp.compile( p_info ) ) {
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "blib_tab" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
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
		else if( p_info->list.p_position->s_word == "," ) {
			//	, ‚Ìê‡
			p_info->list.p_position++;
			p_info->assembler_list.activate_comma();
			p_info->assembler_list.add_label( "work_csrx", "0x0f3dd" );
			p_info->assembler_list.add_label( "work_clmlst", "0x0f3b2" );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "print_comma", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			has_semicolon = true;
		}
		else if( p_info->list.p_position->s_word == "USING" ) {
			//	USING ‚Ìê‡
			p_info->list.p_position++;
			if( !this->exec_using( p_info ) ) {
				//	ƒGƒ‰[‚¾‚Á‚½ê‡
				return true;			//	PRINT USING ‚Æ‚µ‚Äˆ—‚Í‚µ‚½‚Ì‚ÅAtrue
			}
			if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == ";" ) {
				p_info->list.p_position++;
				has_semicolon = true;
			}
			else {
				has_semicolon = false;
			}
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
				p_info->assembler_list.activate_str();
				p_info->assembler_list.add_label( "work_dac_int", "0x0f7f8" );
				p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
				p_info->assembler_list.add_label( "work_csrx", "0x0f3dd" );
				p_info->assembler_list.add_label( "work_linlen", "0x0f3b0" );
				s_label_crlf = p_info->constants.add( value );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_dac_int]", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_valtyp]", COPERAND_TYPE::REGISTER, "A" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "str", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_linlen]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_csrx]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
				p_info->assembler_list.body.push_back( asm_line );
				s_label = p_info->get_auto_label();
				asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label_crlf );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "32" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "0x18", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			case CEXPRESSION_TYPE::SINGLE_REAL:
				p_info->assembler_list.add_label( "work_csrx", "0x0f3dd" );
				p_info->assembler_list.add_label( "work_linlen", "0x0f3b0" );
				p_info->assembler_list.activate_str();
				p_info->assembler_list.activate_ld_dac_single_real();
				s_label_crlf = p_info->constants.add( value );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_single_real", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "str", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_linlen]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_csrx]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
				p_info->assembler_list.body.push_back( asm_line );
				s_label = p_info->get_auto_label();
				asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label_crlf );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "32" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "0x18", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			case CEXPRESSION_TYPE::DOUBLE_REAL:
				p_info->assembler_list.add_label( "work_csrx", "0x0f3dd" );
				p_info->assembler_list.add_label( "work_linlen", "0x0f3b0" );
				p_info->assembler_list.activate_str();
				p_info->assembler_list.activate_ld_dac_double_real();
				s_label_crlf = p_info->constants.add( value );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "ld_dac_double_real", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "str", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_linlen]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_csrx]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
				p_info->assembler_list.body.push_back( asm_line );
				s_label = p_info->get_auto_label();
				asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::C, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label_crlf );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "puts", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "32" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::RST, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "0x18", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			case CEXPRESSION_TYPE::STRING:
				p_info->assembler_list.activate_free_string();
				s_label_crlf = p_info->constants.add( value );
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
			has_semicolon = false;
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return false;
		}
	}

	if( p_info->list.is_command_end() && !has_semicolon ) {
		//	ÅŒã‚Ì‰üs
		s_label_crlf = p_info->constants.add( value );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, s_label_crlf );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "puts", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	if( is_printer ) {
		asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_prtflg]", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
