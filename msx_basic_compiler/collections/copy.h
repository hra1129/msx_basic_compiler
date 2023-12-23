// --------------------------------------------------------------------
//	Compiler collection: Copy
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __COPY_H__
#define __COPY_H__

class CCOPY: public CCOMPILER_CONTAINER {
private:
	bool get_x3_y3( CCOMPILE_INFO *p_info );
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
