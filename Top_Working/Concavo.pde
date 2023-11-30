class Concavo{
  float altura;
  float base;
  float radio_base;
  float radio_alt;
  ArrayList <Obstaculo> obstacles;
  Vector2D pos;
  
  Concavo(float b,float h, float posX, float posY){
    obstacles = new ArrayList <Obstaculo>();
    base=b;
    altura=h;
    radio_base=10.0;
    radio_alt=10.0;
    pos = new Vector2D(posX, posY);
    create();
  }
  
  void draw(){
    fill(0,0,255);
    rect(pos.x, pos.y, base, altura);
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
    Vector2D posCir= new Vector2D(pos.x, pos.y);
    int i=0,k1=15,k2=15;
    int flag = 0;
    //int option = (int)random(0,4);
    float resto1=1.0,resto2=1.0;
      while(resto1!=0)
        {
          radio_base=base/k1;
          resto1=base%k1;
          k1=k1+1;
        }
      while(resto2!=0)
        {
          radio_alt=altura/k2;
          resto2=altura%k2;
          k2=k2+1;
        }
        radio_base = radio_base/2;
        radio_alt = radio_alt/2;
      while(flag!=4)
      {  
        if (flag ==0)
        {
           posCir.x= pos.x + radio_base*i;
           posCir.y= pos.y;
           i=i+1;
        }
        else if(flag==1)
        {
           posCir.x= pos.x + base;
           posCir.y= pos.y + radio_alt*i;
           i=i+1;
        }
        else if(flag==2)
        {
           posCir.x= pos.x + base - radio_base*i;
           posCir.y= pos.y + altura;
           i=i+1;
        }
        else if(flag==3)
        {
           posCir.x= pos.x;
           posCir.y= pos.y + altura - radio_alt*i;
           i=i+1;
        }
        
        if(flag == 0)
        {
          Obstaculo obs = new Obstaculo (radio_base, posCir.x,posCir.y);
          obstacles.add(obs);
        }
        else if(flag == 1)
        {
          Obstaculo obs = new Obstaculo (radio_alt, posCir.x,posCir.y);
          obstacles.add(obs);
        }
        else if(flag == 2)
        {
          Obstaculo obs = new Obstaculo (radio_base, posCir.x,posCir.y);
          obstacles.add(obs);
        }
        /*else if(flag == 3)
        {
          Obstaculo obs = new Obstaculo (radio_alt, posCir.x,posCir.y);
          obstacles.add(obs);
        }*/
        
        if((flag == 0 && posCir.x>=(pos.x+base)) || (flag == 1 && posCir.y>=(pos.y+altura)) || (flag == 2 && posCir.x<=(pos.x))|| (flag == 3 && posCir.y<=(pos.y)))
        {
          i=0;
          flag++;
        }
      }
  }
  
  void move(){
    Vector2D posCir= new Vector2D(pos.x, pos.y);
    int i=0,j=obstacles.size();
    int flag = 0;
      while(flag!=4)
      {  
        if (flag ==0)
        {
           posCir.x= pos.x + radio_base*i;
           posCir.y= pos.y;
           i=i+1;
           j--;
        }
        else if(flag==1)
        {
           posCir.x= pos.x + base;
           posCir.y= pos.y + radio_alt*i;
           i=i+1;
           j--;
        }
        else if(flag==2)
        {
           posCir.x= pos.x + base - radio_base*i;
           posCir.y= pos.y + altura;
           i=i+1;
           j--;
        }
        /*else if(flag==3)
        {
           posCir.x= pos.x;
           posCir.y= pos.y + altura - radio_alt*i;
           i=i+1;
           j--;
        }*/
        
        if(flag == 0)
        {
          if(j >= 0){
            Obstaculo obs = obstacles.get(j);
            obs.pos.set(posCir.x,posCir.y);
            obs.setRadio(radio_base);
          }
        }
        /*else if(flag == 1)
        {
          if(j >= 0){
            Obstaculo obs = obstacles.get(j);
            obs.pos.set(posCir.x,posCir.y);
            obs.setRadio(radio_alt);
          }
        }*/
        else if(flag == 2)
        {
          if(j >= 0){
            Obstaculo obs = obstacles.get(j);
            obs.pos.set(posCir.x,posCir.y);
            obs.setRadio(radio_base);
          }
        }
        else if(flag == 3)
        {
          if(j >= 0){
            Obstaculo obs = obstacles.get(j);
            obs.pos.set(posCir.x,posCir.y);
            obs.setRadio(radio_alt);
          }
        }
        
        if((flag == 0 && posCir.x>=(pos.x+base)) || (flag == 1 && posCir.y>=(pos.y+altura)) || (flag == 2 && posCir.x<=(pos.x))|| (flag == 3 && posCir.y<=(pos.y)))
        {
          i=0;
          flag++;
        }
      }
  }
}
