// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "compiler.h"
#include "collections/comment.h"

// --------------------------------------------------------------------
void CCOMPILER::initialize( void ) {

	this->collection.push_back( new CCOMMENT );
}

// --------------------------------------------------------------------
bool CCOMPILER::is_end( void ) {

	return( this->p_position == this->words.end() );
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( CBASIC_LIST &list ) {
	bool do_exec;
	int line_no;

	this->words = list.get_word_list();
	this->p_errors = &(list.errors);

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR ����������B
	//	�������V���v���ɂ��邽�߂ɁA�r���ŕς�邱�Ƃ͑z�肵�Ȃ��B
	vm.p_errors = &(list.errors);
	vm.analyze_defvars( list.get_word_list() );

	while( !this->is_end() ) {
		do_exec = false;
		if( this->p_position->s_word == ":" ) {
			this->p_position++;
		}
		for( auto p: this->collection ) {
			do_exec = p->exec( this );
			if( do_exec ) {
				break;
			}
		}
		if( !do_exec ) {
			//	������������Ȃ������ꍇ�ASyntax error �ɂ��Ă��̃X�e�[�g�����g��ǂݔ�΂�
			line_no = this->p_position->line_no;
			list.errors.add( "Syntax error.", line_no );
			while( !this->is_end() ) {
				if( this->p_position->line_no != line_no ) {
					//	�s���ς�����̂ŃX�e�[�g�����g��ǂݔ�΂��I������Ɣ��f
					break;
				}
				if( this->p_position->s_word == ":" && this->p_position->type != CBASIC_WORD_TYPE::COMMENT ) {
					//	: �������̂ŃX�e�[�g�����g��ǂݔ�΂��I������Ɣ��f
					break;
				}
				//	1��ǂݔ�΂�
				this->p_position++;
			}
		}
	}
	return( list.errors.list.size() == 0 );
}
