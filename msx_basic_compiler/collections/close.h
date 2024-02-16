// --------------------------------------------------------------------
//	Compiler collection: Close
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __CLOSE_H__
#define __CLOSE_H__

class CCLOSE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
