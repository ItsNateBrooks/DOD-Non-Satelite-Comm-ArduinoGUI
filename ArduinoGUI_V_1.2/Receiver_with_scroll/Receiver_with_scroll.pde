import controlP5.*; //import controlp5 library
import java.io.FileWriter;

//=========================================
import processing.serial.*;
Serial myPort;
//=========================================

ControlP5 cp5;

PFont headingFont;
PFont paragraphFont;
PFont inputFont;
PFont buttonFont;

String textValue = "RECIEVED: ";
String fileName = "";
String fileContents = "";

PShape largeCirc;
PShape medCirc;
PShape smallCirc;

PShape ParaBoxShadow;
PShape ParaBox;
PShape bangShadow;
PShape bang2Shadow;

PGraphics textBox = new PGraphics();
PVector textBoxPos = new PVector(20, 20);
float scroll = 0;

void setup() {

  size(800, 475, P3D);

  cp5 = new ControlP5(this);

  headingFont = createFont("calibri bold", 24);
  paragraphFont = createFont("calibri bold", 16);
  inputFont = createFont("calibri bold", 32);
  buttonFont = createFont("calibri bold", 12);

  //===========================================================
  printArray(Serial.list());
  myPort = new Serial(this, "COM3", 9600);
  //==========================================================

  largeCirc = shapeCreater(true, 175, -150, 500, 500, 147, 228, 230);
  medCirc = shapeCreater(true, 175, -150, 200, 200, 147, 228, 230);
  smallCirc = shapeCreater(true, 175, -150, 90, 90, 147, 228, 230);

  ParaBoxShadow = shapeCreater(false, 25, 95, 750, 300, 116, 159, 254);
  ParaBox = shapeCreater(false, 20, 90, 750, 300, 0, 45, 90);

  bangShadow = shapeCreater(false, 25, 425, 80, 40, 0, 45, 90);
  bang2Shadow = shapeCreater(false, 615, 425, 160, 40, 0, 45, 90);

  bangCreater("Clear", 20, 420, 80, 40);
  buttonCreater("Download as .TXT", 610, 420, 160, 40);

  textBox = createGraphics(750, 300, P3D);
}


void bangCreater(String name, int pos1, int pos2, int size1, int size2) { //Creates and sets properties of an individual keydoard bang (similair to button but executes on press not release)
  cp5.addBang(name)
    .setPosition(pos1, pos2)
    .setSize(size1, size2)
    .setFont(buttonFont)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getController(name).setColorForeground(color(116, 159, 254));
}
void buttonCreater(String name, int pos1, int pos2, int size1, int size2) { //Creates and sets properties of an individual keydoard bang (similair to button but executes on press not release)
  cp5.addButton(name)
    .setPosition(pos1, pos2)
    .setSize(size1, size2)
    .setFont(buttonFont)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getController(name).setColorBackground(color(116, 159, 254));
}

PShape shapeCreater(boolean isEllipse, int pos1, int pos2, int size1, int size2, int col1, int col2, int col3) {
  if (isEllipse) {
    PShape shape = createShape(ELLIPSE, pos1, pos2, size1, size2);                 // creates and sets properties of circle
    shape.setFill(color(col1, col2, col3));
    shape.setStroke(false);
    return shape;
  } else {
    PShape shape = createShape(RECT, pos1, pos2, size1, size2);                 // creates and sets properties of circle
    shape.setFill(color(col1, col2, col3));
    shape.setStroke(false);
    return shape;
  }
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName()=="Clear") {
    textValue = "RECIEVED: ";
    recievedString = "";
    fileName = "";
    fileContents = "";
  }
  if (theEvent.getController().getName()=="Download as .TXT") {
    if (fileName != "")
      createFile(fileName, fileContents);
    else
      selectOutput("Select a file to write to:", "fileSelected");
  }
}

void parseString(String recString) {
  String[] fileInfo = recString.split("###", 3);
  printArray(fileInfo);
  println(fileInfo.length);
  if (fileInfo.length == 3) {
    fileContents = fileInfo[1];
     textValue += fileInfo[1];
    fileName = fileInfo[0];
     recievedString = "";
  } else if (fileInfo.length == 2) {
    //createFile(fileInfo);
    //textValue += fileInfo[1];
    //fileName = fileInfo[0];
    //fileContents = fileInfo[1];
  } else {
    fileContents = fileInfo[0];
    textValue = recString;
  }
}

void createFile(String fileName, String FileContents) {
  try {
    String home = System.getProperty("user.home");
    FileWriter myWriter = new FileWriter(home+"/Downloads/" + fileName);
    myWriter.write(FileContents);
    myWriter.close();
    System.out.println("Successfully wrote to the file.");
  }
  catch (IOException e) {
    System.out.println("An error occurred.");
    e.printStackTrace();
  }
}


void draw() {
  background(255, 255, 255);

  shape(largeCirc, 25, 25);
  shape(medCirc,  250, 600);
  shape(smallCirc, -150, 400);
  shape(largeCirc, 725, 425);
  shape(medCirc, 350, 250);
  shape(smallCirc, 100, 575);

  shape(bangShadow);
  shape(bang2Shadow);
  shape(ParaBoxShadow);
  shape(ParaBox);

  //==========================================================
 
  if(myPort.available() > 0){
  recievedString = recievedString + myPort.readString();

   // parseString(recievedString);
   fileContents = recievedString;
   textValue = recievedString;

  System.out.print(recievedString);
  //System.out.print(myPort.readStringUntil('\n'));

  }

  //==========================================================

  fill(0, 45, 90);
  textFont(headingFont);
  text("      Department of Defense \n Non-Satelite Communication", 50, 30);

  textBox.beginDraw();
  textBox.background(0, 0, 0, 0);  // Transparent background but you could have it coloured.
  textBox.stroke(0, 0, 0);
  textBox.fill(0, 0, 0, 0);
  textBox.rect(0, 0, textBox.width-1, textBox.height-1);  // Black rectangle around the outside.
  textBox.textSize(24);
  textBox.fill(255);
  textBox.textAlign(LEFT, TOP);
  textBox.text(textValue, 0, scroll, textBox.width, textBox.height+10000);
  textBox.endDraw();

  image(textBox, textBoxPos.x, textBoxPos.y+70);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    createFile(selection.getName(), fileContents);
  }
}


void mouseWheel(MouseEvent event) {
  scroll -= event.getCount()*10;
}
