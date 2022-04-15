import controlP5.*; //import controlp5 library
//import java.io.*;

//=========================================
import processing.serial.*;
Serial myPort;
//=========================================

ControlP5 cp5;

PFont headingFont;
PFont paragraphFont;
PFont inputFont;

String textValue = "RECIEVED: ";

PShape largeCirc;
PShape medCirc;
PShape smallCirc;

PShape TextlabelShadow;
PShape ParaBox;
PShape bangShadow;
int i = 10;

void setup() {

  size(400, 400);

  cp5 = new ControlP5(this);

  headingFont = createFont("calibri bold", 24);
  paragraphFont = createFont("calibri bold", 16);
  inputFont = createFont("calibri bold", 32);

  //===========================================================
  printArray(Serial.list());
  myPort = new Serial(this, "COM3", 9600);
  //textValue = myPort.readString();
  //==========================================================

  largeCirc = createShape(ELLIPSE, 175, -150, 500, 500); // creates and sets properties of circle
  largeCirc.setFill(color(147, 228, 230));
  largeCirc.setStroke(false);

  medCirc = createShape(ELLIPSE, 175, -150, 200, 200); // creates and sets properties of circle
  medCirc.setFill(color(147, 228, 230)); //
  medCirc.setStroke(false);

  smallCirc = createShape(ELLIPSE, 175, -150, 90, 90); // creates and sets properties of circle
  smallCirc.setFill(color(147, 228, 230));
  smallCirc.setStroke(false);
  
  TextlabelShadow = createShape(RECT, 25, 115, 350, 200); // creates and sets properties of circle
  TextlabelShadow.setFill(color(116, 159, 254));//0,116,217
  TextlabelShadow.setStroke(false);

  ParaBox = createShape(RECT, 20, 110, 350, 200); // creates and sets properties of circle
  ParaBox.setFill(color(0, 45, 90));//0,116,217
  ParaBox.setStroke(false);
  
  bangShadow = createShape(RECT, 25, 325, 80, 40); // creates and sets properties of circle
  bangShadow.setFill(color(0, 45, 90));//0, 45, 90
  bangShadow.setStroke(false);
  
    cp5.addBang("Clear")        //Creates and sets properties of submit bang (button)
    .setPosition(20, 320)
    .setSize(80, 40)
    .setFont(paragraphFont)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.getController("Clear").setColorForeground(color(116, 159, 254));
  
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName()=="Clear") {
    textValue = "RECIEVED: ";
  }
}


void draw() {
  background(255, 255, 255);

  shape(largeCirc, 25, 25);
  shape(medCirc, 120, 400);
  shape(smallCirc, -100, 480);

  shape(bangShadow);
  shape(TextlabelShadow);
  shape(ParaBox);
  
  //==========================================================

  if(myPort.available() > 0){
    textValue = textValue + myPort.readString();
    
    System.out.print(textValue);
    System.out.print(myPort.readStringUntil('\n'));
    
  }
  
  //textValue = textValue + myPort.readString();
  //textValue = "test";
  //==========================================================
  
  fill(255);
  text(textValue, 22, 110, 350, 200);
  
  fill(0, 45, 90);
  textFont(headingFont);
  text("      Department of Defense \n Non-Satelite Communication", 50, 30);
}
