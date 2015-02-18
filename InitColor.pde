// initialize top 10 colors

public int top = 20;
public color[] clusterColor;
public color[] matColor;

void InitColor() {
  
  // https://github.com/mbostock/d3/wiki/Ordinal-Scales
  clusterColor = new color[top];   
  clusterColor[0] = color(31, 119, 180);
  clusterColor[1] = color(255, 127, 14);
  clusterColor[2] = color(44, 160, 44);
  clusterColor[3] = color(214, 39, 40);
  clusterColor[4] = color(148, 103, 189);
  clusterColor[5] = color(140, 86, 75);
  clusterColor[6] = color(188, 189, 34);
  clusterColor[7] = color(23, 190, 207);
  clusterColor[8] = color(227, 119, 194);
  clusterColor[9] = color(174, 199, 232);
  clusterColor[10] = color(255, 187, 120);
  clusterColor[11] = color(152, 223, 138);
  clusterColor[12] = color(255, 152, 150);
  clusterColor[13] = color(197, 176, 213);
  clusterColor[14] = color(196, 156, 148);
  clusterColor[15] = color(219, 219, 141);
  clusterColor[16] = color(158, 218, 229);
  clusterColor[17] = color(247, 182, 210);
  clusterColor[18] = color(127, 127, 127);
  clusterColor[19] = color(199, 199, 199);
  
  // http://colorbrewer2.org/
  matColor = new color[5];  
  matColor[0] = color(37,52,148);
  matColor[1] = color(44,127,184);
  matColor[2] = color(65,182,196);
  matColor[3] = color(161,218,180);
  matColor[4] = color(255,255,204);
  
}
