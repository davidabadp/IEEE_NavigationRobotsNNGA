class Mapas{
  int opcion,n,m;
  int [] seq;
  int [] upydown;
  Rectangulo rect1;
  Triangulo triang1;
  Recta line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11,line12,line13;
  Recta line0,linetrans0up,linetrans0down,linetrans1up,linetrans1down,linetrans2up,linetrans2down;
  Obstaculo Thecircle;
  ArrayList <Tunel> tuneles;
  ArrayList <Obstaculo> obs;
  int rand_x, rand_y;
  Concavo concav;
  Vector2D target_pos;
  Vector2D start_pos;
  
  Mapas(int option, int ni, int mi){
    opcion = option;
    n = ni;
    m = mi;
    obs = new ArrayList <Obstaculo>();
    target_pos = new Vector2D();
    start_pos = new Vector2D();
  }
  
  Obstaculo getObstacle(int i){
     return obs.get(i);
   }
   
  void eliminar(){
    for (int i = obstacles.size()-1; i >= 0; i--){
      obs.remove(i);
    }
  }
  
  void create(){
    if(opcion == 1){
      tuneles = new ArrayList <Tunel>();
      for(int i = 0; i < this.n; i++){
        for(int j = 0; j < this.m; j++){
          Tunel tun = new Tunel(100,100,j*100,i*100);
          for(int k = 0; k < tun.obstacles.size(); k++){
            obs.add(tun.getObstacle(k));
          }
          tuneles.add(tun);
        }
      }
    }
    
    else if(opcion == 2){
      seq = new int [3];
      upydown = new int[2];
      
      Thecircle = new Obstaculo (100,700,325);
      obs.add(Thecircle);
  
      rect1 = new Rectangulo(50,110,170,250);
      for(int i = 0; i < rect1.obstacles.size(); i++){
        obs.add(rect1.getObstacle(i));
      }
  
      triang1 = new Triangulo(450,270,350,360,550,360);
      for(int i = 0; i < triang1.obstacles.size(); i++){
        obs.add(triang1.getObstacle(i));
      }
  
      line1 = new Recta(100,290,100,190);
      for(int i = 0; i < line1.obstacles.size(); i++){
        obs.add(line1.getObstacle(i));
      }
  
      line2 = new Recta(100,190,300,190);
      for(int i = 0; i < line2.obstacles.size(); i++){
        obs.add(line2.getObstacle(i));
      }
  
      line3 = new Recta(300,190,300,290);
      for(int i = 0; i < line3.obstacles.size(); i++){
        obs.add(line3.getObstacle(i));
      }
  
      line4 = new Recta(100,360,170,360);
      for(int i = 0; i < line4.obstacles.size(); i++){
        obs.add(line4.getObstacle(i));
      }
  
      line5 = new Recta(220,360,300,360);
      for(int i = 0; i < line5.obstacles.size(); i++){
        obs.add(line5.getObstacle(i));
      }
  
      line6 = new Recta(350,290,450,190);
      for(int i = 0; i < line6.obstacles.size(); i++){
        obs.add(line6.getObstacle(i));
      }
  
      line7 = new Recta(450,190,550,290);
      for(int i = 0; i < line7.obstacles.size(); i++){
        obs.add(line7.getObstacle(i));
      }
  
      line8 = new Recta(600,290,600,200);
      for(int i = 0; i < line8.obstacles.size(); i++){
        obs.add(line8.getObstacle(i));
      }
  
      line9 = new Recta(600,200,800,200);
      for(int i = 0; i < line9.obstacles.size(); i++){
        obs.add(line9.getObstacle(i));
      }
  
      line10 = new Recta(800,200,800,290);
      for(int i = 0; i < line10.obstacles.size(); i++){
        obs.add(line10.getObstacle(i));
      }
  
      line11 = new Recta(600,360,600,450);
      for(int i = 0; i < line11.obstacles.size(); i++){
        obs.add(line11.getObstacle(i));
      }
  
      line12 = new Recta(600,450,800,450);
      for(int i = 0; i < line12.obstacles.size(); i++){
        obs.add(line12.getObstacle(i));
      }
  
      line13 = new Recta(800,450,800,360);
      for(int i = 0; i < line13.obstacles.size(); i++){
        obs.add(line13.getObstacle(i));
      }
  
      trans0();
      trans1();
      trans2();
    }
    
    else if(opcion == 3){
      rect1 = new Rectangulo(350,200,275,200);
      for(int i = 0; i < rect1.obstacles.size(); i++){
        obs.add(rect1.getObstacle(i));
      }
    }
    else if(opcion == 4){
      concav = new Concavo(200,200,350,200);
      for(int i = 0; i < concav.obstacles.size(); i++){
        obs.add(concav.getObstacle(i));
      }
    }
    else if (opcion == 5){
      //No obstacles
    }
  }
  
  Vector2D get_target_pos(){
    //Default is random
    int posX = int(random(width));
    int posY = int(random(height));
    
    //Save values for robot init
    rand_x = posX;
    rand_y = posY;
    
    Vector2D pos = new Vector2D();
    
    if (opcion == 1){
      /*int ranX1 = int(random(0,n)); //0 a 8
      int ranY1 = int(random(0,m)); //0 a 5
      posX = 50 + 100*ranX1;
      posY = 50 + 100*ranY1;
      pos.set(width - posX, height - posY);*/
      pos.set(850,550);
    }
    else if(opcion == 2){
      int posY2 = int(random(275,375));
      pos.set(850, posY2);
    }
    else if(opcion == 3){
      int ran3option = int(random(0,2)); //0 o 1
      int ran3updown = int(random(0,2)); //0 o 1
      if(ran3option == 0){
        if(ran3updown == 0){
          posX = int(random(25,225));
        }
        else{
          posX = int(random(675,875));
        }
      }
      else{
        if(ran3updown == 0){
          posY = int(random(25,150));
        }
        else{
          posY = int(random(450,575));
        }
      }
      pos.set(width - posX, height - posY);
      //pos.set(700,450);
    }
    else if(opcion == 4){
      int posY2 = int(random(100,500));
      pos.set(700, posY2);
    }
    else if(opcion == 5){
      pos.set(posX, posY);
    }
    else{
      pos.set(width - posX, height - posY);
    }
    
    target_pos = pos;
    return pos;
  }
  
  Vector2D get_start_pos(){
    if(map.opcion == 1){
      int ranX1 = int(random(0,n)); //0 a 8
      int ranY1 = int(random(0,m)); //0 a 6
      int posX = 50 + 100*ranX1;
      int posY = 50 + 100*ranY1;
      start_pos.set(posX, posY);
      //start_pos.set(50,50);
    }
    else if(map.opcion == 2){
      start_pos.set(75,325);
    }
    else if(map.opcion == 3){
      start_pos.set(width - target_pos.x, height - target_pos.y);
    }
    else if(map.opcion == 4){
      start_pos.set(450,300);
    }
    else if(map.opcion == 5){
      start_pos.set(width - target_pos.x, height - target_pos.y);
    }
    else{
      start_pos.set(rand_x, rand_y);
    }
    return start_pos;
  }
  
  void generate(){
    if(opcion == 1){
      for(int i = 0; i < tuneles.size(); i++){
        int in = (int)random(0,7);
        tuneles.get(i).move(in);
      }
    }
    
    else if(opcion == 2){
      orden_random(seq);
    
      upydown[0] = (int)random(0,2);
      upydown[1] = (int)random(0,2);

      block1(seq[0],upydown[0]);
      block2(seq[1],upydown[1]);
      block3(seq[2]);
    }
    
    else if(opcion == 3){
      //rect1.pos.set(275,200);
      //rect1.move();
    }
    else if(opcion == 4){
      //concav.pos.set(350,200);
      //concav.move();
    }
    else if(opcion == 5){
      //No obstacles
    }
  }
  
  void orden_random(int seq[]){
    boolean flag_ran = true;
    seq[0]=(int)random(1,4);
    for(int i = 1; i < 3; i++){
      while(flag_ran){
        flag_ran = false;
        seq[i] = (int)random(1,4);
        for(int j = 0; j < i; j++){
          if(seq[j] == seq[i]){
            flag_ran = true;
          }
        }
      }
      flag_ran = true;
    }
  }

  void trans0(){
    line0 = new Recta(0,290,0,360);
    for(int i = 0; i < line0.obstacles.size(); i++){
      obs.add(line0.getObstacle(i));
    }
    linetrans0up = new Recta(0,290,100,290);
    for(int i = 0; i < linetrans0up.obstacles.size(); i++){
       obs.add(linetrans0up.getObstacle(i));
    }
    linetrans0down = new Recta(0,360,100,360);
    for(int i = 0; i < linetrans0down.obstacles.size(); i++){
       obs.add(linetrans0down.getObstacle(i));
    }
  }

  void block1(int seq, int sentido){
    line1.pos1.set(100+((seq-1)*250),290+(70*sentido));
    line1.pos2.set(100+((seq-1)*250),190+(270*sentido));
    line1.move();
  
    line2.pos1.set(100+((seq-1)*250),190+(270*sentido));
    line2.pos2.set(300+((seq-1)*250),190+(270*sentido));
    line2.move();
  
    line3.pos1.set(300+((seq-1)*250),190+(270*sentido));
    line3.pos2.set(300+((seq-1)*250),290+(70*sentido));
    line3.move();
  
    line4.pos1.set(100+((seq-1)*250),360-(70*sentido));
    line4.pos2.set(170+((seq-1)*250),360-(70*sentido));
    line4.move();
  
    line5.pos1.set(220+((seq-1)*250),360-(70*sentido));
    line5.pos2.set(300+((seq-1)*250),360-(70*sentido));
    line5.move();
  
    rect1.pos.set(170+((seq-1)*250),250+(40*sentido));
    rect1.move();
}

  void trans1(){
    linetrans1up = new Recta(300,290,350,290);
    for(int i = 0; i < linetrans1up.obstacles.size(); i++){
       obs.add(linetrans1up.getObstacle(i));
    }
    linetrans1down = new Recta(300,360,350,360);
    for(int i = 0; i < linetrans1down.obstacles.size(); i++){
       obs.add(linetrans1down.getObstacle(i));
    }
  }

  void block2(int seq, int sentido){
    line6.pos1.set(100+((seq-1)*250),290+(70*sentido));
    line6.pos2.set(200+((seq-1)*250),190+(270*sentido));
    line6.move();

    line7.pos1.set(200+((seq-1)*250),190+(270*sentido));
    line7.pos2.set(300+((seq-1)*250),290+(70*sentido));
    line7.move();
 
    triang1.pos1.set(200+((seq-1)*250),270+(110*sentido));
    triang1.pos2.set(100+((seq-1)*250),360-(70*sentido));
    triang1.pos3.set(300+((seq-1)*250),360-(70*sentido));
    triang1.move();
  }

  void trans2(){
    linetrans2up = new Recta(550,290,600,290);
    for(int i = 0; i < linetrans2up.obstacles.size(); i++){
      obs.add(linetrans2up.getObstacle(i));
    }
    linetrans2down = new Recta(550,360,600,360);
    for(int i = 0; i < linetrans2down.obstacles.size(); i++){
      obs.add(linetrans2down.getObstacle(i));
    }
  }

  void block3(int seq){
    line8.pos1.set(100+((seq-1)*250),290);
    line8.pos2.set(100+((seq-1)*250),200);
    line8.move();
  
    line9.pos1.set(100+((seq-1)*250),200);
    line9.pos2.set(300+((seq-1)*250),200);
    line9.move();
 
    line10.pos1.set(300+((seq-1)*250),200);
    line10.pos2.set(300+((seq-1)*250),290);
    line10.move();
  
    line11.pos1.set(100+((seq-1)*250),360);
    line11.pos2.set(100+((seq-1)*250),450);
    line11.move();
  
    line12.pos1.set(100+((seq-1)*250),450);
    line12.pos2.set(300+((seq-1)*250),450);
    line12.move();
  
    line13.pos1.set(300+((seq-1)*250),450);
    line13.pos2.set(300+((seq-1)*250),360);
    line13.move();

    Thecircle.pos.set(200+((seq-1)*250),325);
  }
}
