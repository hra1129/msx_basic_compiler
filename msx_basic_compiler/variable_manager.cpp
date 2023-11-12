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
			//	DEFINT AA �̂悤�ȁA2�����ȏ�̎w�肾�����ꍇ�̓G���[
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			this->skip_statement( p_info );
			return;
		}
		if( !isalpha( p_info->list.p_position->s_word[0] & 255 ) ) {
			//	DEFINT 1 �̂悤�ȁA�A���t�@�x�b�g�ȊO�̎w��̏ꍇ�̓G���[
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			this->skip_statement( p_info );
			return;
		}
		start_char = toupper( p_info->list.p_position->s_word[0] & 255 );
		end_char = start_char;
		p_info->list.p_position++;
		if( p_info->list.is_command_end() || p_info->list.p_position->s_word == "," ) {
			//	DEFINT A �̂悤�ȒP�Ǝw��̏ꍇ
		}
		else if( p_info->list.p_position->s_word == "-" ) {
			//	DEFINT A-Z �̂悤�Ȕ͈͎w��̏��
			p_info->list.p_position++;
			if( p_info->list.is_command_end() || p_info->list.p_position->s_word.size() != 1 || !isalpha( p_info->list.p_position->s_word[0] & 255 ) ) {
				//	DEFINT A- �� DEFINT A-AA �� DEFINT A-9 �̂悤�ȕs���ȋL�q�̏ꍇ�̓G���[
				p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
				this->skip_statement( p_info );
				return;
			}
			end_char = toupper( p_info->list.p_position->s_word[0] & 255 );
			p_info->list.p_position++;
		}
		//	�͈͂��`�F�b�N
		if( start_char > end_char ) {
			//	DEFINT Z-A �̂悤�ȋt���w��̏ꍇ�̓G���[
			p_info->errors.add( "The range specification for " + s_def + " is abnormal.", p_info->list.get_line_no() );
			return;
		}
		//	�͈͂�o�^
		for( i = start_char; i <= end_char; i++ ) {
			p_info->variables.def_types[ i - 'A' ] = new_type;
		}
		//	���͈͎̔w��� , �͓ǂݔ�΂�
		if( !p_info->list.is_command_end() && p_info->list.p_position->s_word == "," ) {
			p_info->list.p_position++;
		}
	}
}

// --------------------------------------------------------------------
//	DEFINT, DEFSNG, DEFDBL, DEFSTR �𒲂ׂČ^���ʎq�����̕ϐ���
//	�ǂ̌^�ɂȂ邩���m�肳����
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
//	{�ϐ���}[%|!|#|$][(...)]
CVARIABLE CVARIABLE_MANAGER::add_variable( CCOMPILE_INFO *p_info ) {
	CVARIABLE variable;
	std::string s_name;
	int line_no;
	int dimensions = 0;

	line_no = p_info->list.p_position->line_no;
	//	�ϐ������擾����
	s_name = p_info->list.p_position->s_word;
	transform( s_name.begin(), s_name.end(), s_name.begin(), ::toupper );
	p_info->list.p_position++;
	//	3�����ȏ�̏ꍇ�A2�����ɐ؂�l�߂�
	if( s_name.size() > 2 ) {
		s_name = std::string( "" ) + s_name[0] + s_name[1];
	}
	//	�^���ʎq�̑��݂𒲂ׂ�
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
		//	�^���ʎq���ȗ�����Ă���ꍇ�́ADEFxxx �̎w��ɏ]��
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
	//	�z�񂩁H
	if( p_info->list.p_position->s_word == "(" ) {
		s_name = s_name + "(";
		variable.dimension = this->evaluate_dimensions( p_info );		//	�v�f�ԍ����X�^�b�N�ɐς�
		dimensions = variable.dimension;
	}

	variable.s_name = s_name;
	if( p_info->variables.dictionary.count( s_name ) ) {
		//	���ɔF�m���Ă���ϐ��̏ꍇ�A�z��̎��������`�F�b�N
		variable = p_info->variables.dictionary[ s_name ];
		if( dimensions != variable.dimension ) {
			p_info->errors.add( REDIMENSIONED_ARRAY, line_no );
			return variable;
		}
	}
	else {
		//	���߂ēo�ꂷ��ϐ��̏ꍇ�A�����ɓo�^���ĔF�m
		p_info->variables.dictionary[ s_name ] = variable;
	}
	return variable;
}

// --------------------------------------------------------------------
//	�z��̗v�f�Ɏw�肳��Ă��鎮��]�����ăX�^�b�N�ɐς�
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

//	���݂̎Q�ƈʒu�̔z��ϐ��̏���Ԃ�
CVARIABLE CVARIABLE_MANAGER::get_array_info( class CCOMPILE_INFO *p_info ) {
	std::string s_name;
	std::string s_label;
	CVARIABLE_TYPE var_type;
	CVARIABLE variable;

	if( p_info->list.is_command_end() || p_info->list.p_position->type != CBASIC_WORD_TYPE::UNKNOWN_NAME ) {
		return variable;
	}
	//	�ϐ������擾
	s_name = p_info->list.p_position->s_word;
	transform( s_name.begin(), s_name.end(), s_name.begin(), ::toupper );
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	�ϐ����ő� 2��������
		s_name.resize( 2 );
	}
	//	�^���ʎq
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
	//	�ϐ����x���𐶐�
	switch( var_type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		s_label = "varia";	break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "varfa";	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "varda";	break;
	case CVARIABLE_TYPE::STRING:		s_label = "varsa";	break;
	}
	s_label = s_label + "_" + s_name;
	//	�ϐ���o�^����
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
	//	�ϐ������擾
	s_name = p_info->list.p_position->s_word;
	transform( s_name.begin(), s_name.end(), s_name.begin(), ::toupper );
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	�ϐ����ő� 2��������
		s_name.resize( 2 );
	}
	//	�^���ʎq
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
		//	�z��ϐ����H
		if( !p_info->list.is_command_end() ) {
			if( p_info->list.p_position->s_word == "(" || p_info->list.p_position->s_word == "[" ) {
				//	�z��ϐ��̏ꍇ
				is_array = true;
				p_info->list.p_position++;
			}
		}
	}
	//	�ϐ����x���𐶐�
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
	//	�ϐ���o�^����
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( is_array ) {
		//	�z��̗v�f���𒲂ׂ�
		std::vector< CBASIC_WORD >::const_iterator p_position = p_info->list.p_position;
		for(;;) {
			//	����]��
			p_exp = new CEXPRESSION();
			p_exp->makeup_node( p_info );
			exp_list.push_back( p_exp );
			p_exp = nullptr;
			//	�������X�V
			dimension++;
			//	�G���[�`�F�b�N�ƏI������
			if( p_info->list.is_command_end() ) {
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				break;
			}
			if( p_info->list.p_position->s_word == ")" || p_info->list.p_position->s_word == "]" ) {
				//	�ȍ~�A����������Δ�����
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

	//	���ƂŁu�����m�ہv�̍ۂ̃������T�C�Y���v�Z���邽�߂ɕK�v�ɂȂ�u�v�f�̃T�C�Y�v���v�Z
	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:		element_size = 2; break;
	case CVARIABLE_TYPE::SINGLE_REAL:	element_size = 4; break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	element_size = 8; break;
	case CVARIABLE_TYPE::STRING:		element_size = 2; break;
	}
	//	�����m�۔z�񂾂����ꍇ�̕K�v�ȃ����������v�Z����
	area_size = element_size * 11;
	for( i = 1; i < variable.dimension; i++ ) {
		area_size *= 11;
	}
	//	�z����̃A�h���X�� NULL �Ȃ�A�z��ϐ��̎����m�ۂ����{
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
	//	�z��ϐ��̗v�f�̐擪�A�h���X�����߁A���v�f�����X�^�b�N�ɐς�
	p_info->assembler_list.activate_calc_array_top();
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "calc_array_top", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.add_label( "bios_umult", "0x0314a" );
	for( i = variable.dimension - 1; i >= 0; i-- ) {
		//	�v�f i ���v�Z����
		exp_list[i]->compile( p_info, CEXPRESSION_TYPE::INTEGER );
		if( i < variable.dimension - 1 ) {
			// �Ō�̉��Z���ʂ����o�� ( Z * y_max )
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	�v�f i �̉��Z���ʂƉ��Z����
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		if( i == 0 ) {
			//	�v�f�P���̃T�C�Y�ɍ��킹�āA2�{�E4�{�E8�{����
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
			// �z��v�f�̐擪�A�h���X���X�^�b�N������o���ĉ��Z
			asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			//	�v�f i - 1 �̍ő吔���X�^�b�N������o��
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
	//	�ϐ������擾
	s_name = p_info->list.p_position->s_word;
	p_info->list.p_position++;
	if( s_name.size() > 2 ) {
		//	�ϐ����ő� 2��������
		s_name.resize( 2 );
	}
	//	�^���ʎq
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
		//	�z��ϐ����H
		if( !p_info->list.is_command_end() ) {
			if( p_info->list.p_position->s_word == "(" || p_info->list.p_position->s_word == "[" ) {
				//	�z��ϐ��̏ꍇ
				is_array = true;
				p_info->list.p_position++;
			}
		}
	}
	//	�ϐ����x���𐶐�
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
	//	�ϐ���o�^����
	variable.s_name = s_name;
	variable.s_label = s_label;
	variable.type = var_type;
	variable.dimension = 0;
	if( is_array ) {
		//	�z��̗v�f���𒲂ׂ�
		while( !p_info->list.is_command_end() ) {
			//	�v�f����荞��
			p_exp = new CEXPRESSION();
			p_exp->makeup_node( p_info );
			exp_list.push_back( p_exp );
			dimension++;
			//	�����I��肩�H
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
		//	�ϐ��̈�Ƀ������A�h���X���i�[����Ă���΁ARedimensioned array error (Err10) 
		p_info->assembler_list.add_label( "bios_errhand_redim", "0x0405e" );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[" + variable.s_label + "]" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NZ, COPERAND_TYPE::LABEL, "bios_errhand_redim", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	�T�C�Y�v�Z�̍ŏ��̌W�� 1 ���X�^�b�N�ɐς�
		if( dimension == 0 ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "1" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		p_info->assembler_list.add_label( "bios_umult", "0x0314a" );
		for( i = 0; i < dimension; i++ ) {
			//	�v�f���̌v�Z����]��
			p_exp = exp_list[i];
			p_exp->compile( p_info );
			delete p_exp;
			exp_list[i] = nullptr;
			if( i > 0 ) {
				//	�T�C�Y�v�Z�̒��O�̌��ʂ��X�^�b�N������o��
				asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
			//	�v�Z�����v�f�����X�^�b�N�ɐς�
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
			//	�T�C�Y�v�Z�̂����܂ł̌��ʂ��X�^�b�N�ɐς�
			if( (i + 1) < dimension ) {
				if( i == 0 ) {
					asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
					p_info->assembler_list.body.push_back( asm_line );
				}
				asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
				p_info->assembler_list.body.push_back( asm_line );
			}
		}
		//	�K�v�ȃ������T�C�Y�ɕϊ�����
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
		//	���������m�ۂ���
		asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::NONE, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::NONE, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		p_info->assembler_list.activate_allocate_heap();
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "allocate_heap", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	�ϐ��̈�Ɋm�ۂ����������̃A�h���X���i�[
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[" + variable.s_label + "]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		//	�m�ۂ����������ɃT�C�Y���i�[
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
		//	�T�C�Y�� DE �ɕۑ����Ă��� (������̏ꍇ�̂�)
		if( var_type == CVARIABLE_TYPE::STRING ) {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::REGISTER, "C" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::REGISTER, "B" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		//	�m�ۂ����������Ɏ��������i�[
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, std::to_string( dimension ) );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "B" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	�m�ۂ����������ɗv�f�����i�[
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
	//	�ϐ����x���𐶐�
	switch( var_name_type ) {
	default:
	case CVARIABLE_TYPE::UNSIGNED_BYTE:	s_label = "svarb";	break;
	case CVARIABLE_TYPE::INTEGER:		s_label = "svari";	break;
	case CVARIABLE_TYPE::SINGLE_REAL:	s_label = "svarf";	break;
	case CVARIABLE_TYPE::DOUBLE_REAL:	s_label = "svard";	break;
	case CVARIABLE_TYPE::STRING:		s_label = "svars";	break;
	}
	s_label = s_label + "_" + s_name;
	//	�ϐ���o�^����
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
