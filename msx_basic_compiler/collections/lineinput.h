// --------------------------------------------------------------------
//	Compiler collection: LineInput
// ====================================================================
//	2026/Nov/2nd	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __LINEINPUT_H__
#define __LINEINPUT_H__

class CLINEINPUT: public CCOMPILER_CONTAINER {
public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
