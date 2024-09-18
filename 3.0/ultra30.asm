    ORG $2100
    ICL 'BASE/SYS_EQUATES.M65'
    ICL 'KEM2.ASM'
    ICL 'MEM.ASM'
    ICL 'HEXASCII.ASM'
SISTEMA
    .BY 5
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
    .SB "| MEMORIA DISPONIBLE |         ******* |"
    .SB "| BANCOS DISPONIBLES |             *** |"
    .SB "| PORTB EN USO       |             "
MUESTROPORTB
    .SB "*** |"
    .SB "| SISTEMA EN USO     |          "
MUESTROSISTEMA
    .SB "****** |"
    .SB "| BAUD A GRABAR      |            "
MUESTROBAUD
    .SB "**** |"
    .SB "| BYTES LEIDOS       |         ******* |"
    .SB "| BLOQUES A GRABAR   |            **** |"
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
    JSR ESPORTB
    JSR CUALSISTEMA
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




    LDA BANKOS

    RTS














































    RUN INICIO