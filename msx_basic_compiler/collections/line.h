// --------------------------------------------------------------------
//	Compiler collection: Line
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __LINE_H__
#define __LINE_H__

class CLINE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
