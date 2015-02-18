
class ReadFile {
  String inputFile;
  int rows, cols;
  int[][] value;
  
  ReadFile(String fileName, int c) {
    inputFile = fileName;
    rows = loadStrings(inputFile).length;
    cols = c;
  }
  
  void setCols() {
    // first 2 rows of DM file are node ids and node degrees
    cols = rows - 2;  
  }
  
  void load() {
    String[] lines = loadStrings(inputFile);
    value = new int[rows][cols];

    for (int i=0; i<rows; i++) {      
      String[] columns = splitTokens(lines[i]);     // split the row on the tabs
      for (int j=0; j<cols; j++) {
        value[i][j] = parseInt(columns[j]);
      }
    }
  } // end-load()
  
} // end-class

/*******************************************************************************/
// get Max or Min value of the array
public int indexMin = 0, indexMax = 0;

int getMax(int[] value, int num) {
  int m = -Number.MAX_VALUE;
  for (int i=0; i<num-1; i++) {
    if (value[i] > m) {
      m = value[i];
      indexMax = i;
    }
  }
  return m;
}

int getMin(int[] value, int num) {
  int m = Number.MAX_VALUE;
  for (int i=0; i<num-1; i++) {
    if (value[i] < m) {
      m = value[i];
      indexMin = i;
    }
  }
  return m;
}
