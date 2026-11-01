// --------------------------------------------------------------------
//	Compiler collection: Let
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "let.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  [LET] {変数名}[(配列要素, 配列要素 ...)] = 式
bool CLET::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word == "LET" ) {
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			//	LET だけで終わってる場合は Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		has_let = true;
	}
	
	if( p_info->list.p_position->s_word == "SPRITE" ) {
		//	SPRITE$(n)への代入
		p_info->list.p_position++;
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word != "$" ) {
			p_info->list.p_position--;		//	SPRITE ON かもしれないから、エラーは出さない。
			return false;
		}
		p_info->list.p_position++;
		if( !p_info->list.check_word( &(p_info->errors), "(" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( exp.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
			//	括弧の中の式
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
			p_info->assembler_list.activate_free_string();
			p_info->assembler_list.activate_copy_string_to_buffer();
			//	代入する文字列
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", "legacy_string_buffer" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "copy_string_to_buffer" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "ix", COPERAND_TYPE::CONSTANT, "blib_setsprite" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "free_string" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		return true;
	}
	if( p_info->list.p_position->s_word == "TIME" ) {
		//	TIMEシステム変数への代入
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
		//	VDPシステム変数への代入
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
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "L" );	//	式の評価結果を B へ
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );		//	レジスタ番号を A へ
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
	if( p_info->list.p_position->s_word == "MAXFILES" ) {
		p_info->use_file_access = true;
		//	ファイルの上限数を設定
		p_info->list.p_position++;
		if( !p_info->list.check_word( &(p_info->errors), "=" ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->assembler_list.activate_maxfiles();
		if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
			asm_line.set( "CALL", "", "sub_maxfiles" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
		}
		return true;
	}
	else if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		//	変数名では無いので LET ではない。
		if( has_let ) {
			//	LET だけで終わってる場合は Syntax error.
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		return false;
	}
	//	変数の情報を取得する
	//	[B4] 直接ストアの可否が決まるまで、アドレス計算のコードは生成しない。
	//	(従来は get_variable_address() でこの時点でコードを生成していた)
	std::vector< CEXPRESSION* > dest_exp_list;
	CVARIABLE variable = p_info->variable_manager.get_variable_info( p_info, dest_exp_list );
	//	代入処理
	bool is_valid = true;
	if( !p_info->list.check_word( &(p_info->errors), "=", SYNTAX_ERROR ) ) {
		// エラーは、check_word の中で登録される
		is_valid = false;
	}
	else if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		is_valid = false;
	}
	//	右辺の処理
	CEXPRESSION_TYPE exp_type;
	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		exp_type = CEXPRESSION_TYPE::INTEGER;		break;
	case CVARIABLE_TYPE::SINGLE_REAL:	exp_type = CEXPRESSION_TYPE::SINGLE_REAL;	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	exp_type = CEXPRESSION_TYPE::DOUBLE_REAL;	break;
	case CVARIABLE_TYPE::STRING:		exp_type = CEXPRESSION_TYPE::STRING;		break;
	}
	//	[B4] 右辺を先に構文解析し、代入先が通常の数値変数で右辺が
	//	純粋な式なら、アドレスを PUSH しない直接ストアにする。
	//	それ以外は従来形 (アドレスを PUSH して評価後に間接ストア)。
	bool is_parsed = false;
	bool use_direct = false;
	if( is_valid ) {
		exp.makeup_node( p_info );
		if( exp.get_top_node() != nullptr ) {
			is_parsed = true;
			if( variable.dimension == 0
				&& variable.type != CVARIABLE_TYPE::STRING
				&& variable.type != CVARIABLE_TYPE::UNKNOWN
				&& exp.get_top_node()->is_pure() ) {
				use_direct = true;
			}
		}
	}
	if( use_direct ) {
		//	直接形: 右辺を評価し、結果をそのまま代入先へ書き込む
		if( exp.compile( p_info, exp_type ) ) {
			p_info->p_compiler->write_variable_value_direct( variable );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		}
		return true;
	}
	if( is_valid && !is_parsed ) {
		//	右辺が解釈できなかった場合は従来通り Syntax error
		//	(従来は exp.compile() が false を返して同じエラーになっていた)
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return true;
	}
	//	従来形: 代入先アドレスを生成して PUSH し、右辺評価後に間接ストアする
	//	(get_variable_address() と同じコード生成をここで行う)
	if( variable.dimension == 0 ) {
		//	単独変数の場合
		asm_line.set( "LD", "", "HL", variable.s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		//	配列変数の場合
		p_info->variable_manager.compile_array_elements( p_info, dest_exp_list, variable );
	}
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	if( exp.compile( p_info, exp_type ) ) {
		p_info->p_compiler->write_variable_value( variable );
		exp.release();
	}
	else {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
	}
	return true;
}
