// --------------------------------------------------------------------
//	Compiler collection: Let
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "let.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LET] {�ϐ���}[(�z��v�f, �z��v�f ...)] = ��
bool CLET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word == "LET" ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			//	LET �����ŏI����Ă�ꍇ�� Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		has_let = true;
	}
	
	if( p_info->list.p_position->s_word == "SPRITE" ) {
		//	SPRITE$(n)�ւ̑��
		p_info->list.p_position++;
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word != "$" ) {
			p_info->list.p_position--;		//	SPRITE ON ��������Ȃ�����A�G���[�͏o���Ȃ��B
			return false;
		}
		p_info->list.p_position++;
		if( !p_info->list.check_word( &(p_info->errors), "(" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			//	���ʂ̒��̎�
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( !p_info->list.check_word( &(p_info->errors), ")" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( !p_info->list.check_word( &(p_info->errors), "=" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
			p_info->assembler_list.add_label( "blib_setsprite", "0x04042" );
			//	������镶����
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "ix", COPERAND_TYPE::CONSTANT, "blib_setsprite" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		return true;
	}
	if( p_info->list.p_position->s_word == "TIME" ) {
		//	TIME�V�X�e���ϐ��ւ̑��
		p_info->list.p_position++;
		if( !p_info->list.check_word( &(p_info->errors), "=" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
			p_info->assembler_list.add_label( "work_jiffy", "0x0fc9e" );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_jiffy]", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		return true;
	}
	if( p_info->list.p_position->s_word == "VDP" ) {
		//	VDP�V�X�e���ϐ��ւ̑��
		p_info->list.p_position++;
		if( !p_info->list.check_word( &(p_info->errors), "(" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		if( !p_info->list.check_word( &(p_info->errors), ")" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( !p_info->list.check_word( &(p_info->errors), "=" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "L" );	//	���̕]�����ʂ� B ��
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );		//	���W�X�^�ԍ��� A ��
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		p_info->assembler_list.add_label( "blib_wrvdp", "0x04036" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::NONE, "blib_wrvdp" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		return true;
	}
	else if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	�ϐ����ł͖����̂� LET �ł͂Ȃ��B
		if( has_let ) {
			//	LET �����ŏI����Ă�ꍇ�� Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		return false;
	}
	//	�ϐ��𐶐�����
	CVARIABLE variable = p_info->p_compiler->get_variable_address();
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	�������
	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		// �G���[�́Acheck_word �̒��œo�^�����
	}
	else if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	}
	//	�E�ӂ̏���
	CEXPRESSION_TYPE exp_type;
	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		exp_type = CEXPRESSION_TYPE::INTEGER;		break;
	case CVARIABLE_TYPE::SINGLE_REAL:	exp_type = CEXPRESSION_TYPE::SINGLE_REAL;	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	exp_type = CEXPRESSION_TYPE::DOUBLE_REAL;	break;
	case CVARIABLE_TYPE::STRING:		exp_type = CEXPRESSION_TYPE::STRING;		break;
	}
	if( exp.compile( p_info, exp_type ) ) {
		p_info->p_compiler->write_variable_value( variable );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	}
	return true;
}
