;
; project1.asm
;
; Created: 3/17/2019 12:42:14 PM
; Authors : brian dahlman, sarah dlouhy, jacob lipina, eli verbrugge
;

;MAIN
		  LDI R23, 0x00 ; storing various values
		  LDI R16, 0x00 ; zero registers
		  LDI R17, 0xFF ; one registers
		  LDI R18, 0x0F ;  
		  OUT DDRD, R17 ; LEDs output mode
		  OUT PORTD, R17; LEDs OFF (active low)
		  OUT DDRE, R17
		  SBI PORTE, 5

START:	  OUT DDRA, R16 ; pull-up resistors
		  OUT PORTA, R17
		  CALL RUN_DELAY

		  CHECK_SW1:
			SBIC PINA,0 
			JMP CHECK_SW2 ; checking to see if sw2 is pressed		  
			CPSE R23, R16
			CALL GO_DOWN
			CALL WRAP_BOTTOM
		
		  CHECK_SW2:
			SBIC PINA,1
			JMP  CHECK_SW3 ; check if switch 7 is pressed
			CPSE R23, R18
			CALL GO_UP
			CALL WRAP_TOP
	  
		  CHECK_SW3:
			SBIC PINA, 2
			JMP CHECK_SW4
			CALL JURASSIC_PARK_THEME
		 
		  CHECK_SW4:
			SBIC PINA, 3 ;checking switch 4 pin
			JMP CHECK_SW7 ; jump to switch 7
			LDI R31, 10
YEET:		CALL RAVE_MODE ; rave mode x5
			DEC R31
			BRNE YEET
			LDI R17, 0xFF ; turn off LEDs with next three lines
			OUT DDRD, R17
			OUT PORTD, R17
	  
		  CHECK_SW7:
			SBIC PINA,5 ; checking sw7 pin
			JMP  CHECK_SW8 ; check if switch 8 is  pressed
			CALL PLAYTONE_E5 ; play e5
		  
		  CHECK_SW8:
			SBIC PINA,6 ; checking sw8 pin
			JMP  CHECK_SW9 ; check if sw9 is pressed
			CALL PLAYTONE_F5 ;play f5
		   
		  CHECK_SW9:
			SBIC PINA,7 ; checking sw9 pin
			JMP START;GO BACK TO START
			CALL PLAYTONE_G5	; play g5
		  
		  RJMP START
;END MAIN

;Binary wrapping from 0 to 15
WRAP_BOTTOM:	LDI R23, 15
				CALL PLAY_WRAPTONE
				CALL OUTPUT ; bit masking routine on
				CALL CORNERS
				CALL RUN_DELAY
				CALL MIDDLES
				LDI R17, 0xFF ; turn off LEDs with next three lines
	  			OUT DDRD, R17
	  			OUT PORTD, R17
				RET

;Binary wrapping from 15 to 0
WRAP_TOP:		LDI R23, 0
				CALL PLAY_WRAPTONE
				CALL OUTPUT ; bit masking routine on
				CALL CORNERS
				CALL RUN_DELAY
				CALL MIDDLES
				LDI R17, 0xFF ; turn off LEDs with next three lines
	  			OUT DDRD, R17
	  			OUT PORTD, R17
				RET

GO_UP:			INC R23
				CALL OUTPUT
				JMP CHECK_SW7

GO_DOWN:		DEC R23
				CALL OUTPUT ; bit masking routine on
				JMP CHECK_SW2

;OUTPUT subroutine
OUTPUT:			SBRC R23, 0
				CBI PORTD,3
				SBRS R23, 0
				SBI PORTD,3

				SBRC R23, 1
				CBI PORTD,2
				SBRS R23, 1
				SBI PORTD,2

				SBRC R23, 2
				CBI PORTD,1
				SBRS R23, 2
				SBI PORTD,1

				SBRC R23, 3
				CBI PORTD,0
				SBRS R23, 3
				SBI PORTD,0

;WRAPTONE_DELAY subroutine for a frequency we can hear
WRAPTONE_DELAY:	LDI R24, 121	 
WRAPDELAY_L2:	LDI R22, 21
WRAPDELAY_L1:	DEC R22
				BRNE WRAPDELAY_L1
				DEC R24
				BRNE WRAPDELAY_L2
				RET

;PLAY_WRAPTONE SUBROUTINE, plays that funky music white boi
PLAY_WRAPTONE:	LDI R25, 50		
PLAYWRAP_L2:	LDI R26, 15
PLAYWRAP_L1:	SBI PORTE, 4; set pe4 to high
				CALL WRAPTONE_DELAY
				NOP
				NOP
				CBI PORTE, 4; set pe4 to low
				CALL WRAPTONE_DELAY
				DEC R26
				BRNE PLAYWRAP_L1
				DEC R25
				BRNE PLAYWRAP_L2
				RET



; plays what the speaker thinks is E5, everything is lower than it should be
PLAYTONE_E5:	LDI R25, 30
PLAYE5_L2:		LDI R26, 10
PLAYE5_L1:		SBI PORTE, 4; set pe4 to high
				CALL TONEDELAY_E5
				CBI PORTE, 4; set pe4 to low
				CALL TONEDELAY_E5
				DEC R26
				BRNE PLAYE5_L1
				DEC R25
				BRNE PLAYE5_L2
				RET

PLAYTONE_F5:	LDI R25, 30
PLAYF5_L2:		LDI R26, 10
PLAYF5_L1:		SBI PORTE, 4; set pe4 to high
				CALL TONEDELAY_F5
				CBI PORTE, 4; set pe4 to low
				CALL TONEDELAY_F5
				DEC R26
				BRNE PLAYF5_L1
				DEC R25
				BRNE PLAYF5_L2
				RET

;plays approximately g5
PLAYTONE_G5:	LDI R25, 30
PLAYG5_L2:		LDI R26, 10
PLAYG5_L1:		SBI PORTE, 4; set pe4 to high
				CALL TONEDELAY_G5
				CBI PORTE, 4; set pe4 to low
				CALL TONEDELAY_G5
				DEC R26
				BRNE PLAYG5_L1
				DEC R25
				BRNE PLAYG5_L2
				RET

; plays approximately e4
PLAYTONE_E4:	LDI R25, 30
PLAYE4_L2:		LDI R26, 10
PLAYE4_L1:		SBI PORTE, 4 ;pe4 to high
				CALL TONEDELAY_E4
				CBI PORTE, 4 ; pe4 to low
				CALL TONEDELAY_E4
				DEC R26
				BRNE PLAYE4_L1
				DEC R25
				BRNE PLAYE4_L2
				RET

; plays approximately e8
PLAYTONE_E8:	LDI R25, 30
PLAYE8_L2:		LDI R26, 10
PLAYE8_L1:		SBI PORTE, 4 ;pe4 to high
				CALL TONEDELAY_E8
				CBI PORTE, 4 ;pe4 to low
				CALL TONEDELAY_E8
				DEC R26
				BRNE PLAYE8_L1
				DEC R25
				BRNE PLAYE8_L2
				RET


;all of the tone delays for various notes
TONEDELAY_E5:	LDI R24, 30	 
DELAYE5_L2:		LDI R22, 134
DELAYE5_L1:		DEC R22
				BRNE DELAYE5_L1
				DEC R24
				BRNE DELAYE5_L2
				RET
			
TONEDELAY_F5:	LDI R24, 39	 
DELAYF5_L2:		LDI R22, 97
DELAYF5_L1:		DEC R22
				BRNE DELAYF5_L1
				DEC R24
				BRNE DELAYF5_L2
				RET

TONEDELAY_G5:	LDI R24, 100	 
DELAYG5_L2:		LDI R22, 33
DELAYG5_L1:		DEC R22
				BRNE DELAYG5_L1
				DEC R24
				BRNE DELAYG5_L2
				RET

TONEDELAY_E4:	LDI R24, 122
DELAYE4_L2:		LDI R22, 72
DELAYE4_L1:		DEC R22
				BRNE DELAYE4_L1
				DEC R24
				BRNE DELAYE4_L2
				RET

TONEDELAY_E8:	LDI R24, 51
DELAYE8_L2:		LDI R22, 9
DELAYE8_L1:		DEC R22
				BRNE DELAYE4_L1
				DEC R24
				BRNE DELAYE4_L2
				RET

TONEDELAY_D5:	LDI R24, 51
DELAYD5_L2:		LDI R22, 9
DELAYD5_L1:		DEC R22
				BRNE DELAYD5_L1
				DEC R24
				BRNE DELAYD5_L2
				RET

//turns the corner lights on when board is in 3x3 mode, same lights in 2x4 mode
CORNERS:		LDI R28, 0x5A
				LDI R16, 0xFF
				OUT DDRD, R16 ; output mode
				OUT PORTD, R28 ; out
				RET

//turns the other edge lights on when board is in 3x3 mode; LED2, LED4B, LED6b, and LED 8 in 2x4
MIDDLES:		LDI R28, 0xA5
				LDI R16, 0xFF
				OUT DDRD, R16 ; output mode
				OUT PORTD, R28 ; out
				RET

//switches between lights and plays the notes, sounds like something out of zelda
RAVE_MODE:		CALL CORNERS
				CALL PLAYTONE_E4
				CALL RUN_DELAY
				CALL MIDDLES
				CALL PLAYTONE_E8
				RET

//a delay that's just used for things
RUN_DELAY:		LDI R28, 0xFF	 
L4:				LDI R29, 0xFF
L3:				LDI R30, 30
L_NOP:			NOP
				DEC R30
				BRNE L_NOP
				DEC R29
				BRNE L3
				DEC R28
				BRNE L4
				RET


JURASSIC_PARK_THEME:
	
