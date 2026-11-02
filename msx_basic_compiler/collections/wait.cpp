// --------------------------------------------------------------------
//	Compiler collection: Wait
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "wait.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  WAIT <I/Oポート番号>, <ANDマスク> [, <XORマスク>]
//	実機の意味論: (IN(ポート) XOR XORマスク) AND ANDマスク が 0 の間ループし、
//	0 でなくなったら次へ進む。
bool CWAIT::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	CEXPRESSION exp;
	int line_no = p_info->list.get_line_no();
	std::string s_label;

	if( p_info->list.p_position->s_word != "WAIT" ) {
		return false;
	}
	p_info->list.p_position++;

	//	第1引数 <I/Oポート番号>
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	exp.release();
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );

	if( p_info->list.is_command_end() || p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	p_info->list.p_position++;

	//	第2引数 <ANDマスク>
	if( !exp.compile( p_info ) ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}
	exp.release();
	asm_line.set( "PUSH", "", "HL" );
	p_info->assembler_list.body.push_back( asm_line );

	//	第3引数 <XORマスク> (省略時は 0)
	if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
		p_info->list.p_position++;
		if( !exp.compile( p_info ) ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		exp.release();
	}
	else {
		asm_line.set( "LD", "", "HL", "0" );
		p_info->assembler_list.body.push_back( asm_line );
	}
	//	この時点で HL = XORマスク, スタックに [ANDマスク, ポート番号]
	asm_line.set( "LD", "", "B", "L" );			//	B = XORマスク
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );			//	HL = ANDマスク
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "D", "L" );			//	D = ANDマスク
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "POP", "", "HL" );			//	HL = ポート番号
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "C", "L" );			//	C = ポート番号
	p_info->assembler_list.body.push_back( asm_line );

	s_label = p_info->get_auto_label();
	asm_line.set( "LABEL", "", s_label );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "IN", "", "A", "[C]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "XOR", "", "A", "B" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "AND", "", "A", "D" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "JR", "Z", s_label );
	p_info->assembler_list.body.push_back( asm_line );
	return true;
}
