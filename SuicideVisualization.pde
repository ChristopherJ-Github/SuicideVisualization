void setup() {
  
  size(1280, 720);
  initializeDataTriangles();
}

dataTri[] dataTriangles;

void initializeDataTriangles () {
  
  Table suicideTable = loadTable("suicide indicator age adjusted -05 extrapolated UL 2020100818b JAPAN.csv", "header");
  Table unemploymentTable = loadTable("indicator_t above 15 unemploy JAPAN.csv", "header");
  String[] suicideDataStr = suicideTable.getStringColumn("Suicide, age adjusted, per 100 000 standard population");
  String[] unemploymentDataStr = unemploymentTable.getStringColumn("Total 15+ unemployment (%)");
  String[] yearsStr = suicideTable.getStringColumn("Year");
  setFirstAndLastYears(yearsStr);
  dataTriangles = new dataTri[yearsStr.length];
  for (int i = 0; i < dataTriangles.length; i ++) {
     
    float unemployment = Float.parseFloat(unemploymentDataStr[i]);
    float suicides = Float.parseFloat(suicideDataStr[i]);
    int year = Integer.parseInt(yearsStr[i]);
    dataTri dataTriangle = new dataTri(year, suicides, unemployment);
    dataTriangles[i] = dataTriangle;
  }
}

int firstYear, lastYear;

void setFirstAndLastYears (String[] yearsStr) {
  
  firstYear = Integer.parseInt(yearsStr[0]);
  lastYear = Integer.parseInt(yearsStr[yearsStr.length - 1]);
}

void draw () {
  
  background(225);
  drawTriangles();
}

void drawTriangles () {
  
  for (int i = 0; i < dataTriangles.length; i ++) {
     
    dataTri dataTriangle = dataTriangles[i];
    dataTriangle.update();
  }
}

class dataTri { 
  
  int year;
  float suicides;
  float unemployment;
  int suicidesInt;
  int unemploymentInt;
  
  dataTri (int year, float suicides, float unemployment) {  
    
    this.year = year;
    this.suicides = suicides;
    this.unemployment = unemployment;
    suicidesInt = round(suicides);
    unemploymentInt = round(suicides);
    setInitialPosition(year);
  } 
  
  int initialX;
  int initialY;
  
  void setInitialPosition (int year) {
    
    initialX = round(map(year, firstYear, lastYear, 0, width)); 
    initialY = height/2;
  }
  
  void update() { 
    
    placeTriangle(suicidesInt, unemploymentInt, 4, 4);
  }
  
  //this creates a right angle triangle where the right angle is on the bottom left
  //with two points on the bottom and one on the top left
  void placeTriangle (int sideValue, int bottomValue, int sideMultiplier, int bottomMultiplier) {
    
    int xShift = (bottomValue/2) * bottomMultiplier;
    int yShift = (sideValue/2) * sideMultiplier;
    int topLeftX = initialX - xShift;
    int topLeftY = initialY - yShift;
    int bottomLeftX = topLeftX;
    int bottomLeftY = initialY + yShift;
    int bottomRightX = initialX + xShift;
    int bottomRightY = bottomLeftY;
    triangle(topLeftX, topLeftY, bottomLeftX, bottomLeftY, bottomRightX, bottomRightY);
  }
} 

class links{
  boolean overButton = false;
  
  void update(){
      if(overButton == true) {

    fill(255);

  } else {

    noFill();

  }

ellipse(height/2, width/2, 75, 75);
  }
  
  void mousePressed() 

{

  if(overButton) { 

    link("http://www.economist.com/node/10329261");

  } 

}

void mouseMoved() { 

  checkButtons(); 

}

void mouseDragged() {

  checkButtons(); 

}

void checkButtons() {

  if(mouseX > 20 && mouseX < 95 &&

     mouseY > 60 && mouseY <135) {

    overButton = true;   

  } 
}
}