
_initialConfig:

;Traffic Light Controller.c,21 :: 		void initialConfig(){
;Traffic Light Controller.c,22 :: 		TRISB = 0; TRISC = 0; TRISD = 0;  //Set PORT B,C,D As Output
	CLRF       TRISB+0
	CLRF       TRISC+0
	CLRF       TRISD+0
;Traffic Light Controller.c,23 :: 		ADCON1 = 7;   //Make PortA & PortE R/W Analog Signal
	MOVLW      7
	MOVWF      ADCON1+0
;Traffic Light Controller.c,24 :: 		TRISB.B0 = 1; //Make interrupt pin as input
	BSF        TRISB+0, 0
;Traffic Light Controller.c,25 :: 		GIE_Bit = 1;  //Global interrupt enable
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Traffic Light Controller.c,26 :: 		INTE_Bit = 1; //B0 interrupt enable
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;Traffic Light Controller.c,27 :: 		INTEDG_Bit = 1; //Interrupt On Rising Edge
	BSF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;Traffic Light Controller.c,28 :: 		}
L_end_initialConfig:
	RETURN
; end of _initialConfig

_setWest:

;Traffic Light Controller.c,30 :: 		void setWest(int Red,int Yellow,int Green){
;Traffic Light Controller.c,31 :: 		westRed = Red;
	BTFSC      FARG_setWest_Red+0, 0
	GOTO       L__setWest26
	BCF        PORTB+0, 1
	GOTO       L__setWest27
L__setWest26:
	BSF        PORTB+0, 1
L__setWest27:
;Traffic Light Controller.c,32 :: 		westYellow = Yellow;
	BTFSC      FARG_setWest_Yellow+0, 0
	GOTO       L__setWest28
	BCF        PORTB+0, 2
	GOTO       L__setWest29
L__setWest28:
	BSF        PORTB+0, 2
L__setWest29:
;Traffic Light Controller.c,33 :: 		westGreen = Green;
	BTFSC      FARG_setWest_Green+0, 0
	GOTO       L__setWest30
	BCF        PORTB+0, 3
	GOTO       L__setWest31
L__setWest30:
	BSF        PORTB+0, 3
L__setWest31:
;Traffic Light Controller.c,34 :: 		}
L_end_setWest:
	RETURN
; end of _setWest

_setSouth:

;Traffic Light Controller.c,36 :: 		void setSouth(int Red,int Yellow,int Green){
;Traffic Light Controller.c,37 :: 		southRed = Red;
	BTFSC      FARG_setSouth_Red+0, 0
	GOTO       L__setSouth33
	BCF        PORTB+0, 4
	GOTO       L__setSouth34
L__setSouth33:
	BSF        PORTB+0, 4
L__setSouth34:
;Traffic Light Controller.c,38 :: 		southYellow = Yellow;
	BTFSC      FARG_setSouth_Yellow+0, 0
	GOTO       L__setSouth35
	BCF        PORTB+0, 5
	GOTO       L__setSouth36
L__setSouth35:
	BSF        PORTB+0, 5
L__setSouth36:
;Traffic Light Controller.c,39 :: 		southGreen = Green;
	BTFSC      FARG_setSouth_Green+0, 0
	GOTO       L__setSouth37
	BCF        PORTB+0, 6
	GOTO       L__setSouth38
L__setSouth37:
	BSF        PORTB+0, 6
L__setSouth38:
;Traffic Light Controller.c,40 :: 		}
L_end_setSouth:
	RETURN
; end of _setSouth

_firstPhase:

;Traffic Light Controller.c,42 :: 		void firstPhase(){    //West is Green and South is Red for 20s
;Traffic Light Controller.c,43 :: 		setWest(0,0,1);
	CLRF       FARG_setWest_Red+0
	CLRF       FARG_setWest_Red+1
	CLRF       FARG_setWest_Yellow+0
	CLRF       FARG_setWest_Yellow+1
	MOVLW      1
	MOVWF      FARG_setWest_Green+0
	MOVLW      0
	MOVWF      FARG_setWest_Green+1
	CALL       _setWest+0
;Traffic Light Controller.c,44 :: 		setSouth(1,0,0);
	MOVLW      1
	MOVWF      FARG_setSouth_Red+0
	MOVLW      0
	MOVWF      FARG_setSouth_Red+1
	CLRF       FARG_setSouth_Yellow+0
	CLRF       FARG_setSouth_Yellow+1
	CLRF       FARG_setSouth_Green+0
	CLRF       FARG_setSouth_Green+1
	CALL       _setSouth+0
;Traffic Light Controller.c,45 :: 		for (westCounter = 20, southCounter = 23 ; westCounter > 0 ; westCounter--, southCounter--) {
	MOVLW      20
	MOVWF      _westCounter+0
	MOVLW      0
	MOVWF      _westCounter+1
	MOVLW      23
	MOVWF      _southCounter+0
	MOVLW      0
	MOVWF      _southCounter+1
L_firstPhase0:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _westCounter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__firstPhase40
	MOVF       _westCounter+0, 0
	SUBLW      0
L__firstPhase40:
	BTFSC      STATUS+0, 0
	GOTO       L_firstPhase1
;Traffic Light Controller.c,46 :: 		westDisplay = countDown[westCounter];
	MOVF       _westCounter+0, 0
	MOVWF      R0+0
	MOVF       _westCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;Traffic Light Controller.c,47 :: 		southDisplay = countDown[southCounter];
	MOVF       _southCounter+0, 0
	MOVWF      R0+0
	MOVF       _southCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Traffic Light Controller.c,48 :: 		delay_ms(SEC);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_firstPhase3:
	DECFSZ     R13+0, 1
	GOTO       L_firstPhase3
	DECFSZ     R12+0, 1
	GOTO       L_firstPhase3
	DECFSZ     R11+0, 1
	GOTO       L_firstPhase3
	NOP
	NOP
;Traffic Light Controller.c,45 :: 		for (westCounter = 20, southCounter = 23 ; westCounter > 0 ; westCounter--, southCounter--) {
	MOVLW      1
	SUBWF      _westCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _westCounter+1, 1
	MOVLW      1
	SUBWF      _southCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _southCounter+1, 1
;Traffic Light Controller.c,49 :: 		}
	GOTO       L_firstPhase0
L_firstPhase1:
;Traffic Light Controller.c,50 :: 		}
L_end_firstPhase:
	RETURN
; end of _firstPhase

_secondPhase:

;Traffic Light Controller.c,52 :: 		void secondPhase(){   //West is Yellow and South is Red for 3s
;Traffic Light Controller.c,53 :: 		setWest(0,1,0);
	CLRF       FARG_setWest_Red+0
	CLRF       FARG_setWest_Red+1
	MOVLW      1
	MOVWF      FARG_setWest_Yellow+0
	MOVLW      0
	MOVWF      FARG_setWest_Yellow+1
	CLRF       FARG_setWest_Green+0
	CLRF       FARG_setWest_Green+1
	CALL       _setWest+0
;Traffic Light Controller.c,54 :: 		setSouth(1,0,0);
	MOVLW      1
	MOVWF      FARG_setSouth_Red+0
	MOVLW      0
	MOVWF      FARG_setSouth_Red+1
	CLRF       FARG_setSouth_Yellow+0
	CLRF       FARG_setSouth_Yellow+1
	CLRF       FARG_setSouth_Green+0
	CLRF       FARG_setSouth_Green+1
	CALL       _setSouth+0
;Traffic Light Controller.c,55 :: 		for (westCounter = 3, southCounter = 3 ; westCounter > 0 ; westCounter--, southCounter-- ) {
	MOVLW      3
	MOVWF      _westCounter+0
	MOVLW      0
	MOVWF      _westCounter+1
	MOVLW      3
	MOVWF      _southCounter+0
	MOVLW      0
	MOVWF      _southCounter+1
L_secondPhase4:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _westCounter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__secondPhase42
	MOVF       _westCounter+0, 0
	SUBLW      0
L__secondPhase42:
	BTFSC      STATUS+0, 0
	GOTO       L_secondPhase5
;Traffic Light Controller.c,56 :: 		westDisplay = countDown[westCounter];
	MOVF       _westCounter+0, 0
	MOVWF      R0+0
	MOVF       _westCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;Traffic Light Controller.c,57 :: 		southDisplay = countDown[southCounter];
	MOVF       _southCounter+0, 0
	MOVWF      R0+0
	MOVF       _southCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Traffic Light Controller.c,58 :: 		delay_ms(SEC);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_secondPhase7:
	DECFSZ     R13+0, 1
	GOTO       L_secondPhase7
	DECFSZ     R12+0, 1
	GOTO       L_secondPhase7
	DECFSZ     R11+0, 1
	GOTO       L_secondPhase7
	NOP
	NOP
;Traffic Light Controller.c,55 :: 		for (westCounter = 3, southCounter = 3 ; westCounter > 0 ; westCounter--, southCounter-- ) {
	MOVLW      1
	SUBWF      _westCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _westCounter+1, 1
	MOVLW      1
	SUBWF      _southCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _southCounter+1, 1
;Traffic Light Controller.c,59 :: 		}
	GOTO       L_secondPhase4
L_secondPhase5:
;Traffic Light Controller.c,60 :: 		}
L_end_secondPhase:
	RETURN
; end of _secondPhase

_thirdPhase:

;Traffic Light Controller.c,62 :: 		void thirdPhase(){    //West is Red and South is Green for 12s
;Traffic Light Controller.c,63 :: 		setWest(1,0,0);
	MOVLW      1
	MOVWF      FARG_setWest_Red+0
	MOVLW      0
	MOVWF      FARG_setWest_Red+1
	CLRF       FARG_setWest_Yellow+0
	CLRF       FARG_setWest_Yellow+1
	CLRF       FARG_setWest_Green+0
	CLRF       FARG_setWest_Green+1
	CALL       _setWest+0
;Traffic Light Controller.c,64 :: 		setSouth(0,0,1);
	CLRF       FARG_setSouth_Red+0
	CLRF       FARG_setSouth_Red+1
	CLRF       FARG_setSouth_Yellow+0
	CLRF       FARG_setSouth_Yellow+1
	MOVLW      1
	MOVWF      FARG_setSouth_Green+0
	MOVLW      0
	MOVWF      FARG_setSouth_Green+1
	CALL       _setSouth+0
;Traffic Light Controller.c,65 :: 		for (westCounter = 15 ,southCounter = 12 ; southCounter > 0 ; westCounter--,southCounter--) {
	MOVLW      15
	MOVWF      _westCounter+0
	MOVLW      0
	MOVWF      _westCounter+1
	MOVLW      12
	MOVWF      _southCounter+0
	MOVLW      0
	MOVWF      _southCounter+1
L_thirdPhase8:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _southCounter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__thirdPhase44
	MOVF       _southCounter+0, 0
	SUBLW      0
L__thirdPhase44:
	BTFSC      STATUS+0, 0
	GOTO       L_thirdPhase9
;Traffic Light Controller.c,66 :: 		westDisplay = countDown[westCounter];
	MOVF       _westCounter+0, 0
	MOVWF      R0+0
	MOVF       _westCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;Traffic Light Controller.c,67 :: 		southDisplay = countDown[southCounter];
	MOVF       _southCounter+0, 0
	MOVWF      R0+0
	MOVF       _southCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Traffic Light Controller.c,68 :: 		delay_ms(SEC);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_thirdPhase11:
	DECFSZ     R13+0, 1
	GOTO       L_thirdPhase11
	DECFSZ     R12+0, 1
	GOTO       L_thirdPhase11
	DECFSZ     R11+0, 1
	GOTO       L_thirdPhase11
	NOP
	NOP
;Traffic Light Controller.c,65 :: 		for (westCounter = 15 ,southCounter = 12 ; southCounter > 0 ; westCounter--,southCounter--) {
	MOVLW      1
	SUBWF      _westCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _westCounter+1, 1
	MOVLW      1
	SUBWF      _southCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _southCounter+1, 1
;Traffic Light Controller.c,69 :: 		}
	GOTO       L_thirdPhase8
L_thirdPhase9:
;Traffic Light Controller.c,71 :: 		}
L_end_thirdPhase:
	RETURN
; end of _thirdPhase

_fourthPhase:

;Traffic Light Controller.c,73 :: 		void fourthPhase(){   //West is Red and South is Yellow for 3s
;Traffic Light Controller.c,74 :: 		setWest(1,0,0);
	MOVLW      1
	MOVWF      FARG_setWest_Red+0
	MOVLW      0
	MOVWF      FARG_setWest_Red+1
	CLRF       FARG_setWest_Yellow+0
	CLRF       FARG_setWest_Yellow+1
	CLRF       FARG_setWest_Green+0
	CLRF       FARG_setWest_Green+1
	CALL       _setWest+0
;Traffic Light Controller.c,75 :: 		setSouth(0,1,0);
	CLRF       FARG_setSouth_Red+0
	CLRF       FARG_setSouth_Red+1
	MOVLW      1
	MOVWF      FARG_setSouth_Yellow+0
	MOVLW      0
	MOVWF      FARG_setSouth_Yellow+1
	CLRF       FARG_setSouth_Green+0
	CLRF       FARG_setSouth_Green+1
	CALL       _setSouth+0
;Traffic Light Controller.c,76 :: 		for (westCounter = 3, southCounter = 3 ; southCounter > 0 ; westCounter--, southCounter--) {
	MOVLW      3
	MOVWF      _westCounter+0
	MOVLW      0
	MOVWF      _westCounter+1
	MOVLW      3
	MOVWF      _southCounter+0
	MOVLW      0
	MOVWF      _southCounter+1
L_fourthPhase12:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _southCounter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__fourthPhase46
	MOVF       _southCounter+0, 0
	SUBLW      0
L__fourthPhase46:
	BTFSC      STATUS+0, 0
	GOTO       L_fourthPhase13
;Traffic Light Controller.c,77 :: 		westDisplay = countDown[westCounter];
	MOVF       _westCounter+0, 0
	MOVWF      R0+0
	MOVF       _westCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;Traffic Light Controller.c,78 :: 		southDisplay = countDown[southCounter];
	MOVF       _southCounter+0, 0
	MOVWF      R0+0
	MOVF       _southCounter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _countDown+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTD+0
;Traffic Light Controller.c,79 :: 		delay_ms(SEC);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_fourthPhase15:
	DECFSZ     R13+0, 1
	GOTO       L_fourthPhase15
	DECFSZ     R12+0, 1
	GOTO       L_fourthPhase15
	DECFSZ     R11+0, 1
	GOTO       L_fourthPhase15
	NOP
	NOP
;Traffic Light Controller.c,76 :: 		for (westCounter = 3, southCounter = 3 ; southCounter > 0 ; westCounter--, southCounter--) {
	MOVLW      1
	SUBWF      _westCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _westCounter+1, 1
	MOVLW      1
	SUBWF      _southCounter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _southCounter+1, 1
;Traffic Light Controller.c,80 :: 		}
	GOTO       L_fourthPhase12
L_fourthPhase13:
;Traffic Light Controller.c,81 :: 		}
L_end_fourthPhase:
	RETURN
; end of _fourthPhase

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Traffic Light Controller.c,83 :: 		void interrupt(){
;Traffic Light Controller.c,84 :: 		if(INTF_Bit == 1){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt16
;Traffic Light Controller.c,85 :: 		INTF_Bit = 0; //Reset Flag
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;Traffic Light Controller.c,86 :: 		while (controlPin == 1){ //Still in manual mode
L_interrupt17:
	BTFSS      PORTB+0, 0
	GOTO       L_interrupt18
;Traffic Light Controller.c,88 :: 		if (street == 0){ //West Street
	BTFSC      PORTB+0, 7
	GOTO       L_interrupt19
;Traffic Light Controller.c,89 :: 		westRed = 0; westYellow = 0; westGreen = 1;
	BCF        PORTB+0, 1
	BCF        PORTB+0, 2
	BSF        PORTB+0, 3
;Traffic Light Controller.c,90 :: 		southRed = 1; southYellow = 0; southGreen = 0;
	BSF        PORTB+0, 4
	BCF        PORTB+0, 5
	BCF        PORTB+0, 6
;Traffic Light Controller.c,91 :: 		}
	GOTO       L_interrupt20
L_interrupt19:
;Traffic Light Controller.c,92 :: 		else if (street == 1){ //South Street
	BTFSS      PORTB+0, 7
	GOTO       L_interrupt21
;Traffic Light Controller.c,93 :: 		westRed = 1; westYellow = 0; westGreen = 0;
	BSF        PORTB+0, 1
	BCF        PORTB+0, 2
	BCF        PORTB+0, 3
;Traffic Light Controller.c,94 :: 		southRed = 0; southYellow = 0; southGreen = 1;
	BCF        PORTB+0, 4
	BCF        PORTB+0, 5
	BSF        PORTB+0, 6
;Traffic Light Controller.c,95 :: 		}
L_interrupt21:
L_interrupt20:
;Traffic Light Controller.c,96 :: 		westDisplay = 0;
	CLRF       PORTC+0
;Traffic Light Controller.c,97 :: 		southDisplay = 0;
	CLRF       PORTD+0
;Traffic Light Controller.c,98 :: 		}
	GOTO       L_interrupt17
L_interrupt18:
;Traffic Light Controller.c,99 :: 		}
L_interrupt16:
;Traffic Light Controller.c,100 :: 		}
L_end_interrupt:
L__interrupt48:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Traffic Light Controller.c,102 :: 		void main() {
;Traffic Light Controller.c,104 :: 		initialConfig();
	CALL       _initialConfig+0
;Traffic Light Controller.c,106 :: 		while(1) {
L_main22:
;Traffic Light Controller.c,108 :: 		firstPhase();
	CALL       _firstPhase+0
;Traffic Light Controller.c,109 :: 		secondPhase();
	CALL       _secondPhase+0
;Traffic Light Controller.c,110 :: 		thirdPhase();
	CALL       _thirdPhase+0
;Traffic Light Controller.c,111 :: 		fourthPhase();
	CALL       _fourthPhase+0
;Traffic Light Controller.c,113 :: 		}
	GOTO       L_main22
;Traffic Light Controller.c,114 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
