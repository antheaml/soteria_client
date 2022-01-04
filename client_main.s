;;; CLIENT CODE
#include <xc.inc>

extrn	SPI_MasterInit, SPI_MasterTransmit, SPI_MasterRead, UART_Setup, UART_Transmit_Byte;, read_byte1
    
psect	code, abs
	
rst:	org	0x0000	; reset vector
	goto	clientSetup
	
int_hi:	org	0x0008	; High priority interrupt
	goto	DAC_Int_Hi
	
Client_Int_Hi:	
	call	Client_Interrupt_Setup ; Set up interrupt
	call	Client_Led_Setup ; Set up LEDs NEED TO WRITE
	call	client_imuSetup
	goto	$	; Sit in infinite loop

main:
    goto    $

Client_Led_Setup:
    bcf	    PORTD, 4, A ; enable RD4 (fall LED) as output
    bcf	    PORTE, 4, A ; enable RE4 (alert button) as output
    

test_read:
    ;################# CHIP_ID address 0x00 but MSB = 1 (Read)
    call    NOP_delay
    call    NOP_delay
    bcf	    PORTE, 0, A		; pull CSB low - start message
    call    NOP_delay
    call    NOP_delay
    ;bsf	    TRISC, 4, A ; set RC4 as input, since this will be recieving data from the slave ???????????
    movlw   0b10000000	; chip id register
    ;movlw   0xff
    ;movlw   0b10101010
    ;movlw   0b10000011	; pmu status
    call    SPI_MasterTransmit
    movlw   0b00000000 ; so we don't write anything while trying to read
    ;call    NOP_delay
    ;call    NOP_delay
    call    SPI_MasterRead
    bsf	    PORTE, 0, A		; pull CSB high - end message
    ;movff   read_byte1, WREG   
    call    UART_Transmit_Byte
    return
 

end	rst

   
