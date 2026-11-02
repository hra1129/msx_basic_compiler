// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_len.h"
#include "expression_term.h"
#include "expression_variable.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_LEN::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE* p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_LEN::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	//	先に引数を処理
	this->p_operand->compile( p_info );

	if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
		//	[B6] 数値変数・配列要素なら、その型のサイズを返す (BACON拡張。
		//	実機インタプリタは数値形を Type mismatch にするが、提案に基づき対応)
		CEXPRESSION_VARIABLE *p_variable = dynamic_cast<CEXPRESSION_VARIABLE*>( this->p_operand );
		if( p_variable != nullptr && p_variable->variable.type != CVARIABLE_TYPE::STRING ) {
			int size = 2;
			if( p_variable->variable.type == CVARIABLE_TYPE::SINGLE_REAL ) {
				size = 4;
			}
			else if( p_variable->variable.type == CVARIABLE_TYPE::DOUBLE_REAL ) {
				size = 8;
			}
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, std::to_string( size ) );
			p_info->assembler_list.body.push_back( asm_line );
			this->type = CEXPRESSION_TYPE::INTEGER;
			return;
		}
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.activate_free_string();
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY, "[HL]" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "free_string", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "L", "A" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( "LD", "", "H", "0" );
	p_info->assembler_list.body.push_back( asm_line );

	this->type = CEXPRESSION_TYPE::INTEGER;
}
