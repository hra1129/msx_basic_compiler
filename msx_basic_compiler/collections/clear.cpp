// --------------------------------------------------------------------
//	Compiler collection: Clear
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "clear.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  CLEAR ƒƒ‚ƒŠŠm•Û
bool CCLEAR::exec( CCOMPILE_INFO *p_info ) {
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "CLEAR" ) {
		return false;
	}
	p_info->list.p_position++;

	//	‘æ1ˆø”‚ðˆ—‚·‚é
	exp.makeup_node( p_info );
	exp.release();				//	‚µ‚©‚µAŽg‚í‚¸‚ÉŽÌ‚Ä‚é

	//	, ‚Ìˆ—
	if( p_info->list.is_command_end() ) {
		return true;
	}
	if( p_info->list.p_position->s_word != "," ) {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	if( exp.compile( p_info, CEXPRESSION_TYPE::EXTENDED_INTEGER ) ) {
		







	}
	else {
		p_info->errors.add( SYNTAX_ERROR, line_no );
		return true;
	}

	return true;
}
