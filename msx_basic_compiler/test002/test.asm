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
WORK_GXPOS                      = 0X0FCB3
WORK_GYPOS                      = 0X0FCB5
WORK_ASPECT                     = 0X0F931
WORK_CXOFF                      = 0X0F945
WORK_CYOFF                      = 0X0F947
WORK_CPCNT                      = 0X0F939
WORK_CRCSUM                     = 0X0F93D
BIOS_SETATR                     = 0X0011A
BIOS_FRCSNG                     = 0X02FB2
BIOS_DECMUL                     = 0X027E6
BIOS_FRCINT                     = 0X02F8A
BLIB_GET_SIN_TABLE              = 0X040DE
BIOS_LINE                       = 0X058FC
WORK_RG9SAV                     = 0X0FFE8
WORK_ASPCT1                     = 0X0F40B
WORK_ASPCT2                     = 0X0F40D
WORK_BUF                        = 0X0F55E
WORK_VALTYP                     = 0X0F663
WORK_DAC                        = 0X0F7F6
WORK_SCRMOD                     = 0X0FCAF
WORK_CIRCLE_X_SHIFT             = WORK_BUF + 65
WORK_CIRCLE_QUADRANT0           = WORK_BUF + 66
WORK_CIRCLE_QUADRANT1           = WORK_BUF + 67
WORK_CIRCLE_QUADRANT2           = WORK_BUF + 68
WORK_CIRCLE_QUADRANT3           = WORK_BUF + 69
WORK_CIRCLE_CENTERX             = WORK_BUF + 70
WORK_CIRCLE_CENTERY             = WORK_BUF + 72
WORK_CIRCLE_RADIUSX             = WORK_BUF + 74
WORK_CIRCLE_RADIUSY             = WORK_BUF + 76
WORK_CIRCLE_PREV_CXOFF1         = WORK_BUF + 78
WORK_CIRCLE_PREV_CYOFF1         = WORK_BUF + 80
WORK_CIRCLE_PREV_CXOFF2         = WORK_BUF + 82
WORK_CIRCLE_PREV_CYOFF2         = WORK_BUF + 84
WORK_CIRCLE_CXOFF1              = WORK_BUF + 86
WORK_CIRCLE_CYOFF1              = WORK_BUF + 88
WORK_CIRCLE_CXOFF2              = WORK_BUF + 90
WORK_CIRCLE_CYOFF2              = WORK_BUF + 92
WORK_ARG                        = 0X0F847
WORK_CSCLXY                     = 0X0F941
WORK_SAVEA                      = 0X0F942
WORK_SAVEM                      = 0X0F944
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
LINE_100:
        LD          HL, 5
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
LINE_110:
        LD          HL, 128
        LD          [WORK_CIRCLE_CENTERX], HL
        LD          HL, 100
        LD          HL, 100
        LD          [WORK_CIRCLE_RADIUSX], HL
        LD          A, 15
        CALL        BIOS_SETATR
        LD          HL, 0
        LD          [WORK_CPCNT + 0], HL
        LD          [WORK_CPCNT + 2], HL
        LD          HL, 0
        LD          [WORK_CRCSUM + 0], HL
        LD          [WORK_CRCSUM + 2], HL
        LD          HL, 0X1041
        LD          [WORK_ASPECT + 0], HL
        LD          HL, 0
        LD          [WORK_ASPECT + 2], HL
        CALL        SUB_CIRCLE
LINE_120:
        LD          HL, 10
        LD          [WORK_CIRCLE_CENTERX], HL
        LD          HL, 10
        LD          HL, 120
        LD          [WORK_CIRCLE_RADIUSX], HL
        LD          A, 12
        CALL        BIOS_SETATR
        LD          HL, 0
        LD          [WORK_CPCNT + 0], HL
        LD          [WORK_CPCNT + 2], HL
        LD          HL, 0
        LD          [WORK_CRCSUM + 0], HL
        LD          [WORK_CRCSUM + 2], HL
        LD          HL, 0X1041
        LD          [WORK_ASPECT + 0], HL
        LD          HL, 0
        LD          [WORK_ASPECT + 2], HL
        CALL        SUB_CIRCLE
LINE_130:
        LD          HL, 200
        LD          [WORK_CIRCLE_CENTERX], HL
        LD          HL, 190
        LD          HL, 50
        LD          [WORK_CIRCLE_RADIUSX], HL
        LD          A, 8
        CALL        BIOS_SETATR
        LD          HL, 0
        LD          [WORK_CPCNT + 0], HL
        LD          [WORK_CPCNT + 2], HL
        LD          HL, 0
        LD          [WORK_CRCSUM + 0], HL
        LD          [WORK_CRCSUM + 2], HL
        LD          HL, 0X1041
        LD          [WORK_ASPECT + 0], HL
        LD          HL, 0
        LD          [WORK_ASPECT + 2], HL
        CALL        SUB_CIRCLE
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
LD_ARG_SINGLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 4
        LDIR        
        LD          [WORK_ARG+4], BC
        LD          [WORK_ARG+6], BC
        LD          A, 8
        LD          [WORK_VALTYP], A
        RET         
LD_DAC_SINGLE_REAL:
        LD          DE, WORK_DAC
        LD          BC, 4
        LD          A, C
        LD          [WORK_VALTYP], A
        LDIR        
        LD          [WORK_DAC+4], BC
        LD          [WORK_DAC+6], BC
        RET         
LD_DE_SINGLE_REAL:
        LD          BC, 4
        LDIR        
        RET         
;  CIRCLE ROUTINE --------------------------------------------------------------
SUB_CIRCLE:
; 	CALCLATE VERTICAL RADIUS
        LD          HL, WORK_ASPECT
        CALL        LD_ARG_SINGLE_REAL
        LD          HL, [WORK_CIRCLE_RADIUSX]
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCSNG
        CALL        BIOS_DECMUL
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, [WORK_ASPCT2]
        RLCA        
        JR          NC, _SUB_CIRCLE_SKIP1
        SRL         H
        RR          L
_SUB_CIRCLE_SKIP1:
        LD          [WORK_CIRCLE_RADIUSY], HL
; 	CONVERT START ANGLE TO 0...255.
        LD          HL, WORK_CPCNT
        CALL        LD_ARG_SINGLE_REAL
        LD          HL, CONST_42407437
        CALL        LD_DAC_SINGLE_REAL
        LD          A, 4
        LD          [WORK_VALTYP], A
        LD          A, [WORK_CPCNT]
        PUSH        AF
        AND         A, 0X7F
        LD          [WORK_ARG], A
        CALL        BIOS_DECMUL
        CALL        BIOS_FRCINT
        LD          A, [WORK_DAC + 2]
        LD          [WORK_CPCNT], A
        POP         AF
        AND         A, 0X80
        LD          [WORK_CPCNT + 1], A
; 	CONVERT END ANGLE TO 0`255.
        LD          HL, WORK_CRCSUM
        CALL        LD_ARG_SINGLE_REAL
        LD          HL, CONST_42407437
        CALL        LD_DAC_SINGLE_REAL
        LD          A, 4
        LD          [WORK_VALTYP], A
        LD          A, [WORK_CRCSUM]
        PUSH        AF
        AND         A, 0X7F
        LD          [WORK_ARG], A
        CALL        BIOS_DECMUL
        CALL        BIOS_FRCINT
        LD          A, [WORK_DAC + 2]
        LD          [WORK_CRCSUM], A
        LD          B, A
        POP         AF
        AND         A, 0X80
        LD          [WORK_CRCSUM + 1], A
; 	COMPARE START AND END ANGLE
        LD          A, [WORK_CPCNT]
        CP          A, B
        LD          A, 0
; 
        LD          [WORK_SAVEM], A
; 	GET SIN TABLE
        LD          IX, BLIB_GET_SIN_TABLE
        CALL        CALL_BLIB
; 	INITIAL VALUE OF HORIZONTAL RADIUS.
        LD          HL, [WORK_CIRCLE_RADIUSX]
        LD          [WORK_CIRCLE_CXOFF1], HL
        LD          HL, [WORK_CIRCLE_RADIUSY]
        LD          [WORK_CIRCLE_CYOFF2], HL
        LD          HL, 0
        LD          [WORK_CIRCLE_CXOFF2], HL
        LD          [WORK_CIRCLE_CYOFF1], HL
; 	ƒÆ = 0[DEG]¨45[DEG]
        LD          A, [WORK_CSCLXY]
        LD          B, A
        PUSH        BC
_SUB_CIRCLE_THETA_LOOP:
        LD          A, B
; 		MOVE PREVIOUS VALUE TO PREV SECTION.
        LD          HL, WORK_CIRCLE_CXOFF1
        LD          DE, WORK_CIRCLE_PREV_CXOFF1
        LD          BC, 8
        LDIR        
; 		X1 = COS(THETA) * HORIZONTAL RADIUS, Y2 = COS(THETA) * VERTICAL RADIUS
        CALL        _SUB_CIRCLE_COS
        PUSH        HL
        LD          BC, [WORK_CIRCLE_RADIUSX]
        CALL        _SUB_CIRCLE_MUL
        LD          [WORK_CIRCLE_CXOFF1], HL
        POP         HL
        CALL        _SUB_CIRCLE_MUL
        LD          [WORK_CIRCLE_CYOFF2], HL
; 		Y1 = SIN(THETA) * HORIZONTAL RADIUS, X2 = SIN(THETA) * VERTICAL RADIUS
        POP         AF
        PUSH        AF
        CALL        _SUB_CIRCLE_SIN
        PUSH        HL
        LD          BC, [WORK_CIRCLE_RADIUSY]
        CALL        _SUB_CIRCLE_MUL
        LD          [WORK_CIRCLE_CYOFF1], HL
        POP         HL
        LD          BC, [WORK_CIRCLE_RADIUSX]
        CALL        _SUB_CIRCLE_MUL
        LD          [WORK_CIRCLE_CXOFF2], HL
; 		QUADRANT 0 (0[DEG]...90[DEG])
_SUB_CIRCLE_QUADRANT0_PROCESS:
        LD          A, [WORK_CIRCLE_QUADRANT0]
        OR          A, A
        JR          NZ, _SUB_CIRCLE_QUADRANT1_PROCESS
        POP         BC
        PUSH        BC
        LD          A, 3
        CALL        _SUB_CIRCLE_QUADRANT_PROCESS
; 		QUADRANT 1 (90[DEG]...180[DEG])
_SUB_CIRCLE_QUADRANT1_PROCESS:
        LD          A, [WORK_CIRCLE_QUADRANT1]
        OR          A, A
        JR          NZ, _SUB_CIRCLE_QUADRANT2_PROCESS
        POP         BC
        PUSH        BC
        LD          A, 128
        SUB         A, B
        LD          B, A
        LD          A, 2
        CALL        _SUB_CIRCLE_QUADRANT_PROCESS
; 		QUADRANT 2 (180[DEG]...270[DEG])
_SUB_CIRCLE_QUADRANT2_PROCESS:
        LD          A, [WORK_CIRCLE_QUADRANT2]
        OR          A, A
        JR          NZ, _SUB_CIRCLE_QUADRANT3_PROCESS
        POP         AF
        PUSH        AF
        ADD         A, 128
        LD          B, A
        XOR         A, A
        CALL        _SUB_CIRCLE_QUADRANT_PROCESS
; 		QUADRANT 3 (270[DEG]`360[DEG])
_SUB_CIRCLE_QUADRANT3_PROCESS:
        LD          A, [WORK_CIRCLE_QUADRANT3]
        OR          A, A
        JR          NZ, _SUB_CIRCLE_QUADRANT_END
        POP         AF
        PUSH        AF
        NEG         
        LD          B, A
        LD          A, 1
        CALL        _SUB_CIRCLE_QUADRANT_PROCESS
; 
_SUB_CIRCLE_QUADRANT_END:
        POP         BC
        BIT         5, B
        JP          NZ, _SUB_CIRCLE_LINE_PROCESS
        LD          A, [WORK_CSCLXY]
        ADD         A, B
        LD          B, A
        PUSH        BC
        JP          _SUB_CIRCLE_THETA_LOOP
; 
;  IS ANGLE B A DRAWING TARGET?
;  CY = 0: TARGET, 1: NOT TARGET
_SUB_CIRCLE_CHECK_ANGLE:
;  WHICH IS LARGER, THE START OR END ANGLE?
        LD          A, [WORK_SAVEM]
        OR          A, A
        JR          Z, _SUB_CIRCLE_CHECK_ANGLE_COND_OR
_SUB_CIRCLE_CHECK_ANGLE_COND_AND:
;  IS THE TARGET ANGLE GREATER THAN THE STARTING ANGLE?
        LD          A, [WORK_CPCNT]
        OR          A, A
        JR          Z, _SUB_CIRCLE_CHECK_ANGLE_LEFT1
        CP          A, B
        CCF         
        RET         C
_SUB_CIRCLE_CHECK_ANGLE_LEFT1:
;  THE TARGET ANGLE IS GREATER THAN THE START ANGLE. THEN, IS THE ANGLE OF TARGET SMALLER THAN THE END ANGLE?
        LD          A, [WORK_CRCSUM]
        OR          A, A
        RET         Z
        CP          A, B
        RET         
_SUB_CIRCLE_CHECK_ANGLE_COND_OR:
;  IS THE TARGET ANGLE GREATER THAN THE START ANGLE?
        LD          A, [WORK_CPCNT]
        CP          A, B
        CCF         
        RET         NC
;  THE TARGET ANGLE IS SMALLER THAN THE START ANGLE. SO IS THE TARGET ANGLE SMALLER THAN THE END ANGLE?
        LD          A, [WORK_CRCSUM]
        CP          A, B
        RET         
; 
;  IF BIT0 OF A IS 0, X SIGN IS INVERTED; IF BIT1 IS 0, Y SIGN IS INVERTED.
;  ANGLE 0 TO 31 (0[DEG] TO 45[DEG]) ON B
_SUB_CIRCLE_QUADRANT_PROCESS:
        PUSH        BC
        PUSH        AF
        LD          C, A
        CALL        _SUB_CIRCLE_CHECK_ANGLE
        JR          C, _SUB_CIRCLE_QUADRANT_LINE1_SKIP
        LD          A, C
;  START POINT X1
        LD          HL, [WORK_CIRCLE_CENTERX]
        LD          DE, [WORK_CIRCLE_CXOFF1]
        RRCA        
        JR          C, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_CX1
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_CX1:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_CX1
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_CX1:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_CX1:
        LD          [WORK_GXPOS], HL
; 
;  START POINT Y1
        LD          HL, [WORK_CIRCLE_CENTERY]
        LD          DE, [WORK_CIRCLE_CYOFF1]
        RRCA        
        JR          C, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_CY1
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_CY1:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_CY1
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_CY1:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_CY1:
        LD          [WORK_GYPOS], HL
        POP         AF
; 
        PUSH        AF
;  END POINT X1
        LD          HL, [WORK_CIRCLE_CENTERX]
        LD          DE, [WORK_CIRCLE_PREV_CXOFF1]
        RRCA        
        JR          C, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCX1
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_PCX1:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_PCX1
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCX1:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_PCX1:
        LD          C, L
        LD          B, H
; 
;  END POINT Y1
        LD          HL, [WORK_CIRCLE_CENTERY]
        LD          DE, [WORK_CIRCLE_PREV_CYOFF1]
        RRCA        
        JR          C, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCY1
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_PCY1:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_PCY1
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCY1:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_PCY1:
        EX          DE, HL
; 
        CALL        _SUB_CIRCLE_DRAW_LINE
_SUB_CIRCLE_QUADRANT_LINE1_SKIP:
        POP         AF
        POP         BC
; 
        PUSH        AF
        LD          C, A
        LD          A, B
        XOR         A, 63
        LD          B, A
        CALL        _SUB_CIRCLE_CHECK_ANGLE
        JR          C, _SUB_CIRCLE_QUADRANT_LINE2_SKIP
        LD          A, C
;  START POINT X2
        LD          HL, [WORK_CIRCLE_CENTERX]
        LD          DE, [WORK_CIRCLE_CXOFF2]
        RRCA        
        JR          NC, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_CX2
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_CX2:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_CX2
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_CX2:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_CX2:
        LD          [WORK_GXPOS], HL
; 
;  START POINT Y2
        LD          HL, [WORK_CIRCLE_CENTERY]
        LD          DE, [WORK_CIRCLE_CYOFF2]
        RRCA        
        JR          NC, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_CY2
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_CY2:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_CY2
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_CY2:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_CY2:
        LD          [WORK_GYPOS], HL
        POP         AF
; 
        PUSH        AF
;  END POINT X2
        LD          HL, [WORK_CIRCLE_CENTERX]
        LD          DE, [WORK_CIRCLE_PREV_CXOFF2]
        RRCA        
        JR          NC, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCX2
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_PCX2:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_PCX2
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCX2:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_PCX2:
        LD          C, L
        LD          B, H
; 
;  END POINT Y2
        LD          HL, [WORK_CIRCLE_CENTERY]
        LD          DE, [WORK_CIRCLE_PREV_CYOFF2]
        RRCA        
        JR          NC, _SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCY2
_SUB_CIRCLE_QUADRANT_PROCESS_SUB_PCY2:
        SBC         HL, DE
        JR          _SUB_CIRCLE_QUADRANT_PROCESS_SET_PCY2
_SUB_CIRCLE_QUADRANT_PROCESS_ADD_PCY2:
        ADD         HL, DE
_SUB_CIRCLE_QUADRANT_PROCESS_SET_PCY2:
        EX          DE, HL
; 
        CALL        _SUB_CIRCLE_DRAW_LINE
_SUB_CIRCLE_QUADRANT_LINE2_SKIP:
        POP         AF
        RET         
; 
_SUB_CIRCLE_DRAW_LINE:
        LD          HL, [WORK_GXPOS]
        CALL        _SUB_CIRCLE_X_CLIP
        LD          [WORK_GXPOS], HL
        LD          L, C
        LD          H, B
        JR          C, _SUB_CIRCLE_X_REJECT_CHECK
        CALL        _SUB_CIRCLE_X_CLIP
        LD          C, L
        LD          B, H
        JR          _SUB_CIRCLE_DRAW_LINE_Y
_SUB_CIRCLE_X_REJECT_CHECK:
        CALL        _SUB_CIRCLE_X_CLIP
        LD          C, L
        LD          B, H
        JR          NC, _SUB_CIRCLE_DRAW_LINE_Y
        LD          A, [WORK_GXPOS+1]
        XOR         A, B
        RET         Z
_SUB_CIRCLE_DRAW_LINE_Y:
        LD          HL, [WORK_GYPOS]
        CALL        _SUB_CIRCLE_Y_CLIP
        LD          [WORK_GYPOS], HL
        LD          L, E
        LD          H, D
        JR          C, _SUB_CIRCLE_Y_REJECT_CHECK
        CALL        _SUB_CIRCLE_Y_CLIP
        LD          E, L
        LD          D, H
        JP          BIOS_LINE
_SUB_CIRCLE_Y_REJECT_CHECK:
        CALL        _SUB_CIRCLE_Y_CLIP
        LD          E, L
        LD          D, H
        JP          NC, BIOS_LINE
        LD          A, [WORK_GYPOS+1]
        XOR         A, B
        JP          NZ, BIOS_LINE
        RET         
; 
;  CLIPPING X-COORDINATES IN HL
;  IF CLIPPING, RETURN WITH CY=1
_SUB_CIRCLE_X_CLIP:
        LD          A, H
; 
        JR          NC, _SUB_CIRCLE_X_CLIP_SKIP1
        LD          HL, 0
        RET         
_SUB_CIRCLE_X_CLIP_SKIP1:
        LD          A, [WORK_ASPCT1 + 1]
        DEC         A
        CP          A, H
        RET         NC
        LD          HL, [WORK_ASPCT1]
        DEC         HL
        SCF         
        RET         
; 
;  CLIPPING Y-COORDINATES IN HL
;  IF CLIPPING, RETURN WITH CY=1
_SUB_CIRCLE_Y_CLIP:
        LD          A, H
; 
        JR          NC, _SUB_CIRCLE_Y_CLIP_SKIP1
        LD          HL, 0
        RET         
_SUB_CIRCLE_Y_CLIP_SKIP1:
        LD          A, H
        OR          A, A
        JR          Z, _SUB_CIRCLE_Y_CLIP_SKIP2
        LD          HL, 211
        LD          A, [WORK_RG9SAV]
; 
        RET         C
        LD          L, 191
        CCF         
        RET         
_SUB_CIRCLE_Y_CLIP_SKIP2:
        LD          A, L
        CP          A, 192
        CCF         
        RET         NC
        LD          A, [WORK_RG9SAV]
; 
        JR          NC, _SUB_CIRCLE_Y_CLIP_192
        LD          A, L
        CP          A, 212
        CCF         
        RET         NC
        LD          L, 211
        RET         
_SUB_CIRCLE_Y_CLIP_192:
        LD          L, 191
        SCF         
        RET         
; 
_SUB_CIRCLE_LINE_PROCESS:
;  CONNECT THE CENTER POINT AND THE END ANGLE WITH A LINE SEGMENT?
        LD          HL, [WORK_CRCSUM]
        LD          A, H
        OR          A, A
        CALL        NZ, _SUB_CIRCLE_DRAW_RADIUS
; 
_SUB_CIRCLE_END_LINE:
;  CONNECT THE CENTER POINT AND THE STARTING ANGLE WITH A LINE SEGMENT?
        LD          HL, [WORK_CPCNT]
        LD          A, H
        OR          A, A
        RET         Z
;  CORRECTION OF PROBLEMS WITH CLOCKWISE AND COUNTERCLOCKWISE SHIFT DEPENDING ON THE POSITION OF THE 8 QUADRANTS
        RRCA        
        XOR         A, L
        BIT         5, A
        LD          A, L
        JR          Z, _SUB_CIRCLE_DRAW_RADIUS
        LD          A, [WORK_CSCLXY]
        ADD         A, L
        LD          L, A
_SUB_CIRCLE_DRAW_RADIUS:
;  CORRECT ANGLE TO RESOLUTION
        LD          A, [WORK_CSCLXY]
        LD          H, A
        DEC         A
        CPL         
        AND         A, L
        LD          L, A
;  CORRECTION OF PROBLEMS WITH CLOCKWISE AND COUNTERCLOCKWISE SHIFT DEPENDING ON THE POSITION OF THE 8 QUADRANTS
        RRCA        
        XOR         A, L
        BIT         5, A
        LD          A, L
        JR          NZ, _SUB_CIRCLE_DRAW_RADIUS_SKIP1
        ADD         A, H
_SUB_CIRCLE_DRAW_RADIUS_SKIP1:
        PUSH        AF
        CALL        _SUB_CIRCLE_COS			; HL = COS(THETA)
        LD          BC, [WORK_CIRCLE_RADIUSX]
        CALL        _SUB_CIRCLE_MUL
        LD          [WORK_CIRCLE_CXOFF1], HL
        POP         AF
        CALL        _SUB_CIRCLE_SIN			; HL = SIN(THETA)
        LD          BC, [WORK_CIRCLE_RADIUSY]
        CALL        _SUB_CIRCLE_MUL
        LD          [WORK_CIRCLE_CYOFF1], HL
;  START POINT X1
        LD          HL, [WORK_CIRCLE_CENTERX]
        LD          DE, [WORK_CIRCLE_CXOFF1]
        ADD         HL, DE
        LD          [WORK_GXPOS], HL
;  START POINTY1
        LD          HL, [WORK_CIRCLE_CENTERY]
        LD          DE, [WORK_CIRCLE_CYOFF1]
        ADD         HL, DE
        LD          [WORK_GYPOS], HL
;  END POINT X1
        LD          BC, [WORK_CIRCLE_CENTERX]
;  I“_Y1
        LD          DE, [WORK_CIRCLE_CENTERY]
        JP          _SUB_CIRCLE_DRAW_LINE
        RET         
; 
; 	HL = HL * BC >> 8, HL IS SIGNED, BC IS UNSIGNED.
; 	   = (HL * C >> 8) + HL * B
_SUB_CIRCLE_MUL:
        LD          A, H
        OR          A, A
        PUSH        AF
        JP          P, _SUB_CIRCLE_SKIP_ABS
        CPL         
        LD          H, A
        LD          A, L
        CPL         
        LD          L, A
        INC         HL
_SUB_CIRCLE_SKIP_ABS:
        EX          DE, HL
        LD          HL, 0
        LD          A, 8
_SUB_CIRCLE_MUL_1ST8BIT:
        SLA         L
        RL          H
        SLA         C
        JR          NC, _SUB_CIRCLE_MUL_1ST8BIT_SKIP1
        ADD         HL, DE
_SUB_CIRCLE_MUL_1ST8BIT_SKIP1:
        DEC         A
        JR          NZ, _SUB_CIRCLE_MUL_1ST8BIT
        RL          L
        LD          L, H
        LD          H, 0
        JR          NC, _SUB_CIRCLE_MUL_2ND8BIT
        INC         HL
_SUB_CIRCLE_MUL_2ND8BIT:
        SRL         B
        JR          NC, _SUB_CIRCLE_MUL_2ND8BIT_SKIP1
        ADD         HL, DE
_SUB_CIRCLE_MUL_2ND8BIT_SKIP1:
        SLA         E
        RL          D
        INC         B
        DJNZ        _SUB_CIRCLE_MUL_2ND8BIT
        POP         AF
        RET         P
        LD          A, H
        CPL         
        LD          H, A
        LD          A, L
        CPL         
        LD          L, A
        INC         HL
        RET         
; 	GET COS(THETA): A = THETA (0:0[DEG]`256:360[DEG]) ¨ A = COS(THETA)
_SUB_CIRCLE_COS:
        SUB         A, 64
; 	SINƒÆ‚ð•Ô‚·: A = THETA (0:0[DEG]`256:360[DEG]) ¨ A = SIN(THETA)
_SUB_CIRCLE_SIN:
        LD          B, A
        AND         A, 0X3F
        LD          A, B
        JR          Z, _SUB_CIRCLE_SIN_SPECIAL
        BIT         6, A
        JR          Z, _SUB_CIRCLE_SIN_SKIP1
        NEG         
_SUB_CIRCLE_SIN_SKIP1:
        AND         A, 0X3F
        ADD         A, WORK_BUF & 0X0FF
        LD          L, A
        LD          H, WORK_BUF >> 8
        LD          A, [HL]
        LD          H, 0
        LD          L, A
        RL          B
        RET         C
        CPL         
        DEC         H
        LD          L, A
        INC         HL
        RET         
_SUB_CIRCLE_SIN_SPECIAL:
        LD          HL, 0
        BIT         6, A
        RET         Z
        INC         H
; 
        RET         C
        DEC         H
        DEC         H
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
        INC         HL
        LD          D, [HL]
        INC         HL
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
CONST_42407437:
        DEFB        0X42, 0X40, 0X74, 0X37
STR_0:
        DEFB        0X00
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
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
