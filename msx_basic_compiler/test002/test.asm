; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
BLIB_INIT_NCALBAS               = 0X0404E
WORK_MAXFIL                     = 0XF85F
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
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
BIOS_FRCDBL                     = 0X0303A
BIOS_DECADD                     = 0X0269A
BIOS_VMOVFM                     = 0X02F08
BIOS_VMOVAM                     = 0X02EEF
BIOS_XDCOMP                     = 0X02F5C
WORK_GXPOS                      = 0X0FCB3
WORK_GYPOS                      = 0X0FCB5
WORK_GRPACX                     = 0X0FCB7
WORK_GRPACY                     = 0X0FCB9
WORK_SCRMOD                     = 0X0FCAF
BIOS_LINE                       = 0X058FC
BIOS_LINEB                      = 0X05912
BIOS_LINEBF                     = 0X058C1
BIOS_SETATR                     = 0X0011A
WORK_ARG                        = 0X0F847
BIOS_DECMUL                     = 0X027E6
BIOS_FRCINT                     = 0X02F8A
WORK_LOGOPR                     = 0X0FB02
BIOS_ERRHAND                    = 0X0406F
BLIB_INPUT                      = 0X0407E
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
        XOR         A, A
        LD          [WORK_MAXFIL], A
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
; ----------------------------------------
LINE_20:
; SAMPLE PROGRAM FOR MSX-BACON
LINE_30:
; COPYRIGHT 2023 CHIKUWA TEIKOKU
LINE_40:
; ----------------------------------------
LINE_50:
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
LINE_60:
        LD          HL, VARD_I
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_END
        PUSH        HL
        LD          HL, 9
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_STEP
        PUSH        HL
        LD          HL, CONST_4110000000000000
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, _PT3
        LD          [SVARD_I_LABEL], HL
        JR          _PT2
_PT3:
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
        JR          C, _PT4
        CALL        BIOS_XDCOMP
        DEC         A
        JR          NZ, _PT5
        RET         
_PT4:
        CALL        BIOS_XDCOMP
        INC         A
        RET         Z
_PT5:
        POP         HL
_PT2:
LINE_70:
        LD          HL, 10
        PUSH        HL
        PUSH        HL
        LD          HL, VARD_I
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          [WORK_GXPOS], HL
        LD          [WORK_GRPACX], HL
        LD          HL, 10
        PUSH        HL
        PUSH        HL
        LD          HL, VARD_I
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          [WORK_GYPOS], HL
        LD          [WORK_GRPACY], HL
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          A, 15
        CALL        BIOS_SETATR
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          HL, 90
        PUSH        HL
        LD          HL, 10
        PUSH        HL
        LD          HL, VARD_I
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 90
        PUSH        HL
        LD          HL, 10
        PUSH        HL
        LD          HL, VARD_I
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        EX          DE, HL
        POP         BC
        PUSH        DE
        PUSH        BC
        CALL        BIOS_LINEB
        POP         HL
        LD          [WORK_GXPOS], HL
        POP         HL
        LD          [WORK_GYPOS], HL
LINE_80:
        LD          HL, [SVARD_I_LABEL]
        CALL        JP_HL
LINE_90:
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
LD_DE_DOUBLE_REAL:
        LD          BC, 8
        LDIR        
        RET         
LD_ARG_DOUBLE_REAL:
        LD          DE, WORK_ARG
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
        PUSH        DE
        CALL        RESTORE_H_TIMI
        CALL        RESTORE_H_ERRO
        POP         DE
        JP          WORK_H_ERRO
CONST_4110000000000000:
        DEFB        0X41, 0X10, 0X00, 0X00, 0X00, 0X00, 0X00, 0X00
STR_0:
        DEFB        0X00
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
