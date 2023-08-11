// --------------------------------------------------------------------
//	Expression
// ====================================================================
//	2023/July/29th	t.hara
// --------------------------------------------------------------------
#pragma once

#include <string>
#include <vector>
#include "expression_operator_imp.h"

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_IMP::optimization( void ) {
	
}

// --------------------------------------------------------------------
void CEXPRESSION_OPERATOR_IMP::compile( CCOMPILE_INFO *p_this ) {

	//	æ‚É€‚ðˆ—
	this->p_left->compile( p_this );
	this->p_right->compile( p_this );

	//	‚±‚Ì‰‰ŽZŽq‚Ì‰‰ŽZŒ‹‰Ê‚ÌŒ^‚ðŒˆ‚ß‚é
	if( this->p_left->type == CEXPRESSION_TYPE::STRING || this->p_right->type == CEXPRESSION_TYPE::STRING ) {
		//	‚±‚Ì‰‰ŽZŽq‚Í•¶Žš—ñŒ^‚É‚Í“K—p‚Å‚«‚È‚¢
		p_this->errors.add( TYPE_MISMATCH, p_this->list.get_line_no() );
		return;
	}
	else if( this->p_left->type == this->p_right->type ) {
		//	¶‰E‚Ì€‚ª“¯‚¶Œ^‚È‚çA‚»‚ÌŒ^‚ðŒp³
		this->type = this->p_left->type;
	}
	else if( this->p_left->type > this->p_right->type ) {
		//	¶‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚Å¶‚ðÌ—p
		this->type = this->p_left->type;
	}
	else {
		//	‰E‚Ì•û‚ªŒ^‚ª‘å‚«‚¢‚Ì‚Å‰E‚ðÌ—p
		this->type = this->p_right->type;
	}
}
