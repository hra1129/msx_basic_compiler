; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
work_h_timi                     = 0x0fd9f
work_h_erro                     = 0x0ffb1
blib_init_ncalbas               = 0x0404e
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
bios_chgmodp                    = 0x001B5
bios_extrom                     = 0x0015F
work_rg1sv                      = 0x0f3e0
bios_wrtvdp                     = 0x00047
work_cliksw                     = 0x0f3db
bios_gtstck                     = 0x00d5
bios_icomp                      = 0x02f4d
bios_imult                      = 0x03193
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_vmovfm                     = 0x02f08
bios_neg                        = 0x02e8d
bios_frcsng                     = 0x0303a
work_arg                        = 0x0f847
bios_frcdbl                     = 0x0303a
work_dac_int                    = 0x0f7f8
bios_decmul                     = 0x027e6
bios_frcint                     = 0x02f8a
bios_maf                        = 0x02c4d
bios_decsub                     = 0x0268c
blib_putsprite                  = 0x04045
bios_errhand                    = 0x0406F
blib_strcmp                     = 0x04027
blib_mid                        = 0x04033
work_buf                        = 0x0f55e
bios_fin                        = 0x3299
bios_nwrvrm                     = 0x0177
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
        LD          IX, blib_init_ncalbas
        CALL        call_blib
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
; set
line_1:
        CALL        interrupt_process
        LD          HL, 1
        LD          A, L
        LD          [work_forclr], A
        LD          HL, 15
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 1
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
        CALL        interrupt_process
        CALL        interrupt_process
        LD          HL, 2
        LD          A, L
        LD          IX, bios_chgmodp
        CALL        bios_extrom
        LD          HL, 2
        LD          A, L
        AND         A, 3
        LD          L, A
        LD          A, [work_rg1sv]
        AND         A, 0xFC
        OR          A, L
        LD          B, A
        LD          C, 1
        CALL        bios_wrtvdp
        LD          HL, 0
        LD          A, L
        LD          [work_cliksw], A
line_2:
        CALL        interrupt_process
        LD          HL, vari_SN
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_X
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_MX
        PUSH        HL
        LD          HL, 255
        PUSH        HL
        LD          HL, 16
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_MY
        PUSH        HL
        LD          HL, 191
        PUSH        HL
        LD          HL, 16
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_C
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_SP
        PUSH        HL
        LD          HL, 8
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_AP
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_A
        PUSH        HL
        LD          HL, 14336
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        JP          line_101
line_10:
        CALL        interrupt_process
; loop
line_11:
        CALL        interrupt_process
        LD          HL, vari_S
        PUSH        HL
        LD          HL, 0
        LD          A, L
        CALL        bios_gtstck
        LD          L, A
        LD          H, 0
        PUSH        HL
        LD          HL, 1
        LD          A, L
        CALL        bios_gtstck
        LD          L, A
        LD          H, 0
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, [vari_S]
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
        JP          Z, _pt1
        JP          line_11
_pt1:
_pt0:
line_12:
        CALL        interrupt_process
        LD          HL, vari_X
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, 8
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 5
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt2
        DEC         A
_pt2:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 1
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt3
        DEC         A
_pt3:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 5
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt4
        DEC         A
_pt4:
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 8
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 0
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt5
        DEC         A
_pt5:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 3
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt6
        DEC         A
_pt6:
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 3
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt7
        DEC         A
_pt7:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 7
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt8
        DEC         A
_pt8:
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
; mov
line_13:
        CALL        interrupt_process
        LD          HL, vari_X
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, 0
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt9
        DEC         A
_pt9:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        CALL        ld_arg_single_real
        POP         HL
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decmul
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_X
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, [vari_MX]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt10
        DEC         A
_pt10:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        CALL        ld_arg_single_real
        POP         HL
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, [vari_MX]
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, [vari_MX]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt11
        DEC         A
_pt11:
        LD          H, A
        LD          L, A
        POP         DE
        CALL        bios_imult
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 0
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt12
        DEC         A
_pt12:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        CALL        ld_arg_single_real
        POP         HL
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decmul
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, [vari_MY]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt13
        DEC         A
_pt13:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        CALL        ld_arg_single_real
        POP         HL
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, [vari_MY]
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, [vari_MY]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt14
        DEC         A
_pt14:
        LD          H, A
        LD          L, A
        POP         DE
        CALL        bios_imult
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
; area
line_14:
        CALL        interrupt_process
        LD          HL, vari_SP
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 3
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        CALL        push_single_real_hl
        LD          HL, 4
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_single_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 4
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 5
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        PUSH        HL
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 6
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, [vari_S]
        PUSH        HL
        LD          HL, 7
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, 12
        POP         DE
        CALL        bios_imult
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
; spr ptn
line_15:
        CALL        interrupt_process
        LD          HL, [vari_SN]
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 1
        PUSH        HL
        LD          HL, [vari_SP]
        PUSH        HL
        LD          HL, [vari_AP]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        POP         DE
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          ix, blib_putsprite
        CALL        call_blib
        CALL        interrupt_process
        LD          HL, [vari_SN]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 11
        PUSH        HL
        LD          HL, [vari_SP]
        PUSH        HL
        LD          HL, [vari_AP]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 2
        POP         DE
        ADD         HL, DE
        PUSH        HL
        POP         DE
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          ix, blib_putsprite
        CALL        call_blib
        CALL        interrupt_process
        LD          HL, vari_AP
        PUSH        HL
        LD          HL, [vari_AP]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 1
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        JP          line_11
line_100:
        CALL        interrupt_process
; dat spr
line_101:
        CALL        interrupt_process
        LD          HL, vars_D
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
        CALL        interrupt_process
        LD          HL, [vars_D]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_1
        POP         DE
        EX          DE, HL
        PUSH        HL
        PUSH        DE
        LD          IX, blib_strcmp
        CALL        call_blib
        POP         HL
        PUSH        AF
        CALL        free_string
        POP         AF
        POP         HL
        PUSH        AF
        CALL        free_string
        POP         AF
        LD          HL, 0
        JR          NZ, _pt17
        DEC         HL
_pt17:
        LD          A, L
        OR          A, H
        JP          Z, _pt16
        JP          line_15
_pt16:
        CALL        interrupt_process
        LD          HL, vari_I
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 7
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt19
        LD          [svari_I_LABEL], HL
        JR          _pt18
_pt19:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt20
        RST         0x20
        JR          C, _pt21
        JR          Z, _pt21
        RET         NC
_pt20:
        RST         0x20
        RET         C
_pt21:
        POP         HL
_pt18:
        CALL        interrupt_process
        LD          HL, vars_B
        PUSH        HL
        LD          HL, [vars_D]
        CALL        copy_string
        PUSH        HL
        LD          HL, 1
        PUSH        HL
        LD          HL, 2
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 2
        LD          C, L
        POP         HL
        LD          B, L
        POP         HL
        PUSH        HL
        LD          IX, blib_mid
        CALL        call_blib
        POP         DE
        PUSH        HL
        EX          DE, HL
        CALL        free_string
        POP         HL
        CALL        copy_string
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
        CALL        interrupt_process
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, str_2
        PUSH        HL
        LD          HL, [vars_B]
        CALL        copy_string
        POP         DE
        CALL        str_add
        PUSH        HL
        LD          A, [HL]
        ADD         A, L
        LD          L, A
        LD          A, H
        ADC         A, 0
        LD          H, A
        INC         HL
        LD          A, [HL]
        POP         DE
        PUSH        DE
        PUSH        AF
        LD          [HL], 0
        PUSH        HL
        EX          DE, HL
        INC         HL
        CALL        bios_fin
        POP         HL
        POP         AF
        LD          [HL], A
        CALL        bios_frcdbl
        POP         HL
        CALL        free_string
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
        CALL        interrupt_process
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        CALL        interrupt_process
        JP          line_101
_pt15:
line_103:
        CALL        interrupt_process
; up1l,up1r
line_104:
        CALL        interrupt_process
line_105:
        CALL        interrupt_process
line_107:
        CALL        interrupt_process
line_108:
        CALL        interrupt_process
line_109:
        CALL        interrupt_process
; ri1l,ri1r
line_110:
        CALL        interrupt_process
line_111:
        CALL        interrupt_process
line_112:
        CALL        interrupt_process
line_113:
        CALL        interrupt_process
line_114:
        CALL        interrupt_process
; dw1l,dw1r
line_115:
        CALL        interrupt_process
line_116:
        CALL        interrupt_process
line_117:
        CALL        interrupt_process
line_118:
        CALL        interrupt_process
line_119:
        CALL        interrupt_process
; le1l,lef1r
line_120:
        CALL        interrupt_process
line_121:
        CALL        interrupt_process
line_122:
        CALL        interrupt_process
line_123:
        CALL        interrupt_process
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
ld_arg_single_real:
        LD          DE, work_arg
        LD          BC, 4
        LDIR        
        LD          [work_arg+4], BC
        LD          [work_arg+6], BC
        LD          A, 8
        LD          [work_valtyp], A
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
push_single_real_hl:
        POP         BC
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
pop_single_real_dac:
        POP         BC
        POP         HL
        LD          [work_dac+2], HL
        POP         HL
        LD          [work_dac+0], HL
        LD          HL, 0
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        PUSH        BC
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
data_104:
        DEFW        str_3
        DEFW        str_4
        DEFW        str_5
        DEFW        str_6
data_105:
        DEFW        str_7
        DEFW        str_8
        DEFW        str_9
        DEFW        str_10
data_107:
        DEFW        str_11
        DEFW        str_12
        DEFW        str_13
        DEFW        str_14
data_108:
        DEFW        str_15
        DEFW        str_16
        DEFW        str_17
        DEFW        str_18
data_110:
        DEFW        str_19
        DEFW        str_20
        DEFW        str_21
        DEFW        str_22
data_111:
        DEFW        str_23
        DEFW        str_24
        DEFW        str_25
        DEFW        str_26
data_112:
        DEFW        str_27
        DEFW        str_28
        DEFW        str_29
        DEFW        str_30
data_113:
        DEFW        str_31
        DEFW        str_32
        DEFW        str_33
        DEFW        str_34
data_115:
        DEFW        str_35
        DEFW        str_4
        DEFW        str_21
        DEFW        str_6
data_116:
        DEFW        str_36
        DEFW        str_8
        DEFW        str_25
        DEFW        str_10
data_117:
        DEFW        str_37
        DEFW        str_12
        DEFW        str_29
        DEFW        str_14
data_118:
        DEFW        str_38
        DEFW        str_16
        DEFW        str_33
        DEFW        str_18
data_120:
        DEFW        str_35
        DEFW        str_39
        DEFW        str_40
        DEFW        str_41
data_121:
        DEFW        str_36
        DEFW        str_42
        DEFW        str_43
        DEFW        str_44
data_122:
        DEFW        str_37
        DEFW        str_45
        DEFW        str_46
        DEFW        str_47
data_123:
        DEFW        str_38
        DEFW        str_48
        DEFW        str_49
        DEFW        str_50
        DEFW        str_1
str_0:
        DEFB        0x00
str_1:
        DEFB        0x01, 0x2A
str_10:
        DEFB        0x10, 0x43, 0x30, 0x33, 0x30, 0x32, 0x38, 0x32, 0x38, 0x45, 0x38, 0x42, 0x30, 0x43, 0x30, 0x38, 0x30
str_11:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x30
str_12:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x38, 0x30, 0x38, 0x30, 0x38, 0x30, 0x30, 0x30, 0x32, 0x30, 0x30, 0x30, 0x30
str_13:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x30, 0x30
str_14:
        DEFB        0x10, 0x30, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x43, 0x30, 0x30, 0x30
str_15:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33
str_16:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x38, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x33, 0x30, 0x30
str_17:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30
str_18:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30, 0x31, 0x30, 0x34, 0x30, 0x30, 0x30, 0x30, 0x30
str_19:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x33, 0x30, 0x37, 0x30, 0x45, 0x30, 0x43, 0x30, 0x38, 0x30, 0x34, 0x30, 0x33
str_2:
        DEFB        0x02, 0x26, 0x48
str_20:
        DEFB        0x10, 0x30, 0x35, 0x30, 0x35, 0x30, 0x35, 0x30, 0x35, 0x30, 0x33, 0x30, 0x32, 0x30, 0x32, 0x30, 0x31
str_21:
        DEFB        0x10, 0x30, 0x30, 0x43, 0x30, 0x45, 0x30, 0x33, 0x30, 0x35, 0x30, 0x35, 0x30, 0x32, 0x30, 0x43, 0x30
str_22:
        DEFB        0x10, 0x41, 0x30, 0x32, 0x30, 0x32, 0x30, 0x32, 0x30, 0x43, 0x30, 0x34, 0x30, 0x34, 0x30, 0x38, 0x30
str_23:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x37, 0x30, 0x45, 0x30, 0x43, 0x30, 0x38, 0x30, 0x34
str_24:
        DEFB        0x10, 0x30, 0x33, 0x30, 0x36, 0x30, 0x39, 0x31, 0x32, 0x31, 0x37, 0x30, 0x44, 0x31, 0x32, 0x31, 0x43
str_25:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x45, 0x30, 0x33, 0x30, 0x35, 0x30, 0x35, 0x30, 0x32, 0x30
str_26:
        DEFB        0x10, 0x43, 0x43, 0x37, 0x34, 0x32, 0x38, 0x33, 0x30, 0x45, 0x30, 0x39, 0x30, 0x34, 0x38, 0x33, 0x38
str_27:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x30, 0x33, 0x30, 0x37, 0x30, 0x33, 0x30, 0x30
str_28:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30, 0x30
str_29:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x41, 0x30, 0x41, 0x30, 0x43, 0x30, 0x30, 0x30
str_3:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x33, 0x30, 0x37, 0x30, 0x46, 0x30, 0x46, 0x30, 0x46, 0x30, 0x34, 0x30, 0x33
str_30:
        DEFB        0x10, 0x30, 0x30, 0x38, 0x30, 0x38, 0x30, 0x38, 0x30, 0x30, 0x30, 0x38, 0x30, 0x38, 0x30, 0x30, 0x30
str_31:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x30, 0x33, 0x30, 0x37, 0x30, 0x33
str_32:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x36, 0x30, 0x43, 0x30, 0x38, 0x30, 0x32, 0x30, 0x43, 0x30, 0x30
str_33:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x41, 0x30, 0x41, 0x30, 0x43, 0x30
str_34:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x38, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x36, 0x30, 0x33, 0x30, 0x30, 0x30
str_35:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x33, 0x30, 0x37, 0x30, 0x43, 0x30, 0x41, 0x30, 0x41, 0x30, 0x34, 0x30, 0x33
str_36:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x37, 0x30, 0x43, 0x30, 0x41, 0x30, 0x41, 0x30, 0x34
str_37:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x35, 0x30, 0x35, 0x30, 0x33, 0x30, 0x30
str_38:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x35, 0x30, 0x35, 0x30, 0x33
str_39:
        DEFB        0x10, 0x30, 0x35, 0x30, 0x34, 0x30, 0x34, 0x30, 0x34, 0x30, 0x33, 0x30, 0x32, 0x30, 0x32, 0x30, 0x31
str_4:
        DEFB        0x10, 0x30, 0x43, 0x31, 0x34, 0x31, 0x34, 0x31, 0x34, 0x30, 0x46, 0x30, 0x35, 0x30, 0x33, 0x30, 0x30
str_40:
        DEFB        0x10, 0x30, 0x30, 0x43, 0x30, 0x45, 0x30, 0x37, 0x30, 0x33, 0x30, 0x31, 0x30, 0x32, 0x30, 0x43, 0x30
str_41:
        DEFB        0x10, 0x41, 0x30, 0x41, 0x30, 0x41, 0x30, 0x41, 0x30, 0x43, 0x30, 0x34, 0x30, 0x34, 0x30, 0x38, 0x30
str_42:
        DEFB        0x10, 0x33, 0x33, 0x32, 0x45, 0x31, 0x34, 0x30, 0x43, 0x30, 0x37, 0x30, 0x39, 0x31, 0x32, 0x31, 0x43
str_43:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x45, 0x30, 0x37, 0x30, 0x33, 0x30, 0x31, 0x30, 0x32, 0x30
str_44:
        DEFB        0x10, 0x43, 0x30, 0x36, 0x30, 0x39, 0x30, 0x34, 0x38, 0x45, 0x38, 0x42, 0x30, 0x34, 0x38, 0x33, 0x38
str_45:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30, 0x31, 0x30, 0x30, 0x30, 0x31, 0x30, 0x31, 0x30, 0x30
str_46:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x38, 0x30, 0x43, 0x30, 0x45, 0x30, 0x43, 0x30, 0x30, 0x30
str_47:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x38, 0x30, 0x38, 0x30, 0x30, 0x30
str_48:
        DEFB        0x10, 0x30, 0x30, 0x31, 0x30, 0x30, 0x38, 0x30, 0x30, 0x30, 0x30, 0x30, 0x36, 0x30, 0x43, 0x30, 0x30
str_49:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x38, 0x30, 0x43, 0x30, 0x45, 0x30, 0x43, 0x30
str_5:
        DEFB        0x10, 0x30, 0x30, 0x43, 0x30, 0x45, 0x30, 0x46, 0x30, 0x46, 0x30, 0x46, 0x30, 0x32, 0x30, 0x43, 0x30
str_50:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x36, 0x30, 0x33, 0x30, 0x31, 0x30, 0x34, 0x30, 0x33, 0x30, 0x30, 0x30
str_6:
        DEFB        0x10, 0x33, 0x30, 0x32, 0x38, 0x33, 0x30, 0x32, 0x30, 0x45, 0x30, 0x32, 0x30, 0x32, 0x30, 0x43, 0x30
str_7:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x30, 0x33, 0x30, 0x37, 0x30, 0x46, 0x30, 0x46, 0x30, 0x46, 0x30, 0x34
str_8:
        DEFB        0x10, 0x30, 0x33, 0x30, 0x43, 0x31, 0x34, 0x30, 0x43, 0x30, 0x37, 0x30, 0x34, 0x30, 0x34, 0x30, 0x33
str_9:
        DEFB        0x10, 0x30, 0x30, 0x30, 0x30, 0x43, 0x30, 0x45, 0x30, 0x46, 0x30, 0x46, 0x30, 0x46, 0x30, 0x32, 0x30
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
        DEFW        data_104
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
svari_I_FOR_END:
        DEFW        0
svari_I_FOR_STEP:
        DEFW        0
svari_I_LABEL:
        DEFW        0
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
vari_A:
        DEFW        0
vari_AP:
        DEFW        0
vari_C:
        DEFW        0
vari_I:
        DEFW        0
vari_MX:
        DEFW        0
vari_MY:
        DEFW        0
vari_S:
        DEFW        0
vari_SN:
        DEFW        0
vari_SP:
        DEFW        0
vari_X:
        DEFW        0
vari_Y:
        DEFW        0
var_area_end:
vars_area_start:
vars_B:
        DEFW        0
vars_D:
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
