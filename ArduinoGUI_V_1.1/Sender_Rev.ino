#include <SoftwareSerial.h>
#define txPin 4
#define rxPin 3

SoftwareSerial XSERIAL = SoftwareSerial(rxPin, txPin);
const byte LED = 11;  // Timer 2 "A" output: OC2A

void setup() {
  pinMode (LED, OUTPUT);

  //  = 13.125 uS, so frequency is 1/(2 * 13.125) = 38095 Hz

  int i  = 1;
  Serial.begin(9600);
  XSERIAL.begin(9600);
}  // end of setup

void loop()
{

  if(Serial.available()){

    String GUI_Input = Serial.readString();

    XSERIAL.print(GUI_Input);//GUI_Input
  }
 /* for(int i = 0; i < 100; i++)
  {
    XSERIAL.println(i);
    delay(100);
  }*/
}
  
