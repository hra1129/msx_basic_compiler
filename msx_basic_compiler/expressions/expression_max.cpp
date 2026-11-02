// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "expression_max.h"
#include "expression_term.h"

// --------------------------------------------------------------------
//	[B6] MAX: 2個以上の数値引数の最大値を返す (BACON拡張)。
//	結果の型は引数の中で最も精度の高い型 (実機系の型決定規則)。
//	文字列引数は Type mismatch。
//	実行時は全て倍精度にそろえて XDCOMP で比較する (整数→倍精度の
//	変換は正確なので、整数同士でも結果は変わらない)。
CEXPRESSION_NODE* CEXPRESSION_MAX::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;
	bool is_all_constant = true;

	for( auto *&p_operand : this->operands ) {
		p = p_operand->optimization( p_info );
		if( p != nullptr ) {
			delete p_operand;
			p_operand = p;
		}
		if( !p_operand->is_constant || p_operand->type == CEXPRESSION_TYPE::STRING
			|| dynamic_cast<CEXPRESSION_TERM*>( p_operand ) == nullptr ) {
			is_all_constant = false;
		}
	}
	//	事前計算処理
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && is_all_constant && this->operands.size() >= 2 ) {
		CEXPRESSION_TYPE result_type = CEXPRESSION_TYPE::INTEGER;
		double result = 0;
		bool is_first = true;
		for( auto *p_operand : this->operands ) {
			double value = dynamic_cast<CEXPRESSION_TERM*>( p_operand )->get_value();
			if( is_first || value > result ) {
				result = value;
			}
			is_first = false;
			if( p_operand->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
				result_type = CEXPRESSION_TYPE::DOUBLE_REAL;
			}
			else if( p_operand->type == CEXPRESSION_TYPE::SINGLE_REAL && result_type == CEXPRESSION_TYPE::INTEGER ) {
				result_type = CEXPRESSION_TYPE::SINGLE_REAL;
			}
		}
		CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
		p_term->set_double( result );
		p_term->type = result_type;
		return p_term;
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_MAX::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	std::string s_label_win;
	std::string s_label_push;
	CEXPRESSION_TYPE result_type = CEXPRESSION_TYPE::INTEGER;
	bool is_first = true;

	if( this->operands.size() < 2 ) {
		p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.add_label( "work_arg", "0x0f847" );
	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
	p_info->assembler_list.add_label( "bios_vmovfm", "0x02f08" );
	p_info->assembler_list.add_label( "bios_xdcomp", "0x02f5c" );
	p_info->assembler_list.activate_push_double_real_hl();
	p_info->assembler_list.activate_pop_double_real_arg();
	p_info->assembler_list.activate_pop_double_real_dac();
	if( p_info->assembler_list.add_subroutines( "max_candidate" ) ) {
		asm_line.set( "LABEL", "", "max_candidate" );
		p_info->assembler_list.variables_area.push_back( asm_line );
		for( int i = 0; i < 4; i++ ) {
			asm_line.set( "DEFW", "", "0" );
			p_info->assembler_list.variables_area.push_back( asm_line );
		}
	}

	for( auto *p_operand : this->operands ) {
		p_operand->compile( p_info );
		if( p_operand->type == CEXPRESSION_TYPE::STRING ) {
			p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
			return;
		}
		if( p_operand->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
			result_type = CEXPRESSION_TYPE::DOUBLE_REAL;
		}
		else if( p_operand->type == CEXPRESSION_TYPE::SINGLE_REAL && result_type == CEXPRESSION_TYPE::INTEGER ) {
			result_type = CEXPRESSION_TYPE::SINGLE_REAL;
		}
		//	比較は倍精度で統一する
		this->convert_type( p_info, CEXPRESSION_TYPE::DOUBLE_REAL, p_operand->type );
		if( is_first ) {
			//	現在の最大値をスタックへ退避
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "push_double_real_hl", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			is_first = false;
			continue;
		}
		//	候補を max_candidate へ複製
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "max_candidate" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "8" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	現在の最大値を ARG へ、候補を DAC へ
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "pop_double_real_arg", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "8" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_valtyp]", COPERAND_TYPE::MEMORY, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "max_candidate" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_vmovfm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	DAC(候補) と ARG(最大値) を比較: A = 1 なら候補が大きい
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_xdcomp", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		s_label_win = p_info->get_auto_label();
		s_label_push = p_info->get_auto_label();
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::CONSTANT, s_label_win, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	最大値のまま (ARG 側が勝ち)
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_arg" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label_push, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label_win, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	候補が勝ち
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "max_candidate" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label_push, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "push_double_real_hl", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
	}

	//	結果を DAC へ戻し、結果型へ変換
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "pop_double_real_dac", COPERAND_TYPE::NONE, "" );
	p_info->assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
	p_info->assembler_list.body.push_back( asm_line );
	if( result_type != CEXPRESSION_TYPE::DOUBLE_REAL ) {
		this->convert_type( p_info, result_type, CEXPRESSION_TYPE::DOUBLE_REAL );
	}
	this->type = result_type;
}
