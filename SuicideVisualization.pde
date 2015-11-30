PImage cool;
String articleText = "";
String state;

void setup() {
  
  cool = loadImage("japan.jpg");
  frameRate(60);
  size(1280, 720);
  surface.setResizable(true);
  initializeDataTriangles();
  String[] lines = loadStrings("textTest.txt");
  for (int i = 0 ; i < lines.length; i++) {
    articleText += lines[i];
    articleText += "\n";
  }
  state = "default";
}

dataTri[] dataTriangles;

void initializeDataTriangles () {
  
  Table suicideTable = loadTable("suicide indicator age adjusted -05 extrapolated UL 2020100818b JAPAN.csv", "header");
  Table unemploymentTable = loadTable("indicator_t above 15 unemploy JAPAN.csv", "header");
  String[] suicideDataStr = suicideTable.getStringColumn("Suicide, age adjusted, per 100 000 standard population");
  String[] unemploymentDataStr = unemploymentTable.getStringColumn("Total 15+ unemployment (%)");
  String[] yearsStr = suicideTable.getStringColumn("Year");
  setMinimumAndMaximums(suicideDataStr, unemploymentDataStr);
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

float minSuicides, maxSuicides;
float minUnemployment, maxUnemployment;

void setMinimumAndMaximums (String[] suicideDataStr, String[] unemploymentDataStr) {
  
  minSuicides = 100000000;
  maxSuicides = 0;
  minUnemployment = 100000000;
  maxUnemployment = 0;
  for (int i = 0; i < suicideDataStr.length; i ++) {
     
    float suicides = Float.parseFloat(suicideDataStr[i]);
    if (suicides < minSuicides) {
      minSuicides = suicides;
    }
    if (suicides > maxSuicides) {
      maxSuicides = suicides;
    }
    
    float unemployment = Float.parseFloat(unemploymentDataStr[i]);
    if (unemployment < minUnemployment) {
      minUnemployment = unemployment;
    }
    if (unemployment > maxUnemployment) {
      maxUnemployment = unemployment;
    }
  }
}

int firstYear, lastYear;

void setFirstAndLastYears (String[] yearsStr) {
  
  firstYear = Integer.parseInt(yearsStr[0]);
  lastYear = Integer.parseInt(yearsStr[yearsStr.length - 1]);
}

void draw () {
  
  image(cool, 0, 0, width, height);
  drawTriangles();
  updateButton(); 
}

float timePassed = 0.0;
float waveSpeed = 0.005;
float waveHighlightedSpeed = 0.001;
dataTri highlightedTri;
dataTri clickedTri;

void drawTriangles () {
  
  //this is based off of the last highlighted object so it's
  //not entirely accurate
  if (highlightedTri != null) {  
    timePassed += waveHighlightedSpeed;
  } else {
    timePassed += waveSpeed;
  }
  updateClickShift (); 
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

float currentClickShift;

void updateClickShift () {
  
  float clickShift = (height / 2) - 100;
  if (state == "clicked") {
    currentClickShift = clickShift;
  } 
  if (state == "default") {
    currentClickShift = 0;
  }
}

int minLength = 10;
int maxLength = 100;
float amplitude = 20.0;
float frequency = ((2 * PI)/1.02); //to accuratley change, just edit the 2nd decimal place in the divisor

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
    unemploymentInt = round(unemployment);
    setInitialPosition(year);
    randomRotation = random(0.0, 2.0 * PI);
    setLengths();
  } 
  
  int suicideLength, unemploymentLength;
  int longestLength;
  void setLengths () {
    
    suicideLength = round(map(suicides, minSuicides, maxSuicides, minLength, maxLength));
    unemploymentLength = round(map(unemployment, minUnemployment, maxUnemployment, minLength, maxLength));
    if (suicideLength > unemploymentLength) {
      longestLength = suicideLength;
    } else {
      longestLength = unemploymentLength;
    }
  }
  
  int initialX;
  int initialY;
  
  void setInitialPosition (int year) {
    
    int padding = 50; //padding affects the sin wave's frequency
    initialX = round(map(year, firstYear, lastYear, padding, width - padding)); 
    initialY = height/2;
  }
  
  void updateTransformations () {
    
    currentPositionX = initialX;
    currentPositionY = initialY + (amplitude*sin((initialX + timePassed) * frequency)) - currentClickShift;
  }
  
  void checkIfHighlighted () {
    
     boolean highlighted = overCircle(round(currentPositionX), round(currentPositionY), longestLength);
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
    
    int bottomLength = suicideLength;
    int sideLength = unemploymentLength;
    boolean highlighted = false;
    if (highlightedTri == this) {
      highlighted = true;
      checkIfClicked(bottomLength, sideLength);
    }
    if (clickedTri == this && state == "clicked") {
      drawDetailedTriangle (bottomLength, sideLength);
      drawArticleText ();
    }
    setColor (highlighted);
    placeTriangle (bottomLength, sideLength);
    fill(255); //reset color
  }
  
  void checkIfClicked (int bottomLength, int sideLength) {
    
    if (mousePressed) {
      clickedTri = this;
      state = "clicked";
    }
  }
  
  void drawDetailedTriangle (int bottomLength, int sideLength) {
    
    int fontSize = 20;
    int padding = 10;
    float minLargeLength = 10;
    float maxLargeLength = (width * (1.0/4.0)) - (padding + fontSize);
    float topLeftX = padding + fontSize;
    float topLeftY = height - (padding + fontSize + map(sideLength, minLength, maxLength, minLargeLength, maxLargeLength));
    float bottomLeftX = topLeftX;
    float bottomLeftY = height - (padding + fontSize);
    float bottomRightX = map(bottomLength, minLength, maxLength, minLargeLength, maxLargeLength) + padding + fontSize;
    float bottomRightY = bottomLeftY;
    fill(255, 255, 255, 150);
    triangle(topLeftX, topLeftY, bottomLeftX, bottomLeftY, bottomRightX, bottomRightY);
    drawText (padding, fontSize);
  }
  
  void drawText (int padding, int fontSize) {
    
    textSize(fontSize);
    fill(255, 255, 255, 255);
    
    pushMatrix();
    textAlign (BOTTOM, RIGHT);
    translate(fontSize, height - (padding + fontSize));
    rotate(-PI/2);
    String title = unemployment + " % Unemployment";
    text(title, 0, 0);
    popMatrix();
    
    pushMatrix();
    textAlign (BOTTOM, LEFT);
    translate(fontSize, height);
    title = suicidesInt + " Suicides Per 100,000";
    text(title, 0, 0);
    popMatrix();
  }
  
  void drawArticleText () {
    
    float padding = 10;
    float yShift = (height/2) + padding;
    float xShift = (width * (1.0/4.0)) + padding;
    float articleWidth = width - xShift - padding;
    float articleHeight = 1000;
    textSize(13);
    fill(255);
    text(articleText, xShift, yShift, articleWidth, articleHeight);
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
  
  float currentPositionX;
  float currentPositionY;
  
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
    translate (currentPositionX, currentPositionY);
    rotate (randomRotation);
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