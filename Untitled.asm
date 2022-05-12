;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Mon May 2 2022
; Processor: PIC16F877A
; Compiler:  MPASM (Proteus)
; Author:    Ivan Tyurin
; Fork by:   Arjun Sunil Kumar
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

LIST p=16f877a
#include p16f877a.inc                ; Include register definition file

; 0x36,0x35 are used for storing the numbers respectively
; 0x37  is used to store the condition 
; 0x38, 0x39 are used to store the loop variables

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
RST   code  0x0 
      goto  Start

;====================================================================
; CODE SEGMENT
;====================================================================

PGM   code
Start

;----------------------------------------------------------------------------------------------------------------
; configuring as input and output ports
	bsf STATUS, RP0 			;	select bank 1 

	;FOR KEYPAD
	movlw b'11110000' 			
	movwf TRISB 				

	;FOR LCD CONFIG
	movlw b'11111000'
	movwf TRISD

	;FOR LCD OUTPUT
	movlw 0x00					
	movwf TRISC					

	bcf STATUS, RP0 			;	select bank 0
;-----------------------------------------------------------------------------------------------------------------


;Main-------------------------------------------------------------------------------------------------
begin:						
	call check_keypad		
goto begin				
;-----------------------------------------------------------------------------------------------------



;The part which scans keypad-----------------------------------------------------------------------------
 check_keypad					;	This routine will scan the keypad for any key presses.

		bsf PORTB, 0			;  scan the 1st column of keys		
		;========================================================
		btfsc PORTB, 4			;	has the ON/OFF key been pressed? if yes then
		call ON
		BTFSC 0X43,0
		return
	
		btfsc PORTB, 5			;	has the 1 key been pressed? if yes then
		call  ONE
		
		btfsc PORTB, 6			;	has the 4 key been pressed? if yes then
		call FOUR	
		
		btfsc PORTB, 7			;	has the 7 key been pressed? if yes then
		call SEVEN
	
		bcf PORTB, 0			;	finished column 1

	
		bsf PORTB, 1			;	scan the 2nd column of keys
		;=========================================================
		btfsc PORTB, 4			;	has the 0 key been pressed? if yes then
		CALL ZERO				
		
		btfsc PORTB, 5			;	has the 2 key been pressed? if yes then
		CALL TWO				
	
		btfsc PORTB, 6			;	has the 5 key been pressed? if yes then
		CALL FIVE				
	
		btfsc PORTB, 7			;	has the 8 key been pressed? if yes then
		CALL EIGHT				
	
		bcf PORTB, 1			;	finished column 2

	
		bsf PORTB, 2			; scan the 3rd column of keys
		;=====================================================
		btfsc PORTB, 4			;	has the = key been pressed? if yes then
		CALL EQUAL				
		
		btfsc PORTB, 5			;	has the 3 key been pressed? if yes then
		CALL THREE				
		
		btfsc PORTB, 6			;	has the 6 key been pressed? if yes then
		CALL SIX				
		
		btfsc PORTB, 7			;	has the 9 key been pressed? if yes then
		CALL NINE				
	
		bcf PORTB, 2			;	finished column 3


		bsf PORTB, 3			;   scan the 4th column of keys
		;========================================================
		btfsc PORTB, 4			;	has the + key been pressed? if yes then
		call PLUS				
	
		btfsc PORTB, 5			;	has the - key been pressed? if yes then
		call MINUS				
	
		btfsc PORTB, 6			;	has the x key been pressed? if yes then
		call MULT				
	
		btfsc PORTB, 7			;	has the / key been pressed? if yes then
		call DIV				
	
		bcf PORTB, 3			;	finished column 4

        call DELAY1
	return						;	and now return to the main routine
;----------------------------------------------------------------------------------------------------------------





;----------------------------------------------------------------------------------------------------------------
;KEY FUNTIONS
ZERO:
;movlw 0x00
call shift
addlw 0x00

;MOVWF FSR
;ADDWF FSR, 0
movwf 0x35
movlw 0x30
call display_digit
return 


ONE:
;movlw 0x01
call shift
addlw 0x01

movwf 0x35
movlw 0x31
call display_digit
return 

TWO:
;movlw 0x02
call shift
addlw 0x02

movwf 0x35
movlw 0x32
call display_digit
return 

THREE:
;movlw 0x03
call shift
addlw 0x03

movwf 0x35
movlw 0x33
call display_digit
return 

FOUR:
;movlw 0x04
call shift
addlw 0x04

movwf 0x35
movlw 0x34
call display_digit
return 

FIVE:
;movlw 0x05
call shift
addlw 0x05

movwf 0x35
movlw 0x35
call display_digit
return 

SIX:
;movlw 0x06
call shift
addlw 0x06

movwf 0x35
movlw 0x36
call display_digit
return 

SEVEN:
;movlw 0x07
call shift
addlw 0x07

movwf 0x35
movlw 0x37
call display_digit
return 

EIGHT:
;movlw 0x08
call shift
addlw 0x08

movwf 0x35
movlw 0x38
call display_digit
return 

NINE:
;movlw 0x09
call shift
addlw 0x09

movwf 0x35
movlw 0x39
call display_digit
return 

shift:
movf 0x35,w
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
ADDWF 0x35, 0
return





	;-------------------------------------------------------
	PLUS:
	;storing the first operand to 0x36 so that
	;the second operand would come to 0x35
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	;sending the value 00 for addition  operation
	;0x37 is the varaible that stores the conditions
	movlw 0x00
	movwf 0x37
	
	movlw 0x2B
	call display_digit
	return
	;--------------------------------------------------------
	



	;---------------------------------------------------------
	MINUS:
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	movlw 0x01
	movwf 0x37
	
	movlw 0x2D
	call display_digit
	return
	;----------------------------------------------------------



	;----------------------------------------------------------
	MULT:
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	movlw 0x02
	movwf 0x37
	
	movlw 0x2A
	call display_digit
	return
	;--------------------------------------------------------------



	;--------------------------------------------------------------
	DIV:
	movf 0x35,w
	movwf 0x36
	clrf 0x35
	
	movlw 0x03
	movwf 0x37
	
	movlw 0x2F
	call display_digit
	return
	;------------------------------------------------------------------


EQUAL:
movlw 0x01
movwf 0x43
movlw 0x3D
movf 0x36
call display_digit

;CALCULATION PART-------------------------------------------------------
BTFSS 0X37,1
GOTO TCOND0 ;0X
GOTO TCOND1 ;1X

TCOND0:
BTFSS 0X37,0
GOTO COND00
GOTO COND01

TCOND1:
BTFSS 0X37,0
GOTO COND10
GOTO COND11

;Addition
COND00:
MOVF 0X36,W
ADDWF 0X35,W
;addlw 0x30 
call display_registor
RETURN

;Substration
COND01:
SUBSTRACTION:
MOVF 0X35,W
SUBWF 0X36,W
;addlw 0x30  
call display_registor
RETURN

;Multiplication
COND10:
MOVLW 0X00 
LOOP2:
ADDWF 0X36,W
DECF 0X35,F
BTFSS STATUS,Z
GOTO LOOP2
;addlw 0x30  

;call axb
;movf 0x36, 0
call display_registor
RETURN 

;Division  0x36/0x35
COND11:
MOVF 0X35,W
;LP1:
;SUBWF 0X36,W
;BTFSS STATUS,DC
;GOTO LP1

call del
movf 0x40, 0
;addlw 0x30  
;MOVF 0X00,0
call display_registor
RETURN



; source part of division: https://radiolaba.ru/programmirovanie-pic-kontrollerov/arifmeticheskie-operatsii-umnozhenie-i-delenie.html
;Подпрограмма деления однобайтных чисел (varLL):(tmpLL)
;Первое число предварительно загружается в регистр varLL
;Второе число предварительно загружается в регистр tmpLL
;Результат деления в регистре rezLL, деление целочисленное без дробной части
;на ноль делить нельзя, произойдет выход из подпрограммы без изменений

del clrf 0x40
	clrf 0x41  
    movlw .0        
    xorwf 0x35,W    
    btfsc STATUS,Z 
    return                
d1  movf 0x36, W
    movwf 0x41
    movf 0x35,W   
	subwf 0x36,F         
    btfss STATUS,C 
    return                
    incf 0x40,F 
    
    goto          d1      
;END OF CALCULATION-----------------------------------------------

return





ON:
movlw 0x01
call DISPLAY

clrf 0x35
clrf 0x36
clrf 0x37
clrf 0x43
return
;----------------------------------------------------------------------------------------------------------------




;Display the digit in the 7 segment------------------------------------------------------------------------------
; LCD INITIALIZATION
    
		;If
		;RS=0  Instruction command Code register is selected, allowing user to send command
		;RS=1  Data register is selected allowing to send data that has to be displayed.

		;R\W=0  Reading
		;R\W=1  Writing
		;E- Enable

		;The enable Pin is used by the LCD to latch information at its data pins. When data is supplied to data pins,
		;a high to low pulse must be applied to this pin in order for the LCD to latch the data present in the data pins.
		;E should  Toggle

		;Data Mode:  RS=1, R\W=0, E=1\0

display_digit:
		BSF PORTD,0; CONTROL SIGNAL TO RS
		BCF PORTD,1; CONTROL SIGNAL TO R/W
		BSF PORTD,2; CONTROL SIGNAL TO 'E'
		
		;Here the value already stored in the W reg is send to DISPLAY	
		call DISPLAY
		;call DISPLAY

		MOVLW 0X38  ;initialises the display
		CALL DISPLAY
		
		MOVLW 0X0E ; dont blink the cursor
		CALL DISPLAY

		BSF PORTD,0
		RETURN
		
display_registor:
		
		movwf  0x36
		movlw 0x0A
		movwf 0x35
		call del
		movf 0x41, 0
		
		movwf  0x42
		movf 0x40, 0
		
		movwf  0x36
		movlw 0x0A
		movwf 0x35
		call del
		movf 0x41, 0
		
		ch   equ 0x40
		ch2 equ 0x41
		call checkByte
		movf 0x40, 0
		addlw 0x30
		call display_digit
next: 
		call checkByte2
		movf 0x41, 0
		addlw 0x30
		call display_digit
next2:
		movf 0x42, 0
		addlw 0x30
		call display_digit
		goto begin
		
checkByte:
		BTFSC ch,0
		return
		BTFSC ch,1
		return
		BTFSC ch,2
		return
		BTFSC ch,3
		return
		BTFSC ch,4
		return
		BTFSC ch,5
		return
		BTFSC ch,6
		return
		BTFSC ch,7
		return
		goto next

checkByte2:
		BTFSC ch2,0
		return
		BTFSC ch2,1
		return
		BTFSC ch2,2
		return
		BTFSC ch2,3
		return
		BTFSC ch2,4
		return
		BTFSC ch2,5
		return
		BTFSC ch2,6
		return
		BTFSC ch2,7
		return
		goto next2
		


DISPLAY:   
   		MOVWF PORTC

		BCF PORTD,2
		CALL DELAY1

		BSF PORTD,2
		CALL DELAY1

		BCF PORTD,0
		RETURN

DELAY1:	
		MOVLW	D'13'	 ;A VERY SMALL DELAY
		MOVWF	0X38
		MOVLW	D'251'
		MOVWF	0X39
		LOOP:	DECFSZ	0X39
				GOTO	LOOP
				DECFSZ	0X38
				GOTO	LOOP
		RETURN
		RETURN	

	return					
;----------------------------------------------------------------------------------------------------------------
;Referance
;LCD
;http://www.instructables.com/id/Build-yourself-flashing-message-on-PIC16F877A-with/
;http://www.edaboard.com/thread237649.html

;keypad
;http://www.bradsprojects.com/pic-assembly-tutorial-6-interfacing-a-keypad-to-your-microcontroller/	


Loop  
      goto  Loop

;====================================================================
      END

 


