import controlP5.*; //import controlp5 library
//import java.io.*;

//import processing.serial.*; //this will be utilized if we want to transfer data with serials
//Serial myPort; 

ControlP5 cp5;
PFont font;
String textValue = "";

void setup(){
 size(400, 400); 
 
 cp5 = new ControlP5(this);
 font = createFont("calibri bold", 16);

 //myPort  =  new Serial (this, "COM3",  9600); //this will be utilized if we want to transfer data with serials
 //myPort.bufferUntil ( '\n' );   
 
 cp5.addTextfield("Input: ")
 .setPosition(20, 100)
 .setSize(200, 40)
 .setFont(font)
 .setFocus(true)
 .setColor(color(255, 0, 0));
 
 cp5.addBang("Submit")
 .setPosition(240, 170)
 .setSize(80, 40)
 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);    
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    String input = cp5.get(Textfield.class, "Input: ").getText();
    println("controlEvent: accessing a string from controller 'input' : "
      +input
      );
  }
  if (theEvent.getController().getName()=="Submit") {
    String input = cp5.get(Textfield.class, "Input: ").getText();
    println("controlEvent: accessing a string from controller 'input' : "
      +input
      );
    cp5.get(Textfield.class, "Input: ").clear();
  }
  
}


public void input(String theText) {
  println("a textfield event for controller 'input' : "+theText); //prints user input in "INPUT: " field 
  
}

void draw(){
 background(147, 228, 230); 
 
 fill(0,0,0);
 text("DOD \"Long Distance Communication\"", 20, 50);
}

void showInput () {

  //println(textInput_1) ; 
  // println(textInput_2) ; 
}
