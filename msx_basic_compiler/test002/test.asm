; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
work_h_timi                     = 0x0fd9f
work_h_erro                     = 0x0ffb1
work_himem                      = 0x0FC4A
blib_init_ncalbas               = 0x0404e
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
work_romver                     = 0x0002D
bios_chgmod                     = 0x0005F
bios_chgmodp                    = 0x001B5
bios_extrom                     = 0x0015F
work_prtflg                     = 0x0f416
bios_newstt                     = 0x04601
bios_errhand                    = 0x0406F
bios_gttrig                     = 0x00D8
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
        CALL        INTERRUPT_PROCESS
        LD          A, 15
        LD          [WORK_FORCLR], A
        LD          A, 4
        LD          [WORK_BAKCLR], A
        LD          A, 7
        LD          [WORK_BDRCLR], A
        CALL        BIOS_CHGCLR
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          A, [work_romver]
        OR          A, A
        LD          A, L
        JR          NZ, _pt0
        CALL        bios_chgmod
        JR          _pt1
_pt0:
        LD          IX, bios_chgmodp
        CALL        bios_extrom
        EI          
_pt1:
LINE_110:
        CALL        INTERRUPT_PROCESS
        DI          
        LD          HL, 15
        LD          [svari_on_interval_value], HL
        LD          [svari_on_interval_counter], HL
        LD          HL, line_1000
        LD          [svari_on_interval_line], HL
        EI          
        CALL        INTERRUPT_PROCESS
        LD          A, 1
        LD          [svarb_on_interval_mode], A
LINE_120:
        CALL        INTERRUPT_PROCESS
        LD          HL, LINE_1100
        LD          [SVARI_ON_STOP_LINE], HL
        CALL        INTERRUPT_PROCESS
        LD          A, 1
        LD          [SVARB_ON_STOP_MODE], A
LINE_130:
        CALL        INTERRUPT_PROCESS
        DI          
        LD          HL, line_1200
        LD          [svari_on_strig0_line], HL
        EI          
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        AND         A, 7
        ADD         A, A
        ADD         A, A
        LD          L, A
        LD          H, 0
        LD          DE, svarf_on_strig0_mode
        ADD         HL, DE
        LD          [HL], 1
LINE_140:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_I
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 100
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt3
        LD          [svari_I_LABEL], HL
        JR          _pt2
_pt3:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt4
        RST         0x20
        JR          C, _pt5
        JR          Z, _pt5
        RET         NC
_pt4:
        RST         0x20
        RET         C
_pt5:
        POP         HL
_pt2:
        CALL        INTERRUPT_PROCESS
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        CALL        INTERRUPT_PROCESS
        JP          line_140
LINE_1000:
        CALL        INTERRUPT_PROCESS
        LD          A, 2
        LD          [svarb_on_interval_mode], A
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_3
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        CALL        INTERRUPT_PROCESS
        LD          BC, LINE_120
        JP          _RETURN_LINE_NUM
LINE_1100:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        CALL        INTERRUPT_PROCESS
        RET         
LINE_1200:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        CALL        INTERRUPT_PROCESS
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
        LD          [SVARI_ON_INTERVAL_LINE], HL
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
puts:
        LD          B, [HL]
        INC         B
        DEC         B
        RET         Z
_puts_loop:
        INC         HL
        LD          A, [HL]
        RST         0x18
        DJNZ        _puts_loop
        RET         
free_string:
        LD          DE, heap_start
        RST         0x20
        RET         C
        LD          DE, [heap_next]
        RST         0x20
        RET         NC
        LD          C, [HL]
        LD          B, 0
        INC         BC
        JP          free_heap
free_heap:
        PUSH        HL
        ADD         HL, BC
        LD          [heap_move_size], BC
        LD          [heap_remap_address], HL
        EX          DE, HL
        LD          HL, [heap_next]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          A, C
        OR          A, B
        JR          Z, _free_heap_loop0
        LDIR        
_free_heap_loop0:
        LD          [heap_next], DE
        LD          HL, vars_area_start
_free_heap_loop1:
        LD          DE, varsa_area_end
        RST         0x20
        JR          NC, _free_heap_loop1_end
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [heap_remap_address]
        EX          DE, HL
        RST         0x20
        JR          C, _free_heap_loop1_next
        LD          DE, [heap_move_size]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_free_heap_loop1_next:
        POP         HL
        INC         HL
        JR          _free_heap_loop1
_free_heap_loop1_end:
        LD          HL, varsa_area_start
_free_heap_loop2:
        LD          DE, varsa_area_end
        RST         0x20
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
_free_heap_sarray_elements:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [heap_remap_address]
        EX          DE, HL
        RST         0x20
        JR          C, _free_heap_loop2_next
        LD          HL, [heap_move_size]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_free_heap_loop2_next:
        POP         HL
        INC         HL
        DEC         BC
        LD          A, C
        OR          A, B
        JR          NZ, _free_heap_sarray_elements
        POP         HL
        JR          _free_heap_loop2
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
INTERRUPT_PROCESS:
        LD          A, [SVARB_ON_STOP_EXEC]
        OR          A, A
        JR          Z, _SKIP_ON_STOP
        XOR         A, A
        LD          [SVARB_ON_STOP_EXEC], A
        LD          HL, [SVARI_ON_STOP_LINE]
        CALL        JP_HL
_ON_STOP_RETURN_ADDRESS:
_SKIP_ON_STOP:
        LD          A, [SVARB_ON_INTERVAL_EXEC]
        DEC         A
        JR          NZ, _SKIP_ON_INTERVAL
        LD          [SVARB_ON_INTERVAL_EXEC], A
        LD          HL, [SVARI_ON_INTERVAL_LINE]
        CALL        JP_HL
_ON_INTERVAL_RETURN_ADDRESS:
        LD          A, [SVARB_ON_INTERVAL_MODE]
        CP          A, 2
        JR          NZ, _SKIP_ON_INTERVAL
        DEC         A
        LD          [SVARB_ON_INTERVAL_MODE], A
_SKIP_ON_INTERVAL:
        LD          HL, SVARF_ON_STRIG0_MODE
        LD          DE, SVARI_ON_STRIG0_LINE
        LD          B, 5
_ON_STRIG_LOOP1:
        LD          A, [HL]
        INC         HL
        DEC         A
        JR          NZ, _SKIP_STRIG1
        OR          A, [HL]
        JR          Z, _SKIP_STRIG1
        INC         HL
        INC         A
        OR          A, [HL]
        DEC         HL
        JR          NZ, _SKIP_STRIG1
        DEC         A
        INC         HL
        LD          [HL], A
        DEC         HL
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        PUSH        HL
        EX          DE, HL
        PUSH        BC
        CALL        JP_HL
        POP         BC
        POP         DE
        POP         HL
_SKIP_STRIG1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _ON_STRIG_LOOP1
        RET         
INTERRUPT_PROCESS_END:
_RETURN_LINE_NUM:
        POP         HL
        PUSH        BC
        LD          DE, INTERRUPT_PROCESS
        RST         0X20
        RET         C
        LD          DE, INTERRUPT_PROCESS_END
        RST         0X20
        RET         NC
        LD          DE, _ON_INTERVAL_RETURN_ADDRESS
        RST         0X20
        JR          NZ, _RETURN_LINE_NUM_ON_INTERVAL_SKIP
        LD          A, [SVARB_ON_INTERVAL_MODE]
        CP          A, 2
        JR          NZ, _RETURN_LINE_NUM_ON_INTERVAL_RETURN
        DEC         A
        LD          [SVARB_ON_INTERVAL_MODE], A
_RETURN_LINE_NUM_ON_INTERVAL_RETURN:
        POP         HL
        POP         BC
        JP          HL
_RETURN_LINE_NUM_ON_INTERVAL_SKIP:
        LD          DE, _ON_STOP_RETURN_ADDRESS
        RST         0X20
        JR          NZ, _RETURN_LINE_NUM_ON_STOP_SKIP
        POP         HL
        POP         BC
        JP          HL
_RETURN_LINE_NUM_ON_STOP_SKIP:
        POP         HL
        POP         DE
        POP         DE
        POP         DE
        POP         DE
        JP          HL
; H.TIMI PROCESS -----------------
H_TIMI_HANDLER:
        PUSH        AF
; ON STOP PROCESS -------------------
        LD          A, [SVARB_ON_STOP_MODE]
        OR          A, A
        JR          Z, _END_OF_STOP
        LD          A, [SVARB_ON_STOP_LAST]
        LD          D, A
        IN          A, [0XAA]
        AND         A, 0XF0
        OR          A, 6
        LD          C, A
        OUT         [0XAA], A
        IN          A, [0XA9]
        OR          A, 0XFD
        LD          B, A
        LD          A, C
        INC         A
        OUT         [0XAA], A
        IN          A, [0XA9]
        OR          A, 0XEF
        AND         A, B
        LD          [SVARB_ON_STOP_LAST], A
        CP          A, 0XED
        JR          NZ, _END_OF_STOP
        LD          A, D
        CP          A, 0XED
        JR          Z, _END_OF_STOP
        LD          A, 0XED
        LD          [SVARB_ON_STOP_EXEC], A
_END_OF_STOP:
; ON INTERVAL PROCESS ---------------
        LD          A, [SVARB_ON_INTERVAL_MODE]
        OR          A, A
        JR          Z, _END_OF_INTERVAL
        LD          HL, [SVARI_ON_INTERVAL_COUNTER]
        LD          A, L
        OR          A, H
        JR          Z, _HAPPNED_INTERVAL
        DEC         HL
        LD          [SVARI_ON_INTERVAL_COUNTER], HL
        JR          _END_OF_INTERVAL
_HAPPNED_INTERVAL:
        LD          A, [SVARB_ON_INTERVAL_MODE]
        DEC         A
        JR          NZ, _END_OF_INTERVAL
        INC         A
        LD          [SVARB_ON_INTERVAL_EXEC], A
        LD          HL, [SVARI_ON_INTERVAL_VALUE]
        LD          [SVARI_ON_INTERVAL_COUNTER], HL
_END_OF_INTERVAL:
; ON STRIG PROCESS -----------------
        LD          HL, SVARF_ON_STRIG0_MODE
        LD          BC, 0X0500
_ON_STRIG_LOOP2:
        LD          A, [HL]
        INC         HL
        OR          A, A
        JR          Z, _SKIP_STRIG2
        LD          A, [HL]
        INC         HL
        LD          [HL], A
        DEC         HL
        LD          A, C
        PUSH        BC
        CALL        BIOS_GTTRIG
        POP         BC
        LD          [HL], A
_SKIP_STRIG2:
        INC         HL
        INC         HL
        INC         HL
        INC         C
        DJNZ        _ON_STRIG_LOOP2
_END_OF_STRIG:
        POP         AF
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
str_0:
        DEFB        0x00
str_1:
        DEFB        0x03, 0x41, 0x42, 0x43
str_2:
        DEFB        0x02, 0x0D, 0x0A
str_3:
        DEFB        0x0C, 0x20, 0x20, 0x49, 0x4E, 0x54, 0x45, 0x52, 0x56, 0x41, 0x4C, 0x20, 0x20
str_4:
        DEFB        0x16, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x3C, 0x53, 0x54, 0x4F, 0x50, 0x3E, 0x3E, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
str_5:
        DEFB        0x16, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3C, 0x3C, 0x53, 0x54, 0x52, 0x47, 0x3E, 0x3E, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
var_area_start:
svarb_on_interval_exec:
        DEFB        0
svarb_on_interval_mode:
        DEFB        0
svarb_on_stop_exec:
        DEFB        0
svarb_on_stop_last:
        DEFB        0
svarb_on_stop_mode:
        DEFB        0
svarf_on_strig0_mode:
        DEFW        0, 0
svarf_on_strig1_mode:
        DEFW        0, 0
svarf_on_strig2_mode:
        DEFW        0, 0
svarf_on_strig3_mode:
        DEFW        0, 0
svarf_on_strig4_mode:
        DEFW        0, 0
svarf_on_strig5_mode_dummy:
        DEFW        0, 0
svarf_on_strig6_mode_dummy:
        DEFW        0, 0
svarf_on_strig7_mode_dummy:
        DEFW        0, 0
svari_I_FOR_END:
        DEFW        0
svari_I_FOR_STEP:
        DEFW        0
svari_I_LABEL:
        DEFW        0
svari_on_interval_counter:
        DEFW        0
svari_on_interval_line:
        DEFW        0
svari_on_interval_value:
        DEFW        0
svari_on_stop_line:
        DEFW        0
svari_on_strig0_line:
        DEFW        0
svari_on_strig1_line:
        DEFW        0
svari_on_strig2_line:
        DEFW        0
svari_on_strig3_line:
        DEFW        0
svari_on_strig4_line:
        DEFW        0
vari_I:
        DEFW        0
var_area_end:
vars_area_start:
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
