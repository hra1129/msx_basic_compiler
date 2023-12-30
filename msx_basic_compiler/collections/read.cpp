// --------------------------------------------------------------------
//	Compiler collection: Read
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "read.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  READ {•Ï”–¼}[,•Ï”–¼ ... ]
bool CREAD::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;

	if( p_info->list.p_position->s_word != "READ" ) {
		return false;
	}
	p_info->list.p_position++;

	while( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
			//	•Ï”–¼‚Å‚Í–³‚¢‚Ì‚Å READ ‚Å‚Í‚È‚¢B
			p_info->errors.add( SYNTAX_ERROR, line_no );
			return true;
		}
		//	•Ï”‚ð¶¬‚·‚é
		CVARIABLE variable = p_info->p_compiler->get_variable_address();
		switch( variable.type ) {
		case CVARIABLE_TYPE::STRING:		
			p_info->assembler_list.activate_read_string();
			asm_line.set( "CALL", "", "sub_read_string" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		default:
		case CVARIABLE_TYPE::INTEGER:		
			p_info->assembler_list.activate_read_integer();
			asm_line.set( "CALL", "", "sub_read_integer" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::SINGLE_REAL:	
			p_info->assembler_list.activate_read_single();
			asm_line.set( "CALL", "", "sub_read_single" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		case CVARIABLE_TYPE::DOUBLE_REAL:	
			p_info->assembler_list.activate_read_double();
			asm_line.set( "CALL", "", "sub_read_double" );
			p_info->assembler_list.body.push_back( asm_line );
			break;
		}
		if( p_info->list.is_command_end() ) {
			break;
		}
		if(p_info->list.p_position->type != CBASIC_WORD_TYPE::SYMBOL || p_info->list.p_position->s_word != ",") {
			p_info->errors.add( SYNTAX_ERROR, line_no );
			break;
		}
		p_info->list.p_position++;
	}
	return true;
}
