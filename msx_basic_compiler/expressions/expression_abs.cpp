// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include <cmath>
#include "expression_abs.h"
#include "expression_term.h"
#include "../double_real.h"

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_ABS::optimization( CCOMPILE_INFO *p_info ) {
	CEXPRESSION_NODE *p;

	if( this->p_operand == nullptr ) {
		return nullptr;
	}
	p = this->p_operand->optimization( p_info );
	if( p != nullptr ) {
		delete this->p_operand;
		this->p_operand = p;
	}
	//	事前計算処理
	if( (p_info->options.optimize_level >= COPTIMIZE_LEVEL::NODE_ONLY) && this->p_operand->is_constant ) {
		//	定数の場合
		if( this->p_operand->type != CEXPRESSION_TYPE::STRING ) {
			//	数値の場合
			//	[B6] 従来は std::stol で切り捨てていたため、実数定数や
			//	-32768 を正しく扱えなかった。値ベースで畳み込む。
			CEXPRESSION_TERM *p_term = new CEXPRESSION_TERM();
			CEXPRESSION_TERM *p_operand_term = dynamic_cast<CEXPRESSION_TERM*>( this->p_operand );
			if( p_operand_term == nullptr ) {
				delete p_term;
				return nullptr;
			}
			double value = fabs( p_operand_term->get_value() );
			p_term->set_double( value );
			if( this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
				if( p_operand_term->get_value() == -32768.0 ) {
					//	ABS(-32768) は整数に収まらないため倍精度に昇格 (実機互換)
					p_term->type = CEXPRESSION_TYPE::DOUBLE_REAL;
				}
			}
			else {
				//	実数定数は元の型を維持する
				p_term->type = this->p_operand->type;
			}
			return p_term;
		}
	}
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_ABS::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;
	std::string s_label;

	//	先に引数を処理
	if( this->p_operand == nullptr ) {
		return;
	}
	this->p_operand->compile( p_info );

	if( this->p_operand->type == CEXPRESSION_TYPE::STRING ) {
		p_info->errors.add( TYPE_MISMATCH, p_info->list.get_line_no() );
		return;
	}
	p_info->assembler_list.add_label( "work_valtyp", "0x0f663" );
	p_info->assembler_list.add_label( "work_dac", "0x0f7f6" );
	p_info->assembler_list.add_label( "bios_vmovfm", "0x02f08" );
	p_info->assembler_list.add_label( "bios_absfn", "0x02e82" );
	p_info->assembler_list.add_label( "bios_frcsng", "0x0303a" );
	if( this->p_operand->type == CEXPRESSION_TYPE::INTEGER ) {
		s_label = p_info->get_auto_label();
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::CONSTANT, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CPL, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CPL, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		//	[B6] 実機互換のため、整数の絶対値は倍精度へ昇格させる。
		//	通常は FRCDL で変換するが、-32768 の絶対値 32768 は
		//	整数を経由できないため倍精度定数を直接使う。
		std::string s_label_convert = p_info->get_auto_label();
		std::string s_label_done = p_info->get_auto_label();
		p_info->assembler_list.add_label( "bios_frcdbl", "0x0303a" );
		CDOUBLE_REAL const_32768;
		const_32768.set( "32768" );
		std::string s_const_32768 = p_info->constants.add( const_32768 );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::ADD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NC, COPERAND_TYPE::CONSTANT, s_label_convert, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_const_32768 );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label_done, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label_convert, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_dac + 2]", COPERAND_TYPE::REGISTER, "HL" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "2" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_valtyp]", COPERAND_TYPE::MEMORY, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_frcdbl", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_label_done, COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
	}
	else if( this->p_operand->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "4" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_valtyp]", COPERAND_TYPE::MEMORY, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_vmovfm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_absfn", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
		this->type = CEXPRESSION_TYPE::SINGLE_REAL;
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "8" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY, "[work_valtyp]", COPERAND_TYPE::MEMORY, "A" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_vmovfm", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "bios_absfn", COPERAND_TYPE::NONE, "" );
		p_info->assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "work_dac" );
		p_info->assembler_list.body.push_back( asm_line );
		this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
	}
}
