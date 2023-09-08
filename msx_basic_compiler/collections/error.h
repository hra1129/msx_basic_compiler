// --------------------------------------------------------------------
//	Compiler collection: ERROR
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ERROR_H__
#define __ERROR_H__

class CERROR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
