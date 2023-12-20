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

	void sub_return_line_num( void );

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
	void put_logical_operation( void );
};

#endif
