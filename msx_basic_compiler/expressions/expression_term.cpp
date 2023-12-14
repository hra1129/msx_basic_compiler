// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#include <string>
#include <vector>
#include <cstdlib>
#include <cmath>
#include "expression_term.h"

// --------------------------------------------------------------------
void CEXPRESSION_TERM::set_double( double r ) {

	if( (double)(int)r == r ) {
		this->type = CEXPRESSION_TYPE::INTEGER;
		this->s_value = std::to_string( (int)r );
		return;
	}
	char s[256];
	sprintf( s, "%1.14f", r );
	int l = (int)strlen( s );
	int i;
	for( i = l-1; i > 0; i-- ) {
		if( s[i] == '.' ) continue;
		if( s[i] != '0' ) break;
	}
	if( i > 6 ) {
		this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
	}
	else {
		this->type = CEXPRESSION_TYPE::SINGLE_REAL;
	}
	this->s_value = s;
}

// --------------------------------------------------------------------
void CEXPRESSION_TERM::set_type( CEXPRESSION_TYPE type1, CEXPRESSION_TYPE type2 ) {

	if( type1 == CEXPRESSION_TYPE::DOUBLE_REAL || type2 == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		this->type = CEXPRESSION_TYPE::DOUBLE_REAL;
		return;
	}
	if( type1 == CEXPRESSION_TYPE::SINGLE_REAL || type2 == CEXPRESSION_TYPE::SINGLE_REAL ) {
		this->type = CEXPRESSION_TYPE::SINGLE_REAL;
		return;
	}
	this->type = CEXPRESSION_TYPE::INTEGER;
}

// --------------------------------------------------------------------
double CEXPRESSION_TERM::get_value( void ) {
	double d, i, r;
	int s, e;
	const char *p = this->s_value.c_str();

	//	符号
	while( isspace( *p & 255 ) ) {
		p++;
	}
	if( *p == '-' ) {
		s = -1;
		p++;
		if( *p == 0 ) return 0;
	}
	else if( *p == '+' ) {
		s = 1;
		p++;
		if( *p == 0 ) return 0;
	}
	else {
		s = 1;
	}
	//	整数部
	i = 0;
	while( isdigit( *p & 255 ) ) {
		i = (i * 10) + (*p - '0');
		p++;
	}
	if( *p == 0 ) return s * i;
	//	小数部
	r = 0;
	if( *p == '.' ) {
		p++;
		if( *p == 0 ) return s * i;
		r = 0;
		d = 1;
		while( isdigit( *p & 255 ) ) {
			r = (r * 10) + (*p - '0');
			d = d * 10;
			p++;
		}
		r = r / d;
	}
	if( *p == 0 ) return s * (i + r);
	//	指数部記号
	if( *p != 'E' && *p != 'e' && *p != 'D' && *p != 'd' ) {
		return s * (i + r);
	}
	p++;
	if( *p == 0 ) return s * (i + r);
	//	指数部
	e = std::atoi( p );
	return s * (i + r) * pow( 10., e );
}

// --------------------------------------------------------------------
CEXPRESSION_NODE* CEXPRESSION_TERM::optimization( CCOMPILE_INFO *p_info ) {
	
	//	term は、これ以上最適化できない
	return nullptr;
}

// --------------------------------------------------------------------
void CEXPRESSION_TERM::compile( CCOMPILE_INFO *p_info ) {
	CASSEMBLER_LINE asm_line;

	if( this->type == CEXPRESSION_TYPE::INTEGER ) {
		int i = 0;
		(void) sscanf( this->s_value.c_str(), "%i", &i );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, std::to_string( i ) );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::SINGLE_REAL ) {
		CSINGLE_REAL value;
		value.set( this->s_value );
		std::string s_label = p_info->constants.add( value );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::DOUBLE_REAL ) {
		CDOUBLE_REAL value;
		value.set( this->s_value );
		std::string s_label = p_info->constants.add( value );

		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
	else if( this->type == CEXPRESSION_TYPE::STRING ) {
		CSTRING value;
		value.set( this->s_value );
		std::string s_label = p_info->constants.add( value );
		asm_line.set( CMNEMONIC_TYPE::LD, CCONDITION::NONE, COPERAND_TYPE::REGISTER, "HL", COPERAND_TYPE::CONSTANT, s_label );
		p_info->assembler_list.body.push_back( asm_line );
	}
}
