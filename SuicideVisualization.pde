Table table;

void setup() {
  
  table = loadTable("indicator_t above 15 unemploy JAPAN.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  for (TableRow row : table.rows()) {
    
   float percentage = row.getFloat("Total 15+ unemployment (%)");
   String year = row.getString("Year");
   println("year: " + year + ", percentage: " + percentage);
  }
}

void draw () {
}