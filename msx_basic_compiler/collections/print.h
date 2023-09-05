// --------------------------------------------------------------------
//	Compiler collection: Print
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __PRINT_H__
#define __PRINT_H__

class CPRINT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
