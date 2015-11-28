void setup() {
  
  size(1280, 720);
  surface.setResizable(true);
  initializeDataTriangles();
  setMinimumAndMaximums();
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

float minSuicides, maxSuicides;
float minUnemployment, maxUnemployment;

void setMinimumAndMaximums () {
  
  minSuicides = 100000000;
  maxSuicides = 0;
  minUnemployment = 100000000;
  maxUnemployment = 0;
  for (int i = 0; i < dataTriangles.length; i ++) {
     
    dataTri dataTriangle = dataTriangles[i];
    float suicides = dataTriangle.suicidesInt;
    if (suicides < minSuicides) {
      minSuicides = suicides;
    }
    if (suicides > maxSuicides) {
      maxSuicides = suicides;
    }
    
    float unemployment = dataTriangle.unemploymentInt;
    if (unemployment < minUnemployment) {
      minUnemployment = unemployment;
    }
    if (unemployment > maxUnemployment) {
      maxUnemployment = unemployment;
    }
  }
}

void draw () {
  
  background(225);
  fill(255);
  drawTriangles();
  updateButton();
}

dataTri highlightedTri;

void drawTriangles () {
  
  highlightedTri = null;
  //first update the transformations and check which is highlighted
  for (int i = 0; i < dataTriangles.length; i ++) {
     
    dataTri dataTriangle = dataTriangles[i];
    dataTriangle.updateTransformations();
    dataTriangle.checkIfHighlighted();
  }
  //after that draw all the triangles 
  for (int i = 0; i < dataTriangles.length; i ++) {
     
    dataTri dataTriangle = dataTriangles[i];
    dataTriangle.drawTriangle();
  }
}

int minLength = 5;
int maxLength = 40;

class dataTri { 
  
  int year;
  float suicides;
  float unemployment;
  int suicidesInt;
  int unemploymentInt;
  float randomRotation;
  
  dataTri (int year, float suicides, float unemployment) {  
    
    this.year = year;
    this.suicides = suicides;
    this.unemployment = unemployment;
    suicidesInt = round(suicides);
    unemploymentInt = round(suicides);
    setInitialPosition(year);
    randomRotation = random(0.0, 2.0 * PI);
  } 
  
  int initialX;
  int initialY;
  
  void setInitialPosition (int year) {
    
    initialX = round(map(year, firstYear, lastYear, 0, width)); 
    initialY = height/2;
  }
  
  void updateTransformations () {
  }
  
  void checkIfHighlighted () {
    
     // * 4 should be replaced with the largest multiplier
     boolean highlighted = overCircle(initialX, initialY, unemploymentInt * 4);
     if (highlighted) {
       highlightedTri = this;
     } 
  }
  
  boolean overCircle(int x, int y, int diameter) {
    
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } else {
      return false;
    }
  }
  
  void drawTriangle () {
    
    boolean highlighted = false;
    if (highlightedTri == this) {
      highlighted = true;
    }
    setColor (highlighted);
    int suicideLength = round(map(suicides, minSuicides, maxSuicides, minLength, maxLength));
    int unemploymentLength = round(map(unemployment, minUnemployment, maxUnemployment, minLength, maxLength));
    placeTriangle (suicideLength, unemploymentLength);
    fill(255); //reset color
  }
  
  void setColor (boolean highlighted) {
    
    color col;
    if (highlighted) {
      col = color (255, 0, 0, 255);
    } else {
      col = color (255, 0, 0, 100);
    }
    fill(col);
    noStroke();
  }
  
  //this creates a right angle triangle where the right angle is on the bottom left
  //with two points on the bottom and one on the top left
  void placeTriangle (int bottomLength, int sideLength) {
    
    int xShift = bottomLength/2;
    int yShift = sideLength/2;
    int topLeftX = -xShift;
    int topLeftY = -yShift;
    int bottomLeftX = topLeftX;
    int bottomLeftY = yShift;
    int bottomRightX = xShift;
    int bottomRightY = bottomLeftY;
    pushMatrix ();
    translate (initialX, initialY);
    //rotate (randomRotation);
    triangle(topLeftX, topLeftY, bottomLeftX, bottomLeftY, bottomRightX, bottomRightY);
    popMatrix ();
  }
} 

boolean overButton = false;
  
void updateButton() {
  
  if(overButton == true) {
    fill(255);
  } else {
    noFill();
  }
  ellipse(50, 50, 75, 75);
}
  
void mousePressed() {
  
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

  if(mouseX > 50 && mouseX < 125 &&
     mouseY > 50 && mouseY <125) {
    overButton = true;   
  } else {
    overButton = false;
  }
}