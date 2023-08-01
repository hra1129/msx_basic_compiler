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
bool CCOMPILER::exec( CBASIC_LIST &list, class CVARIABLE_MANAGER &vm ) {
	bool do_exec;

	this->words = list.get_word_list();
	this->p_errors = &(list.errors);

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR を処理する。
	//	実装をシンプルにするために、途中で変わることは想定しない。
	vm.p_errors = &(list.errors);
	vm.analyze_defvars( list.get_word_list() );

	while( !this->p_list->is_end() ) {
		do_exec = false;
		if( this->p_list->p_position->s_word == ":" ) {
			this->p_list->p_position++;
		}
		for( auto p: this->collection ) {
			do_exec = p->exec( this );
			if( do_exec ) {
				break;
			}
		}
		if( !do_exec ) {
			//	何も処理されなかった場合、Syntax error にしてそのステートメントを読み飛ばす
			this->p_list->update_current_line_no();
			list.errors.add( "Syntax error.", this->p_list->get_line_no() );
			while( !this->p_list->is_line_end() ) {
				if( this->p_list->p_position->s_word == ":" && this->p_list->p_position->type != CBASIC_WORD_TYPE::COMMENT ) {
					//	: が来たのでステートメントを読み飛ばし終わったと判断
					break;
				}
				//	1語読み飛ばす
				this->p_list->p_position++;
			}
		}
	}
	return( list.errors.list.size() == 0 );
}
