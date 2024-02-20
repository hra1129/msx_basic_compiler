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
BLIB_WIDTH                      = 0X0403C
BIOS_CLS                        = 0X000C3
BIOS_ERAFNK                     = 0X000CC
BIOS_ERRHAND_REDIM              = 0X0405E
BIOS_UMULT                      = 0X0314A
BIOS_ERRHAND                    = 0X0406F
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
BLIB_LEFT                       = 0X04030
BIOS_IMULT                      = 0X03193
WORK_BUF                        = 0X0F55E
BLIB_MID_CMD                    = 0X0406C
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
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
        XOR         A, A
        CALL        BIOS_CLS
        CALL        BIOS_ERAFNK
LINE_20:
LINE_30:
        LD          HL, [VARSA_MP]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 24
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
LINE_50:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 23
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT3
        LD          [SVARI_Y_LABEL], HL
        JR          _PT2
_PT3:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
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
        LD          HL, [VARI_Y]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 32
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
LINE_55:
        LD          HL, 0
        LD          [VARI_X], HL
        LD          HL, 15
        LD          [SVARI_X_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_X_FOR_STEP], HL
        LD          HL, _PT7
        LD          [SVARI_X_LABEL], HL
        JR          _PT6
_PT7:
        LD          HL, [VARI_X]
        LD          DE, [SVARI_X_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_X], HL
        LD          A, D
        LD          DE, [SVARI_X_FOR_END]
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
LINE_60:
        CALL        LINE_10000
LINE_70:
        LD          HL, [SVARI_X_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
LINE_80:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 22
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
        LD          H, (0) & 255
        INC         H
        PUSH        HL
        LD          HL, [VARI_I]
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
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
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_85:
        LD          H, (0) & 255
        INC         H
        PUSH        HL
        LD          A, 23
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, VARSA_MP
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_SARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, 23
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        COPY_STRING
        PUSH        HL
        LD          C, (31) & 255
        POP         HL
        PUSH        HL
        LD          IX, BLIB_LEFT
        CALL        CALL_BLIB
        POP         DE
        PUSH        HL
        EX          DE, HL
        CALL        FREE_STRING
        POP         HL
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
LINE_90:
        JP          LINE_90
LINE_10000:
        LD          HL, VARSA_MP
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
        DEC         HL
        PUSH        DE
        PUSH        HL
        EX          DE, HL
        CALL        COPY_STRING
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        POP         HL
        CALL        FREE_STRING
        LD          HL, [VARI_X]
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        BIOS_IMULT
        LD          DE, 1
        ADD         HL, DE
        LD          B, L
        LD          C, (2) & 255
        PUSH        BC
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_X]
        LD          DE, 65
        ADD         HL, DE
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, [VARI_Y]
        LD          DE, 65
        ADD         HL, DE
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        LD          HL, VARSA_MP
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
        POP         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        LD          IX, BLIB_MID_CMD
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        RET         
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
        DEFB        0X01, 0X20
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
VARI_I:
        DEFW        0
VARI_X:
        DEFW        0
VARI_Y:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
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
