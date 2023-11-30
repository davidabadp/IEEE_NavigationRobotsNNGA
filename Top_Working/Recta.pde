class Recta{
  float radio;
  ArrayList <Obstaculo> obstacles;
  Vector2D pos1,pos2;
  
  Recta(float x1i,float y1i, float x2i,float y2i){
    obstacles = new ArrayList <Obstaculo>();
    pos1 = new Vector2D(x1i, y1i);
    pos2 = new Vector2D(x2i, y2i);
    radio=4.0;
    create();
  }
  
  void draw(){
      fill(0,0,255);
      line(pos1.x,pos1.y,pos2.x,pos2.y);
      for (Obstaculo obs : obstacles){
      obs.draw();
    }
  }
  
  ArrayList <Obstaculo> getObstacles(){
     return obstacles;
   }
   
   Obstaculo getObstacle(int i){
     return obstacles.get(i);
   }
   
   void eliminar(){
    for (int i = obstacles.size()-1; i >= 0; i--){
      obstacles.remove(i);
    }
  }
  
  void create(){
    Vector2D posCir= new Vector2D();
    Vector2D lado= new Vector2D(pos2.x-pos1.x, pos2.y-pos1.y);
    Vector2D inicio= new Vector2D(pos1.x, pos1.y);
    float dist = lado.getModule();
    float dist_mov = 0;
    int i=1;
    int flag = 0;
      while(flag!=1){  
        
         lado.setMagnitude(i);
         posCir.x= pos1.x + radio*lado.x;
         posCir.y= pos1.y + radio*lado.y;
         i=i+1;
         dist_mov = distancia(posCir,inicio);
 
         Obstaculo obs = new Obstaculo (radio, posCir.x,posCir.y);
         obstacles.add(obs);
         
        if(dist_mov >= dist)
        {
          flag++;
        }
      }
  }
  
  void move(){
    Vector2D posCir= new Vector2D();
    Vector2D lado= new Vector2D(pos2.x-pos1.x, pos2.y-pos1.y);
    Vector2D inicio= new Vector2D(pos1.x, pos1.y);
    float dist = lado.getModule();
    float dist_mov = 0;
    int i=1,j=obstacles.size();
    int flag = 0;
      while(flag!=1){  
        
         lado.setMagnitude(i);
         posCir.x= pos1.x + radio*lado.x;
         posCir.y= pos1.y + radio*lado.y;
         i=i+1;
         j--;
         dist_mov = distancia(posCir,inicio);

        if(j >= 0){
          Obstaculo obs = obstacles.get(j);
          obs.pos.set(posCir.x,posCir.y);
        }
         
        if(dist_mov >= dist)
        {
          flag++;
        }
      }
  }
}
