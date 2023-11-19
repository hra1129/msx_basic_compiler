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
bios_errhand                    = 0x0406F
bios_qinlin                     = 0x00B4
bios_fin                        = 0x3299
bios_frcint                     = 0x2f8a
bios_frcsng                     = 0x2fb2
bios_frcdbl                     = 0x303a
work_dac                        = 0xf7f6
work_valtyp                     = 0xf663
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
line_100:
        CALL        interrupt_process
; INPUT "message1";A,B
line_110:
        CALL        interrupt_process
; PRINT "A=";A
line_120:
        CALL        interrupt_process
; PRINT "B=";B
line_130:
        CALL        interrupt_process
        LD          HL, str_1
        CALL        puts
        LD          HL, vars_B
        PUSH        HL
        LD          HL, vars_A
        PUSH        HL
        CALL        sub_input
        DEFB        3, 3, 0
line_140:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vars_A]
        CALL        copy_string
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_3
        CALL        puts
line_150:
        CALL        interrupt_process
        XOR         A, A
        LD          [work_prtflg], A
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vars_B]
        CALL        copy_string
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_3
        CALL        puts
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
allocate_string:
        LD          HL, [heap_next]
        PUSH        HL
        LD          E, A
        LD          C, A
        LD          D, 0
        ADD         HL, DE
        INC         HL
        LD          DE, [heap_end]
        RST         0x20
        JR          NC, _allocate_string_error
        LD          [heap_next], HL
        POP         HL
        LD          [HL], C
        RET         
_allocate_string_error:
        LD          E, 7
        JP          bios_errhand
sub_input:
        CALL        bios_qinlin
        INC         hl
_sub_input_string_loop:
        EX          de, hl
        POP         hl
        LD          a, [hl]
        CP          a, 3
        JR          Z, _sub_input_string
_sub_input_number:
        EX          de, hl
        PUSH        de
        LD          a, [hl]
        CALL        bios_fin
        LD          a, d
        OR          a, a
        JP          Z, _sub_input_redo_from_start
        CALL        _sub_input_skip_white
        LD          a, [hl]
        OR          a, a
        JR          Z, _sub_input_number_branch
        CP          a, ','
        JR          Z, _sub_input_number_branch
        JP          _sub_input_redo_from_start
_sub_input_number_branch:
        POP         de
        LD          a, [de]
        INC         de
        CP          a, 4
        PUSH        de
        PUSH        hl
        JP          Z, _sub_input_single_real
        JR          NC, _sub_input_double_real
        CALL        bios_frcint
        POP         de
        POP         bc
        POP         hl
        PUSH        bc
        PUSH        de
        LD          de, [work_dac + 2]
        LD          [hl], e
        INC         hl
        LD          [hl], d
        POP         hl
        JR          _check_next_data
_sub_input_single_real:
        CALL        bios_frcsng
        POP         hl
        POP         bc
        POP         de
        PUSH        bc
        PUSH        hl
        LD          hl, work_dac
        LD          bc, 4
        LDIR        
        POP         hl
        JR          _check_next_data
_sub_input_double_real:
        CALL        bios_frcdbl
        POP         hl
        POP         bc
        POP         de
        PUSH        bc
        PUSH        hl
        LD          hl, work_dac
        LD          bc, 8
        LDIR        
        POP         hl
        JR          _check_next_data
_sub_input_string:
        INC         hl
        POP         bc
        PUSH        hl
        EX          de, hl
        CALL        _sub_input_skip_white
        LD          a, [hl]
        CP          a, '"'
        JR          Z, _get_quote_string
_get_normal_string:
        PUSH        bc
        LD          e, l
        LD          d, h
        LD          c, 0
_get_normal_string_loop:
        LD          a, [hl]
        OR          a, a
        JR          Z, _get_string_loop_exit
        CP          a, ','
        JR          Z, _get_string_loop_exit
        INC         hl
        INC         c
        JR          _get_normal_string_loop
_get_quote_string:
        PUSH        bc
        INC         hl
        LD          e, l
        LD          d, h
        LD          c, 0
_get_quote_string_loop:
        LD          a, [hl]
        OR          a, a
        JR          Z, _get_string_loop_exit
        CP          a, '"'
        INC         hl
        JR          Z, _get_string_loop_exit
        INC         c
        JR          _get_quote_string_loop
_get_string_loop_exit:
        LD          a, c
        OR          a, a
        JR          Z, _get_quote_string_zero
        PUSH        de
        CALL        allocate_string
        POP         de
        LD          b, 0
        PUSH        hl
        INC         hl
        EX          de, hl
        LDIR        
        POP         bc
        JR          _sub_input_copy_string
_get_quote_string_zero:
        LD          bc, str_0
_sub_input_copy_string:
        POP         de
        EX          de, hl
        LD          [hl], c
        INC         hl
        LD          [hl], b
        EX          de, hl
_check_next_data:
        LD          a, [hl]
        CP          a, '"'
        JR          NZ, _check_next_data2
        INC         hl
_check_next_data2:
        CALL        _sub_input_skip_white
        LD          a, [hl]
        OR          a, a
        JR          Z, _check_next_parameter
        POP         de
        PUSH        de
        LD          a, [de]
        OR          a, a
        JR          Z, _sub_input_extra_ignored
        INC         hl
        JP          _sub_input_string_loop
_check_next_parameter:
        POP         hl
        PUSH        hl
        LD          a, [hl]
        OR          a, a
        RET         Z
_sub_input_retype:
        LD          a, '?'
        RST         0x18
        JP          sub_input
_sub_input_redo_from_start:
        PUSH        hl
        LD          hl, _str_redo_from_start
        CALL        puts
        POP         hl
        JR          _sub_input_retype
_str_redo_from_start:
        DEFB        18
        DEFB        "?Redo from start"
        DEFB        13, 10
_sub_input_extra_ignored:
        LD          hl, _str_extra_ignored
        CALL        puts
        RET         
_str_extra_ignored:
        DEFB        16
        DEFB        "?Extra ignored"
        DEFB        13, 10
_sub_input_skip_white:
        LD          a, [hl]
        CP          a, ' '
        RET         NZ
        INC         hl
        JR          _sub_input_skip_white
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
copy_string:
        LD          A, [HL]
        PUSH        HL
        CALL        allocate_string
        POP         DE
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
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
        LD          HL, str_0
        LD          [vars_area_start], HL
        LD          HL, vars_area_start
        LD          DE, vars_area_start + 2
        LD          BC, vars_area_end - vars_area_start - 2
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
        DEFB        0x08, 0x6D, 0x65, 0x73, 0x73, 0x61, 0x67, 0x65, 0x32
str_2:
        DEFB        0x04, 0x41, 0x24, 0x3D, 0x5B
str_3:
        DEFB        0x02, 0x0D, 0x0A
str_4:
        DEFB        0x01, 0x5D
str_5:
        DEFB        0x04, 0x42, 0x24, 0x3D, 0x5B
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
vars_A:
        DEFW        0
vars_B:
        DEFW        0
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
h_timi_backup:
        DEFB        0, 0, 0, 0, 0
h_erro_backup:
        DEFB        0, 0, 0, 0, 0
heap_start:
end_address:
