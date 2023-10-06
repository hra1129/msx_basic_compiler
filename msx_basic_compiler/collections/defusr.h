// --------------------------------------------------------------------
//	Compiler collection: DefUsr
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __DEFUSR_H__
#define __DEFUSR_H__

class CDEFUSR: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
