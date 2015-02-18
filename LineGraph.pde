// line graph on timeline

class LineGraph {
  
  int time;
  int[] value;
  int vMin, vMax;
  float xMin, xMax, yMin, yMax;
  String string;
  color gColor;
  
  LineGraph(float x0, float y0, float x1, float y1, String s) {   
    xMin = x0;
    yMin = y0;
    xMax = x1;
    yMax = y1;
    string = s;
  }
  
  void draw(int[] v, int t, int m, color c) {
    
    time = t;
    value = new int[time];
    for (int i=0; i<time; i++) {
      value[i] = v[i];
    }
    vMin = 0;
    vMax = m;
    gColor = c;
    
    // axis
    stroke(120);
    strokeWeight(2);
    line(xMin, yMin-20, xMin, yMax);  // y
    line(xMin, yMin-20, xMin-5, yMin-15);
    line(xMin, yMin-20, xMin+5, yMin-15);
    line(xMin, yMax, xMax, yMax);    // x
    fill(20);
    textSize(12);
    textAlign(CENTER, TOP);
    text("1", xMin, yMax+10);  
    text("41", xMax, yMax+10);
    text("TIME", (xMin+xMax)/2, yMax+20);
    textAlign(RIGHT, CENTER); 
    text("0", xMin-5, yMax);
    text(vMax, xMin-5, yMin);
    text(string, xMin-5, (yMin+yMax)/2);
    
    // line
    stroke(gColor);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i=0; i<time; i++) {
      float x = map(i, 0, time-1, xMin, xMax);
      float y = map(value[i], vMin, vMax, yMax, yMin);
      vertex(x, y); 
    }
    endShape();    
    // point    
    for (int i=0; i<time; i++) {
      float x = map(i, 0, time-1, xMin, xMax);
      float y = map(value[i], vMin, vMax, yMax, yMin);       
      // highlight
      if (currentFrame-1 == i) {
        strokeWeight(1);
        fill(gColor, 180);
        rect(x-4, y, 8, yMax-y);
        fill(gColor);
        textAlign(CENTER, BOTTOM);
        text(value[i], x, y-10);
      }
      strokeWeight(5);
      point(x, y);
    }       
  } // end - draw
  
}
