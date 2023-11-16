// --------------------------------------------------------------------
//	Compiler collection: Input
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __INPUT_H__
#define __INPUT_H__

class CINPUT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
