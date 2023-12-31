; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_FILTAB                     = 0X0F860
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
BIOS_ERRHAND_REDIM              = 0X0405E
BIOS_UMULT                      = 0X0314A
BIOS_ERRHAND                    = 0X0406F
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
BIOS_PSET                       = 0X057F5
BIOS_SETATR                     = 0X0011A
SUBROM_SETC                     = 0X009D
WORK_CLOC                       = 0XF92A
WORK_CMASK                      = 0XF92C
WORK_SCRMOD                     = 0XFCAF
WORK_LOGOPR                     = 0X0FB02
BLIB_POINT                      = 0X040DB
BLIB_WIDTH                      = 0X0403C
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
WORK_BUF                        = 0X0F55E
BIOS_CLS                        = 0X000C3
BIOS_FOUT                       = 0X03425
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
WORK_LINLEN                     = 0X0F3B0
BIOS_NEWSTT                     = 0X04601
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
        LD          HL, [VARIA_S2]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 15
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_S2], HL
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
        LD          HL, [VARIA_S3]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 15
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_S3], HL
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
        LD          HL, [VARIA_S4]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 15
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_S4], HL
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
        LD          HL, [VARIA_S5]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 15
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_S5], HL
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
LINE_110:
        LD          HL, 2
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
LINE_120:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT3
        LD          [SVARI_I_LABEL], HL
        JR          _PT2
_PT3:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT4
        RST         0X20
        JR          C, _PT5
        JR          Z, _PT5
        RET         NC
_PT4:
        RST         0X20
        RET         C
_PT5:
        POP         HL
_PT2:
        LD          HL, [VARI_I]
        LD          A, L
        CALL        BIOS_SETATR
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          HL, 123
        LD          [WORK_CLOC], HL
        LD          HL, 45
        LD          [WORK_CMASK], HL
        EX          DE, HL
        LD          BC, [WORK_CLOC]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT6
        CALL        BIOS_PSET
        JR          _PT7
_PT6:
        LD          IX, SUBROM_SETC
        CALL        BIOS_EXTROM
        EI          
_PT7:
        LD          HL, VARIA_S2
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 45
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_130:
        LD          HL, 3
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT8
        CALL        BIOS_CHGMOD
        JR          _PT9
_PT8:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT9:
LINE_140:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT11
        LD          [SVARI_I_LABEL], HL
        JR          _PT10
_PT11:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT12
        RST         0X20
        JR          C, _PT13
        JR          Z, _PT13
        RET         NC
_PT12:
        RST         0X20
        RET         C
_PT13:
        POP         HL
_PT10:
        LD          HL, [VARI_I]
        LD          A, L
        CALL        BIOS_SETATR
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          HL, 123
        LD          [WORK_CLOC], HL
        LD          HL, 45
        LD          [WORK_CMASK], HL
        EX          DE, HL
        LD          BC, [WORK_CLOC]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT14
        CALL        BIOS_PSET
        JR          _PT15
_PT14:
        LD          IX, SUBROM_SETC
        CALL        BIOS_EXTROM
        EI          
_PT15:
        LD          HL, VARIA_S3
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 45
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_150:
        LD          HL, 4
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT16
        CALL        BIOS_CHGMOD
        JR          _PT17
_PT16:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT17:
LINE_160:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT19
        LD          [SVARI_I_LABEL], HL
        JR          _PT18
_PT19:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT20
        RST         0X20
        JR          C, _PT21
        JR          Z, _PT21
        RET         NC
_PT20:
        RST         0X20
        RET         C
_PT21:
        POP         HL
_PT18:
        LD          HL, [VARI_I]
        LD          A, L
        CALL        BIOS_SETATR
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          HL, 123
        LD          [WORK_CLOC], HL
        LD          HL, 45
        LD          [WORK_CMASK], HL
        EX          DE, HL
        LD          BC, [WORK_CLOC]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT22
        CALL        BIOS_PSET
        JR          _PT23
_PT22:
        LD          IX, SUBROM_SETC
        CALL        BIOS_EXTROM
        EI          
_PT23:
        LD          HL, VARIA_S4
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 45
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_170:
        LD          HL, 5
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT24
        CALL        BIOS_CHGMOD
        JR          _PT25
_PT24:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT25:
LINE_180:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT27
        LD          [SVARI_I_LABEL], HL
        JR          _PT26
_PT27:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT28
        RST         0X20
        JR          C, _PT29
        JR          Z, _PT29
        RET         NC
_PT28:
        RST         0X20
        RET         C
_PT29:
        POP         HL
_PT26:
        LD          HL, [VARI_I]
        LD          A, L
        CALL        BIOS_SETATR
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          HL, 123
        LD          [WORK_CLOC], HL
        LD          HL, 45
        LD          [WORK_CMASK], HL
        EX          DE, HL
        LD          BC, [WORK_CLOC]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT30
        CALL        BIOS_PSET
        JR          _PT31
_PT30:
        LD          IX, SUBROM_SETC
        CALL        BIOS_EXTROM
        EI          
_PT31:
        LD          HL, VARIA_S5
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 123
        PUSH        HL
        LD          HL, 45
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_190:
        LD          HL, 0
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT32
        CALL        BIOS_CHGMOD
        JR          _PT33
_PT32:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT33:
        LD          HL, 40
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
LINE_200:
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          A, 1
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, VARS_T0
        LD          DE, STR_0
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
LINE_210:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 6
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT35
        LD          [SVARI_I_LABEL], HL
        JR          _PT34
_PT35:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT36
        RST         0X20
        JR          C, _PT37
        JR          Z, _PT37
        RET         NC
_PT36:
        RST         0X20
        RET         C
_PT37:
        POP         HL
_PT34:
        LD          HL, VARS_T0
        PUSH        HL
        LD          HL, [VARS_T0]
        CALL        COPY_STRING
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 1
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        STR_ADD
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
LINE_220:
        LD          HL, 0
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT38
        CALL        BIOS_CHGMOD
        JR          _PT39
_PT38:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT39:
        LD          HL, 80
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
LINE_230:
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          A, 1
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, VARS_T1
        LD          DE, STR_0
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
LINE_240:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 6
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT41
        LD          [SVARI_I_LABEL], HL
        JR          _PT40
_PT41:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT42
        RST         0X20
        JR          C, _PT43
        JR          Z, _PT43
        RET         NC
_PT42:
        RST         0X20
        RET         C
_PT43:
        POP         HL
_PT40:
        LD          HL, VARS_T1
        PUSH        HL
        LD          HL, [VARS_T1]
        CALL        COPY_STRING
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 1
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        STR_ADD
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
LINE_250:
        LD          HL, 1
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT44
        CALL        BIOS_CHGMOD
        JR          _PT45
_PT44:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT45:
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
LINE_260:
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          A, 1
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, VARS_T2
        LD          DE, STR_0
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
LINE_270:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 6
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT47
        LD          [SVARI_I_LABEL], HL
        JR          _PT46
_PT47:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT48
        RST         0X20
        JR          C, _PT49
        JR          Z, _PT49
        RET         NC
_PT48:
        RST         0X20
        RET         C
_PT49:
        POP         HL
_PT46:
        LD          HL, VARS_T2
        PUSH        HL
        LD          HL, [VARS_T2]
        CALL        COPY_STRING
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 1
        POP         DE
        LD          IX, BLIB_POINT
        CALL        CALL_BLIB
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        STR_ADD
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
        XOR         A, A
        CALL        BIOS_CLS
LINE_280:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT51
        LD          [SVARI_I_LABEL], HL
        JR          _PT50
_PT51:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT52
        RST         0X20
        JR          C, _PT53
        JR          Z, _PT53
        RET         NC
_PT52:
        RST         0X20
        RET         C
_PT53:
        POP         HL
_PT50:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, VARIA_S2
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
        JR          C, _PT54
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT54:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, VARIA_S3
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
        JR          C, _PT55
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT55:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, VARIA_S4
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
        JR          C, _PT56
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT56:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, VARIA_S5
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
        JR          C, _PT57
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT57:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_290:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARS_T0]
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, STR_2
        CALL        PUTS
LINE_300:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARS_T1]
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, STR_2
        CALL        PUTS
LINE_310:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARS_T2]
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, STR_2
        CALL        PUTS
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          SP, [WORK_FILTAB]
        LD          HL, _BASIC_END
        CALL        BIOS_NEWSTT
_BASIC_END:
        DEFB        ':', 0X81, 0X00
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
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X07, 0X41, 0X42, 0X43, 0X44, 0X45, 0X46, 0X47
STR_2:
        DEFB        0X02, 0X0D, 0X0A
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
SVARI_I_FOR_END:
        DEFW        0
SVARI_I_FOR_STEP:
        DEFW        0
SVARI_I_LABEL:
        DEFW        0
VARI_I:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_T0:
        DEFW        0
VARS_T1:
        DEFW        0
VARS_T2:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARIA_S2:
        DEFW        0
VARIA_S3:
        DEFW        0
VARIA_S4:
        DEFW        0
VARIA_S5:
        DEFW        0
VARA_AREA_END:
VARSA_AREA_START:
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
