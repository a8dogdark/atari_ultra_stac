PCRSR = $CB    
    ORG $2100
    ICL 'BASE/SYS_EQUATES.M65'
    ICL 'KEM2.ASM'
    ICL 'MEM.ASM'
    ICL 'HEXASCII.ASM'
SISTEMA
    .BY 0
BYTESLEIDOS
    .BY 0,0,0
BANCOSTOTALES
    .BY 0,0
DLS
:3  .BY $70
    .BY $46
    .WO SHOW
    .BY $70
:22 .BY $02
    .BY $41
    .WO DLS
SHOW
    .SB " "
    .SB +128,"dogdark"
    .SB "  softwares "
    .SB +32,"QRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRE"
    .SB "| DOGCOPY ULTRA V 3.0  BY DOGDARK 2024 |"
    .SB +32,"ARRRRRRRRRRRRRRRRRRRRWRRRRRRRRRRRRRRRRRD"
    .SB "| MEMORIA DISPONIBLE |        "
MUESTROMEMORIADISPONIBLE
    .SB "******** |"
    .SB "| BANCOS DISPONIBLES |             "
MUESTROBANCOSDISPONIBLES
    .SB "*** |"
    .SB "| PORTB EN USO       |             "
MUESTROPORTB
    .SB "*** |"
    .SB "| SISTEMA EN USO     |          "
MUESTROSISTEMA
    .SB "****** |"
    .SB "| BAUD A GRABAR      |            "
MUESTROBAUD
    .SB "**** |"
    .SB "| BYTES LEIDOS       |         "
MUESTROBYTESLEIDOS
    .SB "******* |"
    .SB "| BLOQUES A GRABAR   |            "
MUESTROBLOQUESLEIDOS
    .SB "**** |"
    .SB +32,"ARRRRRRRRRRRWRRRRRRRRXRRRRRRRRRRRRRRRRRD"
    .SB "| TITULO 01 | "
TITULO01
    .SB "********************     |"
    .SB "| TITULO 02 | "
TITULO02
    .SB "********************     |"
    .SB     "| FUENTE    | "
FUENTE
    .SB "********************     |"
    .SB +32,"ZRRRRRRRRRRRXRRRRRRRRRRRRRRRRRRRRRRRRRRC"
MUESTRODATA
    .SB "DATA************************************" ;40
    .SB "****************************************" ;80
    .SB "****************************************" ;120
    .SB "****************************************" ;160
    .SB "****************************************" ;200
    .SB "****************************************" ;240
    .SB "*************************************FIN" ;250
NHP
    .SB "   NHP"
NHP8
    .SB "  NHP8"
NHP9
    .SB "NHP900"
NHPSTAC
    .SB "  STAC"
NHPULTRA
    .SB " ULTRA"
NHPSUPER
    .SB " SUPER"

BAUDIOS600
    .SB "0600"
BAUDIOS800
    .SB "0800"
BAUDIOS900
    .SB "0900"
BAUDIOSSTAC
    .SB "0990"
BAUDIOSULTRA
    .SB "1150"
BAUDIOSSUPER
    .SB "1400"
RY
	.BYTE 0,0,0
;************************************************
;FUNCION QUE NOS PERMITE PODER CONVERTIR UN BYTE
;EN ATASCII, USADO PARA INGRESO DE TITULOS Y
;FUENTE, NO TIENE LIMITACIONES MAYORES EN LAS
;PULSACIONES DEL TECLADO
;************************************************
ASCINT
	CMP #32
	BCC ADD64
	CMP #96
	BCC SUB32
	CMP #128
	BCC REMAIN
	CMP #160
	BCC ADD64
	CMP #224
	BCC SUB32
	BCS REMAIN
ADD64
	CLC
	ADC #64
	BCC REMAIN
SUB32
	SEC
	SBC #32
REMAIN
	RTS
;************************************************
;FUNCION QUE CIERRA PERIFERICOS
;************************************************
CLOSE
	LDX #$10
	LDA #$0C
	STA $0342,X
	JMP $E456
;************************************************
;CURSOR PARPADEANTE
;************************************************
FLSH
	LDY RY
	LDA (PCRSR),Y
	EOR #63
	STA (PCRSR),Y
	LDA #$10
	STA $021A
	RTS
;************************************************
;ABRE PERIFERICO TECLADO
;************************************************
OPENK
	LDA #255
	STA 764
	LDX #$10
	LDA #$03
	STA $0342,X
	STA $0345,X
	LDA #$26
	STA $0344,X
	LDA #$04
	STA $034A,X
	JSR $E456
	LDA #$07
	STA $0342,X
	LDA #$00
	STA $0348,X
	STA $0349,X
	STA RY
	RTS
;************************************************
;RUTINA QUE LEE LO TECLEADO
;************************************************
RUTLEE
	LDX # <FLSH
	LDY # >FLSH
	LDA #$10
	STX $0228
	STY $0229
	STA $021A
	JSR OPENK
GETEC
	JSR $E456
	CMP #$7E
	BNE C0
	LDY RY
	BEQ GETEC
	LDA #$00
	STA (PCRSR),Y
	LDA #63		;$3F
	DEY
	STA (PCRSR),Y
	DEC RY
	JMP GETEC
C0
	CMP #155	;$9B
	BEQ C2
	JSR ASCINT
	LDY RY
	STA (PCRSR),Y
	CPY #20		;#14
	BEQ C1
	INC RY
C1
	JMP GETEC
C2
	JSR CLOSE
	LDA #$00
	STA $021A
	LDY RY
	STA (PCRSR),Y
	RTS
;************************************************
;DISPLAY DE INICIO DEL PROGRAMA Y FUNCIONALIDAD
;DIRECTA A TODAS SUS FUNCIONES
;************************************************
DOS
	JMP ($0C)
@START
	JSR DOS
START
    LDX #<DLS
    LDY #>DLS
    STX $230
    STY $231
    LDA #$60
    STA 710
    STA 712
    JSR LIMPIO
//***********************************************
// Vamos a poner una interrupcion VBI aqui
//***********************************************
	ldy #<VBI
	ldx #>VBI
	lda #$07	; Diferida
	jsr SETVBV	;Setea

;************************************************
;INGRESAMOS EL TITULO 01
;************************************************
	LDX # <TITULO01
	LDY # >TITULO01
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
;************************************************
;INGRESAMOS EL TITULO 02
;************************************************
	LDX # <TITULO02
	LDY # >TITULO02
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
;************************************************
;INGRESAMOS EL TITULO 01
;************************************************
	LDX # <FUENTE
	LDY # >FUENTE
	STX PCRSR
	STY PCRSR+1
	JSR RUTLEE
    JMP *

INICIO
    JSR KEM
    JSR MEM
    LDX # <@START
	LDY # >@START
	LDA #$03
	STX $02
	STY $03
	STA $09
	LDY #$FF
	STY $08
	INY   
	STY $0244
    JMP START
LIMPIO
    LDX #19
    LDA #$00
LIMPIO2
    STA TITULO01,X
    STA TITULO02,X
    STA FUENTE,X
    DEX
    BPL LIMPIO2
    LDA #63
    STA TITULO01
    STA TITULO02
    STA FUENTE
    JSR ESPORTB
    JSR CUALSISTEMA
    LDX #6
    LDA #$10
LIMPIO3
    STA MUESTROBYTESLEIDOS,X
    DEX
    BPL LIMPIO3
    LDX #3
LIMPIO4
    STA MUESTROBLOQUESLEIDOS,X
    DEX
    BPL LIMPIO4
    JSR LIMPIODATA
    JSR CALCULOMEMORIA
    JSR CALCULOBANCOS
    RTS
LIMPIODATA
    LDX #39
    LDA #$00
LIMPIODATA1
    STA MUESTRODATA,X
    STA MUESTRODATA+40,X
    STA MUESTRODATA+80,X
    STA MUESTRODATA+120,X
    STA MUESTRODATA+160,X
    STA MUESTRODATA+200,X
    STA MUESTRODATA+240,X
    DEX
    BPL LIMPIODATA1
    RTS

ESPORTB
    JSR LIMPIOVAL
    LDA PORTB
    STA VAL
    JSR BIN2BCD
    LDY #7
    LDX #2
ESPORTB1
    LDA RESATASCII,Y
    STA MUESTROPORTB,X
    DEY
    DEX
    BPL ESPORTB1
    RTS
CUALSISTEMA
    LDA #<NHP
    LDX #>NHP
    LDY SISTEMA
    CPY #0
    BEQ FINSISTEMA
    LDA #<NHP8
    LDX #>NHP8
    CPY #1
    BEQ FINSISTEMA
    LDA #<NHP9
    LDX #>NHP9
    CPY #2
    BEQ FINSISTEMA
    LDA #<NHPSTAC
    LDX #>NHPSTAC
    CPY #3
    BEQ FINSISTEMA
    LDA #<NHPULTRA
    LDX #>NHPULTRA
    CPY #4
    BEQ FINSISTEMA
    LDA #<NHPSUPER
    LDX #>NHPSUPER
FINSISTEMA
    STA FINSISTEMA2+1
    STX FINSISTEMA2+2
    LDX #5
FINSISTEMA2
    LDA NHP,X
    STA MUESTROSISTEMA,X
    DEX
    BPL FINSISTEMA2
    LDA #<BAUDIOS600
    LDX #>BAUDIOS600
    CPY #0
    BEQ FINBAUDIOS
    LDA #<BAUDIOS800
    LDX #>BAUDIOS800
    CPY #1
    BEQ FINBAUDIOS
    LDA #<BAUDIOS900
    LDX #>BAUDIOS900
    CPY #2
    BEQ FINBAUDIOS
    LDA #<BAUDIOSSTAC
    LDX #>BAUDIOSSTAC
    CPY #3
    BEQ FINBAUDIOS
    LDA #<BAUDIOSULTRA
    LDX #>BAUDIOSULTRA
    CPY #4
    BEQ FINBAUDIOS
    LDA #<BAUDIOSSUPER
    LDX #>BAUDIOSSUPER
FINBAUDIOS
    STA FINBAUDIOS2+1
    STX FINBAUDIOS2+2
    LDX #3
FINBAUDIOS2
    LDA BAUDIOS600,X
    STA MUESTROBAUD,X
    DEX
    BPL FINBAUDIOS2
    RTS

CALCULOMEMORIA

    JSR LIMPIOVAL
    LDA MEMORIA
    STA VAL
    LDA MEMORIA+1
    STA VAL+1
    LDA MEMORIA+2
    STA VAL+2
    JSR BIN2BCD
    LDX #7
CALCULOMEMORIA1
    LDA RESATASCII,X
    STA MUESTROMEMORIADISPONIBLE,X
    DEX
    BPL CALCULOMEMORIA1
    RTS
    
CALCULOBANCOS
    JSR LIMPIOVAL
    LDA BANKOS
    STA VAL
    JSR BIN2BCD
    LDX #2
    LDY #7
CALCULOBANCOS1
    LDA RESATASCII,Y
    STA MUESTROBANCOSDISPONIBLES,X
    DEY
    DEX
    BPL CALCULOBANCOS1
    RTS

.PROC VBI
    LDA CONSOL
    CMP CONSOLA_ANTERIOR
    BEQ FINOPTION
    STA CONSOLA_ANTERIOR
    CMP #$03
    BNE FINOPTION

ESOPTION
    LDY SISTEMA
    CPY #6
    BEQ SISTEMAA0
    INY
    STY SISTEMA
ESOPTION2
    JSR CUALSISTEMA
FINOPTION
	JMP $E462
SISTEMAA0
    LDY #0
    STY SISTEMA
    JMP ESOPTION2
CONSOLA_ANTERIOR
    .BY $00
.ENDP
    RTS














































    RUN INICIO