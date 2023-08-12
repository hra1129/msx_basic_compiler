// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "compiler.h"
#include "collections/cls.h"
#include "collections/color.h"
#include "collections/comment.h"
#include "collections/defdbl.h"
#include "collections/defint.h"
#include "collections/defsng.h"
#include "collections/defstr.h"
#include "collections/end.h"
#include "collections/goto.h"
#include "collections/gosub.h"
#include "collections/out.h"
#include "collections/poke.h"
#include "collections/return.h"
#include "collections/screen.h"
#include "collections/sound.h"
#include "variable_manager.h"

// --------------------------------------------------------------------
void CCOMPILER::initialize( void ) {

	this->collection.push_back( new CCLS );
	this->collection.push_back( new CCOMMENT );
	this->collection.push_back( new CCOLOR );
	this->collection.push_back( new CDEFDBL );
	this->collection.push_back( new CDEFINT );
	this->collection.push_back( new CDEFSNG );
	this->collection.push_back( new CDEFSTR );
	this->collection.push_back( new CEND );
	this->collection.push_back( new CGOTO );
	this->collection.push_back( new CGOSUB );
	this->collection.push_back( new COUT );
	this->collection.push_back( new CPOKE );
	this->collection.push_back( new CRETURN );
	this->collection.push_back( new CSCREEN );
	this->collection.push_back( new CSOUND );
}

// --------------------------------------------------------------------
void CCOMPILER::insert_label( void ) {
	CASSEMBLER_LINE asm_line;

	this->info.list.update_current_line_no();
	int current_line_no = this->info.list.get_line_no();
	for( auto line_no: this->info.list.jump_target_line_no ) {
		if( current_line_no == line_no ) {
			//	���݂̍s�ԍ����A��ѐ�Ƃ��Ďw�肳��Ă���̂Ń��x���𐶐�����
			asm_line.type = CMNEMONIC_TYPE::LABEL;
			asm_line.operand1.s_value = "line_" + std::to_string( current_line_no );
			asm_line.operand1.type = COPERAND_TYPE::LABEL;
			this->info.assembler_list.body.push_back( asm_line );
			break;
		}
	}
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( void ) {
	bool do_exec;
	CVARIABLE_MANAGER vm;
	CASSEMBLER_LINE asm_line;

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR ����������B
	//	�������V���v���ɂ��邽�߂ɁA�r���ŕς�邱�Ƃ͑z�肵�Ȃ��B
	this->info.list.reset_position();
	vm.analyze_defvars( &(this->info) );

	//	����������������
	asm_line.type = CMNEMONIC_TYPE::DEFB;
	asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
	asm_line.operand1.s_value = "0xFE";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::DEFW;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "start_address";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::DEFW;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "end_address";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::DEFW;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "start_address";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::ORG;
	asm_line.operand1.type = COPERAND_TYPE::CONSTANT;
	asm_line.operand1.s_value = "0x8010";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LABEL;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "start_address";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::MEMORY_CONSTANT;
	asm_line.operand1.s_value = "[save_stack]";
	asm_line.operand2.type = COPERAND_TYPE::REGISTER;
	asm_line.operand2.s_value = "SP";
	this->info.assembler_list.header.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LABEL;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "program_start";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	this->info.assembler_list.header.push_back( asm_line );

	this->info.list.reset_position();
	while( !this->info.list.is_end() ) {
		if( this->info.list.is_line_end() && !this->info.list.is_end() ) {
			//	�V�����s�Ȃ̂ŁA���x���̑}�����`�F�b�N����
			this->insert_label();
		}
		do_exec = false;
		if( this->info.list.p_position->s_word == ":" ) {
			this->info.list.p_position++;
		}
		for( auto p: this->collection ) {
			do_exec = p->exec( &(this->info) );
			if( do_exec ) {
				break;
			}
		}
		if( !do_exec ) {
			//	������������Ȃ������ꍇ�ASyntax error �ɂ��Ă��̃X�e�[�g�����g��ǂݔ�΂�
			this->info.list.update_current_line_no();
			this->info.errors.add( SYNTAX_ERROR, this->info.list.get_line_no() );
			this->info.list.skip_statement();
		}
	}

	asm_line.type = CMNEMONIC_TYPE::LABEL;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "program_termination";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	this->info.assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LD;
	asm_line.operand1.type = COPERAND_TYPE::REGISTER;
	asm_line.operand1.s_value = "SP";
	asm_line.operand2.type = COPERAND_TYPE::MEMORY_CONSTANT;
	asm_line.operand2.s_value = "[save_stack]";
	this->info.assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::RET;
	asm_line.operand1.type = COPERAND_TYPE::NONE;
	asm_line.operand1.s_value = "";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	this->info.assembler_list.body.push_back( asm_line );

	asm_line.type = CMNEMONIC_TYPE::LABEL;
	asm_line.operand1.type = COPERAND_TYPE::LABEL;
	asm_line.operand1.s_value = "end_address";
	asm_line.operand2.type = COPERAND_TYPE::NONE;
	asm_line.operand2.s_value = "";
	this->info.assembler_list.footer.push_back( asm_line );
	return( this->info.errors.list.size() == 0 );
}
