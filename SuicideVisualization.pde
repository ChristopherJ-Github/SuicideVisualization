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
  
  dataTri (int year, float suicides, float unemployment) {  
    
    this.year = year;
    this.suicides = suicides;
    this.unemployment = unemployment;
    setInitialPosition(year);
  } 
  
  PVector initialPosition;
  
  void setInitialPosition (int year) {
    
    int x = round(map(year, firstYear, lastYear, 0, width)); 
    int y = height/2;
    initialPosition = new PVector(x, y);
  }
  
  void update() { 
    
    ellipse(initialPosition.x, initialPosition.y, 55, 55);
  } 
} 