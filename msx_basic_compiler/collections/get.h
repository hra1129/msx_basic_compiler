// --------------------------------------------------------------------
//	Compiler collection: Get
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __GET_H__
#define __GET_H__

class CGET: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
