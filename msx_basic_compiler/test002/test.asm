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
blib_width                      = 0x0403c
bios_posit                      = 0x000C6
work_csry                       = 0x0F3DC
work_csrx                       = 0x0F3DD
work_csrsw                      = 0x0FCA9
work_prtflg                     = 0x0f416
bios_fout                       = 0x03425
work_dac                        = 0x0f7f6
work_valtyp                     = 0x0f663
work_linlen                     = 0x0f3b0
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
        LD          HL, _CODE_RET
        LD          [SVARI_ON_SPRITE_LINE], HL
        LD          [SVARI_ON_INTERVAL_LINE], HL
        LD          [SVARI_ON_KEY01_LINE], HL
        LD          HL, SVARI_ON_KEY01_LINE
        LD          DE, SVARI_ON_KEY01_LINE + 2
        LD          BC, 20 - 2
        LDIR        
        CALL        SETUP_H_ERRO
        EI          
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
        LD          [work_forclr], A
        LD          A, 4
        LD          [work_bakclr], A
        LD          A, 7
        LD          [work_bdrclr], A
        CALL        bios_chgclr
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
_pt1:
        CALL        INTERRUPT_PROCESS
        LD          HL, 32
        LD          ix, blib_width
        CALL        call_blib
LINE_110:
        CALL        INTERRUPT_PROCESS
        DI          
        LD          HL, 15
        LD          [svari_on_interval_value], HL
        LD          [svari_on_interval_counter], HL
        LD          HL, line_160
        LD          [svari_on_interval_line], HL
        EI          
        CALL        INTERRUPT_PROCESS
        LD          A, 1
        LD          [svarb_on_interval_mode], A
LINE_120:
        CALL        INTERRUPT_PROCESS
        JP          line_120
LINE_130:
; 
LINE_140:
; 
LINE_150:
; 
LINE_160:
        CALL        INTERRUPT_PROCESS
        LD          A, 2
        LD          [svarb_on_interval_mode], A
LINE_170:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_TW
        PUSH        HL
        LD          A, [64670]
        LD          L, A
        LD          H, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          HL, 20
        LD          H, L
        INC         H
        PUSH        HL
        XOR         A, A
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_TW]
        LD          [work_dac + 2], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        LD          A, [work_linlen]
        INC         A
        INC         A
        LD          B, A
        LD          A, [work_csrx]
        ADD         A, [HL]
        CP          A, B
        JR          C, _pt2
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt2:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
; JIFFY VALUE
LINE_180:
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
        JP          BIOS_CALSLT
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
str:
        CALL        bios_fout
fout_adjust:
        DEC         HL
        PUSH        HL
        XOR         A, A
        LD          B, A
_str_loop:
        INC         HL
        CP          A, [HL]
        JR          Z, _str_loop_exit
        INC         B
        JR          _str_loop
_str_loop_exit:
        POP         HL
        LD          [HL], B
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
INTERRUPT_PROCESS:
        LD          A, [SVARB_ON_SPRITE_RUNNING]
        OR          A, A
        JR          NZ, _SKIP_ON_SPRITE
        LD          A, [SVARB_ON_SPRITE_EXEC]
        OR          A, A
        JR          Z, _SKIP_ON_SPRITE
        LD          [SVARB_ON_SPRITE_RUNNING], A
        LD          HL, [SVARI_ON_SPRITE_LINE]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        JP_HL
_ON_SPRITE_RETURN_ADDRESS:
        POP         HL
        POP         HL
        POP         HL
        XOR         A, A
        LD          [SVARB_ON_SPRITE_RUNNING], A
_SKIP_ON_SPRITE:
        LD          A, [SVARB_ON_INTERVAL_EXEC]
        DEC         A
        JR          NZ, _SKIP_ON_INTERVAL
        LD          [SVARB_ON_INTERVAL_EXEC], A
        LD          HL, [SVARI_ON_INTERVAL_LINE]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        JP_HL
        POP         HL
        POP         HL
        POP         HL
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
        LD          HL, SVARF_ON_KEY01_MODE
        LD          DE, SVARI_ON_KEY01_LINE
        LD          B, 0X0A
_ON_KEY_LOOP1:
        LD          A, [HL]
        INC         HL
        AND         A, [HL]
        JR          Z, _SKIP_KEY1
        LD          [HL], 0
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        DEC         HL
        EX          DE, HL
        PUSH        DE
        PUSH        BC
        CALL        JP_HL
        POP         BC
        POP         DE
        POP         HL
_SKIP_KEY1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _ON_KEY_LOOP1
        RET         
INTERRUPT_PROCESS_END:
H_TIMI_HANDLER:
        PUSH        AF
        LD          B, A
        LD          A, [SVARB_ON_SPRITE_MODE]
        OR          A, A
        JR          Z, _END_OF_SPRITE
        LD          A, B
        AND         A, 0X20
        LD          [SVARB_ON_SPRITE_EXEC], A
_END_OF_SPRITE:
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
        DI          
        IN          A, [0XAA]
        AND         A, 0XF0
        OR          A, 6
        LD          B, A
        OUT         [0XAA], A
        IN          A, [0XA9]
        OR          A, 0X1E
        RRCA        
        LD          C, A
        LD          A, B
        INC         A
        OUT         [0XAA], A
        IN          A, [0XA9]
        OR          A, 0XFC
        AND         A, C
        LD          C, A
        LD          HL, SVARF_ON_KEY06_MODE
        LD          B, 0X90
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY07_MODE
        LD          B, 0XA0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY08_MODE
        LD          B, 0XC0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY09_MODE
        LD          B, 0X81
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY10_MODE
        LD          B, 0X82
        CALL        _ON_KEY_SUB
        LD          A, C
        XOR         A, 0X80
        LD          C, A
        LD          HL, SVARF_ON_KEY01_MODE
        LD          B, 0X90
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY02_MODE
        LD          B, 0XA0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY03_MODE
        LD          B, 0XC0
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY04_MODE
        LD          B, 0X81
        CALL        _ON_KEY_SUB
        LD          HL, SVARF_ON_KEY05_MODE
        LD          B, 0X82
        CALL        _ON_KEY_SUB
        POP         AF
        JP          H_TIMI_BACKUP
_ON_KEY_SUB:
        LD          A, [HL]
        AND         A, B
        INC         HL
        INC         HL
        LD          D, [HL]
        LD          [HL], 0
        RET         Z
        AND         A, C
        RET         NZ
        DEC         A
        LD          [HL], A
        AND         A, D
        RET         NZ
        DEC         HL
        DEC         A
        LD          [HL], A
        RET         
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
        DEFB        0x06, 0x4A, 0x49, 0x46, 0x46, 0x59, 0x3D
str_2:
        DEFB        0x02, 0x0D, 0x0A
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
svarb_on_sprite_exec:
        DEFB        0
svarb_on_sprite_mode:
        DEFB        0
svarb_on_sprite_running:
        DEFB        0
svarf_on_key01_mode:
        DEFW        0, 0
svarf_on_key02_mode:
        DEFW        0, 0
svarf_on_key03_mode:
        DEFW        0, 0
svarf_on_key04_mode:
        DEFW        0, 0
svarf_on_key05_mode:
        DEFW        0, 0
svarf_on_key06_mode:
        DEFW        0, 0
svarf_on_key07_mode:
        DEFW        0, 0
svarf_on_key08_mode:
        DEFW        0, 0
svarf_on_key09_mode:
        DEFW        0, 0
svarf_on_key10_mode:
        DEFW        0, 0
svarf_on_key11_mode_dummy:
        DEFW        0, 0
svarf_on_key12_mode_dummy:
        DEFW        0, 0
svarf_on_key13_mode_dummy:
        DEFW        0, 0
svarf_on_key14_mode_dummy:
        DEFW        0, 0
svarf_on_key15_mode_dummy:
        DEFW        0, 0
svarf_on_key16_mode_dummy:
        DEFW        0, 0
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
svari_on_interval_counter:
        DEFW        0
svari_on_interval_line:
        DEFW        0
svari_on_interval_value:
        DEFW        0
svari_on_key01_line:
        DEFW        0
svari_on_key02_line:
        DEFW        0
svari_on_key03_line:
        DEFW        0
svari_on_key04_line:
        DEFW        0
svari_on_key05_line:
        DEFW        0
svari_on_key06_line:
        DEFW        0
svari_on_key07_line:
        DEFW        0
svari_on_key08_line:
        DEFW        0
svari_on_key09_line:
        DEFW        0
svari_on_key10_line:
        DEFW        0
svari_on_sprite_line:
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
vari_TW:
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
