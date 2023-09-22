// --------------------------------------------------------------------
//	Compiler collection: Dim
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "dim.h"

// --------------------------------------------------------------------
//  DIM �z��ϐ��錾
bool CDIM::exec( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	int line_no = p_info->list.get_line_no();
	CSTRING value;

	if( p_info->list.p_position->s_word != "DIM" ) {
		return false;
	}
	p_info->list.p_position++;

	while( !p_info->list.is_command_end() ) {
		//	�ϐ���
		CVARIABLE variable = p_info->variable_manager.create_variable_info( p_info, true );
		//	���̔z���
		if( p_info->list.is_command_end() ) {
			break;
		}
		if( p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			break;
		}
		p_info->list.p_position++;
	}
	return true;
}
