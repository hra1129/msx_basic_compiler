// --------------------------------------------------------------------
//	Compiler
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include "compile_info.h"

#ifndef __CCOMPILER_H__
#define __CCOMPILER_H__

// --------------------------------------------------------------------
class CCOMPILER {
private:
	std::vector< CCOMPILER_CONTAINER* > collection;

	void initialize( void );

public:
	CCOMPILE_INFO info;

	CCOMPILER() {
		initialize();
	}

	~CCOMPILER() {
		for( auto p: this->collection ) {
			delete p;
			p = nullptr;
		}
	}

	bool exec( void );
};

#endif
