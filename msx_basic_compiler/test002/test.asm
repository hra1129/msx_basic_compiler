; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
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
work_romver                     = 0x0002D
bios_chgmod                     = 0x0005F
bios_chgmodp                    = 0x001B5
bios_extrom                     = 0x0015F
work_rg1sv                      = 0x0f3e0
bios_wrtvdp                     = 0x00047
blib_width                      = 0x0403c
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
bios_erafnk                     = 0x000CC
work_usrtab                     = 0x0f39a
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_frcint                     = 0x02f8a
bios_errhand_redim              = 0x0405e
bios_umult                      = 0x0314a
bios_errhand                    = 0x0406F
bios_gtstck                     = 0x00d5
bios_gttrig                     = 0x00d8
bios_icomp                      = 0x02f4d
blib_inkey                      = 0x0402a
blib_strcmp                     = 0x04027
bios_wrtvrm                     = 0x004d
bios_nwrvrm                     = 0x0177
work_scrmod                     = 0xFCAF
bios_idiv                       = 0x031e6
bios_imult                      = 0x03193
bios_rdvrm                      = 0x004A
bios_nrdvrm                     = 0x0174
bios_cls                        = 0x000C3
bios_posit                      = 0x000C6
work_csry                       = 0x0F3DC
work_csrx                       = 0x0F3DD
work_csrsw                      = 0x0FCA9
work_prtflg                     = 0x0f416
blib_mid                        = 0x04033
work_buf                        = 0x0f55e
bios_fin                        = 0x3299
bios_frcdbl                     = 0x303a
bios_fout                       = 0x03425
bios_fouth                      = 0x03722
bios_foutb                      = 0x0371a
blib_right                      = 0x0402d
work_arg                        = 0x0f847
bios_decadd                     = 0x0269a
blib_left                       = 0x04030
bios_newstt                     = 0x04601
; BSAVE HEADER -----------------------------------------------------------
        DEFB        0XFE
        DEFW        START_ADDRESS
        DEFW        END_ADDRESS
        DEFW        START_ADDRESS
        ORG         0X8010
START_ADDRESS:
        LD          SP, [WORK_HIMEM]
        CALL        CHECK_BLIB
        JP          NZ, BIOS_SYNTAX_ERROR
        LD          IX, BLIB_INIT_NCALBAS
        CALL        CALL_BLIB
        LD          HL, WORK_H_TIMI
        LD          DE, H_TIMI_BACKUP
        LD          BC, 5
        LDIR        
        DI          
        CALL        SETUP_H_TIMI
        LD          HL, _CODE_RET
        LD          [SVARI_ON_SPRITE_LINE], HL
        LD          [SVARI_ON_INTERVAL_LINE], HL
        LD          [SVARI_ON_KEY01_LINE], HL
        LD          HL, SVARI_ON_KEY01_LINE
        LD          DE, SVARI_ON_KEY01_LINE + 2
        LD          BC, 20 - 2
        LDIR        
        CALL        SETUP_H_ERRO
        EI          
        LD          DE, PROGRAM_START
        JP          PROGRAM_RUN
SETUP_H_TIMI:
        LD          HL, H_TIMI_HANDLER
        LD          [WORK_H_TIMI + 1], HL
        LD          A, 0XC3
        LD          [WORK_H_TIMI], A
        RET         
SETUP_H_ERRO:
        LD          HL, WORK_H_ERRO
        LD          DE, H_ERRO_BACKUP
        LD          BC, 5
        LDIR        
        LD          HL, H_ERRO_HANDLER
        LD          [WORK_H_ERRO + 1], HL
        LD          A, 0XC3
        LD          [WORK_H_ERRO], A
        RET         
JP_HL:
        JP          HL
PROGRAM_START:
LINE_10000:
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          A, [work_romver]
        OR          A, A
        LD          A, L
        JR          NZ, _pt0
        CALL        bios_chgmod
        JR          _pt1
_pt0:
        LD          IX, bios_chgmodp
        CALL        bios_extrom
_pt1:
        XOR         A, A
        AND         A, 3
        LD          L, A
        LD          A, [work_rg1sv]
        AND         A, 0xFC
        OR          A, L
        LD          B, A
        LD          C, 1
        CALL        bios_wrtvdp
        CALL        INTERRUPT_PROCESS
        LD          HL, 32
        LD          ix, blib_width
        CALL        call_blib
        CALL        INTERRUPT_PROCESS
        LD          A, 15
        LD          [work_forclr], A
        LD          A, 1
        LD          [work_bakclr], A
        LD          A, 1
        LD          [work_bdrclr], A
        CALL        bios_chgclr
        CALL        INTERRUPT_PROCESS
        CALL        bios_erafnk
        CALL        INTERRUPT_PROCESS
LINE_10001:
        CALL        INTERRUPT_PROCESS
        LD          HL, 126
        LD          [work_usrtab + 0], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_A
        PUSH        HL
        LD          HL, 0
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        LD          HL, _pt2
        PUSH        HL
        LD          HL, [work_usrtab + 0]
        PUSH        HL
        LD          HL, work_dac
        RET         
_pt2:
        CALL        bios_frcint
        LD          HL, [work_dac + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, 53248
        DI          
        LD          SP, HL
        LD          [work_himem], HL
        LD          DE, err_return_without_gosub
        PUSH        DE
        EI          
        LD          DE, _pt3
        JP          program_run
_pt3:
LINE_10010:
; ===========================
LINE_10011:
; Variables Definition
LINE_10012:
; ===========================
LINE_10013:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X1
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y1
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
; EDIT CURSOR
LINE_10014:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X2
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y2
        PUSH        HL
        LD          HL, 128
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
; CHAR SELECT CURSOR
LINE_10015:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_SP
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
; MODE SELECT
LINE_10016:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_SC
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
; SELECTED CHARACTER
LINE_10017:
        CALL        INTERRUPT_PROCESS
        LD          HL, [varia_PT]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 4
        INC         HL
        PUSH        HL
        EX          DE, HL
        PUSH        DE
        LD          HL, 8
        POP         BC
        INC         HL
        PUSH        HL
        EX          DE, HL
        CALL        bios_umult
        EX          DE, HL
        ADD         HL, HL
        LD          DE, 7
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varia_PT], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          A, 2
        LD          [HL], A
        INC         HL
_pt4:
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         A
        JR          NZ, _pt4
        LD          HL, [varia_PC]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 4
        INC         HL
        PUSH        HL
        EX          DE, HL
        PUSH        DE
        LD          HL, 8
        POP         BC
        INC         HL
        PUSH        HL
        EX          DE, HL
        CALL        bios_umult
        EX          DE, HL
        ADD         HL, HL
        LD          DE, 7
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varia_PC], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          A, 2
        LD          [HL], A
        INC         HL
_pt5:
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         A
        JR          NZ, _pt5
; PATTERN AND COLOR
LINE_10500:
        CALL        INTERRUPT_PROCESS
        CALL        line_11100
        CALL        INTERRUPT_PROCESS
        CALL        line_12000
        CALL        INTERRUPT_PROCESS
        CALL        line_10750
LINE_10550:
        CALL        INTERRUPT_PROCESS
        DI          
        LD          HL, 15
        LD          [svari_on_interval_value], HL
        LD          [svari_on_interval_counter], HL
        LD          HL, line_10600
        LD          [svari_on_interval_line], HL
        EI          
        CALL        INTERRUPT_PROCESS
        LD          A, 1
        LD          [svarb_on_interval_mode], A
LINE_10551:
        CALL        INTERRUPT_PROCESS
        LD          A, 1
        LD          [svarb_on_interval_mode], A
        CALL        INTERRUPT_PROCESS
        JP          line_10551
LINE_10600:
; ===========================
LINE_10601:
; MAIN ROUTINE 
LINE_10602:
; ===========================
LINE_10607:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_ST
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
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_10608:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_TR
        PUSH        HL
        LD          HL, 0
        LD          A, L
        CALL        bios_gttrig
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          HL, 1
        LD          A, L
        CALL        bios_gttrig
        LD          L, A
        LD          H, A
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_10609:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [vari_TR]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
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
        JP          Z, _pt7
        JP          line_10643
_pt7:
_pt6:
LINE_10610:
; CURSOR MOVE
LINE_10611:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_SP]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt9
        JP          line_10625
_pt9:
_pt8:
LINE_10612:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 3
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt11
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X1
        PUSH        HL
        LD          HL, [vari_X1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt10
_pt11:
_pt10:
LINE_10613:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 7
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt13
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X1
        PUSH        HL
        LD          HL, [vari_X1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt12
_pt13:
_pt12:
LINE_10614:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 5
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt15
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y1
        PUSH        HL
        LD          HL, [vari_Y1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt14
_pt15:
_pt14:
LINE_10615:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt17
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y1
        PUSH        HL
        LD          HL, [vari_Y1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt16
_pt17:
_pt16:
LINE_10616:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_X1]
        PUSH        HL
        LD          HL, 120
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt20
        DEC         A
_pt20:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt19
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X1
        PUSH        HL
        LD          HL, 120
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt18
_pt19:
_pt18:
LINE_10617:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_X1]
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt23
        DEC         A
_pt23:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt22
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X1
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt21
_pt22:
_pt21:
LINE_10618:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_Y1]
        PUSH        HL
        LD          HL, 120
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt26
        DEC         A
_pt26:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt25
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y1
        PUSH        HL
        LD          HL, 120
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt24
_pt25:
_pt24:
LINE_10619:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_Y1]
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt29
        DEC         A
_pt29:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt28
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y1
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt27
_pt28:
_pt27:
LINE_10620:
        CALL        INTERRUPT_PROCESS
        JP          line_10641
LINE_10625:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 3
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt31
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X2
        PUSH        HL
        LD          HL, [vari_X2]
        PUSH        HL
        LD          HL, 8
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt30
_pt31:
_pt30:
LINE_10626:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 7
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt33
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X2
        PUSH        HL
        LD          HL, [vari_X2]
        PUSH        HL
        LD          HL, 8
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt32
_pt33:
_pt32:
LINE_10627:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 5
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt35
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y2
        PUSH        HL
        LD          HL, [vari_Y2]
        PUSH        HL
        LD          HL, 8
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt34
_pt35:
_pt34:
LINE_10628:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_ST]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt37
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y2
        PUSH        HL
        LD          HL, [vari_Y2]
        PUSH        HL
        LD          HL, 8
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt36
_pt37:
_pt36:
LINE_10629:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_X2]
        PUSH        HL
        LD          HL, 247
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt40
        DEC         A
_pt40:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt39
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X2
        PUSH        HL
        LD          HL, 247
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt38
_pt39:
_pt38:
LINE_10630:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_X2]
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt43
        DEC         A
_pt43:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt42
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X2
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt41
_pt42:
_pt41:
LINE_10631:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_Y2]
        PUSH        HL
        LD          HL, 184
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt46
        DEC         A
_pt46:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt45
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y2
        PUSH        HL
        LD          HL, 184
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt44
_pt45:
_pt44:
LINE_10632:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_Y2]
        PUSH        HL
        LD          HL, 128
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _pt49
        DEC         A
_pt49:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt48
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y2
        PUSH        HL
        LD          HL, 128
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt47
_pt48:
_pt47:
LINE_10640:
; TRIGGER CHECK
LINE_10641:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_TR]
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
        JP          Z, _pt51
        JP          line_10643
_pt51:
_pt50:
LINE_10642:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_SP]
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
        JP          Z, _pt53
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_SP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt52
_pt53:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_SP
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
_pt52:
LINE_10643:
        CALL        INTERRUPT_PROCESS
        CALL        line_10750
LINE_10644:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_A
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
        CALL        FREE_STRING
        CALL        INTERRUPT_PROCESS
        LD          HL, [vars_A]
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
        JR          NZ, _pt56
        DEC         HL
_pt56:
        PUSH        HL
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_2
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
        JR          NZ, _pt57
        DEC         HL
_pt57:
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _pt55
        JP          line_10999
_pt55:
_pt54:
LINE_10645:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_3
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
        JR          NZ, _pt60
        DEC         HL
_pt60:
        PUSH        HL
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        LD          HL, str_4
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
        JR          NZ, _pt61
        DEC         HL
_pt61:
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _pt59
        CALL        INTERRUPT_PROCESS
        CALL        line_10810
        JP          _pt58
_pt59:
_pt58:
LINE_10698:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_10699:
; GOTO10604 'RETURN10551 
LINE_10750:
; DISPLAY SPRITE
LINE_10751:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_SP]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt63
        JP          line_10757
_pt63:
_pt62:
LINE_10752:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6912
        PUSH        HL
        LD          HL, [vari_Y1]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt65
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt65
_pt64:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt65:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6913
        PUSH        HL
        LD          HL, [vari_X1]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt67
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt67
_pt66:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt67:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6914
        PUSH        HL
        LD          HL, 0
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt69
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt69
_pt68:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt69:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6915
        PUSH        HL
        LD          HL, 15
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt71
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt71
_pt70:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt71:
LINE_10753:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6916
        PUSH        HL
        LD          HL, [vari_Y1]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt73
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt73
_pt72:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt73:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6917
        PUSH        HL
        LD          HL, [vari_X1]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt75
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt75
_pt74:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt75:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6918
        PUSH        HL
        LD          HL, 1
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt77
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt77
_pt76:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt77:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6919
        PUSH        HL
        LD          HL, 7
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt79
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt79
_pt78:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt79:
LINE_10754:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6920
        PUSH        HL
        LD          HL, 209
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt81
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt81
_pt80:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt81:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6921
        PUSH        HL
        LD          HL, [vari_X2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt83
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt83
_pt82:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt83:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6922
        PUSH        HL
        LD          HL, 0
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt85
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt85
_pt84:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt85:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6923
        PUSH        HL
        LD          HL, 15
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt87
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt87
_pt86:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt87:
LINE_10755:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6924
        PUSH        HL
        LD          HL, 209
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt89
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt89
_pt88:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt89:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6925
        PUSH        HL
        LD          HL, [vari_X2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt91
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt91
_pt90:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt91:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6926
        PUSH        HL
        LD          HL, 1
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt93
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt93
_pt92:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt93:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6927
        PUSH        HL
        LD          HL, 7
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt95
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt95
_pt94:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt95:
LINE_10756:
        CALL        INTERRUPT_PROCESS
        JP          line_10770
LINE_10757:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6912
        PUSH        HL
        LD          HL, 209
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt97
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt97
_pt96:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt97:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6913
        PUSH        HL
        LD          HL, [vari_X1]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt99
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt99
_pt98:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt99:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6914
        PUSH        HL
        LD          HL, 0
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt101
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt101
_pt100:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt101:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6915
        PUSH        HL
        LD          HL, 15
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt103
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt103
_pt102:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt103:
LINE_10758:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6916
        PUSH        HL
        LD          HL, 209
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt105
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt105
_pt104:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt105:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6917
        PUSH        HL
        LD          HL, [vari_X1]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt107
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt107
_pt106:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt107:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6918
        PUSH        HL
        LD          HL, 1
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt109
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt109
_pt108:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt109:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6919
        PUSH        HL
        LD          HL, 7
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt111
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt111
_pt110:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt111:
LINE_10759:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6920
        PUSH        HL
        LD          HL, [vari_Y2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt113
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt113
_pt112:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt113:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6921
        PUSH        HL
        LD          HL, [vari_X2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt115
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt115
_pt114:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt115:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6922
        PUSH        HL
        LD          HL, 0
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt117
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt117
_pt116:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt117:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6923
        PUSH        HL
        LD          HL, 15
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt119
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt119
_pt118:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt119:
LINE_10760:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6924
        PUSH        HL
        LD          HL, [vari_Y2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt121
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt121
_pt120:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt121:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6925
        PUSH        HL
        LD          HL, [vari_X2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt123
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt123
_pt122:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt123:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6926
        PUSH        HL
        LD          HL, 1
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt125
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt125
_pt124:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt125:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6927
        PUSH        HL
        LD          HL, 7
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt127
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt127
_pt126:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt127:
LINE_10770:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_10810:
; SELECT
LINE_10820:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_SP]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt129
        JP          line_10880
_pt129:
_pt128:
LINE_10821:
        CALL        INTERRUPT_PROCESS
        JP          line_10899
LINE_10880:
; SELECT A CHARACTER
LINE_10881:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_SX
        PUSH        HL
        LD          HL, [vari_X2]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_idiv
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_SY
        PUSH        HL
        LD          HL, [vari_Y2]
        PUSH        HL
        LD          HL, 128
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_idiv
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_10882:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CC
        PUSH        HL
        LD          HL, [vari_SY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        bios_imult
        PUSH        HL
        LD          HL, [vari_SX]
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_10883:
; READ PATTERN DATAS
LINE_10884:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_AI
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_AI_FOR_END
        PUSH        HL
        LD          HL, 3
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_AI_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt131
        LD          [svari_AI_LABEL], HL
        JR          _pt130
_pt131:
        LD          HL, [vari_AI]
        LD          DE, [svari_AI_FOR_STEP]
        ADD         HL, DE
        LD          [vari_AI], HL
        LD          A, D
        LD          DE, [svari_AI_FOR_END]
        RLCA        
        JR          C, _pt132
        RST         0x20
        JR          C, _pt133
        JR          Z, _pt133
        RET         NC
_pt132:
        RST         0x20
        RET         C
_pt133:
        POP         HL
_pt130:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_AJ
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_AJ_FOR_END
        PUSH        HL
        LD          HL, 7
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_AJ_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt135
        LD          [svari_AJ_LABEL], HL
        JR          _pt134
_pt135:
        LD          HL, [vari_AJ]
        LD          DE, [svari_AJ_FOR_STEP]
        ADD         HL, DE
        LD          [vari_AJ], HL
        LD          A, D
        LD          DE, [svari_AJ_FOR_END]
        RLCA        
        JR          C, _pt136
        RST         0x20
        JR          C, _pt137
        JR          Z, _pt137
        RET         NC
_pt136:
        RST         0x20
        RET         C
_pt137:
        POP         HL
_pt134:
LINE_10885:
        CALL        INTERRUPT_PROCESS
        LD          HL, varia_PT
        LD          D, 2
        LD          BC, 249
        CALL        check_array
        CALL        calc_array_top
        LD          HL, [vari_AJ]
        LD          C, L
        LD          B, H
        POP         DE
        CALL        bios_umult
        PUSH        DE
        LD          HL, [vari_AI]
        POP         DE
        ADD         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 4096
        PUSH        HL
        LD          HL, [vari_CC]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_AJ]
        POP         DE
        ADD         HL, DE
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt139
        CALL        bios_rdvrm
        LD          L, A
        LD          H, 0
        JR          _pt139
        CALL        bios_nrdvrm
        LD          L, A
        LD          H, 0
_pt139:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, varia_PC
        LD          D, 2
        LD          BC, 249
        CALL        check_array
        CALL        calc_array_top
        LD          HL, [vari_AJ]
        LD          C, L
        LD          B, H
        POP         DE
        CALL        bios_umult
        PUSH        DE
        LD          HL, [vari_AI]
        POP         DE
        ADD         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 12288
        PUSH        HL
        LD          HL, [vari_CC]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_AJ]
        POP         DE
        ADD         HL, DE
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt141
        CALL        bios_rdvrm
        LD          L, A
        LD          H, 0
        JR          _pt141
        CALL        bios_nrdvrm
        LD          L, A
        LD          H, 0
_pt141:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_AJ_LABEL]
        CALL        jp_hl
LINE_10886:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_AI]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt143
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CC
        PUSH        HL
        LD          HL, [vari_CC]
        PUSH        HL
        LD          HL, 30
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt142
_pt143:
_pt142:
LINE_10887:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CC
        PUSH        HL
        LD          HL, [vari_CC]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_10888:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_AI_LABEL]
        CALL        jp_hl
LINE_10898:
        CALL        INTERRUPT_PROCESS
        CALL        line_13000
LINE_10899:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_10999:
        CALL        INTERRUPT_PROCESS
        CALL        bios_cls
        CALL        INTERRUPT_PROCESS
        JP          program_termination
LINE_11000:
; ===========================
LINE_11001:
; INITIAL EDIT CELL CREATE
LINE_11002:
; BLANK CELL=&H80
LINE_11003:
; COLOR CELL=&H81-&H8F (COLOR1-15)
LINE_11004:
; ===========================
LINE_11100:
        CALL        INTERRUPT_PROCESS
        LD          HL, data_19200
        LD          [data_ptr], HL
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        XOR         A, A
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_6
        CALL        puts
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_I
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 2047
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
        LD          HL, _pt145
        LD          [svari_I_LABEL], HL
        JR          _pt144
_pt145:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt146
        RST         0x20
        JR          C, _pt147
        JR          Z, _pt147
        RET         NC
_pt146:
        RST         0x20
        RET         C
_pt147:
        POP         HL
_pt144:
LINE_11101:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CV
        PUSH        HL
        LD          HL, [vari_I]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt149
        CALL        bios_rdvrm
        LD          L, A
        LD          H, 0
        JR          _pt149
        CALL        bios_nrdvrm
        LD          L, A
        LD          H, 0
_pt149:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, 2048
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_CV]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt151
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt151
_pt150:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt151:
        CALL        INTERRUPT_PROCESS
        LD          HL, 4096
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_CV]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt153
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt153
_pt152:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt153:
LINE_11102:
        CALL        INTERRUPT_PROCESS
        LD          HL, 8192
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 241
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt155
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt155
_pt154:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt155:
        CALL        INTERRUPT_PROCESS
        LD          HL, 10240
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 241
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt157
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt157
_pt156:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt157:
        CALL        INTERRUPT_PROCESS
        LD          HL, 12288
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 241
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt159
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt159
_pt158:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt159:
LINE_11103:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          A, 1
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_7
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_6
        CALL        puts
LINE_11104:
        CALL        INTERRUPT_PROCESS
        LD          HL, data_19200
        LD          [data_ptr], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_A
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
LINE_11105:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_I
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 15
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
        LD          HL, _pt161
        LD          [svari_I_LABEL], HL
        JR          _pt160
_pt161:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt162
        RST         0x20
        JR          C, _pt163
        JR          Z, _pt163
        RET         NC
_pt162:
        RST         0x20
        RET         C
_pt163:
        POP         HL
_pt160:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_C1
        PUSH        HL
        LD          HL, 128
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_11106:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_J
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_END
        PUSH        HL
        LD          HL, 7
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
        LD          HL, _pt165
        LD          [svari_J_LABEL], HL
        JR          _pt164
_pt165:
        LD          HL, [vari_J]
        LD          DE, [svari_J_FOR_STEP]
        ADD         HL, DE
        LD          [vari_J], HL
        LD          A, D
        LD          DE, [svari_J_FOR_END]
        RLCA        
        JR          C, _pt166
        RST         0x20
        JR          C, _pt167
        JR          Z, _pt167
        RET         NC
_pt166:
        RST         0x20
        RET         C
_pt167:
        POP         HL
_pt164:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_PV
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        LD          HL, [vari_J]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        bios_imult
        PUSH        HL
        LD          HL, 1
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
        LD          A, [HL]
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
        LD          HL, [work_dac + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CV
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          HL, [vari_I]
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_fouth
        CALL        fout_adjust
        CALL        copy_string
        POP         DE
        CALL        str_add
        PUSH        HL
        LD          HL, str_9
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
        LD          A, [HL]
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
        LD          HL, [work_dac + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_11107:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_C1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        PUSH        HL
        LD          HL, [vari_J]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_PV]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt169
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt169
_pt168:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt169:
LINE_11108:
        CALL        INTERRUPT_PROCESS
        LD          HL, 2048
        PUSH        HL
        LD          HL, [vari_C1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_J]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_PV]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt171
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt171
_pt170:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt171:
LINE_11109:
        CALL        INTERRUPT_PROCESS
        LD          HL, 8192
        PUSH        HL
        LD          HL, [vari_C1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_J]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_CV]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt173
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt173
_pt172:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt173:
LINE_11110:
        CALL        INTERRUPT_PROCESS
        LD          HL, 10240
        PUSH        HL
        LD          HL, [vari_C1]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_J]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_CV]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt175
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt175
_pt174:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt175:
LINE_11111:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_J_LABEL]
        CALL        jp_hl
LINE_11112:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        CALL        INTERRUPT_PROCESS
        CALL        bios_cls
LINE_11113:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_X_FOR_END
        PUSH        HL
        LD          HL, 15
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_X_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt177
        LD          [svari_X_LABEL], HL
        JR          _pt176
_pt177:
        LD          HL, [vari_X]
        LD          DE, [svari_X_FOR_STEP]
        ADD         HL, DE
        LD          [vari_X], HL
        LD          A, D
        LD          DE, [svari_X_FOR_END]
        RLCA        
        JR          C, _pt178
        RST         0x20
        JR          C, _pt179
        JR          Z, _pt179
        RET         NC
_pt178:
        RST         0x20
        RET         C
_pt179:
        POP         HL
_pt176:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Y
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_Y_FOR_END
        PUSH        HL
        LD          HL, 15
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_Y_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt181
        LD          [svari_Y_LABEL], HL
        JR          _pt180
_pt181:
        LD          HL, [vari_Y]
        LD          DE, [svari_Y_FOR_STEP]
        ADD         HL, DE
        LD          [vari_Y], HL
        LD          A, D
        LD          DE, [svari_Y_FOR_END]
        RLCA        
        JR          C, _pt182
        RST         0x20
        JR          C, _pt183
        JR          Z, _pt183
        RET         NC
_pt182:
        RST         0x20
        RET         C
_pt183:
        POP         HL
_pt180:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6144
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_X]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 128
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt185
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt185
_pt184:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt185:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_Y_LABEL]
        CALL        jp_hl
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_X_LABEL]
        CALL        jp_hl
LINE_11114:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_I
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 255
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
        LD          HL, _pt187
        LD          [svari_I_LABEL], HL
        JR          _pt186
_pt187:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt188
        RST         0x20
        JR          C, _pt189
        JR          Z, _pt189
        RET         NC
_pt188:
        RST         0x20
        RET         C
_pt189:
        POP         HL
_pt186:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6656
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_I]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt191
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt191
_pt190:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt191:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
LINE_11115:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_12000:
; ===========================
LINE_12001:
; SPRITE DEFINITION
LINE_12002:
; ===========================
LINE_12003:
        CALL        INTERRUPT_PROCESS
        LD          HL, data_19100
        LD          [data_ptr], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_A
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
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_B
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
LINE_12004:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_I
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
        LD          HL, _pt193
        LD          [svari_I_LABEL], HL
        JR          _pt192
_pt193:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt194
        RST         0x20
        JR          C, _pt195
        JR          Z, _pt195
        RET         NC
_pt194:
        RST         0x20
        RET         C
_pt195:
        POP         HL
_pt192:
LINE_12005:
        CALL        INTERRUPT_PROCESS
        LD          HL, 14336
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        LD          HL, [vari_I]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        bios_imult
        PUSH        HL
        LD          HL, 1
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
        LD          A, [HL]
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
        LD          HL, [work_dac + 2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt197
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt197
_pt196:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt197:
LINE_12006:
        CALL        INTERRUPT_PROCESS
        LD          HL, 14344
        PUSH        HL
        LD          HL, [vari_I]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          HL, [vars_B]
        CALL        copy_string
        PUSH        HL
        LD          HL, [vari_I]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        bios_imult
        PUSH        HL
        LD          HL, 1
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
        LD          A, [HL]
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
        LD          HL, [work_dac + 2]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt199
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt199
_pt198:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt199:
LINE_12007:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
LINE_12008:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_13000:
; ===========================
LINE_13001:
; REDRAW EDIT AREA
LINE_13002:
; ===========================
LINE_13003:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_IE
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_IE_FOR_END
        PUSH        HL
        LD          HL, 3
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_IE_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt201
        LD          [svari_IE_LABEL], HL
        JR          _pt200
_pt201:
        LD          HL, [vari_IE]
        LD          DE, [svari_IE_FOR_STEP]
        ADD         HL, DE
        LD          [vari_IE], HL
        LD          A, D
        LD          DE, [svari_IE_FOR_END]
        RLCA        
        JR          C, _pt202
        RST         0x20
        JR          C, _pt203
        JR          Z, _pt203
        RET         NC
_pt202:
        RST         0x20
        RET         C
_pt203:
        POP         HL
_pt200:
LINE_13004:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_IE]
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
        JP          Z, _pt205
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_AD
        PUSH        HL
        LD          HL, 6144
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt204
_pt205:
_pt204:
LINE_13005:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_IE]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt207
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_AD
        PUSH        HL
        LD          HL, 6152
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt206
_pt207:
_pt206:
LINE_13006:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_IE]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt209
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_AD
        PUSH        HL
        LD          HL, 6400
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt208
_pt209:
_pt208:
LINE_13007:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_IE]
        PUSH        HL
        LD          HL, 3
        POP         DE
        CALL        bios_icomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt211
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_AD
        PUSH        HL
        LD          HL, 6408
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt210
_pt211:
_pt210:
LINE_13008:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_IY
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_IY_FOR_END
        PUSH        HL
        LD          HL, 7
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_IY_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt213
        LD          [svari_IY_LABEL], HL
        JR          _pt212
_pt213:
        LD          HL, [vari_IY]
        LD          DE, [svari_IY_FOR_STEP]
        ADD         HL, DE
        LD          [vari_IY], HL
        LD          A, D
        LD          DE, [svari_IY_FOR_END]
        RLCA        
        JR          C, _pt214
        RST         0x20
        JR          C, _pt215
        JR          Z, _pt215
        RET         NC
_pt214:
        RST         0x20
        RET         C
_pt215:
        POP         HL
_pt212:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_L1
        PUSH        HL
        LD          HL, str_10
        PUSH        HL
        LD          HL, varia_PT
        LD          D, 2
        LD          BC, 249
        CALL        check_array
        CALL        calc_array_top
        LD          HL, [vari_IY]
        LD          C, L
        LD          B, H
        POP         DE
        CALL        bios_umult
        PUSH        DE
        LD          HL, [vari_IE]
        POP         DE
        ADD         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_foutb
        CALL        fout_adjust
        CALL        copy_string
        POP         DE
        CALL        str_add
        PUSH        HL
        LD          HL, 8
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
        CALL        FREE_STRING
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_CU
        PUSH        HL
        LD          HL, str_11
        PUSH        HL
        LD          HL, varia_PC
        LD          D, 2
        LD          BC, 249
        CALL        check_array
        CALL        calc_array_top
        LD          HL, [vari_IY]
        LD          C, L
        LD          B, H
        POP         DE
        CALL        bios_umult
        PUSH        DE
        LD          HL, [vari_IE]
        POP         DE
        ADD         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_fouth
        CALL        fout_adjust
        CALL        copy_string
        POP         DE
        CALL        str_add
        PUSH        HL
        LD          HL, 2
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
        CALL        FREE_STRING
LINE_13009:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_IX
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_IX_FOR_END
        PUSH        HL
        LD          HL, 7
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_IX_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt217
        LD          [svari_IX_LABEL], HL
        JR          _pt216
_pt217:
        LD          HL, [vari_IX]
        LD          DE, [svari_IX_FOR_STEP]
        ADD         HL, DE
        LD          [vari_IX], HL
        LD          A, D
        LD          DE, [svari_IX_FOR_END]
        RLCA        
        JR          C, _pt218
        RST         0x20
        JR          C, _pt219
        JR          Z, _pt219
        RET         NC
_pt218:
        RST         0x20
        RET         C
_pt219:
        POP         HL
_pt216:
LINE_13010:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vars_L1]
        CALL        copy_string
        PUSH        HL
        LD          HL, [vari_IX]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 1
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
        PUSH        HL
        LD          HL, str_11
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
        JR          NZ, _pt222
        DEC         HL
_pt222:
        LD          A, L
        OR          A, H
        JP          Z, _pt221
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_BT
        PUSH        HL
        LD          HL, 128
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          HL, [vars_CU]
        CALL        copy_string
        PUSH        HL
        LD          HL, 1
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
        LD          A, [HL]
        CALL        bios_fin
        POP         HL
        POP         AF
        LD          [HL], A
        CALL        bios_frcdbl
        POP         HL
        CALL        free_string
        LD          HL, work_dac
        CALL        ld_arg_double_real
        POP         HL
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt220
_pt221:
_pt220:
LINE_13011:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vars_L1]
        CALL        copy_string
        PUSH        HL
        LD          HL, [vari_IX]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 1
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
        PUSH        HL
        LD          HL, str_12
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
        JR          NZ, _pt225
        DEC         HL
_pt225:
        LD          A, L
        OR          A, H
        JP          Z, _pt224
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_BT
        PUSH        HL
        LD          HL, 128
        PUSH        HL
        LD          HL, str_8
        PUSH        HL
        LD          HL, [vars_CU]
        CALL        copy_string
        PUSH        HL
        LD          HL, 1
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
        LD          A, [HL]
        CALL        bios_fin
        POP         HL
        POP         AF
        LD          [HL], A
        CALL        bios_frcdbl
        POP         HL
        CALL        free_string
        LD          HL, work_dac
        CALL        ld_arg_double_real
        POP         HL
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _pt223
_pt224:
_pt223:
LINE_13012:
        CALL        INTERRUPT_PROCESS
        LD          HL, [vari_AD]
        PUSH        HL
        LD          HL, [vari_IY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_IX]
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [vari_BT]
        LD          A, [work_scrmod]
        CP          A, 5
        JR          NC, _pt227
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JR          _pt227
_pt226:
        LD          A, L
        POP         HL
        CALL        bios_nwrvrm
_pt227:
LINE_13013:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_IX_LABEL]
        CALL        jp_hl
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_IY_LABEL]
        CALL        jp_hl
LINE_13014:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_IE_LABEL]
        CALL        jp_hl
LINE_13099:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_18000:
        CALL        INTERRUPT_PROCESS
        CALL        bios_cls
        CALL        INTERRUPT_PROCESS
        JP          program_termination
LINE_19000:
; ===========================
LINE_19001:
; DATAS
LINE_19002:
; ===========================
LINE_19100:
        CALL        INTERRUPT_PROCESS
LINE_19101:
        CALL        INTERRUPT_PROCESS
LINE_19200:
        CALL        INTERRUPT_PROCESS
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          SP, [WORK_HIMEM]
        LD          HL, _BASIC_END
        CALL        BIOS_NEWSTT
_BASIC_END:
        DEFB        ':', 0X81, 0X00
ERR_RETURN_WITHOUT_GOSUB:
        LD          E, 3
        JP          BIOS_ERRHAND
CHECK_BLIB:
        LD          A, [WORK_BLIBSLOT]
        LD          H, 0X40
        CALL        BIOS_ENASLT
        LD          BC, 8
        LD          HL, SIGNATURE
        LD          DE, SIGNATURE_REF
_CHECK_BLIB_LOOP:
        LD          A, [DE]
        INC         DE
        CPI         
        JR          NZ, _CHECK_BLIB_EXIT
        JP          PE, _CHECK_BLIB_LOOP
_CHECK_BLIB_EXIT:
        PUSH        AF
        LD          A, [WORK_MAINROM]
        LD          H, 0X40
        CALL        BIOS_ENASLT
        EI          
        POP         AF
        RET         
SIGNATURE_REF:
        DEFB        "BACONLIB"
CALL_BLIB:
        LD          IY, [WORK_BLIBSLOT - 1]
        CALL        BIOS_CALSLT
        EI          
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
ld_arg_double_real:
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        RET         
PROGRAM_RUN:
        LD          HL, HEAP_START
        LD          [HEAP_NEXT], HL
        LD          SP, [WORK_HIMEM]
        LD          HL, ERR_RETURN_WITHOUT_GOSUB
        PUSH        HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        LD          HL, [WORK_HIMEM]
        SBC         HL, DE
        LD          [HEAP_END], HL
        LD          HL, VAR_AREA_START
        LD          DE, VAR_AREA_START + 1
        LD          BC, VARSA_AREA_END - VAR_AREA_START - 1
        LD          [HL], 0
        LDIR        
        LD          HL, STR_0
        LD          [VARS_AREA_START], HL
        LD          HL, VARS_AREA_START
        LD          DE, VARS_AREA_START + 2
        LD          BC, VARS_AREA_END - VARS_AREA_START - 2
        LDIR        
        RET         
INTERRUPT_PROCESS:
        LD          A, [SVARB_ON_SPRITE_RUNNING]
        OR          A, A
        JR          NZ, _SKIP_ON_SPRITE
        LD          A, [SVARB_ON_SPRITE_EXEC]
        OR          A, A
        JR          Z, _SKIP_ON_SPRITE
        LD          [SVARB_ON_SPRITE_RUNNING], A
        LD          HL, [SVARI_ON_SPRITE_LINE]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        JP_HL
_ON_SPRITE_RETURN_ADDRESS:
        POP         HL
        POP         HL
        POP         HL
        XOR         A, A
        LD          [SVARB_ON_SPRITE_RUNNING], A
_SKIP_ON_SPRITE:
        LD          A, [SVARB_ON_INTERVAL_EXEC]
        DEC         A
        JR          NZ, _SKIP_ON_INTERVAL
        LD          [SVARB_ON_INTERVAL_EXEC], A
        LD          HL, [SVARI_ON_INTERVAL_LINE]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        JP_HL
        POP         HL
        POP         HL
        POP         HL
        LD          A, [SVARB_ON_INTERVAL_MODE]
        CP          A, 2
        JR          NZ, _SKIP_ON_INTERVAL
        DEC         A
        LD          [SVARB_ON_INTERVAL_MODE], A
_SKIP_ON_INTERVAL:
        LD          HL, SVARF_ON_STRIG0_MODE
        LD          DE, SVARI_ON_STRIG0_LINE
        LD          B, 5
_ON_STRIG_LOOP1:
        LD          A, [HL]
        INC         HL
        DEC         A
        JR          NZ, _SKIP_STRIG1
        OR          A, [HL]
        JR          Z, _SKIP_STRIG1
        INC         HL
        INC         A
        OR          A, [HL]
        DEC         HL
        JR          NZ, _SKIP_STRIG1
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
        CALL        JP_HL
        POP         BC
        POP         DE
        POP         HL
_SKIP_STRIG1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _ON_STRIG_LOOP1
        LD          HL, SVARF_ON_KEY01_MODE
        LD          DE, SVARI_ON_KEY01_LINE
        LD          B, 0X0A
_ON_KEY_LOOP1:
        LD          A, [HL]
        INC         HL
        AND         A, [HL]
        JR          Z, _SKIP_KEY1
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
        CALL        JP_HL
        POP         BC
        POP         DE
        POP         HL
_SKIP_KEY1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _ON_KEY_LOOP1
        RET         
INTERRUPT_PROCESS_END:
H_TIMI_HANDLER:
        PUSH        AF
        LD          B, A
        LD          A, [SVARB_ON_SPRITE_MODE]
        OR          A, A
        JR          Z, _END_OF_SPRITE
        LD          A, B
        AND         A, 0X20
        LD          [SVARB_ON_SPRITE_EXEC], A
_END_OF_SPRITE:
        LD          A, [SVARB_ON_INTERVAL_MODE]
        OR          A, A
        JR          Z, _END_OF_INTERVAL
        LD          HL, [SVARI_ON_INTERVAL_COUNTER]
        LD          A, L
        OR          A, H
        JR          Z, _HAPPNED_INTERVAL
        DEC         HL
        LD          [SVARI_ON_INTERVAL_COUNTER], HL
        JR          _END_OF_INTERVAL
_HAPPNED_INTERVAL:
        LD          A, [SVARB_ON_INTERVAL_MODE]
        DEC         A
        JR          NZ, _END_OF_INTERVAL
        INC         A
        LD          [SVARB_ON_INTERVAL_EXEC], A
        LD          HL, [SVARI_ON_INTERVAL_VALUE]
        LD          [SVARI_ON_INTERVAL_COUNTER], HL
_END_OF_INTERVAL:
        LD          HL, SVARF_ON_STRIG0_MODE
        LD          BC, 0X0500
_ON_STRIG_LOOP2:
        LD          A, [HL]
        INC         HL
        OR          A, A
        JR          Z, _SKIP_STRIG2
        LD          A, [HL]
        INC         HL
        LD          [HL], A
        DEC         HL
        LD          A, C
        PUSH        BC
        CALL        BIOS_GTTRIG
        POP         BC
        LD          [HL], A
_SKIP_STRIG2:
        INC         HL
        INC         HL
        INC         HL
        INC         C
        DJNZ        _ON_STRIG_LOOP2
_END_OF_STRIG:
        IN          A, [0XAA]
        AND         A, 0XF0
        OR          A, 6
        LD          B, A
        OUT         [0XAA], A
        IN          A, [0XA9]
        OR          A, 0X1E
        RRCA        
        LD          C, A
        LD          A, B
        INC         A
        OUT         [0XAA], A
        IN          A, [0XA9]
        OR          A, 0XFC
        AND         A, C
        LD          C, A
        LD          HL, SVARF_ON_KEY06_MODE
        LD          B, 0X90
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY07_MODE
        LD          B, 0XA0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY08_MODE
        LD          B, 0XC0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY09_MODE
        LD          B, 0X81
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY10_MODE
        LD          B, 0X82
        CALL        _ON_KEY_SUB
        LD          A, C
        XOR         A, 0X80
        LD          C, A
        LD          HL, SVARF_ON_KEY01_MODE
        LD          B, 0X90
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY02_MODE
        LD          B, 0XA0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY03_MODE
        LD          B, 0XC0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY04_MODE
        LD          B, 0X81
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY05_MODE
        LD          B, 0X82
        CALL        _ON_KEY_SUB
        POP         AF
        JP          H_TIMI_BACKUP
_ON_KEY_SUB:
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
RESTORE_H_TIMI:
        DI          
        LD          HL, H_TIMI_BACKUP
        LD          DE, WORK_H_TIMI
        LD          BC, 5
        LDIR        
        EI          
        RET         
RESTORE_H_ERRO:
        DI          
        LD          HL, H_ERRO_BACKUP
        LD          DE, WORK_H_ERRO
        LD          BC, 5
        LDIR        
        EI          
_CODE_RET:
        RET         
H_ERRO_HANDLER:
        PUSH        DE
        CALL        RESTORE_H_TIMI
        CALL        RESTORE_H_ERRO
        POP         DE
        JP          WORK_H_ERRO
data_19100:
        DEFW        STR_13
data_19101:
        DEFW        STR_14
data_19200:
        DEFW        STR_15
str_0:
        DEFB        0x00
str_1:
        DEFB        0x01, 0x71
str_10:
        DEFB        0x08, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30
str_11:
        DEFB        0x01, 0x30
str_12:
        DEFB        0x01, 0x31
str_13:
        DEFB        0x10, 0x35, 0x34, 0x30, 0x30, 0x34, 0x34, 0x30, 0x30, 0x35, 0x34, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30
str_14:
        DEFB        0x10, 0x32, 0x38, 0x34, 0x34, 0x30, 0x30, 0x34, 0x34, 0x32, 0x38, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30
str_15:
        DEFB        0x10, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x46, 0x45, 0x30, 0x30
str_2:
        DEFB        0x01, 0x51
str_3:
        DEFB        0x01, 0x7A
str_4:
        DEFB        0x01, 0x5A
str_5:
        DEFB        0x0F, 0x56, 0x52, 0x41, 0x4D, 0x20, 0x49, 0x4E, 0x49, 0x54, 0x49, 0x41, 0x4C, 0x49, 0x5A, 0x45
str_6:
        DEFB        0x02, 0x0D, 0x0A
str_7:
        DEFB        0x1B, 0x45, 0x44, 0x49, 0x54, 0x4F, 0x52, 0x20, 0x43, 0x48, 0x41, 0x52, 0x41, 0x43, 0x54, 0x45, 0x52, 0x20, 0x49, 0x4E, 0x49, 0x54, 0x49, 0x41, 0x4C, 0x49, 0x5A, 0x45
str_8:
        DEFB        0x02, 0x26, 0x48
str_9:
        DEFB        0x01, 0x46
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
DATA_PTR:
        DEFW        DATA_19100
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
svari_AI_FOR_END:
        DEFW        0
svari_AI_FOR_STEP:
        DEFW        0
svari_AI_LABEL:
        DEFW        0
svari_AJ_FOR_END:
        DEFW        0
svari_AJ_FOR_STEP:
        DEFW        0
svari_AJ_LABEL:
        DEFW        0
svari_IE_FOR_END:
        DEFW        0
svari_IE_FOR_STEP:
        DEFW        0
svari_IE_LABEL:
        DEFW        0
svari_IX_FOR_END:
        DEFW        0
svari_IX_FOR_STEP:
        DEFW        0
svari_IX_LABEL:
        DEFW        0
svari_IY_FOR_END:
        DEFW        0
svari_IY_FOR_STEP:
        DEFW        0
svari_IY_LABEL:
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
svari_X_FOR_END:
        DEFW        0
svari_X_FOR_STEP:
        DEFW        0
svari_X_LABEL:
        DEFW        0
svari_Y_FOR_END:
        DEFW        0
svari_Y_FOR_STEP:
        DEFW        0
svari_Y_LABEL:
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
vari_AD:
        DEFW        0
vari_AI:
        DEFW        0
vari_AJ:
        DEFW        0
vari_BT:
        DEFW        0
vari_C1:
        DEFW        0
vari_CC:
        DEFW        0
vari_CV:
        DEFW        0
vari_I:
        DEFW        0
vari_IE:
        DEFW        0
vari_IX:
        DEFW        0
vari_IY:
        DEFW        0
vari_J:
        DEFW        0
vari_PV:
        DEFW        0
vari_SC:
        DEFW        0
vari_SP:
        DEFW        0
vari_ST:
        DEFW        0
vari_SX:
        DEFW        0
vari_SY:
        DEFW        0
vari_TR:
        DEFW        0
vari_X:
        DEFW        0
vari_X1:
        DEFW        0
vari_X2:
        DEFW        0
vari_Y:
        DEFW        0
vari_Y1:
        DEFW        0
vari_Y2:
        DEFW        0
var_area_end:
vars_area_start:
vars_A:
        DEFW        0
vars_B:
        DEFW        0
vars_CU:
        DEFW        0
vars_L1:
        DEFW        0
vars_area_end:
vara_area_start:
varia_PC:
        DEFW        0
varia_PT:
        DEFW        0
vara_area_end:
varsa_area_start:
varsa_area_end:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
