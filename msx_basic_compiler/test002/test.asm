; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_MAXFIL                     = 0X0F85F
WORK_TXTTAB                     = 0X0F676
WORK_VARTAB                     = 0X0F6C2
WORK_USRTAB                     = 0X0F39A
BIOS_NEWSTT                     = 0X04601
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
BIOS_CHGCLR                     = 0X00062
WORK_FORCLR                     = 0X0F3E9
WORK_BAKCLR                     = 0X0F3EA
WORK_BDRCLR                     = 0X0F3EB
WORK_GRPACX                     = 0XFCB7
WORK_GRPACY                     = 0XFCB9
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
WORK_RG1SV                      = 0X0F3E0
BIOS_WRTVDP                     = 0X00047
WORK_CLIKSW                     = 0X0F3DB
BIOS_ERRHAND_REDIM              = 0X0405E
BIOS_IMULT                      = 0X03193
BIOS_ERRHAND                    = 0X0406F
BLIB_PUTSPRITE                  = 0X04045
BIOS_BEEP                       = 0X00C0
BLIB_INKEY                      = 0X0402A
BLIB_STRCMP                     = 0X04027
BIOS_SETPLT                     = 0X0014D
WORK_BUF                        = 0X0F55E
BIOS_FIN                        = 0X3299
BIOS_FRCDBL                     = 0X303A
WORK_DAC                        = 0X0F7F6
BIOS_MAF                        = 0X02C4D
WORK_VALTYP                     = 0X0F663
BIOS_DECMUL                     = 0X027E6
BIOS_FRCINT                     = 0X02F8A
WORK_ARG                        = 0X0F847
BIOS_DECADD                     = 0X0269A
BLIB_COLORSPRITE                = 0X040A5
BLIB_LEFT                       = 0X04030
BLIB_RIGHT                      = 0X0402D
BLIB_SETSPRITE                  = 0X04042
BIOS_UMULT                      = 0X0314A
BLIB_MID                        = 0X04033
BIOS_PSET                       = 0X057F5
BIOS_SETATR                     = 0X0011A
SUBROM_SETC                     = 0X009D
WORK_CLOC                       = 0XF92A
WORK_CMASK                      = 0XF92C
WORK_SCRMOD                     = 0XFCAF
WORK_LOGOPR                     = 0X0FB02
WORK_FILTAB                     = 0XF860
WORK_ERRFLG                     = 0X0F414
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0X8010
START_ADDRESS:
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        LD          HL, 0
        LD          [0X8001], HL
        LD          [0X8002], HL
        LD          HL, [WORK_USRTAB + 0]
        LD          [SVARI_USR0_BACKUP], HL
        LD          HL, HEAP_START
        LD          [WORK_VARTAB], HL
        LD          HL, _BASIC_START
        CALL        BIOS_NEWSTT
_BASIC_START_RET:
        LD          HL, [SVARI_USR0_BACKUP]
        LD          [WORK_USRTAB + 0], HL
        LD          A, 1
        LD          [WORK_MAXFIL], A
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
_BASIC_START:
        DEFB        ':', 0xCD, 0xB7, 0xEF, 0x11, ':', 0x97, 0xDD, 0xEF, 0x0C
        DEFW        _BASIC_START_RET
        DEFB        ':', 'A', 0xEF, 0xDD, '(', 0x11, ')', 0x00
PROGRAM_START:
LINE_1000:
; SAVE"TEST.BAS"
LINE_1010:
LINE_1020:
        LD          A, 15
        LD          [WORK_FORCLR], A
        XOR         A, A
        LD          [WORK_BAKCLR], A
        XOR         A, A
        LD          [WORK_BDRCLR], A
        CALL        BIOS_CHGCLR
        LD          HL, 5
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
LINE_1030:
        LD          HL, [VARSA_S1]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 16
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARSA_S1], HL
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
        LD          HL, [VARSA_S2]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 16
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARSA_S2], HL
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
LINE_1040:
        CALL        LINE_1130
; Set palette
LINE_1050:
        CALL        LINE_1200
; Set sprite
LINE_1060:
        LD          HL, 0
        PUSH        HL
        PUSH        HL
        LD          HL, 0
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 1
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_1070:
        LD          HL, DATA_1600
        LD          [DATA_PTR], HL
LINE_1080:
        CALL        LINE_1360
; Plot enemy
LINE_1090:
; COPY (16,0)-(31,7) TO "TEST.DAT"
LINE_1100:
        CALL        BIOS_BEEP
LINE_1110:
        LD          IX, BLIB_INKEY
        CALL        CALL_BLIB
        CALL        COPY_STRING
        EX          DE, HL
        LD          HL, STR_0
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
        JR          NZ, _PT4
        DEC         HL
_PT4:
        LD          A, L
        OR          A, H
        JP          Z, _PT3
        JP          LINE_1110
_PT3:
_PT2:
LINE_1120:
        JP          program_termination
LINE_1130:
; Set palette
LINE_1140:
        LD          HL, 0
        PUSH        HL
        PUSH        HL
        LD          HL, 0
        PUSH        HL
        LD          A, L
        AND         A, 0X07
        LD          D, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        LD          E, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        RRCA        
        RRCA        
        RRCA        
        RRCA        
        OR          A, D
        POP         HL
        LD          D, L
        LD          IX, BIOS_SETPLT
        CALL        BIOS_EXTROM
        EI          
; Transparent
LINE_1150:
        LD          HL, 1
        PUSH        HL
        LD          HL, 7
        PUSH        HL
        LD          HL, 2
        PUSH        HL
        XOR         A, A
        AND         A, 0X07
        LD          D, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        LD          E, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        RRCA        
        RRCA        
        RRCA        
        RRCA        
        OR          A, D
        POP         HL
        LD          D, L
        LD          IX, BIOS_SETPLT
        CALL        BIOS_EXTROM
        EI          
; Orange
LINE_1160:
        LD          HL, 2
        PUSH        HL
        LD          HL, 0
        PUSH        HL
        PUSH        HL
        LD          A, 7
        AND         A, 0X07
        LD          D, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        LD          E, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        RRCA        
        RRCA        
        RRCA        
        RRCA        
        OR          A, D
        POP         HL
        LD          D, L
        LD          IX, BIOS_SETPLT
        CALL        BIOS_EXTROM
        EI          
; Blue
LINE_1170:
        LD          HL, 3
        PUSH        HL
        LD          HL, 7
        PUSH        HL
        PUSH        HL
        XOR         A, A
        AND         A, 0X07
        LD          D, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        LD          E, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        RRCA        
        RRCA        
        RRCA        
        RRCA        
        OR          A, D
        POP         HL
        LD          D, L
        LD          IX, BIOS_SETPLT
        CALL        BIOS_EXTROM
        EI          
; Yellow
LINE_1180:
        LD          HL, 15
        PUSH        HL
        LD          HL, 7
        PUSH        HL
        PUSH        HL
        LD          A, 7
        AND         A, 0X07
        LD          D, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        LD          E, A
        POP         HL
        LD          A, L
        AND         A, 0X07
        RRCA        
        RRCA        
        RRCA        
        RRCA        
        OR          A, D
        POP         HL
        LD          D, L
        LD          IX, BIOS_SETPLT
        CALL        BIOS_EXTROM
        EI          
; White
LINE_1190:
        RET         
LINE_1200:
; Set sprite
LINE_1210:
; FOR K=0 TO 3
LINE_1220:
        LD          HL, 0
        LD          [VARI_J], HL
        LD          HL, 1
        LD          [SVARI_J_FOR_END], HL
        LD          [SVARI_J_FOR_STEP], HL
        LD          HL, _PT6
        LD          [SVARI_J_LABEL], HL
        JR          _PT5
_PT6:
        LD          HL, [VARI_J]
        LD          DE, [SVARI_J_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_J], HL
        LD          A, D
        LD          DE, [SVARI_J_FOR_END]
        RLCA        
        JR          C, _PT7
        SBC         HL, DE
        JP          M, _PT8
        JR          Z, _PT8
        RET         
_PT7:
        CCF         
        SBC         HL, DE
        RET         M
_PT8:
        POP         HL
_PT5:
LINE_1230:
        LD          HL, VARS_L
        LD          DE, STR_0
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
        LD          HL, VARS_R
        LD          DE, STR_0
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
LINE_1240:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, VARI_D
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
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 16
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_1250:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, VARI_D
        PUSH        HL
        LD          HL, [VARI_D]
        PUSH        HL
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        PUSH        HL
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCDBL
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
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_1260:
        LD          HL, [VARI_K2]
        LD          DE, [VARI_J]
        ADD         HL, DE
        EX          DE, HL
        LD          HL, [VARI_D]
        LD          A, E
        LD          IX, BLIB_COLORSPRITE
        CALL        CALL_BLIB
LINE_1270:
        LD          HL, 1
        LD          [VARI_I], HL
        LD          HL, 16
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT10
        LD          [SVARI_I_LABEL], HL
        JR          _PT9
_PT10:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT11
        SBC         HL, DE
        JP          M, _PT12
        JR          Z, _PT12
        RET         
_PT11:
        CCF         
        SBC         HL, DE
        RET         M
_PT12:
        POP         HL
_PT9:
LINE_1280:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
LINE_1290:
        LD          HL, VARS_L
        PUSH        HL
        LD          HL, [VARS_L]
        CALL        COPY_STRING
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, STR_1
        PUSH        HL
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        LD          C, 8
        PUSH        HL
        LD          IX, BLIB_LEFT
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
LINE_1300:
        LD          HL, VARS_R
        PUSH        HL
        LD          HL, [VARS_R]
        CALL        COPY_STRING
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, STR_1
        PUSH        HL
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        LD          C, 8
        PUSH        HL
        LD          IX, BLIB_RIGHT
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
LINE_1310:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1320:
        LD          HL, [VARI_K2]
        LD          DE, [VARI_J]
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARS_L]
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, [VARS_R]
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
LINE_1330:
        LD          HL, [SVARI_J_LABEL]
        CALL        JP_HL
LINE_1340:
; NEXT
LINE_1350:
        RET         
LINE_1360:
; Plot enemy
LINE_1370:
; FOR L=0 TO 3
LINE_1380:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, VARI_C1
        CALL        SUB_READ_INTEGER
LINE_1390:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
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
LINE_1400:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, VARSA_S1
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARS_D]
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
LINE_1410:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1420:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, VARI_C2
        CALL        SUB_READ_INTEGER
LINE_1430:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT18
        LD          [SVARI_I_LABEL], HL
        JR          _PT17
_PT18:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT19
        SBC         HL, DE
        JP          M, _PT20
        JR          Z, _PT20
        RET         
_PT19:
        CCF         
        SBC         HL, DE
        RET         M
_PT20:
        POP         HL
_PT17:
LINE_1440:
        LD          HL, VARS_D
        CALL        SUB_READ_STRING
        LD          HL, VARSA_S2
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARS_D]
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
LINE_1450:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1460:
; FOR K=0 TO 2
LINE_1470:
        LD          HL, 0
        LD          [VARI_J], HL
        LD          HL, 15
        LD          [SVARI_J_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_J_FOR_STEP], HL
        LD          HL, _PT22
        LD          [SVARI_J_LABEL], HL
        JR          _PT21
_PT22:
        LD          HL, [VARI_J]
        LD          DE, [SVARI_J_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_J], HL
        LD          A, D
        LD          DE, [SVARI_J_FOR_END]
        RLCA        
        JR          C, _PT23
        SBC         HL, DE
        JP          M, _PT24
        JR          Z, _PT24
        RET         
_PT23:
        CCF         
        SBC         HL, DE
        RET         M
_PT24:
        POP         HL
_PT21:
LINE_1480:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT26
        LD          [SVARI_I_LABEL], HL
        JR          _PT25
_PT26:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT27
        SBC         HL, DE
        JP          M, _PT28
        JR          Z, _PT28
        RET         
_PT27:
        CCF         
        SBC         HL, DE
        RET         M
_PT28:
        POP         HL
_PT25:
LINE_1490:
        LD          HL, VARI_D1
        PUSH        HL
        LD          HL, VARSA_S1
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_J]
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
        LD          C, 1
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
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_1500:
        LD          HL, VARI_D2
        PUSH        HL
        LD          HL, VARSA_S2
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_J]
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
        LD          C, 1
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
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_1510:
        LD          HL, VARI_C
        PUSH        HL
        LD          HL, [VARI_D1]
        PUSH        HL
        LD          HL, [VARI_D2]
        EX          DE, HL
        LD          HL, [VARI_C2]
        CALL        BIOS_IMULT
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
LINE_1520:
        LD          HL, [VARI_C]
        LD          A, L
        CALL        BIOS_SETATR
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          HL, 16
        LD          DE, [VARI_I]
        ADD         HL, DE
        LD          [WORK_GRPACX], HL
        LD          [WORK_CLOC], HL
        LD          HL, [VARI_J]
        LD          [WORK_GRPACY], HL
        LD          [WORK_CMASK], HL
        EX          DE, HL
        LD          BC, [WORK_CLOC]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT29
        CALL        BIOS_PSET
        JR          _PT30
_PT29:
        LD          IX, SUBROM_SETC
        CALL        BIOS_EXTROM
        EI          
_PT30:
LINE_1530:
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1540:
        LD          HL, [SVARI_J_LABEL]
        CALL        JP_HL
LINE_1550:
; NEXT
LINE_1560:
; NEXT
LINE_1570:
        RET         
LINE_1580:
; Enemy data
LINE_1590:
; Yellow(0)
LINE_1600:
LINE_1610:
LINE_1620:
LINE_1630:
LINE_1640:
LINE_1650:
LINE_1660:
LINE_1670:
LINE_1680:
LINE_1690:
LINE_1700:
LINE_1710:
LINE_1720:
LINE_1730:
LINE_1740:
LINE_1750:
LINE_1760:
LINE_1770:
; Yellow(1)
LINE_1780:
LINE_1790:
LINE_1800:
LINE_1810:
LINE_1820:
LINE_1830:
LINE_1840:
LINE_1850:
LINE_1860:
LINE_1870:
LINE_1880:
LINE_1890:
LINE_1900:
LINE_1910:
LINE_1920:
LINE_1930:
LINE_1940:
PROGRAM_TERMINATION:
        CALL        SUB_TERMINATION
        LD          SP, [WORK_HIMEM]
        LD          HL, _BASIC_END
        JP          BIOS_NEWSTT
SUB_TERMINATION:
        XOR         A, A
        LD          [WORK_MAXFIL], A
        LD          HL, [WORK_HIMEM]
        LD          DE, 267
        SBC         HL, DE
        LD          [WORK_FILTAB], HL
        LD          L, E
        LD          H, D
        INC         DE
        INC         DE
        LD          [HL], E
        INC         HL
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        RET         
_BASIC_END:
        DEFB        ':', 0x92, ':', 0x94, ':', 0x81, 0x00
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
; Read data for string
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
; Val function
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
LD_ARG_DOUBLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 8
        LDIR        
        RET         
; Read data for integer
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
        DI          
        CALL        SETUP_H_ERRO
        EI          
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
        PUSH        HL
        PUSH        DE
        PUSH        BC
        CALL        RESTORE_H_TIMI
        CALL        RESTORE_H_ERRO
        CALL        SUB_TERMINATION
        POP         BC
        POP         DE
        POP         HL
        JP          WORK_H_ERRO
DATA_1600:
        DEFW        str_2
        DEFW        str_3
DATA_1610:
        DEFW        str_4
DATA_1620:
        DEFW        str_4
DATA_1630:
        DEFW        str_4
DATA_1640:
        DEFW        str_5
DATA_1650:
        DEFW        str_6
DATA_1660:
        DEFW        str_7
DATA_1670:
        DEFW        str_8
DATA_1680:
        DEFW        str_8
DATA_1690:
        DEFW        str_9
DATA_1700:
        DEFW        str_10
DATA_1710:
        DEFW        str_5
DATA_1720:
        DEFW        str_5
DATA_1730:
        DEFW        str_5
DATA_1740:
        DEFW        str_5
DATA_1750:
        DEFW        str_4
DATA_1760:
        DEFW        str_4
DATA_1780:
        DEFW        str_11
        DEFW        str_12
DATA_1790:
        DEFW        str_4
DATA_1800:
        DEFW        str_4
DATA_1810:
        DEFW        str_4
DATA_1820:
        DEFW        str_4
DATA_1830:
        DEFW        str_13
DATA_1840:
        DEFW        str_13
DATA_1850:
        DEFW        str_14
DATA_1860:
        DEFW        str_15
DATA_1870:
        DEFW        str_16
DATA_1880:
        DEFW        str_17
DATA_1890:
        DEFW        str_18
DATA_1900:
        DEFW        str_10
DATA_1910:
        DEFW        str_5
DATA_1920:
        DEFW        str_5
DATA_1930:
        DEFW        str_4
DATA_1940:
        DEFW        str_4
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X02, 0X26, 0X42
STR_10:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30, 0X31, 0X30, 0X30, 0X30, 0X30, 0X30
STR_11:
        DEFB        0X04, 0X30, 0X31, 0X30, 0X30
STR_12:
        DEFB        0X01, 0X32
STR_13:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X31, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X30, 0X30
STR_14:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X31, 0X31, 0X30, 0X30, 0X31, 0X30, 0X31, 0X30, 0X30, 0X31, 0X31, 0X30, 0X30
STR_15:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30
STR_16:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30
STR_17:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X30, 0X31, 0X30, 0X31, 0X31, 0X31, 0X30, 0X30, 0X30
STR_18:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X31, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30, 0X30, 0X30, 0X30
STR_2:
        DEFB        0X04, 0X30, 0X30, 0X30, 0X30
STR_3:
        DEFB        0X01, 0X31
STR_4:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30
STR_5:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30
STR_6:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30
STR_7:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30, 0X30, 0X30, 0X30
STR_8:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30, 0X30
STR_9:
        DEFB        0X10, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30, 0X30, 0X30
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
DATA_PTR:
        DEFW        data_1600
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
SVARI_USR0_BACKUP:
        DEFW        0
VARI_C:
        DEFW        0
VARI_C1:
        DEFW        0
VARI_C2:
        DEFW        0
VARI_D:
        DEFW        0
VARI_D1:
        DEFW        0
VARI_D2:
        DEFW        0
VARI_I:
        DEFW        0
VARI_J:
        DEFW        0
VARI_K2:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_D:
        DEFW        0
VARS_L:
        DEFW        0
VARS_R:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARA_AREA_END:
VARSA_AREA_START:
VARSA_S1:
        DEFW        0
VARSA_S2:
        DEFW        0
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
