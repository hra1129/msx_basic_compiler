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
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
bios_erafnk                     = 0x000CC
bios_chgmodp                    = 0x001B5
bios_extrom                     = 0x0015F
work_rg1sv                      = 0x0f3e0
bios_wrtvdp                     = 0x00047
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_vmovfm                     = 0x02f08
bios_atn                        = 0x02A14
bios_frcdbl                     = 0x0303a
bios_maf                        = 0x02c4d
work_dac_int                    = 0x0f7f8
bios_decmul                     = 0x027e6
bios_decdiv                     = 0x0289f
bios_errhand_redim              = 0x0405e
bios_umult                      = 0x0314a
bios_errhand                    = 0x0406F
bios_decadd                     = 0x0269a
bios_vmovam                     = 0x02eef
bios_xdcomp                     = 0x02f5c
bios_frcint                     = 0x02f8a
work_arg                        = 0x0f847
bios_cos                        = 0x02993
bios_sin                        = 0x029AC
work_buf                        = 0x0f55e
bios_fin                        = 0x3299
blib_setsprite                  = 0x04042
blib_putsprite                  = 0x04045
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
line_10:
        CALL        interrupt_process
; 16WAY HANABI
line_100:
        CALL        interrupt_process
        LD          HL, 15
        LD          A, L
        LD          [work_forclr], A
        LD          HL, 1
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 1
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
        CALL        interrupt_process
        CALL        bios_erafnk
        CALL        interrupt_process
        LD          HL, 1
        LD          A, L
        LD          IX, bios_chgmodp
        CALL        bios_extrom
        LD          HL, 0
        LD          A, L
        AND         A, 3
        LD          L, A
        LD          A, [work_rg1sv]
        AND         A, 0xFC
        OR          A, L
        LD          B, A
        LD          C, 1
        CALL        bios_wrtvdp
line_110:
        CALL        interrupt_process
        LD          HL, vard_PI
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcdbl
        CALL        bios_atn
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 8
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 360
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decdiv
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
line_120:
        CALL        interrupt_process
        LD          HL, [varda_DG]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 16
        INC         HL
        PUSH        HL
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varda_DG], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        CALL        interrupt_process
        LD          HL, [varda_RD]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 16
        INC         HL
        PUSH        HL
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varda_RD], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        CALL        interrupt_process
        LD          HL, [varda_RC]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 16
        INC         HL
        PUSH        HL
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varda_RC], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        CALL        interrupt_process
        LD          HL, [varda_RS]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 16
        INC         HL
        PUSH        HL
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varda_RS], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        CALL        interrupt_process
        LD          HL, [varda_X]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 16
        INC         HL
        PUSH        HL
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varda_X], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        CALL        interrupt_process
        LD          HL, [varda_Y]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 16
        INC         HL
        PUSH        HL
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varda_Y], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
line_140:
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
        LD          HL, 15
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
        LD          HL, varda_DG
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, vard_I
        CALL        push_double_real_hl
        LD          HL, const_42225000
        CALL        ld_arg_single_real
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 124
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 92
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_150:
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
        LD          HL, 15
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
        LD          HL, varda_RD
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, varda_DG
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        CALL        push_double_real_hl
        LD          HL, vard_PI
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
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
        LD          HL, 15
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
        LD          HL, _pt9
        LD          [svard_I_LABEL], HL
        JR          _pt8
_pt9:
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
        JR          C, _pt10
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt11
        RET         
_pt10:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt11:
        POP         HL
_pt8:
        CALL        interrupt_process
        LD          HL, varda_RC
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, varda_RD
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_cos
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, varda_RS
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, varda_RD
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_sin
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_300:
        CALL        interrupt_process
; SPRITE
line_310:
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
        LD          HL, 7
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
        LD          HL, _pt13
        LD          [svard_I_LABEL], HL
        JR          _pt12
_pt13:
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
        JR          C, _pt14
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt15
        RET         
_pt14:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt15:
        POP         HL
_pt12:
        CALL        interrupt_process
        LD          HL, vars_DT
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
        LD          HL, vars_SP
        PUSH        HL
        LD          HL, [vars_SP]
        CALL        copy_string
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, str_1
        PUSH        HL
        LD          HL, [vars_DT]
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
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_320:
        CALL        interrupt_process
        LD          HL, vard_J
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_J_FOR_END
        PUSH        HL
        LD          HL, 15
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_J_FOR_STEP
        PUSH        HL
        LD          HL, const_4110000000000000
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt17
        LD          [svard_J_LABEL], HL
        JR          _pt16
_pt17:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_J
        CALL        bios_vmovfm
        LD          HL, svard_J_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_J
        LD          BC, 8
        LDIR        
        LD          HL, svard_J_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_J_FOR_STEP]
        RLCA        
        JR          C, _pt18
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt19
        RET         
_pt18:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt19:
        POP         HL
_pt16:
        CALL        interrupt_process
        LD          HL, vard_J
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, [vars_SP]
        CALL        copy_string
        POP         DE
        LD          ix, blib_setsprite
        CALL        call_blib
        CALL        interrupt_process
        LD          HL, [svard_J_LABEL]
        CALL        jp_hl
line_325:
        CALL        interrupt_process
; SYOKIHAICHI
line_330:
        CALL        interrupt_process
        LD          HL, vard_A
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_A_FOR_END
        PUSH        HL
        LD          HL, 14
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_A_FOR_STEP
        PUSH        HL
        LD          HL, 2
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt21
        LD          [svard_A_LABEL], HL
        JR          _pt20
_pt21:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_A
        CALL        bios_vmovfm
        LD          HL, svard_A_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_A
        LD          BC, 8
        LDIR        
        LD          HL, svard_A_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_A_FOR_STEP]
        RLCA        
        JR          C, _pt22
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt23
        RET         
_pt22:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt23:
        POP         HL
_pt20:
        CALL        interrupt_process
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, 0
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, 0
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, 9
        PUSH        HL
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
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
        LD          HL, [svard_A_LABEL]
        CALL        jp_hl
line_340:
        CALL        interrupt_process
        LD          HL, vard_B
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_B_FOR_END
        PUSH        HL
        LD          HL, 15
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_B_FOR_STEP
        PUSH        HL
        LD          HL, 2
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt25
        LD          [svard_B_LABEL], HL
        JR          _pt24
_pt25:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_B
        CALL        bios_vmovfm
        LD          HL, svard_B_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_B
        LD          BC, 8
        LDIR        
        LD          HL, svard_B_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_B_FOR_STEP]
        RLCA        
        JR          C, _pt26
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt27
        RET         
_pt26:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt27:
        POP         HL
_pt24:
        CALL        interrupt_process
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, 0
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, 0
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, 11
        PUSH        HL
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
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
        LD          HL, [svard_B_LABEL]
        CALL        jp_hl
line_500:
        CALL        interrupt_process
; FIRE
line_510:
        CALL        interrupt_process
        LD          HL, vard_J
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_J_FOR_END
        PUSH        HL
        LD          HL, 100
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_J_FOR_STEP
        PUSH        HL
        LD          HL, const_4110000000000000
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt29
        LD          [svard_J_LABEL], HL
        JR          _pt28
_pt29:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_J
        CALL        bios_vmovfm
        LD          HL, svard_J_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_J
        LD          BC, 8
        LDIR        
        LD          HL, svard_J_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_J_FOR_STEP]
        RLCA        
        JR          C, _pt30
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt31
        RET         
_pt30:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt31:
        POP         HL
_pt28:
line_520:
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
        LD          HL, 15
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
        LD          HL, _pt33
        LD          [svard_I_LABEL], HL
        JR          _pt32
_pt33:
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
        JR          C, _pt34
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt35
        RET         
_pt34:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt35:
        POP         HL
_pt32:
line_530:
        CALL        interrupt_process
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        CALL        push_double_real_hl
        LD          HL, varda_RC
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decadd
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        CALL        push_double_real_hl
        LD          HL, varda_RS
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decadd
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
line_540:
        CALL        interrupt_process
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        POP         DE
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 3
        LD          ix, blib_putsprite
        CALL        call_blib
line_550:
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
line_560:
        CALL        interrupt_process
        LD          HL, [svard_J_LABEL]
        CALL        jp_hl
line_570:
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
        LD          HL, 15
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
        LD          HL, _pt37
        LD          [svard_I_LABEL], HL
        JR          _pt36
_pt37:
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
        JR          C, _pt38
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt39
        RET         
_pt38:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt39:
        POP         HL
_pt36:
        CALL        interrupt_process
        LD          HL, varda_X
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 124
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, varda_Y
        LD          D, 1
        LD          BC, 93
        CALL        check_array
        CALL        calc_array_top
        LD          HL, vard_I
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        ADD         HL, HL
        ADD         HL, HL
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 92
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
        CALL        interrupt_process
        JP          line_330
line_10000:
        CALL        interrupt_process
line_10010:
        CALL        interrupt_process
line_10020:
        CALL        interrupt_process
line_10030:
        CALL        interrupt_process
line_10040:
        CALL        interrupt_process
line_10050:
        CALL        interrupt_process
line_10060:
        CALL        interrupt_process
line_10070:
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
ld_de_double_real:
        LD          BC, 8
        LDIR        
        RET         
allocate_heap:
        LD          HL, [heap_next]
        PUSH        HL
        ADD         HL, BC
        JR          C, _allocate_heap_error
        LD          DE, [heap_end]
        RST         0x20
        JR          NC, _allocate_heap_error
        LD          [heap_next], HL
        POP         HL
        PUSH        HL
        DEC         BC
        LD          E, L
        LD          D, H
        INC         DE
        LD          [HL], 0
        LDIR        
        POP         HL
        RET         
_allocate_heap_error:
        LD          E, 7
        JP          bios_errhand
check_array:
        LD          A, [HL]
        INC         HL
        OR          A, [HL]
        DEC         HL
        RET         NZ
        PUSH        DE
        PUSH        HL
        PUSH        BC
        CALL        allocate_heap
        POP         BC
        POP         DE
        POP         AF
        EX          DE, HL
        PUSH        HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        EX          DE, HL
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          [HL], A
        INC         HL
        LD          B, A
        LD          DE, 11
_check_array_loop:
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        DJNZ        _check_array_loop
        POP         HL
        RET         
calc_array_top:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        INC         HL
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, 0
        ADD         HL, DE
        ADD         HL, DE
        LD          A, E
        POP         DE
        PUSH        HL
        JR          _calc_array_top_l2
_calc_array_top_l1:
        DEC         HL
        LD          B, [HL]
        DEC         HL
        LD          C, [HL]
        PUSH        BC
_calc_array_top_l2:
        DEC         A
        JR          NZ, _calc_array_top_l1
        PUSH        DE
        RET         
ld_arg_single_real:
        LD          DE, work_arg
        LD          BC, 4
        LDIR        
        LD          [work_arg+4], BC
        LD          [work_arg+6], BC
        LD          A, 8
        LD          [work_valtyp], A
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
data_10000:
        DEFW        str_2
data_10010:
        DEFW        str_3
data_10020:
        DEFW        str_4
data_10030:
        DEFW        str_5
data_10040:
        DEFW        str_5
data_10050:
        DEFW        str_4
data_10060:
        DEFW        str_3
data_10070:
        DEFW        str_2
const_42225000:
        DEFB        0x42, 0x22, 0x50, 0x00
const_4110000000000000:
        DEFB        0x41, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
str_0:
        DEFB        0x00
str_1:
        DEFB        0x02, 0x26, 0x42
str_2:
        DEFB        0x08, 0x30, 0x30, 0x30, 0x31, 0x31, 0x30, 0x30, 0x30
str_3:
        DEFB        0x08, 0x30, 0x30, 0x31, 0x31, 0x31, 0x31, 0x30, 0x30
str_4:
        DEFB        0x08, 0x30, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x30
str_5:
        DEFB        0x08, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31
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
        DEFW        data_10000
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
svard_A_FOR_END:
        DEFW        0, 0, 0, 0
svard_A_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_A_LABEL:
        DEFW        0
svard_B_FOR_END:
        DEFW        0, 0, 0, 0
svard_B_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_B_LABEL:
        DEFW        0
svard_I_FOR_END:
        DEFW        0, 0, 0, 0
svard_I_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_I_LABEL:
        DEFW        0
svard_J_FOR_END:
        DEFW        0, 0, 0, 0
svard_J_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_J_LABEL:
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
vard_A:
        DEFW        0, 0, 0, 0
vard_B:
        DEFW        0, 0, 0, 0
vard_I:
        DEFW        0, 0, 0, 0
vard_J:
        DEFW        0, 0, 0, 0
vard_PI:
        DEFW        0, 0, 0, 0
var_area_end:
vars_area_start:
vars_DT:
        DEFW        0
vars_SP:
        DEFW        0
vars_area_end:
vara_area_start:
varda_DG:
        DEFW        0
varda_RC:
        DEFW        0
varda_RD:
        DEFW        0
varda_RS:
        DEFW        0
varda_X:
        DEFW        0
varda_Y:
        DEFW        0
vara_area_end:
varsa_area_start:
varsa_area_end:
h_timi_backup:
        DEFB        0, 0, 0, 0, 0
h_erro_backup:
        DEFB        0, 0, 0, 0, 0
heap_start:
end_address:
