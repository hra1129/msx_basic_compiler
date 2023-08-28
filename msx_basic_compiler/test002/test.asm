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
blib_iotget_int                 = 0x0401b
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
blib_iotget_str                 = 0x0401e
bios_errhand                    = 0x0406F
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
        LD          HL, str_0
        PUSH        HL
        LD          HL, vari_L
        EX          [SP], HL
        LD          ix, blib_iotget_int
        CALL        call_blib
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_L]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
        LD          HL, str_3
        PUSH        HL
        LD          HL, vari_B
        EX          [SP], HL
        LD          ix, blib_iotget_int
        CALL        call_blib
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vari_B]
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts
        LD          A, 32
        RST         0x18
        LD          HL, str_2
        CALL        puts
        LD          HL, str_4
        PUSH        HL
        LD          HL, vars_IP
        EX          [SP], HL
        LD          ix, blib_iotget_str
        CALL        call_blib
        CALL        copy_string
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, [vars_IP]
        CALL        copy_string
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
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
allocate_string:
        LD          HL, [heap_next]
        PUSH        HL
        LD          E, A
        LD          D, 0
        ADD         HL, DE
        INC         HL
        LD          DE, [heap_end]
        RST         0x20
        JR          NC, _allocate_string_error
        LD          [heap_next], HL
        POP         HL
        LD          [HL], A
        RET         
_allocate_string_error:
        LD          E, 7
        JP          bios_errhand
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
str_0:
        DEFB        0x12, 0x68, 0x6F, 0x73, 0x74, 0x2F, 0x62, 0x61, 0x74, 0x74, 0x65, 0x72, 0x79, 0x2F, 0x6C, 0x65, 0x76, 0x65, 0x6C
str_1:
        DEFB        0x10, 0x42, 0x61, 0x74, 0x74, 0x65, 0x72, 0x79, 0x20, 0x6C, 0x65, 0x76, 0x65, 0x6C, 0x20, 0x20, 0x3A
str_2:
        DEFB        0x02, 0x0D, 0x0A
str_3:
        DEFB        0x0F, 0x63, 0x6F, 0x6E, 0x66, 0x2F, 0x62, 0x72, 0x69, 0x67, 0x68, 0x74, 0x6E, 0x65, 0x73, 0x73
str_4:
        DEFB        0x07, 0x68, 0x6F, 0x73, 0x74, 0x2F, 0x69, 0x70
str_5:
        DEFB        0x10, 0x48, 0x6F, 0x73, 0x74, 0x20, 0x49, 0x50, 0x20, 0x61, 0x64, 0x64, 0x72, 0x65, 0x73, 0x73, 0x3A
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
vari_B:
        DEFW        0
vari_L:
        DEFW        0
var_area_end:
vars_area_start:
vars_IP:
        DEFW        0
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
