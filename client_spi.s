#include <xc.inc>
    
global	SPI_MasterInit, SPI_MasterTransmit, SPI_MasterRead ;, read_byte1

;;;; code to set up the IMU
    
psect	spi_code, class=CODE
    
client_imuSetup:
    call    INT_EN
    call    INT_OUT_CTRL
    call    INT_MAP
    call    INT_LOW_HIGH
    return

INT_EN: ; Instructions sent to configure INT_EN register of IMU
    ;################# INT_EN[0]
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x50 ; IF WE EVER WANT TO READ, CHANGE MSB TO 1 
    call    SPI_MasterTransmit
    movlw   0b00000000
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A    
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ; pull CSB high - stop message
    ;################# INT_EN[1]
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x51
    call    SPI_MasterTransmit
    movlw   0b00001111 
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ;################# INT_EN[2]
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x52
    call    SPI_MasterTransmit
    movlw   0b00000000
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    return

INT_OUT_CTRL: ; Instructions sent to configure INT_OUT_CTRL register of IMU
    ;################# INT_OUT_CTRL
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x53
    call    SPI_MasterTransmit
    movlw   0b10100000
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    return
    
    
INT_MAP: ; Instructions sent to configure INT_MAP register of IMU
    ;################# INT_MAP[0]
    bcf	    PORTD, 3, A		; pull CSB low - start message  CSB = RD3
    movlw   0x55 ; IF WE EVER WANT TO READ, CHANGE MSB TO 1 
    call    SPI_MasterTransmit
    movlw   0b00000000;0b11111111; 0b00000000
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ;################# INT_MAP[1]
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x56
    call    SPI_MasterTransmit
    movlw   0b00000000;0b11110000; 
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ;################# INT_MAP[2]
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x57
    call    SPI_MasterTransmit
    movlw   0b00000001;0b00000000 ; 0b00000001
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    return
      
INT_LOWHIGH: ; Instructions sent to configure INT_LOWHIGH register of IMU
    ;################# INT_LOWHIGH[0] - delay time 
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x5A ;
    call    SPI_MasterTransmit
    movlw   0b00000001 ;							     NEEDS TESTING
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ;################# INT_LOWHIGH[1] - threshold definition
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x5B
    call    SPI_MasterTransmit
    movlw   0b00000011 ;							     NEEDS TESTING
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ;################# INT_LOWHIGH[2]
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x5C
    call    SPI_MasterTransmit
    movlw   0b00000001 ;							     NEEDS TESTING
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ; Don't know if we need to write to these registers or not
    ;################# INT_LOWHIGH[3] - delay time for high g interrupt 
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x5D
    call    SPI_MasterTransmit
    movlw   0b00000000 ;							      
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    ;################# INT_LOWHIGH[4] - threshold for high g interrupt 
    bcf	    PORTD, 3, A		; pull CSB low - start message
    movlw   0x5D
    call    SPI_MasterTransmit
    movlw   0b00000000 ;							      
    call    SPI_MasterTransmit
    bsf	    PORTD, 3, A		; pull CSB high - stop message
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    call    NOP_delay
    return
    
NOP_delay: ; 4 clock cycle delay made up of NOPs
    ;1
    nop
    nop
    nop
    nop
    ;2
    nop
    nop
    nop
    nop
    ;3
    nop
    nop
    nop
    nop
    ;4
    nop
    nop
    nop
    nop
    return
    
    
;;;; Code to send SPI communication
    
SPI_MasterInit:	; Set Clock edge to negative
	bcf	CKE1	; CKE bit in SSP2STAT, 
	;MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw 	(SSP1CON1_SSPEN_MASK)|(SSP1CON1_CKP_MASK)|(SSP1CON1_SSPM1_MASK)
	movwf 	SSP1CON1, A
	; SDO2 output; SCK2 output
	bcf	TRISC, PORTC_SDO1_POSN, A	; SDO2 output #### can just wire up port e pins to port c 
	bcf	TRISC, PORTC_SCK1_POSN, A	; SCK2 output
	;bsf	TRISC, PORTC_SDI1_POSN, A
	;######### added by us
	bcf	TRISD, 3, A ;; think this is right? changed E -> D for csb
	bsf	PORTD, 3, A
	;######### added by us
	return

SPI_MasterTransmit:  ; Start transmission of data (held in W)
	movwf 	SSP1BUF, A 	; write data to output buffer
Wait_Transmit:	; Wait for transmission to complete 
	btfss 	SSP1IF		; check interrupt flag to see if data has been sent
	bra 	Wait_Transmit
	bcf 	SSP1IF		; clear interrupt flag
	return

SPI_MasterRead:
	movwf	SSP1BUF, A ; send register we would like to access
Wait_Read:	; Wait for transmission + read to complete 
	btfss 	SSP1IF	; check interrupt flag to see if data has been sent
	bra 	Wait_Read
	;movff	SSP1BUF, read_byte1, A	    ; load SSP2BUF to read_byte1
Send_to_Master:
	movff	SSP1BUF, WREG, A
	bcf 	SSP1IF		; clear interrupt flag
	return


