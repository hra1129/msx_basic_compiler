        DEFB        0xFE
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          [save_stack], SP
program_start:
work_dac                        = 0x0f7f6
work_arg                        = 0x0f847
bios_xdcomp                     = 0x02f5c
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
bios_frcint                     = 0x02f8a
bios_chgmod                     = 0x0005F
        LD          HL, const_42100000
        CALL        push_single_real_hl
        LD          HL, const_43100000
        LD          DE, work_dac
        LD          BC, 4
        LDIR
        CALL        pop_single_real_arg
        LD          [work_dac+4], HL
        LD          [work_dac+6], HL
        CALL        bios_xdcomp
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          DE, work_dac
        LD          BC, 8
        LDIR
        LD          A, 8
        LD          [work_valtyp], A
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          A, L
        CALL        bios_chgmod
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
const_42100000:
        DEFB        0x42, 0x10, 0x00, 0x00
const_43100000:
        DEFB        0x43, 0x10, 0x00, 0x00
save_stack:
        DEFW        0
end_address:
