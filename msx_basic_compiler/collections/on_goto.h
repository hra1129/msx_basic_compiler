// --------------------------------------------------------------------
//	Compiler collection: On Goto
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ON_GOTO_H__
#define __ON_GOTO_H__

class CONGOTO: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
