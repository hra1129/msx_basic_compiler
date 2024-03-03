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
WORK_RG1SV                      = 0X0F3E0
BIOS_WRTVDP                     = 0X00047
WORK_CLIKSW                     = 0X0F3DB
BIOS_CHGCLR                     = 0X00062
WORK_FORCLR                     = 0X0F3E9
WORK_BAKCLR                     = 0X0F3EA
WORK_BDRCLR                     = 0X0F3EB
BIOS_ERAFNK                     = 0X000CC
WORK_USRTAB                     = 0X0F39A
WORK_VALTYP                     = 0X0F663
WORK_DAC                        = 0X0F7F6
BIOS_FRCINT                     = 0X02F8A
BIOS_IMULT                      = 0X03193
BIOS_ERRHAND                    = 0X0406F
WORK_BUF                        = 0X0F55E
BIOS_FIN                        = 0X3299
BIOS_FRCDBL                     = 0X303A
BIOS_WRTVRM                     = 0X004D
BIOS_NWRVRM                     = 0X0177
WORK_SCRMOD                     = 0XFCAF
BLIB_STRCMP                     = 0X04027
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
BLIB_PUTSPRITE                  = 0X04045
BIOS_VMOVFM                     = 0X02F08
BIOS_NEG                        = 0X02E8D
BIOS_FRCSNG                     = 0X0303A
BIOS_IMOD                       = 0X0323A
WORK_JIFFY                      = 0X0FC9E
WORK_ARG                        = 0X0F847
BIOS_XDCOMP                     = 0X02F5C
BIOS_DECSUB                     = 0X0268C
BIOS_MAF                        = 0X02C4D
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
LINE_10:
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
        LD          A, 2
        AND         A, 3
        LD          L, A
        LD          A, [WORK_RG1SV]
        AND         A, 0XFC
        OR          A, L
        LD          B, A
        LD          C, 1
        CALL        BIOS_WRTVDP
        XOR         A, A
        LD          [work_cliksw], A
        LD          A, 15
        LD          [WORK_FORCLR], A
        LD          A, 5
        LD          [WORK_BAKCLR], A
        LD          A, 1
        LD          [WORK_BDRCLR], A
        CALL        BIOS_CHGCLR
        CALL        BIOS_ERAFNK
LINE_15:
        LD          HL, 126
        LD          [WORK_USRTAB + 0], HL
        LD          HL, VARI_A
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          HL, _PT2
        PUSH        HL
        LD          HL, [WORK_USRTAB + 0]
        PUSH        HL
        LD          HL, WORK_DAC
        RET         
_PT2:
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_S
        PUSH        HL
        LD          HL, [62415]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 1
        LD          [VARI_P], HL
        LD          HL, 32
        LD          [VARI_KX], HL
        LD          HL, 128
        LD          [VARI_KY], HL
LINE_100:
; PCG SET
LINE_110:
        LD          HL, 97
        LD          [VARI_M], HL
        LD          HL, DATA_1010
        LD          [DATA_PTR], HL
LINE_120:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 7
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT4
        LD          [SVARI_I_LABEL], HL
        JR          _PT3
_PT4:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT5
        SBC         HL, DE
        JP          M, _PT6
        JR          Z, _PT6
        RET         
_PT5:
        CCF         
        SBC         HL, DE
        RET         M
_PT6:
        POP         HL
_PT3:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
LINE_130:
        LD          HL, [VARI_M]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_1
        PUSH        HL
        LD          HL, [VARS_D]
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
        JR          NC, _PT8
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT8
_PT7:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT8:
LINE_140:
        LD          HL, 2048
        PUSH        HL
        LD          HL, [VARI_M]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_1
        PUSH        HL
        LD          HL, [VARS_D]
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
        JR          NC, _PT10
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT10
_PT9:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT10:
LINE_150:
        LD          HL, 4096
        PUSH        HL
        LD          HL, [VARI_M]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_1
        PUSH        HL
        LD          HL, [VARS_D]
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
        JR          NC, _PT12
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT12
_PT11:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT12:
LINE_160:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_300:
; PCG COLOR
LINE_310:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 7
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT14
        LD          [SVARI_I_LABEL], HL
        JR          _PT13
_PT14:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT15
        SBC         HL, DE
        JP          M, _PT16
        JR          Z, _PT16
        RET         
_PT15:
        CCF         
        SBC         HL, DE
        RET         M
_PT16:
        POP         HL
_PT13:
        LD          HL, VARS_C
        CALL        SUB_READ_STRING
LINE_320:
        LD          HL, 8192
        PUSH        HL
        LD          HL, [VARI_M]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_2
        PUSH        HL
        LD          HL, [VARS_C]
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
        JR          NC, _PT18
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT18
_PT17:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT18:
LINE_330:
        LD          HL, 10240
        PUSH        HL
        LD          HL, [VARI_M]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_2
        PUSH        HL
        LD          HL, [VARS_C]
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
LINE_340:
        LD          HL, 12288
        PUSH        HL
        LD          HL, [VARI_M]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_2
        PUSH        HL
        LD          HL, [VARS_C]
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
        JR          NC, _PT22
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT22
_PT21:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT22:
LINE_350:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_360:
        LD          HL, 48
        LD          [VARI_I], HL
        LD          HL, 90
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT24
        LD          [SVARI_I_LABEL], HL
        JR          _PT23
_PT24:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT25
        SBC         HL, DE
        JP          M, _PT26
        JR          Z, _PT26
        RET         
_PT25:
        CCF         
        SBC         HL, DE
        RET         M
_PT26:
        POP         HL
_PT23:
        LD          HL, 0
        LD          [VARI_X], HL
        LD          HL, 7
        LD          [SVARI_X_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_X_FOR_STEP], HL
        LD          HL, _PT28
        LD          [SVARI_X_LABEL], HL
        JR          _PT27
_PT28:
        LD          HL, [VARI_X]
        LD          DE, [SVARI_X_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_X], HL
        LD          A, D
        LD          DE, [SVARI_X_FOR_END]
        RLCA        
        JR          C, _PT29
        SBC         HL, DE
        JP          M, _PT30
        JR          Z, _PT30
        RET         
_PT29:
        CCF         
        SBC         HL, DE
        RET         M
_PT30:
        POP         HL
_PT27:
LINE_370:
        LD          HL, 8192
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 8
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          DE, [VARI_X]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_3
        CALL        SUB_VAL
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT32
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT32
_PT31:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT32:
LINE_380:
        LD          HL, [SVARI_X_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_400:
; SPRITE SET
LINE_410:
        LD          HL, DATA_1510
        LD          [DATA_PTR], HL
LINE_420:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, STR_4
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
        JR          NZ, _PT35
        DEC         HL
_PT35:
        LD          A, L
        OR          A, H
        JP          Z, _PT34
        JP          LINE_430
_PT34:
        LD          HL, [VARI_S]
        PUSH        HL
        LD          HL, STR_2
        PUSH        HL
        LD          HL, [VARS_D]
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
        JR          NC, _PT37
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT37
_PT36:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT37:
        LD          HL, VARI_S
        PUSH        HL
        LD          HL, [VARI_S]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          LINE_420
_PT33:
LINE_430:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, STR_4
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
        JR          NZ, _PT40
        DEC         HL
_PT40:
        LD          A, L
        OR          A, H
        JP          Z, _PT39
        JP          LINE_500
_PT39:
        LD          HL, [VARI_S]
        PUSH        HL
        LD          HL, STR_2
        PUSH        HL
        LD          HL, [VARS_D]
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
        JR          NC, _PT42
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT42
_PT41:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT42:
        LD          HL, VARI_S
        PUSH        HL
        LD          HL, [VARI_S]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          LINE_430
_PT38:
LINE_500:
; MAIN
LINE_510:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 14
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT44
        LD          [SVARI_I_LABEL], HL
        JR          _PT43
_PT44:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT45
        SBC         HL, DE
        JP          M, _PT46
        JR          Z, _PT46
        RET         
_PT45:
        CCF         
        SBC         HL, DE
        RET         M
_PT46:
        POP         HL
_PT43:
        LD          H, (1) & 255
        INC         H
        PUSH        HL
        LD          HL, [VARI_I]
        LD          DE, 3
        ADD         HL, DE
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_5
        CALL        PUTS
        LD          HL, STR_6
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_520:
        LD          H, (0) & 255
        INC         H
        PUSH        HL
        LD          A, 1
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_7
        CALL        PUTS
        LD          HL, STR_6
        CALL        PUTS
        LD          H, (21) & 255
        INC         H
        PUSH        HL
        LD          A, 1
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_8
        CALL        PUTS
        LD          HL, STR_6
        CALL        PUTS
LINE_525:
        LD          HL, 0
        PUSH        HL
        LD          HL, [VARI_KX]
        PUSH        HL
        LD          HL, [VARI_KY]
        PUSH        HL
        LD          HL, 10
        PUSH        HL
        LD          HL, [VARI_C]
        LD          E, L
        LD          D, H
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
        LD          HL, VARI_KX
        PUSH        HL
        LD          HL, [VARI_KX]
        LD          DE, [VARI_P]
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_527:
        LD          HL, [VARI_KX]
        PUSH        HL
        LD          HL, 240
        POP         DE
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT49
        DEC         A
_PT49:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_KX]
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT50
        DEC         A
_PT50:
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
        JP          Z, _PT48
        LD          HL, VARI_P
        PUSH        HL
        LD          HL, [VARI_P]
        EX          DE, HL
        LD          HL, 0
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_C
        PUSH        HL
        LD          HL, [VARI_C]
        LD          DE, 1
        ADD         HL, DE
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IMOD
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _PT47
_PT48:
_PT47:
LINE_528:
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
        LD          HL, VARD_T
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, CONST_45655340
        CALL        LD_ARG_SINGLE_REAL
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT52
        LD          HL, VARD_T
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        JP          _PT51
_PT52:
_PT51:
LINE_529:
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
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT54
        JP          LINE_530
_PT54:
        JP          LINE_529
_PT53:
LINE_530:
        JP          LINE_525
LINE_1000:
; PCG DATA -a-
LINE_1010:
LINE_1020:
LINE_1030:
LINE_1040:
LINE_1050:
LINE_1060:
LINE_1070:
LINE_1080:
LINE_1090:
LINE_1500:
; SPRITE DATA
LINE_1510:
LINE_1520:
LINE_1530:
LINE_1540:
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
        LD          DE, [HEAP_MOVE_SIZE]
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
        LD          DE, [HEAP_MOVE_SIZE]
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
LD_DE_DOUBLE_REAL:
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
LD_ARG_SINGLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        LD          [WORK_ARG+4], BC
        LD          [WORK_ARG+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
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
LD_ARG_DOUBLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 8
        LDIR        
        RET         
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
DATA_1010:
        DEFW        STR_9
DATA_1020:
        DEFW        STR_10
DATA_1030:
        DEFW        STR_11
DATA_1040:
        DEFW        STR_12
DATA_1050:
        DEFW        STR_11
DATA_1060:
        DEFW        STR_11
DATA_1070:
        DEFW        STR_13
DATA_1080:
        DEFW        STR_14
DATA_1090:
        DEFW        STR_15
        DEFW        STR_16
        DEFW        STR_15
        DEFW        STR_17
        DEFW        STR_16
        DEFW        STR_17
        DEFW        STR_16
        DEFW        STR_17
DATA_1510:
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_19
        DEFW        STR_20
        DEFW        STR_21
        DEFW        STR_22
        DEFW        STR_23
        DEFW        STR_24
        DEFW        STR_25
        DEFW        STR_26
DATA_1520:
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_27
        DEFW        STR_28
        DEFW        STR_22
        DEFW        STR_22
        DEFW        STR_29
        DEFW        STR_30
        DEFW        STR_29
        DEFW        STR_31
        DEFW        STR_31
        DEFW        STR_32
        DEFW        STR_33
        DEFW        STR_29
        DEFW        STR_30
        DEFW        STR_4
DATA_1530:
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_34
        DEFW        STR_33
        DEFW        STR_23
        DEFW        STR_23
        DEFW        STR_25
        DEFW        STR_26
        DEFW        STR_25
        DEFW        STR_35
        DEFW        STR_35
        DEFW        STR_36
        DEFW        STR_28
        DEFW        STR_25
        DEFW        STR_26
DATA_1540:
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_18
        DEFW        STR_37
        DEFW        STR_38
        DEFW        STR_21
        DEFW        STR_23
        DEFW        STR_22
        DEFW        STR_39
        DEFW        STR_29
        DEFW        STR_30
        DEFW        STR_4
CONST_45655340:
        DEFB        0X45, 0X65, 0X53, 0X40
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X02, 0X26, 0X42
STR_10:
        DEFB        0X08, 0X31, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30, 0X31
STR_11:
        DEFB        0X08, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30
STR_12:
        DEFB        0X08, 0X31, 0X30, 0X31, 0X31, 0X31, 0X31, 0X30, 0X31
STR_13:
        DEFB        0X08, 0X30, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X30
STR_14:
        DEFB        0X08, 0X30, 0X30, 0X30, 0X31, 0X31, 0X30, 0X30, 0X30
STR_15:
        DEFB        0X02, 0X33, 0X31
STR_16:
        DEFB        0X02, 0X32, 0X31
STR_17:
        DEFB        0X02, 0X43, 0X31
STR_18:
        DEFB        0X02, 0X30, 0X30
STR_19:
        DEFB        0X02, 0X35, 0X31
STR_2:
        DEFB        0X02, 0X26, 0X48
STR_20:
        DEFB        0X02, 0X42, 0X46
STR_21:
        DEFB        0X02, 0X46, 0X46
STR_22:
        DEFB        0X02, 0X45, 0X46
STR_23:
        DEFB        0X02, 0X46, 0X37
STR_24:
        DEFB        0X02, 0X37, 0X38
STR_25:
        DEFB        0X02, 0X33, 0X46
STR_26:
        DEFB        0X02, 0X31, 0X46
STR_27:
        DEFB        0X02, 0X33, 0X38
STR_28:
        DEFB        0X02, 0X37, 0X43
STR_29:
        DEFB        0X02, 0X46, 0X43
STR_3:
        DEFB        0X04, 0X26, 0X48, 0X46, 0X31
STR_30:
        DEFB        0X02, 0X46, 0X38
STR_31:
        DEFB        0X02, 0X46, 0X45
STR_32:
        DEFB        0X02, 0X44, 0X45
STR_33:
        DEFB        0X02, 0X33, 0X45
STR_34:
        DEFB        0X02, 0X31, 0X43
STR_35:
        DEFB        0X02, 0X37, 0X46
STR_36:
        DEFB        0X02, 0X37, 0X42
STR_37:
        DEFB        0X02, 0X38, 0X41
STR_38:
        DEFB        0X02, 0X46, 0X44
STR_39:
        DEFB        0X02, 0X31, 0X45
STR_4:
        DEFB        0X01, 0X2B
STR_5:
        DEFB        0X1B, 0X61, 0X61, 0X61, 0X20, 0X61, 0X61, 0X61, 0X20, 0X61, 0X61, 0X61, 0X20, 0X61, 0X61, 0X61, 0X20, 0X61, 0X61, 0X61, 0X20, 0X61, 0X61, 0X61, 0X20, 0X61, 0X61, 0X61
STR_6:
        DEFB        0X02, 0X0D, 0X0A
STR_7:
        DEFB        0X0B, 0X53, 0X43, 0X4F, 0X52, 0X45, 0X3A, 0X30, 0X30, 0X30, 0X30, 0X30
STR_8:
        DEFB        0X07, 0X4B, 0X41, 0X4D, 0X4F, 0X3A, 0X30, 0X30
STR_9:
        DEFB        0X08, 0X30, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
DATA_PTR:
        DEFW        DATA_1010
VAR_AREA_START:
SVARI_I_FOR_END:
        DEFW        0
SVARI_I_FOR_STEP:
        DEFW        0
SVARI_I_LABEL:
        DEFW        0
SVARI_X_FOR_END:
        DEFW        0
SVARI_X_FOR_STEP:
        DEFW        0
SVARI_X_LABEL:
        DEFW        0
VARD_T:
        DEFW        0, 0, 0, 0
VARI_A:
        DEFW        0
VARI_C:
        DEFW        0
VARI_I:
        DEFW        0
VARI_KX:
        DEFW        0
VARI_KY:
        DEFW        0
VARI_M:
        DEFW        0
VARI_P:
        DEFW        0
VARI_S:
        DEFW        0
VARI_X:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_C:
        DEFW        0
VARS_D:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARA_AREA_END:
VARSA_AREA_START:
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
