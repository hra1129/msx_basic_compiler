// --------------------------------------------------------------------
//	MSX-BASIC �{���x�x����
// ====================================================================
//	2023/Aug/14th  t.hara 
// --------------------------------------------------------------------

#include "double_real.h"
#include <cstring>

//	�{���x�����̗L������ 14, �l�̌ܓ��̂��߂� 1��
constexpr int MANTISSA_MAX = 14 + 1;

// --------------------------------------------------------------------
bool CDOUBLE_REAL::set( std::string s ) {
	size_t i = 0;
	int sign, exponent_offset, exponent_sign, exponent;
	int mantissa[MANTISSA_MAX], mi;
	bool has_dot = false;
	bool is_zero = true;

	//	����
	if( i < s.size() && s[i] == '-' ) {
		sign = 0x80;
		i++;
	}
	else {
		sign = 0x00;
	}
	//	����.�����̌���ǂ�
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
				//	�����_��2�ȏ㑶�݂���ꍇ�G���[
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
	//	E+xx, D+xx �̋L�q��ǂ�
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
	//	�l�̌ܓ�
	if( mantissa[MANTISSA_MAX - 1] >= 5 ) {
		//	�J��グ
		for( mi = 0; mi < MANTISSA_MAX - 1; mi++ ) {
			if( mantissa[mi] != 9 ) {
				break;
			}
		}
		if( mi == (MANTISSA_MAX - 1) ) {
			//	�S�� 9 �ŌJ��オ�肪���������ꍇ�Aexponent ��1�������� 1000... �ɂ���
			mantissa[0] = 0;
			for( mi = 1; mi < MANTISSA_MAX - 1; mi++ ) {
				mantissa[mi] = 0;
			}
			exponent--;
		}
		else {
			//	�J��オ��ɔ����C���N�������g
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
		//	�I�[�o�[�t���[
		return false;
	}
	//	�ϊ����ʂ����]�̃t�H�[�}�b�g�Ɋi�[����
	this->image[0] = sign | (64 + exponent);
	for( i = 1, mi = 0; mi < MANTISSA_MAX - 2; i++, mi += 2 ) {
		this->image[i] = (mantissa[mi] << 4) + mantissa[mi+1];
	}
	return true;
}
