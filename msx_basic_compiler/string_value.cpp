// --------------------------------------------------------------------
//	MSX-BASIC •¶Žš—ñ
// ====================================================================
//	2023/Aug/14th  t.hara 
// --------------------------------------------------------------------

#include "string_value.h"

// --------------------------------------------------------------------
bool CSTRING::set( std::string s ) {
	size_t i;

	if( s.size() > 255 ) {
		//	’·‚·‚¬‚é
		return false;
	}
	this->length = s.size();
	memset( this->image, 0, sizeof( this->image ) );
	for( i = 0; i < this->length; i++ ) {
		this->image[i] = s[i];
	}
	return true;
}

// --------------------------------------------------------------------
bool CSTRING::set( int length, const char *p_image ) {

	if( length > 255 ) {
		//	’·‚·‚¬‚é
		return false;
	}
	this->length = length;
	memset( this->image, 0, sizeof( this->image ) );
	memcpy( this->image, p_image, length );
}
