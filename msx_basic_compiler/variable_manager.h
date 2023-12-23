// --------------------------------------------------------------------
//	Variable manager
// ====================================================================
//	2023/July/22  t.hara
// --------------------------------------------------------------------

#include <vector>
#include <string>
#include <map>
#include "variable_info.h"

#ifndef __VARIABLE_MANAGER_H__
#define __VARIABLE_MANAGER_H__

// --------------------------------------------------------------------
class CVARIABLE_MANAGER {
private:
	//	�X�e�[�g�����g��ǂݔ�΂�
	void skip_statement( class CCOMPILE_INFO *p_info );

	//	DEFxxx �̏����X�V����
	void update( class CCOMPILE_INFO *p_info, CVARIABLE_TYPE new_type );

	//	�z��̗v�f ( a, b, c ... ) ��]�����āA�v�f����Ԃ�
	int evaluate_dimensions( class CCOMPILE_INFO *p_info );
public:
	//	�ϐ��ǉ�����
	CVARIABLE add_variable( class CCOMPILE_INFO *p_info );

	//	�R�[�h�����߂��ĕϐ����X�g���쐬����
	bool analyze_defvars( class CCOMPILE_INFO *p_info );

	//	���݂̎Q�ƈʒu�̕ϐ��𐶐����ď���Ԃ�
	CVARIABLE create_variable_info( class CCOMPILE_INFO *p_info, bool with_array = true );

	//	���݂̎Q�ƈʒu�̕ϐ��̏���Ԃ�
	CVARIABLE get_variable_info( class CCOMPILE_INFO *p_info, std::vector< class CEXPRESSION* > &exp_list, bool with_array = true );

	//	���݂̎Q�ƈʒu�̔z��ϐ�(�v�f�ł͂Ȃ��z��S��)�̏���Ԃ�
	CVARIABLE get_array_info( class CCOMPILE_INFO *p_info );

	//	�z��v�f�̎��̔z�� exp_list ���R���p�C������R�[�h�𐶐�����BHL �ɕϐ��̃A�h���X�������Ă���O��ł���B
	void compile_array_elements( class CCOMPILE_INFO *p_info, std::vector< class CEXPRESSION* > &exp_list, CVARIABLE &variable );

	//	����ϐ����`����
	CVARIABLE put_special_variable( class CCOMPILE_INFO *p_info, const std::string s_name, CVARIABLE_TYPE var_type, CVARIABLE_TYPE var_name_type = CVARIABLE_TYPE::UNKNOWN );
};

#endif
