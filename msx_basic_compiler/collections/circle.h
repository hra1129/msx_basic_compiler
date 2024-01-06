// --------------------------------------------------------------------
//	Compiler collection: Circle
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __CIRCLE_H__
#define __CIRCLE_H__

class CCIRCLE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
