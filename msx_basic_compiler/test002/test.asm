; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
work_h_timi                     = 0x0fd9f
work_h_erro                     = 0x0ffb1
blib_init_ncalbas               = 0x0404e
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
bios_beep                       = 0x00C0
bios_cls                        = 0x000C3
bios_errhand_redim              = 0x0405e
bios_umult                      = 0x0314a
bios_errhand                    = 0x0406F
bios_posit                      = 0x000C6
work_csry                       = 0x0F3DC
work_csrx                       = 0x0F3DD
work_csrsw                      = 0x0FCA9
work_prtflg                     = 0x0f416
bios_gttrig                     = 0x00D8
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          [save_stack], SP
        CALL        check_blib
        JP          NZ, bios_syntax_error
        LD          IX, blib_init_ncalbas
        CALL        call_blib
        LD          HL, work_h_timi
        LD          DE, h_timi_backup
        LD          BC, 5
        LDIR        
        DI          
        LD          HL, h_timi_handler
        LD          [work_h_timi + 1], HL
        LD          A, 0xC3
        LD          [work_h_timi], A
        LD          HL, _code_ret
        LD          [svari_on_sprite_line], HL
        LD          [svari_on_interval_line], HL
        LD          [svari_on_key01_line], HL
        LD          HL, svari_on_key01_line
        LD          DE, svari_on_key01_line + 2
        LD          BC, 20 - 2
        LDIR        
        LD          HL, work_h_erro
        LD          DE, h_erro_backup
        LD          BC, 5
        LDIR        
        LD          HL, h_erro_handler
        LD          [work_h_erro + 1], HL
        LD          A, 0xC3
        LD          [work_h_erro], A
        EI          
        LD          DE, program_start
        JP          program_run
jp_hl:
        JP          HL
program_start:
line_10:
        CALL        interrupt_process
; 
line_30:
        CALL        interrupt_process
        CALL        line_8000
        CALL        interrupt_process
        CALL        bios_beep
line_40:
        CALL        interrupt_process
        JP          program_termination
line_8000:
        CALL        interrupt_process
; 
line_8010:
        CALL        interrupt_process
        CALL        bios_cls
line_8030:
        CALL        interrupt_process
line_8040:
        CALL        interrupt_process
        LD          HL, [varia_M]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 20
        INC         HL
        PUSH        HL
        EX          DE, HL
        PUSH        DE
        LD          HL, 23
        POP         BC
        INC         HL
        PUSH        HL
        EX          DE, HL
        CALL        bios_umult
        EX          DE, HL
        ADD         HL, HL
        LD          DE, 7
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varia_M], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 2
        LD          [HL], B
        INC         HL
_pt0:
        POP         DE
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        DJNZ        _pt0
        LD          HL, [varia_M0]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 20
        INC         HL
        PUSH        HL
        EX          DE, HL
        PUSH        DE
        LD          HL, 23
        POP         BC
        INC         HL
        PUSH        HL
        EX          DE, HL
        CALL        bios_umult
        EX          DE, HL
        ADD         HL, HL
        LD          DE, 7
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varia_M0], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 2
        LD          [HL], B
        INC         HL
_pt1:
        POP         DE
        LD          [HL], E
        INC         HL
        LD          [HL], D
        INC         HL
        DJNZ        _pt1
line_8210:
        CALL        interrupt_process
        XOR         A, A
        LD          HL, 0
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 0
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
line_8360:
        CALL        interrupt_process
        RET         
program_termination:
        CALL        restore_h_erro
        CALL        restore_h_timi
        LD          SP, [save_stack]
        RET         
check_blib:
        LD          a, [work_blibslot]
        LD          h, 0x40
        CALL        bios_enaslt
        LD          bc, 8
        LD          hl, signature
        LD          de, signature_ref
_check_blib_loop:
        LD          a, [de]
        INC         de
        CPI         
        JR          NZ, _check_blib_exit
        JP          PE, _check_blib_loop
_check_blib_exit:
        PUSH        af
        LD          a, [work_mainrom]
        LD          h, 0x40
        CALL        bios_enaslt
        EI          
        POP         af
        RET         
signature_ref:
        DEFB        "BACONLIB"
call_blib:
        LD          iy, [work_blibslot - 1]
        JP          bios_calslt
allocate_heap:
        LD          HL, [heap_next]
        PUSH        HL
        ADD         HL, BC
        JR          C, _allocate_heap_error
        LD          DE, [heap_end]
        RST         0x20
        JR          NC, _allocate_heap_error
        LD          [heap_next], HL
        POP         HL
        PUSH        HL
        DEC         BC
        LD          E, L
        LD          D, H
        INC         DE
        LD          [HL], 0
        LDIR        
        POP         HL
        RET         
_allocate_heap_error:
        LD          E, 7
        JP          bios_errhand
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
program_run:
        LD          HL, heap_start
        LD          [heap_next], HL
        LD          HL, [save_stack]
        LD          SP, HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        SBC         HL, DE
        LD          [heap_end], HL
        LD          HL, var_area_start
        LD          DE, var_area_start + 1
        LD          BC, varsa_area_end - var_area_start - 1
        LD          [HL], 0
        LDIR        
        RET         
interrupt_process:
        LD          A, [svarb_on_sprite_running]
        OR          A, A
        JR          NZ, _skip_on_sprite
        LD          A, [svarb_on_sprite_exec]
        OR          A, A
        JR          Z, _skip_on_sprite
        LD          [svarb_on_sprite_running], A
        LD          HL, [svari_on_sprite_line]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        jp_hl
_on_sprite_return_address:
        POP         HL
        POP         HL
        POP         HL
        XOR         A, A
        LD          [svarb_on_sprite_running], A
_skip_on_sprite:
        LD          A, [svarb_on_interval_exec]
        DEC         A
        JR          NZ, _skip_on_interval
        LD          [svarb_on_interval_exec], A
        LD          HL, [svari_on_interval_line]
        PUSH        HL
        PUSH        HL
        PUSH        HL
        CALL        jp_hl
        POP         HL
        POP         HL
        POP         HL
_skip_on_interval:
        LD          HL, svarf_on_strig0_mode
        LD          DE, svari_on_strig0_line
        LD          B, 5
_on_strig_loop1:
        LD          A, [HL]
        INC         HL
        DEC         A
        JR          NZ, _skip_strig1
        OR          A, [HL]
        JR          Z, _skip_strig1
        INC         HL
        INC         A
        OR          A, [HL]
        DEC         HL
        JR          NZ, _skip_strig1
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
        CALL        jp_hl
        POP         BC
        POP         DE
        POP         HL
_skip_strig1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _on_strig_loop1
        LD          HL, svarf_on_key01_mode
        LD          DE, svari_on_key01_line
        LD          B, 0x0A
_on_key_loop1:
        LD          A, [HL]
        INC         HL
        AND         A, [HL]
        JR          Z, _skip_key1
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
        CALL        jp_hl
        POP         BC
        POP         DE
        POP         HL
_skip_key1:
        INC         DE
        INC         DE
        INC         HL
        INC         HL
        INC         HL
        DJNZ        _on_key_loop1
        RET         
interrupt_process_end:
h_timi_handler:
        PUSH        AF
        LD          B, A
        LD          A, [svarb_on_sprite_mode]
        OR          A, A
        JR          Z, _end_of_sprite
        LD          A, B
        AND         A, 0x20
        LD          [svarb_on_sprite_exec], A
_end_of_sprite:
        LD          A, [svarb_on_interval_mode]
        OR          A, A
        JR          Z, _end_of_interval
        LD          HL, [svari_on_interval_counter]
        LD          A, L
        OR          A, H
        JR          Z, _happned_interval
        DEC         HL
        LD          [svari_on_interval_counter], HL
        JR          _end_of_interval
_happned_interval:
        LD          A, [svarb_on_interval_mode]
        DEC         A
        JR          NZ, _end_of_interval
        INC         A
        LD          [svarb_on_interval_exec], A
        LD          HL, [svari_on_interval_value]
        LD          [svari_on_interval_counter], HL
_end_of_interval:
        LD          HL, svarf_on_strig0_mode
        LD          BC, 0x0500
_on_strig_loop2:
        LD          A, [HL]
        INC         HL
        OR          A, A
        JR          Z, _skip_strig2
        LD          A, [HL]
        INC         HL
        LD          [HL], A
        DEC         HL
        LD          A, C
        PUSH        BC
        CALL        bios_gttrig
        POP         BC
        LD          [HL], A
_skip_strig2:
        INC         HL
        INC         HL
        INC         HL
        INC         C
        DJNZ        _on_strig_loop2
_end_of_strig:
        DI          
        IN          A, [0xAA]
        AND         A, 0xF0
        OR          A, 6
        LD          B, A
        OUT         [0xAA], A
        IN          A, [0xA9]
        OR          A, 0x1E
        RRCA        
        LD          C, A
        LD          A, B
        INC         A
        OUT         [0xAA], A
        IN          A, [0xA9]
        OR          A, 0xFC
        AND         A, C
        LD          C, A
        LD          HL, svarf_on_key06_mode
        LD          B, 0x90
        CALL        _on_key_sub
        LD          HL, svarf_on_key07_mode
        LD          B, 0xA0
        CALL        _on_key_sub
        LD          HL, svarf_on_key08_mode
        LD          B, 0xC0
        CALL        _on_key_sub
        LD          HL, svarf_on_key09_mode
        LD          B, 0x81
        CALL        _on_key_sub
        LD          HL, svarf_on_key10_mode
        LD          B, 0x82
        CALL        _on_key_sub
        LD          A, C
        XOR         A, 0x80
        LD          C, A
        LD          HL, svarf_on_key01_mode
        LD          B, 0x90
        CALL        _on_key_sub
        LD          HL, svarf_on_key02_mode
        LD          B, 0xA0
        CALL        _on_key_sub
        LD          HL, svarf_on_key03_mode
        LD          B, 0xC0
        CALL        _on_key_sub
        LD          HL, svarf_on_key04_mode
        LD          B, 0x81
        CALL        _on_key_sub
        LD          HL, svarf_on_key05_mode
        LD          B, 0x82
        CALL        _on_key_sub
        POP         AF
        JP          h_timi_backup
_on_key_sub:
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
restore_h_timi:
        DI          
        LD          HL, h_timi_backup
        LD          DE, work_h_timi
        LD          BC, 5
        LDIR        
        EI          
        RET         
restore_h_erro:
        DI          
        LD          HL, h_erro_backup
        LD          DE, work_h_erro
        LD          BC, 5
        LDIR        
        EI          
_code_ret:
        RET         
h_erro_handler:
        PUSH        DE
        CALL        restore_h_timi
        CALL        restore_h_erro
        POP         DE
        JP          work_h_erro
str_0:
        DEFB        0x00
str_1:
        DEFB        0x01, 0x41
str_2:
        DEFB        0x02, 0x0D, 0x0A
save_stack:
        DEFW        0
heap_next:
        DEFW        0
heap_end:
        DEFW        0
heap_move_size:
        DEFW        0
heap_remap_address:
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
var_area_end:
vars_area_start:
vars_area_end:
vara_area_start:
varia_M:
        DEFW        0
varia_M0:
        DEFW        0
vara_area_end:
varsa_area_start:
varsa_area_end:
h_timi_backup:
        DEFB        0, 0, 0, 0, 0
h_erro_backup:
        DEFB        0, 0, 0, 0, 0
heap_start:
end_address:
