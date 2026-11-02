// --------------------------------------------------------------------
//	Compiler collection: Resume
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __RESUME_H__
#define __RESUME_H__

class CRESUME: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
