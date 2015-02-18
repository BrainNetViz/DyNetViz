
class MenuButton {
  float bX, bY, bW, bH;
  String string;
  boolean bOver, bLock;
  
  MenuButton(String t) {
    string = t;
    bOver = false;
    bLock = false;
  }
  
  void draw(float x, float y, float w, float h) {
    bX = x;
    bY = y;
    bW = w;
    bH = h;
    
    stroke(20);
    strokeWeight(2);
    if (bOver || bLock) {
      fill(180, 180);
    } else {
      noFill();
    }
    rect(bX, bY, bW, bH, 5);
    
    fill(20);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(string, bX+bW/2, bY+bH/2);
    
    bOver = over();
  }
  
  boolean over() {
    if (mouseX >= bX && mouseX <= bX+bW && mouseY >= bY && mouseY <= bY+bH) {
        return true;
    } else {
        return false;
    }
  }
  
}
