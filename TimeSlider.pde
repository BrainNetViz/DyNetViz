// time slider

class TimeSlider {
  float xPos, yPos;
  float bWidth, bHeight;   // width and height of bar
  float sPos, newsPos;     // x position of slider
  float sposMin, sposMax;  // max and min values of slider
  float loose = 1;         // how loose/heavy
  boolean locked = false;
  
  TimeSlider(float x0, float x1, float y, float h) {
    xPos = x0;
    yPos = y;
    bWidth = x1-x0;    
    bHeight = h;
    sPos = xPos + (currentFrame-1)/float(time_step-1)*bWidth;
    newsPos = sPos;
    sposMin = x0;
    sposMax = x1;     
  }
  
  void draw() {   
    update();
    display();
  }
  
  void update() {
    if (mousePressed && over()) {
      locked = true;
      Play.bLock = false;
      Pause.bLock = false;
      Stop.bLock = false;
    }
    if (locked) {
      newsPos = constrain(mouseX, sposMin, sposMax); 
    }
    if (abs(newsPos - sPos) > 1) {
      sPos = sPos + (newsPos-sPos)/loose;
    }
  }
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }
  
  boolean over() {
    if (mouseX > sPos-bHeight*3/2 && mouseX < sPos+bHeight*3/2 && mouseY > yPos-bHeight && mouseY < yPos+bHeight*2) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    stroke(80);
    strokeWeight(1.5);
    fill(145);
    rect(xPos, yPos, bWidth, bHeight, 5);
    
    currentFrame = round((sPos-xPos)*(time_step-1)/bWidth) + 1;
    
    //noStroke();
    if (over() || locked) {
      fill(40);
    } else {
      fill(85);
    }
    ellipse(sPos, yPos+bHeight/2, bHeight*3, bHeight*3);
  }
  
}
