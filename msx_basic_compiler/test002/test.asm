; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
work_h_timi                     = 0x0fd9f
work_h_erro                     = 0x0ffb1
work_himem                      = 0x0FC4A
blib_init_ncalbas               = 0x0404e
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
bios_errhand                    = 0x0406F
blib_mid                        = 0x04033
bios_posit                      = 0x000C6
work_csry                       = 0x0F3DC
work_csrx                       = 0x0F3DD
work_csrsw                      = 0x0FCA9
work_prtflg                     = 0x0f416
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
work_linlen                     = 0x0f3b0
blib_left                       = 0x04030
blib_right                      = 0x0402d
blib_inkey                      = 0x0402a
work_dac                        = 0x0f7f6
bios_frcsng                     = 0x02fb2
bios_frcdbl                     = 0x0303a
blib_mid_cmd                    = 0x0406c
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
        LD          SP, [work_himem]
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
        LD          HL, 1000
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
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          HL, str_1
        PUSH        HL
        LD          HL, 2
        PUSH        HL
        LD          HL, 5
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 0
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt4:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_120:
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
        LD          HL, 1000
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
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          HL, str_3
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 1
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt9:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_130:
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
        LD          HL, 1000
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
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          HL, str_1
        PUSH        HL
        LD          HL, 3
        LD          C, L
        POP         HL
        PUSH        HL
        LD          IX, blib_left
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 2
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_140:
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
        LD          HL, 1000
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
        LD          HL, _pt16
        LD          [svari_I_LABEL], HL
        JR          _pt15
_pt16:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt17
        RST         0x20
        JR          C, _pt18
        JR          Z, _pt18
        RET         NC
_pt17:
        RST         0x20
        RET         C
_pt18:
        POP         HL
_pt15:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          HL, str_1
        PUSH        HL
        LD          HL, 3
        LD          C, L
        POP         HL
        PUSH        HL
        LD          IX, blib_right
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 3
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_150:
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
        LD          HL, 1000
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
        LD          HL, _pt21
        LD          [svari_I_LABEL], HL
        JR          _pt20
_pt21:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt22
        RST         0x20
        JR          C, _pt23
        JR          Z, _pt23
        RET         NC
_pt22:
        RST         0x20
        RET         C
_pt23:
        POP         HL
_pt20:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          HL, str_4
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 4
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_160:
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
        LD          HL, 1000
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
        LD          HL, _pt26
        LD          [svari_I_LABEL], HL
        JR          _pt25
_pt26:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt27
        RST         0x20
        JR          C, _pt28
        JR          Z, _pt28
        RET         NC
_pt27:
        RST         0x20
        RET         C
_pt28:
        POP         HL
_pt25:
        CALL        interrupt_process
        LD          HL, vars_A
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 5
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_170:
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
        LD          HL, 1000
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
        LD          HL, _pt31
        LD          [svari_I_LABEL], HL
        JR          _pt30
_pt31:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt32
        RST         0x20
        JR          C, _pt33
        JR          Z, _pt33
        RET         NC
_pt32:
        RST         0x20
        RET         C
_pt33:
        POP         HL
_pt30:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          A, 3
        CALL        allocate_string
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 234
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        INC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        DEC         HL
        DEC         HL
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 6
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_180:
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
        LD          HL, 1000
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
        LD          HL, _pt36
        LD          [svari_I_LABEL], HL
        JR          _pt35
_pt36:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt37
        RST         0x20
        JR          C, _pt38
        JR          Z, _pt38
        RET         NC
_pt37:
        RST         0x20
        RET         C
_pt38:
        POP         HL
_pt35:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          A, 5
        CALL        allocate_string
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 234
        POP         DE
        ADD         HL, DE
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcsng
        LD          HL, work_dac
        POP         DE
        PUSH        DE
        INC         DE
        LD          BC, 4
        LDIR        
        POP         HL
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 7
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_190:
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
        LD          HL, 1000
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
        LD          HL, _pt41
        LD          [svari_I_LABEL], HL
        JR          _pt40
_pt41:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt42
        RST         0x20
        JR          C, _pt43
        JR          Z, _pt43
        RET         NC
_pt42:
        RST         0x20
        RET         C
_pt43:
        POP         HL
_pt40:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          A, 9
        CALL        allocate_string
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 234
        POP         DE
        ADD         HL, DE
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        PUSH        DE
        INC         DE
        LD          BC, 8
        LDIR        
        POP         HL
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 8
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_200:
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
        LD          HL, 1000
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
        LD          HL, _pt46
        LD          [svari_I_LABEL], HL
        JR          _pt45
_pt46:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt47
        RST         0x20
        JR          C, _pt48
        JR          Z, _pt48
        RET         NC
_pt47:
        RST         0x20
        RET         C
_pt48:
        POP         HL
_pt45:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          HL, str_1
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
        LD          HL, vars_A
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        DE
        PUSH        HL
        EX          DE, HL
        CALL        copy_string
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        POP         HL
        PUSH        DE
        CALL        free_string
        LD          HL, 2
        LD          B, L
        PUSH        BC
        LD          HL, 3
        POP         BC
        LD          C, L
        PUSH        BC
        LD          HL, str_3
        POP         BC
        POP         DE
        PUSH        HL
        EX          DE, HL
        LD          IX, blib_mid_cmd
        CALL        call_blib
        POP         HL
        CALL        free_string
        CALL        interrupt_process
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 9
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
line_210:
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
        LD          HL, 1000
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
        LD          HL, _pt51
        LD          [svari_I_LABEL], HL
        JR          _pt50
_pt51:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt52
        RST         0x20
        JR          C, _pt53
        JR          Z, _pt53
        RET         NC
_pt52:
        RST         0x20
        RET         C
_pt53:
        POP         HL
_pt50:
        CALL        interrupt_process
        LD          HL, vars_A
        PUSH        HL
        LD          A, 1
        CALL        allocate_string
        PUSH        HL
        LD          HL, 100
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
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
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [heap_end]
        LD          DE, [heap_next]
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 10
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, [vari_A]
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
        CALL        interrupt_process
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
program_termination:
        CALL        restore_h_erro
        CALL        restore_h_timi
        LD          SP, [work_himem]
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
program_run:
        LD          HL, heap_start
        LD          [heap_next], HL
        LD          HL, [work_himem]
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
str_0:
        DEFB        0x00
str_1:
        DEFB        0x06, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36
str_2:
        DEFB        0x02, 0x0D, 0x0A
str_3:
        DEFB        0x04, 0x31, 0x32, 0x33, 0x34
str_4:
        DEFB        0x0A, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
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
vari_I:
        DEFW        0
var_area_end:
vars_area_start:
vars_A:
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
