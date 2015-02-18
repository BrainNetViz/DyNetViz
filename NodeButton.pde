// node button in the node-link diagram

class NodeButton {
  int index;
  float Margin, W, H;
  float bX, bY, bW;
  float xPos, newxPos;
  float yPos, newyPos;
  float xposMin, xposMax;
  float yposMin, yposMax;
  float loose = 1;         // how loose/heavy  
  boolean bOver;
  boolean locked;
  
  NodeButton(int i, float margin, float w, float h, float size) {
    index = i;
    Margin = margin;
    W = w;
    H = h;
    bX = margin + (XYpos.value[i][1] - minY)*w/float(maxY - minY);
    bY = margin + (XYpos.value[i][0] - minX)*h/float(maxX - minX);
    bW = size;
    
    xPos = bX;
    newxPos = xPos;
    yPos = bY;
    newyPos = yPos;
    
    xposMin = bX - bW*5;
    xposMax = bX + bW*5;
    yposMin = bY - bW*5;
    yposMax = bY + bW*5;
    
    bOver = false;
    locked = false;
  }
  
  void draw() {   
    update();
    display();
  }
  
  void update() {
    /*if (mousePressed && over()) {
      locked = true;
    }*/
    bOver = over();
    if (locked) {
      newxPos = constrain(mouseX, xposMin, xposMax); 
      newyPos = constrain(mouseY, yposMin, yposMax); 
    }
    if (sqrt(sq(newxPos-xPos)+sq(newyPos-yPos)) > 1) {
      xPos = xPos + (newxPos-xPos)/loose;
      yPos = yPos + (newyPos-yPos)/loose;
    }
  }
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }
  
  boolean over() {
    if (mouseX > xPos-bW/2 && mouseX < xPos+bW/2 && mouseY > yPos-bW/2 && mouseY < yPos+bW/2) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    noStroke();
    noFill();
    ellipse(xPos, yPos, bW, bW);
    
    XYpos.value[index][1] = int((xPos-Margin)*(maxY - minY)/W + minY);
    XYpos.value[index][0] = int((yPos-Margin)*(maxX - minX)/H + minX);
  }
  
}
