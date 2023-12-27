// --------------------------------------------------------------------
//	Compiler collection: FOr
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "for.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  FOR <変数> = <式1> TO <式2> [STEP <式3>]
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

	//	ループ用変数を生成する（ FOR I の I ）
	CVARIABLE variable_loop = p_info->p_compiler->get_variable_address_wo_array();
	if( variable_loop.type == CVARIABLE_TYPE::STRING ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	戻り位置、終端値、増分値の保持用
	variable_loopl.s_name = variable_loop.s_name + "_LABEL";
	variable_loope.s_name = variable_loop.s_name + "_FOR_END";
	variable_loops.s_name = variable_loop.s_name + "_FOR_STEP";
	variable_loopl = p_info->variable_manager.put_special_variable( p_info, variable_loopl.s_name, CVARIABLE_TYPE::INTEGER, variable_loop.type );
	variable_loope = p_info->variable_manager.put_special_variable( p_info, variable_loope.s_name, variable_loop.type );
	variable_loops = p_info->variable_manager.put_special_variable( p_info, variable_loops.s_name, variable_loop.type );
	//	代入処理
	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		// エラーは、check_word の中で登録される
		return true;
	}
	else if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	右辺の処理
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
	//	「TO 式」の処理
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
	//	「STEP 式」の処理
	asm_line.set( "LD", "", "HL", variable_loops.s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "PUSH", "", "HL", "" );
	p_info->assembler_list.body.push_back( asm_line );
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word != "STEP" ) {
			//	STEP以外は受け付けない
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
		//	省略されている場合 1 になる
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
	//	飛び先ラベル生成
	s_body = p_info->get_auto_label();
	s_next = p_info->get_auto_label();
	//	戻りアドレスの設定
	asm_line.set( "LD", "", "HL", s_next );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[" + variable_loopl.s_label + "]", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	//	BODYへジャンプ
	asm_line.set( "JR", "", s_body, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	NEXTの処理
	asm_line.set( "LABEL", "", s_next );
	p_info->assembler_list.body.push_back( asm_line );
	switch( variable_loop.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:
			//	<変数> = <変数> + <STEP>
			asm_line.set( "LD", "", "HL", "[" + variable_loop.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "[" + variable_loops.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "ADD", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[" + variable_loop.s_label + "]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<変数> と <終値> を比較
			s_skip_label = p_info->get_auto_label();
			asm_line.set( "LD", "", "A", "D" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "[" + variable_loope.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RLCA", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "C", s_skip_label, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> が正の場合
			s_pop = p_info->get_auto_label();
			asm_line.set( "RST", "", "0x20", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "C", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "Z", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "NC", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> が負の場合
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
			//	<変数> = <変数> + <STEP>
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
			//	<変数> と <終値> を比較
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
			//	<STEP> が正の場合
			s_pop = p_info->get_auto_label();
			asm_line.set( "CALL", "", "bios_fcomp", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "DEC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "NZ", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> が負の場合
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
			//	<変数> = <変数> + <STEP>
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
			//	<変数> と <終値> を比較
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
			//	<STEP> が正の場合
			s_pop = p_info->get_auto_label();
			asm_line.set( "CALL", "", "bios_xdcomp", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "DEC", "", "A", "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "JR", "NZ", s_pop, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "RET", "", "", "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	<STEP> が負の場合
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

	//	BODYのラベル
	asm_line.set( "LABEL", "", s_body, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	FOR文のループ変数を積んでおく
	p_info->for_variable_array.push_back( variable_loop );
	return true;
}
