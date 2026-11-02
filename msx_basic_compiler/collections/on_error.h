// --------------------------------------------------------------------
//	Compiler collection: On Error
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ON_ERROR_H__
#define __ON_ERROR_H__

class CONERROR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
