// --------------------------------------------------------------------
//	Compiler collection: Print
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "print.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
bool CPRINT::exec_using( CCOMPILE_INFO *p_info, bool is_file ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int offset;
	bool has_parameter, is_semicolon;

	//	����������
	p_info->assembler_list.add_label( "work_buf", "0x0f55e" );
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		asm_line.set( "LD", "", "[work_buf]",  "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return false;
	}
	offset = 2;
	asm_line.set( "LD", "", "HL", "work_buf+2" );
	p_info->assembler_list.body.push_back( asm_line );
	//	�����ƈ����̊Ԃ̓Z�~�R�����̂�
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ";" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return false;
	}
	p_info->list.p_position++;
	has_parameter = false;
	//	����
	for(;;) {
		asm_line.set( "PUSH", "", "HL",  "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( exp.compile( p_info, CEXPRESSION_TYPE::UNKNOWN ) ) {
			//	DE�ɉ��Z���ʁAHL��BUF�̊i�[��
			asm_line.set( "POP", "", "DE",  "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "EX", "", "DE",  "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			//	�^�ɉ����Ċi�[���@���قȂ�
			switch( exp.get_type() ) {
			case CEXPRESSION_TYPE::INTEGER:
				asm_line.set( "LD", "", "[HL]", "2" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[HL]", "E" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[HL]", "D" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 3;
				break;
			case CEXPRESSION_TYPE::STRING:
				asm_line.set( "LD", "", "[HL]", "3" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[HL]", "E" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[HL]", "D" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 3;
				break;
			case CEXPRESSION_TYPE::SINGLE_REAL:
				p_info->assembler_list.activate_ld_de_single_real();
				asm_line.set( "LD", "", "[HL]", "4" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "EX", "", "DE",  "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "ld_de_single_real",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "EX", "", "DE",  "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				offset += 5;
				break;
			case CEXPRESSION_TYPE::DOUBLE_REAL:
				p_info->assembler_list.activate_ld_de_double_real();
				asm_line.set( "LD", "", "[HL]", "8" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "INC", "", "HL",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "EX", "", "DE",  "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "ld_de_double_real",  "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "EX", "", "DE",  "HL" );
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
	asm_line.set( "LD", "", "[HL]", "0" );
	p_info->assembler_list.body.push_back( asm_line );
	offset++;
	if( offset > 258 ) {
		//	�������������� BUF ����ꂽ�ꍇ
		p_info->errors.add( ILLEGAL_FUNCTION_CALL, p_info->list.get_line_no() );
	}
	p_info->assembler_list.add_label( "blib_using", "0x0404b" );
	asm_line.set( "LD", "", "IX", "blib_using" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "","call_blib",  "" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}

// --------------------------------------------------------------------
//  PRINT
//	PRINT �� [[;|,] �� | TAB(n) | SPC(n) ]
bool CPRINT::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	bool has_semicolon;
	bool is_printer = false;
	std::string s_label;
	std::string s_label_crlf;
	bool is_file = false;

	if( p_info->list.p_position->s_word != "?" && p_info->list.p_position->s_word != "PRINT" && p_info->list.p_position->s_word != "LPRINT" ) {
		return false;
	}

	p_info->assembler_list.add_label( "blib_file_puts", "0x040ed" );
	p_info->assembler_list.add_label( "work_prtflg", "0x0f416" );
	if( p_info->list.p_position->s_word == "LPRINT" ) {
		//	LPRINT �̏ꍇ
		asm_line.set( "LD", "", "A", "1" );
		p_info->assembler_list.body.push_back( asm_line );
		is_printer = true;
	}
	else {
		//	PRINT �̏ꍇ
		asm_line.set( "XOR", "", "A",  "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	asm_line.set( "LD", "", "[work_prtflg]",  "A" );
	p_info->assembler_list.body.push_back( asm_line );

	p_info->list.p_position++;

	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "#" ) {
		if( is_printer ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return false;
		}
		//	�t�@�C���ԍ��̏���
		is_file = true;
		p_info->list.p_position++;
		if( !exp.compile( p_info ) ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return false;
		}
		p_info->assembler_list.activate_file_number();
		p_info->use_file_access = true;
		asm_line.set( "CALL", "", "sub_file_number" );			//	PTRFIL (F864h) �� FILE_INFO �̃A�h���X���i�[�A�͈͊O�Ȃ� bad file number �̃G���[
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();

		if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::SYMBOL || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return false;
		}
		p_info->list.p_position++;
	}
	else {
		asm_line.set( "LD", "", "H", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "L", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_ptrfil]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	has_semicolon = false;
	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "SPC(" ) {
			//	SPC(n) �̏ꍇ
			p_info->list.p_position++;
			p_info->assembler_list.add_label( "blib_spc", "0x040f0" );
			if( exp.compile( p_info ) ) {
				if( is_file ) {
					asm_line.set( "LD", "", "DE", "[work_ptrfil]" );
					p_info->assembler_list.body.push_back( asm_line );
					asm_line.set( "LD", "", "A", "[DE]" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				else {
					asm_line.set( "XOR", "", "A", "A" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				asm_line.set( "LD", "", "IX", "blib_spc" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "","call_blib",  "" );
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
			//	TAB(n) �̏ꍇ
			p_info->list.p_position++;
			p_info->assembler_list.add_label( "blib_tab", "0x04048" );
			exp.makeup_node( p_info );
			if( is_file ) {
				//	�t�@�C���̏ꍇ�A�����o���Ȃ��̂� TAB() �Ăяo�����o���Ȃ�
			}
			else {
				exp.compile( p_info );
				asm_line.set( "XOR", "", "A", "A" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "IX", "blib_tab" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "","call_blib",  "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				return false;
			}
			p_info->list.p_position++;
			has_semicolon = false;
			exp.release();
		}
		else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::SYMBOL && p_info->list.p_position->s_word == "," ) {
			//	, �̏ꍇ
			p_info->list.p_position++;
			p_info->assembler_list.add_label( "blib_comma", "0x040f3" );
			p_info->assembler_list.add_label( "work_csrx", "0x0f3dd" );
			p_info->assembler_list.add_label( "work_clmlst", "0x0f3b2" );
			if( is_file ) {
				asm_line.set( "LD", "", "DE", "[work_ptrfil]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "A", "[DE]" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				asm_line.set( "XOR", "", "A", "A" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			asm_line.set( "LD", "", "IX", "blib_comma" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "","call_blib",  "" );
			p_info->assembler_list.body.push_back( asm_line );
			has_semicolon = true;
		}
		else if( p_info->list.p_position->s_word == "USING" ) {
			//	USING �̏ꍇ
			p_info->list.p_position++;
			if( !this->exec_using( p_info, is_file ) ) {
				//	�G���[�������ꍇ
				return true;			//	PRINT USING �Ƃ��ď����͂����̂ŁAtrue
			}
			if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == ";" ) {
				p_info->list.p_position++;
				has_semicolon = true;
			}
			else {
				has_semicolon = false;
			}
		}
		else if( p_info->list.p_position->type == CBASIC_WORD_TYPE::SYMBOL && p_info->list.p_position->s_word == ";" ) {
			//	; �̏ꍇ
			p_info->list.p_position++;
			has_semicolon = true;
		}
		else if( exp.compile( p_info, CEXPRESSION_TYPE::UNKNOWN ) ) {
			//	���̏ꍇ
			switch( exp.get_type() ) {
			default:
			case CEXPRESSION_TYPE::INTEGER:
				p_info->assembler_list.activate_put_integer( p_info );
				asm_line.set( "CALL", "", "put_integer" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			case CEXPRESSION_TYPE::SINGLE_REAL:
				p_info->assembler_list.activate_put_single_real( p_info );
				asm_line.set( "CALL", "", "put_single_real" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			case CEXPRESSION_TYPE::DOUBLE_REAL:
				p_info->assembler_list.activate_put_double_real( p_info );
				asm_line.set( "CALL", "", "put_double_real" );
				p_info->assembler_list.body.push_back( asm_line );
				break;
			case CEXPRESSION_TYPE::STRING:
				asm_line.set( "PUSH", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				if( is_file ) {
					p_info->assembler_list.activate_put_string( p_info );
					asm_line.set( "CALL", "", "put_string" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				else {
					p_info->assembler_list.activate_puts();
					asm_line.set( "CALL", "", "puts" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "free_string" );
				p_info->assembler_list.body.push_back( asm_line );
				p_info->assembler_list.activate_free_string();
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
		static const char image[] = { 13, 10 };
		CSTRING value;
		value.set( 2, image );

		//	�Ō�̉��s
		s_label_crlf = p_info->constants.add( value );
		asm_line.set( "LD", "", "HL", s_label_crlf );
		p_info->assembler_list.body.push_back( asm_line );
		if( is_file ) {
			asm_line.set( "LD", "", "IX", "blib_file_puts" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "","call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			p_info->assembler_list.activate_puts();
			asm_line.set( "CALL", "","puts" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}

	if( is_printer ) {
		asm_line.set( "XOR", "", "A",  "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_prtflg]",  "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	if( is_file ) {
		asm_line.set( "LD", "", "HL",  "0" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_ptrfil]",  "HL" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	return true;
}
