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
	//	���݂̍s����ѐ�Ƃ��Ďw�肳��Ă���ꍇ�A���x���𐶐�����
	void insert_label( void );

	// --------------------------------------------------------------------
	//	�œK���̏���
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

	//	�ϐ��̃A�h���X���擾���鏈��
	CVARIABLE get_variable_address( void );
	//	�ϐ��̃A�h���X���擾���鏈��
	CVARIABLE get_variable_address_wo_array( void );
	//	�ϐ��֒l���i�[���鏈��
	void write_variable_value( CVARIABLE &variable );
	//	body �̍œK��
	void optimize( void );

	// --------------------------------------------------------------------
	//	�ėp�̃R���p�C������
	//	is_lop = false : ���ʂ� work_logopr (0x0fB02) �Ɋi�[����B�ʏ�͂�����B
	//	is_lop = true  : ���ʂ� work_lop (0xf570) �Ɋi�[����B�r�b�g�u���b�N�g�����X�t�@�͂�����B
	void put_logical_operation( bool is_lop = false );
};

#endif
