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
work_prtflg                     = 0x0f416
bios_icomp                      = 0x02f4d
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_vmovfm                     = 0x02f08
bios_neg                        = 0x02e8d
bios_frcsng                     = 0x0303a
work_csrx                       = 0x0f3dd
work_linlen                     = 0x0f3b0
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_arg                        = 0x0f847
bios_xdcomp                     = 0x02f5c
bios_frcdbl                     = 0x0303a
bios_errhand                    = 0x0406F
blib_inkey                      = 0x0402a
blib_strcmp                     = 0x04027
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
line_110:
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
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_120:
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
        CALL        ld_dac_single_real
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
line_130:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt1
        DEC         A
_pt1:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_140:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt3
        DEC         A
_pt3:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt4
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt4:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_150:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt5
        DEC         A
_pt5:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt6
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt6:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_160:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_7
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt7
        DEC         A
_pt7:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_170:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_8
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_180:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_9
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
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
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt11
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt11:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_190:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_10
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt12
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
        CALL        ld_dac_single_real
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt13:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_200:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_11
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_B]
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt14
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt14:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_210:
        CALL        interrupt_process
        CALL        line_2000
line_220:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_12
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
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
        CALL        ld_dac_single_real
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
line_230:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_13
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt16
        DEC         A
_pt16:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_240:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_14
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt18
        DEC         A
_pt18:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_250:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_15
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt20
        DEC         A
_pt20:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_260:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_16
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt22
        DEC         A
_pt22:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt23
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt23:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_270:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_17
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt24
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt24:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_280:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_18
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt25
        DEC         A
_pt25:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_290:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_19
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt27
        DEC         A
_pt27:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_300:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_20
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_310:
        CALL        interrupt_process
        CALL        line_2000
line_320:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_21
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
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
line_330:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_22
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt31
        DEC         A
_pt31:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
line_340:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_23
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt33
        DEC         A
_pt33:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt34
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt34:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_350:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_24
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt35
        DEC         A
_pt35:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt36
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt36:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_360:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_25
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt37
        DEC         A
_pt37:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt38
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt38:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_370:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_26
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt39
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt39:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_380:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_27
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt40
        DEC         A
_pt40:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt41
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt41:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_390:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_28
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _pt42
        DEC         A
_pt42:
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt43
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt43:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_400:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_29
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_A]
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt44
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt44:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_410:
        CALL        interrupt_process
        CALL        line_2000
line_415:
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
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_30
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_420:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_31
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
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
        CALL        ld_dac_single_real
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt45:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_430:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_32
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt46
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt46:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_440:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_33
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt47
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt47:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_450:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_34
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt48
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt48:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_460:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_35
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt49
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt49:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_470:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_36
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt50
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt50:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_480:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_37
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt51
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt51:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_490:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_38
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt52
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt52:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_500:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_39
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_B
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt53
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt53:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_510:
        CALL        interrupt_process
        CALL        line_2000
line_520:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_40
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
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
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt54
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt54:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_530:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_41
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt55
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt55:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_540:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_42
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt56
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt56:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_550:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_43
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt57
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt57:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_560:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_44
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt58
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt58:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_570:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_45
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt59
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt59:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_580:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_46
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt60
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt60:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_590:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_47
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt61
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt61:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_600:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_48
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_B
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt62
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt62:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_610:
        CALL        interrupt_process
        CALL        line_2000
line_620:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_49
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
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
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt63
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt63:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_630:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_50
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt64
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt64:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_640:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_51
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt65
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt65:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_650:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_52
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt66
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt66:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_660:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_53
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt67
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt67:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_670:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_54
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt68
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt68:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_680:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_55
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt69
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt69:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_690:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_56
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt70
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt70:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_700:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_57
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, varf_A
        CALL        push_single_real_hl
        LD          HL, varf_A
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt71
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt71:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_710:
        CALL        interrupt_process
        CALL        line_2000
line_715:
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
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_58
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_720:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_59
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
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
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt72
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt72:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_730:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_60
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt73
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt73:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_740:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_61
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt74
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt74:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_750:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_62
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt75
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt75:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_760:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_63
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt76
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt76:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_770:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_64
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt77
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt77:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_780:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_65
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt78
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt78:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_790:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_66
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt79
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt79:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_800:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_67
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_B
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt80
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt80:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_810:
        CALL        interrupt_process
        CALL        line_2000
line_820:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_68
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
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
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt81
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt81:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_830:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_69
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt82
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt82:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_840:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_70
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt83
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt83:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_850:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_71
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt84
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt84:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_860:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_72
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt85
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt85:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_870:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_73
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt86
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt86:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_880:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_74
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt87
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt87:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_890:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_75
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt88
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt88:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_900:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_76
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_B
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt89
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt89:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_910:
        CALL        interrupt_process
        CALL        line_2000
line_920:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_77
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
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
        CALL        ld_dac_single_real
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt90
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt90:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_930:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_78
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt91
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt91:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_940:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_79
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt92
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt92:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_950:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_80
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt93
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt93:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_960:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_81
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt94
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt94:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_970:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_82
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt95
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt95:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_980:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_83
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt96
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt96:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_990:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_84
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        DEC         A
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt97
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt97:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_1000:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_85
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, vard_A
        CALL        push_double_real_hl
        LD          HL, vard_A
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcsng
        CALL        bios_neg
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
        JR          C, _pt98
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt98:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
line_1010:
        CALL        interrupt_process
        CALL        line_2000
line_1020:
        CALL        interrupt_process
        JP          program_termination
line_2000:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_86
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_2010:
        CALL        interrupt_process
        LD          IX, blib_inkey
        CALL        call_blib
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
        JR          NZ, _pt101
        DEC         HL
_pt101:
        LD          A, L
        OR          A, H
        JP          Z, _pt100
        JP          line_2010
_pt100:
_pt99:
line_2020:
        CALL        interrupt_process
        RET         
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
ld_dac_single_real:
        LD          DE, work_dac
        LD          BC, 4
        LDIR        
        LD          [work_dac+4], BC
        LD          [work_dac+6], BC
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
pop_single_real_arg:
        POP         BC
        POP         HL
        LD          [work_arg+2], HL
        POP         HL
        LD          [work_arg+0], HL
        LD          HL, 0
        LD          [work_arg+4], HL
        LD          [work_arg+6], HL
        PUSH        BC
        RET         
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
pop_double_real_arg:
        POP         BC
        POP         HL
        LD          [work_arg+6], HL
        POP         HL
        LD          [work_arg+4], HL
        POP         HL
        LD          [work_arg+2], HL
        POP         HL
        LD          [work_arg+0], HL
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
        RET         
interrupt_process:
        LD          HL, [svari_on_interval_line]
        LD          A, L
        OR          A, H
        JR          Z, _skip_on_interval
        LD          A, [svarb_on_interval_exec]
        DEC         A
        JR          NZ, _skip_on_interval
        LD          [svarb_on_interval_exec], A
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
str_0:
        DEFB        0x00
str_1:
        DEFB        0x0F, 0x54, 0x45, 0x53, 0x54, 0x20, 0x4F, 0x46, 0x20, 0x49, 0x4E, 0x54, 0x45, 0x47, 0x45, 0x52
str_10:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_11:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_12:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_13:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_14:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_15:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_16:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_17:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_18:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_19:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_2:
        DEFB        0x02, 0x0D, 0x0A
str_20:
        DEFB        0x0E, 0x69, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_21:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_22:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_23:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_24:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_25:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_26:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_27:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_28:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_29:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_3:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_30:
        DEFB        0x13, 0x54, 0x45, 0x53, 0x54, 0x20, 0x4F, 0x46, 0x20, 0x53, 0x49, 0x4E, 0x47, 0x4C, 0x45, 0x20, 0x52, 0x45, 0x41, 0x4C
str_31:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_32:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_33:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_34:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_35:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_36:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_37:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_38:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_39:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_4:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_40:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_41:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_42:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_43:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_44:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_45:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_46:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_47:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_48:
        DEFB        0x0E, 0x73, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_49:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_5:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_50:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_51:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_52:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_53:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_54:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_55:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_56:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_57:
        DEFB        0x0E, 0x73, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_58:
        DEFB        0x13, 0x54, 0x45, 0x53, 0x54, 0x20, 0x4F, 0x46, 0x20, 0x44, 0x4F, 0x55, 0x42, 0x4C, 0x45, 0x20, 0x52, 0x45, 0x41, 0x4C
str_59:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_6:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_60:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_61:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_62:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_63:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_64:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_65:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_66:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_67:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_68:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_69:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_7:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_70:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_71:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_72:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_73:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_74:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_75:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_76:
        DEFB        0x0E, 0x64, 0x29, 0x32, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_77:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_78:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_79:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x20, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_8:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
str_80:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_81:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3D, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_82:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3C, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_83:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_84:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3E, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_85:
        DEFB        0x0E, 0x64, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3E, 0x3C, 0x20, 0x31, 0x30, 0x30, 0x20, 0x3A
str_86:
        DEFB        0x0A, 0x50, 0x52, 0x45, 0x53, 0x53, 0x20, 0x4B, 0x45, 0x59, 0x21
str_9:
        DEFB        0x0E, 0x69, 0x29, 0x31, 0x30, 0x30, 0x20, 0x3D, 0x3C, 0x20, 0x32, 0x30, 0x30, 0x20, 0x3A
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
varf_A:
        DEFW        0, 0
varf_B:
        DEFW        0, 0
vari_A:
        DEFW        0
vari_B:
        DEFW        0
var_area_end:
vars_area_start:
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
