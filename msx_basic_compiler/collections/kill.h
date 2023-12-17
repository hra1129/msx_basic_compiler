// --------------------------------------------------------------------
//	Compiler collection: Kill
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __KILL_H__
#define __KILL_H__

class CKILL: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
