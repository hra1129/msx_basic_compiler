// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "compiler.h"
#include "collections/call.h"
#include "collections/cls.h"
#include "collections/color.h"
#include "collections/comment.h"
#include "collections/defdbl.h"
#include "collections/defint.h"
#include "collections/defsng.h"
#include "collections/defstr.h"
#include "collections/end.h"
#include "collections/for.h"
#include "collections/goto.h"
#include "collections/gosub.h"
#include "collections/if.h"
#include "collections/key.h"
#include "collections/let.h"
#include "collections/locate.h"
#include "collections/next.h"
#include "collections/out.h"
#include "collections/poke.h"
#include "collections/print.h"
#include "collections/return.h"
#include "collections/run.h"
#include "collections/screen.h"
#include "collections/sound.h"
#include "collections/vpoke.h"
#include "variable_manager.h"
#include "./expressions/expression.h"

// --------------------------------------------------------------------
void CCOMPILER::initialize( void ) {

	this->collection.push_back( new CCALL );
	this->collection.push_back( new CCLS );
	this->collection.push_back( new CCOMMENT );
	this->collection.push_back( new CCOLOR );
	this->collection.push_back( new CDEFDBL );
	this->collection.push_back( new CDEFINT );
	this->collection.push_back( new CDEFSNG );
	this->collection.push_back( new CDEFSTR );
	this->collection.push_back( new CEND );
	this->collection.push_back( new CFOR );
	this->collection.push_back( new CGOTO );
	this->collection.push_back( new CGOSUB );
	this->collection.push_back( new CIF );
	this->collection.push_back( new CKEY );
	this->collection.push_back( new CLET );
	this->collection.push_back( new CLOCATE );
	this->collection.push_back( new CNEXT );
	this->collection.push_back( new COUT );
	this->collection.push_back( new CPOKE );
	this->collection.push_back( new CPRINT );
	this->collection.push_back( new CRETURN );
	this->collection.push_back( new CRUN );
	this->collection.push_back( new CSCREEN );
	this->collection.push_back( new CSOUND );
	this->collection.push_back( new CVPOKE );
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
void CCOMPILER::line_compile( void ) {
	bool do_exec;

	while( !this->info.list.is_line_end() && this->info.list.p_position->s_word != "ELSE" ) {
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
}

// --------------------------------------------------------------------
//	着目位置の変数名に応じて、その変数のアドレスを取得するコードを生成する
CVARIABLE CCOMPILER::get_variable_address() {
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable;

	variable = this->info.variable_manager.get_variable_info( &this->info );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, variable.s_label );
	this->info.assembler_list.body.push_back( asm_line );
	return variable;
}

// --------------------------------------------------------------------
//	着目位置の変数名に応じて、その変数のアドレスを取得するコードを生成する (配列は除外)
CVARIABLE CCOMPILER::get_variable_address_wo_array( void ) {
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable;

	variable = this->info.variable_manager.get_variable_info( &this->info, false );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, variable.s_label );
	this->info.assembler_list.body.push_back( asm_line );
	return variable;
}

// --------------------------------------------------------------------
void CCOMPILER::write_variable_value( CVARIABLE &variable ) {
	CASSEMBLER_LINE asm_line;

	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:
		//	変数のアドレスを POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		//	格納する値を DE, 変数のアドレスを HL へ
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "HL" );
		this->info.assembler_list.body.push_back( asm_line );
		//	変数へ DE の値を格納
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::SINGLE_REAL:
		this->info.assembler_list.activate_ld_de_single_real();
		//	変数のアドレスを POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_single_real", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::DOUBLE_REAL:
		this->info.assembler_list.activate_ld_de_double_real();
		//	変数のアドレスを POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_double_real", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::STRING:
		//	文字列の演算結果 [HL] を HEAP にコピー
		this->info.assembler_list.activate_free_string();
		//	変数のアドレスを POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "HL" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "C" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "B" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	}
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( std::string s_name ) {
	CASSEMBLER_LINE asm_line;
	char s_buffer[32];

	this->info.p_compiler = this;

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR を処理する。
	//	実装をシンプルにするために、途中で変わることは想定しない。
	this->info.list.reset_position();
	this->info.variable_manager.analyze_defvars( &(this->info) );

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
	sprintf_s( s_buffer, "0x%04X", this->info.options.start_address );
	asm_line.set( CMNEMONIC_TYPE::ORG, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_buffer, COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	初期化処理
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[save_stack]", COPERAND_TYPE::REGISTER, "SP" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NZ, COPERAND_TYPE::LABEL, "bios_syntax_error", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "program_start" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_run", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "jp_hl", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
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
	//	BLIBチェッカー
	this->info.assembler_list.add_label( "bios_syntax_error", "0x4055" );
	this->info.assembler_list.add_label( "bios_calslt", "0x001C" );
	this->info.assembler_list.add_label( "bios_enaslt", "0x0024" );
	this->info.assembler_list.add_label( "work_mainrom", "0xFCC1" );
	this->info.assembler_list.add_label( "work_blibslot", "0xF3D3" );
	this->info.assembler_list.add_label( "signature", "0x4010" );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_CONSTANT, "[work_blibslot]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "h", COPERAND_TYPE::CONSTANT, "0x40" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_enaslt", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bc", COPERAND_TYPE::CONSTANT, "8" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "hl", COPERAND_TYPE::LABEL, "signature" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "de", COPERAND_TYPE::LABEL, "signature_ref" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_check_blib_loop", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_REGISTER, "[de]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "de", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CPI       , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR		, CCONDITION::NZ,   COPERAND_TYPE::LABEL, "_check_blib_exit", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP		, CCONDITION::PE,   COPERAND_TYPE::LABEL, "_check_blib_loop", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_check_blib_exit", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "af", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_CONSTANT, "[work_mainrom]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "h", COPERAND_TYPE::CONSTANT, "0x40" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_enaslt", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI        , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "af", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET       , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "signature_ref", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB		, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "\"BACONLIB\"", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "iy", COPERAND_TYPE::MEMORY_CONSTANT, "[work_blibslot - 1]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_calslt", COPERAND_TYPE::NONE, "" );
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
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_move_size", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_remap_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );

	this->info.list.reset_position();
	while( !this->info.list.is_end() ) {
		if( this->info.list.is_line_end() && !this->info.list.is_end() ) {
			//	新しい行なので、ラベルの挿入をチェックする
			this->insert_label();
		}
		this->line_compile();
		if( !this->info.list.is_line_end() ) {
			this->info.errors.add( SYNTAX_ERROR, this->info.list.get_line_no() );
			this->info.list.p_position++;
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
	this->info.variables.dump( this->info.assembler_list, this->info.options );
	return( this->info.errors.list.size() == 0 );
}
