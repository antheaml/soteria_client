#include <xc.inc>
	
global Client_Int_Hi, Client_Interrupt_Setup, client_fall, client_alert, client_disable

; ---------- Module controlling the fall interrupt and button responses of the client device ---------- ;

psect	int_code, class=CODE
    
Client_Interrupt_Setup: 
	; ****************************************************
	; ----- Subroutine to set up RB interrupts for the IMU
	; ****************************************************
	movlw	0xFF
	movwf	TRISB, A 	; enable RB pins as inputs
	bsf	RBIE		; Enable RB interrupt				   
	bsf	GIE		; Enable all interrupts
	return

Client_Int_Hi:
	; ******************************************************
	; ----- Subroutine called when RB interrupt is triggered
	; ******************************************************
	BTFSS	RBIF		; check that this is RB interrupt		 
	retfie	f		; if not then return
	call	client_fall
	bcf	RBIF		; clear interrupt flag
	retfie	f		; fast return from interrupt	
	
client_fall:
	; *****************************************
	; ----- Subroutine called when client falls
	; *****************************************
        bcf     PORTH, 2, A ; turn off disable signal
        bcf     PORTH, 5, A ; turn off disable LED
        bcf	PORTH, 1, A ; turn off alert signal 
        bcf     PORTH, 4, A ; turn off alert LED
        bsf     PORTH, 0, A ; turn on fall signal
        bsf	PORTH, 0, A ; turn on fall LED
	NOP		    ; NOPs required so there is enough time for the nurse to pick up the signal
        NOP	
        NOP
        NOP
        bcf     PORTH, 0, A ; turn off fall signal to nurse
        return

client_alert:
	; ***********************************************************
	; ----- Subroutine called when client alert button is pressed
	; ***********************************************************
	bcf	PORTH, 2, A ; turn off disable signal
	bcf	PORTH, 5, A ; turn off disable LED
	bcf	PORTH, 0, A ; turn off fall signal
	bcf	PORTH, 3, A ; turn off fall LED
	bsf	PORTH, 1, A ; turn on alert signal
	bsf	PORTH, 4, A ; turn on alert LED
	NOP		    ; NOPs required so there is enough time for the nurse to pick up the signal
	NOP	
	NOP
	NOP
	bcf     PORTH, 1, A ; turn off alert signal to nurse			   
	return

client_disable:	
	; *************************************************************
	; ----- Subroutine called when client disable button is pressed
	; *************************************************************
    	bcf	PORTH, 1, A ; turn off alert signal
    	bcf	PORTH, 4, A ; turn off alert LED
   	bcf	PORTH, 0, A ; turn off fall signal
    	bcf	PORTH, 3, A ; turn off fall LED
    	bsf	PORTH, 2, A ; turn on disable signal
    	bsf	PORTH, 5, A ; turn on disable LED
    	NOP		    ; NOPs required so there is enough time for the nurse to pick up the signal
    	NOP	
    	NOP
    	NOP
    	bcf     PORTH, 2, A ; turn off disable signal to nurse					    
    	return
