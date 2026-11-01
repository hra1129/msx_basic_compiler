// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/Dec/14th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_input.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_INPUT::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	if( this->p_operand2 != nullptr ) {
		p = this->p_operand2->optimization( p_info );
		if( p != nullptr ) {
			delete this->p_operand2;
			this->p_operand2 = p;
		}
	}
	//	INP関数は最適化で消滅することはない
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_INPUT::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	先に引数を処理
	if( this->p_operand == nullptr ) {
		return;
	}
	if( this->p_operand2 != nullptr ) {
		//	ファイル形 INPUT$( 文字数, #ファイル番号 )
		//	先にファイル番号を評価して FILE_INFO を確定させる
	//	呼び出し側の [work_ptrfil] (PRINT の出力先など) を保存する
	p_info->assembler_list.add_label( "work_ptrfil", "0x0f864" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[work_ptrfil]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
		this->p_operand2->compile( p_info );
		if( this->p_operand2->type == CEXPRESSION_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return;
		}
		this->p_operand2->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand2->type );
		p_info->assembler_list.activate_file_number();
		p_info->use_file_access = true;
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_file_number", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	文字数を評価する
		this->p_operand->compile( p_info );
		if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return;
		}
		this->p_operand->convert_type( p_info, CEXPRESSION_TYPE::INTEGER, this->p_operand->type );
		p_info->assembler_list.activate_input_string_getfile();
		this->type = CEXPRESSION_TYPE::STRING;
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "allocate_string", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_input_string_getfile", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	//	[work_ptrfil] を復元する (結果は HL に保持される)
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[SP]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_ptrfil]", COPERAND_TYPE::REGISTER, "HL" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
		return;
	}
	this->p_operand->compile( p_info );

	if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.activate_input_string_getchar();
	this->type = CEXPRESSION_TYPE::STRING;
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "allocate_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "sub_input_string_getchar", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
}
