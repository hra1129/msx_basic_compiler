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
bool CCOMPILER::is_line_end( void ) {

	if( this->p_position == this->words.end() ) {
		return true;
	}
	return( this->current_line_no != this->p_position->line_no );
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( CBASIC_LIST &list ) {
	bool do_exec;

	this->words = list.get_word_list();
	this->p_errors = &(list.errors);

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR を処理する。
	//	実装をシンプルにするために、途中で変わることは想定しない。
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
			//	何も処理されなかった場合、Syntax error にしてそのステートメントを読み飛ばす
			this->update_current_line_no();
			list.errors.add( "Syntax error.", this->current_line_no );
			while( !this->is_line_end() ) {
				if( this->p_position->s_word == ":" && this->p_position->type != CBASIC_WORD_TYPE::COMMENT ) {
					//	: が来たのでステートメントを読み飛ばし終わったと判断
					break;
				}
				//	1語読み飛ばす
				this->p_position++;
			}
		}
	}
	return( list.errors.list.size() == 0 );
}
