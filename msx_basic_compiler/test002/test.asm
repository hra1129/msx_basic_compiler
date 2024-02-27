; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_FILTAB                     = 0X0F860
WORK_MAXFIL                     = 0X0F85F
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
BIOS_CHGCLR                     = 0X00062
WORK_FORCLR                     = 0X0F3E9
WORK_BAKCLR                     = 0X0F3EA
WORK_BDRCLR                     = 0X0F3EB
BLIB_WIDTH                      = 0X0403C
BIOS_ERAFNK                     = 0X000CC
BLIB_SET_FUNCTION_KEY           = 0X040E1
WORK_JIFFY                      = 0X0FC9E
WORK_VALTYP                     = 0X0F663
WORK_DAC                        = 0X0F7F6
BIOS_VMOVFM                     = 0X02F08
BIOS_NEG                        = 0X02E8D
BIOS_FRCSNG                     = 0X0303A
BIOS_RND                        = 0X02BDF
BIOS_FRCDBL                     = 0X0303A
BIOS_FRCINT                     = 0X02F8A
BIOS_ERRHAND_REDIM              = 0X0405E
BIOS_UMULT                      = 0X0314A
BIOS_ERRHAND                    = 0X0406F
BIOS_WRTVRM                     = 0X004D
BIOS_NWRVRM                     = 0X0177
WORK_SCRMOD                     = 0XFCAF
BIOS_CLS                        = 0X000C3
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
BIOS_FOUT                       = 0X03425
WORK_LINLEN                     = 0X0F3B0
BIOS_GTTRIG                     = 0X00D8
BIOS_GTSTCK                     = 0X00D5
BIOS_ICOMP                      = 0X02F4D
BIOS_IMULT                      = 0X03193
BIOS_IMOD                       = 0X0323A
BIOS_BEEP                       = 0X00C0
WORK_ARG                        = 0X0F847
BIOS_XDCOMP                     = 0X02F5C
BIOS_DECSUB                     = 0X0268C
BIOS_MAF                        = 0X02C4D
BIOS_DECMUL                     = 0X027E6
BIOS_INT                        = 0X030CF
BIOS_DECADD                     = 0X0269A
BLIB_MID_CMD                    = 0X0406C
BLIB_MID                        = 0X04033
BIOS_RDVRM                      = 0X004A
BIOS_NRDVRM                     = 0X0174
BIOS_FIN                        = 0X3299
WORK_BUF                        = 0X0F55E
BLIB_STRCMP                     = 0X04027
BIOS_IDIV                       = 0X031E6
BIOS_NEWSTT                     = 0X04601
WORK_TXTTAB                     = 0X0F676
; BSAVE HEADER -----------------------------------------------------------
        DEFB        0XFE
        DEFW        START_ADDRESS
        DEFW        END_ADDRESS
        DEFW        START_ADDRESS
        ORG         0X8010
START_ADDRESS:
        LD          SP, [WORK_FILTAB]
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
LINE_100:
        LD          HL, 1
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT0
        CALL        BIOS_CHGMOD
        JR          _PT1
_PT0:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT1:
        LD          A, 15
        LD          [WORK_FORCLR], A
        LD          A, 1
        LD          [WORK_BAKCLR], A
        LD          [WORK_BDRCLR], A
        CALL        BIOS_CHGCLR
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
        CALL        BIOS_ERAFNK
        LD          HL, 1
        PUSH        HL
        LD          HL, STR_1
        POP         DE
        PUSH        HL
        LD          IX, BLIB_SET_FUNCTION_KEY
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, VARI_R
        PUSH        HL
        LD          HL, [WORK_JIFFY]
        EX          DE, HL
        LD          HL, 0
        OR          A, A
        SBC         HL, DE
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARIA_BL]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 10
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_BL], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          A, 1
        LD          [HL], A
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        LD          HL, [VARSA_BK]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 20
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARSA_BK], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          E, C
        LD          D, B
        DEC         DE
        LD          A, 1
        LD          [HL], A
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         DE
        DEC         DE
        CALL        INIT_STRING_ARRAY
LINE_105:
        LD          HL, 8208
        PUSH        HL
        LD          HL, 245
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT3
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT3
_PT2:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT3:
        LD          HL, 8209
        PUSH        HL
        LD          HL, 245
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT5
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT5
_PT4:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT5:
        LD          HL, 8210
        PUSH        HL
        LD          HL, 251
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT7
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT7
_PT6:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT7:
        LD          HL, 8211
        PUSH        HL
        LD          HL, 224
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT9
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT9
_PT8:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT9:
        CALL        LINE_1000
        CALL        LINE_1120
LINE_110:
        XOR         A, A
        CALL        BIOS_CLS
        CALL        LINE_730
        LD          H, (10) & 255
        INC         H
        PUSH        HL
        LD          A, 2
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [VARI_HS]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT10
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT10:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (9) & 255
        INC         H
        PUSH        HL
        LD          A, 5
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_4
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (8) & 255
        INC         H
        PUSH        HL
        LD          A, 14
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_5
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (3) & 255
        INC         H
        PUSH        HL
        LD          A, 20
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_6
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (3) & 255
        INC         H
        PUSH        HL
        LD          A, 21
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_7
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        CALL        LINE_1100
LINE_115:
        XOR         A, A
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        POP         DE
        ADD         HL, DE
        LD          A, L
        OR          A, H
        JP          Z, _PT12
        JP          LINE_120
_PT12:
        JP          LINE_115
_PT11:
LINE_120:
        XOR         A, A
        CALL        BIOS_CLS
        CALL        LINE_730
        CALL        LINE_950
        CALL        LINE_920
        CALL        LINE_965
        CALL        LINE_970
        CALL        LINE_996
        CALL        LINE_700
        CALL        LINE_810
LINE_200:
        LD          HL, VARI_ST
        PUSH        HL
        XOR         A, A
        CALL        BIOS_GTSTCK
        LD          L, A
        LD          H, 0
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTSTCK
        LD          L, A
        LD          H, 0
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_SG
        PUSH        HL
        LD          HL, [VARI_ST]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        EX          DE, HL
        LD          HL, 0
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_PC
        PUSH        HL
        LD          HL, [VARI_PC]
        LD          DE, [VARI_SG]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_SG]
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_SG
        PUSH        HL
        XOR         A, A
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_210:
        LD          HL, VARI_BU
        PUSH        HL
        LD          HL, [VARI_PX]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_PC]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_PC]
        PUSH        HL
        LD          HL, 5
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _PT15
        DEC         A
_PT15:
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT14
        LD          HL, VARI_PX
        PUSH        HL
        LD          HL, [VARI_PX]
        PUSH        HL
        LD          HL, [VARI_ST]
        PUSH        HL
        LD          HL, 7
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_ST]
        PUSH        HL
        LD          HL, 3
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        PUSH        HL
        LD          HL, 10
        POP         DE
        CALL        BIOS_IMOD
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _PT13
_PT14:
_PT13:
LINE_220:
        LD          HL, [VARI_PX]
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT18
        DEC         A
_PT18:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT17
        LD          HL, 9
        LD          [VARI_PX], HL
        JP          _PT16
_PT17:
_PT16:
LINE_240:
        LD          HL, 6758
        LD          DE, [VARI_PX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 128
        PUSH        HL
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        POP         DE
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT20
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT20
_PT19:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT20:
LINE_245:
        LD          HL, [VARI_PX]
        PUSH        HL
        LD          HL, [VARI_BU]
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT22
        LD          HL, 6758
        LD          DE, [VARI_BU]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT24
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT24
_PT23:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT24:
        JP          _PT21
_PT22:
_PT21:
LINE_250:
        LD          HL, [VARI_SG]
        PUSH        HL
        LD          HL, -1
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, -1
        POP         DE
        CALL        BIOS_ICOMP
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
        PUSH        HL
        LD          HL, [VARI_SP]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
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
        JP          Z, _PT26
        LD          HL, VARI_BX
        PUSH        HL
        LD          HL, [VARI_PX]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 18
        LD          [VARI_BY], HL
        LD          HL, VARI_B
        PUSH        HL
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        LD          DE, 128
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        LINE_800
        CALL        LINE_970
        CALL        LINE_700
        JP          _PT25
_PT26:
_PT25:
LINE_260:
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          M, _PT29
        DEC         A
_PT29:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT28
        CALL        LINE_980
        JP          _PT27
_PT28:
_PT27:
LINE_500:
; gosub 970
LINE_545:
        LD          HL, [VARI_SL]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT31
        CALL        LINE_895
        CALL        LINE_870
        CALL        LINE_810
        CALL        LINE_710
        CALL        LINE_890
        CALL        LINE_700
        LD          HL, VARI_LL
        PUSH        HL
        LD          HL, [VARI_LL]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 0
        LD          [VARI_SP], HL
        JP          _PT30
_PT31:
_PT30:
LINE_567:
        LD          HL, VARI_SL
        PUSH        HL
        LD          HL, [VARI_SL]
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          HL, 61
        PUSH        HL
        LD          HL, [VARI_LV]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        CALL        BIOS_IMOD
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_578:
        LD          HL, [VARI_LL]
        PUSH        HL
        LD          HL, 25
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT34
        DEC         A
_PT34:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_LV]
        PUSH        HL
        LD          HL, 50
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT35
        DEC         A
_PT35:
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
        JP          Z, _PT33
        LD          HL, VARI_LV
        PUSH        HL
        LD          HL, [VARI_LV]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        BIOS_BEEP
        CALL        BIOS_BEEP
        LD          HL, 0
        LD          [VARI_LL], HL
        LD          H, (8) & 255
        INC         H
        PUSH        HL
        LD          A, 5
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_8
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, 1
        LD          [VARI_SP], HL
        JP          _PT32
_PT33:
_PT32:
LINE_590:
        LD          HL, [WORK_JIFFY]
        PUSH        HL
        LD          HL, CONST_45655340
        CALL        LD_ARG_SINGLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_XDCOMP
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT37
        LD          HL, 0
        LD          [WORK_JIFFY], HL
        JP          _PT36
_PT37:
_PT36:
LINE_592:
        LD          HL, VARD_T
        PUSH        HL
        LD          HL, [WORK_JIFFY]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
LINE_595:
        LD          HL, [WORK_JIFFY]
        PUSH        HL
        LD          HL, VARD_T
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECSUB
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 2
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT39
        JP          LINE_595
_PT39:
        JP          LINE_200
_PT38:
LINE_697:
        JP          LINE_200
LINE_700:
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 1
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 2
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_HS]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT40
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT40:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 4
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_9
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 5
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_SC]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT41
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT41:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 7
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_10
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 8
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_FA]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT42
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT42:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 10
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_11
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 11
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_LV]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT43
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT43:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 13
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_12
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 14
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_LF]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT44
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT44:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
LINE_705:
        LD          H, (20) & 255
        INC         H
        PUSH        HL
        LD          A, 17
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_13
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 18
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_NX]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT45
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT45:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        RET         
LINE_710:
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 18
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT48
        DEC         A
_PT48:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 0
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT49
        DEC         A
_PT49:
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
        JP          Z, _PT47
        LD          HL, VARI_BY
        PUSH        HL
        LD          HL, [VARI_BY]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _PT46
_PT47:
_PT46:
LINE_711:
        RET         
LINE_720:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 17
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT51
        LD          [SVARI_Y_LABEL], HL
        JR          _PT50
_PT51:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT52
        SBC         HL, DE
        JP          M, _PT53
        JR          Z, _PT53
        RET         
_PT52:
        CCF         
        SBC         HL, DE
        RET         M
_PT53:
        POP         HL
_PT50:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        LD          DE, 2
        ADD         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        COPY_STRING
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
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 18
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_14
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
        RET         
LINE_730:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 23
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT55
        LD          [SVARI_Y_LABEL], HL
        JR          _PT54
_PT55:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT56
        SBC         HL, DE
        JP          M, _PT57
        JR          Z, _PT57
        RET         
_PT56:
        CCF         
        SBC         HL, DE
        RET         M
_PT57:
        POP         HL
_PT54:
        LD          HL, 0
        LD          [VARI_X], HL
        LD          HL, 31
        LD          [SVARI_X_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_X_FOR_STEP], HL
        LD          HL, _PT59
        LD          [SVARI_X_LABEL], HL
        JR          _PT58
_PT59:
        LD          HL, [VARI_X]
        LD          DE, [SVARI_X_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_X], HL
        LD          A, D
        LD          DE, [SVARI_X_FOR_END]
        RLCA        
        JR          C, _PT60
        SBC         HL, DE
        JP          M, _PT61
        JR          Z, _PT61
        RET         
_PT60:
        CCF         
        SBC         HL, DE
        RET         M
_PT61:
        POP         HL
_PT58:
        LD          HL, 6144
        LD          DE, [VARI_X]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_Y]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 152
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT63
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT63
_PT62:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT63:
        LD          HL, [SVARI_X_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
        RET         
LINE_735:
        LD          HL, 23
        LD          [VARI_Y], HL
        LD          HL, 0
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT65
        LD          [SVARI_Y_LABEL], HL
        JR          _PT64
_PT65:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT66
        SBC         HL, DE
        JP          M, _PT67
        JR          Z, _PT67
        RET         
_PT66:
        CCF         
        SBC         HL, DE
        RET         M
_PT67:
        POP         HL
_PT64:
        LD          HL, 0
        LD          [VARI_X], HL
        LD          HL, 31
        LD          [SVARI_X_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_X_FOR_STEP], HL
        LD          HL, _PT69
        LD          [SVARI_X_LABEL], HL
        JR          _PT68
_PT69:
        LD          HL, [VARI_X]
        LD          DE, [SVARI_X_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_X], HL
        LD          A, D
        LD          DE, [SVARI_X_FOR_END]
        RLCA        
        JR          C, _PT70
        SBC         HL, DE
        JP          M, _PT71
        JR          Z, _PT71
        RET         
_PT70:
        CCF         
        SBC         HL, DE
        RET         M
_PT71:
        POP         HL
_PT68:
        LD          HL, 6144
        LD          DE, [VARI_X]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_Y]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 152
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT73
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT73
_PT72:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT73:
        LD          HL, [SVARI_X_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
        RET         
LINE_740:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 500
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT75
        LD          [SVARI_I_LABEL], HL
        JR          _PT74
_PT75:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT76
        SBC         HL, DE
        JP          M, _PT77
        JR          Z, _PT77
        RET         
_PT76:
        CCF         
        SBC         HL, DE
        RET         M
_PT77:
        POP         HL
_PT74:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_741:
        XOR         A, A
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        POP         DE
        ADD         HL, DE
        LD          A, L
        OR          A, H
        JP          Z, _PT79
        JP          LINE_742
_PT79:
        JP          LINE_741
_PT78:
LINE_742:
        CALL        LINE_735
        CALL        LINE_735
        JP          LINE_110
LINE_750:
        LD          HL, [VARI_NX]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT81
        CALL        LINE_760
        JP          _PT80
_PT81:
        RET         
_PT80:
LINE_755:
        RET         
LINE_760:
        CALL        BIOS_BEEP
        LD          H, (7) & 255
        INC         H
        PUSH        HL
        LD          A, 5
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_15
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (7) & 255
        INC         H
        PUSH        HL
        LD          A, 8
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_16
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, VARI_BN
        PUSH        HL
        LD          HL, [VARI_LV]
        LD          DE, [VARI_FA]
        ADD         HL, DE
        LD          DE, [VARI_LF]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 10
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          H, (7) & 255
        INC         H
        PUSH        HL
        LD          A, 9
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_BN]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT82
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT82:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, VARI_SC
        PUSH        HL
        LD          HL, [VARI_SC]
        LD          DE, [VARI_BN]
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 10
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT84
        LD          [SVARI_I_LABEL], HL
        JR          _PT83
_PT84:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT85
        SBC         HL, DE
        JP          M, _PT86
        JR          Z, _PT86
        RET         
_PT85:
        CCF         
        SBC         HL, DE
        RET         M
_PT86:
        POP         HL
_PT83:
        LD          HL, 8211
        PUSH        HL
        LD          HL, 112
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT88
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT88
_PT87:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT88:
        CALL        BIOS_BEEP
        LD          HL, 8211
        PUSH        HL
        LD          HL, 224
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT90
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT90
_PT89:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT90:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 500
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT92
        LD          [SVARI_I_LABEL], HL
        JR          _PT91
_PT92:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT93
        SBC         HL, DE
        JP          M, _PT94
        JR          Z, _PT94
        RET         
_PT93:
        CCF         
        SBC         HL, DE
        RET         M
_PT94:
        POP         HL
_PT91:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_761:
        XOR         A, A
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        POP         DE
        ADD         HL, DE
        LD          A, L
        OR          A, H
        JP          Z, _PT96
        JP          LINE_762
_PT96:
        JP          LINE_761
_PT95:
LINE_762:
        LD          HL, 0
        LD          [VARI_SL], HL
        LD          [VARI_LL], HL
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 18
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT98
        LD          [SVARI_I_LABEL], HL
        JR          _PT97
_PT98:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT99
        SBC         HL, DE
        JP          M, _PT100
        JR          Z, _PT100
        RET         
_PT99:
        CCF         
        SBC         HL, DE
        RET         M
_PT100:
        POP         HL
_PT97:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_14
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
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        LD          HL, VARI_FA
        PUSH        HL
        LD          HL, [VARI_FA]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_NX
        PUSH        HL
        LD          HL, 10
        LD          DE, [VARI_FA]
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        LINE_730
        CALL        LINE_920
        CALL        LINE_965
        CALL        LINE_970
        CALL        LINE_996
        CALL        LINE_700
        CALL        LINE_810
        RET         
LINE_770:
        LD          HL, 15
        LD          [VARI_I], HL
        LD          HL, 18
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT102
        LD          [SVARI_I_LABEL], HL
        JR          _PT101
_PT102:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT103
        SBC         HL, DE
        JP          M, _PT104
        JR          Z, _PT104
        RET         
_PT103:
        CCF         
        SBC         HL, DE
        RET         M
_PT104:
        POP         HL
_PT101:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_14
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
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        RET         
LINE_780:
        LD          HL, [VARI_HS]
        PUSH        HL
        LD          HL, [VARI_SC]
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          M, _PT107
        DEC         A
_PT107:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT106
        LD          HL, VARI_HS
        PUSH        HL
        LD          HL, [VARI_SC]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          H, (7) & 255
        INC         H
        PUSH        HL
        LD          A, 9
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_17
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        LD          H, (7) & 255
        INC         H
        PUSH        HL
        LD          A, 10
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARI_HS]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT108
        PUSH        HL
        LD          HL, STR_3
        CALL        PUTS
        POP         HL
_PT108:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_3
        CALL        PUTS
        JP          _PT105
_PT106:
_PT105:
LINE_785:
        RET         
LINE_800:
        LD          HL, 1
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT110
        LD          [SVARI_I_LABEL], HL
        JR          _PT109
_PT110:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT111
        SBC         HL, DE
        JP          M, _PT112
        JR          Z, _PT112
        RET         
_PT111:
        CCF         
        SBC         HL, DE
        RET         M
_PT112:
        POP         HL
_PT109:
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 9
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 9
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_DAC_DOUBLE_REAL
        CALL        BIOS_INT
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        RET         
LINE_810:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 18
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT114
        LD          [SVARI_Y_LABEL], HL
        JR          _PT113
_PT114:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT115
        SBC         HL, DE
        JP          M, _PT116
        JR          Z, _PT116
        RET         
_PT115:
        CCF         
        SBC         HL, DE
        RET         M
_PT116:
        POP         HL
_PT113:
        LD          H, (6) & 255
        INC         H
        PUSH        HL
        LD          HL, [VARI_Y]
        LD          DE, 1
        ADD         HL, DE
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
        RET         
LINE_870:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT118
        LD          [SVARI_I_LABEL], HL
        JR          _PT117
_PT118:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT119
        SBC         HL, DE
        JP          M, _PT120
        JR          Z, _PT120
        RET         
_PT119:
        CCF         
        SBC         HL, DE
        RET         M
_PT120:
        POP         HL
_PT117:
        LD          HL, VARI_R
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 40
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        CALL        LD_DAC_DOUBLE_REAL
        CALL        BIOS_INT
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_875:
        LD          HL, [VARI_R]
        PUSH        HL
        LD          HL, 1
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT122
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        CALL        GET_WRITEABLE_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_I]
        LD          DE, 1
        ADD         HL, DE
        LD          B, L
        LD          C, (1) & 255
        PUSH        BC
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, 129
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 8
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        JP          _PT121
_PT122:
_PT121:
LINE_887:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        RET         
LINE_890:
        LD          HL, 18
        LD          [VARI_Y], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT124
        LD          [SVARI_Y_LABEL], HL
        JR          _PT123
_PT124:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT125
        SBC         HL, DE
        JP          M, _PT126
        JR          Z, _PT126
        RET         
_PT125:
        CCF         
        SBC         HL, DE
        RET         M
_PT126:
        POP         HL
_PT123:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        COPY_STRING
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
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_14
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
        RET         
LINE_895:
        LD          HL, 0
        LD          [VARI_T], HL
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT128
        LD          [SVARI_I_LABEL], HL
        JR          _PT127
_PT128:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT129
        SBC         HL, DE
        JP          M, _PT130
        JR          Z, _PT130
        RET         
_PT129:
        CCF         
        SBC         HL, DE
        RET         M
_PT130:
        POP         HL
_PT127:
        LD          HL, VARI_T
        PUSH        HL
        LD          HL, [VARI_T]
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 18
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, [VARI_I]
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          C, (1) & 255
        POP         HL
        LD          B, L
        POP         HL
        PUSH        HL
        LD          IX, BLIB_MID
        CALL        CALL_BLIB
        POP         DE
        PUSH        HL
        EX          DE, HL
        CALL        FREE_STRING
        POP         HL
        CALL        COPY_STRING
        INC         HL
        LD          A, [HL]
        DEC         HL
        LD          L, A
        LD          H, 0
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_897:
        LD          HL, [VARI_T]
        PUSH        HL
        LD          HL, 320
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT132
        LD          HL, VARI_LF
        PUSH        HL
        LD          HL, [VARI_LF]
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 10
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT134
        LD          [SVARI_I_LABEL], HL
        JR          _PT133
_PT134:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT135
        SBC         HL, DE
        JP          M, _PT136
        JR          Z, _PT136
        RET         
_PT135:
        CCF         
        SBC         HL, DE
        RET         M
_PT136:
        POP         HL
_PT133:
        LD          HL, 8211
        PUSH        HL
        LD          HL, 96
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT138
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT138
_PT137:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT138:
        CALL        BIOS_BEEP
        LD          HL, 8211
        PUSH        HL
        LD          HL, 224
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT140
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT140
_PT139:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT140:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        LINE_770
        CALL        LINE_720
        CALL        LINE_810
        CALL        LINE_700
        JP          _PT131
_PT132:
_PT131:
LINE_898:
        LD          HL, [VARI_LF]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT142
        LD          H, (7) & 255
        INC         H
        PUSH        HL
        LD          A, 6
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_18
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        CALL        LINE_780
        CALL        LINE_740
        JP          _PT141
_PT142:
_PT141:
LINE_899:
        RET         
LINE_900:
; 
LINE_920:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 11
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT144
        LD          [SVARI_I_LABEL], HL
        JR          _PT143
_PT144:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT145
        SBC         HL, DE
        JP          M, _PT146
        JR          Z, _PT146
        RET         
_PT145:
        CCF         
        SBC         HL, DE
        RET         M
_PT146:
        POP         HL
_PT143:
        LD          HL, 6149
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 144
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT148
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT148
_PT147:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT148:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 19
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT150
        LD          [SVARI_I_LABEL], HL
        JR          _PT149
_PT150:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT151
        SBC         HL, DE
        JP          M, _PT152
        JR          Z, _PT152
        RET         
_PT151:
        CCF         
        SBC         HL, DE
        RET         M
_PT152:
        POP         HL
_PT149:
        LD          HL, 6181
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 144
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT154
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT154
_PT153:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT154:
        LD          HL, 6192
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 144
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT156
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT156
_PT155:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT156:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 11
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT158
        LD          [SVARI_I_LABEL], HL
        JR          _PT157
_PT158:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT159
        SBC         HL, DE
        JP          M, _PT160
        JR          Z, _PT160
        RET         
_PT159:
        CCF         
        SBC         HL, DE
        RET         M
_PT160:
        POP         HL
_PT157:
        LD          HL, 6789
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 144
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT162
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT162
_PT161:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT162:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        LD          HL, 6194
        PUSH        HL
        LD          HL, 62
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT164
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT164
_PT163:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT164:
        LD          H, (5) & 255
        INC         H
        PUSH        HL
        LD          A, 22
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_19
        CALL        PUTS
        LD          HL, STR_3
        CALL        PUTS
        RET         
LINE_950:
        LD          HL, 4
        LD          [VARI_PX], HL
        LD          HL, 0
        LD          [VARI_BU], HL
        LD          [VARI_BL], HL
        LD          HL, 0
        LD          [VARI_BX], HL
        LD          HL, -1
        LD          [VARI_BY], HL
        LD          HL, 120
        LD          [VARI_SL], HL
        LD          HL, 1
        LD          [VARI_LV], HL
        LD          HL, 3
        LD          [VARI_LF], HL
        LD          HL, 0
        LD          [VARI_PC], HL
        LD          HL, 1
        LD          [VARI_FA], HL
        LD          HL, 0
        LD          [VARI_SC], HL
        LD          [VARI_SP], HL
        LD          HL, 5
        LD          [VARI_NX], HL
LINE_957:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 19
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT166
        LD          [SVARI_Y_LABEL], HL
        JR          _PT165
_PT166:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT167
        SBC         HL, DE
        JP          M, _PT168
        JR          Z, _PT168
        RET         
_PT167:
        CCF         
        SBC         HL, DE
        RET         M
_PT168:
        POP         HL
_PT165:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_14
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
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
LINE_960:
        RET         
LINE_965:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT170
        LD          [SVARI_I_LABEL], HL
        JR          _PT169
_PT170:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT171
        SBC         HL, DE
        JP          M, _PT172
        JR          Z, _PT172
        RET         
_PT171:
        CCF         
        SBC         HL, DE
        RET         M
_PT172:
        POP         HL
_PT169:
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 10
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_DAC_DOUBLE_REAL
        CALL        BIOS_INT
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        RET         
LINE_970:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT174
        LD          [SVARI_I_LABEL], HL
        JR          _PT173
_PT174:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT175
        SBC         HL, DE
        JP          M, _PT176
        JR          Z, _PT176
        RET         
_PT175:
        CCF         
        SBC         HL, DE
        RET         M
_PT176:
        POP         HL
_PT173:
        LD          HL, 6195
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        LD          DE, 128
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT178
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT178
_PT177:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT178:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        RET         
LINE_980:
        LD          HL, VARI_Q
        PUSH        HL
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT180
        CALL        BIOS_RDVRM
        LD          L, A
        LD          H, 0
        JR          _PT180
        CALL        BIOS_NRDVRM
        LD          L, A
        LD          H, 0
_PT180:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_Q]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT182
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT184
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT184
_PT183:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT184:
        CALL        LINE_990
        LD          HL, -1
        LD          [VARI_BY], HL
        RET         
        JP          _PT181
_PT182:
_PT181:
LINE_985:
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_B]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT186
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT186
_PT185:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT186:
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT188
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT188
_PT187:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT188:
        LD          HL, VARI_BY
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        RET         
LINE_990:
        LD          HL, [VARI_Q]
        PUSH        HL
        LD          HL, 144
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT190
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        CALL        GET_WRITEABLE_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_BX]
        LD          DE, 1
        ADD         HL, DE
        LD          B, L
        LD          C, (1) & 255
        PUSH        BC
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_B]
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, 6182
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_B]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT192
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT192
_PT191:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT192:
        LD          HL, VARI_LL
        PUSH        HL
        LD          HL, [VARI_LL]
        LD          DE, 2
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        LINE_700
        RET         
        JP          _PT189
_PT190:
_PT189:
LINE_991:
        LD          HL, [VARI_B]
        PUSH        HL
        LD          HL, 128
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT194
        LD          HL, VARIA_BL
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_Q]
        PUSH        HL
        LD          HL, 128
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        BIOS_BEEP
        CALL        BIOS_BEEP
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_BY]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        CALL        GET_WRITEABLE_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_BX]
        LD          DE, 1
        ADD         HL, DE
        LD          B, L
        LD          C, (1) & 255
        PUSH        BC
        LD          HL, STR_20
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_BY]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT196
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT196
_PT195:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT196:
        CALL        BIOS_BEEP
        LD          HL, VARI_LL
        PUSH        HL
        LD          HL, [VARI_LL]
        LD          DE, 2
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        LINE_970
        RET         
        JP          _PT193
_PT194:
_PT193:
LINE_992:
; if q=b then gosub 720:gosub 810:RETURN
LINE_993:
        LD          HL, VARI_Q
        PUSH        HL
        LD          HL, [VARI_Q]
        LD          DE, [VARI_B]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 128
        POP         DE
        CALL        BIOS_IMOD
        PUSH        HL
        LD          HL, 10
        POP         DE
        CALL        BIOS_IMOD
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 0
        LD          [VARI_SL], HL
LINE_994:
        LD          HL, [VARI_Q]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT198
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_BY]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        CALL        GET_WRITEABLE_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_BX]
        LD          DE, 1
        ADD         HL, DE
        LD          B, L
        LD          C, (1) & 255
        PUSH        BC
        LD          HL, STR_20
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_BY]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT200
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT200
_PT199:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT200:
        CALL        BIOS_BEEP
        LD          HL, VARI_SC
        PUSH        HL
        LD          HL, [VARI_SC]
        LD          DE, 10
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_LL
        PUSH        HL
        LD          HL, [VARI_LL]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_NX
        PUSH        HL
        LD          HL, [VARI_NX]
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        LINE_720
        CALL        LINE_810
        CALL        LINE_700
        CALL        LINE_750
        RET         
        JP          _PT197
_PT198:
_PT197:
LINE_995:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_BY]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        CALL        GET_WRITEABLE_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_BX]
        LD          DE, 1
        ADD         HL, DE
        LD          B, L
        LD          C, (1) & 255
        PUSH        BC
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_Q]
        LD          DE, 128
        ADD         HL, DE
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_BY]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, 6150
        LD          DE, [VARI_BX]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_BY]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_Q]
        LD          DE, 128
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT202
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT202
_PT201:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT202:
        RET         
LINE_996:
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        CALL        GET_WRITEABLE_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 9
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          B, L
        LD          C, (1) & 255
        PUSH        BC
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 9
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 128
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        LD          HL, VARSA_BK
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 0
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        RET         
LINE_1000:
; 
LINE_1010:
        LD          HL, DATA_1500
        LD          [DATA_PTR], HL
LINE_1020:
        LD          HL, VARI_C
        CALL        SUB_READ_INTEGER
        LD          HL, [VARI_C]
        PUSH        HL
        LD          HL, 0
        POP         DE
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT204
        RET         
        JP          _PT203
_PT204:
_PT203:
LINE_1030:
        LD          HL, VARS_BG
        CALL        SUB_READ_STRING
LINE_1040:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 7
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT206
        LD          [SVARI_I_LABEL], HL
        JR          _PT205
_PT206:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT207
        SBC         HL, DE
        JP          M, _PT208
        JR          Z, _PT208
        RET         
_PT207:
        CCF         
        SBC         HL, DE
        RET         M
_PT208:
        POP         HL
_PT205:
        LD          HL, [VARI_C]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_21
        PUSH        HL
        LD          HL, [VARS_BG]
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          C, (2) & 255
        POP         HL
        LD          B, L
        POP         HL
        PUSH        HL
        LD          IX, BLIB_MID
        CALL        CALL_BLIB
        POP         DE
        PUSH        HL
        EX          DE, HL
        CALL        FREE_STRING
        POP         HL
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT210
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT210
_PT209:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT210:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1050:
        JP          LINE_1020
LINE_1100:
        LD          HL, DATA_1530
        LD          [DATA_PTR], HL
LINE_1110:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 3
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT212
        LD          [SVARI_I_LABEL], HL
        JR          _PT211
_PT212:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT213
        SBC         HL, DE
        JP          M, _PT214
        JR          Z, _PT214
        RET         
_PT213:
        CCF         
        SBC         HL, DE
        RET         M
_PT214:
        POP         HL
_PT211:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, 0
        LD          [VARI_J], HL
        LD          HL, 26
        LD          [SVARI_J_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_J_FOR_STEP], HL
        LD          HL, _PT216
        LD          [SVARI_J_LABEL], HL
        JR          _PT215
_PT216:
        LD          HL, [VARI_J]
        LD          DE, [SVARI_J_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_J], HL
        LD          A, D
        LD          DE, [SVARI_J_FOR_END]
        RLCA        
        JR          C, _PT217
        SBC         HL, DE
        JP          M, _PT218
        JR          Z, _PT218
        RET         
_PT217:
        CCF         
        SBC         HL, DE
        RET         M
_PT218:
        POP         HL
_PT215:
LINE_1115:
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, [VARI_J]
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          C, (1) & 255
        POP         HL
        LD          B, L
        POP         HL
        PUSH        HL
        LD          IX, BLIB_MID
        CALL        CALL_BLIB
        POP         DE
        PUSH        HL
        EX          DE, HL
        CALL        FREE_STRING
        POP         HL
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, STR_22
        POP         DE
        EX          DE, HL
        PUSH        HL
        PUSH        DE
        LD          IX, BLIB_STRCMP
        CALL        CALL_BLIB
        POP         HL
        PUSH        AF
        CALL        FREE_STRING
        POP         AF
        POP         HL
        PUSH        AF
        CALL        FREE_STRING
        POP         AF
        LD          HL, 0
        JR          NZ, _PT221
        DEC         HL
_PT221:
        LD          A, L
        OR          A, H
        JP          Z, _PT220
        LD          HL, 6371
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_J]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 144
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT223
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT223
_PT222:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT223:
        JP          _PT219
_PT220:
_PT219:
LINE_1117:
        LD          HL, [SVARI_J_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        RET         
LINE_1120:
        LD          HL, 33
        LD          [VARI_I], HL
        LD          HL, 126
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT225
        LD          [SVARI_I_LABEL], HL
        JR          _PT224
_PT225:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT226
        SBC         HL, DE
        JP          M, _PT227
        JR          Z, _PT227
        RET         
_PT226:
        CCF         
        SBC         HL, DE
        RET         M
_PT227:
        POP         HL
_PT224:
        LD          HL, 0
        LD          [VARI_J], HL
        LD          HL, 7
        LD          [SVARI_J_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_J_FOR_STEP], HL
        LD          HL, _PT229
        LD          [SVARI_J_LABEL], HL
        JR          _PT228
_PT229:
        LD          HL, [VARI_J]
        LD          DE, [SVARI_J_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_J], HL
        LD          A, D
        LD          DE, [SVARI_J_FOR_END]
        RLCA        
        JR          C, _PT230
        SBC         HL, DE
        JP          M, _PT231
        JR          Z, _PT231
        RET         
_PT230:
        CCF         
        SBC         HL, DE
        RET         M
_PT231:
        POP         HL
_PT228:
        LD          HL, VARI_K
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, [VARI_J]
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT233
        CALL        BIOS_RDVRM
        LD          L, A
        LD          H, 0
        JR          _PT233
        CALL        BIOS_NRDVRM
        LD          L, A
        LD          H, 0
_PT233:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_L
        PUSH        HL
        LD          HL, [VARI_K]
        PUSH        HL
        LD          HL, [VARI_K]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IDIV
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
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, [VARI_J]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_L]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT235
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT235
_PT234:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT235:
        LD          HL, [SVARI_J_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        RET         
LINE_1500:
LINE_1510:
LINE_1520:
LINE_1530:
LINE_1540:
LINE_1550:
LINE_1560:
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          SP, [WORK_FILTAB]
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        LD          HL, _BASIC_END
        CALL        BIOS_NEWSTT
_BASIC_END:
        DEFB        ':', 0X92, ':', 0X94, ':', 0X81, 0X00
ERR_RETURN_WITHOUT_GOSUB:
        LD          E, 3
        JP          BIOS_ERRHAND
        DI          
        CALL        SETUP_H_ERRO
        EI          
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
FREE_STRING:
        LD          DE, HEAP_START
        RST         0X20
        RET         C
        LD          DE, [HEAP_NEXT]
        RST         0X20
        RET         NC
        LD          C, [HL]
        LD          B, 0
        INC         BC
        JP          FREE_HEAP
FREE_HEAP:
        PUSH        HL
        ADD         HL, BC
        LD          [HEAP_MOVE_SIZE], BC
        LD          [HEAP_REMAP_ADDRESS], HL
        EX          DE, HL
        LD          HL, [HEAP_NEXT]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          A, C
        OR          A, B
        JR          Z, _FREE_HEAP_LOOP0
        LDIR        
_FREE_HEAP_LOOP0:
        LD          [HEAP_NEXT], DE
        LD          HL, VARS_AREA_START
_FREE_HEAP_LOOP1:
        LD          DE, VARSA_AREA_END
        RST         0X20
        JR          NC, _FREE_HEAP_LOOP1_END
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [HEAP_REMAP_ADDRESS]
        EX          DE, HL
        RST         0X20
        JR          C, _FREE_HEAP_LOOP1_NEXT
        LD          HL, [HEAP_MOVE_SIZE]
        EX          DE, HL
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_FREE_HEAP_LOOP1_NEXT:
        POP         HL
        INC         HL
        JR          _FREE_HEAP_LOOP1
_FREE_HEAP_LOOP1_END:
        LD          HL, VARSA_AREA_START
_FREE_HEAP_LOOP2:
        LD          DE, VARSA_AREA_END
        RST         0X20
        RET         NC
        LD          E, [HL]
        LD          A, E
        INC         HL
        LD          D, [HL]
        OR          A, D
        INC         HL
        JR          Z, _FREE_HEAP_LOOP2
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
_FREE_HEAP_SARRAY_ELEMENTS:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [HEAP_REMAP_ADDRESS]
        EX          DE, HL
        RST         0X20
        JR          C, _FREE_HEAP_LOOP2_NEXT
        LD          HL, [HEAP_MOVE_SIZE]
        EX          DE, HL
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_FREE_HEAP_LOOP2_NEXT:
        POP         HL
        INC         HL
        DEC         BC
        LD          A, C
        OR          A, B
        JR          NZ, _FREE_HEAP_SARRAY_ELEMENTS
        POP         HL
        JR          _FREE_HEAP_LOOP2
ALLOCATE_HEAP:
        LD          HL, [HEAP_NEXT]
        PUSH        HL
        ADD         HL, BC
        JR          C, _ALLOCATE_HEAP_ERROR
        LD          DE, [HEAP_END]
        RST         0X20
        JR          NC, _ALLOCATE_HEAP_ERROR
        LD          [HEAP_NEXT], HL
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
_ALLOCATE_HEAP_ERROR:
        LD          E, 7
        JP          BIOS_ERRHAND
INIT_STRING_ARRAY:
        LD          BC, STR_0
_INIT_STRING_ARRAY_LOOP:
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         DE
        DEC         DE
        LD          A, E
        OR          A, D
        JR          NZ, _INIT_STRING_ARRAY_LOOP
        RET         
PUTS:
        LD          B, [HL]
        INC         B
        DEC         B
        RET         Z
_PUTS_LOOP:
        INC         HL
        LD          A, [HL]
        RST         0X18
        DJNZ        _PUTS_LOOP
        RET         
STR:
        CALL        BIOS_FOUT
FOUT_ADJUST:
        DEC         HL
        PUSH        HL
        XOR         A, A
        LD          B, A
_STR_LOOP:
        INC         HL
        CP          A, [HL]
        JR          Z, _STR_LOOP_EXIT
        INC         B
        JR          _STR_LOOP
_STR_LOOP_EXIT:
        POP         HL
        LD          [HL], B
        RET         
CHECK_ARRAY:
        LD          A, [HL]
        INC         HL
        OR          A, [HL]
        DEC         HL
        RET         NZ
        PUSH        DE
        PUSH        HL
        PUSH        BC
        CALL        ALLOCATE_HEAP
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
_CHECK_ARRAY_LOOP:
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        DJNZ        _CHECK_ARRAY_LOOP
        POP         HL
        RET         
CALC_ARRAY_TOP:
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
        JR          _CALC_ARRAY_TOP_L2
_CALC_ARRAY_TOP_L1:
        DEC         HL
        LD          B, [HL]
        DEC         HL
        LD          C, [HL]
        PUSH        BC
_CALC_ARRAY_TOP_L2:
        DEC         A
        JR          NZ, _CALC_ARRAY_TOP_L1
        PUSH        DE
        RET         
LD_ARG_SINGLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        LD          [WORK_ARG+4], BC
        LD          [WORK_ARG+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        RET         
LD_DE_DOUBLE_REAL:
        LD          BC, 8
        LDIR        
        RET         
LD_ARG_DOUBLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 8
        LDIR        
        RET         
PUSH_DOUBLE_REAL_HL:
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
POP_DOUBLE_REAL_DAC:
        POP         BC
        POP         HL
        LD          [WORK_DAC+6], HL
        POP         HL
        LD          [WORK_DAC+4], HL
        POP         HL
        LD          [WORK_DAC+2], HL
        POP         HL
        LD          [WORK_DAC+0], HL
        LD          A, 8
        LD          [WORK_VALTYP], A
        PUSH        BC
        RET         
CHECK_SARRAY:
        LD          A, [HL]
        INC         HL
        OR          A, [HL]
        DEC         HL
        RET         NZ
        PUSH        DE
        PUSH        HL
        PUSH        BC
        CALL        ALLOCATE_HEAP
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
        OR          A, A
        RR          B
        RR          C
        LD          DE, 11
_CHECK_SARRAY_LOOP:
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        DEC         BC
        DEC         A
        JR          NZ, _CHECK_SARRAY_LOOP
        LD          DE, STR_0
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        LD          E, L
        LD          D, H
        DEC         HL
        DEC         HL
        DEC         BC
        LDIR        
        POP         HL
        RET         
ALLOCATE_STRING:
        LD          HL, [HEAP_NEXT]
        PUSH        HL
        LD          E, A
        LD          C, A
        LD          D, 0
        ADD         HL, DE
        INC         HL
        LD          DE, [HEAP_END]
        RST         0X20
        JR          NC, _ALLOCATE_STRING_ERROR
        LD          [HEAP_NEXT], HL
        POP         HL
        LD          [HL], C
        RET         
_ALLOCATE_STRING_ERROR:
        LD          E, 7
        JP          BIOS_ERRHAND
COPY_STRING:
        LD          A, [HL]
        PUSH        HL
        CALL        ALLOCATE_STRING
        POP         DE
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
LD_DAC_DOUBLE_REAL:
        LD          DE, WORK_DAC
        LD          BC, 8
        LD          A, C
        LD          [WORK_VALTYP], A
        LDIR        
        RET         
GET_WRITEABLE_STRING:
        LD          DE, HEAP_START
        RST         0X20
        JR          C, _GET_WRITEABLE_STRING_MAKE_COPY
        LD          DE, [HEAP_NEXT]
        RST         0X20
        RET         C
_GET_WRITEABLE_STRING_MAKE_COPY:
        CALL        COPY_STRING
        RET         
        CALL        FREE_STRING
; VAL FUNCTION
SUB_VAL:
        LD          C, [HL]
        LD          B, 0
        INC         HL
        LD          DE, WORK_BUF
        LDIR        
        XOR         A, A
        LD          [DE], A
        LD          HL, WORK_BUF
        LD          A, [HL]
        CALL        BIOS_FIN
        RET         
; READ DATA FOR INTEGER
SUB_READ_INTEGER:
        PUSH        HL
        LD          HL, [DATA_PTR]
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          [DATA_PTR], HL
        EX          DE, HL
        CALL        SUB_VAL
        CALL        BIOS_FRCINT
        POP         HL
        LD          DE, [WORK_DAC + 2]
        LD          [HL], E
        INC         HL
        LD          [HL], D
        RET         
; READ DATA FOR STRING
SUB_READ_STRING:
        EX          DE, HL
        LD          HL, [DATA_PTR]
        LD          C, [HL]
        INC         HL
        LD          B, [HL]
        INC         HL
        LD          [DATA_PTR], HL
        EX          DE, HL
        LD          [HL], C
        INC         HL
        LD          [HL], B
        RET         
STR_ADD:
        PUSH        DE
        PUSH        HL
        LD          C, [HL]
        LD          A, [DE]
        ADD         A, C
        JR          C, _STR_ADD_ERROR
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        INC         HL
        LD          DE, WORK_BUF+1
        LD          B, 0
        INC         C
        DEC         C
        JR          Z, _STR_ADD_S1
        LDIR        
_STR_ADD_S1:
        POP         HL
        LD          C, [HL]
        INC         HL
        INC         C
        DEC         C
        JR          Z, _STR_ADD_S2
        LDIR        
_STR_ADD_S2:
        LD          [WORK_BUF], A
        POP         HL
        CALL        FREE_STRING
        POP         HL
        CALL        FREE_STRING
        LD          A, [WORK_BUF]
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          DE, WORK_BUF
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
_STR_ADD_ERROR:
        LD          E, 15
        JP          BIOS_ERRHAND
PROGRAM_RUN:
        LD          HL, HEAP_START
        LD          [HEAP_NEXT], HL
        LD          SP, [WORK_FILTAB]
        LD          HL, ERR_RETURN_WITHOUT_GOSUB
        PUSH        HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        LD          HL, [WORK_FILTAB]
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
; H.TIMI PROCESS -----------------
H_TIMI_HANDLER:
        JP          H_TIMI_BACKUP
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
DATA_1500:
        DEFW        STR_23
        DEFW        STR_24
        DEFW        STR_25
        DEFW        STR_26
        DEFW        STR_27
        DEFW        STR_28
        DEFW        STR_29
        DEFW        STR_30
DATA_1510:
        DEFW        STR_31
        DEFW        STR_32
        DEFW        STR_33
        DEFW        STR_34
        DEFW        STR_35
        DEFW        STR_36
        DEFW        STR_37
        DEFW        STR_38
DATA_1520:
        DEFW        STR_39
        DEFW        STR_40
        DEFW        STR_41
        DEFW        STR_42
        DEFW        STR_43
        DEFW        STR_44
        DEFW        STR_45
        DEFW        STR_46
        DEFW        STR_47
DATA_1530:
        DEFW        STR_48
DATA_1540:
        DEFW        STR_49
DATA_1550:
        DEFW        STR_50
DATA_1560:
        DEFW        STR_51
CONST_45655340:
        DEFB        0X45, 0X65, 0X53, 0X40
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X08, 0X73, 0X63, 0X72, 0X65, 0X65, 0X6E, 0X30, 0X0D
STR_10:
        DEFB        0X04, 0X46, 0X61, 0X73, 0X65
STR_11:
        DEFB        0X05, 0X4C, 0X65, 0X76, 0X65, 0X6C
STR_12:
        DEFB        0X04, 0X4C, 0X69, 0X66, 0X65
STR_13:
        DEFB        0X06, 0X4E, 0X45, 0X58, 0X54, 0X2D, 0X3E
STR_14:
        DEFB        0X0A, 0X20, 0X20, 0X20, 0X20, 0X20, 0X20, 0X20, 0X20, 0X20, 0X20
STR_15:
        DEFB        0X09, 0X46, 0X41, 0X53, 0X45, 0X20, 0X43, 0X4C, 0X52, 0X21
STR_16:
        DEFB        0X06, 0X42, 0X4F, 0X4E, 0X55, 0X53, 0X21
STR_17:
        DEFB        0X08, 0X48, 0X2D, 0X53, 0X43, 0X4F, 0X52, 0X45, 0X21
STR_18:
        DEFB        0X09, 0X47, 0X41, 0X4D, 0X45, 0X20, 0X4F, 0X56, 0X45, 0X52
STR_19:
        DEFB        0X12, 0X48, 0X61, 0X6E, 0X64, 0X6F, 0X27, 0X73, 0X20, 0X47, 0X41, 0X4D, 0X45, 0X20, 0X4D, 0X41, 0X52, 0X4B, 0X4E
STR_2:
        DEFB        0X07, 0X48, 0X2D, 0X53, 0X63, 0X6F, 0X72, 0X65
STR_20:
        DEFB        0X01, 0X20
STR_21:
        DEFB        0X02, 0X26, 0X68
STR_22:
        DEFB        0X01, 0X31
STR_23:
        DEFB        0X03, 0X31, 0X32, 0X38
STR_24:
        DEFB        0X10, 0X30, 0X30, 0X33, 0X43, 0X34, 0X36, 0X34, 0X36, 0X34, 0X36, 0X34, 0X36, 0X33, 0X43, 0X30, 0X30
STR_25:
        DEFB        0X03, 0X31, 0X32, 0X39
STR_26:
        DEFB        0X10, 0X30, 0X30, 0X31, 0X38, 0X33, 0X38, 0X31, 0X38, 0X31, 0X38, 0X31, 0X38, 0X31, 0X38, 0X30, 0X30
STR_27:
        DEFB        0X03, 0X31, 0X33, 0X30
STR_28:
        DEFB        0X10, 0X30, 0X30, 0X33, 0X43, 0X34, 0X36, 0X30, 0X36, 0X33, 0X43, 0X36, 0X30, 0X37, 0X45, 0X30, 0X30
STR_29:
        DEFB        0X03, 0X31, 0X33, 0X31
STR_3:
        DEFB        0X02, 0X0D, 0X0A
STR_30:
        DEFB        0X10, 0X30, 0X30, 0X33, 0X43, 0X34, 0X36, 0X31, 0X43, 0X30, 0X36, 0X34, 0X36, 0X33, 0X43, 0X30, 0X30
STR_31:
        DEFB        0X03, 0X31, 0X33, 0X32
STR_32:
        DEFB        0X10, 0X30, 0X30, 0X34, 0X43, 0X34, 0X43, 0X34, 0X43, 0X37, 0X43, 0X30, 0X43, 0X30, 0X43, 0X30, 0X30
STR_33:
        DEFB        0X03, 0X31, 0X33, 0X33
STR_34:
        DEFB        0X10, 0X30, 0X30, 0X37, 0X43, 0X34, 0X30, 0X37, 0X43, 0X30, 0X36, 0X30, 0X36, 0X37, 0X43, 0X30, 0X30
STR_35:
        DEFB        0X03, 0X31, 0X33, 0X34
STR_36:
        DEFB        0X10, 0X30, 0X30, 0X33, 0X43, 0X34, 0X30, 0X37, 0X43, 0X34, 0X36, 0X34, 0X36, 0X33, 0X43, 0X30, 0X30
STR_37:
        DEFB        0X03, 0X31, 0X33, 0X35
STR_38:
        DEFB        0X10, 0X30, 0X30, 0X37, 0X45, 0X34, 0X36, 0X30, 0X43, 0X31, 0X38, 0X31, 0X38, 0X30, 0X38, 0X30, 0X30
STR_39:
        DEFB        0X03, 0X31, 0X33, 0X36
STR_4:
        DEFB        0X0C, 0X48, 0X61, 0X6E, 0X64, 0X6F, 0X27, 0X73, 0X20, 0X47, 0X41, 0X4D, 0X45
STR_40:
        DEFB        0X10, 0X30, 0X30, 0X33, 0X43, 0X34, 0X36, 0X33, 0X43, 0X34, 0X36, 0X34, 0X36, 0X33, 0X43, 0X30, 0X30
STR_41:
        DEFB        0X03, 0X31, 0X33, 0X37
STR_42:
        DEFB        0X10, 0X30, 0X30, 0X33, 0X43, 0X34, 0X36, 0X34, 0X36, 0X33, 0X45, 0X30, 0X36, 0X33, 0X43, 0X30, 0X30
STR_43:
        DEFB        0X03, 0X31, 0X34, 0X34
STR_44:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X32, 0X34, 0X31, 0X38, 0X36, 0X36, 0X31, 0X38, 0X32, 0X34, 0X30, 0X30
STR_45:
        DEFB        0X03, 0X31, 0X35, 0X32
STR_46:
        DEFB        0X10, 0X30, 0X30, 0X37, 0X45, 0X37, 0X45, 0X37, 0X45, 0X37, 0X45, 0X37, 0X45, 0X37, 0X45, 0X30, 0X30
STR_47:
        DEFB        0X01, 0X30
STR_48:
        DEFB        0X1B, 0X31, 0X30, 0X30, 0X30, 0X31, 0X30, 0X30, 0X31, 0X31, 0X30, 0X30, 0X31, 0X31, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X30
STR_49:
        DEFB        0X1B, 0X31, 0X31, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30, 0X30, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30, 0X30
STR_5:
        DEFB        0X0F, 0X50, 0X55, 0X53, 0X48, 0X20, 0X53, 0X50, 0X41, 0X43, 0X45, 0X20, 0X4B, 0X45, 0X59, 0X21
STR_50:
        DEFB        0X1B, 0X31, 0X30, 0X31, 0X30, 0X31, 0X30, 0X31, 0X31, 0X31, 0X31, 0X30, 0X31, 0X31, 0X31, 0X30, 0X30, 0X31, 0X31, 0X30, 0X30, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30, 0X30
STR_51:
        DEFB        0X1B, 0X31, 0X30, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31
STR_6:
        DEFB        0X19, 0X32, 0X30, 0X32, 0X34, 0X20, 0X48, 0X61, 0X6E, 0X64, 0X6F, 0X27, 0X73, 0X20, 0X47, 0X41, 0X4D, 0X45, 0X20, 0X43, 0X48, 0X41, 0X4E, 0X4E, 0X45, 0X4C
STR_7:
        DEFB        0X07, 0X56, 0X65, 0X72, 0X20, 0X31, 0X2E, 0X30
STR_8:
        DEFB        0X06, 0X4C, 0X56, 0X20, 0X55, 0X50, 0X21
STR_9:
        DEFB        0X05, 0X53, 0X63, 0X6F, 0X72, 0X65
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
DATA_PTR:
        DEFW        DATA_1500
VAR_AREA_START:
SVARI_I_FOR_END:
        DEFW        0
SVARI_I_FOR_STEP:
        DEFW        0
SVARI_I_LABEL:
        DEFW        0
SVARI_J_FOR_END:
        DEFW        0
SVARI_J_FOR_STEP:
        DEFW        0
SVARI_J_LABEL:
        DEFW        0
SVARI_X_FOR_END:
        DEFW        0
SVARI_X_FOR_STEP:
        DEFW        0
SVARI_X_LABEL:
        DEFW        0
SVARI_Y_FOR_END:
        DEFW        0
SVARI_Y_FOR_STEP:
        DEFW        0
SVARI_Y_LABEL:
        DEFW        0
VARD_T:
        DEFW        0, 0, 0, 0
VARI_B:
        DEFW        0
VARI_BL:
        DEFW        0
VARI_BN:
        DEFW        0
VARI_BU:
        DEFW        0
VARI_BX:
        DEFW        0
VARI_BY:
        DEFW        0
VARI_C:
        DEFW        0
VARI_FA:
        DEFW        0
VARI_HS:
        DEFW        0
VARI_I:
        DEFW        0
VARI_J:
        DEFW        0
VARI_K:
        DEFW        0
VARI_L:
        DEFW        0
VARI_LF:
        DEFW        0
VARI_LL:
        DEFW        0
VARI_LV:
        DEFW        0
VARI_NX:
        DEFW        0
VARI_PC:
        DEFW        0
VARI_PX:
        DEFW        0
VARI_Q:
        DEFW        0
VARI_R:
        DEFW        0
VARI_SC:
        DEFW        0
VARI_SG:
        DEFW        0
VARI_SL:
        DEFW        0
VARI_SP:
        DEFW        0
VARI_ST:
        DEFW        0
VARI_T:
        DEFW        0
VARI_X:
        DEFW        0
VARI_Y:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_BG:
        DEFW        0
VARS_D:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARIA_BL:
        DEFW        0
VARA_AREA_END:
VARSA_AREA_START:
VARSA_BK:
        DEFW        0
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
