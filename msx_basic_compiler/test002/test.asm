; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_vmovfm                     = 0x02f08
bios_neg                        = 0x02e8d
bios_frcsng                     = 0x0303a
bios_rnd                        = 0x02bdf
bios_frcdbl                     = 0x0303a
bios_fout                       = 0x03425
bios_int                        = 0x030cf
bios_sgn                        = 0x02e97
work_dac_int                    = 0x0f7f8
bios_sin                        = 0x029AC
bios_cos                        = 0x02993
bios_tan                        = 0x029FB
bios_atn                        = 0x02A14
bios_log                        = 0x02A72
bios_exp                        = 0x02b4a
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          [save_stack], SP
        CALL        check_blib
        JP          NZ, bios_syntax_error
        LD          DE, program_start
        JP          program_run
program_start:
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_rnd
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_rnd
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_4699999998765400
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_int
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_44123456
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_neg
        LD          HL, work_dac
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_sgn
        LD          HL, [work_dac + 2]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, 0
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_sgn
        LD          HL, [work_dac + 2]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_44123456
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_sgn
        LD          HL, [work_dac + 2]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_4131415926535000
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_sin
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_4131415926535000
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_cos
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcdbl
        CALL        bios_tan
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_4131415926535000
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_atn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_4127182818285000
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_log
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
        LD          HL, const_41100000
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_frcdbl
        CALL        bios_exp
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_0
        CALL        puts
program_termination:
        LD          SP, [save_stack]
        RET         
program_run:
        LD          HL, heap_start
        LD          [heap_next], HL
        LD          HL, [save_stack]
        LD          SP, HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        SBC         HL, DE
        LD          [heap_end], HL
        RET         
check_blib:
        LD          a, [work_blibslot]
        LD          h, 0x40
        CALL        bios_enaslt
        LD          bc, 8
        LD          hl, signature
        LD          de, signature_ref
_check_blib_loop:
        LD          a, [de]
        INC         de
        CPI         
        JR          NZ, _check_blib_exit
        JP          PE, _check_blib_loop
_check_blib_exit:
        PUSH        af
        LD          a, [work_mainrom]
        LD          h, 0x40
        CALL        bios_enaslt
        EI          
        POP         af
        RET         
signature_ref:
        DEFB        "BACONLIB"
call_blib:
        LD          iy, [work_blibslot - 1]
        JP          bios_calslt
puts:
        LD          B, [HL]
_puts_loop:
        INC         HL
        LD          A, [HL]
        RST         0x18
        DJNZ        _puts_loop
        RET         
str:
        CALL        bios_fout
        DEC         HL
        PUSH        HL
        XOR         A, A
        LD          B, A
_str_loop:
        INC         HL
        CP          A, [HL]
        JR          Z, _str_loop_exit
        INC         B
        JR          _str_loop
_str_loop_exit:
        POP         HL
        LD          [HL], B
        RET         
ld_dac_double_real:
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        RET         
const_41100000:
        DEFB        0x41, 0x10, 0x00, 0x00
const_44123456:
        DEFB        0x44, 0x12, 0x34, 0x56
const_4127182818285000:
        DEFB        0x41, 0x27, 0x18, 0x28, 0x18, 0x28, 0x50, 0x00
const_4131415926535000:
        DEFB        0x41, 0x31, 0x41, 0x59, 0x26, 0x53, 0x50, 0x00
const_4699999998765400:
        DEFB        0x46, 0x99, 0x99, 0x99, 0x98, 0x76, 0x54, 0x00
str_0:
        DEFB        0x02, 0x0D, 0x0A
save_stack:
        DEFW        0
heap_next:
        DEFW        0
heap_end:
        DEFW        0
heap_move_size:
        DEFW        0
heap_remap_address:
        DEFW        0
var_area_start:
var_area_end:
vars_area_start:
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
