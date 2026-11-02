// --------------------------------------------------------------------
//	Compiler collection: Next
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------

#include "next.h"
#include "../expressions/expression.h"

// --------------------------------------------------------------------
//  NEXT [変数名 [,変数名 ...]]
bool CNEXT::exec( CCOMPILE_INFO *p_info ) {
	std::string s;
	int line_no = p_info->list.get_line_no();
	bool has_let = false;
	bool at_first = true;
	CEXPRESSION exp;
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable_loop;
	CVARIABLE variable_loopl;

	if( p_info->list.p_position->s_word != "NEXT" ) {
		return false;
	}
	p_info->list.p_position++;
	for(;;) {
		//	[B6] O3: for_variable_array と並行に積まれた FOR 記録を取り出す
		int b6_record_index = -1;
		//	変数の記述の存在を確認
		if( p_info->list.is_command_end() ) {
			//	変数の記述が省略されている場合
			if( !at_first ) {
				//	省略可能なのは一番最初だけ
				p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
				return true;
			}
			if( p_info->for_variable_array.size() == 0 ) {
				//	ループ変数が予測不能な場合
				p_info->errors.add( "The loop variable targeted by the NEXT statement is unclear.", p_info->list.get_line_no() );
				return true;
			}
			else {
				//	最後に見つけた FOR文のループ変数を採用する。FOR文で変数は生成済みなので生成処理は省略
				variable_loop = p_info->for_variable_array.back();
				p_info->for_variable_array.pop_back();
				if( p_info->options.optimize_level == COPTIMIZE_LEVEL::DEEP && !p_info->for_b6_stack.empty() ) {
					b6_record_index = p_info->for_b6_stack.back();
					p_info->for_b6_stack.pop_back();
				}
			}
		}
		else {
			//	変数を生成する
			std::vector< CEXPRESSION* > exp_list_dummy;
			variable_loop = p_info->variable_manager.get_variable_info( p_info, exp_list_dummy );
			if( p_info->for_variable_array.size() > 0 ) {
				p_info->for_variable_array.pop_back();
				if( p_info->options.optimize_level == COPTIMIZE_LEVEL::DEEP && !p_info->for_b6_stack.empty() ) {
					b6_record_index = p_info->for_b6_stack.back();
					p_info->for_b6_stack.pop_back();
				}
			}
			p_info->variable_manager.put_special_variable( p_info, variable_loop.s_name + "_LABEL", CVARIABLE_TYPE::INTEGER, variable_loop.type );
		}
		//	1変数文のループ処理
		variable_loopl = p_info->variables.dictionary[ "s" + variable_loop.s_label + "_LABEL" ];
		//	[B6] 静的ペアリングの判定: O3 で、対応 FOR と変数が一致し、
		//	FOR〜NEXT 間に飛び込み対象の行/ラベルが無い場合だけ直接呼ぶ
		bool b6_paired = false;
		if( b6_record_index >= 0 ) {
			CCOMPILE_INFO::CFOR_B6_RECORD &rec = p_info->for_b6_records[ b6_record_index ];
			if( !rec.paired && rec.s_var_label == variable_loop.s_label ) {
				int cur_line = p_info->list.get_line_no();
				bool span_ok = true;
				for( int target: p_info->list.jump_target_line_no ) {
					if( target > rec.for_line_no && target < cur_line ) {
						span_ok = false;
						break;
					}
				}
				if( span_ok ) {
					for( int target: p_info->label_target_lines ) {
						if( target > rec.for_line_no && target < cur_line ) {
							span_ok = false;
							break;
						}
					}
				}
				if( span_ok ) {
					rec.paired = true;
					rec.next_line_no = cur_line;
					b6_paired = true;
				}
			}
		}
		if( b6_paired ) {
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, p_info->for_b6_records[ b6_record_index ].s_next_label, COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
		}
		else {
			asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY, "[" + variable_loopl.s_label + "]" );
			p_info->assembler_list.body.push_back( asm_line );
			asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "jp_hl", COPERAND_TYPE::NONE, "" );
			p_info->assembler_list.body.push_back( asm_line );
			//	セル経由の参照が残る場合は FOR 側の保存を消せない
			p_info->b6_cell_used_vars.insert( variable_loopl.s_label );
		}
		//	次の変数記述があるか調べる
		if( p_info->list.is_command_end() ) {
			break;
		}
		//	, を調べる
		if( p_info->list.p_position->s_word != "," ) {
			p_info->errors.add( SYNTAX_ERROR, p_info->list.get_line_no() );
			return true;
		}
		p_info->list.p_position++;
		at_first = false;
	}
	return true;
}
