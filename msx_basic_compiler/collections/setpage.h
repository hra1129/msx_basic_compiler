// --------------------------------------------------------------------
//	Compiler collection: SetPage
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SETPAGE_H__
#define __SETPAGE_H__

class CSETPAGE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
