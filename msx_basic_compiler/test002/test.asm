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
bios_fin                        = 0x3299
bios_frcdbl                     = 0x303a
work_dac                        = 0x0f7f6
work_arg                        = 0x0f847
bios_decadd                     = 0x0269a
bios_fout                       = 0x03425
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
        LD          HL, 4
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 7
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
; VALの引数
        LD          HL, str_0
; VALの本体開始
        PUSH        HL
        INC         HL
        LD          A, [HL]
        CALL        bios_fin
        CALL        bios_frcdbl
        POP         HL
        CALL        free_string
        LD          HL, work_dac
; VALの本体終了
        CALL        push_double_real_hl
; VALの引数
        LD          HL, str_1
; VALの本体開始
        PUSH        HL
        INC         HL
        LD          A, [HL]
        CALL        bios_fin
        CALL        bios_frcdbl
        POP         HL
        CALL        free_string
        LD          HL, work_dac
; VALの本体終了
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        CALL        pop_double_real_arg
        CALL        bios_decadd
        LD          HL, work_dac
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
; VALの引数
        LD          HL, str_3
; VALの本体開始
        PUSH        HL
        INC         HL
        LD          A, [HL]
        CALL        bios_fin
        CALL        bios_frcdbl
        POP         HL
        CALL        free_string
        LD          HL, work_dac
; VALの本体終了
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
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
push_double_real_hl:
        POP         BC
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        DE
        PUSH        BC
        RET         
pop_double_real_arg:
        POP         BC
        POP         HL
        LD          [work_arg+6], HL
        POP         HL
        LD          [work_arg+4], HL
        POP         HL
        LD          [work_arg+2], HL
        POP         HL
        LD          [work_arg+0], HL
        PUSH        BC
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
ld_dac_double_real:
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        RET         
str_0:
        DEFB        0x03, 0x31, 0x32, 0x33
str_1:
        DEFB        0x06, 0x32, 0x33, 0x34, 0x2E, 0x35, 0x36
str_2:
        DEFB        0x02, 0x0D, 0x0A
str_3:
        DEFB        0x08, 0x31, 0x32, 0x33, 0x2E, 0x35, 0x36, 0x45, 0x32
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
var_area_end:
vars_area_start:
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
