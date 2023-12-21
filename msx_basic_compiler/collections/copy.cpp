// --------------------------------------------------------------------
//	Compiler collection: Copy
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "copy.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  COPY <ファイル名> TO <ファイル名>
//  COPY <配列変数名> TO <ファイル名>
//  COPY <ファイル名> TO <配列変数名>
//  COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//  COPY <ファイル名>[,<方向>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//  COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <ファイル名>
//  COPY <配列変数名>[,<方向>] TO (X3,Y3) [,[<PAGE>][,<LOP>]]
//  COPY (X1,Y1)-[STEP](X2,Y2) [,<PAGE>] TO <配列変数名>
bool CCOPY_ARRAY::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	bool has_parameter;
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "COPY" ) {
		return false;
	}
	p_info->list.p_position++;

	CEXPRESSION exp;

	
	
	
	
	
	return true;
}
