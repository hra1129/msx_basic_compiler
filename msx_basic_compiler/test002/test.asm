; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
bios_chgmod                     = 0x0005F
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0x8010
start_address:
        LD          [save_stack], SP
        LD          DE, program_start
        JP          program_run
program_start:
        LD          HL, 1
        LD          A, L
        CALL        bios_chgmod
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
        LD          HL, str_3
        CALL        puts
        JP          program_termination
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
puts:
        LD          B, [HL]
_puts_loop:
        INC         HL
        LD          A, [HL]
        RST         0x18
        DJNZ        _puts_loop
        RET
free_string:
        PUSH        HL
        LD          E, [HL]
        LD          D, 0
        ADD         HL, DE
        INC         HL
        INC         DE
        SBC         HL, DE
        POP         HL
        RET
        LD          [heap_next], HL
        RET
str_0:
        DEFB        0x0D, 0x48, 0x45, 0x4C, 0x4C, 0x4F, 0x2C, 0x20, 0x57, 0x4F, 0x52, 0x4C, 0x44, 0x21
str_1:
        DEFB        0x02, 0x0D, 0x0A
str_2:
        DEFB        0x13, 0x54, 0x68, 0x69, 0x73, 0x20, 0x69, 0x73, 0x20, 0x4D, 0x53, 0x58, 0x2D, 0x42, 0x41, 0x43, 0x4F, 0x4E, 0x21, 0x21
str_3:
        DEFB        0x02, 0x0D, 0x0A
save_stack:
        DEFW        0
heap_next:
        DEFW        0
heap_end:
        DEFW        0
heap_start:
end_address:
