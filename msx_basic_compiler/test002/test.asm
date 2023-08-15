        DEFB        0xFE
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          [save_stack], SP
program_start:
bios_chgclr                     = 0x00062
work_forclr                     = 0x0F3E9
work_bakclr                     = 0x0F3EA
work_bdrclr                     = 0x0F3EB
bios_chgmod                     = 0x0005F
work_rg9sv                      = 0x0ffe8
bios_wrtvdp                     = 0x00047
work_dac                        = 0x0f7f6
work_arg                        = 0x0f847
bios_decadd                     = 0x0269a
bios_decsub                     = 0x0268c
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
bios_frcint                     = 0x02f8a
        LD          HL, 15
        LD          A, L
        LD          [work_forclr], A
        LD          HL, 12
        LD          A, L
        LD          [work_bakclr], A
        LD          HL, 3
        LD          A, L
        LD          [work_bdrclr], A
        CALL        bios_chgclr
        LD          HL, 1
        LD          A, L
        CALL        bios_chgmod
        LD          HL, 3
        LD          A, L
        AND         A, 3
        ADD         A, A
        ADD         A, A
        LD          L, A
        LD          A, [work_rg9sv]
        AND         A, 0xF3
        OR          A, L
        LD          B, A
        LD          C, 9
        CALL        bios_wrtvdp
        LD          HL, const_41100000
        CALL        push_single_real_hl
        LD          HL, const_41200000
        LD          DE, work_dac
        LD          BC, 4
        LDIR
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_decadd
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, const_41500000
        CALL        ld_arg_single_real
        CALL        pop_double_real_dac
        CALL        bios_decadd
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, const_41400000
        CALL        ld_arg_single_real
        CALL        pop_double_real_dac
        CALL        bios_decadd
        LD          HL, work_dac
        CALL        push_double_real_hl
        LD          HL, const_41100000
        CALL        ld_arg_single_real
        CALL        pop_double_real_dac
        CALL        bios_decsub
        LD          HL, work_dac
        LD          DE, work_dac
        LD          BC, 8
        LDIR
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          A, L
        LD          [work_forclr], A
        CALL        bios_chgclr
program_termination:
        LD          SP, [save_stack]
        RET
push_single_real_hl:
        POP         BC
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
pop_single_real_arg:
        POP         BC
        POP         HL
        LD          [work_arg+2], HL
        POP         HL
        LD          [work_arg+0], HL
        LD          HL, 0
        LD          [work_arg+4], HL
        LD          [work_arg+6], HL
        PUSH        BC
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
ld_arg_single_real:
        LD          DE, work_arg
        LD          BC, 4
        LDIR
        LD          [work_arg+4], BC
        LD          [work_arg+6], BC
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
const_41100000:
        DEFB        0x41, 0x10, 0x00, 0x00
const_41200000:
        DEFB        0x41, 0x20, 0x00, 0x00
const_41400000:
        DEFB        0x41, 0x40, 0x00, 0x00
const_41500000:
        DEFB        0x41, 0x50, 0x00, 0x00
save_stack:
        DEFW        0
end_address:
