; ------------------------------------------------------------------------
; Compiled by MSX-BACON from test.asc
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_MAXFIL                     = 0X0F85F
WORK_TXTTAB                     = 0X0F676
WORK_VARTAB                     = 0X0F6C2
WORK_USRTAB                     = 0X0F39A
BIOS_NEWSTT                     = 0X04601
FILE_INFO_SIZE                  = 37 + 3 * 16
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
WORK_GRPACX                     = 0XFCB7
WORK_GRPACY                     = 0XFCB9
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
WORK_RG1SV                      = 0X0F3E0
BIOS_WRTVDP                     = 0X00047
BIOS_ERAFNK                     = 0X000CC
BIOS_WRTPSG                     = 0X00093
BIOS_CLS                        = 0X000C3
BLIB_PUTSPRITE                  = 0X04045
BIOS_IMULT                      = 0X03193
BIOS_WRTVRM                     = 0X004D
BIOS_NWRVRM                     = 0X0177
WORK_SCRMOD                     = 0XFCAF
BIOS_IDIV                       = 0X031E6
BIOS_ICOMP                      = 0X02F4D
BIOS_GTTRIG                     = 0X00D8
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
BIOS_FRCSNG                     = 0X02FB2
WORK_JIFFY                      = 0X0FC9E
BIOS_VMOVFM                     = 0X02F08
BIOS_NEG                        = 0X02E8D
BIOS_RND                        = 0X02BDF
BIOS_FRCDBL                     = 0X0303A
BIOS_FRCINT                     = 0X02F8A
BLIB_FILE_PUTS                  = 0X040ED
WORK_PRTFLG                     = 0X0F416
WORK_PTRFIL                     = 0X0F864
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
BIOS_MAF                        = 0X02C4D
BIOS_DECMUL                     = 0X027E6
WORK_ARG                        = 0X0F847
BIOS_DECADD                     = 0X0269A
BIOS_GTSTCK                     = 0X00D5
BIOS_XDCOMP                     = 0X02F5C
BIOS_DECSUB                     = 0X0268C
BIOS_INT                        = 0X030CF
BIOS_RDVRM                      = 0X004A
BIOS_NRDVRM                     = 0X0174
BIOS_FOUT                       = 0X03425
BLIB_PUT_DIGITS                 = 0X040F6
BIOS_ERRHAND                    = 0X0406F
WORK_BUF                        = 0X0F55E
BIOS_FIN                        = 0X3299
BLIB_SETSPRITE                  = 0X04042
WORK_FILTAB                     = 0XF860
WORK_ERRFLG                     = 0X0F414
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0X8010
START_ADDRESS:
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        LD          HL, 0
        LD          [0X8001], HL
        LD          [0X8002], HL
        LD          HL, [WORK_USRTAB + 0]
        LD          [SVARI_USR0_BACKUP], HL
        LD          HL, HEAP_START
        LD          [WORK_VARTAB], HL
        LD          HL, _BASIC_START
        CALL        BIOS_NEWSTT
_BASIC_START_RET:
        LD          HL, [SVARI_USR0_BACKUP]
        LD          [WORK_USRTAB + 0], HL
        LD          A, 1
        LD          [WORK_MAXFIL], A
        LD          SP, [WORK_HIMEM]
        CALL        CHECK_BLIB
        JP          NZ, BIOS_SYNTAX_ERROR
        LD          IX, BLIB_INIT_NCALBAS
        CALL        CALL_BLIB
        LD          HL, WORK_H_TIMI
        LD          DE, H_TIMI_BACKUP
        LD          BC, 5
        LDIR        
        DI          
        CALL        SETUP_H_TIMI
        LD          DE, PROGRAM_START
        JP          PROGRAM_RUN
SETUP_H_TIMI:
        LD          HL, H_TIMI_HANDLER
        LD          [WORK_H_TIMI + 1], HL
        LD          A, 0XC3
        LD          [WORK_H_TIMI], A
        RET         
SETUP_H_ERRO:
        LD          HL, WORK_H_ERRO
        LD          DE, H_ERRO_BACKUP
        LD          BC, 5
        LDIR        
        LD          HL, H_ERRO_HANDLER
        LD          [WORK_H_ERRO + 1], HL
        LD          A, 0XC3
        LD          [WORK_H_ERRO], A
        RET         
JP_HL:
        JP          HL
_BASIC_START:
        DEFB        ':', 0xCD, 0xB7, 0xEF, 0x11, ':', 0x97, 0xDD, 0xEF, 0x0C
        DEFW        _BASIC_START_RET
        DEFB        ':', 'A', 0xEF, 0xDD, '(', 0x11, ')', 0x00
PROGRAM_START:
LINE_100:
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT0
        CALL        BIOS_CHGMOD
        JR          _PT1
_PT0:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT1:
        XOR         A, A
        AND         A, 3
        LD          L, A
        LD          A, [WORK_RG1SV]
        AND         A, 0XFC
        OR          A, L
        LD          B, A
        LD          C, 1
        CALL        BIOS_WRTVDP
        CALL        INTERRUPT_PROCESS
        CALL        BIOS_ERAFNK
        CALL        INTERRUPT_PROCESS
        LD          HL, 8
        LD          E, 0
        LD          A, L
        CALL        bios_wrtpsg
LINE_110:
        CALL        INTERRUPT_PROCESS
        CALL        LINE_1000
        CALL        INTERRUPT_PROCESS
        CALL        LINE_1090
LINE_115:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        CALL        BIOS_CLS
        CALL        INTERRUPT_PROCESS
        CALL        LINE_2000
LINE_120:
        CALL        INTERRUPT_PROCESS
        LD          HL, 128
        LD          [VARI_X], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 100
        LD          [VARI_Y], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          [VARI_CL], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_Z], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          [VARI_VX], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_CS], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 3
        LD          [VARI_PL], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 3
        LD          [VARI_EL], HL
LINE_130:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        PUSH        HL
        LD          HL, [VARI_X]
        PUSH        HL
        LD          HL, [VARI_Y]
        PUSH        HL
        LD          HL, 15
        LD          DE, 0
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_140:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_X
        PUSH        HL
        LD          HL, [VARI_X]
        LD          DE, [VARI_VX]
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_VX
        PUSH        HL
        LD          HL, [VARI_VX]
        PUSH        HL
        LD          HL, [VARI_X]
        EX          DE, HL
        LD          HL, 0
        EX          DE, HL
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT2
        DEC         A
_PT2:
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_X]
        EX          DE, HL
        LD          HL, 247
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT3
        DEC         A
_PT3:
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        OR          A, E
        LD          L, A
        LD          A, H
        OR          A, D
        LD          H, A
        EX          DE, HL
        LD          HL, 2
        CALL        BIOS_IMULT
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        CALL        BIOS_IMULT
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_150:
        CALL        INTERRUPT_PROCESS
        LD          HL, [62399]
        LD          DE, 16
        ADD         HL, DE
        PUSH        HL
        LD          HL, [VARI_CL]
        EX          DE, HL
        LD          HL, 16
        CALL        BIOS_IMULT
        LD          DE, 4
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT4
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT5
_PT4:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT5:
LINE_160:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_Z
        PUSH        HL
        LD          HL, [VARI_Z]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CL
        PUSH        HL
        LD          HL, [VARI_Z]
        EX          DE, HL
        LD          HL, 100
        CALL        BIOS_IDIV
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_Z]
        EX          DE, HL
        LD          HL, 1499
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT7
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_Z], HL
        JP          _PT6
_PT7:
_PT6:
LINE_170:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        POP         DE
        ADD         HL, DE
        EX          DE, HL
        LD          HL, -1
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT9
        JP          LINE_130
_PT9:
_PT8:
LINE_175:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_X
        PUSH        HL
        LD          HL, 64
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_Y
        PUSH        HL
        LD          HL, 40
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_X1
        PUSH        HL
        LD          HL, 192
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_Y1
        PUSH        HL
        LD          HL, 160
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_A
        PUSH        HL
        LD          HL, [WORK_JIFFY]
        EX          DE, HL
        LD          HL, 0
        OR          A, A
        SBC         HL, DE
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, LINE_960
        LD          [SVARI_ON_SPRITE_LINE], HL
        CALL        INTERRUPT_PROCESS
        LD          A, 1
        LD          [SVARB_ON_SPRITE_MODE], A
        CALL        INTERRUPT_PROCESS
        LD          HL, [62399]
        LD          DE, 16
        ADD         HL, DE
        PUSH        HL
        LD          HL, 244
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT10
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT11
_PT10:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT11:
LINE_180:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        CALL        BIOS_CLS
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, 2
        LD          [VARI_I], HL
        LD          HL, 21
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT13
        LD          [SVARI_I_LABEL], HL
        JR          _PT12
_PT13:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT14
        SBC         HL, DE
        JP          M, _PT15
        JR          Z, _PT15
        RET         
_PT14:
        CCF         
        SBC         HL, DE
        RET         M
_PT15:
        POP         HL
_PT12:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 9
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT17
        LD          [SVARI_I_LABEL], HL
        JR          _PT16
_PT17:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT18
        SBC         HL, DE
        JP          M, _PT19
        JR          Z, _PT19
        RET         
_PT18:
        CCF         
        SBC         HL, DE
        RET         M
_PT19:
        POP         HL
_PT16:
        CALL        INTERRUPT_PROCESS
        LD          HL, 2
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 20
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          H, L
        INC         H
        PUSH        HL
        LD          HL, 2
        PUSH        HL
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 20
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          HL, WORK_DAC
        CALL        LD_ARG_DOUBLE_REAL
        POP         HL
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, L
        INC         A
        POP         HL
        LD          L, A
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_190:
        CALL        INTERRUPT_PROCESS
        LD          HL, (1) | ((2) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_4
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, SVARI_I_FOR_END
        PUSH        HL
        LD          HL, [VARI_PL]
        EX          DE, HL
        LD          HL, 1
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT21
        LD          [SVARI_I_LABEL], HL
        JR          _PT20
_PT21:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT22
        SBC         HL, DE
        JP          M, _PT23
        JR          Z, _PT23
        RET         
_PT22:
        CCF         
        SBC         HL, DE
        RET         M
_PT23:
        POP         HL
_PT20:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_I]
        LD          DE, 8
        ADD         HL, DE
        LD          H, L
        INC         H
        LD          L, 1
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_5
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        LD          HL, (1) | ((17) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_6
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, SVARI_I_FOR_END
        PUSH        HL
        LD          HL, [VARI_EL]
        EX          DE, HL
        LD          HL, 1
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT25
        LD          [SVARI_I_LABEL], HL
        JR          _PT24
_PT25:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT26
        SBC         HL, DE
        JP          M, _PT27
        JR          Z, _PT27
        RET         
_PT26:
        CCF         
        SBC         HL, DE
        RET         M
_PT27:
        POP         HL
_PT24:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_I]
        LD          DE, 22
        ADD         HL, DE
        LD          H, L
        INC         H
        LD          L, 1
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_5
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        CALL        LINE_600
LINE_200:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_ST
        PUSH        HL
        XOR         A, A
        CALL        BIOS_GTSTCK
        LD          L, A
        LD          H, 0
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTSTCK
        LD          L, A
        LD          H, 0
        POP         DE
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_210:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_ST]
        EX          DE, HL
        LD          HL, 7
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_XX
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -8
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT29
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40050000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECSUB
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT28
_PT29:
_PT28:
LINE_220:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_ST]
        EX          DE, HL
        LD          HL, 3
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_XX
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 8
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT31
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40050000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT30
_PT31:
_PT30:
LINE_230:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_ST]
        EX          DE, HL
        LD          HL, 1
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_YY
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -8
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT33
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40050000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECSUB
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT32
_PT33:
_PT32:
LINE_240:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_ST]
        EX          DE, HL
        LD          HL, 5
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_YY
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 8
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT35
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40050000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT34
_PT35:
_PT34:
LINE_290:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_X
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_XX
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_Y
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_YY
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
LINE_300:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        PUSH        HL
        LD          HL, VARF_X
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, VARF_Y
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 15
        LD          DE, 0
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_305:
        CALL        INTERRUPT_PROCESS
        CALL        LINE_850
LINE_310:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_X
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_X1
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_XA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT37
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40020000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT36
_PT37:
_PT36:
LINE_320:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_X
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_X1
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_XA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT39
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40020000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECSUB
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT38
_PT39:
_PT38:
LINE_330:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_Y
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_Y1
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_YA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT41
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40020000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT40
_PT41:
_PT40:
LINE_340:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_Y
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_Y1
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, VARF_YA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -1
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT43
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_40020000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECSUB
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT42
_PT43:
_PT42:
LINE_350:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_X1
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_XA
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_Y1
        PUSH        HL
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, VARF_YA
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
LINE_360:
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        PUSH        HL
        LD          HL, VARF_X1
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, VARF_Y1
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 10
        LD          DE, 0
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
LINE_370:
        CALL        INTERRUPT_PROCESS
        CALL        LINE_900
LINE_380:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_CS]
        EX          DE, HL
        LD          HL, 0
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT46
        DEC         A
_PT46:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT45
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CS
        PUSH        HL
        LD          HL, [VARI_CS]
        EX          DE, HL
        LD          HL, 1
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        JP          _PT44
_PT45:
_PT44:
LINE_500:
        CALL        INTERRUPT_PROCESS
        JP          LINE_200
LINE_600:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_PL]
        EX          DE, HL
        LD          HL, 0
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT48
        CALL        INTERRUPT_PROCESS
        LD          HL, (11) | ((10) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_7
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        JP          LINE_610
        JP          _PT47
_PT48:
_PT47:
LINE_605:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_EL]
        EX          DE, HL
        LD          HL, 0
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT50
        CALL        INTERRUPT_PROCESS
        LD          HL, (11) | ((10) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_8
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        JP          LINE_610
        JP          _PT49
_PT50:
_PT49:
LINE_607:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_610:
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        PUSH        HL
        LD          A, 1
        CALL        BIOS_GTTRIG
        LD          L, A
        LD          H, A
        POP         DE
        ADD         HL, DE
        EX          DE, HL
        LD          HL, -1
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT52
        JP          LINE_610
_PT52:
        JP          LINE_115
_PT51:
LINE_850:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CR
        PUSH        HL
        LD          HL, [62397]
        PUSH        HL
        LD          HL, VARF_X
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        EX          DE, HL
        LD          HL, 8
        CALL        BIOS_IDIV
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, VARF_Y
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        EX          DE, HL
        LD          HL, 8
        CALL        BIOS_IDIV
        EX          DE, HL
        LD          HL, 32
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT53
        CALL        BIOS_RDVRM
        LD          L, A
        LD          H, 0
        JR          _PT54
_PT53:
        CALL        BIOS_NRDVRM
        LD          L, A
        LD          H, 0
_PT54:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_851:
        CALL        INTERRUPT_PROCESS
        LD          HL, (1) | ((1) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, [VARI_CR]
        CALL        PUT_INTEGER
        LD          HL, STR_1
        CALL        PUTS
LINE_868:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_CR]
        EX          DE, HL
        LD          HL, 32
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT56
        CALL        INTERRUPT_PROCESS
        JP          LINE_2500
        JP          _PT55
_PT56:
_PT55:
LINE_887:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_CR]
        EX          DE, HL
        LD          HL, 96
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_CS]
        EX          DE, HL
        LD          HL, 0
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT58
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        PUSH        HL
        LD          A, 4
        LD          [WORK_VALTYP], A
        CALL        BIOS_VMOVFM
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        PUSH        HL
        LD          A, 4
        LD          [WORK_VALTYP], A
        CALL        BIOS_VMOVFM
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, 20
        LD          [VARI_CS], HL
        CALL        INTERRUPT_PROCESS
        CALL        LINE_3110
        JP          _PT57
_PT58:
_PT57:
LINE_890:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_900:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_CR
        PUSH        HL
        LD          HL, [62397]
        PUSH        HL
        LD          HL, VARF_X1
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        EX          DE, HL
        LD          HL, 8
        CALL        BIOS_IDIV
        POP         DE
        ADD         HL, DE
        PUSH        HL
        LD          HL, VARF_Y1
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        EX          DE, HL
        LD          HL, 8
        CALL        BIOS_IDIV
        EX          DE, HL
        LD          HL, 32
        CALL        BIOS_IMULT
        POP         DE
        ADD         HL, DE
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT59
        CALL        BIOS_RDVRM
        LD          L, A
        LD          H, 0
        JR          _PT60
_PT59:
        CALL        BIOS_NRDVRM
        LD          L, A
        LD          H, 0
_PT60:
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
LINE_905:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_CR]
        EX          DE, HL
        LD          HL, 32
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT62
        CALL        INTERRUPT_PROCESS
        JP          LINE_2510
        JP          _PT61
_PT62:
_PT61:
LINE_910:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_CR]
        EX          DE, HL
        LD          HL, 96
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        PUSH        HL
        LD          HL, [VARI_CS]
        EX          DE, HL
        LD          HL, 0
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        POP         DE
        LD          A, L
        AND         A, E
        LD          L, A
        LD          A, H
        AND         A, D
        LD          H, A
        LD          A, L
        OR          A, H
        JP          Z, _PT64
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        LD          A, 4
        LD          [WORK_VALTYP], A
        CALL        BIOS_VMOVFM
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        LD          A, 4
        LD          [WORK_VALTYP], A
        CALL        BIOS_VMOVFM
        CALL        BIOS_NEG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, 20
        LD          [VARI_CS], HL
        CALL        INTERRUPT_PROCESS
        CALL        LINE_3110
        JP          _PT63
_PT64:
_PT63:
LINE_954:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_960:
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_CS]
        EX          DE, HL
        LD          HL, 0
        XOR         A, A
        SBC         HL, DE
        JP          P, _PT67
        DEC         A
_PT67:
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT66
        CALL        INTERRUPT_PROCESS
        RET         
        JP          _PT65
_PT66:
_PT65:
LINE_969:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_T
        PUSH        HL
        LD          HL, VARF_XA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_41120000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECMUL
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        LD          HL, VARF_XX
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_41120000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECMUL
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        EX          DE, HL
        LD          HL, VARF_T
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_T
        PUSH        HL
        LD          HL, VARF_YA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_41120000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECMUL
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        LD          HL, VARF_YY
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, CONST_41120000
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        CALL        POP_SINGLE_REAL_DAC
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        CALL        BIOS_DECMUL
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        EX          DE, HL
        LD          HL, VARF_T
        CALL        LD_DE_SINGLE_REAL
        CALL        INTERRUPT_PROCESS
        LD          HL, 20
        LD          [VARI_CS], HL
        CALL        INTERRUPT_PROCESS
        CALL        LINE_3310
LINE_979:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT69
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT68
_PT69:
_PT68:
LINE_980:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT71
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XA
        PUSH        HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT70
_PT71:
_PT70:
LINE_981:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT73
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT72
_PT73:
_PT72:
LINE_982:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT75
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YA
        PUSH        HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT74
_PT75:
_PT74:
LINE_983:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT77
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        PUSH        HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT76
_PT77:
_PT76:
LINE_991:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT79
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_XX
        PUSH        HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT78
_PT79:
_PT78:
LINE_995:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        DEC         A
        SRA         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT81
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        PUSH        HL
        LD          HL, 4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT80
_PT81:
_PT80:
LINE_997:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        CALL        PUSH_SINGLE_REAL_HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_SINGLE_REAL_DAC
        CALL        BIOS_XDCOMP
        SRA         A
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT83
        CALL        INTERRUPT_PROCESS
        LD          HL, VARF_YY
        PUSH        HL
        LD          HL, -4
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_SINGLE_REAL
        JP          _PT82
_PT83:
_PT82:
LINE_998:
        CALL        INTERRUPT_PROCESS
        RET         
LINE_999:
        CALL        INTERRUPT_PROCESS
        JP          program_termination
LINE_1000:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_J], HL
        LD          HL, 2
        LD          [SVARI_J_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_J_FOR_STEP], HL
        LD          HL, _PT85
        LD          [SVARI_J_LABEL], HL
        JR          _PT84
_PT85:
        LD          HL, [VARI_J]
        LD          DE, [SVARI_J_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_J], HL
        LD          A, D
        LD          DE, [SVARI_J_FOR_END]
        RLCA        
        JR          C, _PT86
        SBC         HL, DE
        JP          M, _PT87
        JR          Z, _PT87
        RET         
_PT86:
        CCF         
        SBC         HL, DE
        RET         M
_PT87:
        POP         HL
_PT84:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_D
        LD          DE, STR_0
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 7
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT89
        LD          [SVARI_I_LABEL], HL
        JR          _PT88
_PT89:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT90
        SBC         HL, DE
        JP          M, _PT91
        JR          Z, _PT91
        RET         
_PT90:
        CCF         
        SBC         HL, DE
        RET         M
_PT91:
        POP         HL
_PT88:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_A
        CALL        SUB_READ_STRING
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_D
        PUSH        HL
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          HL, STR_9
        PUSH        HL
        LD          HL, [VARS_A]
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, L
        POP         HL
        INC         HL
        LD          [HL], A
        DEC         HL
        POP         DE
        CALL        STR_ADD
        POP         DE
        EX          DE, HL
        LD          C, [HL]
        LD          [HL], E
        INC         HL
        LD          B, [HL]
        LD          [HL], D
        LD          L, C
        LD          H, B
        CALL        FREE_STRING
        CALL        INTERRUPT_PROCESS
        LD          HL, 128
        LD          DE, [VARI_J]
        ADD         HL, DE
        EX          DE, HL
        LD          HL, 8
        CALL        BIOS_IMULT
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_10
        PUSH        HL
        LD          HL, [VARS_A]
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT92
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT93
_PT92:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT93:
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        LD          HL, [VARI_J]
        PUSH        HL
        LD          HL, [VARS_D]
        CALL        COPY_STRING
        POP         DE
        LD          IX, BLIB_SETSPRITE
        CALL        CALL_BLIB
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_J_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        RET         
LINE_1001:
        CALL        INTERRUPT_PROCESS
LINE_1002:
        CALL        INTERRUPT_PROCESS
LINE_1003:
        CALL        INTERRUPT_PROCESS
LINE_1004:
        CALL        INTERRUPT_PROCESS
LINE_1005:
        CALL        INTERRUPT_PROCESS
LINE_1006:
        CALL        INTERRUPT_PROCESS
LINE_1007:
        CALL        INTERRUPT_PROCESS
LINE_1008:
        CALL        INTERRUPT_PROCESS
LINE_1011:
        CALL        INTERRUPT_PROCESS
LINE_1012:
        CALL        INTERRUPT_PROCESS
LINE_1013:
        CALL        INTERRUPT_PROCESS
LINE_1014:
        CALL        INTERRUPT_PROCESS
LINE_1015:
        CALL        INTERRUPT_PROCESS
LINE_1016:
        CALL        INTERRUPT_PROCESS
LINE_1017:
        CALL        INTERRUPT_PROCESS
LINE_1018:
        CALL        INTERRUPT_PROCESS
LINE_1021:
        CALL        INTERRUPT_PROCESS
LINE_1022:
        CALL        INTERRUPT_PROCESS
LINE_1023:
        CALL        INTERRUPT_PROCESS
LINE_1024:
        CALL        INTERRUPT_PROCESS
LINE_1025:
        CALL        INTERRUPT_PROCESS
LINE_1026:
        CALL        INTERRUPT_PROCESS
LINE_1027:
        CALL        INTERRUPT_PROCESS
LINE_1028:
        CALL        INTERRUPT_PROCESS
LINE_1090:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT95
        LD          [SVARI_I_LABEL], HL
        JR          _PT94
_PT95:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT96
        SBC         HL, DE
        JP          M, _PT97
        JR          Z, _PT97
        RET         
_PT96:
        CCF         
        SBC         HL, DE
        RET         M
_PT97:
        POP         HL
_PT94:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARS_A
        CALL        SUB_READ_STRING
        CALL        INTERRUPT_PROCESS
        LD          HL, 760
        LD          DE, [VARI_I]
        ADD         HL, DE
        PUSH        HL
        LD          HL, STR_9
        PUSH        HL
        LD          HL, [VARS_A]
        CALL        COPY_STRING
        POP         DE
        CALL        STR_ADD
        PUSH        HL
        CALL        SUB_VAL
        POP         HL
        CALL        FREE_STRING
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT98
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT99
_PT98:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT99:
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        RET         
LINE_1100:
        CALL        INTERRUPT_PROCESS
LINE_1110:
        CALL        INTERRUPT_PROCESS
LINE_1120:
        CALL        INTERRUPT_PROCESS
LINE_1130:
        CALL        INTERRUPT_PROCESS
LINE_1140:
        CALL        INTERRUPT_PROCESS
LINE_1150:
        CALL        INTERRUPT_PROCESS
LINE_1160:
        CALL        INTERRUPT_PROCESS
LINE_1170:
        CALL        INTERRUPT_PROCESS
LINE_1180:
        CALL        INTERRUPT_PROCESS
LINE_1190:
        CALL        INTERRUPT_PROCESS
LINE_1200:
        CALL        INTERRUPT_PROCESS
LINE_1210:
        CALL        INTERRUPT_PROCESS
LINE_1220:
        CALL        INTERRUPT_PROCESS
LINE_1230:
        CALL        INTERRUPT_PROCESS
LINE_1240:
        CALL        INTERRUPT_PROCESS
LINE_1250:
        CALL        INTERRUPT_PROCESS
LINE_2000:
        CALL        INTERRUPT_PROCESS
        LD          HL, DATA_2010
        LD          [DATA_PTR], HL
        CALL        INTERRUPT_PROCESS
        LD          HL, (3) | ((6) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_30
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, (21) | ((1) << 8)
        CALL        BIOS_POSIT
        CALL        INTERRUPT_PROCESS
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_31
        CALL        PUTS
        LD          HL, STR_1
        CALL        PUTS
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 47
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT101
        LD          [SVARI_I_LABEL], HL
        JR          _PT100
_PT101:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT102
        SBC         HL, DE
        JP          M, _PT103
        JR          Z, _PT103
        RET         
_PT102:
        CCF         
        SBC         HL, DE
        RET         M
_PT103:
        POP         HL
_PT100:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_D
        CALL        SUB_READ_INTEGER
        CALL        INTERRUPT_PROCESS
        LD          HL, [62397]
        LD          DE, [VARI_D]
        ADD         HL, DE
        PUSH        HL
        LD          HL, 128
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT104
        LD          A, L
        POP         HL
        CALL        BIOS_WRTVRM
        JR          _PT105
_PT104:
        LD          A, L
        POP         HL
        CALL        BIOS_NWRVRM
_PT105:
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        RET         
LINE_2010:
        CALL        INTERRUPT_PROCESS
LINE_2020:
        CALL        INTERRUPT_PROCESS
LINE_2030:
        CALL        INTERRUPT_PROCESS
LINE_2040:
        CALL        INTERRUPT_PROCESS
LINE_2050:
        CALL        INTERRUPT_PROCESS
LINE_2060:
        CALL        INTERRUPT_PROCESS
LINE_2070:
        CALL        INTERRUPT_PROCESS
LINE_2080:
        CALL        INTERRUPT_PROCESS
LINE_2500:
        CALL        INTERRUPT_PROCESS
        CALL        LINE_3200
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        PUSH        HL
        LD          HL, VARF_X
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, VARF_Y
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 15
        LD          DE, 1
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 5000
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT107
        LD          [SVARI_I_LABEL], HL
        JR          _PT106
_PT107:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT108
        SBC         HL, DE
        JP          M, _PT109
        JR          Z, _PT109
        RET         
_PT108:
        CCF         
        SBC         HL, DE
        RET         M
_PT109:
        POP         HL
_PT106:
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        PUSH        HL
        LD          HL, VARF_X
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, VARF_Y
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 15
        LD          DE, 2
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_PL
        PUSH        HL
        LD          HL, [VARI_PL]
        EX          DE, HL
        LD          HL, 1
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        JP          LINE_175
LINE_2510:
        CALL        INTERRUPT_PROCESS
        CALL        LINE_3200
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        PUSH        HL
        LD          HL, VARF_X1
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, VARF_Y1
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 10
        LD          DE, 1
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 5000
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT111
        LD          [SVARI_I_LABEL], HL
        JR          _PT110
_PT111:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT112
        SBC         HL, DE
        JP          M, _PT113
        JR          Z, _PT113
        RET         
_PT112:
        CCF         
        SBC         HL, DE
        RET         M
_PT113:
        POP         HL
_PT110:
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        PUSH        HL
        LD          HL, VARF_X1
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, VARF_Y1
        LD          DE, WORK_DAC
        LD          BC, 4
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        PUSH        HL
        LD          HL, 10
        LD          DE, 2
        LD          D, L
        POP         HL
        POP         BC
        LD          B, C
        LD          C, L
        POP         HL
        LD          A, L
        LD          L, 7
        LD          IX, BLIB_PUTSPRITE
        CALL        CALL_BLIB
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_EL
        PUSH        HL
        LD          HL, [VARI_EL]
        EX          DE, HL
        LD          HL, 1
        EX          DE, HL
        OR          A, A
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        JP          LINE_175
LINE_3000:
; sound
LINE_3100:
; GAN
LINE_3110:
        CALL        INTERRUPT_PROCESS
        LD          HL, 8
        LD          E, 16
        LD          A, L
        CALL        bios_wrtpsg
LINE_3120:
        CALL        INTERRUPT_PROCESS
        LD          HL, 11
        LD          E, 10
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        LD          HL, 12
        LD          E, 10
        LD          A, L
        CALL        bios_wrtpsg
LINE_3130:
        CALL        INTERRUPT_PROCESS
        LD          HL, 13
        LD          E, 9
        LD          A, L
        CALL        bios_wrtpsg
LINE_3140:
        CALL        INTERRUPT_PROCESS
        LD          HL, 6
        LD          E, 22
        LD          A, L
        CALL        bios_wrtpsg
LINE_3150:
        CALL        INTERRUPT_PROCESS
        LD          HL, 7
        LD          E, 182
        LD          A, L
        CALL        bios_wrtpsg
LINE_3160:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          E, 177
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          E, 210
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        RET         
LINE_3200:
        CALL        INTERRUPT_PROCESS
        LD          HL, 50
        LD          [VARI_A], HL
LINE_3210:
        CALL        INTERRUPT_PROCESS
        LD          HL, 9
        LD          E, 15
        LD          A, L
        CALL        bios_wrtpsg
LINE_3220:
        CALL        INTERRUPT_PROCESS
        LD          HL, 7
        LD          E, 189
        LD          A, L
        CALL        bios_wrtpsg
LINE_3230:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 200
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT115
        LD          [SVARI_I_LABEL], HL
        JR          _PT114
_PT115:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT116
        SBC         HL, DE
        JP          M, _PT117
        JR          Z, _PT117
        RET         
_PT116:
        CCF         
        SBC         HL, DE
        RET         M
_PT117:
        POP         HL
_PT114:
LINE_3240:
        CALL        INTERRUPT_PROCESS
        LD          HL, 2
        PUSH        HL
        LD          HL, [VARI_A]
        LD          E, L
        POP         HL
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        LD          HL, 3
        LD          E, 0
        LD          A, L
        CALL        bios_wrtpsg
LINE_3250:
        CALL        INTERRUPT_PROCESS
        LD          HL, VARI_A
        PUSH        HL
        LD          HL, [VARI_A]
        LD          DE, 1
        ADD         HL, DE
        POP         DE
        EX          DE, HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        CALL        INTERRUPT_PROCESS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_3260:
        CALL        INTERRUPT_PROCESS
        LD          HL, 7
        LD          E, 191
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        RET         
LINE_3310:
        CALL        INTERRUPT_PROCESS
        LD          HL, 8
        LD          E, 16
        LD          A, L
        CALL        bios_wrtpsg
LINE_3320:
        CALL        INTERRUPT_PROCESS
        LD          HL, 11
        LD          E, 0
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        LD          HL, 12
        LD          E, 10
        LD          A, L
        CALL        bios_wrtpsg
LINE_3330:
        CALL        INTERRUPT_PROCESS
        LD          HL, 13
        LD          E, 9
        LD          A, L
        CALL        bios_wrtpsg
LINE_3340:
        CALL        INTERRUPT_PROCESS
        LD          HL, 7
        LD          E, 190
        LD          A, L
        CALL        bios_wrtpsg
LINE_3350:
        CALL        INTERRUPT_PROCESS
        LD          HL, 0
        LD          E, 35
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        LD          HL, 1
        LD          E, 0
        LD          A, L
        CALL        bios_wrtpsg
        CALL        INTERRUPT_PROCESS
        RET         
PROGRAM_TERMINATION:
        CALL        SUB_TERMINATION
        LD          SP, [WORK_HIMEM]
        LD          HL, _BASIC_END
        JP          BIOS_NEWSTT
SUB_TERMINATION:
        XOR         A, A
        LD          [WORK_MAXFIL], A
        LD          HL, [WORK_HIMEM]
        LD          DE, 267
        SBC         HL, DE
        LD          [WORK_FILTAB], HL
        LD          L, E
        LD          H, D
        INC         DE
        INC         DE
        LD          [HL], E
        INC         HL
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        RET         
_BASIC_END:
        DEFB        ':', 0x92, ':', 0x94, ':', 0x81, 0x00
ERR_RETURN_WITHOUT_GOSUB:
        LD          E, 3
        JP          BIOS_ERRHAND
CHECK_BLIB:
        LD          A, [WORK_BLIBSLOT]
        LD          H, 0X40
        CALL        BIOS_ENASLT
        LD          BC, 8
        LD          HL, SIGNATURE
        LD          DE, SIGNATURE_REF
_CHECK_BLIB_LOOP:
        LD          A, [DE]
        INC         DE
        CPI         
        JR          NZ, _CHECK_BLIB_EXIT
        JP          PE, _CHECK_BLIB_LOOP
_CHECK_BLIB_EXIT:
        PUSH        AF
        LD          A, [WORK_MAINROM]
        LD          H, 0X40
        CALL        BIOS_ENASLT
        EI          
        POP         AF
        RET         
SIGNATURE_REF:
        DEFB        "BACONLIB"
CALL_BLIB:
        LD          IY, [WORK_BLIBSLOT - 1]
        CALL        BIOS_CALSLT
        EI          
        RET         
LD_DE_SINGLE_REAL:
        LD          BC, 4
        LDIR        
        RET         
PUTS:
        LD          B, [HL]
        INC         B
        DEC         B
        RET         Z
_PUTS_LOOP:
        INC         HL
        LD          A, [HL]
        RST         0X18
        DJNZ        _PUTS_LOOP
        RET         
FREE_STRING:
        LD          DE, HEAP_START
        RST         0X20
        RET         C
        LD          DE, [HEAP_NEXT]
        RST         0X20
        RET         NC
        LD          C, [HL]
        LD          B, 0
        INC         BC
        JP          FREE_HEAP
FREE_HEAP:
        PUSH        HL
        ADD         HL, BC
        LD          [HEAP_MOVE_SIZE], BC
        LD          [HEAP_REMAP_ADDRESS], HL
        EX          DE, HL
        LD          HL, [HEAP_NEXT]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          A, C
        OR          A, B
        JR          Z, _FREE_HEAP_LOOP0
        LDIR        
_FREE_HEAP_LOOP0:
        LD          [HEAP_NEXT], DE
        LD          HL, VARS_AREA_START
_FREE_HEAP_LOOP1:
        LD          DE, VARSA_AREA_END
        RST         0X20
        JR          NC, _FREE_HEAP_LOOP1_END
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [HEAP_REMAP_ADDRESS]
        EX          DE, HL
        RST         0X20
        JR          C, _FREE_HEAP_LOOP1_NEXT
        LD          DE, [HEAP_MOVE_SIZE]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_FREE_HEAP_LOOP1_NEXT:
        POP         HL
        INC         HL
        JR          _FREE_HEAP_LOOP1
_FREE_HEAP_LOOP1_END:
        LD          HL, VARSA_AREA_START
_FREE_HEAP_LOOP2:
        LD          DE, VARSA_AREA_END
        RST         0X20
        RET         NC
        LD          E, [HL]
        LD          A, E
        INC         HL
        LD          D, [HL]
        OR          A, D
        INC         HL
        JR          Z, _FREE_HEAP_LOOP2
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          C, [HL]
        INC         HL
        LD          B, 0
        ADD         HL, BC
        ADD         HL, BC
        EX          DE, HL
        SBC         HL, BC
        SBC         HL, BC
        RR          H
        RR          L
        LD          C, L
        LD          B, H
        EX          DE, HL
_FREE_HEAP_SARRAY_ELEMENTS:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [HEAP_REMAP_ADDRESS]
        EX          DE, HL
        RST         0X20
        JR          C, _FREE_HEAP_LOOP2_NEXT
        LD          DE, [HEAP_MOVE_SIZE]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_FREE_HEAP_LOOP2_NEXT:
        POP         HL
        INC         HL
        DEC         BC
        LD          A, C
        OR          A, B
        JR          NZ, _FREE_HEAP_SARRAY_ELEMENTS
        POP         HL
        JR          _FREE_HEAP_LOOP2
PUSH_DOUBLE_REAL_HL:
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
POP_DOUBLE_REAL_DAC:
        POP         BC
        POP         HL
        LD          [WORK_DAC+6], HL
        POP         HL
        LD          [WORK_DAC+4], HL
        POP         HL
        LD          [WORK_DAC+2], HL
        POP         HL
        LD          [WORK_DAC+0], HL
        LD          A, 8
        LD          [WORK_VALTYP], A
        PUSH        BC
        RET         
LD_ARG_DOUBLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 8
        LDIR        
        RET         
PUSH_SINGLE_REAL_HL:
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
POP_SINGLE_REAL_DAC:
        POP         BC
        POP         HL
        LD          [WORK_DAC+2], HL
        POP         HL
        LD          [WORK_DAC+0], HL
        LD          HL, 0
        LD          [WORK_DAC+4], HL
        LD          [WORK_DAC+6], HL
        PUSH        BC
        RET         
STR:
        CALL        BIOS_FOUT
FOUT_ADJUST:
        DEC         HL
        PUSH        HL
        XOR         A, A
        LD          B, A
_STR_LOOP:
        INC         HL
        CP          A, [HL]
        JR          Z, _STR_LOOP_EXIT
        INC         B
        JR          _STR_LOOP
_STR_LOOP_EXIT:
        POP         HL
        LD          [HL], B
        RET         
PUT_INTEGER:
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          IX, BLIB_PUT_DIGITS
        JP          CALL_BLIB
; Read data for string
SUB_READ_STRING:
        EX          DE, HL
        LD          HL, [DATA_PTR]
        LD          C, [HL]
        INC         HL
        LD          B, [HL]
        INC         HL
        LD          [DATA_PTR], HL
        EX          DE, HL
        LD          [HL], C
        INC         HL
        LD          [HL], B
        RET         
; Allocate memory for strings. A: Length
ALLOCATE_STRING:
        LD          HL, [HEAP_NEXT]
        PUSH        HL
        LD          E, A
        LD          C, A
        LD          D, 0
        ADD         HL, DE
        INC         HL
        LD          DE, [HEAP_END]
        RST         0X20
        JR          NC, _ALLOCATE_STRING_ERROR
        LD          [HEAP_NEXT], HL
        POP         HL
        LD          [HL], C
        RET         
_ALLOCATE_STRING_ERROR:
        LD          E, 7
        JP          BIOS_ERRHAND
COPY_STRING:
        LD          A, [HL]
        PUSH        HL
        CALL        ALLOCATE_STRING
        POP         DE
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
STR_ADD:
        PUSH        DE
        PUSH        HL
        LD          C, [HL]
        LD          A, [DE]
        ADD         A, C
        JR          C, _STR_ADD_ERROR
        PUSH        HL
        EX          DE, HL
        LD          C, [HL]
        INC         HL
        LD          DE, WORK_BUF+1
        LD          B, 0
        INC         C
        DEC         C
        JR          Z, _STR_ADD_S1
        LDIR        
_STR_ADD_S1:
        POP         HL
        LD          C, [HL]
        INC         HL
        INC         C
        DEC         C
        JR          Z, _STR_ADD_S2
        LDIR        
_STR_ADD_S2:
        LD          [WORK_BUF], A
        POP         HL
        CALL        FREE_STRING
        POP         HL
        CALL        FREE_STRING
        LD          A, [WORK_BUF]
        CALL        ALLOCATE_STRING
        PUSH        HL
        LD          DE, WORK_BUF
        EX          DE, HL
        LD          C, [HL]
        LD          B, 0
        INC         BC
        LDIR        
        POP         HL
        RET         
_STR_ADD_ERROR:
        LD          E, 15
        JP          BIOS_ERRHAND
; Val function
SUB_VAL:
        LD          C, [HL]
        LD          B, 0
        INC         HL
        LD          DE, WORK_BUF
        LDIR        
        XOR         A, A
        LD          [DE], A
        LD          HL, WORK_BUF
        LD          A, [HL]
        CALL        BIOS_FIN
        RET         
; Read data for integer
SUB_READ_INTEGER:
        PUSH        HL
        LD          HL, [DATA_PTR]
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          [DATA_PTR], HL
        EX          DE, HL
        CALL        SUB_VAL
        CALL        BIOS_FRCINT
        POP         HL
        LD          DE, [WORK_DAC + 2]
        LD          [HL], E
        INC         HL
        LD          [HL], D
        RET         
PROGRAM_RUN:
        LD          HL, HEAP_START
        LD          [HEAP_NEXT], HL
        LD          SP, [WORK_HIMEM]
        LD          HL, ERR_RETURN_WITHOUT_GOSUB
        PUSH        HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        LD          HL, [WORK_HIMEM]
        SBC         HL, DE
        LD          [HEAP_END], HL
        DI          
        LD          HL, _CODE_RET
        LD          [SVARI_ON_SPRITE_LINE], HL
        CALL        SETUP_H_ERRO
        EI          
        LD          HL, VAR_AREA_START
        LD          DE, VAR_AREA_START + 1
        LD          BC, VARSA_AREA_END - VAR_AREA_START - 1
        LD          [HL], 0
        LDIR        
        LD          HL, STR_0
        LD          [VARS_AREA_START], HL
        LD          HL, VARS_AREA_START
        LD          DE, VARS_AREA_START + 2
        LD          BC, VARS_AREA_END - VARS_AREA_START - 2
        LDIR        
        RET         
INTERRUPT_PROCESS:
        LD          A, [SVARB_ON_SPRITE_RUNNING]
        OR          A, A
        JR          NZ, _SKIP_ON_SPRITE
        LD          A, [SVARB_ON_SPRITE_EXEC]
        OR          A, A
        JR          Z, _SKIP_ON_SPRITE
        LD          [SVARB_ON_SPRITE_RUNNING], A
        LD          HL, [SVARI_ON_SPRITE_LINE]
        CALL        JP_HL
_ON_SPRITE_RETURN_ADDRESS:
        XOR         A, A
        LD          [SVARB_ON_SPRITE_EXEC], A
        LD          [SVARB_ON_SPRITE_RUNNING], A
_SKIP_ON_SPRITE:
        RET         
INTERRUPT_PROCESS_END:
; H.TIMI PROCESS -----------------
H_TIMI_HANDLER:
        PUSH        AF
; ON SPRITE PROCESS -----------------
        LD          B, A
        LD          A, [SVARB_ON_SPRITE_MODE]
        OR          A, A
        JR          Z, _END_OF_SPRITE
        LD          A, B
        AND         A, 0X20
        LD          [SVARB_ON_SPRITE_EXEC], A
_END_OF_SPRITE:
        POP         AF
        JP          H_TIMI_BACKUP
RESTORE_H_TIMI:
        DI          
        LD          HL, H_TIMI_BACKUP
        LD          DE, WORK_H_TIMI
        LD          BC, 5
        LDIR        
        EI          
        RET         
RESTORE_H_ERRO:
        DI          
        LD          HL, H_ERRO_BACKUP
        LD          DE, WORK_H_ERRO
        LD          BC, 5
        LDIR        
        EI          
_CODE_RET:
        RET         
H_ERRO_HANDLER:
        PUSH        HL
        PUSH        DE
        PUSH        BC
        CALL        RESTORE_H_TIMI
        CALL        RESTORE_H_ERRO
        CALL        SUB_TERMINATION
        POP         BC
        POP         DE
        POP         HL
        JP          WORK_H_ERRO
DATA_1001:
        DEFW        str_11
DATA_1002:
        DEFW        str_12
DATA_1003:
        DEFW        str_13
DATA_1004:
        DEFW        str_14
DATA_1005:
        DEFW        str_14
DATA_1006:
        DEFW        str_14
DATA_1007:
        DEFW        str_15
DATA_1008:
        DEFW        str_11
DATA_1011:
        DEFW        str_16
DATA_1012:
        DEFW        str_11
DATA_1013:
        DEFW        str_17
DATA_1014:
        DEFW        str_15
DATA_1015:
        DEFW        str_15
DATA_1016:
        DEFW        str_15
DATA_1017:
        DEFW        str_11
DATA_1018:
        DEFW        str_18
DATA_1021:
        DEFW        str_16
DATA_1022:
        DEFW        str_18
DATA_1023:
        DEFW        str_19
DATA_1024:
        DEFW        str_11
DATA_1025:
        DEFW        str_11
DATA_1026:
        DEFW        str_19
DATA_1027:
        DEFW        str_18
DATA_1028:
        DEFW        str_18
DATA_1100:
        DEFW        str_20
DATA_1110:
        DEFW        str_21
DATA_1120:
        DEFW        str_21
DATA_1130:
        DEFW        str_21
DATA_1140:
        DEFW        str_21
DATA_1150:
        DEFW        str_21
DATA_1160:
        DEFW        str_21
DATA_1170:
        DEFW        str_18
DATA_1180:
        DEFW        str_22
DATA_1190:
        DEFW        str_23
DATA_1200:
        DEFW        str_24
DATA_1210:
        DEFW        str_25
DATA_1220:
        DEFW        str_26
DATA_1230:
        DEFW        str_27
DATA_1240:
        DEFW        str_28
DATA_1250:
        DEFW        str_29
DATA_2010:
        DEFW        str_32
        DEFW        str_33
        DEFW        str_34
        DEFW        str_35
        DEFW        str_36
DATA_2020:
        DEFW        str_37
        DEFW        str_38
        DEFW        str_39
        DEFW        str_40
DATA_2030:
        DEFW        str_41
        DEFW        str_42
        DEFW        str_43
        DEFW        str_44
        DEFW        str_45
        DEFW        str_46
DATA_2040:
        DEFW        str_47
        DEFW        str_48
        DEFW        str_49
        DEFW        str_50
        DEFW        str_51
        DEFW        str_52
DATA_2050:
        DEFW        str_53
        DEFW        str_54
        DEFW        str_55
        DEFW        str_56
        DEFW        str_57
        DEFW        str_58
        DEFW        str_59
DATA_2060:
        DEFW        str_60
        DEFW        str_61
        DEFW        str_62
        DEFW        str_63
        DEFW        str_64
        DEFW        str_65
DATA_2070:
        DEFW        str_66
        DEFW        str_67
        DEFW        str_68
        DEFW        str_69
        DEFW        str_70
        DEFW        str_71
        DEFW        str_72
DATA_2080:
        DEFW        str_73
        DEFW        str_74
        DEFW        str_75
        DEFW        str_76
        DEFW        str_77
        DEFW        str_78
        DEFW        str_79
CONST_40020000:
        DEFB        0X40, 0X02, 0X00, 0X00
CONST_40050000:
        DEFB        0X40, 0X05, 0X00, 0X00
CONST_41120000:
        DEFB        0X41, 0X12, 0X00, 0X00
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X02, 0X0D, 0X0A
STR_10:
        DEFB        0X02, 0X26, 0X42
STR_11:
        DEFB        0X08, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30
STR_12:
        DEFB        0X08, 0X30, 0X31, 0X30, 0X31, 0X31, 0X31, 0X31, 0X30
STR_13:
        DEFB        0X08, 0X31, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31
STR_14:
        DEFB        0X08, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31
STR_15:
        DEFB        0X08, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30
STR_16:
        DEFB        0X09, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X27
STR_17:
        DEFB        0X08, 0X30, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30
STR_18:
        DEFB        0X08, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30
STR_19:
        DEFB        0X08, 0X30, 0X30, 0X30, 0X31, 0X31, 0X30, 0X30, 0X30
STR_2:
        DEFB        0X1B, 0X20, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F, 0X5F
STR_20:
        DEFB        0X08, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30
STR_21:
        DEFB        0X08, 0X31, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30, 0X30
STR_22:
        DEFB        0X09, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X31, 0X27
STR_23:
        DEFB        0X08, 0X31, 0X30, 0X31, 0X31, 0X31, 0X31, 0X31, 0X30
STR_24:
        DEFB        0X08, 0X31, 0X31, 0X30, 0X31, 0X31, 0X31, 0X30, 0X30
STR_25:
        DEFB        0X08, 0X31, 0X31, 0X31, 0X30, 0X31, 0X30, 0X30, 0X30
STR_26:
        DEFB        0X08, 0X31, 0X31, 0X31, 0X31, 0X30, 0X30, 0X30, 0X30
STR_27:
        DEFB        0X08, 0X31, 0X31, 0X31, 0X30, 0X31, 0X31, 0X30, 0X30
STR_28:
        DEFB        0X08, 0X31, 0X31, 0X30, 0X31, 0X30, 0X31, 0X31, 0X30
STR_29:
        DEFB        0X08, 0X31, 0X30, 0X31, 0X30, 0X31, 0X30, 0X31, 0X31
STR_3:
        DEFB        0X01, 0X60
STR_30:
        DEFB        0X03, 0X54, 0X48, 0X45
STR_31:
        DEFB        0X20, 0X32, 0X30, 0X32, 0X34, 0X20, 0X48, 0X61, 0X6E, 0X64, 0X6F, 0X27, 0X73, 0X47, 0X61, 0X6D, 0X65, 0X43, 0X68, 0X61, 0X6E, 0X6E, 0X65, 0X6C, 0X2F, 0X82, 0XA9, 0X82, 0XB8, 0X82, 0XC6, 0X82, 0XE0
STR_32:
        DEFB        0X02, 0X34, 0X33
STR_33:
        DEFB        0X02, 0X34, 0X34
STR_34:
        DEFB        0X02, 0X34, 0X35
STR_35:
        DEFB        0X02, 0X35, 0X32
STR_36:
        DEFB        0X02, 0X35, 0X34
STR_37:
        DEFB        0X02, 0X37, 0X35
STR_38:
        DEFB        0X02, 0X37, 0X38
STR_39:
        DEFB        0X02, 0X38, 0X34
STR_4:
        DEFB        0X07, 0X50, 0X4C, 0X41, 0X59, 0X45, 0X52, 0X3A
STR_40:
        DEFB        0X02, 0X38, 0X36
STR_41:
        DEFB        0X03, 0X31, 0X30, 0X37
STR_42:
        DEFB        0X03, 0X31, 0X31, 0X30
STR_43:
        DEFB        0X03, 0X31, 0X31, 0X32
STR_44:
        DEFB        0X03, 0X31, 0X31, 0X33
STR_45:
        DEFB        0X03, 0X31, 0X31, 0X36
STR_46:
        DEFB        0X03, 0X31, 0X31, 0X38
STR_47:
        DEFB        0X03, 0X31, 0X33, 0X39
STR_48:
        DEFB        0X03, 0X31, 0X34, 0X30
STR_49:
        DEFB        0X03, 0X31, 0X34, 0X31
STR_5:
        DEFB        0X01, 0X80
STR_50:
        DEFB        0X03, 0X31, 0X34, 0X36
STR_51:
        DEFB        0X03, 0X31, 0X34, 0X38
STR_52:
        DEFB        0X03, 0X31, 0X35, 0X30
STR_53:
        DEFB        0X03, 0X31, 0X37, 0X31
STR_54:
        DEFB        0X03, 0X31, 0X37, 0X34
STR_55:
        DEFB        0X03, 0X31, 0X37, 0X36
STR_56:
        DEFB        0X03, 0X31, 0X37, 0X37
STR_57:
        DEFB        0X03, 0X31, 0X37, 0X38
STR_58:
        DEFB        0X03, 0X31, 0X38, 0X30
STR_59:
        DEFB        0X03, 0X31, 0X38, 0X32
STR_6:
        DEFB        0X06, 0X45, 0X4E, 0X45, 0X4D, 0X59, 0X3A
STR_60:
        DEFB        0X03, 0X32, 0X30, 0X33
STR_61:
        DEFB        0X03, 0X32, 0X30, 0X36
STR_62:
        DEFB        0X03, 0X32, 0X30, 0X37
STR_63:
        DEFB        0X03, 0X32, 0X31, 0X30
STR_64:
        DEFB        0X03, 0X32, 0X31, 0X32
STR_65:
        DEFB        0X03, 0X32, 0X31, 0X34
STR_66:
        DEFB        0X03, 0X32, 0X33, 0X35
STR_67:
        DEFB        0X03, 0X32, 0X33, 0X38
STR_68:
        DEFB        0X03, 0X32, 0X33, 0X39
STR_69:
        DEFB        0X03, 0X32, 0X34, 0X31
STR_7:
        DEFB        0X0B, 0X20, 0X47, 0X41, 0X4D, 0X45, 0X20, 0X4F, 0X56, 0X45, 0X52, 0X20
STR_70:
        DEFB        0X03, 0X32, 0X34, 0X32
STR_71:
        DEFB        0X03, 0X32, 0X34, 0X34
STR_72:
        DEFB        0X03, 0X32, 0X34, 0X36
STR_73:
        DEFB        0X03, 0X32, 0X36, 0X37
STR_74:
        DEFB        0X03, 0X32, 0X36, 0X38
STR_75:
        DEFB        0X03, 0X32, 0X36, 0X39
STR_76:
        DEFB        0X03, 0X32, 0X37, 0X32
STR_77:
        DEFB        0X03, 0X32, 0X37, 0X34
STR_78:
        DEFB        0X03, 0X32, 0X37, 0X36
STR_79:
        DEFB        0X03, 0X32, 0X37, 0X38
STR_8:
        DEFB        0X0B, 0X20, 0X59, 0X4F, 0X55, 0X20, 0X57, 0X49, 0X4E, 0X21, 0X20, 0X21
STR_9:
        DEFB        0X02, 0X26, 0X62
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
DATA_PTR:
        DEFW        data_1001
VAR_AREA_START:
SVARB_ON_SPRITE_EXEC:
        DEFB        0
SVARB_ON_SPRITE_MODE:
        DEFB        0
SVARB_ON_SPRITE_RUNNING:
        DEFB        0
SVARI_I_FOR_END:
        DEFW        0
SVARI_I_FOR_STEP:
        DEFW        0
SVARI_I_LABEL:
        DEFW        0
SVARI_J_FOR_END:
        DEFW        0
SVARI_J_FOR_STEP:
        DEFW        0
SVARI_J_LABEL:
        DEFW        0
SVARI_ON_SPRITE_LINE:
        DEFW        0
SVARI_USR0_BACKUP:
        DEFW        0
VARF_T:
        DEFW        0, 0
VARF_X:
        DEFW        0, 0
VARF_X1:
        DEFW        0, 0
VARF_XA:
        DEFW        0, 0
VARF_XX:
        DEFW        0, 0
VARF_Y:
        DEFW        0, 0
VARF_Y1:
        DEFW        0, 0
VARF_YA:
        DEFW        0, 0
VARF_YY:
        DEFW        0, 0
VARI_A:
        DEFW        0
VARI_CL:
        DEFW        0
VARI_CR:
        DEFW        0
VARI_CS:
        DEFW        0
VARI_D:
        DEFW        0
VARI_EL:
        DEFW        0
VARI_I:
        DEFW        0
VARI_J:
        DEFW        0
VARI_PL:
        DEFW        0
VARI_ST:
        DEFW        0
VARI_VX:
        DEFW        0
VARI_X:
        DEFW        0
VARI_Y:
        DEFW        0
VARI_Z:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_A:
        DEFW        0
VARS_D:
        DEFW        0
VARS_AREA_END:
VARA_AREA_START:
VARA_AREA_END:
VARSA_AREA_START:
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
