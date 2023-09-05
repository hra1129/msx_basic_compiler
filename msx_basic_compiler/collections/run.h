// --------------------------------------------------------------------
//	Compiler collection: Run
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __RUN_H__
#define __RUN_H__

class CRUN: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
