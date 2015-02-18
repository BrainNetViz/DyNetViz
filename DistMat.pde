// public variables

/* @pjs preload="help.jpg"; */
PImage img;

public int minX = 51;
public int maxX = 637;
public int minY = 99;
public int maxY = 415;

public float matSize;
public float cellSize;
public float matTop;
public float matLeft;
public float wNL;  // 3+7
public float hNL;  // rotate 90 degree 
  
public int node_num;
public int group_num;
public int time_step = 41;
public int longestPath = 5;
public int currentFrame = 11;

ReadFile XYpos;
ReadFile colorFile;
ReadFile[] dmFile;
public int[] maxtrixSize;
public int[] matrixIndex;
public int[] matrixIndex_prev;
public int[][] distMat;
public int[][] distMat_prev;

MatButton[] matrixButtonNode;
MatButton[] matrixButtonEdge;

NodeButton[] nlButton;

TimeSlider timeSlider;

public int[] nodeDegree;
public int[] orderIndex;

LineGraph Graph_Edge_Num;  // default
LineGraph Graph_Neighbor_Num;  // seletedNode
LineGraph Graph_Distance;  // selectedEdge
public int[] graph_Edge_Num;
public int[][] graph_Neighbor_Num;
public int[][] graph_Distance;
public int graph_Edge_Num_Max;
public int graph_Neighbor_Num_Max;
public int graph_Distance_Max;

public boolean transitionMode = false;

MenuButton Help;
MenuButton Reset;
MenuButton Transit;
MenuButton Play;
MenuButton Pause;
MenuButton Stop;

public float play_delta = 0;

/********************************************/


void setup() {
  size(1550, 1080);  
  frameRate(30);
  
  img = loadImage("help.jpg");
  
  // x-y coordinates of nodes
  XYpos = new ReadFile("XYcoordinates.txt", 2);  
  XYpos.load();
  node_num = XYpos.rows;
   
  // icolor & gcolor of active nodes
  colorFile = new ReadFile("Communities_Top20_i-gColor-c111.txt", 4);
  colorFile.load();
  
  int[] group_color = new int[colorFile.rows];
  for (int i=0; i<colorFile.rows; i++) {
    group_color[i] = colorFile.value[i][3];
  }
  group_num = getMax(group_color, colorFile.rows);
  //println("group_num: " + group_num);
  
  // distance matrices of entire time steps
  dmFile = new ReadFile[time_step];
  maxtrixSize = new int[time_step];
  for (int i=0; i<time_step; i++) {
    dmFile[i] = new ReadFile("DM-t" + (i+1) + ".txt", 1);  
    dmFile[i].setCols();
    dmFile[i].load();
    maxtrixSize[i] = dmFile[i].cols;
  }
  
  /***********************************************************************/
  
  matSize = 700;
  cellSize = matSize/node_num;
  matTop = cellSize*3;
  matLeft = width - matSize - cellSize*9;  // 1+8
  wNL = matLeft - cellSize*10;  // 3+7
  hNL = (maxX - minX)*wNL/float(maxY - minY);  // rotate 90 degree 
  
  InitColor();
  
  // initialize the distance matrix
  distMat = new int[node_num][node_num];
  distMat_prev = new int[node_num][node_num];
  
  // initialize the matrix buttons
  matrixButtonNode = new MatButton[node_num*3];
  for (int i=0; i<node_num*3; i++) {
    matrixButtonNode[i] = new MatButton("node");
  } 
  
  matrixButtonEdge = new MatButton[node_num*node_num];
  for (int i=0; i<node_num*node_num; i++) {
    matrixButtonEdge[i] = new MatButton("edge");
  }
  
  // initialize the node buttons in the node-link
  nlButton =new NodeButton[node_num];
  for (int i=0; i<node_num; i++) {
    nlButton[i] = new NodeButton(i, matTop, wNL, hNL, cellSize);
  }
  
  // initialize menu buttons
  Help = new MenuButton("HELP");
  Reset = new MenuButton("RESET");
  Transit = new MenuButton("TRANSIT");
  Play = new MenuButton("PLAY");
  Pause = new MenuButton("PAUSE");
  Stop = new MenuButton("STOP");
    
  // initialize time slider
  timeSlider = new TimeSlider(matLeft-cellSize, width-cellSize*9, matTop*2+matSize, cellSize/2);
    
  /***********************************************************************/
  
  // initialize the order according to node id
  orderIndex = new int[node_num];
  for (int i=0; i<node_num; i++) {
    orderIndex[i] = i;
  }
  
  // initialize node degrees
  /*nodeDegree = new int[node_num];
  for (int i=0; i<node_num; i++) {
    nodeDegree[i] = 0; 
  }
  // accumulated node-degree
  for (int i=0; i<time_step; i++) {
    for (int j=0; j<maxtrixSize[i]; j++) {
      nodeDegree[matrixIndex[j]] += dmFile[i].value[1][j];  // a bug ...
    }
  }
  
  // order according to the accumulated node-degree
  for (int i=0; i<node_num; i++) {
    getMax(nodeDegree, node_num);
    orderIndex[i] = indexMax;
    nodeDegree[indexMax] = 0;
  }*/
  
  /***********************************************************************/
  
  // timeline graphs
  graph_Edge_Num = new int[time_step]; 
  graph_Neighbor_Num = new int[node_num][time_step]; 
  graph_Distance = new int[node_num*node_num][time_step];   
  for (int i=0; i<time_step; i++) {
    graph_Edge_Num[i] = 0;
    for (int j=0; j<node_num; j++) {
      graph_Neighbor_Num[j][i] = 0;
    }
    for (int k=0; k<node_num*node_num; k++) {
      graph_Distance[k][i] = 0;
    }    
  }
  
  for (int i=0; i<time_step; i++) {
    // graph 1
    for (int j=0; j<maxtrixSize[i]; j++) {      
      for (int k=j+1; k<maxtrixSize[i]; k++) {
        if (dmFile[i].value[j+2][k] == 1) {
          graph_Edge_Num[i] += 1;
        }
      }    
    }
    // graph 2
    for (int l=0; l<node_num; l++) {
      for (int m=0; m<maxtrixSize[i]; m++) { 
        if (dmFile[i].value[0][m] == l) {
          graph_Neighbor_Num[l][i] = dmFile[i].value[1][m];
        }
      }
    }  
    // graph 3
    for (int r=0; r<node_num; r++) { 
      for (int s=0; s<maxtrixSize[i]; s++) {
        if (dmFile[i].value[0][s] == r) {
          for (int t=0; t<node_num; t++) {
            for (int n=0; n<maxtrixSize[i]; n++) {
              if (dmFile[i].value[0][n] == t) {
                if (dmFile[i].value[s+2][n] > 0) {
                  graph_Distance[r*node_num+t][i] = dmFile[i].value[s+2][n];
                }
              }
            }
          }
        }
      }
    }
  } // end - for
  graph_Edge_Num_Max = getMax(graph_Edge_Num, time_step);
  graph_Neighbor_Num_Max = node_num-1;
  graph_Distance_Max = longestPath;
  
  /***********************************************************************/
}


void draw() {
  background(255);
  smooth();
  /*
  float matSize = 700;
  float cellSize = matSize/node_num;
  float matTop = cellSize*3;
  float matLeft = width - matSize - cellSize*9;  // 1+8
  */      
  /****************************** assign value to distMatrix (current & previous) ******************************/
  
  // initialize the distance matrix
    for (int i=0; i<node_num; i++) {
      for (int j=0; j<node_num; j++) {
        distMat[i][j] = -2;
        distMat_prev[i][j] = -2;
      }
    }
  // mapping the index of cols in the matrix to the real node id
    matrixIndex = new int[maxtrixSize[currentFrame-1]];
    for (int i=0; i<maxtrixSize[currentFrame-1]; i++) {
      matrixIndex[i] = dmFile[currentFrame-1].value[0][i];
    }
  // assign the distances to disMat[][]
    for (int i=0; i<maxtrixSize[currentFrame-1]; i++) {
      for (int j=0; j<maxtrixSize[currentFrame-1]; j++) {
        if (matrixIndex[j] == dmFile[currentFrame-1].value[0][j]) {
          distMat[matrixIndex[i]][matrixIndex[j]] = dmFile[currentFrame-1].value[i+2][j];
        }
      }
    }
  // previous time step
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
  /**************************************** draw the time slider ****************************************/
  
  // time slider
  fill(20);
  textSize(14);
  textAlign(LEFT, BOTTOM);
  text("Time Step: " + currentFrame, matLeft-cellSize, matTop*2+matSize-cellSize/2);
  textSize(12);
  textAlign(CENTER, TOP);
  text("1", matLeft-cellSize, matTop*2+matSize+cellSize);
  text("41", width-cellSize*9, matTop*2+matSize+cellSize);
  timeSlider.draw();
  
  /**************************************** draw timeline graphs ****************************************/
  
  float tlTop = (matTop*3.5+matSize);
  
  Graph_Edge_Num = new LineGraph(matLeft-cellSize, tlTop, width-cellSize*9, height-cellSize*3, "Edges");
  Graph_Neighbor_Num = new LineGraph(matLeft-cellSize, tlTop, width-cellSize*9, height-cellSize*3, "Neighbors");
  Graph_Distance = new LineGraph(matLeft-cellSize, tlTop, width-cellSize*9, height-cellSize*3, "Distance");
  
  if (selectedMatButtonEdge == -1 && selectedMatButtonNode == -1) {
    Graph_Edge_Num.draw(graph_Edge_Num, time_step, graph_Edge_Num_Max, clusterColor[3]);
  } else if (selectedMatButtonEdge == -1 && selectedMatButtonNode != -1) {
    Graph_Neighbor_Num.draw(graph_Neighbor_Num[selectedMatButtonNode], time_step, graph_Neighbor_Num_Max, clusterColor[3]);
  } else if (selectedMatButtonEdge != -1 && selectedMatButtonNode == -1) {
    Graph_Distance.draw(graph_Distance[selectedMatButtonEdge], time_step, graph_Distance_Max, clusterColor[3]);
  }
  
  /**************************************** draw the menu buttons ****************************************/
  
  Help.draw(width-cellSize*6, matTop, cellSize*4, cellSize*2);
  Reset.draw(width-cellSize*6, matTop+cellSize*3, cellSize*4, cellSize*2);
  Transit.draw(width-cellSize*6, matTop+cellSize*6, cellSize*4, cellSize*2);
  Play.draw(width-cellSize*6, matTop+cellSize*10, cellSize*4, cellSize*2);
  Pause.draw(width-cellSize*6, matTop+cellSize*13, cellSize*4, cellSize*2);
  Stop.draw(width-cellSize*6, matTop+cellSize*16, cellSize*4, cellSize*2);
  
  // play the animation
  if (Play.bLock) {
    play_delta += 0.15;    
    if (floor(play_delta) == 1) {
      if (currentFrame < time_step) {
        currentFrame += 1;
        timeSlider.newsPos = timeSlider.xPos + (currentFrame-1)/float(time_step-1)*timeSlider.bWidth;
      } else if (currentFrame == time_step) {
        currentFrame = 1;
        timeSlider.newsPos = timeSlider.xPos;
      }     
    }   
    if (play_delta > 1) {
      play_delta = 0;
    }
  }
  
  // draw lengend
  fill(20);
  textSize(14);
  textAlign(CENTER, TOP);
  text("Distance", width-cellSize*4, matTop+cellSize*20.5);        
  for (int i=0; i<longestPath; i++) {
    noStroke();
    fill(matColor[i]);
    rect(width-cellSize*5.5, matTop+cellSize*(22+i*2), cellSize*2, cellSize*2);
      
    fill(20);
    textAlign(RIGHT, CENTER);
    text(""+(i+1), width-cellSize*2.5, matTop+cellSize*(23+i*2));
  }
  
  fill(20);
  textSize(12);
  textAlign(CENTER, BOTTOM);
  text("Community", width-cellSize*4, matTop+cellSize*35);
  for (int j=0; j<group_num; j++) {
    noStroke();
    fill(clusterColor[j]);
    ellipse(width-cellSize*4, matTop+cellSize*(36+j*1.2), cellSize, cellSize);
  }
  
  /**************************************** draw the distance matrix ****************************************/
   
  // draw distance matrix
  for (int i=0; i<node_num; i++) {
    // draw cells
    for (int j=0; j<node_num; j++) {
      if (distMat[orderIndex[i]][orderIndex[j]] <= 0) { 
        noStroke();
        fill(255);
      } else {
        stroke(120);
        strokeWeight(0.5);
        fill(matColor[distMat[orderIndex[i]][orderIndex[j]]-1]);
      }
      matrixButtonEdge[orderIndex[i]*node_num+orderIndex[j]].draw(matLeft + cellSize*i, matTop + cellSize*j, cellSize);  // assign verically
      
      // transition mode
      if (transitionMode && currentFrame>1) {
        noStroke();
        if (distMat_prev[orderIndex[i]][orderIndex[j]] <= 0) {
          fill(255);
        } else {
          fill(matColor[distMat_prev[orderIndex[i]][orderIndex[j]]-1]);
        }
        rect(matLeft + cellSize*i + cellSize/4, matTop + cellSize*j + cellSize/4, cellSize/2, cellSize/2);
      }
    }
    
    // draw nodes on the top/left
    for (int k=0; k<colorFile.rows; k++) {
      if (colorFile.value[k][0] == currentFrame && colorFile.value[k][1] == orderIndex[i]) {
        if (colorFile.value[k][2] == top) {  // unobserved - fill group color       
          stroke(clusterColor[colorFile.value[k][3]-1]);
          strokeWeight(2);
          noFill();
        } else {
          stroke(20);
          strokeWeight(1);
          fill(clusterColor[colorFile.value[k][2]-1]);
        }
        matrixButtonNode[orderIndex[i]].draw(matLeft-cellSize, matTop+cellSize/2.0 + cellSize*i, cellSize*5/6);  // left
        matrixButtonNode[orderIndex[i]+node_num].draw(matLeft+cellSize/2.0 + cellSize*i, matTop-cellSize, cellSize*5/6);  // top
        break;        
      }
    }     
  }
  // end - draw matrix
  
  // highlight the cell/node in the matrix
  for (int i=0; i<node_num; i++) {
    // highlight the cell
    for (int j=0; j<node_num; j++) {
      if (distMat[orderIndex[i]][orderIndex[j]] > 0 && (matrixButtonEdge[orderIndex[i]*node_num+orderIndex[j]].bOver || selectedMatButtonEdge == orderIndex[i]*node_num+orderIndex[j]) ) {
        stroke(20);
        strokeWeight(1.5);
        fill(matColor[distMat[orderIndex[i]][orderIndex[j]]-1], 205);
        //rect(matLeft + cellSize*i - cellSize/4, matTop + cellSize*j - cellSize/4, cellSize*3/2, cellSize*3/2);
        ellipse(matLeft + cellSize*i + cellSize/2, matTop + cellSize*j + cellSize/2, cellSize*3/2, cellSize*3/2);
        
        // transition mode
        if (transitionMode && currentFrame>1) {
          noStroke();
          if (distMat_prev[orderIndex[i]][orderIndex[j]] <= 0) {
            fill(250);
          } else {
            fill(matColor[distMat_prev[orderIndex[i]][orderIndex[j]]-1]);
          }
          ellipse(matLeft + cellSize*i + cellSize/2, matTop + cellSize*j + cellSize/2, cellSize*3/4, cellSize*3/4);
        }
      } else if (selectedMatButtonNode != -1 && selectedMatButtonNode != orderIndex[i] && selectedMatButtonNode != orderIndex[j]) {
      //|| (selectedMatButtonEdge != -1 && orderIndex[i] != selectedMatButtonEdge%node_num && orderIndex[i] != (int)(selectedMatButtonEdge/node_num)) ) {
        noStroke();
        fill(180, 180);
        rect(matLeft + cellSize*i, matTop + cellSize*j, cellSize, cellSize);
      }
    }      
    // highlight the node    
    if (matrixButtonNode[orderIndex[i]].bOver || matrixButtonNode[orderIndex[i]+node_num].bOver || matrixButtonNode[orderIndex[i]+node_num*2].bOver || selectedMatButtonNode == orderIndex[i]
    ||  (selectedMatButtonEdge != -1 && (orderIndex[i] == selectedMatButtonEdge%node_num || orderIndex[i] == (int)(selectedMatButtonEdge/node_num)) ) ) {
      for (int k=0; k<colorFile.rows; k++) {
        if (colorFile.value[k][0] == currentFrame && colorFile.value[k][1] == orderIndex[i]) {
          if (colorFile.value[k][2] == top) {  // unobserved - fill group color
            stroke(clusterColor[colorFile.value[k][3]-1]);
            strokeWeight(2);
            noFill();
          } else {
            noStroke();
            fill(clusterColor[colorFile.value[k][2]-1], 205);
          }          
          ellipse(matLeft-cellSize, matTop+cellSize/2.0 + cellSize*i, cellSize*5/4, cellSize*5/4);
          ellipse(matLeft+cellSize/2.0 + cellSize*i, matTop-cellSize, cellSize*5/4, cellSize*5/4);
          break;
        }
      }        
    } else if (selectedMatButtonNode != -1 && selectedMatButtonNode != orderIndex[i]
    || (selectedMatButtonEdge != -1 && orderIndex[i] != selectedMatButtonEdge%node_num && orderIndex[i] != (int)(selectedMatButtonEdge/node_num)) ) {      
      noStroke();
      fill(180, 125);
      ellipse(matLeft-cellSize, matTop+cellSize/2.0 + cellSize*i, cellSize*5/6, cellSize*5/6);
      ellipse(matLeft+cellSize/2.0 + cellSize*i, matTop-cellSize, cellSize*5/6, cellSize*5/6);
    }
  } 
  // end - highlighting
    
  /**************************************** draw the node-link diagram ****************************************/
  
  //float wNL = matLeft - cellSize*10;  // 3+7
  //float hNL = (maxX - minX)*wNL/float(maxY - minY);  // rotate 90 degree 
  
  // draw directed edges
  for (int i=0; i<node_num; i++) {     
    for (int j=i+1; j<node_num; j++) { 
      // rotate 90 degree
      float y0 = matTop + (XYpos.value[i][0] - minX)*hNL/float(maxX - minX);
      float x0 = matTop + (XYpos.value[i][1] - minY)*wNL/float(maxY - minY);
      float y1 = matTop + (XYpos.value[j][0] - minX)*hNL/float(maxX - minX);
      float x1 = matTop + (XYpos.value[j][1] - minY)*wNL/float(maxY - minY);
    
      stroke(55);
      strokeWeight(1.5);
      // draw all links
      if (selectedMatButtonEdge == -1 && selectedMatButtonNode == -1 && distMat[i][j] == 1) {
        drawEdge(i, j, matTop, wNL, hNL);
      }
      // draw direct links (edges) for the selected node 
      else if (selectedMatButtonEdge == -1 && selectedMatButtonNode != -1 && distMat[i][j] == 1
      && (selectedMatButtonNode == i || selectedMatButtonNode == j)) {
        drawEdge(i, j, matTop, wNL, hNL);
      }
      // draw shortest path for the selected matrix cell (a pair of nodes)
      // depth-first search
      else if (selectedMatButtonNode == -1 && (selectedMatButtonEdge == i*node_num+j || selectedMatButtonEdge == j*node_num+i)) {
        ShortestPath(i, j, distMat, distMat[i][j], matTop, wNL, hNL, color(55));
        // transition mode
        if (transitionMode && currentFrame>1 && distMat_prev[i][j] != distMat[i][j]) {
          ShortestPath(i, j, distMat_prev, distMat_prev[i][j], matTop, wNL, hNL, clusterColor[3]);
        }
      }
    }
  }  
  // end - draw edges
    
  // draw nodes in node-link diagrams
  for (int i=0; i<node_num; i++) {
    // buttons for moving the overlapped nodes in the node-link
    nlButton[i].draw();
    
    // rotate 90 degree
    float y = matTop + (XYpos.value[i][0] - minX)*hNL/float(maxX - minX);
    float x = matTop + (XYpos.value[i][1] - minY)*wNL/float(maxY - minY);
    
    float nodeSize = cellSize;
    
    // highlights the selected node
    if (matrixButtonNode[i].bOver || matrixButtonNode[i+node_num].bOver || matrixButtonNode[i+node_num*2].bOver || selectedMatButtonNode == i
    || (selectedMatButtonEdge != -1 && (i == selectedMatButtonEdge%node_num || i == (int)(selectedMatButtonEdge/node_num))) ) {
      nodeSize = cellSize*4/3;
    } 
    
    // prepare for transition
    int icolor_prev = 0;
    int icolor_curr = 0;
    int gcolor_prev = 0;
    int gcolor_curr = 0;
        
    // draw active nodes 
    stroke(20);
    strokeWeight(0.5); 
    for (int k=0; k<colorFile.rows; k++) {      
      if (colorFile.value[k][0] == currentFrame && colorFile.value[k][1] == i) {
        gcolor_curr = colorFile.value[k][3]; 
        icolor_curr = colorFile.value[k][2];
        if (colorFile.value[k][2] == top) {  // unobserved nodes  
          fill(clusterColor[colorFile.value[k][3]-1]);
          rect(x-nodeSize*3/4, y-nodeSize*3/4, nodeSize*3/2, nodeSize*3/2);
          fill(255);
          matrixButtonNode[node_num*2+i].draw(x, y, nodeSize);
        } else {
          fill(clusterColor[colorFile.value[k][3]-1]);
          rect(x-nodeSize*3/4, y-nodeSize*3/4, nodeSize*3/2, nodeSize*3/2);
          fill(clusterColor[colorFile.value[k][2]-1]);  // individual color for circle
          matrixButtonNode[node_num*2+i].draw(x, y, nodeSize);
        }            
        break;
      } // end - if
    }
    
    // draw non-active nodes    
    if (distMat[i][i] == -2) {
      noStroke();
      fill(165, 220);
      ellipse(x, y,  nodeSize,  nodeSize);
    }
    
    // transition mode - previous      
    if (transitionMode && currentFrame>1) { 
      // draw non-active nodes in previous  
      if (distMat_prev[i][i] == -2 && distMat[i][i] != -2) {
        noStroke();
        fill(255);
        rect(x-nodeSize*3/4, y-nodeSize*3/4, nodeSize*3/2, nodeSize*3/4);
        fill(165, 220);
        arc(x, y, nodeSize, nodeSize, PI, TWO_PI);
      }
      for (int l=0; l<colorFile.rows; l++) {        
        if (colorFile.value[l][0] == currentFrame-1 && colorFile.value[l][1] == i) {  
          gcolor_prev = colorFile.value[l][3]; 
          icolor_prev = colorFile.value[l][2];          
          if (icolor_prev == top) {  // unobserved nodes  
            if (icolor_prev != icolor_curr) {
              stroke(20);
              strokeWeight(0.5);
              fill(clusterColor[gcolor_prev-1]);
              rect(x-nodeSize*3/4, y-nodeSize*3/4, nodeSize*3/2, nodeSize*3/4);
            }
            stroke(20);
            strokeWeight(0.1);
            fill(255);
            arc(x, y, nodeSize, nodeSize, PI, TWO_PI);
          } else {
            if (gcolor_prev != gcolor_curr) {
              stroke(20);
              strokeWeight(0.5);
              fill(clusterColor[gcolor_prev-1]);
              rect(x-nodeSize*3/4, y-nodeSize*3/4, nodeSize*3/2, nodeSize*3/4);
            }
            stroke(20);
            strokeWeight(0.1);
            fill(clusterColor[icolor_prev-1]);
            arc(x, y, nodeSize, nodeSize, PI, TWO_PI);
          }
          break;
        }                
      }
    }
    // unhighlight
    if ((selectedMatButtonNode != -1 && selectedMatButtonNode != i)
    || (selectedMatButtonEdge != -1 && i != selectedMatButtonEdge%node_num && i != (int)(selectedMatButtonEdge/node_num)) ) {
      noStroke();
      fill(180, 180);
      rect(x-nodeSize*3/4, y-nodeSize*3/4, nodeSize*3/2, nodeSize*3/2);
    }    
  }
  // end - draw nodes
  
  if (Help.bLock) {
    // 1006*590
    image(img, width/2-503, matTop*2); 
    stroke(20);
    strokeWeight(2);
    fill(80, 45);
    rect(width/2-503, matTop*2, 1006, 590);
  }
 /********************************************************************************/
} 
// end - draw()



