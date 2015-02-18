
class MatButton {
  float bX, bY, bW;
  String type;
  boolean bOver;

  MatButton(String t) {
    type = t;
    bOver = false;
  }
  
  void draw(float x, float y, float w) {
    bX = x;
    bY = y;
    bW = w;
    
    if (type == "edge") {
      rect(bX, bY, bW, bW);
    } else if (type == "node") {
      ellipse(bX, bY, bW, bW);
    }
    
    bOver = over();
  }
  
  boolean over() {
    if (type == "edge") {
      if (mouseX >= bX && mouseX <= bX+bW && mouseY >= bY && mouseY <= bY+bW) {
        return true;
      } else {
        return false;
      }
    } else if (type == "node") {
      if (mouseX >= bX-bW/2 && mouseX <= bX+bW/2 && mouseY >= bY-bW/2 && mouseY <= bY+bW/2) {
        return true;
      } else {
        return false;
      }     
    } else {
      return false;
    }
  }
  
}
