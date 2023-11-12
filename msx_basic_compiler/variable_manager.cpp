// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include "variable_manager.h"
#include "compile_info.h"
#include "expressions/expression.h"
#include <algorithm>

// --------------------------------------------------------------------
void CVARIABLE_MANAGER::skip_statement( CCOMPILE_INFO *p_info ) {

	p_info->list.update_current_line_no();
	while( !p_info->list.is_line_end() ) {
		if( p_info->list.p_position->s_word == "THEN" || p_info->list.p_position->s_word == "ELSE" || p_info->list.p_position->s_word == ":" ) {
			p_info->list.p_position++;
			break;
		}
		p_info->list.p_position++;
	}
}

// --------------------------------------------------------------------
void CVARIABLE_MANAGER::update( CCOMPILE_INFO *p_info, CVARIABLE_TYPE new_type ) {
	char start_char, end_char;
	std::string s_def = p_info->list.p_position->s_word;
	int i;

	p_info->list.update_current_line_no();
	p_info->list.p_position++;
	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word.size() != 1 ) {
			//	DEFINT AA のような、2文字以上の指定だった場合はエラー
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			this->skip_statement( p_info );
			return;
		}
		if( !isalpha( p_info->list.p_position->s_word[0] & 255 ) ) {
			//	DEFINT 1 のような、アルファベット以外の指定の場合はエラー
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			this->skip_statement( p_info );
			return;
		}
		start_char = toupper( p_info->list.p_position->s_word[0] & 255 );
		end_char = start_char;
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word == "," ) {
			//	DEFINT A のような単独指定の場合
		}
		else if( p_info->list.p_position->s_word == "-" ) {
			//	DEFINT A-Z のような範囲指定の場青
			p_info->list.p_position++;
			if( p_info->list.is_command_end() || p_info->list.p_position->s_word.size() != 1 || !isalpha( p_info->list.p_position->s_word[0] & 255 ) ) {
				//	DEFINT A- や DEFINT A-AA や DEFINT A-9 のような不正な記述の場合はエラー
				p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
				this->skip_statement( p_info );
				return;
			}
			end_char = toupper( p_info->list.p_position->s_word[0] & 255 );
			p_info->list.p_position++;
		}
		//	範囲をチェック
		if( start_char > end_char ) {
			//	DEFINT Z-A のような逆巡指定の場合はエラー
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			return;
		}
		//	範囲を登録
		for( i = start_char; i <= end_char; i++ ) {
			p_info->variables.def_types[ i - 'A' ] = new_type;
		}
		//	次の範囲指定の , は読み飛ばす
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
			p_info->list.p_position++;
		}
	}
}

// --------------------------------------------------------------------
//	DEFINT, DEFSNG, DEFDBL, DEFSTR を調べて型識別子無しの変数が
//	どの型になるかを確定させる
bool CVARIABLE_MANAGER::analyze_defvars( CCOMPILE_INFO *p_info ) {

	while( !p_info->list.is_end() ) {
		if( p_info->list.p_position->s_word == "DEFINT" ) {
			this->update( p_info, CVARIABLE_TYPE::INTEGER );
		}
		else if( p_info->list.p_position->s_word == "DEFSNG" ) {
			this->update( p_info, CVARIABLE_TYPE::SINGLE_REAL );
		}
		else if( p_info->list.p_position->s_word == "DEFDBL" ) {
			this->update( p_info, CVARIABLE_TYPE::DOUBLE_REAL );
		}
		else if( p_info->list.p_position->s_word == "DEFSTR" ) {
			this->update( p_info, CVARIABLE_TYPE::STRING );
		}
		else {
			this->skip_statement( p_info );
		}
	}
	return true;
}

// --------------------------------------------------------------------
//	{変数名}[%|!|#|$][(...)]
CVARIABLE CVARIABLE_MANAGER::add_variable( CCOMPILE_INFO *p_info ) {
	CVARIABLE variable;
	std::string s_name;
	int line_no;
	int dimensions = 0;

	line_no = p_info->list.p_position->line_no;
	//	変数名を取得する
	s_name = p_info->list.p_position->s_word;
	transform( s_name.begin(), s_name.end(), s_name.begin(), ::toupper );
	p_info->list.p_position++;
	//	3文字以上の場合、2文字に切り詰める
	if( s_name.size() > 2 ) {
		s_name = std::string( "" ) + s_name[0] + s_name[1];
	}
	//	型識別子の存在を調べる
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "%" ) {
		variable.type = CVARIABLE_TYPE::INTEGER;
		s_name = s_name + "%";
		p_info->list.p_position++;
	}
	else if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "!" ) {
		variable.type = CVARIABLE_TYPE::SINGLE_REAL;
		s_name = s_name + "!";
		p_info->list.p_position++;
	}
	else if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "#" ) {
		variable.type = CVARIABLE_TYPE::DOUBLE_REAL;
		s_name = s_name + "#";
		p_info->list.p_position++;
	}
	else if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "$" ) {
		variable.type = CVARIABLE_TYPE::STRING;
		s_name = s_name + "$";
		p_info->list.p_position++;
	}
	else {
		//	型識別子が省略されている場合は、DEFxxx の指定に従う
		variable.type = p_info->variables.def_types[ s_name[0] ];
		switch( variable.type ) {
		default:
		case CVARIABLE_TYPE::INTEGER:		s_name = s_name + "%"; break;
		case CVARIABLE_TYPE::SINGLE_REAL:	s_name = s_name + "!"; break;
		case CVARIABLE_TYPE::DOUBLE_REAL:	s_name = s_name + "#"; break;
		case CVARIABLE_TYPE::STRING:		s_name = s_name + "$"; break;
		}
	}
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return variable;
	}
	//	配列か？
	if( p_info->list.p_position->s_word == "(" ) {
		s_name = s_name + "(";
		variable.dimension = this->evaluate_dimensions( p_info );		//	要素番号をスタックに積む
		dimensions = variable.dimension;
	}

	variable.s_name = s_name;
	if( p_info->variables.dictionary.count( s_name ) ) {
		//	既に認知している変数の場合、配列の次元数をチェック
		variable = p_info->variables.dictionary[ s_name ];
		if( dimensions != variable.dimension ) {
			p_info->errors.add( REDIMENSIONED_ARRAY, line_no );
			return variable;
		}
	}
	else {
		//	初めて登場する変数の場合、辞書に登録して認知
		p_info->variables.dictionary[ s_name ] = variable;
	}
	return variable;
}

// --------------------------------------------------------------------
//	配列の要素に指定されている式を評価してスタックに積む
int CVARIABLE_MANAGER::evaluate_dimensions( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	int dimension = 0;

	std::vector< CBASIC_WORD >::const_iterator p_position = p_info->list.p_position;
	for( ;; ) {
		exp.makeup_node( p_info );
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->s_word == ")" || p_info->list.p_position->s_word == "]" ) {
			p_info->list.p_position++;
			break;
		}
		if( p_info->list.p_position->s_word != "," ) {
			break;
		}
		p_info->list.p_position++;
		dimension++;
		exp.release();
	}
	p_info->list.p_position = p_position;

	return dimension;
}

//	現在の参照位置の配列変数の情報を返す
CVARIABLE CVARIABLE_MANAGER::get_array_info( class CCOMPILE_INFO *p_info ) {
	std::string s_name;
	std::string s_label;
	CVARIABLE_TYPE var_type;
	CVARIABLE variable;

	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		return variable;
	}
	//	変数名を取得
	s_name = p_info->list.p_position->s_word;
	transform( s_name.begin(), s_name.end(), s_name.begin(), ::toupper );
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	変数名最大 2文字制限
		s_name.resize( 2 );
	}
	//	型識別子
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "%" ) {
			var_type = CVARIABLE_TYPE::INTEGER;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "!" ) {
			var_type = CVARIABLE_TYPE::SINGLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "#" ) {
			var_type = CVARIABLE_TYPE::DOUBLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "$" ) {
			var_type = CVARIABLE_TYPE::STRING;
			p_info->list.p_position++;
		}
		else {
			var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
		}
	}
	else {
		var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
	}
	//	変数ラベルを生成
	switch( var_type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		s_label = "varia";	break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "varfa";	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "varda";	break;
	case CVARIABLE_TYPE::STRING:		s_label = "varsa";	break;
	}
	s_label = s_label + "_" + s_name;
	//	変数を登録する
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( p_info->variables.dictionary.count( s_label ) == 0 ) {
		p_info->variables.dictionary[ s_label ] = variable;
	}
	else {
		variable = p_info->variables.dictionary[ s_label ];
	}
	return variable;
}

// --------------------------------------------------------------------
CVARIABLE CVARIABLE_MANAGER::get_variable_info( class CCOMPILE_INFO *p_info, std::vector< CEXPRESSION* > &exp_list, bool with_array ) {
	std::string s_name;
	std::string s_label;
	CVARIABLE_TYPE var_type;
	CVARIABLE variable;
	bool is_array = false;
	int dimension = 0;
	CEXPRESSION *p_exp;

	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		return variable;
	}
	//	変数名を取得
	s_name = p_info->list.p_position->s_word;
	transform( s_name.begin(), s_name.end(), s_name.begin(), ::toupper );
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	変数名最大 2文字制限
		s_name.resize( 2 );
	}
	//	型識別子
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "%" ) {
			var_type = CVARIABLE_TYPE::INTEGER;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "!" ) {
			var_type = CVARIABLE_TYPE::SINGLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "#" ) {
			var_type = CVARIABLE_TYPE::DOUBLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "$" ) {
			var_type = CVARIABLE_TYPE::STRING;
			p_info->list.p_position++;
		}
		else {
			var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
		}
	}
	else {
		var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
	}
	if( with_array ) {
		//	配列変数か？
		if( !p_info->list.is_command_end() ) {
			if( p_info->list.p_position->s_word == "(" || p_info->list.p_position->s_word == "[" ) {
				//	配列変数の場合
				is_array = true;
				p_info->list.p_position++;
			}
		}
	}
	//	変数ラベルを生成
	switch( var_type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		s_label = "vari"; break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "varf"; break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "vard"; break;
	case CVARIABLE_TYPE::STRING:		s_label = "vars"; break;
	}
	if( is_array ) {
		s_label = s_label + "a";
	}
	s_label = s_label + "_" + s_name;
	//	変数を登録する
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( is_array ) {
		//	配列の要素数を調べる
		std::vector< CBASIC_WORD >::const_iterator p_position = p_info->list.p_position;
		for(;;) {
			//	式を評価
			p_exp = new CEXPRESSION();
			p_exp->makeup_node( p_info );
			exp_list.push_back( p_exp );
			p_exp = nullptr;
			//	次元数更新
			dimension++;
			//	エラーチェックと終了判定
			if( p_info->list.is_command_end() ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				break;
			}
			if( p_info->list.p_position->s_word == ")" || p_info->list.p_position->s_word == "]" ) {
				//	以降、式が無ければ抜ける
				p_info->list.p_position++;
				break;
			}
			if( p_info->list.p_position->s_word != "," ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				break;
			}
			p_info->list.p_position++;
		}
	}
	if( p_info->variables.dictionary.count( s_label ) == 0 ) {
		variable.dimension = dimension;
		p_info->variables.dictionary[ s_label ] = variable;
	}
	else {
		variable = p_info->variables.dictionary[ s_label ];
		if( variable.dimension != dimension ) {
			p_info->errors.add( SUBSCRIPT_OUT_OF_RANGE, p_info->list.get_line_no() );
		}
	}
	return variable;
}

// --------------------------------------------------------------------
void CVARIABLE_MANAGER::compile_array_elements( class CCOMPILE_INFO *p_info, std::vector< class CEXPRESSION* > &exp_list, CVARIABLE &variable ) {
	CASSEMBLER_LINE asm_line;
	int i, area_size; 
	int element_size = 2;

	//	あとで「自動確保」の際のメモリサイズを計算するために必要になる「要素のサイズ」を計算
	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		element_size = 2; break;
	case CVARIABLE_TYPE::SINGLE_REAL:	element_size = 4; break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	element_size = 8; break;
	case CVARIABLE_TYPE::STRING:		element_size = 2; break;
	}
	//	自動確保配列だった場合の必要なメモリ数を計算する
	area_size = element_size * 11;
	for( i = 1; i < variable.dimension; i++ ) {
		area_size *= 11;
	}
	//	配列実体アドレスが NULL なら、配列変数の自動確保を実施
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, variable.s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::CONSTANT, std::to_string( variable.dimension ) );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, std::to_string( 2 + 1 + variable.dimension * 2 + area_size ) );
	p_info->assembler_list.body.push_back( asm_line );
	if( variable.type == CVARIABLE_TYPE::STRING ) {
		p_info->assembler_list.activate_check_sarray( &(p_info->constants) );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_sarray", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else {
		p_info->assembler_list.activate_check_array();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_array", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	配列変数の要素の先頭アドレスを求め、かつ要素数をスタックに積む
	p_info->assembler_list.activate_calc_array_top();
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "calc_array_top", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.add_label( "bios_umult", "0x0314a" );
	for( i = variable.dimension - 1; i >= 0; i-- ) {
		//	要素 i を計算する
		exp_list[i]->compile( p_info, CEXPRESSION_TYPE::INTEGER );
		if( i < variable.dimension - 1 ) {
			// 最後の演算結果を取り出す ( Z * y_max )
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	要素 i の演算結果と加算する
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( i == 0 ) {
			//	要素１つ分のサイズに合わせて、2倍・4倍・8倍する
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			if( element_size >= 4 ) {
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			if( element_size == 8 ) {
				asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			// 配列要素の先頭アドレスをスタックから取り出して加算
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			//	要素 i - 1 の最大数をスタックから取り出す
			asm_line.set( CMNEMONIC_TYPE::LD,   CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD,   CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "H" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::POP,  CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL,    "bios_umult", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		exp_list[i]->release();
	}
}

// --------------------------------------------------------------------
CVARIABLE CVARIABLE_MANAGER::create_variable_info( class CCOMPILE_INFO *p_info, bool with_array ) {
	std::string s_name;
	std::string s_label;
	CVARIABLE_TYPE var_type;
	CVARIABLE variable, variable_old;
	bool is_array = false;
	int dimension = 0;
	std::vector< CEXPRESSION* > exp_list;
	CEXPRESSION *p_exp;
	int i, element_size;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		return variable;
	}
	//	変数名を取得
	s_name = p_info->list.p_position->s_word;
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	変数名最大 2文字制限
		s_name.resize( 2 );
	}
	//	型識別子
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "%" ) {
			var_type = CVARIABLE_TYPE::INTEGER;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "!" ) {
			var_type = CVARIABLE_TYPE::SINGLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "#" ) {
			var_type = CVARIABLE_TYPE::DOUBLE_REAL;
			p_info->list.p_position++;
		}
		else if( p_info->list.p_position->s_word == "$" ) {
			var_type = CVARIABLE_TYPE::STRING;
			p_info->list.p_position++;
		}
		else {
			var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
		}
	}
	else {
		var_type = p_info->variables.def_types[ s_name[0] - 'A' ];
	}
	switch( var_type ) {
	case CVARIABLE_TYPE::SINGLE_REAL:
		element_size = 4;
		break;
	case CVARIABLE_TYPE::DOUBLE_REAL:
		element_size = 8;
		break;
	default:
		element_size = 2;
		break;
	}
	if( with_array ) {
		//	配列変数か？
		if( !p_info->list.is_command_end() ) {
			if( p_info->list.p_position->s_word == "(" || p_info->list.p_position->s_word == "[" ) {
				//	配列変数の場合
				is_array = true;
				p_info->list.p_position++;
			}
		}
	}
	//	変数ラベルを生成
	switch( var_type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		s_label = "vari";	break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "varf";	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "vard";	break;
	case CVARIABLE_TYPE::STRING:		s_label = "vars";	break;
	}
	if( is_array ) {
		s_label = s_label + "a";
	}
	s_label = s_label + "_" + s_name;
	//	変数を登録する
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( is_array ) {
		//	配列の要素数を調べる
		while( !p_info->list.is_command_end() ) {
			//	要素を取り込む
			p_exp = new CEXPRESSION();
			p_exp->makeup_node( p_info );
			exp_list.push_back( p_exp );
			dimension++;
			//	もう終わりか？
			if( p_info->list.is_command_end() ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				break;
			}
			if( p_info->list.p_position->s_word == ")" ) {
				p_info->list.p_position++;
				break;
			}
			if( p_info->list.p_position->s_word != "," ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				break;
			}
			p_info->list.p_position++;
		}
		variable.dimension = dimension;
	}
	if( p_info->variables.dictionary.count( s_label ) == 0 ) {
		p_info->variables.dictionary[ s_label ] = variable;
	}
	else {
		variable_old = p_info->variables.dictionary[ s_label ];
		if( variable_old.dimension != variable.dimension ) {
			p_info->errors.add( REDIMENSIONED_ARRAY, p_info->list.get_line_no() );
		}
	}
	if( is_array ) {
		//	変数領域にメモリアドレスが格納されていれば、Redimensioned array error (Err10) 
		p_info->assembler_list.add_label( "bios_errhand_redim", "0x0405e" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + variable.s_label + "]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NZ, COPERAND_TYPE::LABEL, "bios_errhand_redim", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	サイズ計算の最初の係数 1 をスタックに積む
		if( dimension == 0 ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "1" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		p_info->assembler_list.add_label( "bios_umult", "0x0314a" );
		for( i = 0; i < dimension; i++ ) {
			//	要素数の計算式を評価
			p_exp = exp_list[i];
			p_exp->compile( p_info );
			delete p_exp;
			exp_list[i] = nullptr;
			if( i > 0 ) {
				//	サイズ計算の直前の結果をスタックから取り出す
				asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			//	計算した要素数をスタックに積む
			asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			if( i > 0 ) {
				asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				//	DE = BC * DE
				asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_umult", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			//	サイズ計算のここまでの結果をスタックに積む
			if( (i + 1) < dimension ) {
				if( i == 0 ) {
					asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
		}
		//	必要なメモリサイズに変換する
		if( dimension > 1 ) {
			asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		if( element_size > 2 ) {
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( element_size > 4 ) {
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, std::to_string( 2 + 1 + dimension * 2 ) );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
		p_info->assembler_list.body.push_back( asm_line );
		//	メモリを確保する
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::NONE, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::NONE, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->assembler_list.activate_allocate_heap();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_heap", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	変数領域に確保したメモリのアドレスを格納
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[" + variable.s_label + "]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		//	確保したメモリにサイズを格納
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "C" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "B" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	サイズを DE に保存しておく (文字列の場合のみ)
		if( var_type == CVARIABLE_TYPE::STRING ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::REGISTER, "C" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::REGISTER, "B" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		//	確保したメモリに次元数を格納
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, std::to_string( dimension ) );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "B" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	確保したメモリに要素数を格納
		if( dimension > 1 ) {
			s_label = p_info->get_auto_label();
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "C" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "B" );
		p_info->assembler_list.body.push_back( asm_line );
		if( dimension > 1 ) {
			asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			if( var_type == CVARIABLE_TYPE::STRING ) {
				asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else if( var_type == CVARIABLE_TYPE::STRING ) {
			asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}

		if( var_type == CVARIABLE_TYPE::STRING ) {
			p_info->assembler_list.activate_init_string_array();
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "init_string_array", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	return variable;
}

// --------------------------------------------------------------------
CVARIABLE CVARIABLE_MANAGER::put_special_variable( class CCOMPILE_INFO *p_info, const std::string s_name, CVARIABLE_TYPE var_type, CVARIABLE_TYPE var_name_type ) {
	CVARIABLE variable;
	std::string s_label;

	if( var_name_type == CVARIABLE_TYPE::UNKNOWN ) {
		var_name_type = var_type;
	}
	//	変数ラベルを生成
	switch( var_name_type ) {
	default:
	case CVARIABLE_TYPE::UNSIGNED_BYTE:	s_label = "svarb";	break;
	case CVARIABLE_TYPE::INTEGER:		s_label = "svari";	break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "svarf";	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "svard";	break;
	case CVARIABLE_TYPE::STRING:		s_label = "svars";	break;
	}
	s_label = s_label + "_" + s_name;
	//	変数を登録する
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( p_info->variables.dictionary.count( s_label ) == 0 ) {
		p_info->variables.dictionary[ s_label ] = variable;
	}
	else {
		variable = p_info->variables.dictionary[ s_label ];
	}
	return variable;
}
