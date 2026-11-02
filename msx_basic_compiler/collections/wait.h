// --------------------------------------------------------------------
//	Compiler collection: Wait
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __WAIT_H__
#define __WAIT_H__

class CWAIT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
