// --------------------------------------------------------------------
//	MSX-BASIC 倍精度度実数
// ====================================================================
//	2023/Aug/14th  t.hara 
// --------------------------------------------------------------------

#include "double_real.h"
#include <cstring>

//	倍精度実数の有効桁数 14, 四捨五入のための 1桁
constexpr int MANTISSA_MAX = 14 + 1;

// --------------------------------------------------------------------
bool CDOUBLE_REAL::set( std::string s ) {
	size_t i = 0;
	int sign, exponent_offset, exponent_sign, exponent;
	int mantissa[MANTISSA_MAX], mi;
	bool has_dot = false;
	bool is_zero = true;

	//	符号
	if( i < s.size() && s[i] == '-' ) {
		sign = 0x80;
		i++;
	}
	else {
		sign = 0x00;
	}
	//	数字.数字の桁を読む
	mi = 0;
	exponent_offset = 0;
	memset( mantissa, 0, sizeof(mantissa) );
	while( i < s.size() ) {
		if( isdigit(s[i] & 255) ) {
			if( is_zero ) {
				if( s[i] != '0' ) {
					is_zero = false;
				}
			}
			if( !is_zero ) {
				if( mi < MANTISSA_MAX ) {
					mantissa[mi] = s[i] - '0';
					mi++;
				}
				if( !has_dot ) {
					exponent_offset++;
				}
			}
		}
		else if( s[i] == '.' ) {
			if( has_dot ) {
				//	小数点が2つ以上存在する場合エラー
				return false;
			}
			has_dot = true;
			is_zero = false;
		}
		else {
			break;
		}
		i++;
	}
	//	E+xx, D+xx の記述を読む
	exponent = 0;
	if( i < s.size() && (toupper( s[i] & 255 ) == 'E' || toupper( s[i] & 255 ) == 'D') ) {
		i++;
		exponent_sign = 1;
		if( i < s.size() ) {
			if( s[i] == '+' ) {
				exponent_sign = 1;
				i++;
			}
			else if( s[i] == '-' ) {
				exponent_sign = -1;
				i++;
			}
		}
		while( i < s.size() ) {
			if( !isdigit( s[i] & 255 ) ) {
				break;
			}
			exponent = exponent * 10 + (s[i] - '0');
			i++;
			if( exponent > 63 ) {
				break;
			}
		}
		exponent = exponent_sign * exponent;
	}
	exponent += exponent_offset;
	//	四捨五入
	if( mantissa[MANTISSA_MAX - 1] >= 5 ) {
		//	繰り上げ
		for( mi = 0; mi < MANTISSA_MAX - 1; mi++ ) {
			if( mantissa[mi] != 9 ) {
				break;
			}
		}
		if( mi == (MANTISSA_MAX - 1) ) {
			//	全桁 9 で繰り上がりが発生した場合、exponent を1桁下げて 1000... にする
			mantissa[0] = 0;
			for( mi = 1; mi < MANTISSA_MAX - 1; mi++ ) {
				mantissa[mi] = 0;
			}
			exponent--;
		}
		else {
			//	繰り上がりに伴うインクリメント
			for( mi = MANTISSA_MAX - 2; mi >= 0; mi-- ) {
				mantissa[mi]++;
				if( mantissa[mi] == 10 ) {
					mantissa[mi] = 0;
				}
				else {
					break;
				}
			}
		}
	}
	if( exponent > 63 ) {
		//	オーバーフロー
		return false;
	}
	//	変換結果を所望のフォーマットに格納する
	this->image[0] = sign | (64 + exponent);
	for( i = 1, mi = 0; mi < MANTISSA_MAX - 2; i++, mi += 2 ) {
		this->image[i] = (mantissa[mi] << 4) + mantissa[mi+1];
	}
	return true;
}
