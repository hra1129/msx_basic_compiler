// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include "variable_manager.h"

// --------------------------------------------------------------------
std::vector< CBASIC_WORD >::const_iterator CVARIABLE_MANAGER::skip_statement( std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end ) {
	int line_no = p_list->line_no;

	while( p_list != p_end ) {
		if( p_list->line_no != line_no ) {
			break;
		}
		if( p_list->s_word == ":" || p_list->s_word == "THEN" || p_list->s_word == "ELSE" ) {
			p_list++;
			break;
		}
		p_list++;
	}
	return p_list;
}

// --------------------------------------------------------------------
std::vector< CBASIC_WORD >::const_iterator CVARIABLE_MANAGER::update( CVARIABLE_TYPE new_type, std::vector< CBASIC_WORD >::const_iterator p_list, std::vector< CBASIC_WORD >::const_iterator p_end ) {
	char start_char, end_char;
	std::string s_def = p_list->s_word;
	int line_no = p_list->line_no;
	int i;

	p_list++;
	while( p_list != p_end ) {
		if( p_list->s_word.size() != 1 ) {
			//	DEFINT AA �̂悤�ȁA2�����ȏ�̎w�肾�����ꍇ�̓G���[
			this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
			return this->skip_statement( p_list, p_end );
		}
		if( !isalpha( p_list->s_word[0] & 255 ) ) {
			//	DEFINT 1 �̂悤�ȁA�A���t�@�x�b�g�ȊO�̎w��̏ꍇ�̓G���[
			this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
			return this->skip_statement( p_list, p_end );
		}
		start_char = toupper( p_list->s_word[0] & 255 );
		p_list++;
		if( p_list == p_end || p_list->s_word == "," || p_list->s_word == ":" ) {
			//	DEFINT A �̂悤�ȒP�Ǝw��̏ꍇ
			end_char = start_char;
		}
		else if( p_list->s_word == "-" ) {
			//	DEFINT A-Z �̂悤�Ȕ͈͎w��̏��
			p_list++;
			if( p_list == p_end || p_list->s_word.size() != 1 || !isalpha( p_list->s_word[0] & 255 ) ) {
				//	DEFINT A- �� DEFINT A-AA �� DEFINT A-9 �̂悤�ȕs���ȋL�q�̏ꍇ�̓G���[
				this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
				return this->skip_statement( p_list, p_end );
			}
			end_char = toupper( p_list->s_word[0] & 255 );
			p_list++;
		}
		//	�͈͂��`�F�b�N
		if( start_char > end_char ) {
			//	DEFINT Z-A �̂悤�ȋt���w��̏ꍇ�̓G���[
			this->p_errors->add( "The range specification for " + s_def + " is abnormal.", line_no );
			return p_list;
		}
		//	�͈͂�o�^
		for( i = start_char; i <= end_char; i++ ) {
			this->def_types[ i - 'A' ] = new_type;
		}
		//	���͈͎̔w��� , �͓ǂݔ�΂�
		if( p_list != p_end && p_list->s_word == "," ) {
			p_list++;
		}
		else if( p_list != p_end && p_list->s_word == ":" ) {
			p_list++;
			break;
		}
	}
	return p_list;
}

// --------------------------------------------------------------------
//	DEFINT, DEFSNG, DEFDBL, DEFSTR �𒲂ׂČ^���ʎq�����̕ϐ���
//	�ǂ̌^�ɂȂ邩���m�肳����
bool CVARIABLE_MANAGER::analyze_defvars( std::vector< CBASIC_WORD > list ) {
	std::vector< CBASIC_WORD >::const_iterator p_list;

	p_list = list.begin();
	while( p_list != list.end() ) {
		if( p_list->s_word == "DEFINT" ) {
			p_list = this->update( CVARIABLE_TYPE::INTEGER, p_list, list.end() );
		}
		else if( p_list->s_word == "DEFSNG" ) {
			p_list = this->update( CVARIABLE_TYPE::SINGLE_REAL, p_list, list.end() );
		}
		else if( p_list->s_word == "DEFDBL" ) {
			p_list = this->update( CVARIABLE_TYPE::DOUBLE_REAL, p_list, list.end() );
		}
		else if( p_list->s_word == "DEFSTR" ) {
			p_list = this->update( CVARIABLE_TYPE::STRING, p_list, list.end() );
		}
		else {
			p_list = this->skip_statement( p_list, list.end() );
		}
	}
	return true;
}
