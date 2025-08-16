#line 1 "F:/2nd CCED/Summer Training/Embedded Systems/Project Data/Code/Traffic Light Controller.c"
#line 16 "F:/2nd CCED/Summer Training/Embedded Systems/Project Data/Code/Traffic Light Controller.c"
int westCounter = 0;
int southCounter = 0;
const int SEC = 1000;
int countDown[] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x20,0x21,0x22,0x23};

void initialConfig(){
TRISB = 0; TRISC = 0; TRISD = 0;
ADCON1 = 7;
TRISB.B0 = 1;
GIE_Bit = 1;
INTE_Bit = 1;
INTEDG_Bit = 1;
}

void setWest(int Red,int Yellow,int Green){
  PORTB.B1  = Red;
  PORTB.B2  = Yellow;
  PORTB.B3  = Green;
}

void setSouth(int Red,int Yellow,int Green){
  PORTB.B4  = Red;
  PORTB.B5  = Yellow;
  PORTB.B6  = Green;
}

void firstPhase(){
setWest(0,0,1);
setSouth(1,0,0);
for (westCounter = 20, southCounter = 23 ; westCounter > 0 ; westCounter--, southCounter--) {
  PORTC  = countDown[westCounter];
  PORTD  = countDown[southCounter];
 delay_ms(SEC);
}
}

void secondPhase(){
setWest(0,1,0);
setSouth(1,0,0);
for (westCounter = 3, southCounter = 3 ; westCounter > 0 ; westCounter--, southCounter-- ) {
  PORTC  = countDown[westCounter];
  PORTD  = countDown[southCounter];
 delay_ms(SEC);
}
}

void thirdPhase(){
setWest(1,0,0);
setSouth(0,0,1);
for (westCounter = 15 ,southCounter = 12 ; southCounter > 0 ; westCounter--,southCounter--) {
  PORTC  = countDown[westCounter];
  PORTD  = countDown[southCounter];
 delay_ms(SEC);
}

}

void fourthPhase(){
setWest(1,0,0);
setSouth(0,1,0);
for (westCounter = 3, southCounter = 3 ; southCounter > 0 ; westCounter--, southCounter--) {
  PORTC  = countDown[westCounter];
  PORTD  = countDown[southCounter];
 delay_ms(SEC);
}
}

void interrupt(){
if(INTF_Bit == 1){
 INTF_Bit = 0;
 while ( PORTB.B0  == 1){

 if ( PORTB.B7  == 0){
  PORTB.B1  = 0;  PORTB.B2  = 0;  PORTB.B3  = 1;
  PORTB.B4  = 1;  PORTB.B5  = 0;  PORTB.B6  = 0;
 }
 else if ( PORTB.B7  == 1){
  PORTB.B1  = 1;  PORTB.B2  = 0;  PORTB.B3  = 0;
  PORTB.B4  = 0;  PORTB.B5  = 0;  PORTB.B6  = 1;
 }
  PORTC  = 0;
  PORTD  = 0;
 }
}
}

void main() {

initialConfig();

while(1) {

 firstPhase();
 secondPhase();
 thirdPhase();
 fourthPhase();

}
}
