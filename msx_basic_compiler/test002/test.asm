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
BIOS_IMULT                      = 0X03193
BLIB_FCLOSE                     = 0X04063
WORK_PRTFLG                     = 0X0F416
BIOS_FOUT                       = 0X03425
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
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
        LD          A, [WORK_MAXFIL]
        LD          [SVARI_MAXFILES_BACKUP], A
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
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_110:
        LD          HL, 2
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_120:
        LD          HL, 3
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_130:
        LD          HL, 4
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_140:
        LD          HL, 5
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_150:
        LD          HL, 6
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_160:
        LD          HL, 7
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_170:
        LD          HL, 8
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_180:
        LD          HL, 9
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_190:
        LD          HL, 10
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_200:
        LD          HL, 11
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_210:
        LD          HL, 12
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_220:
        LD          HL, 13
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_230:
        LD          HL, 14
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_240:
        LD          HL, 15
        CALL        SUB_MAXFILES
        CALL        LINE_260
LINE_250:
        JP          program_termination
LINE_260:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [HEAP_END]
        LD          DE, [HEAP_NEXT]
        OR          A, A
        SBC         HL, DE
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
        LD          HL, STR_1
        CALL        PUTS
        POP         HL
_PT0:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_1
        CALL        PUTS
        RET         
PROGRAM_TERMINATION:
        CALL        SUB_ALL_CLOSE
        LD          A, [SVARI_MAXFILES_BACKUP]
        LD          [WORK_MAXFIL], A
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
        LD          DE, 292
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
        LD          HL, 292
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
SUB_MAXFILES:
        PUSH        HL
        CALL        SUB_ALL_CLOSE
        POP         HL
        LD          A, L
        AND         A, 15
        LD          [WORK_MAXFIL], A
        JP          SUB_INIT_FILES
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
        LD          HL, [SVARIA_FILE_INFO]
        LD          A, H
        OR          A, L
        JR          Z, FILE_INIT_SKIP
        CALL        SUB_ALL_CLOSE
        LD          HL, 0
        LD          [SVARIA_FILE_INFO], HL
FILE_INIT_SKIP:
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
        CALL        SUB_INIT_FILES
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
SVARI_MAXFILES_BACKUP:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
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
