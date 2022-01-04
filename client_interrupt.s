#include <xc.inc>
	
global DAC_Int_Hi, Interrupt_Setup
    
extrn	nurse_fall, nurse_alert, nurse_remote_disable
        
psect udata_acs
delay_counter1:	    ds 1
delay_counter2:	    ds 1
alert_code:	    ds 1

psect	dac_code, class=CODE
    
Client_Interrupt_Setup: ; used to be DAC_Setup
	; need to rewrite and set up based on how the client is wired up
	movlw	0xFF
	movwf	TRISB, A ; enable RB pins as inputs
	movlw	0x00
	movwf	TRISH, A ; enable H pins as outputs
	bsf	RBIE		; Enable RB interrupt				    Not sure if these codes are compatable with the clicker, need to check, not in manual online?
	bsf	GIE		; Enable all interrupts
	return

Client_Int_Hi:	; used to be DAC_Int_Hi
	btfss	RBIF		; check that this is RB interrupt		    Is this the same for the clicker?
	retfie	f		; if not then return
	; logic to figure out which subroutine to call depending on signal
	BTFSC	PORTB, 0, A  ;bit test RB0, skip if clear - alert button
	goto    client_alert
	BTFSC	PORTB, 1, A  ;bit test RB1, skip if clear - disable button
	goto	client_disable
	call	client_fall
end_Client_Int_Hi:
	bcf	RBIF		; clear interrupt flag
	retfie	f		; fast return from interrupt	
	
client_fall:
    bsf	    PORTH, 4, A ; make RH4 high (stays high until disable)		   
    bsf	    PORTD, 4, A ; turn on fall LED
    return
	; write interrupt subroutine that is called when fall 
	    ; RB0 which triggers
	    ; make RH0 high (stays high)
	    ; RH4 connects RB0 on nurse
	        
client_alert:	 
    bsf	    PORTH, 1, A ; make RH7 high (stays high)				   
    bsf	    PORTE, 4, A ; turn on alert button LED
    goto    end_Client_Int_Hi
	; write interrupt subroutine this is called when alert button pressed
	    ; RB1 which triggers
	    ; make RH1 high (stays high)
	    ; RH1 connects RB1 on nurse
client_disable:	
    bcf	    PORTH, 4, A ; make RH4 low						  
    bcf	    PORTH, 7, A ; make RH7 low						    
    bcf	    PORTD, 4, A ; turn fall LED off
    bcf	    PORTE, 4, A ; turn alert LED off
    goto    end_Client_Int_Hi
	; write interrupt subroutine this is called when disable button pressed
	    ; RB2 which triggers
	    ; make RH2 high (stays high)
	    ; RH2 connects RB2 on nurse



