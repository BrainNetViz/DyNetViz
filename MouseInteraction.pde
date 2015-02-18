
public int selectedMatButtonEdge = -1;
public int selectedMatButtonNode = -1;
public int selectedNLButton = -1;

void mouseClicked() {
  // interaction with matrix cell
  for (int i=0; i<node_num*node_num; i++) {
    if (matrixButtonEdge[i].bOver && mouseButton==LEFT) {
      selectedMatButtonEdge = i;  // scan vertically (0 ~ node_num*node_num-1)
      //println("selectedMatButtonEdge: " + selectedMatButtonEdge);
      selectedMatButtonNode = -1;
    } else if (matrixButtonEdge[i].bOver && mouseButton==RIGHT) {
      selectedMatButtonEdge = -1;
    }
  }
  // interaction with matrix node
  for (int i=0; i<node_num*3; i++) {
    if (matrixButtonNode[i].bOver && mouseButton==LEFT) {
      selectedMatButtonNode = i%node_num;  // scan vertically (0 ~ node_num-1)
      //println("selectedMatButtonNode: " + selectedMatButtonNode);    
      selectedMatButtonEdge = -1;
    } else if (matrixButtonNode[i].bOver && mouseButton==RIGHT) {
      selectedMatButtonNode = -1;
    }
  }
  
  // menu buttons
  if (Help.bOver) {
    if (Help.bLock) {
      Help.bLock = false;
    } else {
      Help.bLock = true;
    }    
  }
  if (Reset.bOver) {
    selectedMatButtonEdge = -1;
    selectedMatButtonNode = -1;
    currentFrame = 1;
    timeSlider.newsPos = timeSlider.xPos;
    transitionMode = false;    
    Help.bLock = false;
    Reset.bLock = false;
    Transit.bLock = false;
    Play.bLock = false;
    Pause.bLock = false;
    Stop.bLock = false;
  }
  if (Transit.bOver) {
    if (Transit.bLock) {
      Transit.bLock = false;
    } else {
      Transit.bLock = true;
    }
    transitionMode = Transit.bLock;
  }
  if (Play.bOver) {
    Play.bLock = true;
    Pause.bLock = false;
    Stop.bLock = false;
  }
  if (Pause.bOver) {
    Play.bLock = false;
    Pause.bLock = true;
    Stop.bLock = false;
  }
  if (Stop.bOver) {
    Play.bLock = false;
    Pause.bLock = false;
    Stop.bLock = true;
    currentFrame = 1;
    timeSlider.newsPos = timeSlider.xPos;
  }
  //
}


void mousePressed() {
  // moving overlapped nodes
  for (int i=0; i<node_num; i++) {
    if (nlButton[i].bOver) {
      selectedNLButton = i;
    }    
  }
  if (selectedNLButton != -1) {
    nlButton[selectedNLButton].locked = true;
  }
}


void mouseReleased() {
  timeSlider.locked = false;
  if (selectedNLButton != -1) {
    nlButton[selectedNLButton].locked = false;
    selectedNLButton = -1;
  }
}

/*
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT && currentFrame > 1) {
      currentFrame--;
      println("currentFrame: " + currentFrame);
    } else if (keyCode == RIGHT && currentFrame < time_step) {
      currentFrame++;
      println("currentFrame: " + currentFrame);
    }
    
    //
    for (int i=0; i<node_num; i++) {
      for (int j=0; j<node_num; j++) {
        distMat[i][j] = -2;
        distMat_prev[i][j] = -2;
      }
    }
    
    matrixIndex = new int[maxtrixSize[currentFrame-1]];
    for (int i=0; i<maxtrixSize[currentFrame-1]; i++) {
      matrixIndex[i] = dmFile[currentFrame-1].value[0][i];
    }
    for (int i=0; i<maxtrixSize[currentFrame-1]; i++) {
      for (int j=0; j<maxtrixSize[currentFrame-1]; j++) {
        if (matrixIndex[j] == dmFile[currentFrame-1].value[0][j]) {
          distMat[matrixIndex[i]][matrixIndex[j]] = dmFile[currentFrame-1].value[i+2][j];
        }
      }
    }
    
    if (currentFrame>1) {
      matrixIndex_prev = new int[maxtrixSize[currentFrame-2]];
      for (int i=0; i<maxtrixSize[currentFrame-2]; i++) {
        matrixIndex_prev[i] = dmFile[currentFrame-2].value[0][i];
      }
    
      for (int i=0; i<maxtrixSize[currentFrame-2]; i++) {
        for (int j=0; j<maxtrixSize[currentFrame-2]; j++) {
          if (matrixIndex_prev[j] == dmFile[currentFrame-2].value[0][j]) {
            distMat_prev[matrixIndex_prev[i]][matrixIndex_prev[j]] = dmFile[currentFrame-2].value[i+2][j];
          }
        }
      }
    }
    //
  } // end (key == CODED)
}
*/
