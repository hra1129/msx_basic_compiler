// --------------------------------------------------------------------
//	Compiler collection: IRandomize
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __IRANDOMIZE_H__
#define __IRANDOMIZE_H__

class CIRANDOMIZE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
