// --------------------------------------------------------------------
//	Error list
// ====================================================================
//	2023/July/23rd	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "basic_code_loader.h"
#include "variable_manager.h"

// --------------------------------------------------------------------
class CCOMPILER_CONTAINER {
public:
	// --------------------------------------------------------------------
	//	このコンテナが対応する記述だけをコンパイルする
	//	このコンテナが対応する記述だった場合は、true を返す
	virtual bool exec( class CCOMPILER *p_this ) = 0;
};

// --------------------------------------------------------------------
class CCOMPILER {
private:
	std::vector< CCOMPILER_CONTAINER* > collection;
	CVARIABLE_MANAGER vm;

public:
	CERROR_LIST *p_errors;

	bool is_end( void );
	std::vector< CBASIC_WORD > words;
	std::vector< CBASIC_WORD >::const_iterator p_position;

	std::vector< std::string > header;
	std::vector< std::string > body;
	std::vector< std::string > datas;
	std::vector< std::string > variables;
	std::vector< std::string > footer;

	void initialize( void );

	~CCOMPILER() {
		for( auto p: this->collection ) {
			delete p;
			p = nullptr;
		}
	}

	bool exec( CBASIC_LIST &list );
};
