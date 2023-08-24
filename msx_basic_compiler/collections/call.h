// --------------------------------------------------------------------
//	Compiler collection: Call
// ====================================================================
//	2023/July/25th	t.hara
// --------------------------------------------------------------------
#include "../compiler.h"

#ifndef __CALL_H__
#define __CALL_H__

class CCALL: public CCOMPILER_CONTAINER {
private:
	//	サブルーチン生成
	void iot_set_device_path( CCOMPILE_INFO *p_this );
	void iot_get_integer( CCOMPILE_INFO *p_this );
	void iot_get_string( CCOMPILE_INFO *p_this );
	//	コマンド処理
	void iotget( CCOMPILE_INFO *p_this );
public:
	bool exec( CCOMPILE_INFO *p_this );
};

#endif
