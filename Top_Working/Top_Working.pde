import NeuralNetwork.*;

//Training
boolean next_generation = true;
int nIndiv = 100;
int nCrossPoints = 1000;
float mutation_rate = 0.0001;

//Robot
Robot walle;
Meta target;
Rectangulo rect,rect1;
Triangulo triang;
Recta line;
int tempo = 100;
float tiempo = 0.0;
float tiempoWalle = 0.0;
float dist = 0.0;
float distWalle = 0.0;
float ener = 0.0;
float enerWalle = 0.0;
ArrayList <Obstaculo> obstacles;

int frameNumber = 0;
String mood_navigation;
PrintWriter log_file; 
int captura = 0;

//Maps
Mapas map;
int n,m;

void setup(){
  n = 9;
  m = 6; 
  size(900,600);
  frameRate(tempo);
  
  obstacles = new ArrayList <Obstaculo>();
  map = new Mapas(2,n,m);
  map.create();
  mood_navigation = "neural_networks";
  
  for(int i = 0; i < map.obs.size(); i++){
    obstacles.add(map.getObstacle(i));
  }

  walle = new Robot(this, mood_navigation);
  walle.pos = map.get_start_pos();
  
  target = new Meta(20,500,300);
  target.pos = map.get_target_pos();
  
  if(mood_navigation == "neural_networks"){
    walle.model.printParams();
    walle.model.readWeights(walle.neu, walle.model);}
  
  String name = "Datos";
  log_file = createWriter("Data/" + name + ".txt");
}

void draw(){
  frameNumber++;
  tiempo=millis();
  background(200);
  
  target.draw();
  walle.draw();
  for(Obstaculo o : obstacles){o.draw();}
  
  walle.compute_work(target,obstacles,frameCount);
  
   if(frameCount % 20 == 0){
    captura++;
    saveFrame("Fotos/Dificil_NN"+ "_Captura" + captura + ".png");
  }
  
  if(walle.has_arrived == false){
    dist+=(walle.getVelocidad()/tempo);
    ener+=(0.5*walle.getVelocidad()*walle.getVelocidad());
    text("Tiempo:"+tiempo,400,20);
    text("Distancia:"+dist,400,30);
    text("Energia:"+ener,400,40);
    //text("FrameCount:"+ frameCount,500,50);
    tiempoWalle=tiempo;
    distWalle=dist;
    enerWalle=ener;
   }
  else{
    text("Tiempo:"+tiempoWalle,400,20); 
    text("Distancia:"+distWalle,400,30);
    text("Energia:"+enerWalle,400,40);
    log_file.print("Tiempo:"+tiempoWalle+",Distancia:"+distWalle+",Energia:"+enerWalle);
    log_file.println();
    log_file.println("El robot ha triunfado");
    exit();
  }  
}

void keyPressed() {

}

void exit(){
  log_file.flush();
  log_file.close();
  println("Archivo cerrado");
  super.exit();//let processing carry with it's regular exit routine
}
