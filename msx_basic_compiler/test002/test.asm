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
BIOS_NEWSTT                     = 0X04601
BIOS_ERRHAND                    = 0X0406F
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
        JP          LINE_90
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        DI          
        LD          HL, [HEAP_END]
        LD          DE, HEAP_START
        OR          A, A
        SBC         HL, DE
        LD          C, L
        LD          B, H
        LD          HL, HEAP_START
        LD          DE, HEAP_START + 1
        LD          [HL], 0
        LDIR        
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
