#include <SoftwareSerial.h>
#define txPin 4
#define rxPin 3

SoftwareSerial XSERIAL = SoftwareSerial(rxPin, txPin);
const byte LED = 11;  // Timer 2 "A" output: OC2A

void setup() {
  
  pinMode (LED, OUTPUT);

  Serial.begin(9600);
  XSERIAL.begin(9600);
  
}  // end of setup

void loop()
{
  if(Serial.available()){

    String GUI_Input = Serial.readString();

    XSERIAL.println(GUI_Input);//GUI_Input
  }
}
