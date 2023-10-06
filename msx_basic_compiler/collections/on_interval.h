// --------------------------------------------------------------------
//	Compiler collection: On Interval
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __ON_INTERVAL_H__
#define __ON_INTERVAL_H__

class CONINTERVAL: public CCOMPILER_CONTAINER {
private:
	void interval( CCOMPILE_INFO *p_info );

public:
	bool exec( CCOMPILE_INFO *p_info );
};

#endif
