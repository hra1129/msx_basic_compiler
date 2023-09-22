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
bios_errhand_redim              = 0x0405e
bios_umult                      = 0x0314a
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
jp_hl:
        JP          HL
program_start:
        LD          HL, [varia_A]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 10
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varia_A], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        LD          HL, [varia_A]
        LD          A, L
        OR          A, H
        JP          NZ, bios_errhand_redim
        LD          HL, 11
        INC         HL
        PUSH        HL
        ADD         HL, HL
        LD          DE, 5
        ADD         HL, DE
        PUSH        HL
        LD          C, L
        LD          B, H
        CALL        allocate_heap
        LD          [varia_A], HL
        POP         BC
        DEC         BC
        DEC         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
        INC         HL
        LD          B, 1
        LD          [HL], B
        INC         HL
        POP         BC
        LD          [HL], C
        INC         HL
        LD          [HL], B
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
        LD          [HL], 0
        LDIR        
        POP         HL
        RET         
_allocate_heap_error:
        LD          E, 7
        JP          bios_errhand
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
varia_A:
        DEFW        0
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
