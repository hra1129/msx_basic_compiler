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
bios_posit                      = 0x000C6
work_csry                       = 0x0F3DC
work_csrx                       = 0x0F3DD
work_csrsw                      = 0x0FCA9
blib_rdvdp                      = 0x04039
blib_wrvdp                      = 0x04036
bios_gttrig                     = 0x00d8
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
jp_hl:
        JP          HL
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
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, 10
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 10
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        LD          HL, str_3
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
line_130:
        LD          HL, 24
        PUSH        HL
        LD          HL, 24
        LD          A, L
        LD          IX, blib_rdvdp
        CALL        call_blib
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 255
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          B, L
        POP         HL
        LD          A, L
        LD          IX, blib_wrvdp
        CALL        call_blib
        LD          HL, 0
        LD          A, L
        CALL        bios_gttrig
        LD          L, A
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _pt1
        JP          program_termination
        JP          _pt0
_pt1:
        JP          line_130
_pt0:
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
        LD          [heap_remap_address], HL
        LD          [heap_move_size], BC
        EX          DE, HL
        LD          HL, [heap_next]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         DE
        LD          HL, [heap_remap_address]
        LD          A, C
        OR          A, B
        JR          Z, _free_heap_loop0
        LDIR        
_free_heap_loop0:
        LD          [heap_next], DE
        LD          HL, vars_area_start
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
        EX          DE, HL
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
        LD          DE, varsa_area_end
        RST         0x20
        JR          C, _free_heap_loop1
        RET         
str_0:
        DEFB        0x0B, 0x53, 0x43, 0x52, 0x4F, 0x4C, 0x4C, 0x20, 0x54, 0x45, 0x53, 0x54
str_1:
        DEFB        0x02, 0x0D, 0x0A
str_2:
        DEFB        0x0A, 0x20, 0x48, 0x4F, 0x47, 0x45, 0x20, 0x48, 0x4F, 0x47, 0x45
str_3:
        DEFB        0x09, 0x53, 0x43, 0x52, 0x4F, 0x4C, 0x4C, 0x49, 0x4E, 0x47
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
