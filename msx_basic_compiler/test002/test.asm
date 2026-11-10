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
FILE_INFO_SIZE                  = 37 + 3 * 33
BLIB_STARTUP                    = 0X04105
BLIB_STARTUP_MAIN               = 0X04108
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
BLIB_WIDTH                      = 0X0403C
BIOS_ERRHAND                    = 0X0406F
BLIB_ALLOCATE_HEAP              = 0X04120
BLIB_FREE_HEAP                  = 0X04123
BLIB_SETSPRITE                  = 0X04042
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
BLIB_FILE_PUTS                  = 0X040ED
WORK_PTRFIL                     = 0X0F864
BIOS_FOUT                       = 0X03425
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
BLIB_PUT_DIGITS                 = 0X040F6
BLIB_PUTSPRITE                  = 0X04045
BIOS_CHGET                      = 0X009F
WORK_FILTAB                     = 0XF860
BLIB_TERMINATION                = 0X04117
BLIB_SETUP_H_ERRO               = 0X0410E
WORK_ERRFLG                     = 0X0F414
BLIB_H_ERRO_CLEANUP             = 0X04114
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0X8010
START_ADDRESS:
        CALL        CHECK_BLIB
        JP          NZ, BIOS_SYNTAX_ERROR
        LD          HL, STARTUP_PARAMS
        LD          IX, BLIB_STARTUP
        JP          CALL_BLIB
_BASIC_START_RET:
        LD          HL, STARTUP_PARAMS
        LD          IX, BLIB_STARTUP_MAIN
        CALL        CALL_BLIB
        JP          PROGRAM_RUN
JP_HL:
        JP          HL
_BASIC_START:
        DEFB        ':', 0xCD, 0xB7, 0xEF, 0x11, ':', 0x97, 0xDD, 0xEF, 0x0C
        DEFW        _BASIC_START_RET
        DEFB        ':', 'A', 0xEF, 0xDD, '(', 0x11, ')', 0x00
PROGRAM_START:
LINE_100:
        LD          A, 15
        LD          [WORK_FORCLR], A
        LD          A, 4
        LD          [WORK_BAKCLR], A
        LD          A, 7
        LD          [WORK_BDRCLR], A
        CALL        BIOS_CHGCLR
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
        LD          A, 3
        AND         A, 3
        LD          L, A
        LD          A, [WORK_RG1SV]
        AND         A, 0XFC
        OR          A, L
        LD          B, A
        LD          C, 1
        CALL        BIOS_WRTVDP
        LD          A, 0
        LD          [work_cliksw], A
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
LINE_110:
        LD          HL, 0
        PUSH        HL
        LD          HL, 32
        PUSH        HL
        LD          A, 255
        POP         DE
        CALL        STRING_A
        PUSH        HL
        LD          DE, LEGACY_STRING_BUFFER
        CALL        COPY_STRING_TO_BUFFER
        POP         BC
        POP         DE
        PUSH        BC
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
LINE_120:
        LD          HL, 5
        LD          [VARI_I], HL
        LD          HL, -40
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_I_FOR_STEP], HL
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
        LD          HL, 0
        LD          H, L
        INC         H
        LD          A, 7
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, [VARI_I]
        CALL        PUT_INTEGER
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 0
        LD          E, L
        LD          D, H
        LD          HL, 15
        LD          D, L
        LD          HL, 0
        POP         BC
        RLC         B
        LD          B, C
        LD          C, L
        LD          A, 0
        LD          L, 7
        RL          L
        CALL        BLIB_PUTSPRITE_STUB
LINE_130:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        CALL        SUB_INPUT_STRING_GETCHAR
        POP         DE
        EX          DE, HL
        CALL        ASSIGN_STRING
        CALL        _PT3
LINE_140:
        LD          HL, -40
        LD          [VARI_I], HL
        LD          HL, 5
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
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
        LD          HL, 0
        LD          H, L
        INC         H
        LD          A, 7
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, [VARI_I]
        CALL        PUT_INTEGER
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 0
        POP         BC
        RLC         B
        LD          B, C
        LD          C, L
        LD          A, 0
        LD          L, 1
        RL          L
        CALL        BLIB_PUTSPRITE_STUB
LINE_150:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        CALL        SUB_INPUT_STRING_GETCHAR
        POP         DE
        EX          DE, HL
        CALL        ASSIGN_STRING
        CALL        _PT7
LINE_160:
        LD          HL, -250
        LD          [VARI_I], HL
        LD          HL, -290
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_I_FOR_STEP], HL
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
        LD          HL, 0
        LD          H, L
        INC         H
        LD          A, 7
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, [VARI_I]
        CALL        PUT_INTEGER
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, [VARI_I]
        PUSH        HL
        LD          HL, 0
        LD          E, L
        LD          D, H
        LD          HL, 15
        LD          D, L
        LD          HL, 0
        POP         BC
        RLC         B
        LD          B, C
        LD          C, L
        LD          A, 0
        LD          L, 7
        RL          L
        CALL        BLIB_PUTSPRITE_STUB
LINE_170:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        CALL        SUB_INPUT_STRING_GETCHAR
        POP         DE
        EX          DE, HL
        CALL        ASSIGN_STRING
        CALL        _PT11
PROGRAM_TERMINATION:
        LD          HL, STARTUP_PARAMS
        LD          IX, BLIB_TERMINATION
        JP          CALL_BLIB
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
        LD          HL, HEAP_PARAMS
        LD          IX, BLIB_ALLOCATE_HEAP
        JP          CALL_BLIB
; Allocate memory for strings. A: Length
ALLOCATE_STRING:
        PUSH        AF
        LD          HL, STRING_TEMP_AREA
_ALLOCATE_STRING_SCAN:
        LD          DE, STRING_TEMP_AREA_END
        RST         0X20
        JP          NC, _ALLOCATE_STRING_ERROR
        PUSH        HL
        INC         HL
        LD          A, [HL]
        INC         HL
        OR          A, [HL]
        POP         HL
        JR          Z, _ALLOCATE_STRING_FOUND
        LD          DE, 3
        ADD         HL, DE
        JR          _ALLOCATE_STRING_SCAN
_ALLOCATE_STRING_FOUND:
        POP         AF
        LD          [HL], A
        PUSH        HL
        OR          A, A
        JR          Z, _ALLOCATE_STRING_EMPTY
        LD          C, A
        LD          B, 0
        CALL        ALLOCATE_HEAP
        JR          _ALLOCATE_STRING_STORE
_ALLOCATE_STRING_EMPTY:
        LD          HL, STR_0_DATA
_ALLOCATE_STRING_STORE:
        EX          DE, HL
        POP         HL
        INC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        DEC         HL
        DEC         HL
        RET         
_ALLOCATE_STRING_ERROR:
        POP         AF
        LD          E, 7
        JP          BIOS_ERRHAND
FREE_STRING:
        LD          DE, HEAP_START
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        DEC         HL
        PUSH        HL
        EX          DE, HL
        LD          DE, HEAP_START
        RST         0X20
        JR          C, _FREE_STRING_CLEAR
        LD          DE, [HEAP_NEXT]
        RST         0X20
        JR          NC, _FREE_STRING_CLEAR
        POP         HL
        LD          C, [HL]
        LD          B, 0
        PUSH        HL
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        CALL        FREE_HEAP
        POP         HL
        JR          _FREE_STRING_RELEASE_TEMP
_FREE_STRING_CLEAR:
        POP         HL
_FREE_STRING_RELEASE_TEMP:
RELEASE_STRING_TEMP:
        LD          DE, STRING_TEMP_AREA
        RST         0X20
        RET         C
        LD          DE, STRING_TEMP_AREA_END
        RST         0X20
        RET         NC
        LD          [HL], 0
        INC         HL
        LD          [HL], 0
        INC         HL
        LD          [HL], 0
        RET         
FREE_HEAP:
        EX          DE, HL
        LD          HL, HEAP_PARAMS
        LD          IX, BLIB_FREE_HEAP
        JP          CALL_BLIB
STRING:
        LD          A, [HL]
        OR          A, A
        JR          Z, _STRING_ERROR
        PUSH        DE
        PUSH        HL
        INC         HL
        LD          C, [HL]
        INC         HL
        LD          B, [HL]
        LD          H, B
        LD          L, C
        LD          A, [HL]
        POP         HL
        PUSH        AF
        CALL        FREE_STRING
        POP         AF
        POP         DE
STRING_A:
        PUSH        AF
        LD          A, E
        CALL        ALLOCATE_STRING
        LD          B, [HL]
        PUSH        HL
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        POP         DE
        POP         AF
        LD          C, A
        LD          A, B
        OR          A, A
        JR          Z, _STRING_DONE
STRING_LOOP:
        LD          [HL], C
        INC         HL
        DJNZ        STRING_LOOP
_STRING_DONE:
        EX          DE, HL
        RET         
_STRING_ERROR:
        LD          E, 5
        JP          BIOS_ERRHAND
COPY_STRING_TO_BUFFER:
        LD          A, [HL]
        PUSH        DE
        LD          [DE], A
        INC         DE
        PUSH        DE
        OR          A, A
        JR          Z, _COPY_STRING_TO_BUFFER_EMPTY
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
        POP         DE
        LD          C, A
        LD          B, 0
        LDIR        
        POP         HL
        RET         
_COPY_STRING_TO_BUFFER_EMPTY:
        POP         DE
        POP         HL
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
PUT_INTEGER:
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          IX, BLIB_PUT_DIGITS
        JP          CALL_BLIB
PUTS:
        LD          C, [HL]
        LD          B, C
        LD          A, C
        OR          A, A
        RET         Z
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EX          DE, HL
_PUTS_LOOP:
        LD          A, [HL]
        RST         0X18
        INC         HL
        DJNZ        _PUTS_LOOP
        RET         
; Read a fixed-length string from the keyboard
SUB_INPUT_STRING_GETCHAR:
        PUSH        HL
        LD          C, [HL]
        LD          A, C
        OR          A, A
        JR          Z, _INPUT_STRING_GETCHAR_DONE
        INC         HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        EI          
_INPUT_STRING_GETCHAR_LOOP:
        PUSH        BC
        PUSH        DE
        CALL        BIOS_CHGET
        POP         DE
        POP         BC
        LD          [DE], A
        INC         DE
        DEC         C
        JR          NZ, _INPUT_STRING_GETCHAR_LOOP
_INPUT_STRING_GETCHAR_DONE:
        POP         HL
        RET         
ASSIGN_STRING:
        LD          [STRING_ASSIGN_DESTINATION], HL
        LD          [STRING_ASSIGN_SOURCE], DE
        OR          A, A
        SBC         HL, DE
        RET         Z
        LD          HL, [STRING_ASSIGN_DESTINATION]
        LD          DE, STRING_ASSIGN_OLD
        LD          BC, 3
        LDIR        
        LD          HL, [STRING_ASSIGN_SOURCE]
        LD          DE, [STRING_ASSIGN_DESTINATION]
        LD          BC, 3
        LDIR        
        LD          HL, [STRING_ASSIGN_SOURCE]
        CALL        RELEASE_STRING_TEMP
        LD          HL, STRING_ASSIGN_OLD
        JP          FREE_STRING
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
        LD          HL, STARTUP_PARAMS
        LD          IX, BLIB_SETUP_H_ERRO
        CALL        CALL_BLIB
        EI          
        LD          HL, VAR_AREA_START
        LD          DE, VAR_AREA_START + 1
        LD          BC, STRING_TEMP_AREA_END - VAR_AREA_START - 1
        LD          [HL], 0
        LDIR        
        LD          HL, STR_0
        LD          DE, VARS_AREA_START
        LD          BC, 3
        LDIR        
        RET         
; H.TIMI PROCESS -----------------
H_TIMI_HANDLER:
        JP          H_TIMI_BACKUP
_CODE_RET:
        RET         
H_ERRO_HANDLER:
        PUSH        HL
        PUSH        DE
        PUSH        BC
        LD          HL, STARTUP_PARAMS
        LD          IX, BLIB_H_ERRO_CLEANUP
        CALL        CALL_BLIB
        POP         BC
        POP         DE
        POP         HL
        JP          WORK_H_ERRO
BLIB_PUTSPRITE_STUB:
        LD          IX, BLIB_PUTSPRITE
        JP          CALL_BLIB
STR_0:
        DEFB        0X00
        DEFW        STR_0_DATA
STR_0_DATA:
        DEFB        0
STR_1:
        DEFB        0X02
        DEFW        STR_1_DATA
STR_1_DATA:
        DEFB        0X0D, 0X0A
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
LEGACY_STRING_BUFFER:
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
        DEFW        0
STRING_ASSIGN_SOURCE:
        DEFW        0
STRING_ASSIGN_DESTINATION:
        DEFW        0
STRING_ASSIGN_OLD:
        DEFB        0
        DEFW        0
STARTUP_PARAMS:
        DEFW        heap_start
        DEFW        svari_usr0_backup
        DEFW        _BASIC_START
        DEFW        h_timi_handler
        DEFW        h_timi_backup
        DEFW        h_erro_handler
        DEFW        h_erro_backup
        DEFW        program_start
        DEFW        program_run
        DEFW        _basic_end
        DEFW        0
VAR_AREA_START:
SVARI_I_FOR_END:
        DEFW        0
SVARI_I_FOR_STEP:
        DEFW        0
SVARI_I_LABEL:
        DEFW        0
SVARI_USR0_BACKUP:
        DEFW        0
VARI_I:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_I:
        DEFB        0
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARA_AREA_END:
VARSA_AREA_START:
VARSA_AREA_END:
STRING_TEMP_AREA:
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
        DEFB        0
        DEFW        0
STRING_TEMP_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_REMAP_END:
        DEFW        0
HEAP_PARAMS:
        DEFW        heap_next
        DEFW        heap_end
        DEFW        heap_start
        DEFW        string_temp_area
        DEFW        string_temp_area_end
        DEFW        vars_area_start
        DEFW        vars_area_end
        DEFW        vara_area_start
        DEFW        vara_area_end
        DEFW        varsa_area_start
        DEFW        varsa_area_end
        DEFW        heap_move_size
        DEFW        heap_remap_address
        DEFW        heap_remap_end
        DEFW        0
HEAP_START:
END_ADDRESS:
