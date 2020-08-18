class CharObj{
  PVector pos;
  char cha;
  
  CharObj(float x, float y, char cha){
    this.pos = new PVector(x, y);
    this.cha = cha;
  }
  
  void show(PGraphics pg){
    pg.textSize(textS);
    pg.text(cha, pos.x, pos.y);
  }
}
