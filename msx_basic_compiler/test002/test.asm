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
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
WORK_GXPOS                      = 0X0FCB3
WORK_GYPOS                      = 0X0FCB5
WORK_GRPACX                     = 0X0FCB7
WORK_GRPACY                     = 0X0FCB9
WORK_SCRMOD                     = 0X0FCAF
BIOS_LINE                       = 0X058FC
BIOS_LINEB                      = 0X05912
BIOS_LINEBF                     = 0X058C1
BIOS_SETATR                     = 0X0011A
WORK_LOGOPR                     = 0X0FB02
WORK_SX                         = 0XF562
WORK_SY                         = 0XF564
WORK_NX                         = 0XF56A
WORK_NY                         = 0XF56C
WORK_ACPAGE                     = 0X0FAF6
WORK_BUF                        = 0X0F55E
BLIB_COPY_POS_TO_FILE           = 0X040BD
BIOS_NEWSTT                     = 0X04601
BIOS_ERRHAND                    = 0X0406F
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
LINE_100:
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
LINE_110:
        LD          HL, 0
        LD          [WORK_GXPOS], HL
        LD          [WORK_GRPACX], HL
        LD          HL, 0
        LD          [WORK_GYPOS], HL
        LD          [WORK_GRPACY], HL
        XOR         A, A
        LD          [WORK_LOGOPR], A
        LD          A, 15
        CALL        BIOS_SETATR
        LD          HL, 255
        PUSH        HL
        LD          HL, 211
        EX          DE, HL
        POP         BC
        PUSH        DE
        PUSH        BC
        CALL        BIOS_LINE
        POP         HL
        LD          [WORK_GXPOS], HL
        POP         HL
        LD          [WORK_GYPOS], HL
LINE_120:
        LD          HL, 0
        LD          [WORK_SX], HL
        LD          [WORK_SY], HL
        LD          HL, 255
        LD          DE, [WORK_SX]
        OR          A, A
        SBC         HL, DE
        INC         HL
        LD          [WORK_NX], HL
        LD          HL, 211
        LD          DE, [WORK_SY]
        OR          A, A
        SBC         HL, DE
        INC         HL
        LD          [WORK_NY], HL
        XOR         A, A
        LD          [WORK_SY + 1], A
        LD          HL, [HEAP_NEXT]
        LD          [WORK_BUF + 0], HL
        LD          HL, [HEAP_END]
        LD          [WORK_BUF + 2], HL
        LD          HL, STR_1
        LD          IX, BLIB_COPY_POS_TO_FILE
        CALL        CALL_BLIB
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
        DEFB        0X08, 0X54, 0X45, 0X53, 0X54, 0X2E, 0X47, 0X52, 0X35
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
