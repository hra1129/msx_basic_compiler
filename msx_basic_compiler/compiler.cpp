// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "compiler.h"
#include "collections/comment.h"
#include "variable_manager.h"

// --------------------------------------------------------------------
void CCOMPILER::initialize( void ) {

	this->collection.push_back( new CCOMMENT );
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( void ) {
	bool do_exec;
	CVARIABLE_MANAGER vm;

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR ����������B
	//	�������V���v���ɂ��邽�߂ɁA�r���ŕς�邱�Ƃ͑z�肵�Ȃ��B
	this->info.list.reset_position();
	vm.analyze_defvars( &(this->info) );

	this->info.list.reset_position();
	while( !this->info.list.is_end() ) {
		do_exec = false;
		if( this->info.list.p_position->s_word == ":" ) {
			this->info.list.p_position++;
		}
		for( auto p: this->collection ) {
			do_exec = p->exec( &(this->info) );
			if( do_exec ) {
				break;
			}
		}
		if( !do_exec ) {
			//	������������Ȃ������ꍇ�ASyntax error �ɂ��Ă��̃X�e�[�g�����g��ǂݔ�΂�
			this->info.list.update_current_line_no();
			this->info.errors.add( "Syntax error.", this->info.list.get_line_no() );
			while( !this->info.list.is_line_end() ) {
				if( this->info.list.p_position->s_word == ":" && this->info.list.p_position->type != CBASIC_WORD_TYPE::COMMENT ) {
					//	: �������̂ŃX�e�[�g�����g��ǂݔ�΂��I������Ɣ��f
					break;
				}
				//	1��ǂݔ�΂�
				this->info.list.p_position++;
			}
		}
	}
	return( this->info.errors.list.size() == 0 );
}
