; ------------------------------------------------------------------------
; Compiled by MSX-BACON from an.bas
; ------------------------------------------------------------------------
; 
work_h_timi                     = 0x0fd9f
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
blib_iotget_int                 = 0x0401b
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
work_csrx                       = 0x0f3dd
work_linlen                     = 0x0f3b0
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
        LD          HL, work_h_timi
        LD          DE, h_timi_backup
        LD          BC, 5
        LDIR        
        DI          
        LD          HL, h_timi_handler
        LD          [work_h_timi + 1], HL
        LD          A, 0xC3
        LD          [work_h_timi], A
        EI          
        LD          DE, program_start
        JP          program_run
jp_hl:
        JP          HL
program_start:
line_100:
        CALL        interrupt_prcess
line_110:
        CALL        interrupt_prcess
        LD          HL, str_1
        PUSH        HL
        LD          HL, vari_A
        EX          [SP], HL
        LD          ix, blib_iotget_int
        CALL        call_blib
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        interrupt_prcess
        LD          HL, [vari_A]
        LD          [work_dac_int], HL
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
        JR          C, _pt0
        PUSH        HL
        LD          HL, str_2
        CALL        puts
        POP         HL
_pt0:
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
        CALL        interrupt_prcess
        JP          line_110
program_termination:
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
        RET         
interrupt_prcess:
        LD          HL, [svari_on_interval_line]
        LD          A, L
        OR          A, H
        JR          Z, _skip_on_interval
        LD          A, [svarb_on_interval_exec]
        DEC         A
        JR          NZ, _skip_on_interval
        LD          [svarb_on_interval_exec], A
        CALL        jp_hl
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
        RET         
interrupt_prcess_end:
h_timi_handler:
        PUSH        AF
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
        POP         AF
        JP          h_timi_backup
restore_h_timi:
        DI          
        LD          HL, h_timi_backup
        LD          DE, work_h_timi
        LD          BC, 5
        LDIR        
        EI          
        RET         
str_0:
        DEFB        0x00
str_1:
        DEFB        0x10, 0x64, 0x65, 0x76, 0x69, 0x63, 0x65, 0x2F, 0x61, 0x6E, 0x61, 0x6C, 0x6F, 0x67, 0x2F, 0x69, 0x6E
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
h_timi_backup:
        DEFB        0, 0, 0, 0, 0
var_area_start:
svarb_on_interval_exec:
        DEFB        0
svarb_on_interval_mode:
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
svari_on_interval_counter:
        DEFW        0
svari_on_interval_line:
        DEFW        0
svari_on_interval_value:
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
vari_A:
        DEFW        0
var_area_end:
vars_area_start:
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
