// --------------------------------------------------------------------
//	Compiler collection: DefFn
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DEFFN_H__
#define __DEFFN_H__

class CDEFFN: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
