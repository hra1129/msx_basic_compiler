SRCS =	assembler/assembler_line.cpp \
	assembler/assembler_list.cpp \
	basic_list.cpp \
	collections/beep.cpp \
	collections/bload.cpp \
	collections/bsave.cpp \
	collections/call.cpp \
	collections/clear.cpp \
	collections/cls.cpp \
	collections/color.cpp \
	collections/comment.cpp \
	collections/data.cpp \
	collections/defdbl.cpp \
	collections/defint.cpp \
	collections/defsng.cpp \
	collections/defstr.cpp \
	collections/defusr.cpp \
	collections/dim.cpp \
	collections/end.cpp \
	collections/erase.cpp \
	collections/error.cpp \
	collections/files.cpp \
	collections/for.cpp \
	collections/gosub.cpp \
	collections/goto.cpp \
	collections/if.cpp \
	collections/input.cpp \
	collections/irandomize.cpp \
	collections/key.cpp \
	collections/kill.cpp \
	collections/let.cpp \
	collections/line.cpp \
	collections/locate.cpp \
	collections/lset.cpp \
	collections/mid.cpp \
	collections/name.cpp \
	collections/next.cpp \
	collections/on_goto.cpp \
	collections/on_interval.cpp \
	collections/on_key.cpp \
	collections/on_sprite.cpp \
	collections/on_stop.cpp \
	collections/on_strig.cpp \
	collections/out.cpp \
	collections/play.cpp \
	collections/poke.cpp \
	collections/pokes.cpp \
	collections/pokew.cpp \
	collections/print.cpp \
	collections/pset.cpp \
	collections/put_sprite.cpp \
	collections/read.cpp \
	collections/restore.cpp \
	collections/return.cpp \
	collections/run.cpp \
	collections/screen.cpp \
	collections/setpage.cpp \
	collections/setscroll.cpp \
	collections/sound.cpp \
	collections/swap.cpp \
	collections/vpoke.cpp \
	collections/vpokes.cpp \
	collections/width.cpp \
	compiler.cpp \
	double_real.cpp \
	error_list.cpp \
	expressions/expression.cpp \
	expressions/expression_abs.cpp \
	expressions/expression_asc.cpp \
	expressions/expression_atn.cpp \
	expressions/expression_base.cpp \
	expressions/expression_bin.cpp \
	expressions/expression_cdbl.cpp \
	expressions/expression_chr.cpp \
	expressions/expression_chrhex.cpp \
	expressions/expression_cint.cpp \
	expressions/expression_cos.cpp \
	expressions/expression_csng.cpp \
	expressions/expression_csrlin.cpp \
	expressions/expression_cvd.cpp \
	expressions/expression_cvi.cpp \
	expressions/expression_cvs.cpp \
	expressions/expression_exp.cpp \
	expressions/expression_fix.cpp \
	expressions/expression_fre.cpp \
	expressions/expression_function.cpp \
	expressions/expression_hex.cpp \
	expressions/expression_hexchr.cpp \
	expressions/expression_inkey.cpp \
	expressions/expression_inp.cpp \
	expressions/expression_input.cpp \
	expressions/expression_instr.cpp \
	expressions/expression_int.cpp \
	expressions/expression_irnd.cpp \
	expressions/expression_left.cpp \
	expressions/expression_len.cpp \
	expressions/expression_log.cpp \
	expressions/expression_mid.cpp \
	expressions/expression_mkd.cpp \
	expressions/expression_mki.cpp \
	expressions/expression_mks.cpp \
	expressions/expression_msxver.cpp \
	expressions/expression_oct.cpp \
	expressions/expression_operator_add.cpp \
	expressions/expression_operator_and.cpp \
	expressions/expression_operator_div.cpp \
	expressions/expression_operator_equ.cpp \
	expressions/expression_operator_eqv.cpp \
	expressions/expression_operator_ge.cpp \
	expressions/expression_operator_gt.cpp \
	expressions/expression_operator_imp.cpp \
	expressions/expression_operator_intdiv.cpp \
	expressions/expression_operator_le.cpp \
	expressions/expression_operator_lt.cpp \
	expressions/expression_operator_minus.cpp \
	expressions/expression_operator_mod.cpp \
	expressions/expression_operator_mul.cpp \
	expressions/expression_operator_neq.cpp \
	expressions/expression_operator_not.cpp \
	expressions/expression_operator_or.cpp \
	expressions/expression_operator_power.cpp \
	expressions/expression_operator_sub.cpp \
	expressions/expression_operator_xor.cpp \
	expressions/expression_pad.cpp \
	expressions/expression_peek.cpp \
	expressions/expression_peeks.cpp \
	expressions/expression_peekw.cpp \
	expressions/expression_right.cpp \
	expressions/expression_rnd.cpp \
	expressions/expression_sgn.cpp \
	expressions/expression_sin.cpp \
	expressions/expression_space.cpp \
	expressions/expression_sqr.cpp \
	expressions/expression_stick.cpp \
	expressions/expression_str.cpp \
	expressions/expression_strig.cpp \
	expressions/expression_string.cpp \
	expressions/expression_tan.cpp \
	expressions/expression_term.cpp \
	expressions/expression_time.cpp \
	expressions/expression_usr.cpp \
	expressions/expression_val.cpp \
	expressions/expression_variable.cpp \
	expressions/expression_varptr.cpp \
	expressions/expression_vdp.cpp \
	expressions/expression_vpeek.cpp \
	expressions/expression_vpeeks.cpp \
	msx_basic_compiler.cpp \
	single_real.cpp \
	string_value.cpp \
	variable_manager.cpp \

OBJS    = $(SRCS:.cpp=.o)
CC      = g++
CFLAGS  = -std=c++1y -Wno-delete-abstract-non-virtual-dtor -Wno-deprecated-declarations
TARGET  = msx_bacon

$(TARGET): $(OBJS)
	$(CC) -o $@ $^

%.o: %.cpp
	$(CC) $(CFLAGS) -c -o $@ $<

all: clean
#	time make -j9 $(TARGET) > make.log 2>&1
	time make -j9 $(TARGET) 2>&1 | tee make.log
mk:
	python makefile_gen.py
clean:
	-rm -f $(OBJS) $(TARGET) make.log
install:
	cp msx_bacon /opt/homebrew/bin/.
uninstall:
	rm /opt/homebrew/bin/msx_bacon
