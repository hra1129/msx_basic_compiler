// --------------------------------------------------------------------
//	Compiler collection: Line
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "line.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  LINE [(SX,SY)]-[STEP](EX,EY),C [,{B|BF}]
bool CLINE::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp, exp_x, exp_y;
	bool has_step = false;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "LINE" ) {
		return false;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		//	LINE �����ŏI����Ă�ꍇ�� Syntax error.
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	p_info->assembler_list.add_label( "work_gxpos", "0x0FCB3" );
	p_info->assembler_list.add_label( "work_gypos", "0x0FCB5" );
	p_info->assembler_list.add_label( "bios_line", "0x058FC" );
	p_info->assembler_list.add_label( "bios_linebox", "0x058C1" );
	p_info->assembler_list.add_label( "bios_setatr", "0x0011A" );

	if( p_info->list.p_position->s_word == "(" ) {
		//	�n�_���W�̎w�肪����ꍇ
		//	(
		p_info->list.p_position++;
		//	X���W
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		//	,
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		//	Y���W
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		//	)
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
	}
	//	-
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "-" ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	STEP
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "STEP" ) {
		has_step = true;
		p_info->list.p_position++;
	}
	//	(
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	X���W
	exp_x.makeup_node( p_info );
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	Y���W
	exp_y.makeup_node( p_info );
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	,
	if( p_info->list.is_command_end() ) {
		//	LINE (x,y)-(x,y) �ŏI����Ă�ꍇ�B����`���B

		//	�F�͑O�i�F�ɂȂ�
		p_info->assembler_list.add_label( "work_forclr", "0x0F3E9" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[work_forclr]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_setatr", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );

		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_line", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	if( p_info->list.p_position->s_word != "," ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	//	�F
	if( p_info->list.p_position->s_word != "," ){
		//	�F�̎w�肪����
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_setatr", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			//	LINE (x,y)-(x,y),c �ŏI����Ă�ꍇ�B����`���B
			if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_line", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
	}
	//	,
	if( p_info->list.p_position->s_word != "," ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	B �܂��� BF
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word == "B" ) {
		//	B �̏ꍇ
		p_info->list.p_position++;
		//	LINE (x,y)-(x,y),c,b �ŏI����Ă�ꍇ�B�l�p��`���B
		p_info->errors.add( SYNTAX_ERROR, line_no );		//	���܂��Ή����ĂȂ�
		return true;
	}
	else if( p_info->list.p_position->s_word == "BF" ) {
		//	BF �̏ꍇ
		p_info->list.p_position++;
		//	LINE (x,y)-(x,y),c,bf �ŏI����Ă�ꍇ�B�h��Ԃ��l�p��`���B
		if( !exp_x.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		if( !exp_y.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_linebox", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gxpos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_gypos]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	//	�����W�J���I�y���[�V������ SCREEN5�ȏ�Ŏw��\
	p_info->errors.add( SYNTAX_ERROR, line_no );
	return true;
}
