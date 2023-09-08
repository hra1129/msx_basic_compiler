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
work_dac                        = 0x0f7f6
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
bios_frcdbl                     = 0x0303a
bios_vmovfm                     = 0x02f08
bios_atn                        = 0x02A14
bios_decmul                     = 0x027e6
work_arg                        = 0x0f847
bios_maf                        = 0x02c4d
bios_decdiv                     = 0x0289f
bios_cos                        = 0x02993
bios_decadd                     = 0x0269a
bios_sin                        = 0x029AC
bios_frcint                     = 0x02f8a
bios_posit                      = 0x000C6
work_csry                       = 0x0F3DC
work_csrx                       = 0x0F3DD
work_csrsw                      = 0x0FCA9
bios_errhand                    = 0x0406F
bios_vmovam                     = 0x02eef
bios_xdcomp                     = 0x02f5c
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
        LD          HL, vard_R
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vard_PI
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcdbl
        CALL        bios_atn
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 8
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        CALL        ld_arg_double_real
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vars_C
        PUSH        HL
        LD          HL, str_0
        POP         DE
        EX          DE, HL
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        free_string
        LD          HL, vard_XB
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vard_YB
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
line_120:
        LD          HL, vard_X
        PUSH        HL
        LD          HL, 15
        PUSH        HL
        LD          HL, vard_R
        CALL        push_double_real_hl
        LD          HL, vard_PI
        CALL        ld_arg_double_real
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 64
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decdiv
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_cos
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 10
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        CALL        ld_arg_double_real
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        ld_arg_double_real
        POP         HL
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decadd
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vard_Y
        PUSH        HL
        LD          HL, 15
        PUSH        HL
        LD          HL, vard_R
        CALL        push_double_real_hl
        LD          HL, vard_PI
        CALL        ld_arg_double_real
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 64
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decdiv
        LD          HL, work_dac
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_vmovfm
        CALL        bios_sin
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 5
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        CALL        ld_arg_double_real
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        CALL        ld_arg_double_real
        POP         HL
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_decadd
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vard_R
        PUSH        HL
        LD          HL, vard_R
        CALL        push_double_real_hl
        LD          HL, 1
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        PUSH        HL
        LD          HL, 63
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vard_XB
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, vard_YB
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        LD          HL, str_1
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
        LD          HL, vard_X
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, vard_Y
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        bios_posit
        LD          HL, [vars_C]
        CALL        copy_string
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_2
        CALL        puts
        LD          HL, vard_I
        PUSH        HL
        LD          HL, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_END
        PUSH        HL
        LD          HL, 100
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        LD          HL, work_dac
        POP         DE
        CALL        ld_de_double_real
        LD          HL, svard_I_FOR_STEP
        PUSH        HL
        LD          HL, const_4110000000000000
        POP         DE
        CALL        ld_de_double_real
        LD          HL, _pt1
        LD          [svard_I_LABEL], HL
        JR          _pt0
_pt1:
        LD          A, 8
        LD          [work_valtyp], A
        LD          HL, vard_I
        CALL        bios_vmovfm
        LD          HL, svard_I_FOR_STEP
        CALL        bios_vmovam
        CALL        bios_decadd
        LD          HL, work_dac
        LD          DE, vard_I
        LD          BC, 8
        LDIR        
        LD          HL, svard_I_FOR_END
        CALL        bios_vmovam
        LD          A, [svard_I_FOR_STEP]
        RLCA        
        JR          C, _pt2
        CALL        bios_xdcomp
        DEC         A
        JR          NZ, _pt3
        RET         
_pt2:
        CALL        bios_xdcomp
        INC         A
        RET         Z
_pt3:
        POP         HL
_pt0:
        LD          HL, [svard_I_LABEL]
        CALL        jp_hl
        LD          HL, vard_XB
        PUSH        HL
        LD          HL, vard_X
        POP         DE
        CALL        ld_de_double_real
        LD          HL, vard_YB
        PUSH        HL
        LD          HL, vard_Y
        POP         DE
        CALL        ld_de_double_real
        JP          line_120
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
ld_de_double_real:
        LD          BC, 8
        LDIR        
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
ld_arg_double_real:
        LD          DE, work_arg
        LD          BC, 8
        LDIR        
        RET         
pop_double_real_dac:
        POP         BC
        POP         HL
        LD          [work_dac+6], HL
        POP         HL
        LD          [work_dac+4], HL
        POP         HL
        LD          [work_dac+2], HL
        POP         HL
        LD          [work_dac+0], HL
        PUSH        BC
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
const_4110000000000000:
        DEFB        0x41, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
str_0:
        DEFB        0x01, 0x31
str_1:
        DEFB        0x01, 0x20
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
svard_I_FOR_END:
        DEFW        0, 0, 0, 0
svard_I_FOR_STEP:
        DEFW        0, 0, 0, 0
svard_I_LABEL:
        DEFW        0
vard_I:
        DEFW        0, 0, 0, 0
vard_PI:
        DEFW        0, 0, 0, 0
vard_R:
        DEFW        0, 0, 0, 0
vard_X:
        DEFW        0, 0, 0, 0
vard_XB:
        DEFW        0, 0, 0, 0
vard_Y:
        DEFW        0, 0, 0, 0
vard_YB:
        DEFW        0, 0, 0, 0
var_area_end:
vars_area_start:
vars_C:
        DEFW        0
vars_area_end:
vara_area_start:
vara_area_end:
varsa_area_start:
varsa_area_end:
heap_start:
end_address:
