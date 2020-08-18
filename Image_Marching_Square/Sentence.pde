class Sentence{
  PVector pos;
  float textS;
  String text;
  ArrayList<CharObj> chars = new ArrayList<CharObj>();
  int charIX = 0;//typing char index
  
  Sentence(String text, float x, float y, float textS){//origin center, center by myself to make thing easier
    this.text = text;
    this.textS = textS;
    textSize(textS);
    pos = new PVector(x-textWidth(text)/2, y+textS/2);
    splitText();
  }
  
  void splitText(){
    chars = new ArrayList<CharObj>();
    float xoff = 0;
    textSize(textS);
    for(int i=0; i<text.length(); i++){
      char c = text.charAt(i);
      chars.add(new CharObj(pos.x + xoff, pos.y, c));
      xoff += textWidth(c);
    }
  }
  
  void update(){
    
  }
  
  void show(PGraphics pg){
    //textSize(textS);
    //text(text, pos.x, pos.y);
    for(CharObj cha : chars){
      cha.show(pg);
    }
  }
}
