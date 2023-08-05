// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <map>
#include "compile_info.h"

#ifndef __VARIABLE_MANAGER_H__
#define __VARIABLE_MANAGER_H__

// --------------------------------------------------------------------
class CVARIABLE_MANAGER {
private:
	//	�X�e�[�g�����g��ǂݔ�΂�
	void skip_statement( CCOMPILE_INFO *p_info );

	//	DEFxxx �̏����X�V����
	void update( CCOMPILE_INFO *p_info, CVARIABLE_TYPE new_type );

	//	�z��̗v�f ( a, b, c ... ) ��]�����āA�v�f����Ԃ�
	int evaluate_dimensions( void );
public:
	//	�ϐ��ǉ�����
	CVARIABLE add_variable( CCOMPILE_INFO *p_info, bool is_dim = false );

	//	�R�[�h�����߂��ĕϐ����X�g���쐬����
	bool analyze_defvars( CCOMPILE_INFO *p_info );
};

#endif
