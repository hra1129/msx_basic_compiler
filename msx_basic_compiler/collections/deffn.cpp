// --------------------------------------------------------------------
//	Compiler collection: DefFn
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------

#include "deffn.h"

// --------------------------------------------------------------------
//  DEF FN<名前>(<仮引数>) = <式>
//	定義は analyze_deffn() で事前登録済み。本体は呼び出し側で
//	インライン展開されるため、この文自体はコードを生成しない。
//	文末まで読み飛ばすだけである。
bool CDEFFN::exec( CCOMPILE_INFO *p_info ) {
	int line_no = p_info->list.get_line_no();

	if( p_info->list.p_position->s_word != "DEF" ) {
		return false;
	}
	if( (p_info->list.p_position + 1)->s_word != "FN" ) {
		return false;		//	DEF USR などは CDEFUSR に任せる
	}
	//	式 (本体) を含めて文末まで読み飛ばす
	while( !p_info->list.is_command_end() ) {
		p_info->list.p_position++;
	}
	(void) line_no;
	return true;
}
