# --------------------------------------------------------------------
#	MSX-BACON Linux build (Makefile)
#
#	compile.sh と同じソース・同じコンパイル/リンクフラグでビルドします。
#	compile.sh との違いは次の点です。
#	・オブジェクトをこのディレクトリの obj/ 以下に分けて置く
#	  （ツリー内の他のビルド方法とオブジェクトが混ざらないようにするため）
#	・-MMD -MP でヘッダ依存関係を記録し、増分ビルドができる
#	・make -j で並列ビルドができる
#	使い方も compile.sh と同じく、このディレクトリで実行してください。
# --------------------------------------------------------------------

CXX			:= g++
CXXFLAGS	:= -O2 -std=c++17 -W
CPPFLAGS	:= -I.. -I../assembler -I../collections -I../expressions
DEPFLAGS	:= -MMD -MP

TARGET		:= msx_bacon
OBJDIR		:= obj

SOURCES		:= $(wildcard ../assembler/*.cpp) \
			   $(wildcard ../collections/*.cpp) \
			   $(wildcard ../expressions/*.cpp) \
			   $(wildcard ../*.cpp)
OBJECTS		:= $(patsubst ../%.cpp,$(OBJDIR)/%.o,$(SOURCES))
DEPS		:= $(OBJECTS:.o=.d)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) -O2 $(OBJECTS) -o $@

$(OBJDIR)/%.o: ../%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJDIR) $(TARGET)

-include $(DEPS)
