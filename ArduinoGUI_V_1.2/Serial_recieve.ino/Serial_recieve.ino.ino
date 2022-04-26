#include <SoftwareSerial.h>

#define rxPin 2
#define txPin 3

SoftwareSerial XSERIAL = SoftwareSerial(rxPin,txPin,false);

void setup() {

  XSERIAL.begin(9600);
  Serial.begin(9600);
  
  Serial.println("waiting");

} // end of setup

void loop() {
  if(XSERIAL.available()){
    
    String recieved_string = XSERIAL.readString();
    
    Serial.println(recieved_string);
  }
}
