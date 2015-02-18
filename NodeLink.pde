
// draw direct links
void drawEdge(int i, int j, float margin, float w, float h) {
    // rotate 90 degree
    float y0 = margin + (XYpos.value[i][0] - minX)*h/float(maxX - minX);
    float x0 = margin + (XYpos.value[i][1] - minY)*w/float(maxY - minY);
    float y1 = margin + (XYpos.value[j][0] - minX)*h/float(maxX - minX);
    float x1 = margin + (XYpos.value[j][1] - minY)*w/float(maxY - minY);
      
    float a = 100;
    float x0_b, y0_b, x1_e, y1_e;          
    if (x0 < x1) { 
      x0_b = x0 - a;
      y0_b = y0 + a;
      x1_e = x1 + a;
      y1_e = y1 + a;
    } else if (x0 == x1) {
      x0_b = x0 - a;
      y0_b = y0 - a;
      x1_e = x1 - a;
      y1_e = y1 + a;
    } else {
      x0_b = x0 + a;
      y0_b = y0 - a;
      x1_e = x1 - a;
      y1_e = y1 + a;
    }
    
    noFill();
    curve(x0_b, y0_b, x0, y0, x1, y1, x1_e, y1_e);
}


// draw shortest path between two nodes
void ShortestPath(int i, int j, int[][] dist, int d, float margin, float w, float h, color c) {
  stroke(c);
  switch(d) {
   case 1:
       drawEdge(i, j, margin, w, h);
       break;
   case 2:
       for (int k=0; k<node_num; k++) {
         if (dist[i][k] == 1 && dist[k][j] == 1) {
           drawEdge(i, k, margin, w, h);
           drawEdge(k, j, margin, w, h);
         }       
       }
       break;
   case 3:
       for (int k=0; k<node_num; k++) {
         for (int l=0; l<node_num; l++) {
           if (dist[i][k] == 1 && dist[k][l] == 1 && dist[l][j] == 1) {
             drawEdge(i, k, margin, w, h);
             drawEdge(k, l, margin, w, h);
             drawEdge(l, j, margin, w, h);
           }
         }
       }
       break;
   case 4:
       for (int k=0; k<node_num; k++) {
         for (int l=0; l<node_num; l++) {
           for (int m=0; m<node_num; m++) {
             if (dist[i][k] == 1 && dist[k][l] == 1 && dist[l][m] == 1 && dist[m][j] == 1) {
               drawEdge(i, k, margin, w, h);
               drawEdge(k, l, margin, w, h);
               drawEdge(l, m, margin, w, h);
               drawEdge(m, j, margin, w, h);
             }
           }
         }
       }
       break;
   case 5:
       for (int k=0; k<node_num; k++) {
         for (int l=0; l<node_num; l++) {
           for (int m=0; m<node_num; m++) {
             for (int n=0; n<node_num; n++) {
               if (dist[i][k] == 1 && dist[k][l] == 1 && dist[l][m] == 1 && dist[m][n] == 1 && dist[n][j] == 1) {
                 drawEdge(i, k, margin, w, h);
                 drawEdge(k, l, margin, w, h);
                 drawEdge(l, m, margin, w, h);
                 drawEdge(m, n, margin, w, h);
                 drawEdge(n, j, margin, w, h);
               }
             }
           }
         }
       }
       break;
  }  
}
