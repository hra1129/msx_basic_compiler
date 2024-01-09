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
WORK_ASPECT                     = 0X0F931
WORK_CXOFF                      = 0X0F945
WORK_CYOFF                      = 0X0F947
WORK_CPCNT                      = 0X0F939
WORK_CRCSUM                     = 0X0F93D
BIOS_SETATR                     = 0X0011A
WORK_ARG                        = 0X0F847
WORK_VALTYP                     = 0X0F663
WORK_ASPCT1                     = 0X0F40B
WORK_ASPCT2                     = 0X0F40D
WORK_DAC                        = 0X0F7F6
BLIB_GET_SIN_TABLE              = 0X40DE
BIOS_DECMUL                     = 0X027E6
BIOS_INT                        = 0X030CF
WORK_BUF                        = 0X0F55E
WORK_SCRMOD                     = 0X0FCAF
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
        LD          HL, 128
        LD          [WORK_GXPOS], HL
        LD          HL, 100
        LD          HL, 100
        LD          [WORK_CXOFF], HL
        LD          A, 15
        CALL        BIOS_SETATR
        LD          HL, 0
        LD          [WORK_CPCNT + 0], HL
        LD          [WORK_CPCNT + 2], HL
        LD          HL, 0
        LD          [WORK_CRCSUM + 0], HL
        LD          [WORK_CRCSUM + 2], HL
        LD          HL, 0X1041
        LD          [WORK_ASPECT + 0], HL
        LD          HL, 0
        LD          [WORK_ASPECT + 2], HL
        CALL        SUB_CIRCLE
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
LD_ARG_SINGLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        LD          [WORK_ARG+4], BC
        LD          [WORK_ARG+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        RET         
; CIRCLE ROUTINE
SUB_CIRCLE:
        LD          HL, [WORK_CXOFF]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          DE, WORK_ASPECT
        CALL        LD_ARG_SINGLE_REAL
        CALL        BIOS_DECMUL
        CALL        BIOS_INT
        LD          HL, [WORK_DAC + 2]
        LD          A, [WORK_ASPCT2]
        RLCA        
        JR          NC, _SUB_CIRCLE_SKIP1
        SRL         H
        RR          L
_SUB_CIRCLE_SKIP1:
        LD          [WORK_CYOFF], HL
        LD          A, [WORK_ASPCT1 + 1]
        RRCA        
        LD          [WORK_BUF + 65], A
        LD          C, A
        LD          A, [WORK_GXPOS + 1]
        LD          B, A
        AND         A, 0X80
        LD          [WORK_BUF + 67], A
        LD          [WORK_BUF + 68], A
        LD          A, B
        INC         C
        DEC         C
        JR          Z, _SUB_CIRCLE_SKIP2
        RRCA        
_SUB_CIRCLE_SKIP2:
        AND         A, 0X7F
        LD          [WORK_BUF + 66], A
        LD          [WORK_BUF + 69], A
        LD          A, [WORK_GYPOS + 1]
        LD          B, A
        LD          HL, WORK_BUF + 66
        AND         A, 0X80
        LD          C, A
        OR          A, [HL]
        LD          [HL], A
        INC         HL
        LD          A, C
        OR          A, [HL]
        LD          [HL], A
        INC         HL
        LD          A, B
        AND         A, 0X7F
        OR          A, [HL]
        LD          IX, BLIB_GET_SIN_TABLE
        CALL        CALL_BLIB
        LD          B, 32
_SUB_CIRCLE_THETA_LOOP:
        LD          A, WORK_BUF & 0X0FF
        ADD         A, B
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
