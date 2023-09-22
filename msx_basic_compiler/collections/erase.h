// --------------------------------------------------------------------
//	Compiler collection: Erase
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ERASE_H__
#define __ERASE_H__

class CERASE: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
