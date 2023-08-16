        DEFB        0xFE
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          [save_stack], SP
program_start:
work_csry                       = 0x0f3dc
bios_chgmod                     = 0x0005F
        LD          HL, [work_csry]
        LD          H, 0
        LD          A, L
        CALL        bios_chgmod
program_termination:
        LD          SP, [save_stack]
        RET
save_stack:
        DEFW        0
end_address:
