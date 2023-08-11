// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "compiler.h"
#include "collections/cls.h"
#include "collections/color.h"
#include "collections/comment.h"
#include "collections/defdbl.h"
#include "collections/defint.h"
#include "collections/defsng.h"
#include "collections/defstr.h"
#include "collections/goto.h"
#include "collections/gosub.h"
#include "collections/poke.h"
#include "collections/return.h"
#include "collections/screen.h"
#include "variable_manager.h"

// --------------------------------------------------------------------
void CCOMPILER::initialize( void ) {

	this->collection.push_back( new CCLS );
	this->collection.push_back( new CCOMMENT );
	this->collection.push_back( new CCOLOR );
	this->collection.push_back( new CDEFDBL );
	this->collection.push_back( new CDEFINT );
	this->collection.push_back( new CDEFSNG );
	this->collection.push_back( new CDEFSTR );
	this->collection.push_back( new CGOTO );
	this->collection.push_back( new CGOSUB );
	this->collection.push_back( new CPOKE );
	this->collection.push_back( new CRETURN );
	this->collection.push_back( new CSCREEN );
}

// --------------------------------------------------------------------
void CCOMPILER::insert_label( void ) {
	CASSEMBLER_LINE asm_line;

	this->info.list.update_current_line_no();
	int current_line_no = this->info.list.get_line_no();
	for( auto line_no: this->info.list.jump_target_line_no ) {
		if( current_line_no == line_no ) {
			//	現在の行番号が、飛び先として指定されているのでラベルを生成する
			asm_line.type = CMNEMONIC_TYPE::LABEL;
			asm_line.operand1.s_value = "line_" + std::to_string( current_line_no );
			asm_line.operand1.type = COPERAND_TYPE::LABEL;
			this->info.assembler_list.body.push_back( asm_line );
			break;
		}
	}
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( void ) {
	bool do_exec;
	CVARIABLE_MANAGER vm;

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR を処理する。
	//	実装をシンプルにするために、途中で変わることは想定しない。
	this->info.list.reset_position();
	vm.analyze_defvars( &(this->info) );

	this->info.list.reset_position();
	while( !this->info.list.is_end() ) {
		if( this->info.list.is_line_end() && !this->info.list.is_end() ) {
			//	新しい行なので、ラベルの挿入をチェックする
			this->insert_label();
		}
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
			//	何も処理されなかった場合、Syntax error にしてそのステートメントを読み飛ばす
			this->info.list.update_current_line_no();
			this->info.errors.add( SYNTAX_ERROR, this->info.list.get_line_no() );
			this->info.list.skip_statement();
		}
	}
	return( this->info.errors.list.size() == 0 );
}
