// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_eof.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_EOF::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	EOF関数は最適化で消滅することはない
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_EOF::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	先に引数を処理
	if( this->p_operand == nullptr ) {
		return;
	}
	//	呼び出し側の [work_ptrfil] (PRINT の出力先など) を保存する
	p_info->assembler_list.add_label( "work_ptrfil", "0x0f864" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[work_ptrfil]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->p_operand->compile( p_info );

	if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
	p_info->assembler_list.activate_file_number();
	p_info->use_file_access = true;
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_file_number", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	p_info->assembler_list.add_label( "blib_eof", "0x0411a" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::CONSTANT, "blib_eof" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "call_blib", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	//	[work_ptrfil] を復元する (結果は HL に保持される)
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[SP]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_ptrfil]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	this->type = CEXPRESSION_TYPE::INTEGER;
}
