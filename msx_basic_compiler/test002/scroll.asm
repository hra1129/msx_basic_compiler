; ------------------------------------------------------------------------
; Compiled by MSX-BACON from scroll.bas
; ------------------------------------------------------------------------
; 
bios_syntax_error               = 0x4055
bios_calslt                     = 0x001C
bios_enaslt                     = 0x0024
work_mainrom                    = 0xFCC1
work_blibslot                   = 0xF3D3
signature                       = 0x4010
bios_chgmod                     = 0x0005F
bios_erafnk                     = 0x000CC
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_vmovfm                     = 0x02f08
bios_rnd                        = 0x02bdf
bios_frcdbl                     = 0x0303a
bios_maf                        = 0x02c4d
work_dac_int                    = 0x0f7f8
bios_decmul                     = 0x027e6
bios_frcint                     = 0x02f8a
bios_imult                      = 0x03193
bios_wrtvrm                     = 0x004d
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
        CALL        bios_erafnk
        LD          HL, 15
        LD          A, L
        LD          [work_forclr], A
        LD          HL, 1
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 1
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
        LD          HL, vari_A
        PUSH        HL
        LD          HL, 6144
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_J
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_END
        PUSH        HL
        LD          HL, 31
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_J_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt1
        LD          [svari_J_LABEL], HL
        JR          _pt0
_pt1:
        LD          HL, [vari_J]
        LD          DE, [svari_J_FOR_STEP]
        ADD         HL, DE
        LD          [vari_J], HL
        LD          A, D
        LD          DE, [svari_J_FOR_END]
        RLCA        
        JR          C, _pt2
        RST         0x20
        JR          C, _pt3
        JR          Z, _pt3
        RET         NC
_pt2:
        RST         0x20
        RET         C
_pt3:
        POP         HL
_pt0:
        LD          HL, vari_C
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [work_valtyp], A
        LD          [work_dac + 2], HL
        CALL        bios_frcdbl
        CALL        bios_rnd
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, 15
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        bios_frcdbl
        CALL        bios_maf
        CALL        pop_double_real_dac
        CALL        bios_decmul
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_D
        PUSH        HL
        LD          HL, 128
        PUSH        HL
        LD          HL, [vari_J]
        PUSH        HL
        LD          HL, 1
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        PUSH        HL
        LD          HL, 32
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_I
        PUSH        HL
        LD          HL, 0
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_END
        PUSH        HL
        LD          HL, 23
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, svari_I_FOR_STEP
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, _pt5
        LD          [svari_I_LABEL], HL
        JR          _pt4
_pt5:
        LD          HL, [vari_I]
        LD          DE, [svari_I_FOR_STEP]
        ADD         HL, DE
        LD          [vari_I], HL
        LD          A, D
        LD          DE, [svari_I_FOR_END]
        RLCA        
        JR          C, _pt6
        RST         0x20
        JR          C, _pt7
        JR          Z, _pt7
        RET         NC
_pt6:
        RST         0x20
        RET         C
_pt7:
        POP         HL
_pt4:
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, [vari_C]
        PUSH        HL
        LD          HL, [vari_D]
        POP         DE
        ADD         HL, DE
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        LD          HL, vari_C
        PUSH        HL
        LD          HL, [vari_C]
        PUSH        HL
        LD          HL, 1
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 15
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, 32
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [svari_I_LABEL]
        CALL        jp_hl
        LD          HL, vari_A
        PUSH        HL
        LD          HL, [vari_A]
        PUSH        HL
        LD          HL, 767
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [svari_J_LABEL]
        CALL        jp_hl
        LD          HL, vari_H
        PUSH        HL
        LD          HL, 1024
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, vari_K
        PUSH        HL
        LD          HL, 1280
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
line_4:
        LD          HL, [vari_H]
        PUSH        HL
        LD          HL, 0
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        LD          HL, vari_H
        PUSH        HL
        LD          HL, [vari_H]
        PUSH        HL
        LD          HL, 3
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 3967
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [vari_H]
        PUSH        HL
        LD          HL, 1
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        LD          HL, [vari_K]
        PUSH        HL
        LD          HL, 0
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        LD          HL, vari_K
        PUSH        HL
        LD          HL, [vari_K]
        PUSH        HL
        LD          HL, 5
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 3967
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, [vari_K]
        PUSH        HL
        LD          HL, 1
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
        JP          line_4
program_termination:
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
str_0:
        DEFB        0x00
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
svari_I_FOR_END:
        DEFW        0
svari_I_FOR_STEP:
        DEFW        0
svari_I_LABEL:
        DEFW        0
svari_J_FOR_END:
        DEFW        0
svari_J_FOR_STEP:
        DEFW        0
svari_J_LABEL:
        DEFW        0
vari_A:
        DEFW        0
vari_C:
        DEFW        0
vari_D:
        DEFW        0
vari_H:
        DEFW        0
vari_I:
        DEFW        0
vari_J:
        DEFW        0
vari_K:
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
