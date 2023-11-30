class Meta{
  int radio;
  Vector2D pos;
  
  Meta(int r, float posX, float posY){
    radio = r;
    pos = new Vector2D(posX, posY);
  }
  
  void draw(){
      fill(0,255,0);
      ellipse(pos.x, pos.y, radio, radio);
  }
}
