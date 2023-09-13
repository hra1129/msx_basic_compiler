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
work_dac                        = 0x0f7f6
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
bios_frcdbl                     = 0x0303a
bios_decadd                     = 0x0269a
bios_vmovfm                     = 0x02f08
bios_vmovam                     = 0x02eef
bios_xdcomp                     = 0x02f5c
bios_errhand                    = 0x0406F
bios_fin                        = 0x3299
work_csrx                       = 0x0f3dd
work_linlen                     = 0x0f3b0
bios_fout                       = 0x03425
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
jp_hl:
        JP          HL
program_start:
line_100:
; TEST
line_120:
        LD          HL, vard_A
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, data_110
        LD          [data_ptr], HL
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 9
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_STEP
        PUSH        HL
        LD          HL, const_4110000000000000
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt1
        LD          [svard_I_LABEL], HL
        JR          _pt0
_pt1:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_I
        CALL        bios_vmovfm
        LD          HL, svard_I_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_I
        LD          BC, 8
        LDIR        
        LD          HL, svard_I_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_I_FOR_STEP]
        RLCA        
        JR          C, _pt2
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt3
        RET         
_pt2:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt3:
        POP         HL
_pt0:
        LD          HL, vars_A
        EX          DE, HL
        LD          HL, [data_ptr]
        LD          C, [HL]
        INC         HL
        LD          B, [HL]
        INC         HL
        LD          [data_ptr], HL
        EX          DE, HL
        LD          [HL], C
        INC         HL
        LD          [HL], B
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_8
        CALL        puts
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
        LD          HL, data_110
        LD          [data_ptr], HL
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 2
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_STEP
        PUSH        HL
        LD          HL, const_4110000000000000
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt5
        LD          [svard_I_LABEL], HL
        JR          _pt4
_pt5:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_I
        CALL        bios_vmovfm
        LD          HL, svard_I_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_I
        LD          BC, 8
        LDIR        
        LD          HL, svard_I_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_I_FOR_STEP]
        RLCA        
        JR          C, _pt6
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt7
        RET         
_pt6:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt7:
        POP         HL
_pt4:
        LD          HL, vard_A
        PUSH        HL
        LD          HL, [data_ptr]
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          [data_ptr], HL
        EX          DE, HL
        INC         HL
        LD          A, [HL]
        CALL        bios_fin
        CALL        bios_frcdbl
        POP         DE
        LD          HL, work_dac
        CALL        ld_de_double_real
        LD          HL, vard_A
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt8
        PUSH        HL
        LD          HL, str_8
        CALL        puts
        POP         HL
_pt8:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_8
        CALL        puts
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
        LD          HL, data_120
        LD          [data_ptr], HL
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 2
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_STEP
        PUSH        HL
        LD          HL, const_4110000000000000
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt10
        LD          [svard_I_LABEL], HL
        JR          _pt9
_pt10:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_I
        CALL        bios_vmovfm
        LD          HL, svard_I_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_I
        LD          BC, 8
        LDIR        
        LD          HL, svard_I_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_I_FOR_STEP]
        RLCA        
        JR          C, _pt11
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt12
        RET         
_pt11:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt12:
        POP         HL
_pt9:
        LD          HL, vard_A
        PUSH        HL
        LD          HL, [data_ptr]
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          [data_ptr], HL
        EX          DE, HL
        INC         HL
        LD          A, [HL]
        CALL        bios_fin
        CALL        bios_frcdbl
        POP         DE
        LD          HL, work_dac
        CALL        ld_de_double_real
        LD          HL, vard_A
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt13
        PUSH        HL
        LD          HL, str_8
        CALL        puts
        POP         HL
_pt13:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_8
        CALL        puts
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
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
ld_de_double_real:
        LD          BC, 8
        LDIR        
        RET         
puts:
        LD          B, [HL]
        INC         B
        DEC         B
        RET         Z
_puts_loop:
        INC         HL
        LD          A, [HL]
        RST         0x18
        DJNZ        _puts_loop
        RET         
allocate_string:
        LD          HL, [heap_next]
        PUSH        HL
        LD          E, A
        LD          C, A
        LD          D, 0
        ADD         HL, DE
        INC         HL
        LD          DE, [heap_end]
        RST         0x20
        JR          NC, _allocate_string_error
        LD          [heap_next], HL
        POP         HL
        LD          [HL], C
        RET         
_allocate_string_error:
        LD          E, 7
        JP          bios_errhand
copy_string:
        LD          A, [HL]
        PUSH        HL
        CALL        allocate_string
        POP         DE
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
free_string:
        LD          DE, heap_start
        RST         0x20
        RET         C
        LD          DE, [heap_next]
        RST         0x20
        RET         NC
        LD          C, [HL]
        LD          B, 0
        INC         BC
        JP          free_heap
free_heap:
        PUSH        HL
        ADD         HL, BC
        LD          [heap_remap_address], HL
        LD          [heap_move_size], BC
        EX          DE, HL
        LD          HL, [heap_next]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         DE
        LD          HL, [heap_remap_address]
        LD          A, C
        OR          A, B
        JR          Z, _free_heap_loop0
        LDIR        
_free_heap_loop0:
        LD          [heap_next], DE
        LD          HL, vars_area_start
_free_heap_loop1:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [heap_remap_address]
        EX          DE, HL
        RST         0x20
        JR          C, _free_heap_loop1_next
        LD          HL, [heap_move_size]
        EX          DE, HL
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_free_heap_loop1_next:
        POP         HL
        INC         HL
        LD          DE, varsa_area_end
        RST         0x20
        JR          C, _free_heap_loop1
        RET         
str:
        CALL        bios_fout
fout_adjust:
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
data_110:
        DEFW        str_0
        DEFW        str_1
        DEFW        str_2
        DEFW        str_3
        DEFW        str_4
        DEFW        str_0
data_120:
        DEFW        str_5
        DEFW        str_6
data_140:
        DEFW        str_7
const_4110000000000000:
        DEFB        0x41, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
str_0:
        DEFB        0x03, 0x31, 0x32, 0x33
str_1:
        DEFB        0x05, 0x26, 0x48, 0x46, 0x30, 0x30
str_2:
        DEFB        0x03, 0x41, 0x42, 0x43
str_3:
        DEFB        0x03, 0x44, 0x45, 0x46
str_4:
        DEFB        0x02, 0x2D, 0x31
str_5:
        DEFB        0x02, 0x31, 0x30
str_6:
        DEFB        0x02, 0x32, 0x30
str_7:
        DEFB        0x08, 0x52, 0x45, 0x4D, 0x20, 0x54, 0x45, 0x53, 0x54
str_8:
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
data_ptr:
        DEFW        data_110
var_area_start:
svard_I_FOR_END:
        DEFW        0, 0, 0, 0
svard_I_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_I_LABEL:
        DEFW        0
vard_A:
        DEFW        0, 0, 0, 0
vard_I:
        DEFW        0, 0, 0, 0
var_area_end:
vars_area_start:
vars_A:
        DEFW        0
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
