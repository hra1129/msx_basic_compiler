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
bios_chgmod                     = 0x0005F
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
work_csrx                       = 0x0f3dd
work_linlen                     = 0x0f3b0
work_dac                        = 0x0f7f6
bios_vmovfm                     = 0x02f08
bios_neg                        = 0x02e8d
bios_frcsng                     = 0x0303a
bios_frcint                     = 0x02f8a
bios_decadd                     = 0x0269a
bios_vmovam                     = 0x02eef
bios_fcomp                      = 0x02f21
bios_frcdbl                     = 0x0303a
bios_xdcomp                     = 0x02f5c
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
        LD          HL, 1
        LD          A, L
        CALL        bios_chgmod
        LD          HL, 15
        LD          A, L
        LD          [work_forclr], A
        LD          HL, 4
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 7
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
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
        LD          HL, 10
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
        LD          HL, _pt1
        LD          [svari_I_LABEL], HL
        JR          _pt0
_pt1:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt2
        RST         0x20
        JR          C, _pt3
        JR          Z, _pt3
        RET         NC
_pt2:
        RST         0x20
        RET         C
_pt3:
        POP         HL
_pt0:
        LD          HL, [vari_I]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt4
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt4:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        LD          HL, str_0
        CALL        puts
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
        LD          HL, 10
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
        LD          HL, _pt6
        LD          [svari_I_LABEL], HL
        JR          _pt5
_pt6:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt7
        RST         0x20
        JR          C, _pt8
        JR          Z, _pt8
        RET         NC
_pt7:
        RST         0x20
        RET         C
_pt8:
        POP         HL
_pt5:
        LD          HL, [vari_I]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt9
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt9:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        LD          HL, str_0
        CALL        puts
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
        LD          HL, 2
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
        LD          HL, _pt11
        LD          [svari_I_LABEL], HL
        JR          _pt10
_pt11:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt12
        RST         0x20
        JR          C, _pt13
        JR          Z, _pt13
        RET         NC
_pt12:
        RST         0x20
        RET         C
_pt13:
        POP         HL
_pt10:
        LD          HL, vari_J
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_END
        PUSH        HL
        LD          HL, 2
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt15
        LD          [svari_J_LABEL], HL
        JR          _pt14
_pt15:
        LD          HL, [vari_J]
        LD          DE, [svari_J_FOR_STEP]
        ADD         HL, DE
        LD          [vari_J], HL
        LD          A, D
        LD          DE, [svari_J_FOR_END]
        RLCA        
        JR          C, _pt16
        RST         0x20
        JR          C, _pt17
        JR          Z, _pt17
        RET         NC
_pt16:
        RST         0x20
        RET         C
_pt17:
        POP         HL
_pt14:
        LD          HL, [vari_J]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt18
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt18:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svari_J_LABEL]
        CALL        jp_hl
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        LD          HL, str_0
        CALL        puts
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
        LD          HL, 2
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
        LD          HL, _pt20
        LD          [svari_I_LABEL], HL
        JR          _pt19
_pt20:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt21
        RST         0x20
        JR          C, _pt22
        JR          Z, _pt22
        RET         NC
_pt21:
        RST         0x20
        RET         C
_pt22:
        POP         HL
_pt19:
        LD          HL, vari_J
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_END
        PUSH        HL
        LD          HL, 2
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt24
        LD          [svari_J_LABEL], HL
        JR          _pt23
_pt24:
        LD          HL, [vari_J]
        LD          DE, [svari_J_FOR_STEP]
        ADD         HL, DE
        LD          [vari_J], HL
        LD          A, D
        LD          DE, [svari_J_FOR_END]
        RLCA        
        JR          C, _pt25
        RST         0x20
        JR          C, _pt26
        JR          Z, _pt26
        RET         NC
_pt25:
        RST         0x20
        RET         C
_pt26:
        POP         HL
_pt23:
        LD          HL, [vari_J]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt27
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt27:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svari_J_LABEL]
        CALL        jp_hl
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        LD          HL, str_0
        CALL        puts
        LD          HL, vari_I
        PUSH        HL
        LD          HL, 10
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_STEP
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        LD          [work_dac+4], BC
        LD          [work_dac+6], BC
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt29
        LD          [svari_I_LABEL], HL
        JR          _pt28
_pt29:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt30
        RST         0x20
        JR          C, _pt31
        JR          Z, _pt31
        RET         NC
_pt30:
        RST         0x20
        RET         C
_pt31:
        POP         HL
_pt28:
        LD          HL, [vari_I]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt32
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt32:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_I]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt33
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt33:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_0
        CALL        puts
        LD          HL, varf_K
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        LD          HL, svarf_K_FOR_END
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        LD          HL, svarf_K_FOR_STEP
        PUSH        HL
        LD          HL, const_40100000
        POP         DE
        CALL        ld_de_single_real
        LD          HL, _pt35
        LD          [svarf_K_LABEL], HL
        JR          _pt34
_pt35:
        LD          A, 4
        LD          [work_valtyp], A
        LD          HL, varf_K
        CALL        bios_vmovfm
        LD          HL, svarf_K_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, varf_K
        LD          BC, 4
        LDIR        
        LD          BC, [svarf_K_FOR_END]
        LD          DE, [svarf_K_FOR_END + 2]
        LD          A, [svarf_K_FOR_STEP]
        RLCA        
        JR          C, _pt36
        CALL        bios_fcomp
        DEC         A
        JR          NZ, _pt37
        RET         
_pt36:
        CALL        bios_fcomp
        INC         A
        RET         Z
_pt37:
        POP         HL
_pt34:
        LD          HL, varf_K
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt38
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt38:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svarf_K_LABEL]
        CALL        jp_hl
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_K
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt39
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt39:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_0
        CALL        puts
        LD          HL, vard_K
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_K_FOR_END
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_K_FOR_STEP
        PUSH        HL
        LD          HL, const_40100000
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt41
        LD          [svard_K_LABEL], HL
        JR          _pt40
_pt41:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_K
        CALL        bios_vmovfm
        LD          HL, svard_K_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_K
        LD          BC, 8
        LDIR        
        LD          HL, svard_K_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_K_FOR_STEP]
        RLCA        
        JR          C, _pt42
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt43
        RET         
_pt42:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt43:
        POP         HL
_pt40:
        LD          HL, vard_K
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt44
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt44:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svard_K_LABEL]
        CALL        jp_hl
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_K
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt45
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt45:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_0
        CALL        puts
        LD          HL, varf_K
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        LD          HL, svarf_K_FOR_END
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        LD          HL, svarf_K_FOR_STEP
        PUSH        HL
        LD          HL, const_40100000
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_neg
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        LD          HL, _pt47
        LD          [svarf_K_LABEL], HL
        JR          _pt46
_pt47:
        LD          A, 4
        LD          [work_valtyp], A
        LD          HL, varf_K
        CALL        bios_vmovfm
        LD          HL, svarf_K_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, varf_K
        LD          BC, 4
        LDIR        
        LD          BC, [svarf_K_FOR_END]
        LD          DE, [svarf_K_FOR_END + 2]
        LD          A, [svarf_K_FOR_STEP]
        RLCA        
        JR          C, _pt48
        CALL        bios_fcomp
        DEC         A
        JR          NZ, _pt49
        RET         
_pt48:
        CALL        bios_fcomp
        INC         A
        RET         Z
_pt49:
        POP         HL
_pt46:
        LD          HL, varf_K
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt50
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt50:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svarf_K_LABEL]
        CALL        jp_hl
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_K
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt51
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt51:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_0
        CALL        puts
        LD          HL, vard_K
        PUSH        HL
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_K_FOR_END
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_K_FOR_STEP
        PUSH        HL
        LD          HL, const_40100000
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_neg
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt53
        LD          [svard_K_LABEL], HL
        JR          _pt52
_pt53:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_K
        CALL        bios_vmovfm
        LD          HL, svard_K_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_K
        LD          BC, 8
        LDIR        
        LD          HL, svard_K_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_K_FOR_STEP]
        RLCA        
        JR          C, _pt54
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt55
        RET         
_pt54:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt55:
        POP         HL
_pt52:
        LD          HL, vard_K
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt56
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt56:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, [svard_K_LABEL]
        CALL        jp_hl
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_K
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt57
        PUSH        HL
        LD          HL, str_0
        CALL        puts
        POP         HL
_pt57:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
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
        LD          E, L
        LD          D, H
        ADD         HL, BC
        EX          DE, HL
        PUSH        HL
        LD          HL, [heap_next]
        OR          A, A
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          [heap_move_size], BC
        LD          [heap_remap_address], HL
        LD          [heap_next], DE
        LD          A, B
        OR          A, C
        JR          Z, _free_heap_loop1
        LDIR        
        LD          [heap_next], DE
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
        SBC         HL, DE
        POP         DE
        EX          DE, HL
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
ld_de_single_real:
        LD          BC, 4
        LDIR        
        RET         
ld_dac_single_real:
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        LD          [work_dac+4], BC
        LD          [work_dac+6], BC
        RET         
ld_de_double_real:
        LD          BC, 8
        LDIR        
        RET         
ld_dac_double_real:
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        RET         
const_40100000:
        DEFB        0x40, 0x10, 0x00, 0x00
str_0:
        DEFB        0x02, 0x0D, 0x0A
str_1:
        DEFB        0x01, 0x5B
str_2:
        DEFB        0x01, 0x5D
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
svard_K_FOR_END:
        DEFW        0, 0, 0, 0
svard_K_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_K_LABEL:
        DEFW        0
svarf_K_FOR_END:
        DEFW        0, 0
svarf_K_FOR_STEP:
        DEFW        0, 0
svarf_K_LABEL:
        DEFW        0
svari_I_FOR_END:
        DEFW        0
svari_I_FOR_STEP:
        DEFW        0
svari_I_LABEL:
        DEFW        0
svari_J_FOR_END:
        DEFW        0
svari_J_FOR_STEP:
        DEFW        0
svari_J_LABEL:
        DEFW        0
vard_K:
        DEFW        0, 0, 0, 0
varf_K:
        DEFW        0, 0
vari_I:
        DEFW        0
vari_J:
        DEFW        0
var_area_end:
vars_area_start:
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
