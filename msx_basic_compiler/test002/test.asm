; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
work_h_timi                     = 0x0fd9f
work_h_erro                     = 0x0ffb1
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
blib_iotput_str                 = 0x04024
blib_iotput_int                 = 0x04021
bios_decadd                     = 0x0269a
bios_vmovfm                     = 0x02f08
bios_vmovam                     = 0x02eef
bios_xdcomp                     = 0x02f5c
blib_iotget_int                 = 0x0401b
bios_maf                        = 0x02c4d
work_prtflg                     = 0x0f416
bios_errhand                    = 0x0406F
work_buf                        = 0x0f55e
blib_iotget_str                 = 0x0401e
bios_icomp                      = 0x02f4d
bios_gttrig                     = 0x00D8
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
        LD          HL, work_h_timi
        LD          DE, h_timi_backup
        LD          BC, 5
        LDIR        
        DI          
        LD          HL, h_timi_handler
        LD          [work_h_timi + 1], HL
        LD          A, 0xC3
        LD          [work_h_timi], A
        LD          HL, _code_ret
        LD          [svari_on_sprite_line], HL
        LD          [svari_on_interval_line], HL
        LD          [svari_on_key01_line], HL
        LD          HL, svari_on_key01_line
        LD          DE, svari_on_key01_line + 2
        LD          BC, 20 - 2
        LDIR        
        LD          HL, work_h_erro
        LD          DE, h_erro_backup
        LD          BC, 5
        LDIR        
        LD          HL, h_erro_handler
        LD          [work_h_erro + 1], HL
        LD          A, 0xC3
        LD          [work_h_erro], A
        EI          
        LD          DE, program_start
        JP          program_run
jp_hl:
        JP          HL
program_start:
line_0:
        CALL        interrupt_process
; ----------------------------------------
line_1:
        CALL        interrupt_process
; SAMPLE PROGRAM FOR MSX-BACON
line_2:
        CALL        interrupt_process
; COPYRIGHT 2023 CHIKUWA TEIKOKU
line_3:
        CALL        interrupt_process
; ----------------------------------------
line_10:
        CALL        interrupt_process
        LD          HL, vard_RF
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, vard_RC
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
line_20:
        CALL        interrupt_process
        LD          HL, str_1
        PUSH        HL
        LD          HL, str_2
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_str
        CALL        call_blib
line_30:
        CALL        interrupt_process
        LD          HL, str_3
        PUSH        HL
        LD          HL, 80
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_int
        CALL        call_blib
line_40:
        CALL        interrupt_process
        LD          HL, str_4
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_int
        CALL        call_blib
line_50:
        CALL        interrupt_process
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 100
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
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_60:
        CALL        interrupt_process
        LD          HL, str_4
        PUSH        HL
        LD          HL, vard_CN
        EX          [SP], HL
        LD          IX, blib_iotget_int
        CALL        call_blib
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcdbl
        POP         DE
        CALL        ld_de_double_real
line_70:
        CALL        interrupt_process
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 10
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
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_80:
        CALL        interrupt_process
        LD          HL, vard_CN
        CALL        push_double_real_hl
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt9
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_6
        CALL        puts
        CALL        interrupt_process
        JP          program_termination
        JP          _pt8
_pt9:
_pt8:
line_90:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_7
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_6
        CALL        puts
line_100:
        CALL        interrupt_process
        LD          HL, vars_SD
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 13
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        str_add
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 10
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        str_add
        POP         DE
        EX          DE, HL
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        free_string
line_110:
        CALL        interrupt_process
        LD          HL, str_9
        PUSH        HL
        LD          HL, [vars_SD]
        CALL        copy_string
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_str
        CALL        call_blib
line_120:
        CALL        interrupt_process
        LD          HL, vars_SD
        PUSH        HL
        LD          HL, str_10
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 13
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        str_add
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 10
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        str_add
        POP         DE
        EX          DE, HL
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        free_string
line_130:
        CALL        interrupt_process
        LD          HL, str_9
        PUSH        HL
        LD          HL, [vars_SD]
        CALL        copy_string
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_str
        CALL        call_blib
line_140:
        CALL        interrupt_process
        LD          HL, vars_SD
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 13
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 10
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        str_add
        POP         DE
        EX          DE, HL
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        free_string
line_150:
        CALL        interrupt_process
        LD          HL, str_9
        PUSH        HL
        LD          HL, [vars_SD]
        CALL        copy_string
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_str
        CALL        call_blib
line_160:
        CALL        interrupt_process
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 100
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
        LD          HL, _pt11
        LD          [svard_I_LABEL], HL
        JR          _pt10
_pt11:
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
        JR          C, _pt12
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt13
        RET         
_pt12:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt13:
        POP         HL
_pt10:
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_170:
        CALL        interrupt_process
        LD          HL, str_9
        PUSH        HL
        LD          HL, vars_RD
        EX          [SP], HL
        LD          ix, blib_iotget_str
        CALL        call_blib
        POP         DE
        EX          DE, HL
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        free_string
line_180:
        CALL        interrupt_process
        LD          HL, [vars_RD]
        CALL        copy_string
        LD          A, [HL]
        PUSH        AF
        CALL        free_string
        POP         AF
        LD          L, A
        LD          H, 0
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt15
        JP          line_220
_pt15:
_pt14:
line_190:
        CALL        interrupt_process
        LD          HL, vard_RF
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
line_200:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vars_RD]
        CALL        copy_string
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
line_210:
        CALL        interrupt_process
        JP          line_170
line_220:
        CALL        interrupt_process
        LD          HL, vard_RF
        CALL        push_double_real_hl
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, vard_RC
        CALL        push_double_real_hl
        LD          HL, 3
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _pt17
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_11
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_6
        CALL        puts
        CALL        interrupt_process
        JP          line_250
        JP          _pt16
_pt17:
_pt16:
line_230:
        CALL        interrupt_process
        LD          HL, vard_RF
        CALL        push_double_real_hl
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt19
        CALL        interrupt_process
        JP          line_250
        JP          _pt18
_pt19:
_pt18:
line_240:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_12
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_6
        CALL        puts
        CALL        interrupt_process
        LD          HL, vard_RC
        PUSH        HL
        LD          HL, vard_RC
        CALL        push_double_real_hl
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decadd
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        JP          line_170
line_250:
        CALL        interrupt_process
        LD          HL, str_4
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          IX, blib_iotput_int
        CALL        call_blib
program_termination:
        CALL        restore_h_erro
        CALL        restore_h_timi
        LD          SP, [save_stack]
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
push_double_real_hl:
        POP         BC
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        DE
        PUSH        BC
        RET         
pop_double_real_dac:
        POP         BC
        POP         HL
        LD          [work_dac+6], HL
        POP         HL
        LD          [work_dac+4], HL
        POP         HL
        LD          [work_dac+2], HL
        POP         HL
        LD          [work_dac+0], HL
        PUSH        BC
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
        LD          [heap_move_size], BC
        LD          [heap_remap_address], HL
        EX          DE, HL
        LD          HL, [heap_next]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          A, C
        OR          A, B
        JR          Z, _free_heap_loop0
        LDIR        
_free_heap_loop0:
        LD          [heap_next], DE
        LD          HL, vars_area_start
_free_heap_loop1:
        LD          DE, varsa_area_end
        RST         0x20
        JR          NC, _free_heap_loop1_end
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [heap_remap_address]
        EX          DE, HL
        RST         0x20
        JR          C, _free_heap_loop1_next
        LD          DE, [heap_move_size]
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
        JR          _free_heap_loop1
_free_heap_loop1_end:
        LD          HL, varsa_area_start
_free_heap_loop2:
        LD          DE, varsa_area_end
        RST         0x20
        RET         NC
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          C, [HL]
        INC         HL
        LD          B, 0
        ADD         HL, BC
        ADD         HL, BC
        EX          DE, HL
        SBC         HL, BC
        SBC         HL, BC
        RRC         H
        RRC         L
        LD          C, L
        LD          B, H
        EX          DE, HL
_free_heap_sarray_elements:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [heap_remap_address]
        EX          DE, HL
        RST         0x20
        JR          C, _free_heap_loop2_next
        LD          HL, [heap_move_size]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_free_heap_loop2_next:
        POP         HL
        INC         HL
        DEC         BC
        LD          A, C
        OR          A, B
        JR          NZ, _free_heap_sarray_elements
        POP         HL
        JR          _free_heap_loop2
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
str_add:
        PUSH        DE
        PUSH        HL
        LD          C, [HL]
        LD          A, [DE]
        ADD         A, C
        JR          C, _str_add_error
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        INC         HL
        LD          DE, work_buf+1
        LD          B, 0
        INC         C
        DEC         C
        JR          Z, _str_add_s1
        LDIR        
_str_add_s1:
        POP         HL
        LD          C, [HL]
        INC         HL
        INC         C
        DEC         C
        JR          Z, _str_add_s2
        LDIR        
_str_add_s2:
        LD          [work_buf], A
        POP         HL
        CALL        free_string
        POP         HL
        CALL        free_string
        LD          A, [work_buf]
        CALL        allocate_string
        PUSH        HL
        LD          DE, work_buf
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
_str_add_error:
        LD          E, 15
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
        LD          HL, var_area_start
        LD          DE, var_area_start + 1
        LD          BC, varsa_area_end - var_area_start - 1
        LD          [HL], 0
        LDIR        
        LD          HL, str_0
        LD          [vars_area_start], HL
        LD          HL, vars_area_start
        LD          DE, vars_area_start + 2
        LD          BC, vars_area_end - vars_area_start - 2
        LDIR        
        RET         
interrupt_process:
        LD          A, [svarb_on_sprite_running]
        OR          A, A
        JR          NZ, _skip_on_sprite
        LD          A, [svarb_on_sprite_exec]
        OR          A, A
        JR          Z, _skip_on_sprite
        LD          [svarb_on_sprite_running], A
        LD          HL, [svari_on_sprite_line]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        jp_hl
_on_sprite_return_address:
        POP         HL
        POP         HL
        POP         HL
        XOR         A, A
        LD          [svarb_on_sprite_running], A
_skip_on_sprite:
        LD          A, [svarb_on_interval_exec]
        DEC         A
        JR          NZ, _skip_on_interval
        LD          [svarb_on_interval_exec], A
        LD          HL, [svari_on_interval_line]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        jp_hl
        POP         HL
        POP         HL
        POP         HL
_skip_on_interval:
        LD          HL, svarf_on_strig0_mode
        LD          DE, svari_on_strig0_line
        LD          B, 5
_on_strig_loop1:
        LD          A, [HL]
        INC         HL
        DEC         A
        JR          NZ, _skip_strig1
        OR          A, [HL]
        JR          Z, _skip_strig1
        INC         HL
        INC         A
        OR          A, [HL]
        DEC         HL
        JR          NZ, _skip_strig1
        DEC         A
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        PUSH        BC
        CALL        jp_hl
        POP         BC
        POP         DE
        POP         HL
_skip_strig1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _on_strig_loop1
        LD          HL, svarf_on_key01_mode
        LD          DE, svari_on_key01_line
        LD          B, 0x0A
_on_key_loop1:
        LD          A, [HL]
        INC         HL
        AND         A, [HL]
        JR          Z, _skip_key1
        LD          [HL], 0
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        EX          DE, HL
        PUSH        DE
        PUSH        BC
        CALL        jp_hl
        POP         BC
        POP         DE
        POP         HL
_skip_key1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _on_key_loop1
        RET         
interrupt_process_end:
h_timi_handler:
        PUSH        AF
        LD          B, A
        LD          A, [svarb_on_sprite_mode]
        OR          A, A
        JR          Z, _end_of_sprite
        LD          A, B
        AND         A, 0x20
        LD          [svarb_on_sprite_exec], A
_end_of_sprite:
        LD          A, [svarb_on_interval_mode]
        OR          A, A
        JR          Z, _end_of_interval
        LD          HL, [svari_on_interval_counter]
        LD          A, L
        OR          A, H
        JR          Z, _happned_interval
        DEC         HL
        LD          [svari_on_interval_counter], HL
        JR          _end_of_interval
_happned_interval:
        LD          A, [svarb_on_interval_mode]
        DEC         A
        JR          NZ, _end_of_interval
        INC         A
        LD          [svarb_on_interval_exec], A
        LD          HL, [svari_on_interval_value]
        LD          [svari_on_interval_counter], HL
_end_of_interval:
        LD          HL, svarf_on_strig0_mode
        LD          BC, 0x0500
_on_strig_loop2:
        LD          A, [HL]
        INC         HL
        OR          A, A
        JR          Z, _skip_strig2
        LD          A, [HL]
        INC         HL
        LD          [HL], A
        DEC         HL
        LD          A, C
        PUSH        BC
        CALL        bios_gttrig
        POP         BC
        LD          [HL], A
_skip_strig2:
        INC         HL
        INC         HL
        INC         HL
        INC         C
        DJNZ        _on_strig_loop2
_end_of_strig:
        DI          
        IN          A, [0xAA]
        AND         A, 0xF0
        OR          A, 6
        LD          B, A
        OUT         [0xAA], A
        IN          A, [0xA9]
        OR          A, 0x1E
        RRCA        
        LD          C, A
        LD          A, B
        INC         A
        OUT         [0xAA], A
        IN          A, [0xA9]
        OR          A, 0xFC
        AND         A, C
        LD          C, A
        LD          HL, svarf_on_key06_mode
        LD          B, 0x90
        CALL        _on_key_sub
        LD          HL, svarf_on_key07_mode
        LD          B, 0xA0
        CALL        _on_key_sub
        LD          HL, svarf_on_key08_mode
        LD          B, 0xC0
        CALL        _on_key_sub
        LD          HL, svarf_on_key09_mode
        LD          B, 0x81
        CALL        _on_key_sub
        LD          HL, svarf_on_key10_mode
        LD          B, 0x82
        CALL        _on_key_sub
        LD          A, C
        XOR         A, 0x80
        LD          C, A
        LD          HL, svarf_on_key01_mode
        LD          B, 0x90
        CALL        _on_key_sub
        LD          HL, svarf_on_key02_mode
        LD          B, 0xA0
        CALL        _on_key_sub
        LD          HL, svarf_on_key03_mode
        LD          B, 0xC0
        CALL        _on_key_sub
        LD          HL, svarf_on_key04_mode
        LD          B, 0x81
        CALL        _on_key_sub
        LD          HL, svarf_on_key05_mode
        LD          B, 0x82
        CALL        _on_key_sub
        POP         AF
        JP          h_timi_backup
_on_key_sub:
        LD          A, [HL]
        AND         A, B
        INC         HL
        INC         HL
        LD          D, [HL]
        LD          [HL], 0
        RET         Z
        AND         A, C
        RET         NZ
        DEC         A
        LD          [HL], A
        AND         A, D
        RET         NZ
        DEC         HL
        DEC         A
        LD          [HL], A
        RET         
restore_h_timi:
        DI          
        LD          HL, h_timi_backup
        LD          DE, work_h_timi
        LD          BC, 5
        LDIR        
        EI          
        RET         
restore_h_erro:
        DI          
        LD          HL, h_erro_backup
        LD          DE, work_h_erro
        LD          BC, 5
        LDIR        
        EI          
_code_ret:
        RET         
h_erro_handler:
        PUSH        DE
        CALL        restore_h_timi
        CALL        restore_h_erro
        POP         DE
        JP          work_h_erro
const_4110000000000000:
        DEFB        0x41, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
str_0:
        DEFB        0x00
str_1:
        DEFB        0x18, 0x6D, 0x73, 0x78, 0x2F, 0x6D, 0x65, 0x2F, 0x69, 0x66, 0x2F, 0x4E, 0x45, 0x54, 0x30, 0x2F, 0x63, 0x6F, 0x6E, 0x66, 0x2F, 0x61, 0x64, 0x64, 0x72
str_10:
        DEFB        0x1D, 0x48, 0x6F, 0x73, 0x74, 0x3A, 0x20, 0x61, 0x62, 0x65, 0x68, 0x69, 0x72, 0x6F, 0x73, 0x68, 0x69, 0x2E, 0x6C, 0x61, 0x2E, 0x63, 0x6F, 0x6F, 0x63, 0x61, 0x6E, 0x2E, 0x6A, 0x70
str_11:
        DEFB        0x12, 0x55, 0x4E, 0x41, 0x42, 0x4C, 0x45, 0x20, 0x54, 0x4F, 0x20, 0x52, 0x45, 0x43, 0x45, 0x49, 0x56, 0x45, 0x2E
str_12:
        DEFB        0x0B, 0x52, 0x45, 0x54, 0x52, 0x59, 0x49, 0x4E, 0x47, 0x2E, 0x2E, 0x2E
str_2:
        DEFB        0x17, 0x61, 0x62, 0x65, 0x68, 0x69, 0x72, 0x6F, 0x73, 0x68, 0x69, 0x2E, 0x6C, 0x61, 0x2E, 0x63, 0x6F, 0x6F, 0x63, 0x61, 0x6E, 0x2E, 0x6A, 0x70
str_3:
        DEFB        0x18, 0x6D, 0x73, 0x78, 0x2F, 0x6D, 0x65, 0x2F, 0x69, 0x66, 0x2F, 0x4E, 0x45, 0x54, 0x30, 0x2F, 0x63, 0x6F, 0x6E, 0x66, 0x2F, 0x70, 0x6F, 0x72, 0x74
str_4:
        DEFB        0x16, 0x6D, 0x73, 0x78, 0x2F, 0x6D, 0x65, 0x2F, 0x69, 0x66, 0x2F, 0x4E, 0x45, 0x54, 0x30, 0x2F, 0x63, 0x6F, 0x6E, 0x6E, 0x65, 0x63, 0x74
str_5:
        DEFB        0x12, 0x43, 0x4F, 0x4E, 0x4E, 0x45, 0x43, 0x54, 0x49, 0x4F, 0x4E, 0x20, 0x46, 0x41, 0x49, 0x4C, 0x45, 0x44, 0x2E
str_6:
        DEFB        0x02, 0x0D, 0x0A
str_7:
        DEFB        0x0A, 0x43, 0x4F, 0x4E, 0x4E, 0x45, 0x43, 0x54, 0x45, 0x44, 0x2E
str_8:
        DEFB        0x15, 0x47, 0x45, 0x54, 0x20, 0x2F, 0x74, 0x6F, 0x70, 0x2E, 0x68, 0x74, 0x6D, 0x20, 0x48, 0x54, 0x54, 0x50, 0x2F, 0x31, 0x2E, 0x31
str_9:
        DEFB        0x12, 0x6D, 0x73, 0x78, 0x2F, 0x6D, 0x65, 0x2F, 0x69, 0x66, 0x2F, 0x4E, 0x45, 0x54, 0x30, 0x2F, 0x6D, 0x73, 0x67
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
svarb_on_interval_exec:
        DEFB        0
svarb_on_interval_mode:
        DEFB        0
svarb_on_sprite_exec:
        DEFB        0
svarb_on_sprite_mode:
        DEFB        0
svarb_on_sprite_running:
        DEFB        0
svard_I_FOR_END:
        DEFW        0, 0, 0, 0
svard_I_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_I_LABEL:
        DEFW        0
svarf_on_key01_mode:
        DEFW        0, 0
svarf_on_key02_mode:
        DEFW        0, 0
svarf_on_key03_mode:
        DEFW        0, 0
svarf_on_key04_mode:
        DEFW        0, 0
svarf_on_key05_mode:
        DEFW        0, 0
svarf_on_key06_mode:
        DEFW        0, 0
svarf_on_key07_mode:
        DEFW        0, 0
svarf_on_key08_mode:
        DEFW        0, 0
svarf_on_key09_mode:
        DEFW        0, 0
svarf_on_key10_mode:
        DEFW        0, 0
svarf_on_key11_mode_dummy:
        DEFW        0, 0
svarf_on_key12_mode_dummy:
        DEFW        0, 0
svarf_on_key13_mode_dummy:
        DEFW        0, 0
svarf_on_key14_mode_dummy:
        DEFW        0, 0
svarf_on_key15_mode_dummy:
        DEFW        0, 0
svarf_on_key16_mode_dummy:
        DEFW        0, 0
svarf_on_strig0_mode:
        DEFW        0, 0
svarf_on_strig1_mode:
        DEFW        0, 0
svarf_on_strig2_mode:
        DEFW        0, 0
svarf_on_strig3_mode:
        DEFW        0, 0
svarf_on_strig4_mode:
        DEFW        0, 0
svarf_on_strig5_mode_dummy:
        DEFW        0, 0
svarf_on_strig6_mode_dummy:
        DEFW        0, 0
svarf_on_strig7_mode_dummy:
        DEFW        0, 0
svari_on_interval_counter:
        DEFW        0
svari_on_interval_line:
        DEFW        0
svari_on_interval_value:
        DEFW        0
svari_on_key01_line:
        DEFW        0
svari_on_key02_line:
        DEFW        0
svari_on_key03_line:
        DEFW        0
svari_on_key04_line:
        DEFW        0
svari_on_key05_line:
        DEFW        0
svari_on_key06_line:
        DEFW        0
svari_on_key07_line:
        DEFW        0
svari_on_key08_line:
        DEFW        0
svari_on_key09_line:
        DEFW        0
svari_on_key10_line:
        DEFW        0
svari_on_sprite_line:
        DEFW        0
svari_on_strig0_line:
        DEFW        0
svari_on_strig1_line:
        DEFW        0
svari_on_strig2_line:
        DEFW        0
svari_on_strig3_line:
        DEFW        0
svari_on_strig4_line:
        DEFW        0
vard_CN:
        DEFW        0, 0, 0, 0
vard_I:
        DEFW        0, 0, 0, 0
vard_RC:
        DEFW        0, 0, 0, 0
vard_RF:
        DEFW        0, 0, 0, 0
var_area_end:
vars_area_start:
vars_RD:
        DEFW        0
vars_SD:
        DEFW        0
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
h_timi_backup:
        DEFB        0, 0, 0, 0, 0
h_erro_backup:
        DEFB        0, 0, 0, 0, 0
heap_start:
end_address:
