; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
bios_chgmod                     = 0x0005F
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
work_jiffy                      = 0x0fc9e
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
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
        LD          DE, program_start
        JP          program_run
program_start:
        LD          HL, 1
        LD          A, L
        CALL        bios_chgmod
        LD          HL, 15
        LD          A, L
        LD          [work_forclr], A
        LD          HL, 0
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 0
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
        LD          HL, vari_X
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_Z
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 0
        LD          [work_jiffy], HL
line_120:
        LD          HL, str_0
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_X]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_1
        CALL        puts
line_130:
        LD          HL, vari_Z
        PUSH        HL
        LD          HL, [vari_Z]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [vari_Z]
        PUSH        HL
        LD          HL, 100
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JR          NC, _pt2
        DEC         A
_pt2:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt1
        JP          line_130
_pt1:
        LD          HL, vari_Z
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
_pt0:
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [vari_Y]
        PUSH        HL
        LD          HL, 100
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JR          NC, _pt5
        DEC         A
_pt5:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt4
        JP          line_130
_pt4:
        LD          HL, vari_Y
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
_pt3:
        LD          HL, vari_X
        PUSH        HL
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [vari_X]
        PUSH        HL
        LD          HL, 10
        POP         DE
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JR          NC, _pt8
        DEC         A
_pt8:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _pt7
        JP          line_120
_pt7:
_pt6:
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [work_jiffy]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_1
        CALL        puts
program_termination:
        LD          SP, [save_stack]
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
        LD          E, L
        LD          D, H
        ADD         HL, BC
        EX          DE, HL
        PUSH        HL
        LD          HL, [heap_next]
        OR          A, A
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          [heap_move_size], BC
        LD          [heap_remap_address], HL
        LD          [heap_next], DE
        LD          A, B
        OR          A, C
        JR          Z, _free_heap_loop1
        LDIR        
        LD          [heap_next], DE
_free_heap_loop1:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [heap_remap_address]
        EX          DE, HL
        RST         0x20
        JR          C, _free_heap_loop1_next
        LD          HL, [heap_move_size]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_free_heap_loop1_next:
        POP         HL
        INC         HL
        LD          DE, varsa_area_end
        RST         0x20
        JR          C, _free_heap_loop1
        RET         
str:
        CALL        bios_fout
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
str_0:
        DEFB        0x02, 0x58, 0x3D
str_1:
        DEFB        0x02, 0x0D, 0x0A
str_2:
        DEFB        0x08, 0x43, 0x4F, 0x4D, 0x50, 0x4C, 0x45, 0x54, 0x45
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
vari_X:
        DEFW        0
vari_Y:
        DEFW        0
vari_Z:
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
