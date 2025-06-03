// --------------------------------------------------------------------
//	Compiler
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "compile_info.h"

#ifndef __CCOMPILER_H__
#define __CCOMPILER_H__

// --------------------------------------------------------------------
class CCOMPILER {
private:
	std::vector< CCOMPILER_CONTAINER* > collection;

	void initialize( void );

	void exec_header( std::string s_name );
	void exec_initializer( std::string s_name );
	void exec_compile_body( void );
	void exec_terminator( void );
	void exec_data( void );
	void exec_subroutines( void );

	void exec_sub_run( void );
	void exec_sub_interrupt_process( void );
	void exec_sub_h_timi( void );
	void exec_sub_restore_h_timi( void );
	void exec_sub_on_error( void );

	// ----------------------------------------------------------------
	//	現在の行が飛び先として指定されている場合、ラベルを生成する
	void insert_label( void );

	// --------------------------------------------------------------------
	//	最適化の処理
	void optimize_interrupt_process( void );
	void optimize_push_pop( void );
	void optimize_remove_interrupt_process( void );
	void optimize_ldir( void );
	void optimize_calculation( void );

	void sub_return_line_num( void );

	bool is_pair_register( char h, char l ) {
		const char* p_pair_registers[] = { "AF", "BC", "DE", "HL" };
		size_t i;
		for( i = 0; i < sizeof( p_pair_registers ) / sizeof( p_pair_registers[0] ); i++ ) {
			if( p_pair_registers[i][0] == h && p_pair_registers[i][1] == l ) {
				return true;
			}
			if( p_pair_registers[i][0] == l && p_pair_registers[i][1] == h ) {
				return true;
			}
		}
		return false;
	}

	bool is_pair_low_register( char l ) {
		const char* p_pair_registers[] = { "AF", "BC", "DE", "HL" };
		size_t i;
		for( i = 0; i < sizeof( p_pair_registers ) / sizeof( p_pair_registers[0] ); i++ ) {
			if( p_pair_registers[i][1] == l ) {
				return true;
			}
		}
		return false;
	}

	const char *get_pair_register( char reg8 ) {
		const char* p_pair_registers[] = { "AF", "BC", "DE", "HL" };
		size_t i;
		for( i = 0; i < sizeof( p_pair_registers ) / sizeof( p_pair_registers[0] ); i++ ) {
			if( p_pair_registers[i][0] == reg8 || p_pair_registers[i][1] == reg8 ) {
				return p_pair_registers[i];
			}
		}
		return "null";
	}

	int check_16bit_register( const std::string s ) const {
		if( s == "HL" ) {
			return 0;
		}
		if( s == "DE" ) {
			return 1;
		}
		if( s == "BC" ) {
			return 2;
		}
		if( s == "AF" ) {
			return 3;
		}
		if( s == "SP" ) {
			return 4;
		}
		return 999;
	}

	bool is_flag_change( std::vector< CASSEMBLER_LINE >::iterator p ) {
		if( p->type == CMNEMONIC_TYPE::COMMENT || p->type == CMNEMONIC_TYPE::LABEL || p->type == CMNEMONIC_TYPE::CONSTANT ) {
			return false;
		}
		if( ( p->type == CMNEMONIC_TYPE::EX || p->type == CMNEMONIC_TYPE::POP ) && p->operand1.s_value == "AF" ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::RR || p->type == CMNEMONIC_TYPE::RL || p->type == CMNEMONIC_TYPE::RRC || p->type == CMNEMONIC_TYPE::RLC ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::SLA || p->type == CMNEMONIC_TYPE::SRA || p->type == CMNEMONIC_TYPE::SRL ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::AND || p->type == CMNEMONIC_TYPE::OR || p->type == CMNEMONIC_TYPE::XOR || p->type == CMNEMONIC_TYPE::NEG || p->type == CMNEMONIC_TYPE::CPL ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::ADD || p->type == CMNEMONIC_TYPE::ADC || p->type == CMNEMONIC_TYPE::SUB || p->type == CMNEMONIC_TYPE::SBC || p->type == CMNEMONIC_TYPE::CP ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::RLCA || p->type == CMNEMONIC_TYPE::RRCA || p->type == CMNEMONIC_TYPE::RLA || p->type == CMNEMONIC_TYPE::RRA ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::OTIR || p->type == CMNEMONIC_TYPE::OUTI || p->type == CMNEMONIC_TYPE::INIR || p->type == CMNEMONIC_TYPE::INI ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::OTDR || p->type == CMNEMONIC_TYPE::OUTD || p->type == CMNEMONIC_TYPE::INDR || p->type == CMNEMONIC_TYPE::IND ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::CPI || p->type == CMNEMONIC_TYPE::CPIR || p->type == CMNEMONIC_TYPE::CPD || p->type == CMNEMONIC_TYPE::CPDR ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::DJNZ || p->type == CMNEMONIC_TYPE::BIT ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::CCF || p->type == CMNEMONIC_TYPE::SCF ) {
			return true;
		}
		if( (p->type == CMNEMONIC_TYPE::INC || p->type == CMNEMONIC_TYPE::DEC) && check_16bit_register( p->operand1.s_value ) == 999 ) {
			return true;
		}
		return false;
	}

	bool use_flag_command( std::vector< CASSEMBLER_LINE >::iterator p ) {
		if( p->type == CMNEMONIC_TYPE::COMMENT || p->type == CMNEMONIC_TYPE::LABEL || p->type == CMNEMONIC_TYPE::CONSTANT ) {
			return false;
		}
		if( p->type == CMNEMONIC_TYPE::RR || p->type == CMNEMONIC_TYPE::RL ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::SLA || p->type == CMNEMONIC_TYPE::SRA || p->type == CMNEMONIC_TYPE::SRL ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::ADC || p->type == CMNEMONIC_TYPE::SBC ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::RLA || p->type == CMNEMONIC_TYPE::RRA ) {
			return true;
		}
		if( p->type == CMNEMONIC_TYPE::CCF ) {
			return true;
		}
		return false;
	}

public:
	CCOMPILE_INFO info;

	CCOMPILER() {
		initialize();
	}

	~CCOMPILER() {
		for( auto p: this->collection ) {
			delete p;
			p = nullptr;
		}
	}

	bool exec( std::string s_name );

	void line_compile( bool is_top = false );

	//	変数のアドレスを取得する処理
	CVARIABLE get_variable_address( void );
	//	変数のアドレスを取得する処理
	CVARIABLE get_variable_address_wo_array( void );
	//	変数へ値を格納する処理
	void write_variable_value( CVARIABLE &variable );
	//	body の最適化
	void optimize( void );

	// --------------------------------------------------------------------
	//	汎用のコンパイル処理
	//	is_lop = false : 結果を work_logopr (0x0fB02) に格納する。通常はこちら。
	//	is_lop = true  : 結果を work_lop (0xf570) に格納する。ビットブロックトランスファはこちら。
	void put_logical_operation( bool is_lop = false );

	bool is_integer( const std::string s );
};

#endif
