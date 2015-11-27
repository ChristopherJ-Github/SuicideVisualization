void setup() {
  
  size(1280, 720);
  InitializeUnemploymentData();
  InitializeSuicideData();
  InitializeYears();
}

float[] unemploymentData;

void InitializeUnemploymentData () {
  
  Table unemploymentTable = loadTable("indicator_t above 15 unemploy JAPAN.csv", "header");
  String[] unemploymentDataStr = unemploymentTable.getStringColumn("Total 15+ unemployment (%)");
  unemploymentData = new float[unemploymentDataStr.length];
  for (int i = 0; i < unemploymentData.length; i ++) {
    
    float value = Float.parseFloat(unemploymentDataStr[i]);
    unemploymentData[i] = value;
  }
}

float[] suicideData;

void InitializeSuicideData () {
  
   Table suicideTable = loadTable("suicide indicator age adjusted -05 extrapolated UL 2020100818b JAPAN.csv", "header");
   String[] suicideDataStr = suicideTable.getStringColumn("Suicide, age adjusted, per 100 000 standard population");
   suicideData = new float[suicideDataStr.length];
   for (int i = 0; i < suicideData.length; i ++) {
    
     float value = Float.parseFloat(suicideDataStr[i]);
     suicideData[i] = value;
   }
}

int[] years;

void InitializeYears () {
  
  Table suicideTable = loadTable("suicide indicator age adjusted -05 extrapolated UL 2020100818b JAPAN.csv", "header");
  String[] yearsStr = suicideTable.getStringColumn("Year");
  years = new int[yearsStr.length];
  for (int i = 0; i < years.length; i ++) {
    
     int value = Integer.parseInt(yearsStr[i]);
     years[i] = value;
  }
}

void draw () {
 
}