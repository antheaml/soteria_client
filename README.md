# Soteria - Fall detection system - Client device

## Project description
This code forms one half of the code required for the alpha-prototype of the Soteria fall detection system. Soteria provides a solution to the delay between a fall occurring in an at-risk individual and a trusted responder arriving on the scene. The at-risk individual wears the _Client_ device which is equipped with an accelerometer to detect falling motion, alongside an alert button, and a button to disable the alarm system. The _Client_ is paired with the _Nurse_ device which features an LCD screen, LEDs, and a buzzer to provide the user with information about whether the at-risk individual has fallen or is in need of aid. 

## Hardware
The client and nurse devices are based on MikroElectronika's EasyPIC PRO V7.0 development boards, which are mounted with the PIC18F87K22 microprocessor. Mikroelektronika's 6 DOF IMU 2 Click, which comes mounted with the BMI160 microprocessor, is attached to the _Client_ device for acceleration detection.

## What each file does
### client_interrupt.s
A module which controls the response of the nurse device when a fall is detected in the client, or the alert or disabled button is pressed. It also contains the set-up and response of the interrupt triggered by the IMU.

Contains the following subroutines: Client_Interrupt_Setup, Client_Int_Hi, client_fall, client_alert, client_disable 

### client_main.s
A module which controls the set-up and standby state of the client device. A test subroutine (test_read) tests whether the IMU is responding to SPI communication. This also contains the high priority interrupt vector.

Contains the following subroutines: rst, int_hi, clientSetup, Client_pin_Setup, client_main_polling, test_read

### client_spi.s
A module containing code to set up the IMU, including the SPI communication required to do so.

Contains the following subroutines: client_imuSetup, INT_EN, INT_OUT_CTRL, INT_MAP, INT_LOWHIGH, NOP_delay, SPI_MasterInit, SPI_MasterTransmit, Wait_Transmit, SPI_MasterRead, Wait_Read, Send_to_Master

## Credits

This project was jointly made by SW Yuan and A MacIntosh-LaRocque for the 3rd Year Microprocessors Lab Course at Imperial College London during the academic year 2021-2022. 
