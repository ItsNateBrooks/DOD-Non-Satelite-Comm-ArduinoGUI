import controlP5.*; //import controlp5 library
//=========================================
import processing.serial.*;
Serial myPort;
//=========================================

//Variable Decleration
ControlP5 cp5;

PFont headingFont;
PFont paragraphFont;
PFont inputFont;
PFont buttonFont;

String textValue = "";

PShape largeCirc;
PShape medCirc;
PShape smallCirc;

PShape bangShadow;
PShape textFieldShadow;

PShape ParaBoxShadow;
PShape ParaBox;
PShape fileBangShadow;

boolean isCaps = true;
String fileContents = "";
String fileName = "";

PGraphics textBox = new PGraphics();
PVector textBoxPos = new PVector(20,20);
float scroll = 0;

//Main/Setup
void setup() {
 
  size(800, 475, P3D);
    
  cp5 = new ControlP5(this);
  
  headingFont = createFont("calibri bold", 24);
  paragraphFont = createFont("calibri bold", 16);
  inputFont = createFont("calibri bold", 32);
  buttonFont = createFont("calibri bold", 12);
  
  //===========================================================
  printArray(Serial.list());
  myPort = new Serial(this, "COM4", 9600);
  //==========================================================
  
  largeCirc = shapeCreater(true, 175, -150, 500, 500, 147, 228, 230);
  medCirc = shapeCreater(true, 175, -150, 200, 200, 147, 228, 230);
  smallCirc = shapeCreater(true, 175, -150, 90, 90, 147, 228, 230);
  bangShadow = shapeCreater(false, 25, 235, 80, 40, 0, 45, 90);
  textFieldShadow = shapeCreater(false, 25,  155, 309, 40, 116, 159, 254);
  fileBangShadow = shapeCreater(false, 425, 335, 120, 40, 0, 45, 90);
  ParaBoxShadow = shapeCreater(false,  425, 115, 350, 200, 116, 159, 254);
  ParaBox = shapeCreater(false, 420, 110, 350, 200, 0, 45, 90);
  
  String[] keys = {"1","2","3","4","5","6","7","8","9","0","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","'","Z","X","C","V","B","N","M",",",".","?"};
  
  int pos1 = 20;
  int pos2 = 300;

//create ROWs 1-4
  for(int i = 0; i < 40; i++){
    keyboardCreater(keys[i], pos1, pos2);
    pos1 += 31;
    if(i == 9 || i == 19 || i == 29){
      pos2 += 31;
      pos1 = 20;
    }
  }
  
//create ROW 5, space, enter, backspace and caps lock
  bangCreater("Caps Lock", 20, 424, 61, 30);
  bangCreater("Space", 82, 424, 123,30);
  bangCreater("Enter", 206, 424, 61, 30);
  bangCreater("Backspace", 268, 424, 61, 30);

//create MISC buttons and bangs + textfield
  bangCreater("Send String", 20, 230, 80, 40);
  buttonCreater("Select .TXT File", 420, 330, 120, 40);
  buttonCreater("SEND .TXT File", 620, 330, 120, 40);
  
  cp5.addTextfield("Input: ")  //Creates and sets properties of input text fieldp  
    .setPosition(20, 150)
    .setSize(309, 40)
    .setFont(inputFont)
    .setFocus(true)
    .setColor(color(255, 255, 255));
  cp5.getController("Input: ").getCaptionLabel().setColor(color(116, 159, 254)); //sets "Input: " text color  
  
  textBox = createGraphics(350, 200, P3D);
}


//Functions
  void keyboardCreater(String Sym, int pos1, int pos2) {//Creates and sets properties of an individual keyboard bang (similair to button but executes on press not release)
  cp5.addBang(Sym)                        
    .setPosition(pos1, pos2)
    .setSize(30, 30)
    .setFont(paragraphFont)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    cp5.getController(Sym).setColorForeground(color(116, 159, 254));
  }
  
  void buttonCreater(String name, int pos1, int pos2, int size1, int size2){ //Creates and sets properties of an  button
    cp5.addButton(name)                   
    .setPosition(pos1, pos2)
    .setSize(size1,size2)
    .setFont(buttonFont)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    cp5.getController(name).setColorBackground(color(116, 159, 254));
  }
  
  void bangCreater(String name, int pos1, int pos2, int size1, int size2){ //Creates and sets properties of an individual keydoard bang (similair to button but executes on press not release)
    cp5.addBang(name)                    
    .setPosition(pos1, pos2)
    .setSize(size1,size2)
    .setFont(buttonFont)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    cp5.getController(name).setColorForeground(color(116, 159, 254));
  }
  
  PShape shapeCreater(boolean isEllipse, int pos1, int pos2, int size1, int size2, int col1, int col2, int col3) {
    if(isEllipse){
      PShape shape = createShape(ELLIPSE, pos1, pos2, size1, size2);                 // creates and sets properties of circle
      shape.setFill(color(col1, col2, col3));
      shape.setStroke(false);
      return shape;
    }
    else{
      PShape shape = createShape(RECT, pos1, pos2, size1, size2);                 // creates and sets properties of circle
      shape.setFill(color(col1, col2, col3));
      shape.setStroke(false);
      return shape; 
    }
    
  }

//Button & Bang Functionality
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    textValue = cp5.get(Textfield.class, "Input: ").getText();
    println("String Entered: "+textValue);
    //==========================================================
    myPort.write(textValue);
    //==========================================================
    println("String Sent: "+textValue);
    cp5.get(Textfield.class, "Input: ").clear();
    textValue = "";
    println("Text Box Cleared");
  }
  
  switch (theEvent.getController().getName()) {
            case "Caps Lock":
              if(isCaps){
                isCaps = false;
              }
              else{
                isCaps = true;
              }
              break;
            case "SEND .TXT File":
              println(".TXT File Sending: "+fileContents);
              //==========================================================
              myPort.write(fileContents);
              //==========================================================
              println(".TXT File Sent");
              fileContents = "";
              fileName = "";
              println("File Contents and Name Cleared");
              break;
            case "Send String":    
              textValue = cp5.get(Textfield.class, "Input: ").getText();
              println("String Entered: "+textValue);
              //==========================================================
              myPort.write(textValue);
              //==========================================================
              println("String Sent: "+textValue);
              cp5.get(Textfield.class, "Input: ").clear();
              textValue = "";
              println("Text Box Cleared");
              break;
            case "Select .TXT File":
                selectInput("Select a file to process:", "fileSelected");
              break;
            //1st Row Functionality
            case "1":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"1");
              break;
            case "2":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"2");
              break;
            case "3":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"3");
              break;
            case "4":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"4");
              break;
            case "5":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"5");
              break;
            case "6":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"6");
              break;
            case "7":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"7");
              break;
            case "8":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"8");
              break;
            case "9":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"9");
              break;
            case "0":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"0");
              break;
              
              
            //2nd Row Functionality
            case "Q":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "Q" : "q"));
              break;
            case "W":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "W" : "w"));
              break;
            case "E":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "E" : "e"));
              break;
            case "R":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "R" : "r"));
              break;
            case "T":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "T" : "t"));
              break;
            case "Y":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "Y" : "y"));
              break;
            case "U":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "U" : "u"));
              break;
            case "I":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "I" : "i"));
              break;
            case "O":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "O" : "o"));
              break;
            case "P":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "P" : "p"));
              break;
              
            //3rd Row Functionality
            case "A":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "A" : "a"));
              break;
            case "S":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "S" : "s"));
              break;
            case "D":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "D" : "d"));
              break;
            case "F":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "F" : "f"));
              break;
            case "G":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "G" : "g"));
              break;
            case "H":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "H" : "h"));
              break;
            case "J":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "J" : "j"));
              break;
            case "K":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "K" : "k"));
              break;
            case "L":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "L" : "l"));
              break;
            case "'":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"'");
              break;
              
              
            //4th Row Functionality
            case "Z":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "Z" : "z"));
              break;
            case "X":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "X" : "x"));
              break;
            case "C":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "C" : "c"));
              break;
            case "V":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "V" : "v"));
              break;
            case "B":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "B" : "b"));
              break;
            case "N":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "N" : "n"));
              break;
            case "M":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+((isCaps == true) ? "M" : "m"));
              break;
            case ",":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+",");
              break;
            case ".":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+".");
              break;
            case "?":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+"?");
              break;
              
            
            //5th Row Functionality
            case "Enter":
              textValue = cp5.get(Textfield.class, "Input: ").getText();
              println("String Entered: "+textValue);
              //==========================================================
              myPort.write(textValue);
              //==========================================================
              println("String Sent: "+textValue);
              cp5.get(Textfield.class, "Input: ").clear();
              textValue = "";
              println("Text Box Cleared");
            case "Space":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText()+" ");
              break;
            case "Backspace":
              cp5.get(Textfield.class, "Input: ").setText(cp5.get(Textfield.class, "Input: ").getText().substring(0, cp5.get(Textfield.class, "Input: ").getText().length() - 1));
              break;
              
            default:
              break;
    }
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String[] lines = loadStrings(selection.getAbsolutePath());
    fileName = selection.getName();
    println(fileName);
    println("There are " + lines.length + " lines.");
    printArray(lines);
    for(int i = 0; i < lines.length; i++)
      if(i == lines.length - 1){
        fileContents += lines[i];
      }
      else{
      fileContents += lines[i] + "\n";
      }
  }
}

void draw() {
  background(255, 255, 255);
  
  shape(largeCirc, 25, 25);
  shape(medCirc, 120, 400);
  shape(smallCirc, -100, 480);
  shape(medCirc, 420, 500);
  shape(smallCirc, 500, 240);

  shape(bangShadow);
  shape(textFieldShadow);
  shape(fileBangShadow);
  shape(fileBangShadow, 200, 0);
  
  shape(ParaBoxShadow);
  shape(ParaBox);

  fill(0, 45, 90);
  textFont(headingFont);
  text("      Department of Defense \n Non-Satelite Communication", 50, 30);
  
  fill(0, 45, 90);
  textFont(headingFont);
  text(".TXT File Sending", 500, 30);
  
  fill(116, 159, 254);
  text("File Contents:", 422, 90, 350, 200);
  
  textBox.beginDraw();
    textBox.background(0,0,0,0);  // Transparent background but you could have it coloured.
    textBox.stroke(0,0,0);
    textBox.fill(0,0,0,0);
    textBox.rect(0, 0, textBox.width-1, textBox.height-1);  // Black rectangle around the outside.
    textBox.textSize(24);
    textBox.fill(255);
    textBox.textAlign(LEFT, TOP);
    textBox.text(fileContents, 0, scroll, textBox.width, textBox.height+10000);
  textBox.endDraw();

  image(textBox, textBoxPos.x+400, textBoxPos.y+90); 
  
}

void mouseWheel(MouseEvent event){
  scroll -= event.getCount()*10;
}
