;************************************************
;VALORES PRINCIPALES QUE REGULA LOS BAUDIOS
;CODIGO DONADO POR WILLYSOFT
;************************************************
B00600 	= $05CC		;TIMER  600 BPS
B00800 	= $0458  	;TIMER  800 BPS
B00900  = $03DB     ;TIMER  900 BPS
B00990 	= $0381  	;TIMER  990 BPS
B01150 	= $0303  	;TIMER 1150 BPS
B01400	= $0278		;TIMER 1400 BPS    
    ORG $2000
    ICL 'BASE/SYS_EQUATES.M65'
    ICL 'KEM2.ASM'
    ICL 'MEM.ASM'
    ICL 'HEXASCII.ASM'
NHP
    .SB "   NHP"    ;600 BAUDIOS
NHP8
    .SB "NHP800"    ;800 BAUDIOS
NHP9
    .SB "NHP900"    ;900 BAUDIOS
STAC
    .SB "  STAC"    ;990 BAUDIOS SOLO XC11
ULTRA
    .SB " ULTRA"    ;1150 BAUDIOS SOLO XC11
SUPER
    .SB " SUPER"    ;1400 BAUDIOS SOLO EMULADORES
SISTEMA
    .BY 0
GRABANDOOPEN
    .SB +128,"  PRESIONE  RETURN  "
GRABANDOINICIO
    .SB +128,"  GRABANDO  INICIO  "
GRABANDOLOADER
    .SB +128,"  GRABANDO  LOADER  "
GRABANDOJUEGO
    .SB +128,"  GRABANDO ARCHIVO  "
DLS
:3  .BY $70
    .BY $46
    .WO SHOW
    .BY $70
:21  .BY $02
    .BY $41
    .WO DLS
SHOW
    .SB " "
    .SB +128,"dogdark"
    .SB "  softwares "
    .SB +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
    .SB "| DOGCOPY ULTRA V 3.0  BY DOGDARK 2024 |"
    .SB +32,"ARRRRRRRRRRRRRRRRRRRRRRRRRRRWRRRRRRRRRRD"
    .SB "| MEMORIA DISPONIBLE        | "
MEMORIADISPONIBLE
    .SB "******** |"
    .SB "| BANCOS DISPONIBLES        |      "
BANCOSDISPONIBLES
    .SB "*** |"
    .SB "| PORTB EN USO              |      "
PORTBENUSO    
    .SB "*** |"
    .SB "| BYTES LEIDOS              | "
BYTESLEIDOS
    .SB "******** |"
    .SB "| BLOQUES TOTALES           |     "
BLOQUESTOTALES
    .SB "**** |"
    .SB "| SISTEMA A GRABAR          |   "
SISTEMAAGRABAR    
    .SB "****** |"
    .SB +32,"ARRRRRRRRRRRWRRRRRRRRRRRRRRRXRRRRRRRRRRD"
    .SB "| TITULO 01 | "
TITULO01    
    .SB "********************     |"
    .SB "| TITULO 02 | "
TITULO02    
    .SB "********************     |"
    .SB "| UNIDAD    | "
UNIDAD
    .SB "********************     |"
    .SB +32,"ZRRRRRRRRRRRXRRRRRRRRRRRRRRRRRRRRRRRRRRC"
DATA
    .SB "DATA************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "****************************************"
    .SB "*************************************FIN"
START
    LDX #<DLS
    LDY #>DLS
    STX $230
    STY $231
    LDA #$80
    STA 710
    STA 712
    JSR LIMPIO

;************************************************
;ABRO PERIFERICO CASETTE
;************************************************
;
    LDX #19
ABROPERIFERICO
    LDA GRABANDOOPEN,X 
    STA UNIDAD,X 
    DEX
    BPL ABROPERIFERICO
    JMP *
INICIO
    JSR KEM
    JSR MEM
    LDA #$00
    STA SISTEMA

    JMP START
    


;************************************************
;FUNCIONES DEL SISTEMA
;************************************************
;
LIMPIO
    LDX #39
    LDA #$00
LIMPIO2
    STA DATA,X
    STA DATA+40,X
    STA DATA+80,X
    STA DATA+120,X
    STA DATA+160,X
    STA DATA+200,X
    STA DATA+240,X
    DEX
    BPL LIMPIO2
    LDX #19
LIMPIO3
    STA TITULO01,X
    STA TITULO02,X 
    STA UNIDAD,X 
    DEX
    BPL LIMPIO3
    LDA #$3F
    STA TITULO01
    STA TITULO02
    STA UNIDAD
    JSR VALIDOSISTEMA
    JSR CUENTOMEMORIA
    JSR VEOPORTB
    JSR VEOBYTESLEIDOS
    JSR VEOBLOKES
    RTS
;************************************************
;FUNCION PARA REGULAR LA VELOCIDAD AL GRABAR
;************************************************
;
BAUD.600
	LDA # <B00600
	JSR BAUD.M1
	LDA # >B00600
	JMP BAUD.M2
BAUD.800
	LDA # <B00800
	JSR BAUD.M1
	LDA # >B00800
	JMP BAUD.M2
BAUD.900
    LDA # <B00900
	JSR BAUD.M1
	LDA # >B00900
	JMP BAUD.M2
BAUD.990
	LDA # <B00990
	JSR BAUD.M1
	LDA # >B00990
	JMP BAUD.M2
BAUD.1150
	LDA # <B01150
	JSR BAUD.M1
	LDA # >B01150
	JMP BAUD.M2
BAUD.1400
	LDA # <B01400
	JSR BAUD.M1
	LDA # >B01400
BAUD.M2
	STA $EBA8
	STA $FD46
	STA $FCE1
	RTS
BAUD.M1
	STA $EBA3
	STA $FD41
	STA $FCDC
	RTS
;************************************************
; VALIDO LA VELOCIDAD A GRABAR Y MUESTRO EN 
; PANTALLA
;************************************************
VALIDOSISTEMA
    LDX #5
    LDA SISTEMA
    CMP #0
    BEQ ESNHP
    CMP #1
    BEQ ESNHP8
    CMP #2
    BEQ ESNHP9
    CMP #3 
    BEQ ESSTAC
    CMP #4
    BEQ ESULTRA
    JMP ESSUPER
ESNHP
    LDA NHP,X
    STA SISTEMAAGRABAR,X
    DEX
    BPL ESNHP
    RTS
ESNHP8
    LDA NHP8,X
    STA SISTEMAAGRABAR,X
    DEX
    BPL ESNHP8
    RTS
ESNHP9
    LDA NHP9,X
    STA SISTEMAAGRABAR,X
    DEX
    BPL ESNHP9
    RTS
ESSTAC
    LDA STAC,X
    STA SISTEMAAGRABAR,X
    DEX
    BPL ESSTAC
    RTS
ESULTRA
    LDA ULTRA,X
    STA SISTEMAAGRABAR,X
    DEX
    BPL ESULTRA
    RTS
ESSUPER
    LDA SUPER,X
    STA SISTEMAAGRABAR,X
    DEX
    BPL ESSUPER
    RTS
CUENTOMEMORIA
    JSR LIMPIOVAL
    LDA MEMORIA
    STA VAL
    LDA MEMORIA+1
    STA VAL+1
    LDA MEMORIA+2
    STA VAL+2
    JSR BIN2BCD
    LDX #7
CUENTOMEMORIA1
    LDA RESATASCII,X
    STA MEMORIADISPONIBLE,X 
    DEX
    BPL CUENTOMEMORIA1
    JSR LIMPIOVAL
    LDA BANKOS
    STA VAL
    JSR BIN2BCD
    LDY #7
    LDX #2
CUENTOMEMORIA2
    LDA RESATASCII,Y
    STA BANCOSDISPONIBLES,X 
    DEY
    DEX
    BPL CUENTOMEMORIA2
    RTS
VEOPORTB
    JSR LIMPIOVAL
    LDA PORTB
    STA VAL
    JSR BIN2BCD
    LDY #7
    LDX #2
VEOPORTB1
    LDA RESATASCII,Y
    STA PORTBENUSO,X 
    DEY
    DEX
    BPL VEOPORTB1
    RTS
VEOBYTESLEIDOS
    LDA #$10
    LDX #7
VEOBYTESLEIDOS1
    STA BYTESLEIDOS,X
    DEX
    BPL VEOBYTESLEIDOS1
    RTS
VEOBLOKES
    LDA #$10
    LDX #3
VEOBLOKES1
    STA BLOQUESTOTALES,X
    DEX
    BPL VEOBLOKES1
    RTS






    RUN INICIO