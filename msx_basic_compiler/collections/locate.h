// --------------------------------------------------------------------
//	Compiler collection: Locate
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __LOCATE_H__
#define __LOCATE_H__

class CLOCATE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
