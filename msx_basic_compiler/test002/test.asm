; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
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
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
WORK_RG1SV                      = 0X0F3E0
BIOS_WRTVDP                     = 0X00047
WORK_CLIKSW                     = 0X0F3DB
SUBROM_SETPAG                   = 0X013D
WORK_DPPAGE                     = 0X0FAF5
WORK_ACPAGE                     = 0X0FAF6
BIOS_CLS                        = 0X000C3
BLIB_SETSPRITE                  = 0X04042
WORK_VALTYP                     = 0X0F663
WORK_DAC                        = 0X0F7F6
BIOS_VMOVFM                     = 0X02F08
BIOS_NEG                        = 0X02E8D
BIOS_FRCSNG                     = 0X0303A
BIOS_FRCINT                     = 0X02F8A
BLIB_PUTSPRITE                  = 0X04045
BLIB_COLORSPRITE_STR            = 0X040A8
BIOS_ERRHAND                    = 0X0406F
BLIB_INKEY                      = 0X0402A
BLIB_STRCMP                     = 0X04027
BIOS_NEWSTT                     = 0X04601
; BSAVE HEADER -----------------------------------------------------------
        DEFB        0XFE
        DEFW        START_ADDRESS
        DEFW        END_ADDRESS
        DEFW        START_ADDRESS
        ORG         0X8010
START_ADDRESS:
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
PROGRAM_START:
LINE_100:
        LD          A, 15
        LD          [WORK_FORCLR], A
        LD          A, 4
        LD          [WORK_BAKCLR], A
        LD          A, 7
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
LINE_120:
        XOR         A, A
        LD          [WORK_DPPAGE], A
        XOR         A, A
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        BIOS_CLS
        LD          HL, 0
        PUSH        HL
        LD          HL, STR_1
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
LINE_130:
        LD          HL, 0
        PUSH        HL
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCSNG
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 15
        PUSH        HL
        LD          HL, 0
        LD          E, L
        LD          D, H
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_140:
        XOR         A, A
        LD          [WORK_DPPAGE], A
        LD          A, 1
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        BIOS_CLS
        LD          HL, 0
        PUSH        HL
        LD          HL, STR_2
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
LINE_150:
        LD          HL, 0
        PUSH        HL
        LD          HL, 8
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCSNG
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 12
        PUSH        HL
        LD          HL, 0
        LD          E, L
        LD          D, H
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_160:
        XOR         A, A
        LD          [WORK_DPPAGE], A
        LD          A, 2
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        BIOS_CLS
        LD          HL, 0
        PUSH        HL
        LD          HL, STR_3
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
LINE_170:
        LD          HL, 0
        PUSH        HL
        LD          HL, 16
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCSNG
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 13
        PUSH        HL
        LD          HL, 0
        LD          E, L
        LD          D, H
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_180:
        XOR         A, A
        LD          [WORK_DPPAGE], A
        LD          A, 3
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        BIOS_CLS
        LD          HL, 0
        PUSH        HL
        LD          HL, STR_4
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
LINE_190:
        LD          HL, 0
        PUSH        HL
        LD          HL, 24
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCSNG
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 7
        PUSH        HL
        LD          HL, 0
        LD          E, L
        LD          D, H
        POP         HL
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_200:
        LD          HL, 0
        PUSH        HL
        LD          HL, STR_5
        POP         DE
        LD          A, E
        PUSH        HL
        LD          IX, BLIB_COLORSPRITE_STR
        CALL        CALL_BLIB
        POP         HL
        CALL        FREE_STRING
LINE_210:
; 
LINE_220:
        XOR         A, A
        LD          [WORK_DPPAGE], A
        XOR         A, A
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        LINE_1000
LINE_230:
        LD          A, 1
        LD          [WORK_DPPAGE], A
        XOR         A, A
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        LINE_1000
LINE_240:
        LD          A, 2
        LD          [WORK_DPPAGE], A
        XOR         A, A
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        LINE_1000
LINE_250:
        LD          A, 3
        LD          [WORK_DPPAGE], A
        XOR         A, A
        LD          [WORK_ACPAGE], A
        LD          IX, SUBROM_SETPAG
        CALL        BIOS_EXTROM
        EI          
        CALL        LINE_1000
        JP          LINE_220
LINE_1000:
        LD          IX, BLIB_INKEY
        CALL        CALL_BLIB
        CALL        COPY_STRING
        PUSH        HL
        LD          HL, STR_0
        POP         DE
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
        JP          LINE_1000
_PT3:
_PT2:
LINE_1010:
        RET         
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          SP, [WORK_HIMEM]
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
        DEFB        0X20, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38
STR_2:
        DEFB        0X20, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31
STR_3:
        DEFB        0X20, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32
STR_4:
        DEFB        0X20, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X31, 0X32, 0X33
STR_5:
        DEFB        0X10, 0X0A, 0X0B, 0X0F, 0X0B, 0X0A, 0X0B, 0X0F, 0X0B, 0X0A, 0X0B, 0X0F, 0X0B, 0X0A, 0X0B, 0X0F, 0X0B
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
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
