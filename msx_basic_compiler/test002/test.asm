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
work_dac                        = 0x0f7f6
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
bios_frcdbl                     = 0x0303a
bios_vmovfm                     = 0x02f08
bios_neg                        = 0x02e8d
bios_frcsng                     = 0x0303a
work_prtflg                     = 0x0f416
work_arg                        = 0x0f847
bios_decsub                     = 0x0268c
bios_absfn                      = 0x02e82
work_csrx                       = 0x0f3dd
work_linlen                     = 0x0f3b0
bios_fout                       = 0x03425
bios_errhand                    = 0x0406F
blib_inkey                      = 0x0402a
blib_strcmp                     = 0x04027
bios_frcint                     = 0x02f8a
bios_newstt                     = 0x04601
bios_gttrig                     = 0x00D8
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          HL, err_return_without_gosub
        PUSH        HL
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
        CALL        setup_h_timi
        LD          HL, _code_ret
        LD          [svari_on_sprite_line], HL
        LD          [svari_on_interval_line], HL
        LD          [svari_on_key01_line], HL
        LD          HL, svari_on_key01_line
        LD          DE, svari_on_key01_line + 2
        LD          BC, 20 - 2
        LDIR        
        CALL        setup_h_erro
        EI          
        LD          DE, program_start
        JP          program_run
setup_h_timi:
        LD          HL, h_timi_handler
        LD          [work_h_timi + 1], HL
        LD          A, 0xC3
        LD          [work_h_timi], A
        RET         
setup_h_erro:
        LD          HL, work_h_erro
        LD          DE, h_erro_backup
        LD          BC, 5
        LDIR        
        LD          HL, h_erro_handler
        LD          [work_h_erro + 1], HL
        LD          A, 0xC3
        LD          [work_h_erro], A
        RET         
jp_hl:
        JP          HL
program_start:
line_100:
        CALL        interrupt_process
line_110:
        CALL        interrupt_process
        LD          HL, vard_A
        PUSH        HL
        LD          HL, 100
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, vard_B
        PUSH        HL
        LD          HL, 200
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        CALL        interrupt_process
        LD          HL, vard_C
        PUSH        HL
        LD          HL, 100
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
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
        CALL        interrupt_process
        LD          HL, vard_D
        PUSH        HL
        LD          HL, 200
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
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
line_120:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_130:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_3
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt0
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt0:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_140:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt1
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt1:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_150:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_C
        CALL        push_double_real_hl
        LD          HL, vard_D
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt2
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt2:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_160:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_D
        CALL        push_double_real_hl
        LD          HL, vard_C
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt3
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt3:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_170:
        CALL        interrupt_process
        LD          HL, vars_I
        PUSH        HL
        LD          IX, blib_inkey
        CALL        call_blib
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
        LD          HL, [vars_I]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_0
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
        JR          NZ, _pt6
        DEC         HL
_pt6:
        LD          A, L
        OR          A, H
        JP          Z, _pt5
        JP          line_170
_pt5:
_pt4:
line_210:
        CALL        interrupt_process
        LD          HL, varf_A
        PUSH        HL
        LD          HL, 100
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        CALL        interrupt_process
        LD          HL, varf_B
        PUSH        HL
        LD          HL, 200
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        CALL        interrupt_process
        LD          HL, varf_C
        PUSH        HL
        LD          HL, 100
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
        CALL        interrupt_process
        LD          HL, varf_D
        PUSH        HL
        LD          HL, 200
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_single_real
line_220:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_7
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_230:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_3
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_arg
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_dac
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt7
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt7:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_240:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_arg
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_dac
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt8:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_250:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_C
        CALL        push_single_real_hl
        LD          HL, varf_D
        LD          DE, work_arg
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_dac
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt9:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_260:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_D
        CALL        push_single_real_hl
        LD          HL, varf_C
        LD          DE, work_arg
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_dac
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_decsub
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt10
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt10:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_270:
        CALL        interrupt_process
        LD          HL, vars_I
        PUSH        HL
        LD          IX, blib_inkey
        CALL        call_blib
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
        LD          HL, [vars_I]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_0
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
        JR          NZ, _pt13
        DEC         HL
_pt13:
        LD          A, L
        OR          A, H
        JP          Z, _pt12
        JP          line_270
_pt12:
_pt11:
line_310:
        CALL        interrupt_process
        LD          HL, vari_A
        PUSH        HL
        LD          HL, 100
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_B
        PUSH        HL
        LD          HL, 200
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        LD          HL, vari_C
        PUSH        HL
        LD          HL, 100
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
        CALL        interrupt_process
        LD          HL, vari_D
        PUSH        HL
        LD          HL, 200
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
line_320:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_8
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_330:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_3
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        LD          A, H
        ADD         A, A
        JR          NC, _pt14
        LD          A, H
        CPL         
        LD          H, A
        LD          A, L
        CPL         
        LD          L, A
        INC         HL
_pt14:
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
        JR          C, _pt15
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt15:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_340:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        LD          A, H
        ADD         A, A
        JR          NC, _pt16
        LD          A, H
        CPL         
        LD          H, A
        LD          A, L
        CPL         
        LD          L, A
        INC         HL
_pt16:
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
        JR          C, _pt17
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt17:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_350:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_C]
        PUSH        HL
        LD          HL, [vari_D]
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        LD          A, H
        ADD         A, A
        JR          NC, _pt18
        LD          A, H
        CPL         
        LD          H, A
        LD          A, L
        CPL         
        LD          L, A
        INC         HL
_pt18:
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
        JR          C, _pt19
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt19:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_360:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_D]
        PUSH        HL
        LD          HL, [vari_C]
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        LD          A, H
        ADD         A, A
        JR          NC, _pt20
        LD          A, H
        CPL         
        LD          H, A
        LD          A, L
        CPL         
        LD          L, A
        INC         HL
_pt20:
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
        JR          C, _pt21
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt21:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_370:
        CALL        interrupt_process
        LD          HL, vars_I
        PUSH        HL
        LD          IX, blib_inkey
        CALL        call_blib
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
        LD          HL, [vars_I]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_0
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
        JR          NZ, _pt24
        DEC         HL
_pt24:
        LD          A, L
        OR          A, H
        JP          Z, _pt23
        JP          line_370
_pt23:
_pt22:
line_420:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_9
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_430:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_10
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 123
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
        JR          C, _pt25
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt25:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_440:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_11
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 0
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
        JR          C, _pt26
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt26:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_450:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_12
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 234
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
        LD          HL, work_dac
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_single_real
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt27:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_460:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_13
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_43123000
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt28
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt28:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_470:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_14
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_40000000
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt29
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt29:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_480:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_15
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_43234000
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_neg
        LD          HL, work_dac
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt30
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt30:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_490:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_16
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_43123000
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt31
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt31:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_500:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_17
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_40000000
        CALL        ld_dac_single_real
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt32:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_510:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_18
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_43234000
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_neg
        LD          HL, work_dac
        LD          A, 4
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_absfn
        LD          HL, work_dac
        CALL        ld_dac_single_real
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt33:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
program_termination:
        CALL        restore_h_erro
        CALL        restore_h_timi
        LD          SP, [save_stack]
        LD          HL, _basic_end
        CALL        bios_newstt
_basic_end:
        DEFB        ':', 0x81, 0x00
err_return_without_gosub:
        LD          E, 3
        JP          bios_errhand
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
        RR          H
        RR          L
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
        LD          A, 8
        LD          [work_valtyp], A
        PUSH        BC
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
ld_de_single_real:
        LD          BC, 4
        LDIR        
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
ld_dac_single_real:
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        LD          [work_dac+4], BC
        LD          [work_dac+6], BC
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
const_40000000:
        DEFB        0x40, 0x00, 0x00, 0x00
const_43123000:
        DEFB        0x43, 0x12, 0x30, 0x00
const_43234000:
        DEFB        0x43, 0x23, 0x40, 0x00
str_0:
        DEFB        0x00
str_1:
        DEFB        0x11, 0x44, 0x6F, 0x75, 0x62, 0x6C, 0x65, 0x20, 0x72, 0x65, 0x61, 0x6C, 0x20, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D
str_10:
        DEFB        0x06, 0x20, 0x31, 0x32, 0x33, 0x25, 0x3A
str_11:
        DEFB        0x06, 0x20, 0x20, 0x20, 0x30, 0x25, 0x3A
str_12:
        DEFB        0x06, 0x2D, 0x32, 0x33, 0x34, 0x25, 0x3A
str_13:
        DEFB        0x06, 0x20, 0x31, 0x32, 0x33, 0x21, 0x3A
str_14:
        DEFB        0x06, 0x20, 0x20, 0x20, 0x30, 0x21, 0x3A
str_15:
        DEFB        0x06, 0x2D, 0x32, 0x33, 0x34, 0x21, 0x3A
str_16:
        DEFB        0x06, 0x20, 0x31, 0x32, 0x33, 0x23, 0x3A
str_17:
        DEFB        0x06, 0x20, 0x20, 0x20, 0x30, 0x23, 0x3A
str_18:
        DEFB        0x06, 0x2D, 0x32, 0x33, 0x34, 0x23, 0x3A
str_2:
        DEFB        0x02, 0x0D, 0x0A
str_3:
        DEFB        0x0E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x2D, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_4:
        DEFB        0x0E, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x2D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_5:
        DEFB        0x0E, 0x28, 0x2D, 0x31, 0x30, 0x30, 0x29, 0x2D, 0x28, 0x2D, 0x32, 0x30, 0x30, 0x29, 0x3A
str_6:
        DEFB        0x0E, 0x28, 0x2D, 0x32, 0x30, 0x30, 0x29, 0x2D, 0x28, 0x2D, 0x31, 0x30, 0x30, 0x29, 0x3A
str_7:
        DEFB        0x11, 0x53, 0x69, 0x6E, 0x67, 0x6C, 0x65, 0x20, 0x72, 0x65, 0x61, 0x6C, 0x20, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D
str_8:
        DEFB        0x11, 0x49, 0x6E, 0x74, 0x65, 0x67, 0x65, 0x72, 0x20, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D
str_9:
        DEFB        0x11, 0x43, 0x6F, 0x6E, 0x73, 0x74, 0x61, 0x6E, 0x74, 0x20, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D, 0x2D
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
vard_C:
        DEFW        0, 0, 0, 0
vard_D:
        DEFW        0, 0, 0, 0
varf_A:
        DEFW        0, 0
varf_B:
        DEFW        0, 0
varf_C:
        DEFW        0, 0
varf_D:
        DEFW        0, 0
vari_A:
        DEFW        0
vari_B:
        DEFW        0
vari_C:
        DEFW        0
vari_D:
        DEFW        0
var_area_end:
vars_area_start:
vars_I:
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
