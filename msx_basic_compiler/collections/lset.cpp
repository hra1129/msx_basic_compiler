// --------------------------------------------------------------------
//	Compiler collection: Lset
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "lset.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LSET] {�ϐ���}[(�z��v�f, �z��v�f ...)] = ��
bool CLSET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool is_rset = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word != "LSET" && p_info->list.p_position->s_word != "RSET" ) {
		return false;
	}
	is_rset = ( p_info->list.p_position->s_word == "RSET" );
	p_info->list.p_position++;
	
	//	�ϐ��𐶐�����
	CVARIABLE variable = p_info->p_compiler->get_variable_address();
	p_info->assembler_list.activate_allocate_string();
	p_info->assembler_list.activate_free_string();
	asm_line.set( "PUSH", "", "HL", "" );					//	HL = �ϐ��̃A�h���X
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "E", "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "[HL]" );					//	DE = ���̕�����
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "A", "[DE]" );					//	A = ���̕�����̒���
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "AF", "" );					//	���̕�����̒�����ۑ�
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );					//	HL = ���̕�����
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string", "" );			//	���̕���������
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "AF", "" );					//	���̕�����̒����𕜋A
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "allocate_string", "" );		//	HL = ���ʂ̊i�[����m��
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "DE", "" );					//	DE = �ϐ��̃A�h���X
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );					//	HL = �ϐ��̃A�h���X, DE = ���ʂ̊i�[��
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );					//	HL = �ϐ��̃A�h���X
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "E" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "INC", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[HL]", "D" );					//	�ϐ��Ɍ��ʂ̊i�[���ۑ�
	p_info->assembler_list.body.push_back( asm_line );

	//	= �̃`�F�b�N
	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		// �G���[�́Acheck_word �̒��œo�^�����
		return true;
	}
	else if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	�E�ӂ̏���
	if( variable.type != CVARIABLE_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return true;
	}
	if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}

	asm_line.set( "POP", "", "DE", "" );				//	DE = �ϐ��̃A�h���X
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "EX", "", "DE", "HL" );			//	HL = �ϐ��̃A�h���X, DE = �E��
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "DE", "" );				//	�E�ӕۑ�
	p_info->assembler_list.body.push_back( asm_line );

	if( is_rset ) {
		p_info->assembler_list.add_label( "blib_rset", "0x04078" );
		asm_line.set( "LD", "", "IX", "blib_rset" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib", "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->assembler_list.add_label( "blib_lset", "0x04075" );
		asm_line.set( "LD", "", "IX", "blib_lset" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "CALL", "", "call_blib", "" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	asm_line.set( "POP", "", "HL", "" );				//	�E�ӕ��A
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string", "" );		//	���̕���������
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
