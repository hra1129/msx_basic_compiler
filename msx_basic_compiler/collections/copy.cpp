// --------------------------------------------------------------------
//	Compiler collection: Copy
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "copy.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------t
bool CCOPY::get_x1_y1_x2_y2( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	bool is_step = false;

	p_info->assembler_list.add_label( "work_sx", "0xf562" );
	p_info->assembler_list.add_label( "work_sy", "0xf564" );
	p_info->assembler_list.add_label( "work_nx", "0xf56A" );
	p_info->assembler_list.add_label( "work_ny", "0xf56C" );
	p_info->assembler_list.add_label( "work_acpage", "0x0faf6" );

	//	(
	p_info->list.p_position++;

	//	X1
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_sx]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	//	Y1
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_sy]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	//	-
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "-" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	//	STEP
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "STEP" ){
		p_info->list.p_position++;
		is_step = true;
	}

	//	(
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "(" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	//	X2
	if( exp.compile( p_info ) ) {
		if( !is_step ) {
			asm_line.set( "LD", "", "DE", "[work_sx]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "OR", "", "A", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "SBC", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( "LD", "", "[work_nx]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	//	Y2
	if( exp.compile( p_info ) ) {
		if( !is_step ) {
			asm_line.set( "LD", "", "DE", "[work_sy]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "OR", "", "A", "A" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "SBC", "", "HL", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "INC", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		asm_line.set( "LD", "", "[work_ny]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	//	,
	if( p_info->list.is_command_end() ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	if( p_info->list.p_position->s_word == "TO" ) {
		//	ページの指定が省略されている場合
		asm_line.set( "LD", "", "A", "[work_acpage]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_sy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->list.p_position++;
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return false;
	}
	p_info->list.p_position++;

	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "A", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_sy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();

		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TO" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return false;
		}
		p_info->list.p_position++;
		return true;
	}
	p_info->errors.add( SYNTAX_ERROR, line_no );
	return false;
}

// --------------------------------------------------------------------t
bool CCOPY::get_x3_y3( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();

	p_info->assembler_list.add_label( "work_dx", "0xf566" );
	p_info->assembler_list.add_label( "work_dy", "0xf568" );
	p_info->assembler_list.add_label( "work_lop", "0xf570" );
	p_info->assembler_list.add_label( "work_acpage", "0x0faf6" );

	//	(
	p_info->list.p_position++;

	//	X3
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_dx]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	,
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	//	Y3
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "[work_dy]", "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	//	)
	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != ")" ){
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		//	転送先：描画ページ
		asm_line.set( "LD", "", "A", "[work_acpage]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_dy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		//	ロジカルオペレーション
		p_info->p_compiler->put_logical_operation( true );
		return true;
	}
	//	,
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;
	//	転送先ページ
	if( exp.compile( p_info ) ) {
		asm_line.set( "LD", "", "A", "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_dy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
		exp.release();
	}
	else {
		asm_line.set( "LD", "", "A", "[work_acpage]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( "LD", "", "[work_dy + 1]", "A" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	ロジカルオペレーション
	p_info->p_compiler->put_logical_operation( true );
	return true;
}

// --------------------------------------------------------------------
//  (1) COPY <ファイル名> TO <ファイル名>
//  (2) COPY <ファイル名> TO <配列変数名>
//  (3) COPY <ファイル名>[,<方向>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//
//  (4) COPY <配列変数名> TO <ファイル名>
//  (5) COPY <配列変数名>[,<方向>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//
//  (6) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//  (7) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <ファイル名>
//  (8) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <配列変数名>
//
bool CCOPY::exec( CCOMPILE_INFO *p_info ) {
	CVARIABLE variable;
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp, exp_direction;
	bool has_direction = false;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "COPY" ) {
		return false;
	}
	p_info->list.p_position++;

	p_info->assembler_list.add_label( "work_buf", "0x0f55e" );
	if( p_info->list.is_command_end() ) {
		//	COPY だけで終わってる場合はエラー
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	if( p_info->list.p_position->s_word == "(" ) {
		//	( X1, Y1 )-[STEP]( X2, Y2 ), [ページ] だった場合
		if( !this->get_x1_y1_x2_y2( p_info ) ) {
			return true;
		}
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "(" ){
			//	(6) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
			if( !this->get_x3_y3( p_info ) ) {
				//	エラーが発生したので何もせずに戻る
				return true;
			}
			p_info->assembler_list.add_label( "blib_copy_pos_to_pos", "0x040b4" );
			asm_line.set( "LD", "", "IX", "blib_copy_pos_to_pos" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
		variable = p_info->variable_manager.get_array_info( p_info );
		if( variable.s_name == "" ) {
			//	(7) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <ファイル名>
			p_info->assembler_list.add_label( "work_buf", "0x0f55e" );
			asm_line.set( "LD", "", "HL", "[heap_next]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_buf + 0]", "hl" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", "[heap_end]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_buf + 2]", "hl" );
			p_info->assembler_list.body.push_back( asm_line );
			if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
				exp.release();
				p_info->assembler_list.add_label( "blib_copy_pos_to_file", "0x040bd" );
				asm_line.set( "LD", "", "IX", "blib_copy_pos_to_file" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "call_blib" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
		}
		else {
			//	(8) COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <配列変数名>
			asm_line.set( "LD", "", "HL", variable.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			p_info->assembler_list.add_label( "blib_copy_pos_to_array", "0x040b7" );
			asm_line.set( "LD", "", "IX", "blib_copy_pos_to_array" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
		return true;
	}

	//	第1引数を仮に配列変数と見なして情報を得てみる
	variable = p_info->variable_manager.get_array_info( p_info );
	if( variable.s_name == "" ) {
		//	配列変数ではなかった場合、ファイル名でなければならない
		if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			exp.release();
		}
		else {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "," ) {
			//	方向の指定がある場合
			p_info->list.p_position++;
			has_direction = true;
			exp_direction.makeup_node( p_info );
		}
		//	TO
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TO" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "(" ) {
			//	(3) COPY <ファイル名>[,<方向>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
			if( !this->get_x3_y3( p_info ) ) {
				//	エラーが発生したので何もせずに戻る
				return true;
			}
			asm_line.set( "LD", "", "HL", "[heap_next]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_buf + 0]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", "[heap_end]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "[work_buf + 2]", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			//	方向
			if( has_direction ) {
				if( exp_direction.compile( p_info, CEXPRESSION_TYPE::INTEGER ) ) {
					exp_direction.release();
					asm_line.set( "LD", "", "A", "L" );
					p_info->assembler_list.body.push_back( asm_line );
					asm_line.set( "POP", "", "HL" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				else {
					p_info->errors.add( SYNTAX_ERROR, line_no );
					return true;
				}
			}
			else {
				asm_line.set( "XOR", "", "A", "A" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			p_info->assembler_list.add_label( "blib_copy_file_to_pos", "0x051f5" );
			asm_line.set( "PUSH", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_copy_file_to_pos" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "free_string" );
			p_info->assembler_list.body.push_back( asm_line );
			return true;
		}
		//	TO 配列変数？
		variable = p_info->variable_manager.get_array_info( p_info );
		if( variable.s_name == "" ) {
			if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
				//	(1) COPY <ファイル名> TO <ファイル名>
				p_info->assembler_list.activate_free_string();
				//	方向の指定は無視する
				exp_direction.release();
				p_info->assembler_list.add_label( "blib_copy_file_to_file", "0x040ab" );

				asm_line.set( "POP", "", "DE" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "EX", "", "DE", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "PUSH", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "PUSH", "", "DE" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "BC", "[heap_next]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[work_buf + 0]", "BC" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "BC", "[heap_end]" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "[work_buf + 2]", "BC" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "IX", "blib_copy_file_to_file" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "call_blib" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "free_string" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "free_string" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
		}
		else {
			//	(2) COPY <ファイル名> TO <配列変数名>
			p_info->assembler_list.activate_free_string();
			//	方向の指定は無視する
			exp_direction.release();
			p_info->assembler_list.add_label( "blib_copy_file_to_array", "0x040b1" );

			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "DE", variable.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "EX", "", "DE", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "PUSH", "", "DE" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_copy_file_to_array" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "POP", "", "HL" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "free_string" );
			p_info->assembler_list.body.push_back( asm_line );
		}
	}
	else {
		//	配列変数だった
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "," ) {
			//	方向の指定がある場合
			p_info->list.p_position++;
			has_direction = true;
			exp_direction.makeup_node( p_info );
		}
		//	TO
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "TO" ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		p_info->list.p_position++;
		if( p_info->list.is_command_end() ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		if( p_info->list.p_position->s_word == "(" ) {
			if( !this->get_x3_y3( p_info ) ) {
				//	エラーが発生したので何もせずに戻る
				return true;
			}
			//	(5) COPY <配列変数名>[,<方向>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
			p_info->assembler_list.add_label( "blib_copy_array_to_pos", "0x040ba" );
			exp_direction.compile( p_info, CEXPRESSION_TYPE::INTEGER );
			asm_line.set( "LD", "", "A", "L" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "HL", variable.s_label );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "LD", "", "IX", "blib_copy_array_to_pos" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( "CALL", "", "call_blib" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			//	(4) COPY <配列変数名> TO <ファイル名>
			if( exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
				//	方向の指定は無視する
				exp_direction.release();
				p_info->assembler_list.activate_free_string();
				p_info->assembler_list.add_label( "blib_copy_array_to_file", "0x040ae" );

				asm_line.set( "EX", "", "DE", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "HL", variable.s_label );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "PUSH", "", "DE" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "LD", "", "IX", "blib_copy_array_to_file" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "call_blib" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "POP", "", "HL" );
				p_info->assembler_list.body.push_back( asm_line );
				asm_line.set( "CALL", "", "free_string" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			else {
				p_info->errors.add( SYNTAX_ERROR, line_no );
				return true;
			}
		}
	}
	
	
	
	
	return true;
}
