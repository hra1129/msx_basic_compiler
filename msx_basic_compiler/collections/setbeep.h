// --------------------------------------------------------------------
//	Compiler collection: SetBeep
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETBEEP_H__
#define __SETBEEP_H__

class CSETBEEP: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
