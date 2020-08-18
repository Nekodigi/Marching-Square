// Marching Squares Metaballs Interpolation
//https://thecodingtrain.com/challenges/coding-in-the-cabana/005-marching-squares.html
float textS = 100;
float threshold = 1;//it must 1?
float bdiv = 100;//brightness division, use for instead of threshold of brightness
float[][] field;
int rez = 5;
int cols, rows;
Sentence sentence;
PImage input, img, show;//input for marching square, test image, image for showing

void setup() {
  size(500, 500);
  img = loadImage("FevCat.png");
  img.resize(width, height);
  show = img.copy();
  img.filter(INVERT);//please use invert for only you want to black as high value
  cols = 1 + width / rez;
  rows = 1 + height / rez;
  field = new float[cols][rows];
  sentence = new Sentence("Example", width/2, height/2, textS);
}

void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

void draw() {
  background(255); 
  stroke(0);
  strokeWeight(2);
  input = img.copy();
  input.filter(BLUR, map(mouseX, 0, width, 0, 20));
  bdiv = map(mouseY, 0, height, 0, 255);
  tint(255, 100);
  image(show, 0, 0, width, height);
  
  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x = i * rez;
      float y = j * rez;
      int xi = i * rez;
      int yj = j * rez;
      
      // interpolation
      int c1 = brightAt(input, xi, yj)  < threshold ? 0 : 1;
      int c2 = brightAt(input, xi+rez, yj)  < threshold ? 0 : 1;
      int c3 = brightAt(input, xi+rez, yj+rez)  < threshold ? 0 : 1;
      int c4 = brightAt(input, xi, yj+rez)  < threshold ? 0 : 1;
      int state = getState(c1, c2, c3, c4);
      
      float a_val = brightAt(input, xi, yj);
      float b_val = brightAt(input, xi+rez, yj);
      float c_val = brightAt(input, xi+rez, yj+rez);
      float d_val = brightAt(input, xi, yj+rez);      
      //if(a_val == b_val)continue;
      //if(a_val == c_val)continue;
      //if(a_val == d_val)continue;
      //if(b_val == c_val)continue;
      //if(b_val == d_val)continue;
      //if(c_val == d_val)continue;
      PVector a = new PVector();
      float amt = (1 - a_val) / (b_val - a_val);
      a.x = lerp(x, x + rez, amt);
      a.y = y;

      PVector b = new PVector();
      amt = (1 - b_val) / (c_val - b_val);
      b.x = x + rez;
      b.y = lerp(y, y + rez, amt);

      PVector c = new PVector();
      amt = (1 - d_val) / (c_val - d_val);
      c.x = lerp(x, x + rez, amt);
      c.y = y + rez;


      PVector d = new PVector();
      amt = (1 - a_val) / (d_val - a_val);
      d.x = x;
      d.y = lerp(y, y + rez, amt);

      switch (state) {
      case 1:  
        line(c, d);
        break;
      case 2:  
        line(b, c);
        break;
      case 3:  
        line(b, d);
        break;
      case 4:  
        line(a, b);
        break;
      case 5:  
        line(a, d);
        line(b, c);
        break;
      case 6:  
        line(a, c);
        break;
      case 7:  
        line(a, d);
        break;
      case 8:  
        line(a, d);
        break;
      case 9:  
        line(a, c);
        break;
      case 10: 
        line(a, b);
        line(c, d);
        break;
      case 11: 
        line(a, b);
        break;
      case 12: 
        line(b, d);
        break;
      case 13: 
        line(b, c);
        break;
      case 14: 
        line(c, d);
        break;
      }
    }
   }
  
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}
