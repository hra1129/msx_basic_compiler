// --------------------------------------------------------------------
//	Compiler collection: FOr
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "for.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  FOR <�ϐ�> = <��1> TO <��2> [STEP <��3>]
bool CFOR::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	std::string s_label;
	std::string s_body;
	std::string s_next;
	std::string s_skip_label;
	std::string s_pop;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable_loopl;
	CVARIABLE variable_loope;
	CVARIABLE variable_loops;

	if( p_info->list.p_position->s_word != "FOR" ) {
		return false;
	}
	p_info->list.p_position++;

	//	���[�v�p�ϐ��𐶐�����i FOR I �� I �j
	CVARIABLE variable_loop = p_info->p_compiler->get_variable_address_wo_array();
	if( variable_loop.type == CVARIABLE_TYPE::STRING ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	�߂�ʒu�A�I�[�l�A�����l�̕ێ��p
	variable_loopl.s_name = variable_loop.s_name + "_LABEL";
	variable_loope.s_name = variable_loop.s_name + "_FOR_END";
	variable_loops.s_name = variable_loop.s_name + "_FOR_STEP";
	variable_loopl = p_info->variable_manager.put_special_variable( p_info, variable_loopl.s_name, CVARIABLE_TYPE::INTEGER, variable_loop.type );
	variable_loope = p_info->variable_manager.put_special_variable( p_info, variable_loope.s_name, variable_loop.type );
	variable_loops = p_info->variable_manager.put_special_variable( p_info, variable_loops.s_name, variable_loop.type );
	//	�������
	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		// �G���[�́Acheck_word �̒��œo�^�����
		return true;
	}
	else if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	�E�ӂ̏���
	CEXPRESSION_TYPE exp_type;
	switch( variable_loop.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		exp_type = CEXPRESSION_TYPE::INTEGER;		break;
	case CVARIABLE_TYPE::SINGLE_REAL:	exp_type = CEXPRESSION_TYPE::SINGLE_REAL;	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	exp_type = CEXPRESSION_TYPE::DOUBLE_REAL;	break;
	}
	if( exp.compile( p_info, exp_type ) ) {
		p_info->p_compiler->write_variable_value( variable_loop );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	�uTO ���v�̏���
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TO" ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	p_info->list.p_position++;
	asm_line.set( "LD", "", "HL", variable_loope.s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	if( exp.compile( p_info, exp_type ) ) {
		p_info->p_compiler->write_variable_value( variable_loope );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	�uSTEP ���v�̏���
	asm_line.set( "LD", "", "HL", variable_loops.s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word != "STEP" ) {
			//	STEP�ȊO�͎󂯕t���Ȃ�
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;
		if( exp.compile( p_info, exp_type ) ) {
			p_info->p_compiler->write_variable_value( variable_loops );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
	}
	else {
		//	�ȗ�����Ă���ꍇ 1 �ɂȂ�
		switch( variable_loop.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:
			{
				asm_line.set( "LD", "", "HL", "1" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			break;
		case CVARIABLE_TYPE::SINGLE_REAL:
			{
				CSINGLE_REAL value;
				value.set( "1" );
				s_label = p_info->constants.add( value );

				asm_line.set( "LD", "", "HL", s_label );
				p_info->assembler_list.body.push_back( asm_line );
			}
			break;
		case CVARIABLE_TYPE::DOUBLE_REAL:
			{
				CDOUBLE_REAL value;
				value.set( "1" );
				s_label = p_info->constants.add( value );

				asm_line.set( "LD", "", "HL", s_label );
				p_info->assembler_list.body.push_back( asm_line );
			}
			break;
		}
		p_info->p_compiler->write_variable_value( variable_loops );
	}
	//	��ѐ惉�x������
	s_body = p_info->get_auto_label();
	s_next = p_info->get_auto_label();
	//	�߂�A�h���X�̐ݒ�
	asm_line.set( "LD", "", "HL", s_next );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[" + variable_loopl.s_label + "]", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	//	BODY�փW�����v
	asm_line.set( "JR", "", s_body, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	NEXT�̏���
	asm_line.set( "LABEL", "", s_next );
	p_info->assembler_list.body.push_back( asm_line );
	switch( variable_loop.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:
			//	<�ϐ�> = <�ϐ�> + <STEP>
			asm_line.set( "LD", "", "HL", "[" + variable_loop.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "[" + variable_loops.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "ADD", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[" + variable_loop.s_label + "]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<�ϐ�> �� <�I�l> ���r
			s_skip_label = p_info->get_auto_label();
			asm_line.set( "LD", "", "A", "D" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "[" + variable_loope.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RLCA", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "C", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> �����̏ꍇ
			s_pop = p_info->get_auto_label();
			asm_line.set( "RST", "", "0x20", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "C", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "Z", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "NC", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> �����̏ꍇ
			asm_line.set( "LABEL", "", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RST", "", "0x20", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "C", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LABEL", "", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL", "" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::SINGLE_REAL:
			//	<�ϐ�> = <�ϐ�> + <STEP>
			p_info->assembler_list.add_label( "bios_decadd", "0x0269a" );
			p_info->assembler_list.add_label( "bios_vmovfm", "0x02f08" );
			p_info->assembler_list.add_label( "bios_vmovam", "0x02eef" );
			p_info->assembler_list.add_label( "bios_fcomp", "0x02f21" );
			p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
			p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
			asm_line.set( "LD", "", "A", "4" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_valtyp]", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", variable_loop.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_vmovfm", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", variable_loops.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_vmovam", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_decadd", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", variable_loop.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "BC", "4" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LDIR", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<�ϐ�> �� <�I�l> ���r
			s_skip_label = p_info->get_auto_label();
			asm_line.set( "LD", "", "BC", "[" + variable_loope.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "[" + variable_loope.s_label + " + 2]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "A", "[" + variable_loops.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RLCA", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "C", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> �����̏ꍇ
			s_pop = p_info->get_auto_label();
			asm_line.set( "CALL", "", "bios_fcomp", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "DEC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "NZ", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> �����̏ꍇ
			asm_line.set( "LABEL", "", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_fcomp", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "Z", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LABEL", "", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL", "" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::DOUBLE_REAL:
			//	<�ϐ�> = <�ϐ�> + <STEP>
			p_info->assembler_list.add_label( "bios_decadd", "0x0269a" );
			p_info->assembler_list.add_label( "bios_vmovfm", "0x02f08" );
			p_info->assembler_list.add_label( "bios_vmovam", "0x02eef" );
			p_info->assembler_list.add_label( "bios_xdcomp", "0x02f5c" );
			p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
			p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
			asm_line.set( "LD", "", "A", "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_valtyp]", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", variable_loop.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_vmovfm", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", variable_loops.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_vmovam", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_decadd", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", "work_dac" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", variable_loop.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "BC", "8" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LDIR", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<�ϐ�> �� <�I�l> ���r
			s_skip_label = p_info->get_auto_label();
			asm_line.set( "LD", "", "HL", variable_loope.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_vmovam", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "A", "[" + variable_loops.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RLCA", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "C", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> �����̏ꍇ
			s_pop = p_info->get_auto_label();
			asm_line.set( "CALL", "", "bios_xdcomp", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "DEC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "NZ", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> �����̏ꍇ
			asm_line.set( "LABEL", "", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "bios_xdcomp", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "Z", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LABEL", "", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL", "" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
	}

	//	BODY�̃��x��
	asm_line.set( "LABEL", "", s_body, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	FOR���̃��[�v�ϐ���ς�ł���
	p_info->for_variable_array.push_back( variable_loop );
	return true;
}
