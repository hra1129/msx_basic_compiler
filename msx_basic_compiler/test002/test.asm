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
BIOS_ERRHAND_REDIM              = 0X0405E
BIOS_UMULT                      = 0X0314A
BIOS_ERRHAND                    = 0X0406F
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
BLIB_WIDTH                      = 0X0403C
BIOS_ERAFNK                     = 0X000CC
BIOS_CLS                        = 0X000C3
BLIB_MID                        = 0X04033
WORK_BUF                        = 0X0F55E
BIOS_FIN                        = 0X3299
BIOS_FRCDBL                     = 0X303A
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
BIOS_FRCINT                     = 0X02F8A
BIOS_IMULT                      = 0X03193
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
BLIB_MID_CMD                    = 0X0406C
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
        LD          HL, [VARSA_MP]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 21
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARSA_MP], HL
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
LINE_864:
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
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
        CALL        BIOS_ERAFNK
        LD          HL, VARS_FL
        PUSH        HL
        LD          HL, 30
        PUSH        HL
        LD          HL, STR_1
        POP         DE
        CALL        STRING
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
LINE_1718:
; ================== BUILD MAP
LINE_1725:
        XOR         A, A
        CALL        BIOS_CLS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 19
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
        SBC         HL, DE
        JP          M, _PT5
        JR          Z, _PT5
        RET         
_PT4:
        CCF         
        SBC         HL, DE
        RET         M
_PT5:
        POP         HL
_PT2:
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 30
        PUSH        HL
        LD          HL, STR_2
        POP         DE
        CALL        STRING
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
LINE_1730:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT7
        LD          [SVARI_I_LABEL], HL
        JR          _PT6
_PT7:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT8
        SBC         HL, DE
        JP          M, _PT9
        JR          Z, _PT9
        RET         
_PT8:
        CCF         
        SBC         HL, DE
        RET         M
_PT9:
        POP         HL
_PT6:
        LD          HL, VARS_A
        CALL        SUB_READ_STRING
        LD          HL, VARI_L
        PUSH        HL
        LD          HL, [VARS_A]
        CALL        COPY_STRING
        LD          A, [HL]
        PUSH        AF
        CALL        FREE_STRING
        POP         AF
        LD          L, A
        LD          H, 0
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
LINE_1740:
        LD          HL, 0
        LD          [VARI_J], HL
        LD          HL, SVARI_J_FOR_END
        PUSH        HL
        LD          HL, [VARI_L]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 1
        LD          [SVARI_J_FOR_STEP], HL
        LD          HL, _PT11
        LD          [SVARI_J_LABEL], HL
        JR          _PT10
_PT11:
        LD          HL, [VARI_J]
        LD          DE, [SVARI_J_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_J], HL
        LD          A, D
        LD          DE, [SVARI_J_FOR_END]
        RLCA        
        JR          C, _PT12
        SBC         HL, DE
        JP          M, _PT13
        JR          Z, _PT13
        RET         
_PT12:
        CCF         
        SBC         HL, DE
        RET         M
_PT13:
        POP         HL
_PT10:
        LD          HL, VARS_B
        PUSH        HL
        LD          HL, [VARS_A]
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
        LD          HL, VARI_B
        PUSH        HL
        LD          HL, STR_3
        PUSH        HL
        LD          HL, [VARS_B]
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
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
        LD          HL, VARI_II
        PUSH        HL
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, VARI_JJ
        PUSH        HL
        LD          HL, [VARI_J]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [VARI_B]
        LD          A, L
        OR          A, H
        JP          Z, _PT14
        LD          DE, 3
        RST         0X20
        JP          NC, _PT14
        ADD         HL, HL
        LD          DE, _PT15 - 2
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        LD          DE, _PT14
        PUSH        DE
        JP          HL
_PT15:
        DEFW        LINE_1800
        DEFW        LINE_1810
_PT14:
        LD          HL, [SVARI_J_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1745:
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 20
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARS_FL]
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
LINE_1760:
        LD          H, (0) & 255
        INC         H
        PUSH        HL
        LD          A, 1
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        PUSH        HL
        LD          HL, [VARS_FL]
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        LD          HL, STR_1
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 20
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT17
        LD          [SVARI_I_LABEL], HL
        JR          _PT16
_PT17:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT18
        SBC         HL, DE
        JP          M, _PT19
        JR          Z, _PT19
        RET         
_PT18:
        CCF         
        SBC         HL, DE
        RET         M
_PT19:
        POP         HL
_PT16:
        LD          H, (0) & 255
        INC         H
        PUSH        HL
        LD          HL, 1
        LD          DE, [VARI_I]
        ADD         HL, DE
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        PUSH        HL
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        LD          HL, STR_1
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_1770:
        LD          H, (0) & 255
        INC         H
        PUSH        HL
        LD          A, 1
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        JP          program_termination
LINE_1800:
        LD          HL, 0
        LD          [VARI_K], HL
        LD          HL, 1
        LD          [SVARI_K_FOR_END], HL
        LD          [SVARI_K_FOR_STEP], HL
        LD          HL, _PT21
        LD          [SVARI_K_LABEL], HL
        JR          _PT20
_PT21:
        LD          HL, [VARI_K]
        LD          DE, [SVARI_K_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_K], HL
        LD          A, D
        LD          DE, [SVARI_K_FOR_END]
        RLCA        
        JR          C, _PT22
        SBC         HL, DE
        JP          M, _PT23
        JR          Z, _PT23
        RET         
_PT22:
        CCF         
        SBC         HL, DE
        RET         M
_PT23:
        POP         HL
_PT20:
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_II]
        LD          DE, [VARI_K]
        ADD         HL, DE
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
        LD          HL, [VARI_JJ]
        LD          B, L
        LD          C, (2) & 255
        PUSH        BC
        LD          HL, STR_5
        PUSH        HL
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_II]
        LD          DE, [VARI_K]
        ADD         HL, DE
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
        LD          HL, [SVARI_K_LABEL]
        CALL        JP_HL
        RET         
LINE_1810:
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_II]
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
        LD          HL, [VARI_JJ]
        LD          B, L
        LD          C, (2) & 255
        PUSH        BC
        LD          HL, STR_6
        PUSH        HL
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_II]
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
        LD          HL, 1
        LD          [VARI_K], HL
        LD          HL, 5
        LD          [SVARI_K_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_K_FOR_STEP], HL
        LD          HL, _PT25
        LD          [SVARI_K_LABEL], HL
        JR          _PT24
_PT25:
        LD          HL, [VARI_K]
        LD          DE, [SVARI_K_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_K], HL
        LD          A, D
        LD          DE, [SVARI_K_FOR_END]
        RLCA        
        JR          C, _PT26
        SBC         HL, DE
        JP          M, _PT27
        JR          Z, _PT27
        RET         
_PT26:
        CCF         
        SBC         HL, DE
        RET         M
_PT27:
        POP         HL
_PT24:
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_II]
        LD          DE, [VARI_K]
        ADD         HL, DE
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
        LD          HL, [VARI_JJ]
        LD          B, L
        LD          C, (2) & 255
        PUSH        BC
        LD          HL, STR_7
        PUSH        HL
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_II]
        LD          DE, [VARI_K]
        ADD         HL, DE
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
        LD          HL, [SVARI_K_LABEL]
        CALL        JP_HL
        RET         
LINE_20000:
; =========== MAP DATA
LINE_20120:
LINE_20130:
LINE_20140:
LINE_20150:
LINE_20160:
LINE_20170:
LINE_20180:
LINE_20190:
LINE_20200:
LINE_20210:
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
STRING:
        LD          A, [HL]
        OR          A, A
        INC         HL
        LD          A, [HL]
        JR          NZ, STRING_SKIP
        LD          E, 5
        JP          BIOS_ERRHAND
STRING_SKIP:
        PUSH        AF
        LD          A, E
        CALL        ALLOCATE_STRING
        POP         AF
        PUSH        HL
        INC         HL
        LD          B, C
        INC         B
        JR          STRING_LOOP_ENTER
STRING_LOOP:
        LD          [HL], A
        INC         HL
STRING_LOOP_ENTER:
        DJNZ        STRING_LOOP
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
DATA_20120:
        DEFW        STR_8
DATA_20130:
        DEFW        STR_9
DATA_20140:
        DEFW        STR_10
DATA_20150:
        DEFW        STR_11
DATA_20160:
        DEFW        STR_12
DATA_20170:
        DEFW        STR_13
DATA_20180:
        DEFW        STR_14
DATA_20190:
        DEFW        STR_15
DATA_20200:
        DEFW        STR_12
DATA_20210:
        DEFW        STR_16
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X01, 0X2A
STR_10:
        DEFB        0X0F, 0X30, 0X42, 0X30, 0X30, 0X34, 0X30, 0X30, 0X30, 0X30, 0X30, 0X33, 0X30, 0X31, 0X30, 0X34
STR_11:
        DEFB        0X0F, 0X32, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31
STR_12:
        DEFB        0X0F, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30
STR_13:
        DEFB        0X0F, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X37
STR_14:
        DEFB        0X0F, 0X31, 0X30, 0X30, 0X30, 0X30, 0X34, 0X30, 0X30, 0X39, 0X30, 0X30, 0X30, 0X30, 0X30, 0X33
STR_15:
        DEFB        0X0F, 0X31, 0X31, 0X31, 0X31, 0X31, 0X32, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31
STR_16:
        DEFB        0X0F, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X39, 0X33, 0X30, 0X30, 0X30, 0X30, 0X30, 0X35
STR_2:
        DEFB        0X01, 0X20
STR_3:
        DEFB        0X02, 0X26, 0X48
STR_4:
        DEFB        0X02, 0X0D, 0X0A
STR_5:
        DEFB        0X02, 0X2A, 0X2A
STR_6:
        DEFB        0X02, 0X57, 0X57
STR_7:
        DEFB        0X02, 0X48, 0X48
STR_8:
        DEFB        0X0F, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X31
STR_9:
        DEFB        0X0F, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X41, 0X30
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
DATA_PTR:
        DEFW        DATA_20120
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
SVARI_K_FOR_END:
        DEFW        0
SVARI_K_FOR_STEP:
        DEFW        0
SVARI_K_LABEL:
        DEFW        0
VARI_B:
        DEFW        0
VARI_I:
        DEFW        0
VARI_II:
        DEFW        0
VARI_J:
        DEFW        0
VARI_JJ:
        DEFW        0
VARI_K:
        DEFW        0
VARI_L:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_A:
        DEFW        0
VARS_B:
        DEFW        0
VARS_FL:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARA_AREA_END:
VARSA_AREA_START:
VARSA_MP:
        DEFW        0
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
