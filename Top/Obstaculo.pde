class Obstaculo{
  float radio;
  Vector2D pos;
  
  Obstaculo(float r, float posX, float posY){
    radio = r;
    pos = new Vector2D(posX, posY);
  }
  
  void draw(){
      fill(255,0,0);
      ellipse(pos.x, pos.y, radio, radio);
  }
  
  void setRadio(float r){
    radio = r;
  }
}
