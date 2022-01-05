;;; CLIENT CODE
#include <xc.inc>

extrn	SPI_MasterInit, SPI_MasterTransmit, SPI_MasterRead, UART_Setup, UART_Transmit_Byte, Client_Int_Hi

; ---------- Module controlling the set-up and standby state of the client device ---------- ;

psect	code, abs
	
rst:	org	0x0000	; reset vector
	goto	clientSetup
	
int_hi:	org	0x0008	; High priority interrupt
	goto	Client_Int_Hi

clientSetup:	
	call	Client_pin_Setup ; enable pins as inputs and outputs, turn on standby led
	call	Client_Interrupt_Setup ; Set up interrupt
	call	Client_Led_Setup ; Set up LEDs NEED TO WRITE
	call	client_imuSetup
	goto	client_main_polling
	
client_main_polling: 
    ; *************************************************************************************************
    ; ----- Looping subroutine which tests the logic level of RD1:2 to determine if the alert or
    ; ----- disable buttons are pressed on the client device
    ; ----- Logic:
    ; -----		Fall occurs -> PORTB0 high -> interrupt triggered -> go to Client_Int_Hi 
    ; -----		Alert button pressed -> PORTD1 high -> call alert subroutine 
    ; ----- 		Disable button pressed -> PORTD2 high -> call disable subroutine triggered
    ; ----- BTFSC = bit test f, skip if clear
    ; *************************************************************************************************
    
    BTFSC   PORTD, 1, A 
    call    client_alert
    BTFSC   PORTD, 0, A 
    call    nurse_fall
    BTFSC   PORTD, 2, A 
    call    nurse_remote_disable
    bra     polling_main ; loop
	goto	$	; Sit in infinite loop


Client_pin_Setup:
	; Enable RH0:2 pins as outputs
	bcf	TRISH, 0, A
	bcf	TRISH, 1, A
	bcf	TRISH, 2, A
	; Turn on disable LED
	bsf	PORTH, 2, A
	; Enable RD1:2 as inputs
	bsf	TRISD, 1, A
	bsf	TRISD, 2, A
	return
  
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

   
