// --------------------------------------------------------------------
//	Compiler collection: SetDateTime
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETDATETIME_H__
#define __SETDATETIME_H__

class CSETDATETIME: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
