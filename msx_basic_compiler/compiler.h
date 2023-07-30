// --------------------------------------------------------------------
//	Compiler
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
	int current_line_no;

public:
	CERROR_LIST *p_errors;
	std::vector< CBASIC_WORD > words;
	std::vector< CBASIC_WORD >::const_iterator p_position;
	std::vector< std::string > header;
	std::vector< std::string > body;
	std::vector< std::string > datas;
	std::vector< std::string > variables;
	std::vector< std::string > footer;

	void update_current_line_no( void ) {
		if( this->is_end() ) {
			this->current_line_no = -1;
			return;
		}
		this->current_line_no = p_position->line_no; 
	}

	int get_line_no( void ) const {
		return this->current_line_no;
	}

	bool is_end( void );
	bool is_line_end( void );

	void initialize( void );

	~CCOMPILER() {
		for( auto p: this->collection ) {
			delete p;
			p = nullptr;
		}
	}

	bool exec( CBASIC_LIST &list );
};
