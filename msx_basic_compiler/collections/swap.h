// --------------------------------------------------------------------
//	Compiler collection: Swap
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __SWAP_H__
#define __SWAP_H__

class CSWAP: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
