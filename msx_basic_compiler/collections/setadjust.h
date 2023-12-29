// --------------------------------------------------------------------
//	Compiler collection: SetAdjust
// ====================================================================
//	2023/Dec/29th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETADJUST_H__
#define __SETADJUST_H__

class CSETADJUST: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
