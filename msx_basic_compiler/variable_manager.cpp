// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include "variable_manager.h"
#include "compile_info.h"

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
CVARIABLE CVARIABLE_MANAGER::add_variable( CCOMPILE_INFO *p_info, bool is_dim ) {
	CVARIABLE variable;
	std::string s_name;
	int line_no;
	int dimensions = 0;

	line_no = p_info->list.p_position->line_no;
	//	�ϐ������擾����
	s_name = p_info->list.p_position->s_word;
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
		variable.dimension = -1;		//	�z��Ȃ̂͊m�������A�v�f���͂܂�������Ȃ��B
		dimensions = this->evaluate_dimensions();		//	�v�f�ԍ����X�^�b�N�ɐς�
	}
	else if( is_dim ) {
		//	DIM A �̂悤�ɁADIM�錾�̒��ŗv�f���w�肪�ȗ�����Ă���ꍇ (10) ���w�肳�ꂽ���m�Ƃ���
		s_name = s_name + "(";
		variable.dimension = 1;			//	1�����z��
		dimensions = 1;
		//	�v�f�ԍ����X�^�b�N�ɐς�
		//	��	p_this->body.push_back( "\t\tld\t\thl, 10" );
		//	��	p_this->body.push_back( "\t\tpush\thl" );
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

	if( is_dim ) {
		//	�z��錾DIM �������ꍇ�AHL�ɔz��|�C���^�̃A�h���X������ redim ���Ă�


	}
	return variable;
}

// --------------------------------------------------------------------
//	�z��̗v�f�Ɏw�肳��Ă��鎮��]�����ăX�^�b�N�ɐς�
int CVARIABLE_MANAGER::evaluate_dimensions( void ) {

	//	��
	return 0;
}

// --------------------------------------------------------------------
CVARIABLE CVARIABLE_MANAGER::get_variable_info( class CCOMPILE_INFO *p_info ) {
	std::string s_name;
	std::string s_label;
	CVARIABLE_TYPE var_type;
	CVARIABLE variable;
	bool is_array = false;

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
	//	�z��ϐ����H
	if( !p_info->list.is_command_end() ) {
		if( p_info->list.p_position->s_word == "(" || p_info->list.p_position->s_word == "[" ) {
			//	�z��ϐ��̏ꍇ
			is_array = true;
			p_info->list.p_position++;
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
		//	��T.B.D.
	}
	if( p_info->variables.dictionary.count( s_label ) == 0 ) {
		p_info->variables.dictionary[ s_label ] = variable;
	}
	else {
		variable = p_info->variables.dictionary[ s_label ];
	}
	return variable;
}
