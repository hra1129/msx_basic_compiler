// --------------------------------------------------------------------
//	Compiler collection: Draw
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "draw.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  DRAW <文字列式>
//	実体は BACONLIB 側の GML インタプリタ (blib_draw)。
//	文字列は PLAY と同様にワークバッファへコピーしてから渡す。
//	状態ブロック (draw_state) は文字列バッファと同一ワーク内に置く:
//	  +0     初期化フラグ
//	  +1     角度 (0..3)
//	  +2     スケール (既定 4)
//	  +3     色
//	  +4..   座標の小数部・X ネスト用スタック等 (ライブラリ管理)
//	  +64    文字列バッファ (最大 255 文字 + 終端)
//	  +63    文字数 (当ステートメントが書く)
bool CDRAW::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "DRAW" ) {
		return false;
	}
	p_info->list.p_position++;

	if( p_info->list.is_command_end() ) {
		p_info->errors.add( MISSING_OPERAND, line_no );
		return true;
	}
	p_info->assembler_list.add_label( "blib_draw", "0x04147" );
	p_info->assembler_list.activate_copy_string_to_buffer();
	p_info->assembler_list.activate_free_string();
	if( p_info->assembler_list.add_subroutines( "draw_workspace" ) ) {
		asm_line.set( "LABEL", "", "draw_workspace" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		for( int i = 0; i < 320 / 2; i++ ) {
			asm_line.set( "DEFW", "", "0" );
			p_info->assembler_list.variables_area.push_back( asm_line );
		}
	}

	CEXPRESSION exp;
	if( !exp.compile( p_info, CEXPRESSION_TYPE::STRING ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	exp.release();
	//	文字列をバッファへコピーして一時文字列を解放
	//	(バッファは長さバイト付き: +64 = 文字数, +65.. = 本文)
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "draw_workspace + 64" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "copy_string_to_buffer" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "free_string" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.activate_sub_draw_line();
	p_info->assembler_list.activate_sub_draw_frcint();
	asm_line.set( "LD", "", "hl", "sub_draw_frcint_tramp" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[draw_workspace + 55]", "hl" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "hl", "sub_draw_line_tramp" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "[draw_workspace + 53]", "hl" );
	p_info->assembler_list.body.push_back( asm_line );

	//	blib_draw( HL = draw_workspace, DE = draw_variable_table, BC = draw_default_types )
	asm_line.set( "LD", "", "HL", "draw_workspace" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "DE", "draw_variable_table" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "BC", "draw_default_types" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "IX", "blib_draw" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "CALL", "", "call_blib" );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
