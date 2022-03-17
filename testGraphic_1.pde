import controlP5.*; //import controlp5 library


ControlP5 cp5;
PFont font;
String textValue = "";

void setup(){
 size(400, 400); 
 
 cp5 = new ControlP5(this);
 font = createFont("calibri bold", 16);
 

 
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
    println("controlEvent: accessing a string from controller '"
      +theEvent.getName()+"': "
      +theEvent.getStringValue()
      );
  }

}


public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
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
