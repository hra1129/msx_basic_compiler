; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_MAXFIL                     = 0X0F85F
WORK_TXTTAB                     = 0X0F676
BIOS_NEWSTT                     = 0X04601
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
BIOS_ERRHAND_REDIM              = 0X0405E
BIOS_IMULT                      = 0X03193
BIOS_ERRHAND                    = 0X0406F
BIOS_UMULT                      = 0X0314A
WORK_PRTFLG                     = 0X0F416
BIOS_FOUT                       = 0X03425
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
WORK_CSRX                       = 0X0F3DD
WORK_LINLEN                     = 0X0F3B0
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
        LD          HL, _BASIC_START
        CALL        BIOS_NEWSTT
_BASIC_START_RET:
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
LINE_100:
        LD          HL, 3
        LD          [VARI_X], HL
LINE_110:
        LD          HL, [VARIA_Z]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 7
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_Z], HL
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
        LD          HL, [VARIA_A]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 11
        PUSH        HL
        EX          DE, HL
        LD          HL, 10
        PUSH        HL
        CALL        BIOS_IMULT
        ADD         HL, HL
        LD          DE, 7
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_A], HL
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
_PT0:
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         A
        JR          NZ, _PT0
        LD          HL, [VARIA_B]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, 11
        PUSH        HL
        EX          DE, HL
        LD          HL, 10
        PUSH        HL
        CALL        BIOS_IMULT
        EX          DE, HL
        LD          HL, 9
        PUSH        HL
        CALL        BIOS_IMULT
        ADD         HL, HL
        LD          DE, 9
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_B], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          A, 3
        LD          [HL], A
        INC         HL
_PT1:
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         A
        JR          NZ, _PT1
        LD          HL, [VARIA_C]
        LD          A, L
        OR          A, H
        JP          NZ, BIOS_ERRHAND_REDIM
        LD          HL, [VARI_X]
        LD          DE, 2
        ADD         HL, DE
        INC         HL
        PUSH        HL
        EX          DE, HL
        LD          HL, 5
        PUSH        HL
        CALL        BIOS_IMULT
        EX          DE, HL
        LD          HL, [VARI_X]
        INC         HL
        PUSH        HL
        CALL        BIOS_IMULT
        EX          DE, HL
        LD          HL, 3
        PUSH        HL
        CALL        BIOS_IMULT
        ADD         HL, HL
        LD          DE, 11
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [VARIA_C], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          A, 4
        LD          [HL], A
        INC         HL
_PT2:
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        DEC         A
        JR          NZ, _PT2
LINE_120:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 6
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
        LD          HL, VARIA_Z
        LD          D, 1
        LD          BC, 27
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_I]
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        EX          DE, HL
        LD          HL, [VARI_I]
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_130:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 6
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT8
        LD          [SVARI_I_LABEL], HL
        JR          _PT7
_PT8:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT9
        SBC         HL, DE
        JP          M, _PT10
        JR          Z, _PT10
        RET         
_PT9:
        CCF         
        SBC         HL, DE
        RET         M
_PT10:
        POP         HL
_PT7:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, VARIA_Z
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
        JR          C, _PT11
        PUSH        HL
        LD          HL, STR_1
        CALL        PUTS
        POP         HL
_PT11:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
LINE_140:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 9
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT13
        LD          [SVARI_Y_LABEL], HL
        JR          _PT12
_PT13:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
        RLCA        
        JR          C, _PT14
        SBC         HL, DE
        JP          M, _PT15
        JR          Z, _PT15
        RET         
_PT14:
        CCF         
        SBC         HL, DE
        RET         M
_PT15:
        POP         HL
_PT12:
        LD          HL, 0
        LD          [VARI_X], HL
        LD          HL, 10
        LD          [SVARI_X_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_X_FOR_STEP], HL
        LD          HL, _PT17
        LD          [SVARI_X_LABEL], HL
        JR          _PT16
_PT17:
        LD          HL, [VARI_X]
        LD          DE, [SVARI_X_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_X], HL
        LD          A, D
        LD          DE, [SVARI_X_FOR_END]
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
        LD          HL, VARIA_A
        LD          D, 2
        LD          BC, 249
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        LD          C, L
        LD          B, H
        POP         DE
        CALL        BIOS_UMULT
        LD          HL, [VARI_X]
        ADD         HL, DE
        ADD         HL, HL
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_X]
        PUSH        HL
        LD          HL, [VARI_Y]
        EX          DE, HL
        LD          HL, 11
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [SVARI_X_LABEL]
        CALL        JP_HL
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
LINE_150:
        LD          HL, 0
        LD          [VARI_Y], HL
        LD          HL, 9
        LD          [SVARI_Y_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_Y_FOR_STEP], HL
        LD          HL, _PT21
        LD          [SVARI_Y_LABEL], HL
        JR          _PT20
_PT21:
        LD          HL, [VARI_Y]
        LD          DE, [SVARI_Y_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_Y], HL
        LD          A, D
        LD          DE, [SVARI_Y_FOR_END]
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
        LD          HL, 0
        LD          [VARI_X], HL
        LD          HL, 10
        LD          [SVARI_X_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_X_FOR_STEP], HL
        LD          HL, _PT25
        LD          [SVARI_X_LABEL], HL
        JR          _PT24
_PT25:
        LD          HL, [VARI_X]
        LD          DE, [SVARI_X_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_X], HL
        LD          A, D
        LD          DE, [SVARI_X_FOR_END]
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
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, VARIA_A
        LD          D, 2
        LD          BC, 249
        CALL        CHECK_ARRAY
        CALL        CALC_ARRAY_TOP
        LD          HL, [VARI_Y]
        LD          C, L
        LD          B, H
        POP         DE
        CALL        BIOS_UMULT
        LD          HL, [VARI_X]
        ADD         HL, DE
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
        JR          C, _PT28
        PUSH        HL
        LD          HL, STR_1
        CALL        PUTS
        POP         HL
_PT28:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, [SVARI_X_LABEL]
        CALL        JP_HL
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, [SVARI_Y_LABEL]
        CALL        JP_HL
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
STR_0:
        DEFB        0X00
STR_1:
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
SVARI_MAXFILES_BACKUP:
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
VARIA_A:
        DEFW        0
VARIA_B:
        DEFW        0
VARIA_C:
        DEFW        0
VARIA_Z:
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
