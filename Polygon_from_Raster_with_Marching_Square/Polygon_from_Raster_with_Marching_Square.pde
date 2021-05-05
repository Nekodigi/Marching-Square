//based on this code 
// https://thecodingtrain.com/challenges/coding-in-the-cabana/005-marching-squares.html
PImage img;
PGraphics canvas;
boolean[][] checkout;
int scaling = 1;
color white;
color black;
ArrayList<PVector> points = new ArrayList<PVector>();
int marchdir = 0;//0= ^up 1= >right 2= \/down 3= <left 
int ix, iy;
float threshold = 1;
PVector a, b, c, d;

void setup() {
  size(800, 800);
  canvas = createGraphics(width/scaling, height/scaling);
  checkout = new boolean[canvas.width][canvas.height];
  colorMode(RGB, 255, 255, 255, 1);
  //image(img, 0, 0, width, height);

  white = color(255);
  black = color(0);
  //noSmooth();

  background(255);
  canvas.beginDraw();
  //canvas.noSmooth();
  //canvas.noStroke();
  canvas.fill(0);
  canvas.background(black);
  canvas.strokeWeight(20);
  canvas.stroke(white);
  //canvas.stroke(0);//set brush color
  canvas.endDraw();
}

void draw() {
  background(black);
  //image(canvas, 0, 0);
  canvas.beginDraw();
  canvas.noSmooth();
  //noSmooth();


  if (mousePressed) {
    canvas.line(pmouseX/scaling, pmouseY/scaling, mouseX/scaling, mouseY/scaling);
  }
  canvas.endDraw();
  tint(255, 0.5);
  image(canvas, 0, 0, width, height);
  stroke(255);
  marchingSquare();

}

void marchingSquare() {
  fillEdge();
  checkout = new boolean[canvas.width][canvas.height];
  for (int i=0; i<canvas.pixels.length; i++) {
    ix = i%canvas.width;
    iy = i/canvas.width;


    if (ix==canvas.width-1 || iy==canvas.height-1)continue;
    int c00 = brightness(canvas.pixels[iy*canvas.width+ix]) < threshold ? 0 : 1;//00, 10
    int c10 = brightness(canvas.pixels[iy*canvas.width+ix+1]) < threshold ? 0 : 1;//01, 11
    int c11 = brightness(canvas.pixels[(iy+1)*canvas.width+ix+1]) < threshold ? 0 : 1;
    int c01 = brightness(canvas.pixels[(iy+1)*canvas.width+ix]) < threshold ? 0 : 1;

    if (checkout[ix][iy] == false && c00 == 0 && c10 == 0 && c01 == 0 && c11 == 1) {
      //scanLoop
      stroke(255);
      strokeWeight(2);

      marchdir = 0;
      ArrayList<PVector> points = scanLoop();
      beginShape();noFill();//stroke();
      for(PVector point : points){
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    } else if (checkout[ix][iy] == false && c00 == 1 && c10 == 1 && c01 == 1 && c11 == 0) {
      //scanLoop
      stroke(255, 0, 0);
      strokeWeight(2);

      marchdir = 3;
      ArrayList<PVector> points = scanLoop();
      beginShape();noFill();//stroke();
      for(PVector point : points){
        vertex(point.x, point.y);
      }
      endShape(CLOSE);
    }
  }
}

ArrayList<PVector> scanLoop() {
  int six = ix;
  int siy = iy;
  int safety = 0;
  points = new ArrayList<PVector>();
  while (true) {
    float x = ix+0.5;
  float y= iy+0.5;
    int c00 = brightness(canvas.pixels[iy*canvas.width+ix]) < threshold ? 0 : 1;//00, 10
    int c10 = brightness(canvas.pixels[iy*canvas.width+ix+1]) < threshold ? 0 : 1;//01, 11
    int c11 = brightness(canvas.pixels[(iy+1)*canvas.width+ix+1]) < threshold ? 0 : 1;
    int c01 = brightness(canvas.pixels[(iy+1)*canvas.width+ix]) < threshold ? 0 : 1;
    float a_val = brightness(canvas.pixels[iy*canvas.width+ix]);
    float b_val = brightness(canvas.pixels[iy*canvas.width+ix+1]);
    float c_val = brightness(canvas.pixels[(iy+1)*canvas.width+ix+1]);
    float d_val = brightness(canvas.pixels[(iy+1)*canvas.width+ix]);
    int state = getState(c00, c10, c11, c01);
    a = new PVector();
      float amt = (threshold - a_val) / (b_val - a_val);
      a.x = lerp(x, x + 1, amt)*scaling;
      a.y = y*scaling;

      b = new PVector();
      amt = (threshold - b_val) / (c_val - b_val);
      b.x = (x + 1)*scaling;
      b.y = lerp(y, y + 1, amt)*scaling;

      c = new PVector();
      amt = (threshold - d_val) / (c_val - d_val);
      c.x = lerp(x, x + 1, amt)*scaling;
      c.y = (y + 1)*scaling;


      d = new PVector();
      amt = (threshold - a_val) / (d_val - a_val);
      d.x = x*scaling;
      d.y = lerp(y, y + 1, amt)*scaling;
    switch (state) {
    case 1:  
      //line(c, d);
      if (marchdir == 1) marchDir(2);
      else if (marchdir == 0) marchDir(3);
      break;
    case 2:  
      //line(b, c);
      checkout[ix][iy] = true;
      if (marchdir == 0) marchDir(1);
      else if (marchdir == 3) marchDir(2);
      break;
    case 3:  
      //line(b, d);
      if (marchdir == 1) marchDir(1);
      else if (marchdir == 3) marchDir(3);
      break;
    case 4:  
      //line(a, b);
      if (marchdir == 2) marchDir(1);
      else if (marchdir == 3) marchDir(0);
      break;
    case 5:  //render both but use only one at once
      //line(a, d);
      //line(b, c);
      checkout[ix][iy] = true;
      if (marchdir == 2) marchDir(3);
      else if (marchdir == 1) marchDir(0);
      else if (marchdir == 0) marchDir(1);
      else if (marchdir == 3) marchDir(2);
      break;
    case 6:  
      //line(a, c);
      if (marchdir == 0) marchDir(0);
      else if (marchdir == 2) marchDir(2);
      break;
    case 7:  
      //line(a, d);
      checkout[ix][iy] = true;
      if (marchdir == 2) marchDir(3);
      else if (marchdir == 1) marchDir(0);
      break;
    case 8:  
      //line(a, d);
      checkout[ix][iy] = true;
      if (marchdir == 2) marchDir(3);
      else if (marchdir == 1) marchDir(0);
      break;
    case 9:  
      //line(a, c);
      if (marchdir == 0) marchDir(0);
      else if (marchdir == 2) marchDir(2);
      break;
    case 10: 
//line(a, b);
      //line(c, d);
      if (marchdir == 2) marchDir(1);
      else if (marchdir == 3) marchDir(0);
      else if (marchdir == 1) marchDir(2);
      else if (marchdir == 0) marchDir(3);
      break;
    case 11: 
      //line(a, b);
      if (marchdir == 2) marchDir(1);
      else if (marchdir == 3) marchDir(0);
      break;
    case 12: 
      //line(b, d);
      if (marchdir == 1) marchDir(1);
      else if (marchdir == 3) marchDir(3);
      break;
    case 13: 
      //line(b, c);
      checkout[ix][iy] = true;
      if (marchdir == 0) marchDir(1);
      else if (marchdir == 3) marchDir(2);
      break;
    case 14: 
      //line(c, d);
      if (marchdir == 1) marchDir(2);
      else if (marchdir == 0) marchDir(3);
      break;
    }
    if (ix==six && iy==siy)break;
    if (safety++>=10000) {
      println("not safety", ix, iy);
      return null;
    }
  }
  return points;
}

void marchDir(int val) {
  marchdir = val;
  switch(val) {
  case 0:
    iy -= 1;
    points.add(a);
    break;
  case 1:
    ix += 1;
    points.add(b);
    break;
  case 2:
    iy += 1;
    points.add(c);
    break;
  case 3:
    ix -= 1;
    points.add(d);
    break;
  }
}

void fillEdge() {//fill edge with black to make calculation simple
  for (int i=0; i<canvas.width; i++) {
    canvas.pixels[i] = color(0);
    canvas.pixels[(canvas.height-1)*canvas.width+i] = color(0);
  }
  for (int i=0; i<canvas.height; i++) {
    canvas.pixels[i*canvas.width] = color(0);
    canvas.pixels[i*canvas.width+canvas.width-1] = color(0);
  }
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}

void line(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}
