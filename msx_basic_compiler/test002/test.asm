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
BLIB_INPUT                      = 0X0407E
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
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
LINE_120:
        LD          HL, 5
        LD          [VARI_I], HL
        LD          HL, -40
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
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
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_130:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_140:
        LD          HL, -40
        LD          [VARI_I], HL
        LD          HL, 5
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
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_150:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_160:
        LD          HL, -250
        LD          [VARI_I], HL
        LD          HL, -290
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
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
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_170:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
SVARI_USR0_BACKUP:
        DEFW        0
VARI_I:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_I:
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
