; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
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
BIOS_ERRHAND                    = 0X0406F
BIOS_QINLIN                     = 0X00B4
BIOS_FIN                        = 0X3299
BIOS_FRCINT                     = 0X2F8A
BIOS_FRCSNG                     = 0X2FB2
BIOS_FRCDBL                     = 0X303A
WORK_DAC                        = 0XF7F6
WORK_VALTYP                     = 0XF663
WORK_PRTFLG                     = 0X0F416
BIOS_FOUT                       = 0X03425
WORK_CSRX                       = 0X0F3DD
WORK_LINLEN                     = 0X0F3B0
BIOS_NEWSTT                     = 0X04601
WORK_TXTTAB                     = 0X0F676
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
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
LINE_110:
        LD          HL, VARI_A
        PUSH        HL
        CALL        SUB_INPUT
        DEFB        2, 0
LINE_120:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, [VARI_A]
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
        JR          C, _PT0
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT0:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          SP, [WORK_FILTAB]
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        LD          HL, _BASIC_END
        CALL        BIOS_NEWSTT
_BASIC_END:
        DEFB        ':', 0x92, ':', 0x94, ':', 0x81, 0x00
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
SUB_INPUT:
        CALL        BIOS_QINLIN
        INC         HL
_SUB_INPUT_STRING_LOOP:
        EX          DE, HL
        POP         HL
        LD          A, [HL]
        CP          A, 3
        JR          Z, _SUB_INPUT_STRING
_SUB_INPUT_NUMBER:
        EX          DE, HL
        PUSH        DE
        LD          A, [HL]
        PUSH        HL
        CALL        BIOS_FIN
        POP         DE
        RST         0X20
        JP          Z, _SUB_INPUT_REDO_FROM_START
        CALL        _SUB_INPUT_SKIP_WHITE
        LD          A, [HL]
        OR          A, A
        JR          Z, _SUB_INPUT_NUMBER_BRANCH
        CP          A, ', '
        JR          Z, _SUB_INPUT_NUMBER_BRANCH
        JP          _SUB_INPUT_REDO_FROM_START
_SUB_INPUT_NUMBER_BRANCH:
        POP         DE
        LD          A, [DE]
        INC         DE
        CP          A, 4
        PUSH        DE
        PUSH        HL
        JP          Z, _SUB_INPUT_SINGLE_REAL
        JR          NC, _SUB_INPUT_DOUBLE_REAL
        CALL        BIOS_FRCINT
        POP         DE
        POP         BC
        POP         HL
        PUSH        BC
        PUSH        DE
        LD          DE, [WORK_DAC + 2]
        LD          [HL], E
        INC         HL
        LD          [HL], D
        POP         HL
        JR          _CHECK_NEXT_DATA
_SUB_INPUT_SINGLE_REAL:
        CALL        BIOS_FRCSNG
        POP         HL
        POP         BC
        POP         DE
        PUSH        BC
        PUSH        HL
        LD          HL, WORK_DAC
        LD          BC, 4
        LDIR        
        POP         HL
        JR          _CHECK_NEXT_DATA
_SUB_INPUT_DOUBLE_REAL:
        CALL        BIOS_FRCDBL
        POP         HL
        POP         BC
        POP         DE
        PUSH        BC
        PUSH        HL
        LD          HL, WORK_DAC
        LD          BC, 8
        LDIR        
        POP         HL
        JR          _CHECK_NEXT_DATA
_SUB_INPUT_STRING:
        INC         HL
        POP         BC
        PUSH        HL
        EX          DE, HL
        CALL        _SUB_INPUT_SKIP_WHITE
        LD          A, [HL]
        CP          A, '"'
        JR          Z, _GET_QUOTE_STRING
_GET_NORMAL_STRING:
        PUSH        BC
        LD          E, L
        LD          D, H
        LD          C, 0
_GET_NORMAL_STRING_LOOP:
        LD          A, [HL]
        OR          A, A
        JR          Z, _GET_STRING_LOOP_EXIT
        CP          A, ', '
        JR          Z, _GET_STRING_LOOP_EXIT
        INC         HL
        INC         C
        JR          _GET_NORMAL_STRING_LOOP
_GET_QUOTE_STRING:
        PUSH        BC
        INC         HL
        LD          E, L
        LD          D, H
        LD          C, 0
_GET_QUOTE_STRING_LOOP:
        LD          A, [HL]
        OR          A, A
        JR          Z, _GET_STRING_LOOP_EXIT
        CP          A, '"'
        INC         HL
        JR          Z, _GET_STRING_LOOP_EXIT
        INC         C
        JR          _GET_QUOTE_STRING_LOOP
_GET_STRING_LOOP_EXIT:
        LD          A, C
        OR          A, A
        JR          Z, _GET_QUOTE_STRING_ZERO
        PUSH        DE
        CALL        ALLOCATE_STRING
        POP         DE
        LD          B, 0
        PUSH        HL
        INC         HL
        EX          DE, HL
        LDIR        
        POP         BC
        JR          _SUB_INPUT_COPY_STRING
_GET_QUOTE_STRING_ZERO:
        LD          BC, STR_0
_SUB_INPUT_COPY_STRING:
        POP         DE
        EX          DE, HL
        LD          [HL], C
        INC         HL
        LD          [HL], B
        EX          DE, HL
_CHECK_NEXT_DATA:
        LD          A, [HL]
        CP          A, '"'
        JR          NZ, _CHECK_NEXT_DATA2
        INC         HL
_CHECK_NEXT_DATA2:
        CALL        _SUB_INPUT_SKIP_WHITE
        LD          A, [HL]
        OR          A, A
        JR          Z, _CHECK_NEXT_PARAMETER
        POP         DE
        PUSH        DE
        LD          A, [DE]
        OR          A, A
        JR          Z, _SUB_INPUT_EXTRA_IGNORED
        INC         HL
        JP          _SUB_INPUT_STRING_LOOP
_CHECK_NEXT_PARAMETER:
        POP         HL
        PUSH        HL
        LD          A, [HL]
        OR          A, A
        RET         Z
_SUB_INPUT_RETYPE:
        LD          A, '?'
        RST         0X18
        JP          SUB_INPUT
_SUB_INPUT_REDO_FROM_START:
        PUSH        HL
        LD          HL, _STR_REDO_FROM_START
        CALL        PUTS
        POP         HL
        JR          _SUB_INPUT_RETYPE
_STR_REDO_FROM_START:
        DEFB        18
        DEFB        "?Redo from start"
        DEFB        13, 10
_SUB_INPUT_EXTRA_IGNORED:
        LD          HL, _STR_EXTRA_IGNORED
        CALL        PUTS
        RET         
_STR_EXTRA_IGNORED:
        DEFB        16
        DEFB        "?Extra ignored"
        DEFB        13, 10
_SUB_INPUT_SKIP_WHITE:
        LD          A, [HL]
        CP          A, ' '
        RET         NZ
        INC         HL
        JR          _SUB_INPUT_SKIP_WHITE
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
        DEFB        0X0A, 0X49, 0X6E, 0X70, 0X75, 0X74, 0X20, 0X64, 0X61, 0X74, 0X61
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
VARI_A:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
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
