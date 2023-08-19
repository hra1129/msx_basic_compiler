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
#include "collections/end.h"
#include "collections/goto.h"
#include "collections/gosub.h"
#include "collections/let.h"
#include "collections/out.h"
#include "collections/poke.h"
#include "collections/print.h"
#include "collections/return.h"
#include "collections/run.h"
#include "collections/screen.h"
#include "collections/sound.h"
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
	this->collection.push_back( new CEND );
	this->collection.push_back( new CGOTO );
	this->collection.push_back( new CGOSUB );
	this->collection.push_back( new CLET );
	this->collection.push_back( new COUT );
	this->collection.push_back( new CPOKE );
	this->collection.push_back( new CPRINT );
	this->collection.push_back( new CRETURN );
	this->collection.push_back( new CRUN );
	this->collection.push_back( new CSCREEN );
	this->collection.push_back( new CSOUND );
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
bool CCOMPILER::exec( std::string s_name ) {
	bool do_exec;
	CVARIABLE_MANAGER vm;
	CASSEMBLER_LINE asm_line;

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR を処理する。
	//	実装をシンプルにするために、途中で変わることは想定しない。
	this->info.list.reset_position();
	vm.analyze_defvars( &(this->info) );

	//	ヘッダーコメント
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "------------------------------------------------------------------------", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "Compiled by MSX-BACON from " + s_name, COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "------------------------------------------------------------------------", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	//	BSAVEヘッダー
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "BSAVE header -----------------------------------------------------------", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0xfe", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, "end_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::ORG, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0x8010", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	初期化処理
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[save_stack]", COPERAND_TYPE::REGISTER, "SP" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "program_start" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_run", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_start", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	RUN用サブルーチン
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_run", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "heap_start" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]", COPERAND_TYPE::LABEL, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "[save_stack]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "SP", COPERAND_TYPE::LABEL, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, std::to_string( this->info.options.stack_size ) );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_end]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	初期化処理用変数
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "save_stack", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_next", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_end", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );

	this->info.list.reset_position();
	while( !this->info.list.is_end() ) {
		if( this->info.list.is_line_end() && !this->info.list.is_end() ) {
			//	新しい行なので、ラベルの挿入をチェックする
			this->insert_label();
		}
		do_exec = false;
		if( this->info.list.p_position->s_word == ":" ) {
			this->info.list.p_position++;
			continue;
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

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_termination", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "SP", COPERAND_TYPE::MEMORY_CONSTANT, "[save_stack]" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_start", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.footer.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "end_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.footer.push_back( asm_line );

	this->info.constants.dump( this->info.assembler_list, this->info.options );
	return( this->info.errors.list.size() == 0 );
}
