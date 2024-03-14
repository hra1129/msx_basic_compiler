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
WORK_BUF                        = 0X0F55E
BLIB_BLOAD                      = 0X04054
WORK_USRTAB                     = 0X0F39A
WORK_VALTYP                     = 0X0F663
WORK_DAC                        = 0X0F7F6
BIOS_FRCINT                     = 0X02F8A
BIOS_FRCDBL                     = 0X0303A
BIOS_NEWSTT                     = 0X04601
BIOS_ERRHAND                    = 0X0406F
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
        LD          HL, 49151
        DI          
        LD          SP, HL
        LD          [WORK_HIMEM], HL
        LD          DE, ERR_RETURN_WITHOUT_GOSUB
        PUSH        DE
        EI          
        LD          DE, _PT0
        JP          PROGRAM_RUN
_PT0:
LINE_110:
        LD          HL, STR_1
        PUSH        HL
        LD          HL, 8192
        LD          [WORK_BUF], HL
        POP         HL
        CALL        SUB_BLOAD
LINE_120:
        LD          HL, 49152
        LD          [WORK_USRTAB + 0], HL
LINE_130:
        LD          HL, VARD_A
        PUSH        HL
        LD          HL, 48
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          HL, _PT1
        PUSH        HL
        LD          HL, [WORK_USRTAB + 0]
        PUSH        HL
        LD          HL, WORK_DAC
        RET         
_PT1:
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, VARD_A
        PUSH        HL
        LD          HL, 49
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          HL, _PT2
        PUSH        HL
        LD          HL, [WORK_USRTAB + 0]
        PUSH        HL
        LD          HL, WORK_DAC
        RET         
_PT2:
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, VARD_A
        PUSH        HL
        LD          HL, 50
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          HL, _PT3
        PUSH        HL
        LD          HL, [WORK_USRTAB + 0]
        PUSH        HL
        LD          HL, WORK_DAC
        RET         
_PT3:
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
PROGRAM_TERMINATION:
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
SUB_BLOAD:
        PUSH        HL
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          HL, SUB_BLOAD_TRANS_START
        LD          DE, SUB_BLOAD_TRANS
        LD          BC, SUB_BLOAD_TRANS_END - SUB_BLOAD_TRANS
        LDIR        
        POP         HL
        CALL        SUB_BLOAD_TRANS
        DI          
        CALL        SETUP_H_TIMI
        CALL        SETUP_H_ERRO
        EI          
        RET         
SUB_BLOAD_TRANS_START:
        ORG         WORK_BUF + 50
SUB_BLOAD_TRANS:
        LD          IY, [WORK_BLIBSLOT - 1]
        LD          IX, BLIB_BLOAD
        CALL        BIOS_CALSLT
        LD          HL, [WORK_HIMEM]
        EX          DE, HL
        RST         0X20
        RET         NC
        LD          HL, _BLOAD_BASIC_END
        CALL        BIOS_NEWSTT
_BLOAD_BASIC_END:
        DEFB        ':', 0x81, 0x00
SUB_BLOAD_TRANS_END:
        ORG         SUB_BLOAD_TRANS_START + SUB_BLOAD_TRANS_END - SUB_BLOAD_TRANS
LD_DE_DOUBLE_REAL:
        LD          BC, 8
        LDIR        
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
        DEFB        0X0B, 0X54, 0X45, 0X53, 0X54, 0X41, 0X53, 0X4D, 0X2E, 0X42, 0X49, 0X4E
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
VARD_A:
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
