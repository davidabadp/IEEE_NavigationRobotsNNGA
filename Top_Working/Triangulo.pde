class Triangulo{
  float radio;
  ArrayList <Obstaculo> obstacles;
  Vector2D pos1,pos2,pos3;
  
  Triangulo(float x1i,float y1i, float x2i, float y2i,float x3i, float y3i){
    obstacles = new ArrayList <Obstaculo>();
    pos1 = new Vector2D(x1i, y1i);
    pos2 = new Vector2D(x2i, y2i);
    pos3 = new Vector2D(x3i, y3i);
    radio=4.0;
    create();
  }
  
  void draw(){
      fill(0,0,255);
      triangle(pos1.x,pos1.y,pos2.x,pos2.y,pos3.x,pos3.y);
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
    Vector2D ladoizq= new Vector2D(pos2.x-pos1.x, pos2.y-pos1.y);
    Vector2D ladoaba= new Vector2D(pos3.x-pos2.x, pos3.y-pos2.y);
    Vector2D ladoder= new Vector2D(pos1.x-pos3.x, pos1.y-pos3.y);
    Vector2D inicioup= new Vector2D(pos1.x, pos1.y);
    Vector2D inicioizq= new Vector2D(pos2.x, pos2.y);
    Vector2D inicioder= new Vector2D(pos3.x, pos3.y);
    float distizq = ladoizq.getModule();
    float distder = ladoder.getModule();
    float distaba = ladoaba.getModule();
    float dist_mov = 0;
    int i=1;
    int flag = 0;
      while(flag!=3){  
        if (flag ==0)
        {
           ladoder.setMagnitude(i);
           posCir.x= pos1.x - radio*ladoder.x;
           posCir.y= pos1.y - radio*ladoder.y;
           i=i+1;
           dist_mov = distancia(posCir,inicioup);
        }
        else if(flag==1)
        {
           ladoaba.setMagnitude(i);
           posCir.x= pos3.x - radio*ladoaba.x;
           posCir.y= pos3.y - radio*ladoaba.y;
           i=i+1;
           dist_mov = distancia(posCir,inicioder);
        }
        else if(flag==2)
        {
           ladoizq.setMagnitude(i);
           posCir.x= pos2.x - radio*ladoizq.x;
           posCir.y= pos2.y - radio*ladoizq.y;
           i=i+1;
           dist_mov = distancia(posCir,inicioizq);
        }
        
         Obstaculo obs = new Obstaculo (radio, posCir.x,posCir.y);
         obstacles.add(obs);

        if( (flag == 0 && dist_mov >= distder) || (flag == 1 && dist_mov >= distaba) || (flag == 2 && dist_mov >= distizq))
        {
          i=1;
          dist_mov=0.0;
          flag++;
        }
      }
  }
  
  void move(){
    Vector2D posCir= new Vector2D();
    Vector2D ladoizq= new Vector2D(pos2.x-pos1.x, pos2.y-pos1.y);
    Vector2D ladoaba= new Vector2D(pos3.x-pos2.x, pos3.y-pos2.y);
    Vector2D ladoder= new Vector2D(pos1.x-pos3.x, pos1.y-pos3.y);
    Vector2D inicioup= new Vector2D(pos1.x, pos1.y);
    Vector2D inicioizq= new Vector2D(pos2.x, pos2.y);
    Vector2D inicioder= new Vector2D(pos3.x, pos3.y);
    float distizq = ladoizq.getModule();
    float distder = ladoder.getModule();
    float distaba = ladoaba.getModule();
    float dist_mov = 0;
    int i=1,j=obstacles.size();
    int flag = 0;
      while(flag!=3){  
        if (flag ==0)
        {
           ladoder.setMagnitude(i);
           posCir.x= pos1.x - radio*ladoder.x;
           posCir.y= pos1.y - radio*ladoder.y;
           i=i+1;
           dist_mov = distancia(posCir,inicioup);
           j--;
        }
        else if(flag==1)
        {
           ladoaba.setMagnitude(i);
           posCir.x= pos3.x - radio*ladoaba.x;
           posCir.y= pos3.y - radio*ladoaba.y;
           i=i+1;
           dist_mov = distancia(posCir,inicioder);
           j--;
        }
        else if(flag==2)
        {
           ladoizq.setMagnitude(i);
           posCir.x= pos2.x - radio*ladoizq.x;
           posCir.y= pos2.y - radio*ladoizq.y;
           i=i+1;
           dist_mov = distancia(posCir,inicioizq);
           j--;
        }
        
        if(j >= 0){
          Obstaculo obs = obstacles.get(j);
          obs.pos.set(posCir.x,posCir.y);
        }

        if( (flag == 0 && dist_mov >= distder) || (flag == 1 && dist_mov >= distaba) || (flag == 2 && dist_mov >= distizq))
        {
          i=1;
          dist_mov=0.0;
          flag++;
        }
      }
  }
}
