; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
bios_chgmod                     = 0x0005F
bios_fout                       = 0x03425
work_dac_int                    = 0x0f7f8
work_valtyp                     = 0x0f663
work_dac                        = 0x0f7f6
bios_imult                      = 0x03193
work_arg                        = 0x0f847
bios_frcint                     = 0x02f8a
bios_fcomp                      = 0x02f21
bios_decsub                     = 0x0268c
work_jiffy                      = 0x0fc9e
bios_rdvrm                      = 0x004A
bios_gtstck                     = 0x00d5
bios_gttrig                     = 0x00d8
bios_wrtvrm                     = 0x004d
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
        JP          line_120
line_120:
        LD          HL, str_2
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        JP          line_130
line_130:
        LD          HL, str_3
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 12345
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        JP          line_140
line_140:
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_41123456
        CALL        ld_dac_single_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        JP          line_150
line_150:
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_42120000
        CALL        ld_dac_single_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        JP          line_160
line_160:
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_40120000
        CALL        ld_dac_single_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        JP          line_170
line_170:
        LD          HL, str_4
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_42230000
        CALL        ld_dac_single_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_4112345678901234
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_4212345678901234
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_4012345678901234
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, str_5
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_4312345678901234
        CALL        ld_dac_double_real
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_7
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_8
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 123
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_6
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 123
        PUSH        HL
        LD          HL, 345
        PUSH        HL
        LD          HL, 2
        POP         DE
        CALL        bios_imult
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 1
        POP         DE
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_9
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 1
        PUSH        HL
        LD          HL, 2
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, 3
        POP         DE
        ADD         HL, DE
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts_num_str
        LD          HL, str_10
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_11
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 10
        CALL        spc
        LD          HL, str_12
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, str_1
        CALL        puts
        LD          HL, str_13
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_45500000
        CALL        convert_to_integer_from_sngle_real
        LD          A, [HL]
        LD          L, A
        LD          H, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, 12345
        LD          [work_jiffy], HL
        LD          HL, str_14
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, const_45400000
        CALL        convert_to_integer_from_sngle_real
        CALL        bios_rdvrm
        LD          L, A
        LD          H, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, str_15
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 0
        LD          A, L
        CALL        bios_gtstck
        LD          L, A
        LD          H, 0
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts_num_str
        LD          HL, str_16
        PUSH        HL
        CALL        puts
        POP         HL
        CALL        free_string
        LD          HL, 0
        LD          A, L
        CALL        bios_gttrig
        LD          L, A
        LD          H, A
        LD          [work_dac_int], HL
        LD          A, 2
        LD          [work_valtyp], A
        CALL        str
        CALL        puts_num_str
        LD          HL, str_1
        CALL        puts
        LD          HL, 6144
        PUSH        HL
        LD          HL, 33
        LD          A, L
        POP         HL
        CALL        bios_wrtvrm
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
puts_num_str:
        LD          A, 32
        RST         0x18
        CALL        puts
        LD          A, 32
        RST         0x18
        RET
str:
        CALL        bios_fout
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
ld_dac_single_real:
        LD          DE, work_dac
        LD          BC, 4
        LDIR
        LD          [work_dac+4], BC
        LD          [work_dac+6], BC
        RET
ld_dac_double_real:
        LD          DE, work_dac
        LD          BC, 8
        LDIR
        LD          A, 8
        LD          [work_valtyp], A
        RET
spc:
        LD          B, L
        LD          A, 32
_spc_loop:
        INC         HL
        RST         0x18
        DJNZ        _spc_loop
        RET
ld_arg_single_real:
        LD          DE, work_arg
        LD          BC, 4
        LDIR
        LD          [work_arg+4], BC
        LD          [work_arg+6], BC
        LD          A, 8
        LD          [work_valtyp], A
        RET
convert_to_integer:
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        RET
convert_to_integer_from_sngle_real:
        CALL        ld_dac_single_real
        LD          BC, 0x3245
        LD          DE, 0x8076
        CALL        bios_fcomp
        INC         A
        JR          Z, convert_to_integer
        LD          HL, const_45327680
        CALL        ld_arg_single_real
        CALL        bios_decsub
        CALL        bios_frcint
        LD          HL, [work_dac_int]
        LD          A, H
        XOR         A, 0x80
        LD          H, A
        RET
const_40120000:
        DEFB        0x40, 0x12, 0x00, 0x00
const_41123456:
        DEFB        0x41, 0x12, 0x34, 0x56
const_42120000:
        DEFB        0x42, 0x12, 0x00, 0x00
const_42230000:
        DEFB        0x42, 0x23, 0x00, 0x00
const_45327680:
        DEFB        0x45, 0x32, 0x76, 0xFFFFFF80
const_45400000:
        DEFB        0x45, 0x40, 0x00, 0x00
const_45500000:
        DEFB        0x45, 0x50, 0x00, 0x00
const_4012345678901234:
        DEFB        0x40, 0x12, 0x34, 0x56, 0x78, 0xFFFFFF90, 0x12, 0x34
const_4112345678901234:
        DEFB        0x41, 0x12, 0x34, 0x56, 0x78, 0xFFFFFF90, 0x12, 0x34
const_4212345678901234:
        DEFB        0x42, 0x12, 0x34, 0x56, 0x78, 0xFFFFFF90, 0x12, 0x34
const_4312345678901234:
        DEFB        0x43, 0x12, 0x34, 0x56, 0x78, 0xFFFFFF90, 0x12, 0x34
str_0:
        DEFB        0x0D, 0x48, 0x45, 0x4C, 0x4C, 0x4F, 0x2C, 0x20, 0x57, 0x4F, 0x52, 0x4C, 0x44, 0x21
str_1:
        DEFB        0x02, 0x0D, 0x0A
str_10:
        DEFB        0x02, 0x3E, 0x3E
str_11:
        DEFB        0x01, 0x5B
str_12:
        DEFB        0x01, 0x5D
str_13:
        DEFB        0x0C, 0x50, 0x45, 0x45, 0x4B, 0x28, 0x35, 0x30, 0x30, 0x30, 0x30, 0x29, 0x3D
str_14:
        DEFB        0x0D, 0x56, 0x50, 0x45, 0x45, 0x4B, 0x28, 0x34, 0x30, 0x30, 0x30, 0x30, 0x29, 0x3D
str_15:
        DEFB        0x09, 0x53, 0x54, 0x49, 0x43, 0x4B, 0x28, 0x30, 0x29, 0x3D
str_16:
        DEFB        0x09, 0x53, 0x54, 0x52, 0x49, 0x47, 0x28, 0x30, 0x29, 0x3D
str_2:
        DEFB        0x13, 0x54, 0x68, 0x69, 0x73, 0x20, 0x69, 0x73, 0x20, 0x4D, 0x53, 0x58, 0x2D, 0x42, 0x41, 0x43, 0x4F, 0x4E, 0x21, 0x21
str_3:
        DEFB        0x0A, 0x49, 0x4E, 0x54, 0x45, 0x47, 0x45, 0x52, 0x20, 0x3D, 0x20
str_4:
        DEFB        0x0A, 0x53, 0x49, 0x4E, 0x47, 0x4C, 0x45, 0x20, 0x20, 0x3D, 0x20
str_5:
        DEFB        0x0A, 0x44, 0x4F, 0x55, 0x42, 0x4C, 0x45, 0x20, 0x20, 0x3D, 0x20
str_6:
        DEFB        0x0A, 0x53, 0x54, 0x52, 0x49, 0x4E, 0x47, 0x20, 0x20, 0x3D, 0x20
str_7:
        DEFB        0x0B, 0x4D, 0x6F, 0x6A, 0x69, 0x4D, 0x6F, 0x6A, 0x69, 0x4B, 0x75, 0x6E
str_8:
        DEFB        0x0C, 0x4B, 0x61, 0x69, 0x67, 0x79, 0x6F, 0x2D, 0x4E, 0x61, 0x73, 0x68, 0x69
str_9:
        DEFB        0x0C, 0x49, 0x4E, 0x54, 0x45, 0x47, 0x45, 0x52, 0x20, 0x3D, 0x20, 0x3C, 0x3C
save_stack:
        DEFW        0
heap_next:
        DEFW        0
heap_end:
        DEFW        0
heap_start:
end_address:
