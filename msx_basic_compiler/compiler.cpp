// --------------------------------------------------------------------
//	Compiler
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------

#include "compiler.h"
#include "collections/beep.h"
#include "collections/bload.h"
#include "collections/bsave.h"
#include "collections/call.h"
#include "collections/clear.h"
#include "collections/cls.h"
#include "collections/color.h"
#include "collections/comment.h"
#include "collections/data.h"
#include "collections/defdbl.h"
#include "collections/defint.h"
#include "collections/defusr.h"
#include "collections/defsng.h"
#include "collections/defstr.h"
#include "collections/dim.h"
#include "collections/end.h"
#include "collections/erase.h"
#include "collections/error.h"
#include "collections/for.h"
#include "collections/goto.h"
#include "collections/gosub.h"
#include "collections/if.h"
#include "collections/input.h"
#include "collections/key.h"
#include "collections/let.h"
#include "collections/lset.h"
#include "collections/locate.h"
#include "collections/next.h"
#include "collections/mid.h"
#include "collections/on_goto.h"			//	on gosub �����̒�
#include "collections/on_interval.h"
#include "collections/on_key.h"
#include "collections/on_sprite.h"
#include "collections/on_strig.h"
#include "collections/out.h"
#include "collections/play.h"
#include "collections/poke.h"
#include "collections/print.h"
#include "collections/put_sprite.h"
#include "collections/read.h"
#include "collections/restore.h"
#include "collections/return.h"
#include "collections/run.h"
#include "collections/screen.h"
#include "collections/setpage.h"
#include "collections/setscroll.h"
#include "collections/sound.h"
#include "collections/vpoke.h"
#include "collections/width.h"
#include "variable_manager.h"
#include "./expressions/expression.h"

// --------------------------------------------------------------------
void CCOMPILER::initialize( void ) {

	this->collection.push_back( new CBEEP );
	this->collection.push_back( new CBLOAD );
	this->collection.push_back( new CBSAVE );
	this->collection.push_back( new CCALL );
	this->collection.push_back( new CCLS );
	this->collection.push_back( new CCLEAR );
	this->collection.push_back( new CCOMMENT );
	this->collection.push_back( new CCOLOR );
	this->collection.push_back( new CDATA );
	this->collection.push_back( new CDEFDBL );
	this->collection.push_back( new CDEFINT );
	this->collection.push_back( new CDEFUSR );
	this->collection.push_back( new CDEFSNG );
	this->collection.push_back( new CDEFSTR );
	this->collection.push_back( new CDIM );
	this->collection.push_back( new CEND );
	this->collection.push_back( new CERASE );
	this->collection.push_back( new CERROR );
	this->collection.push_back( new CFOR );
	this->collection.push_back( new CGOTO );
	this->collection.push_back( new CGOSUB );
	this->collection.push_back( new CIF );
	this->collection.push_back( new CINPUT );
	this->collection.push_back( new CKEY );
	this->collection.push_back( new CLET );
	this->collection.push_back( new CLSET );
	this->collection.push_back( new CLOCATE );
	this->collection.push_back( new CNEXT );
	this->collection.push_back( new CMID );
	this->collection.push_back( new CONINTERVAL );
	this->collection.push_back( new CONKEY );
	this->collection.push_back( new CONSPRITE );
	this->collection.push_back( new CONSTRIG );
	this->collection.push_back( new CONGOTO );			//	ON GOTO/GOSUB �́AON�`GOSUB ����
	this->collection.push_back( new COUT );
	this->collection.push_back( new CPLAY );
	this->collection.push_back( new CPOKE );
	this->collection.push_back( new CPRINT );
	this->collection.push_back( new CPUTSPRITE );
	this->collection.push_back( new CREAD );
	this->collection.push_back( new CRESTORE );
	this->collection.push_back( new CRETURN );
	this->collection.push_back( new CRUN );
	this->collection.push_back( new CSCREEN );
	this->collection.push_back( new CSETPAGE );
	this->collection.push_back( new CSETSCROLL );
	this->collection.push_back( new CSOUND );
	this->collection.push_back( new CVPOKE );
	this->collection.push_back( new CWIDTH );
}

// --------------------------------------------------------------------
void CCOMPILER::insert_label( void ) {
	CASSEMBLER_LINE asm_line;

	this->info.list.update_current_line_no();
	int current_line_no = this->info.list.get_line_no();
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "line_" + std::to_string( current_line_no ), COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::line_compile( bool is_top ) {
	CASSEMBLER_LINE asm_line;
	bool do_exec;

	while( !this->info.list.is_line_end() && !(!is_top && this->info.list.p_position->s_word == "ELSE") ) {
		if( this->info.list.p_position->s_word == ":" ) {
			this->info.list.p_position++;
			continue;
		}
		if( this->info.list.p_position->type == CBASIC_WORD_TYPE::LINE_NO && this->info.list.p_position->s_word[0] == '*' ) {
			asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "label_" + this->info.list.p_position->s_word.substr(1), COPERAND_TYPE::NONE, "" );
			this->info.assembler_list.body.push_back( asm_line );
			this->info.list.p_position++;
			continue;
		}
		do_exec = false;
		//	���荞�ݏ����p�̃��[�`�����Ăяo��
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "interrupt_process", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		//	���߂̏����𐶐�����
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
}

// --------------------------------------------------------------------
//	���ڈʒu�̕ϐ����ɉ����āA���̕ϐ��̃A�h���X���擾����R�[�h�𐶐�����
CVARIABLE CCOMPILER::get_variable_address() {
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable;
	std::vector< CEXPRESSION* > exp_list;

	variable = this->info.variable_manager.get_variable_info( &this->info, exp_list );
	if( variable.dimension == 0 ) {
		//	�P�ƕϐ��̏ꍇ
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, variable.s_label );
		this->info.assembler_list.body.push_back( asm_line );
	}
	else {
		//	�z��ϐ��̏ꍇ
		this->info.variable_manager.compile_array_elements( &this->info, exp_list, variable );
	}
	return variable;
}

// --------------------------------------------------------------------
//	���ڈʒu�̕ϐ����ɉ����āA���̕ϐ��̃A�h���X���擾����R�[�h�𐶐����� (�z��͏��O)
CVARIABLE CCOMPILER::get_variable_address_wo_array( void ) {
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable;
	std::vector< CEXPRESSION* > exp_list;

	variable = this->info.variable_manager.get_variable_info( &this->info, exp_list, false );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, variable.s_label );
	this->info.assembler_list.body.push_back( asm_line );
	return variable;
}

// --------------------------------------------------------------------
void CCOMPILER::write_variable_value( CVARIABLE &variable ) {
	CASSEMBLER_LINE asm_line;

	switch( variable.type ) {
	default:
	case CVARIABLE_TYPE::INTEGER:
		//	�ϐ��̃A�h���X�� POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		//	�i�[����l�� DE, �ϐ��̃A�h���X�� HL ��
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "HL" );
		this->info.assembler_list.body.push_back( asm_line );
		//	�ϐ��� DE �̒l���i�[
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::SINGLE_REAL:
		this->info.assembler_list.activate_ld_de_single_real();
		//	�ϐ��̃A�h���X�� POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_single_real", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::DOUBLE_REAL:
		this->info.assembler_list.activate_ld_de_double_real();
		//	�ϐ��̃A�h���X�� POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "ld_de_double_real", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	case CVARIABLE_TYPE::STRING:
		//	������̉��Z���� [HL] �� HEAP �ɃR�s�[
		this->info.assembler_list.activate_free_string();
		//	�ϐ��̃A�h���X�� POP
		asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "HL" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "E" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "HL", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "D" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "L", COPERAND_TYPE::REGISTER, "C" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "H", COPERAND_TYPE::REGISTER, "B" );
		this->info.assembler_list.body.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "free_string", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.body.push_back( asm_line );
		break;
	}
}

// --------------------------------------------------------------------
void CCOMPILER::exec_header( std::string s_name ) {
	CASSEMBLER_LINE asm_line;
	char s_buffer[32];

	//	�w�b�_�[�R�����g
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "------------------------------------------------------------------------", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "Compiled by MSX-BACON from " + s_name, COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "------------------------------------------------------------------------", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.header.push_back( asm_line );
	//	BSAVE�w�b�_�[
	asm_line.set( CMNEMONIC_TYPE::COMMENT, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "BSAVE header -----------------------------------------------------------", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0xfe", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, "end_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	sprintf( s_buffer, "0x%04X", this->info.options.start_address );
	asm_line.set( CMNEMONIC_TYPE::ORG, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, s_buffer, COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_initializer( std::string s_name ) {
	CASSEMBLER_LINE asm_line;

	this->info.assembler_list.add_label( "work_himem", "0x0FC4A" );

	//	���������� (BACONLIB���݊m�F)
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "start_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "err_return_without_gosub" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "SP", COPERAND_TYPE::MEMORY_CONSTANT, "[work_himem]" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NZ, COPERAND_TYPE::LABEL, "bios_syntax_error", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	���s�̓x�� blib ������
	this->info.assembler_list.add_label( "blib_init_ncalbas", "0x0404e" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "IX", COPERAND_TYPE::LABEL, "blib_init_ncalbas" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	���������� (H.TIMI�t�b�N)
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "work_h_timi" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "h_timi_backup" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "5" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "setup_h_timi", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	ON SPRITE �̔�ѐ揉����
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "_code_ret" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_sprite_line]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.body.push_back( asm_line );
	//	ON INTERVAL �̔�ѐ揉����
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_interval_line]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.body.push_back( asm_line );
	//	ON KEY �̔�ѐ揉����
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_key01_line]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svari_on_key01_line" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "svari_on_key01_line + 2" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "20 - 2" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	���������� (H.ERRO�t�b�N)
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "setup_h_erro", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	���������� (�v���O�����N��)
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "program_start" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_run", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	���������� (h.timi�t�b�N)
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "setup_h_timi", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "h_timi_handler" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_h_timi + 1]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xC3" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_h_timi]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	���������� (h.erro�t�b�N)
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "setup_h_erro", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "work_h_erro" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "h_erro_backup" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "5" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "h_erro_handler" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_h_erro + 1]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xC3" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[work_h_erro]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "jp_hl", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_start", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );

	//	BLIB�`�F�b�J�[
	this->info.assembler_list.add_label( "bios_syntax_error", "0x4055" );
	this->info.assembler_list.add_label( "bios_calslt", "0x001C" );
	this->info.assembler_list.add_label( "bios_enaslt", "0x0024" );
	this->info.assembler_list.add_label( "work_mainrom", "0xFCC1" );
	this->info.assembler_list.add_label( "work_blibslot", "0xF3D3" );
	this->info.assembler_list.add_label( "signature", "0x4010" );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "check_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_CONSTANT, "[work_blibslot]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "h", COPERAND_TYPE::CONSTANT, "0x40" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_enaslt", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "bc", COPERAND_TYPE::CONSTANT, "8" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "hl", COPERAND_TYPE::LABEL, "signature" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "de", COPERAND_TYPE::LABEL, "signature_ref" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_check_blib_loop", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_REGISTER, "[de]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "de", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CPI       , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR		, CCONDITION::NZ,   COPERAND_TYPE::LABEL, "_check_blib_exit", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP		, CCONDITION::PE,   COPERAND_TYPE::LABEL, "_check_blib_loop", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_check_blib_exit", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "af", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "a", COPERAND_TYPE::MEMORY_CONSTANT, "[work_mainrom]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "h", COPERAND_TYPE::CONSTANT, "0x40" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_enaslt", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI        , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "af", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET       , CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "signature_ref", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB		, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "\"BACONLIB\"", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "call_blib", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD		, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "iy", COPERAND_TYPE::MEMORY_CONSTANT, "[work_blibslot - 1]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP		, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_calslt", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	�����������p�ϐ�
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_next", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_end", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_move_size", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_remap_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_compile_body( void ) {
	CASSEMBLER_LINE asm_line;

	this->info.list.reset_position();
	while( !this->info.list.is_end() ) {
		if( this->info.list.is_line_end() && !this->info.list.is_end() ) {
			//	�V�����s�Ȃ̂ŁA���x���̑}�����`�F�b�N����
			this->insert_label();
		}
		this->line_compile( true );
		if( !this->info.list.is_line_end() ) {
			this->info.errors.add( SYNTAX_ERROR, this->info.list.get_line_no() );
			this->info.list.p_position++;
		}
	}
}

// --------------------------------------------------------------------
void CCOMPILER::exec_terminator( void ) {
	CASSEMBLER_LINE asm_line;

	this->info.assembler_list.add_label( "bios_newstt", "0x04601" );
	this->info.assembler_list.add_label( "bios_errhand", "0x0406F" );
	this->info.assembler_list.add_label( "work_himem", "0x0FC4A" );

	//	�v���O�����̏I������
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_termination", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	�v���O�����̏I������ (H.TIMI����)
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "restore_h_erro", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	�v���O�����̏I������ (H.TIMI����)
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "restore_h_timi", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	//	�v���O�����̏I������ (�X�^�b�N����)
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "SP", COPERAND_TYPE::MEMORY_CONSTANT, "[work_himem]" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "_basic_end" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::NONE, "bios_newstt", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_basic_end", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "':', 0x81, 0x00", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "err_return_without_gosub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::CONSTANT, "3" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_errhand", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.body.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "heap_start", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.footer.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "end_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.footer.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_data( void ) {

	//	�f�[�^�Q�Ɨp�̃��x��
	if( this->info.list.data_line_no.size() == 0 ) {
		return;
	}

	CASSEMBLER_LINE asm_line;
	std::string s_label;

	s_label = "data_" + std::to_string( this->info.list.data_line_no[0] );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "data_ptr", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFW, CCONDITION::NONE, COPERAND_TYPE::LABEL, s_label, COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_sub_run( void ) {
	CASSEMBLER_LINE asm_line;

	//	RUN�p�T�u���[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "program_run", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "heap_start" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_next]", COPERAND_TYPE::LABEL, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "[work_himem]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "SP", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, std::to_string( this->info.options.stack_size ) );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::SBC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::REGISTER, "DE" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[heap_end]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	RUN�p�T�u���[�`���̒��ŕϐ��̈���N���A����
	int variable_area_bytes = this->info.variables.var_area_size + this->info.variables.vars_area_count + this->info.variables.vara_area_count;
	if( variable_area_bytes == 0 ) {
		//	�ϐ�����؎g���ĂȂ��̂ŏ������s�v
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "var_area_start" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "var_area_start + 1" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::LABEL, "varsa_area_end - var_area_start - 1" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::CONSTANT, "0" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.subroutines.push_back( asm_line );
	}
	if( this->info.variables.vars_area_count == 0 ) {
		//	������ϐ�����؎g���ĂȂ��̂ŏ������s�v
	}
	else if( this->info.variables.vars_area_count == 1 ) {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, this->info.constants.s_blank_string );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[vars_area_start]", COPERAND_TYPE::REGISTER, "HL" );
		this->info.assembler_list.subroutines.push_back( asm_line );
	}
	else {
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, this->info.constants.s_blank_string );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[vars_area_start]", COPERAND_TYPE::REGISTER, "HL" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "vars_area_start" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "vars_area_start + 2" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::LABEL, "vars_area_end - vars_area_start - 2" );
		this->info.assembler_list.subroutines.push_back( asm_line );
		asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
		this->info.assembler_list.subroutines.push_back( asm_line );
	}
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_sub_interrupt_process( void ) {
	CASSEMBLER_LINE asm_line;

	//	���荞�݃t���O�������[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "interrupt_process", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	���荞�݃t���O�������[�`�� ( ON SPRITE )
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_sprite_running]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_skip_on_sprite", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_sprite_exec]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_skip_on_sprite", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_sprite_running]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_sprite_line]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 1�i�v �����킹�̃_�~�[
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 2�i�v �����킹�̃_�~�[
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 3�i�v �����킹�̃_�~�[
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "jp_hl", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_on_sprite_return_address", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::XOR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_sprite_running]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_skip_on_sprite", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	���荞�݃t���O�������[�`�� ( ON INTERVAL )
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_interval_exec]" );	//	0:Through, 1:Execute
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_skip_on_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_interval_exec]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_interval_line]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 1�i�v �����킹�̃_�~�[
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 2�i�v �����킹�̃_�~�[
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 3�i�v �����킹�̃_�~�[
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "jp_hl", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_skip_on_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	���荞�݃t���O�������[�`�� ( ON STRIG )
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "svarf_on_strig0_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::CONSTANT, "svari_on_strig0_line" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "5" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- STRIG(n)
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_on_strig_loop1", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- svarf_on_strig0_mode[+00] ���m�F����
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );				//	1:ON ���H
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_skip_strig1", COPERAND_TYPE::NONE, "" );			// 0:OFF/STOP �Ȃ珈�����X�L�b�v����
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- svarf_on_strig0_mode[+01] ���m�F����
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_skip_strig1", COPERAND_TYPE::NONE, "" );			// 0x00 �Ȃ珈�����X�L�b�v����
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- svarf_on_strig0_mode[+02] ���m�F����
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_skip_strig1", COPERAND_TYPE::NONE, "" );			// 0xFF �Ȃ珈�����X�L�b�v����
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- svari_on_strig0_line �� CALL ����
	asm_line.set( CMNEMONIC_TYPE::PUSH,	CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				// svarf_on_strig0_mode + 01 ��ۑ�
	this->info.assembler_list.subroutines.push_back( asm_line );																//	��ѐ�֔�ԑO�ɁuSTACK 1�i�v
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "E", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "D", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );				// svari_on_strig0_line �ۑ�
	this->info.assembler_list.subroutines.push_back( asm_line );																//	��ѐ�֔�ԑO�ɁuSTACK 2�i�v
	asm_line.set( CMNEMONIC_TYPE::EX, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );				//	��ѐ�֔�ԑO�ɁuSTACK 3�i�v
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,	CCONDITION::NONE, COPERAND_TYPE::LABEL, "jp_hl", COPERAND_TYPE::NONE, "" );				//	���荞�݂̔�ѐ�
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- ����
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_skip_strig1", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_on_strig_loop1", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	���荞�݃t���O�������[�`�� (ON KEY)
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::LABEL,			"svarf_on_key01_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::LABEL,			"svari_on_key01_line" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"B",				COPERAND_TYPE::CONSTANT,		"0x0A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,			"_on_key_loop1",	COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",				COPERAND_TYPE::MEMORY_REGISTER,	"[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",				COPERAND_TYPE::MEMORY_REGISTER,	"[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR,		CCONDITION::Z,		COPERAND_TYPE::LABEL,			"_skip_key1",		COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::MEMORY_REGISTER,	"[HL]",				COPERAND_TYPE::CONSTANT,		"0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE, "" );	//	��ѐ�֔�ԑO�ɁuSTACK 1�i�v
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::REGISTER,		"HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"E",				COPERAND_TYPE::MEMORY_REGISTER,	"[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"D",				COPERAND_TYPE::MEMORY_REGISTER,	"[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EX,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::REGISTER,		"HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::NONE, "" );	//	��ѐ�֔�ԑO�ɁuSTACK 2�i�v
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"BC",				COPERAND_TYPE::NONE, "" );	//	��ѐ�֔�ԑO�ɁuSTACK 3�i�v
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL,			"jp_hl",			COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"BC",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL,	CCONDITION::NONE,	COPERAND_TYPE::LABEL,			"_skip_key1",		COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"DE",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ,		CCONDITION::NONE,	COPERAND_TYPE::LABEL,			"_on_key_loop1",	COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	���荞�݃t���O�������[�`���I���
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "interrupt_process_end", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_sub_h_timi( void ) {
	CASSEMBLER_LINE asm_line;

	//	H.TIMI�������[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "h_timi_handler", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );		// VDP S#0 �̒l (A���W�X�^) ��ۑ�
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	H.TIMI�������[�`�� ( ON SPRITE ���� )
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_sprite_mode]" );	//	0:OFF, 1:ON, 2:STOP
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_end_of_sprite", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- �X�v���C�g�Փ˃t���t�������Ă��邩�H
	asm_line.set( CMNEMONIC_TYPE::AND, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x20" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "[svarb_on_sprite_exec]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_end_of_sprite", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	H.TIMI�������[�`�� ( ON INTERVAL ���� )
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_interval_mode]" );	//	0:OFF, 1:ON, 2:STOP
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_end_of_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- �f�N�������g�J�E���^�[�����Z
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_interval_counter]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "L" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "H" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_happned_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_interval_counter]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_end_of_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_happned_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_interval_mode]" );	//	0:OFF, 1:ON, 2:STOP
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::NZ, COPERAND_TYPE::LABEL, "_end_of_interval", COPERAND_TYPE::NONE, "" );		//	STOP �Ȃ�ۗ�
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );	//	1:Execute
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svarb_on_interval_exec]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_interval_value]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_CONSTANT, "[svari_on_interval_counter]", COPERAND_TYPE::REGISTER, "HL" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_end_of_interval", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	H.TIMI�������[�`�� ( ON STRIG ���� )
	this->info.assembler_list.add_label( "bios_gttrig", "0x00D8" );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, "svarf_on_strig0_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "0x0500" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	-- STRIG(n)
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_on_strig_loop2", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JR, CCONDITION::Z, COPERAND_TYPE::LABEL, "_skip_strig2", COPERAND_TYPE::NONE, "" );					//	0:OFF �Ȃ�A�������X�L�b�v
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_REGISTER, "[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "A" );			//	1�O�� GTTRIG��Ԃ��X�V
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "C" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "bios_gttrig", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::MEMORY_REGISTER, "[HL]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_skip_strig2", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DJNZ, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_on_strig_loop2", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "_end_of_strig", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );			//	GTTRIG �� EI ���Ă��܂��̂� DI ���Ă���
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	H.TIMI�������[�`�� ( ON KEY ���� )
	asm_line.set( CMNEMONIC_TYPE::IN,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[0xAA]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xF0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "6" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT,		CCONDITION::NONE,	COPERAND_TYPE::MEMORY_CONSTANT, "[0xAA]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[0xA9]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x1E" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RRCA,		CCONDITION::NONE,	COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "B" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OUT,		CCONDITION::NONE,	COPERAND_TYPE::MEMORY_CONSTANT, "[0xAA]", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::IN,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::MEMORY_CONSTANT, "[0xA9]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::OR,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0xFC" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "C" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key06_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x90" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key07_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0xA0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key08_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0xC0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key09_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x81" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key10_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x82" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::REGISTER, "C" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::XOR,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "A", COPERAND_TYPE::CONSTANT, "0x80" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "C", COPERAND_TYPE::REGISTER, "A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key01_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x90" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key02_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0xA0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key03_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0xC0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key04_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x81" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "svarf_on_key05_mode" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,		CCONDITION::NONE,	COPERAND_TYPE::REGISTER, "B", COPERAND_TYPE::CONSTANT, "0x82" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL,		CCONDITION::NONE,	COPERAND_TYPE::LABEL, "_on_key_sub", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	H.TIMI�������[�`���I������
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "AF", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "h_timi_backup", COPERAND_TYPE::NONE, "" );		// VDP S#0 �̒l (A���W�X�^) �𕜋A
	this->info.assembler_list.subroutines.push_back( asm_line );
	//	H.TIMI�������[�`���̒��̃T�u���[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL,CCONDITION::NONE,	COPERAND_TYPE::LABEL,			"_on_key_sub",	COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",			COPERAND_TYPE::MEMORY_REGISTER,	"[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",			COPERAND_TYPE::REGISTER,		"B" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",			COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::INC,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",			COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"D",			COPERAND_TYPE::MEMORY_REGISTER,	"[HL]" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE,	COPERAND_TYPE::MEMORY_REGISTER,	"[HL]",			COPERAND_TYPE::CONSTANT,		"0" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,	CCONDITION::Z,		COPERAND_TYPE::NONE,			"",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",			COPERAND_TYPE::REGISTER,		"C" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,	CCONDITION::NZ,		COPERAND_TYPE::NONE,			"",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",			COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE,	COPERAND_TYPE::MEMORY_REGISTER,	"[HL]",			COPERAND_TYPE::REGISTER,		"A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::AND,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",			COPERAND_TYPE::REGISTER,		"D" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,	CCONDITION::NZ,		COPERAND_TYPE::NONE,			"",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"HL",			COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEC,	CCONDITION::NONE,	COPERAND_TYPE::REGISTER,		"A",			COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD,	CCONDITION::NONE,	COPERAND_TYPE::MEMORY_REGISTER,	"[HL]",			COPERAND_TYPE::REGISTER,		"A" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET,	CCONDITION::NONE,	COPERAND_TYPE::NONE,			"",				COPERAND_TYPE::NONE,			"" );
	this->info.assembler_list.subroutines.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_sub_restore_h_timi( void ) {
	CASSEMBLER_LINE asm_line;

	//	H.TIMI�����������[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "restore_h_timi", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "h_timi_backup" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "work_h_timi" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "5" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	H.TIMI�Ҕ��G���A
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "h_timi_backup", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0, 0, 0, 0, 0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_sub_on_error( void ) {
	CASSEMBLER_LINE asm_line;

	//	H.ERRO�����������[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "restore_h_erro", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::LABEL, "h_erro_backup" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::LABEL, "work_h_erro" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "BC", COPERAND_TYPE::CONSTANT, "5" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LDIR, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::EI, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::NONE, "_code_ret", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::RET, CCONDITION::NONE, COPERAND_TYPE::NONE, "", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	H.ERRO�������[�`��
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "h_erro_handler", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );


	asm_line.set( CMNEMONIC_TYPE::PUSH, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );				// E�ɃG���[�R�[�h�������Ă���̂ŕۑ�
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "restore_h_timi", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::CALL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "restore_h_erro", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::POP, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "DE", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::JP, CCONDITION::NONE, COPERAND_TYPE::LABEL, "work_h_erro", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.subroutines.push_back( asm_line );

	//	H.ERRO�Ҕ��G���A
	asm_line.set( CMNEMONIC_TYPE::LABEL, CCONDITION::NONE, COPERAND_TYPE::LABEL, "h_erro_backup", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
	asm_line.set( CMNEMONIC_TYPE::DEFB, CCONDITION::NONE, COPERAND_TYPE::CONSTANT, "0, 0, 0, 0, 0", COPERAND_TYPE::NONE, "" );
	this->info.assembler_list.variables_area.push_back( asm_line );
}

// --------------------------------------------------------------------
void CCOMPILER::exec_subroutines( void ) {
	CASSEMBLER_LINE asm_line;

	this->exec_sub_run();
	this->exec_sub_interrupt_process();
	this->exec_sub_h_timi();
	this->exec_sub_restore_h_timi();
	this->exec_sub_on_error();
}

// --------------------------------------------------------------------
bool CCOMPILER::exec( std::string s_name ) {
	CASSEMBLER_LINE asm_line;
	CVARIABLE variable;

	this->info.p_compiler = this;

	//	DEFINT, DEFSNG, DEFDBL, DEFSTR ����������B
	//	�������V���v���ɂ��邽�߂ɁA�r���ŕς�邱�Ƃ͑z�肵�Ȃ��B
	this->info.list.reset_position();
	this->info.variable_manager.analyze_defvars( &(this->info) );

	//	�󕶎���𕶎���v�[���ɒǉ�
	CSTRING value;
	value.set( "" );
	this->info.constants.s_blank_string = this->info.constants.add( value );

	this->info.assembler_list.add_label( "work_h_timi", "0x0fd9f" );
	this->info.assembler_list.add_label( "work_h_erro", "0x0ffb1" );

	this->exec_header( s_name );
	this->exec_initializer( s_name );
	this->exec_compile_body();
	this->exec_terminator();
	this->exec_data();

	//	���荞�݃t���O
	this->info.variable_manager.put_special_variable( &(this->info), "on_interval_mode", CVARIABLE_TYPE::UNSIGNED_BYTE );
	this->info.variable_manager.put_special_variable( &(this->info), "on_interval_exec", CVARIABLE_TYPE::UNSIGNED_BYTE );
	this->info.variable_manager.put_special_variable( &(this->info), "on_interval_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_interval_value", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_interval_counter", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig0_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig1_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig2_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig3_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig4_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig5_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig6_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig7_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig0_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig1_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig2_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig3_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_strig4_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key01_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key02_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key03_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key04_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key05_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key06_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key07_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key08_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key09_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key10_mode", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key11_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key12_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key13_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key14_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key15_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key16_mode_dummy", CVARIABLE_TYPE::SINGLE_REAL );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key01_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key02_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key03_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key04_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key05_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key06_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key07_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key08_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key09_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_key10_line", CVARIABLE_TYPE::INTEGER );
	this->info.variable_manager.put_special_variable( &(this->info), "on_sprite_mode", CVARIABLE_TYPE::UNSIGNED_BYTE );
	this->info.variable_manager.put_special_variable( &(this->info), "on_sprite_exec", CVARIABLE_TYPE::UNSIGNED_BYTE );
	this->info.variable_manager.put_special_variable( &(this->info), "on_sprite_running", CVARIABLE_TYPE::UNSIGNED_BYTE );
	this->info.variable_manager.put_special_variable( &(this->info), "on_sprite_line", CVARIABLE_TYPE::INTEGER );

	//	�ϐ��_���v
	this->info.constants.dump( this->info.assembler_list, this->info.options );
	this->info.variables.dump( this->info.assembler_list, this->info.options );

	this->exec_subroutines();

	return( this->info.errors.list.size() == 0 );
}
