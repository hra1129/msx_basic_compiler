// --------------------------------------------------------------------
//	Compiler collection: Goto
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __GOTO_H__
#define __GOTO_H__

class CGOTO: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
