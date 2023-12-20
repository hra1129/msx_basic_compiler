// --------------------------------------------------------------------
//	Compiler collection: On Stop
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ON_STOP_H__
#define __ON_STOP_H__

class CONSTOP: public CCOMPILER_CONTAINER {
private:
	void stop( CCOMPILE_INFO *p_info );

public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
