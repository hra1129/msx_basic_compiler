; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_FILTAB                     = 0X0F860
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
BIOS_FRCDBL                     = 0X0303A
BIOS_ERRHAND                    = 0X0406F
BIOS_DECADD                     = 0X0269A
BIOS_VMOVFM                     = 0X02F08
BIOS_VMOVAM                     = 0X02EEF
BIOS_XDCOMP                     = 0X02F5C
BIOS_FRCINT                     = 0X02F8A
BLIB_MID_CMD                    = 0X0406C
WORK_PRTFLG                     = 0X0F416
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
LINE_5:
LINE_10:
        LD          HL, VARS_A
        LD          DE, STR_1
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
LINE_20:
        LD          HL, VARD_I
        PUSH        HL
        LD          HL, 1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_END
        PUSH        HL
        LD          HL, [VARS_A]
        CALL        COPY_STRING
        LD          A, [HL]
        PUSH        AF
        CALL        FREE_STRING
        POP         AF
        LD          L, A
        LD          H, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_STEP
        PUSH        HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, _PT1
        LD          [SVARD_I_LABEL], HL
        JR          _PT0
_PT1:
        LD          A, 8
        LD          [WORK_VALTYP], A
        LD          HL, VARD_I
        CALL        BIOS_VMOVFM
        LD          HL, SVARD_I_FOR_STEP
        CALL        BIOS_VMOVAM
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        LD          DE, VARD_I
        LD          BC, 8
        LDIR        
        LD          HL, SVARD_I_FOR_END
        CALL        BIOS_VMOVAM
        LD          A, [SVARD_I_FOR_STEP]
        RLCA        
        JR          C, _PT2
        CALL        BIOS_XDCOMP
        DEC         A
        JR          NZ, _PT3
        RET         
_PT2:
        CALL        BIOS_XDCOMP
        INC         A
        RET         Z
_PT3:
        POP         HL
_PT0:
        LD          HL, VARS_A
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
        LD          HL, VARD_I
        LD          DE, WORK_DAC
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          B, L
        LD          C, (2) & 255
        PUSH        BC
        LD          HL, STR_2
        PUSH        HL
        LD          HL, VARS_A
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
        LD          HL, [SVARD_I_LABEL]
        CALL        JP_HL
LINE_30:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARS_A]
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, STR_3
        CALL        PUTS
LINE_40:
        LD          HL, VARS_B
        LD          DE, STR_1
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
LINE_50:
        LD          HL, VARD_I
        PUSH        HL
        LD          HL, 1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_END
        PUSH        HL
        LD          HL, [VARS_B]
        CALL        COPY_STRING
        LD          A, [HL]
        PUSH        AF
        CALL        FREE_STRING
        POP         AF
        LD          L, A
        LD          H, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_STEP
        PUSH        HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, _PT5
        LD          [SVARD_I_LABEL], HL
        JR          _PT4
_PT5:
        LD          A, 8
        LD          [WORK_VALTYP], A
        LD          HL, VARD_I
        CALL        BIOS_VMOVFM
        LD          HL, SVARD_I_FOR_STEP
        CALL        BIOS_VMOVAM
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        LD          DE, VARD_I
        LD          BC, 8
        LDIR        
        LD          HL, SVARD_I_FOR_END
        CALL        BIOS_VMOVAM
        LD          A, [SVARD_I_FOR_STEP]
        RLCA        
        JR          C, _PT6
        CALL        BIOS_XDCOMP
        DEC         A
        JR          NZ, _PT7
        RET         
_PT6:
        CALL        BIOS_XDCOMP
        INC         A
        RET         Z
_PT7:
        POP         HL
_PT4:
        LD          HL, VARS_B
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
        LD          HL, VARD_I
        LD          DE, WORK_DAC
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          B, L
        LD          C, (2) & 255
        PUSH        BC
        LD          HL, STR_2
        PUSH        HL
        LD          HL, VARS_B
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
        LD          HL, [SVARD_I_LABEL]
        CALL        JP_HL
LINE_60:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, [VARS_B]
        CALL        COPY_STRING
        PUSH        HL
        CALL        PUTS
        POP         HL
        CALL        FREE_STRING
        LD          HL, STR_3
        CALL        PUTS
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
LD_DE_DOUBLE_REAL:
        LD          BC, 8
        LDIR        
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
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X14, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X39, 0X30, 0X31, 0X32, 0X33, 0X34, 0X35, 0X36, 0X37, 0X38, 0X39, 0X30
STR_2:
        DEFB        0X02, 0X41, 0X41
STR_3:
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
SVARD_I_FOR_END:
        DEFW        0, 0, 0, 0
SVARD_I_FOR_STEP:
        DEFW        0, 0, 0, 0
SVARD_I_LABEL:
        DEFW        0
VARD_I:
        DEFW        0, 0, 0, 0
VAR_AREA_END:
VARS_AREA_START:
VARS_A:
        DEFW        0
VARS_B:
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
