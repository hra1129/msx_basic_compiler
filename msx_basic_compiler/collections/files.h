// --------------------------------------------------------------------
//	Compiler collection: Files
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __FILES_H__
#define __FILES_H__

class CFILES: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
