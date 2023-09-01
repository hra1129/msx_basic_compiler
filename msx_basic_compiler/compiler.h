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

	// ----------------------------------------------------------------
	//	���݂̍s����ѐ�Ƃ��Ďw�肳��Ă���ꍇ�A���x���𐶐�����
	void insert_label( void );

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

	void line_compile( void );

	//	�ϐ��̃A�h���X���擾���鏈��
	CVARIABLE get_variable_address( void );
	//	�ϐ��̃A�h���X���擾���鏈��
	CVARIABLE get_variable_address_wo_array( void );
	//	�ϐ��֒l���i�[���鏈��
	void write_variable_value( CVARIABLE &variable );
};

#endif
