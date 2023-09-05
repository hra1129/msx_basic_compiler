// --------------------------------------------------------------------
//	Compiler collection: Return
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __RETURN_H__
#define __RETURN_H__

class CRETURN: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
