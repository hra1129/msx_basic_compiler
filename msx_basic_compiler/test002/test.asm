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
FILE_INFO_SIZE                  = 37 + 3 * 16
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
BLIB_OPEN_FOR_NONE              = 0X40F9
BIOS_IMULT                      = 0X03193
BIOS_ERRHAND                    = 0X0406F
WORK_PTRFIL                     = 0X0F864
BLIB_LSET                       = 0X04075
BLIB_RSET                       = 0X04078
BLIB_PUT                        = 0X40FC
BLIB_FCLOSE                     = 0X04063
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
LINE_100:
LINE_110:
        LD          HL, STR_1
        PUSH        HL
        LD          HL, 1
        PUSH        HL
        LD          HL, 30
        LD          A, L
        POP         DE
        POP         HL
        CALL        SUB_OPEN_FOR_NONE
LINE_120:
        LD          HL, 1
        CALL        SUB_FILE_NUMBER
        LD          DE, 37
        ADD         HL, DE
        PUSH        HL
        LD          HL, 10
        LD          A, L
        POP         DE
        LD          HL, VARS_A
        CALL        SUB_FIELD
        PUSH        HL
        LD          HL, 20
        LD          A, L
        POP         DE
        LD          HL, VARS_B
        CALL        SUB_FIELD
        LD          [HL], 0
LINE_130:
        LD          HL, VARS_A
        PUSH        HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        LD          A, [DE]
        PUSH        AF
        EX          DE, HL
        CALL        FREE_STRING
        POP         AF
        CALL        ALLOCATE_STRING
        POP         DE
        EX          DE, HL
        PUSH        HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, STR_2
        POP         DE
        EX          DE, HL
        PUSH        DE
        LD          IX, BLIB_LSET
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, VARS_B
        PUSH        HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        LD          A, [DE]
        PUSH        AF
        EX          DE, HL
        CALL        FREE_STRING
        POP         AF
        CALL        ALLOCATE_STRING
        POP         DE
        EX          DE, HL
        PUSH        HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, STR_3
        POP         DE
        EX          DE, HL
        PUSH        DE
        LD          IX, BLIB_RSET
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
LINE_140:
        LD          HL, 1
        CALL        SUB_FILE_NUMBER
        PUSH        HL
        LD          HL, 1
        POP         DE
        LD          IX, BLIB_PUT
        CALL        CALL_BLIB
LINE_150:
        LD          HL, VARS_A
        PUSH        HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        LD          A, [DE]
        PUSH        AF
        EX          DE, HL
        CALL        FREE_STRING
        POP         AF
        CALL        ALLOCATE_STRING
        POP         DE
        EX          DE, HL
        PUSH        HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, STR_4
        POP         DE
        EX          DE, HL
        PUSH        DE
        LD          IX, BLIB_LSET
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
        LD          HL, VARS_B
        PUSH        HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        LD          A, [DE]
        PUSH        AF
        EX          DE, HL
        CALL        FREE_STRING
        POP         AF
        CALL        ALLOCATE_STRING
        POP         DE
        EX          DE, HL
        PUSH        HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, STR_5
        POP         DE
        EX          DE, HL
        PUSH        DE
        LD          IX, BLIB_RSET
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
LINE_160:
        LD          HL, 1
        CALL        SUB_FILE_NUMBER
        PUSH        HL
        LD          HL, 3
        POP         DE
        LD          IX, BLIB_PUT
        CALL        CALL_BLIB
LINE_170:
        LD          HL, 1
PROGRAM_TERMINATION:
        CALL        SUB_TERMINATION
        LD          SP, [WORK_HIMEM]
        LD          HL, _BASIC_END
        JP          BIOS_NEWSTT
SUB_TERMINATION:
        CALL        SUB_ALL_CLOSE
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
SUB_OPEN_SUB:
        PUSH        AF
        PUSH        HL
        LD          A, D
        OR          A, A
        JR          NZ, _SUB_OPEN_BAD_FILE_NUMBER
        DEC         E
        LD          A, E
        CP          A, 15
        JR          NC, _SUB_OPEN_BAD_FILE_NUMBER
        LD          HL, FILE_INFO_SIZE
        CALL        BIOS_IMULT
        LD          DE, [SVARIA_FILE_INFO]
        ADD         HL, DE
        INC         HL
        INC         HL
        LD          [WORK_PTRFIL], HL
        POP         HL
        POP         AF
        RET         
_SUB_OPEN_BAD_FILE_NUMBER:
        LD          E, 52
        JP          BIOS_ERRHAND
SUB_OPEN_FOR_NONE:
        CALL        SUB_OPEN_SUB
        LD          IX, BLIB_OPEN_FOR_NONE
        JP          CALL_BLIB
; Allocate memory for strings. A: Length
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
        JR          NZ, STRING_A
        LD          E, 5
        JP          BIOS_ERRHAND
STRING_A:
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
SUB_FILE_NUMBER:
        DEC         HL
        LD          A, L
        CP          A, 15
        LD          E, 52
        JP          NC, BIOS_ERRHAND
        INC         H
        DEC         H
        JP          NZ, BIOS_ERRHAND
        LD          DE, FILE_INFO_SIZE
        CALL        BIOS_IMULT
        LD          DE, [SVARIA_FILE_INFO]
        ADD         HL, DE
        INC         HL
        INC         HL
        LD          [WORK_PTRFIL], HL
        RET         
; SPACE$ processing. L: Length. RETURN HL: Result string.
SUB_SPACE:
        LD          A, L
        PUSH        AF
        CALL        ALLOCATE_STRING
        POP         AF
        OR          A, A
        RET         Z
        LD          C, A
        LD          B, 0
        INC         HL
        LD          [HL], ' '
        DEC         HL
        DEC         C
        RET         Z
        INC         HL
        PUSH        HL
        LD          E, L
        LD          D, H
        INC         DE
        LDIR        
        POP         HL
        DEC         HL
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
; Auxiliary processing of FIELD instruction. HL: Address of variable, DE: Address of variable list, A: Length
SUB_FIELD:
        EX          DE, HL
        LD          [HL], A
        INC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        PUSH        HL
        PUSH        DE
        PUSH        AF
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        FREE_STRING
        POP         AF
        LD          L, A
        CALL        SUB_SPACE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        POP         HL
        RET         
SUB_CLOSE:
        LD          A, [WORK_MAXFIL]
        LD          E, 52
        CP          A, L
        JP          C, BIOS_ERRHAND
        LD          A, H
        OR          A, A
        JP          NZ, BIOS_ERRHAND
        OR          A, L
        RET         Z
        DEC         L
        LD          DE, FILE_INFO_SIZE
        CALL        BIOS_IMULT
        LD          DE, [SVARIA_FILE_INFO]
        ADD         HL, DE
        INC         HL
        INC         HL
        LD          A, [HL]
        DEC         A
        CP          A, 8
        JR          NC, SUB_CLOSE_END
        PUSH        HL
        LD          IX, BLIB_FCLOSE
        CALL        CALL_BLIB
        POP         HL
SUB_CLOSE_END:
        LD          [HL], 0
        RET         
SUB_ALL_CLOSE:
        LD          A, [WORK_MAXFIL]
        OR          A, A
        RET         Z
        LD          H, 0
        LD          L, A
SUB_ALL_CLOSE_LOOP:
        PUSH        HL
        CALL        SUB_CLOSE
        POP         HL
        DEC         L
        JR          NZ, SUB_ALL_CLOSE_LOOP
        RET         
PROGRAM_RUN:
        LD          HL, [SVARIA_FILE_INFO]
        LD          A, H
        OR          A, L
        JR          Z, FILE_INIT_SKIP
        PUSH        DE
        CALL        SUB_ALL_CLOSE
        LD          HL, 0
        LD          [SVARIA_FILE_INFO], HL
        POP         DE
FILE_INIT_SKIP:
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
        CALL        SUB_INIT_FILES
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
SUB_INIT_FILES:
        LD          HL, [SVARIA_FILE_INFO]
        LD          C, [HL]
        INC         HL
        LD          B, [HL]
        DEC         HL
        INC         BC
        INC         BC
        LD          A, H
        OR          A, L
        CALL        NZ, FREE_HEAP
        LD          A, [WORK_MAXFIL]
        LD          E, A
        LD          D, 0
        LD          HL, FILE_INFO_SIZE
        CALL        BIOS_IMULT
        PUSH        HL
        INC         HL
        INC         HL
        LD          C, L
        LD          B, H
        CALL        ALLOCATE_HEAP
        LD          [SVARIA_FILE_INFO], HL
        POP         DE
        LD          [HL], E
        INC         HL
        LD          [HL], D
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
        DEFB        0X08, 0X48, 0X4F, 0X47, 0X45, 0X2E, 0X54, 0X58, 0X54
STR_2:
        DEFB        0X0A, 0X30, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X39
STR_3:
        DEFB        0X03, 0X41, 0X42, 0X43
STR_4:
        DEFB        0X06, 0X30, 0X30, 0X31, 0X31, 0X32, 0X32
STR_5:
        DEFB        0X07, 0X61, 0X62, 0X63, 0X64, 0X65, 0X66, 0X67
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
SVARI_USR0_BACKUP:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_A:
        DEFW        0
VARS_B:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
SVARIA_FILE_INFO:
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
