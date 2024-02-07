; ------------------------------------------------------------------------
; COMPILED BY MSX-BACON FROM TEST.ASC
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_FILTAB                     = 0X0F860
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
WORK_RG1SV                      = 0X0F3E0
BIOS_WRTVDP                     = 0X00047
WORK_CLIKSW                     = 0X0F3DB
BIOS_CHGCLR                     = 0X00062
WORK_FORCLR                     = 0X0F3E9
WORK_BAKCLR                     = 0X0F3EA
WORK_BDRCLR                     = 0X0F3EB
BLIB_WIDTH                      = 0X0403C
WORK_PRTFLG                     = 0X0F416
BIOS_FOUT                       = 0X03425
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
WORK_CSRX                       = 0X0F3DD
WORK_LINLEN                     = 0X0F3B0
BIOS_ERRHAND                    = 0X0406F
BLIB_INPUT                      = 0X0407E
BIOS_NEWSTT                     = 0X04601
; BSAVE HEADER -----------------------------------------------------------
        DEFB        0XFE
        DEFW        START_ADDRESS
        DEFW        END_ADDRESS
        DEFW        START_ADDRESS
        ORG         0X8010
START_ADDRESS:
        LD          SP, [WORK_FILTAB]
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
PROGRAM_START:
LINE_110:
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
        XOR         A, A
        LD          [work_cliksw], A
        LD          A, 15
        LD          [WORK_FORCLR], A
        LD          A, 4
        LD          [WORK_BAKCLR], A
        LD          A, 7
        LD          [WORK_BDRCLR], A
        CALL        BIOS_CHGCLR
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
LINE_120:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_130:
        LD          HL, 15
        LD          [VARI_I], HL
        LD          HL, 0
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT3
        LD          [SVARI_I_LABEL], HL
        JR          _PT2
_PT3:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT4
        SBC         HL, DE
        JP          M, _PT5
        JR          Z, _PT5
        RET         
_PT4:
        CCF         
        SBC         HL, DE
        RET         M
_PT5:
        POP         HL
_PT2:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT6
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT6:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_140:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_150:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_4
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_160:
        LD          HL, 15
        LD          [VARI_I], HL
        LD          HL, -1
        LD          [SVARI_I_FOR_END], HL
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT8
        LD          [SVARI_I_LABEL], HL
        JR          _PT7
_PT8:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT9
        SBC         HL, DE
        JP          M, _PT10
        JR          Z, _PT10
        RET         
_PT9:
        CCF         
        SBC         HL, DE
        RET         M
_PT10:
        POP         HL
_PT7:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT11
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT11:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_170:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_180:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_5
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_190:
        LD          HL, 15
        LD          [VARI_I], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
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
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT16
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT16:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_200:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_210:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_6
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_220:
        LD          HL, 15
        LD          [VARI_I], HL
        LD          HL, -2
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT18
        LD          [SVARI_I_LABEL], HL
        JR          _PT17
_PT18:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT19
        SBC         HL, DE
        JP          M, _PT20
        JR          Z, _PT20
        RET         
_PT19:
        CCF         
        SBC         HL, DE
        RET         M
_PT20:
        POP         HL
_PT17:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT21
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT21:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_230:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_240:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_7
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_250:
        LD          HL, 15
        LD          [VARI_I], HL
        LD          HL, 2
        LD          [SVARI_I_FOR_END], HL
        LD          HL, -1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT23
        LD          [SVARI_I_LABEL], HL
        JR          _PT22
_PT23:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT24
        SBC         HL, DE
        JP          M, _PT25
        JR          Z, _PT25
        RET         
_PT24:
        CCF         
        SBC         HL, DE
        RET         M
_PT25:
        POP         HL
_PT22:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT26
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT26:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_260:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_270:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_8
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_280:
        LD          HL, 0
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT28
        LD          [SVARI_I_LABEL], HL
        JR          _PT27
_PT28:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT29
        SBC         HL, DE
        JP          M, _PT30
        JR          Z, _PT30
        RET         
_PT29:
        CCF         
        SBC         HL, DE
        RET         M
_PT30:
        POP         HL
_PT27:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT31
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT31:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_290:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_300:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_9
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_310:
        LD          HL, -1
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT33
        LD          [SVARI_I_LABEL], HL
        JR          _PT32
_PT33:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT34
        SBC         HL, DE
        JP          M, _PT35
        JR          Z, _PT35
        RET         
_PT34:
        CCF         
        SBC         HL, DE
        RET         M
_PT35:
        POP         HL
_PT32:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT36
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT36:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_320:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_330:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_10
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_340:
        LD          HL, 1
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT38
        LD          [SVARI_I_LABEL], HL
        JR          _PT37
_PT38:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT39
        SBC         HL, DE
        JP          M, _PT40
        JR          Z, _PT40
        RET         
_PT39:
        CCF         
        SBC         HL, DE
        RET         M
_PT40:
        POP         HL
_PT37:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT41
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT41:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_350:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_360:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_11
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_370:
        LD          HL, -2
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT43
        LD          [SVARI_I_LABEL], HL
        JR          _PT42
_PT43:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT44
        SBC         HL, DE
        JP          M, _PT45
        JR          Z, _PT45
        RET         
_PT44:
        CCF         
        SBC         HL, DE
        RET         M
_PT45:
        POP         HL
_PT42:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT46
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT46:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
LINE_380:
        LD          HL, VARS_I
        PUSH        HL
        LD          A, 1
        CALL        ALLOCATE_STRING
        LD          IX, BLIB_INPUT
        CALL        CALL_BLIB
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
LINE_390:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_12
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_400:
        LD          HL, 2
        LD          [VARI_I], HL
        LD          HL, 15
        LD          [SVARI_I_FOR_END], HL
        LD          HL, 1
        LD          [SVARI_I_FOR_STEP], HL
        LD          HL, _PT48
        LD          [SVARI_I_LABEL], HL
        JR          _PT47
_PT48:
        LD          HL, [VARI_I]
        LD          DE, [SVARI_I_FOR_STEP]
        ADD         HL, DE
        LD          [VARI_I], HL
        LD          A, D
        LD          DE, [SVARI_I_FOR_END]
        RLCA        
        JR          C, _PT49
        SBC         HL, DE
        JP          M, _PT50
        JR          Z, _PT50
        RET         
_PT49:
        CCF         
        SBC         HL, DE
        RET         M
_PT50:
        POP         HL
_PT47:
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, [VARI_I]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        STR
        LD          A, [WORK_LINLEN]
        INC         A
        INC         A
        LD          B, A
        LD          A, [WORK_CSRX]
        ADD         A, [HL]
        CP          A, B
        JR          C, _PT51
        PUSH        HL
        LD          HL, STR_2
        CALL        PUTS
        POP         HL
_PT51:
        CALL        PUTS
        LD          A, 32
        RST         0X18
        LD          HL, STR_2
        CALL        PUTS
        LD          HL, [SVARI_I_LABEL]
        CALL        JP_HL
PROGRAM_TERMINATION:
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          SP, [WORK_FILTAB]
        LD          HL, _BASIC_END
        CALL        BIOS_NEWSTT
_BASIC_END:
        DEFB        ':', 0X81, 0X00
ERR_RETURN_WITHOUT_GOSUB:
        LD          E, 3
        JP          BIOS_ERRHAND
        DI          
        CALL        SETUP_H_ERRO
        EI          
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
        LD          HL, [HEAP_MOVE_SIZE]
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
PROGRAM_RUN:
        LD          HL, HEAP_START
        LD          [HEAP_NEXT], HL
        LD          SP, [WORK_FILTAB]
        LD          HL, ERR_RETURN_WITHOUT_GOSUB
        PUSH        HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        LD          HL, [WORK_FILTAB]
        SBC         HL, DE
        LD          [HEAP_END], HL
        LD          HL, VAR_AREA_START
        LD          DE, VAR_AREA_START + 1
        LD          BC, VARSA_AREA_END - VAR_AREA_START - 1
        LD          [HL], 0
        LDIR        
        LD          HL, STR_0
        LD          [VARS_AREA_START], HL
        RET         
; H.TIMI PROCESS -----------------
H_TIMI_HANDLER:
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
        PUSH        DE
        CALL        RESTORE_H_TIMI
        CALL        RESTORE_H_ERRO
        POP         DE
        JP          WORK_H_ERRO
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X15, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X31, 0X35, 0X20, 0X54, 0X4F, 0X20, 0X30, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X2D, 0X31
STR_10:
        DEFB        0X14, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X31, 0X20, 0X54, 0X4F, 0X20, 0X31, 0X35, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X31
STR_11:
        DEFB        0X15, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X2D, 0X32, 0X20, 0X54, 0X4F, 0X20, 0X31, 0X35, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X31
STR_12:
        DEFB        0X14, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X32, 0X20, 0X54, 0X4F, 0X20, 0X31, 0X35, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X31
STR_2:
        DEFB        0X02, 0X0D, 0X0A
STR_3:
        DEFB        0X02, 0X49, 0X3D
STR_4:
        DEFB        0X16, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X31, 0X35, 0X20, 0X54, 0X4F, 0X20, 0X2D, 0X31, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X2D, 0X31
STR_5:
        DEFB        0X15, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X31, 0X35, 0X20, 0X54, 0X4F, 0X20, 0X31, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X2D, 0X31
STR_6:
        DEFB        0X16, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X31, 0X35, 0X20, 0X54, 0X4F, 0X20, 0X2D, 0X32, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X2D, 0X31
STR_7:
        DEFB        0X15, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X31, 0X35, 0X20, 0X54, 0X4F, 0X20, 0X32, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X2D, 0X31
STR_8:
        DEFB        0X14, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X30, 0X20, 0X54, 0X4F, 0X20, 0X31, 0X35, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X31
STR_9:
        DEFB        0X15, 0X46, 0X4F, 0X52, 0X20, 0X49, 0X3D, 0X2D, 0X31, 0X20, 0X54, 0X4F, 0X20, 0X31, 0X35, 0X20, 0X53, 0X54, 0X45, 0X50, 0X20, 0X31
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
SVARI_I_FOR_END:
        DEFW        0
SVARI_I_FOR_STEP:
        DEFW        0
SVARI_I_LABEL:
        DEFW        0
VARI_I:
        DEFW        0
VAR_AREA_END:
VARS_AREA_START:
VARS_I:
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
