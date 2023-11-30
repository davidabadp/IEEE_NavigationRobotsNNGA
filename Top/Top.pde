import NeuralNetwork.*;

//Training
boolean next_generation = true;
int maxGenerations = 100;
int generation = 0;
int maxRepetitions = 10;
int repetitions = 0;
Population population;
ArrayList <Robot> robots;
int nIndiv = 100;
int nCrossPoints = 20;
float mutation_rate = 0.005;
int elite_indivs = 25;
int rand = 0;
String mood_navigation;
int cuenta = -1;
//Maps
Mapas map;
int n,m;
ArrayList <Obstaculo> obstacles;

//Robot
Robot walle;
Meta target;

//Program
int tempo = 100;
int frameNumber = 0;
int captura = 0;

//Files
PrintWriter weights_file[] = new PrintWriter [maxRepetitions*maxGenerations];
PrintWriter log_file1[] = new PrintWriter [maxRepetitions];
//PrintWriter loss_file[] = new PrintWriter [maxRepetitions];
//PrintWriter log_file2[] = new PrintWriter [maxRepetitions];
//PrintWriter log_file3[] = new PrintWriter [maxRepetitions];

void setup(){
  n = 9;
  m = 6; 
  size(900,600); //Poner n*100 y m*100
  frameRate(tempo);
  
  obstacles = new ArrayList <Obstaculo>();
  /*walle = new Robot(this, "potential_fields");
  walle.rgb_color = color(255,0,255);
  walle.pos.set(100,100);*/

  target = new Meta(20,850,330);
  map = new Mapas(3,n,m);
  map.create();
  mood_navigation = "neural_networks";
  
  for(int i = 0; i < map.obs.size(); i++){
    obstacles.add(map.getObstacle(i));
  }
  println("Obtacles size: " + map.obs.size());
  
  robots = new ArrayList <Robot>();
  for(int i = 0; i < nIndiv; i++){
    Robot walle_neural = new Robot(this, mood_navigation);
    if(mood_navigation == "neural_networks"){
      if (i < elite_indivs){
        walle_neural.rgb_color = color(255,255,0);
      }
    }
    robots.add(walle_neural);
  }
  
  int nParam = robots.get(0).getnParameters();
  population = new Population(this, nIndiv, nParam);
  population.crossover_type = "multiple_random";
  if(mood_navigation == "neural_networks"){
      robots.get(0).model.printParams();
  }
  
  //robots.get(0).model.creatFiles();
  for(int i = repetitions; i < (maxRepetitions); i++){
    log_file1[i] = createWriter("Data/" + "ROBOTS_" + i + ".txt");
    //loss_file[i] = createWriter("Data/" + "LOSS_" + i + ".txt");
    //log_file2[i] = createWriter("Data/" + "ROBOTS_OUT_" + i + ".txt");
    //log_file3[i] = createWriter("Data/" + "ROBOTS_TOP_" + i + ".txt");
    log_file1[i].println("Generation,num_target,num_obs,num_robotstop,dist2obj_target,dist_target,ener_target,dist2obj_obs,dist_obs,ener_obs,dist2obj_null,dist_null,ener_null,best_loss,global_loss");
    //loss_file[i].println("Generation, best_loss");
    //log_file2[i].println("Generation,num_obs");
    //log_file3[i].println("Generation,porcentaje_robots_top");
  }
  for(int i = repetitions; i < (maxRepetitions*maxGenerations); i++){
    //loss_file[i] = createWriter("Data/" + "LOSS_" + i + ".txt");
    weights_file[i] = createWriter("Data/" + "WEIGHTS_" + i + ".txt");
    //log_file2[i] = createWriter("Data/" + "ROBOTS_OUT_" + i + ".txt");
    //log_file3[i] = createWriter("Data/" + "ROBOTS_TOP_" + i + ".txt");
    //loss_file[i].println("Generation, best_loss");
    //log_file2[i].println("Generation,num_obs");
    //log_file3[i].println("Generation,porcentaje_robots_top");
  }
}

void draw(){
  frameNumber++;
  background(200);
  
  //walle.draw();
  //walle.compute_work(target,obstacles);
  //triang.draw();
  //line.draw();
  //for(Obstaculo o : obstacles){o.draw();}
  
  if (next_generation){
    generation++;
    println("Generation: " + str(generation));
    rand = int(random(nIndiv));

    map.generate();
    Vector2D target_pos = map.get_target_pos();
    target.pos.set(target_pos.x, target_pos.y);
    
    //Init robot variables
    Vector2D startPos = map.get_start_pos();
    for (int i = 0; i < nIndiv; i++){
      robots.get(i).pos.set(startPos.x, startPos.y);
      robots.get(i).pos_in = startPos;
      robots.get(i).has_arrived = false;
      robots.get(i).flag_obs = false;
      robots.get(i).distance = 0.0;
      robots.get(i).time = 0.0;
      robots.get(i).energy = 0.0;
      robots.get(i).loss_extra = 0.0;
      if(mood_navigation == "neural_networks"){
        robots.get(i).model.genes2weights(population.individuals[i].chromosome, robots.get(i).getNeu(), robots.get(i).model);;
      }
    }
    next_generation = false;
    captura = 0;
  }
  
  for (int i = nIndiv-1; i >= 0; i--){
    robots.get(i).draw();
  }
  //walle.draw_sensors();
  //walle.draw();
  target.draw();
  for(Obstaculo o : obstacles){o.draw();}

  textSize(15);
  fill(0,0,255);
  text("Repeticion: " + repetitions ,400,12);
  text("Generacion: " + generation ,400,26);
  text("FPS: " + int(frameRate) ,0,12);
   
   /*println("Walle ditancia: " + walle.distance);
   println("Walle tiempo: " + walle.time);
   println("Walle energia: " + walle.energy);*/
   //println(robots.get(0).pos.x);
    for(int i = 0; i < nIndiv; i++){
      robots.get(i).compute_work(target,obstacles, frameCount);
    }
  
  /*walle.emulate_sensors(obstacles);
  walle.newAcel = new Vector2D((mouseX-walle.pos.x)/width, (mouseY-walle.pos.y)/height);
  walle.run_simulation(target,obstacles, frameCount);*/
  
  if(frameCount % 20 == 0){
    captura++;
    saveFrame("Fotos/Generacion" + generation + "_Captura" + captura + ".png");
  }
  
  if(frameCount % 1400 == 0){
    next_generation = true;
  }
 
  if (next_generation){
    for (int i = 0; i < nIndiv; i++){
      float loss = 0.0;
      float present = 1000.0;
      if(robots.get(i).has_arrived){
        present = 0.0;
      }
      //error = robots.get(i).model.compute_loss(exit);
      loss = (distancia(robots.get(i).pos, target.pos)*10) +  (robots.get(i).distance/500) + robots.get(i).loss_extra + present;
      population.individuals[i].fitness = 1/loss;
    }
   
    population.calculate_selection_probability();
  
    //Metrics
    int best = population.getBetsIndiv();
    if(mood_navigation == "neural_networks"){
      robots.get(best).model.genes2weights(population.individuals[best].chromosome, robots.get(best).getNeu(), robots.get(best).model);
    }
    
    int sum_ = 0;
    float mse_ = 0;
    float ener_target = 0.0;
    float ener_obs = 0.0;
    float ener_null = 0.0;
    float dist_target = 0.0;
    float dist_obs = 0.0;
    float dist_null = 0.0;
    float dist2obj_target = 0;
    float dist2obj_obs = 0;
    float dist2obj_null = 0;
    float global_loss = 0.0;
    int num_target = 0;
    int num_obs = 0;
    int num_null = 0;
    int num_robtop = 0;
    
    for(int i = 0; i < nIndiv; i++){
      if(robots.get(i).has_arrived){
        num_target++;
        dist2obj_target += robots.get(i).dist_objetivo;
        dist_target += robots.get(i).distance;
        ener_target += robots.get(i).energy;
      }
      else if(robots.get(i).flag_obs){
        num_obs++;
        dist2obj_obs += robots.get(i).dist_objetivo;
        dist_obs += robots.get(i).distance;
        ener_obs += robots.get(i).energy;
      }
      else{
        num_null++;
        dist2obj_null += robots.get(i).dist_objetivo;
        dist_null += robots.get(i).distance;
        ener_null += robots.get(i).energy;
      }
      
      if(robots.get(i).has_arrived && i<elite_indivs){
        num_robtop++;
      }
      
      global_loss +=  population.individuals[i].fitness;
    }
    
    if(num_target != 0){
      dist2obj_target = dist2obj_target/num_target;
      dist_target = dist_target/num_target;
      ener_target = ener_target/num_target;
    }
    if(num_obs != 0){
      dist2obj_obs = dist2obj_obs/num_obs;
      dist_obs = dist_obs/num_obs;
      ener_obs = ener_obs/num_obs;
    }
    if(num_null != 0){
      dist2obj_null = dist2obj_null/num_null;
      dist_null = dist_null/num_null;
      ener_null = ener_null/num_null;
    }
    global_loss = global_loss/nIndiv;
  
 
    log_file1[repetitions].println(generation + "," + num_target + "," + num_obs + "," + num_robtop + "," + dist2obj_target + "," 
    + dist_target + "," + ener_target + "," + dist2obj_obs + "," + dist_obs + "," + ener_obs+ "," + dist2obj_null + "," + dist_null + "," 
    + ener_null + "," + population.individuals[best].fitness + "," + global_loss);
    
    //float [] entry1 = {robots.get(best).pos.x, robots.get(best).pos.y, target.pos.x, target.pos.y};
    //float [] exit = {target.pos.x, target.pos.y};
    //robots.get(best).in.setNeurons(entry1);
    //robots.get(best).model.forward_prop();
    //mse
    //mse_ =  robots.get(best).model.mse( robots.get(best).model.layers.get( robots.get(best).model.layers.size()-1).neurons, exit);
    mse_ =  1/population.individuals[best].fitness;
    //accuracy

    if (robots.get(best).has_arrived){
      sum_++;
    }
    print("Fitness del mejor robot: " + population.individuals[best].fitness);
    print(" -> ");
    if(sum_ == 1){
      println("El Robot con mejor fitness ha llegado");
    }
    else{
      println("El Robot con mejor fitness no ha llegado");
    }
    println("loss: " + str(mse_));
    println("Nº de Robots que han llegado al Target: " + num_target);
    println("Nº de Robots que se han chocado con un Obstaculo: " + num_obs);
    if(elite_indivs != 0){
      println("Nº de Robots Top que han llegado al Target: " + num_robtop);
    }
    println();
  
    //if (repetitions == 0){
      //robots.get(repetitions).model.saveParamsLoss(generation, best, population.individuals[best].fitness);
    //}
    //loss_file[repetitions].println(generation + "," + population.individuals[best].fitness);
    cuenta++;
    for(int i= 0; i < population.individuals[best].chromosome_length; i++){
            weights_file[cuenta].print(population.individuals[best].chromosome[i]);
           if(i < (population.individuals[best].chromosome_length-1)){
              weights_file[cuenta].print("\t");
           }
        }
   weights_file[cuenta].flush();
   weights_file[cuenta].close();
  
    Individual child [] = new Individual [nIndiv];
    
    //Elitism
    if(elite_indivs != 0){
      int [] best_indivs = new int[elite_indivs];
      best_indivs[0] = best;
      float last_best_fitness = population.individuals[best].fitness;
      float best_fitness;
      for (int ei = 0; ei < elite_indivs; ei++){
        best_fitness = 0;
        for (int i = 0; i < nIndiv; i++){
          if (population.individuals[i].fitness > best_fitness){
            if (population.individuals[i].fitness < last_best_fitness){
              best_fitness = population.individuals[i].fitness;
              best_indivs[ei] = i;
            }
          }
        }
        last_best_fitness = best_fitness;
      }    
    
      for (int i = 0; i < elite_indivs; i++){
        //print("best_indivs:" + best_indivs[i]);
        //println("\tfitness:" + population.individuals[best_indivs[i]].fitness);
        child[i] = population.individuals[best_indivs[i]]; 
      }
    }
    
    for (int i = elite_indivs; i < nIndiv; i++){
      int p1 = population.get_parent();
      int p2 = population.get_parent();
    
      //crossover
      child[i] = population.crossover(p1, p2, nCrossPoints);
      //mutation
      child[i].addMutation(mutation_rate);
    }
  
    // Renew population
    for (int i = 0; i < nIndiv; i++){
      population.individuals[i] = child[i];  
    }
    
    if (generation == maxGenerations){
      if (repetitions == (maxRepetitions-1)){
        //robots.get(repetitions).model.ParamsWeights(best, population.individuals[best].chromosome_length, population.individuals[best].chromosome);
        //robots.get(repetitions).model.exit2();
        /*for(int i= 0; i < population.individuals[best].chromosome_length; i++){
            weights_file[repetitions].print(population.individuals[best].chromosome[i]);
           if(i < (population.individuals[best].chromosome_length-1)){
              weights_file[repetitions].print("\t");
           }
        }*/
        exit();//let processing carry with it's regular exit routine
      }
      else{
        /*if(repetitions == 0){
          robots.get(repetitions).model.ParamsWeights(best, population.individuals[best].chromosome_length, population.individuals[best].chromosome);
          robots.get(repetitions).model.exit2();
        }*/
        /*for(int i= 0; i < population.individuals[best].chromosome_length; i++){
            weights_file[repetitions].print(population.individuals[best].chromosome[i]);
           if(i < (population.individuals[best].chromosome_length-1)){
              weights_file[repetitions].print("\t");
           }
        }
        //loss_file[repetitions].flush();
        //loss_file[repetitions].close();
        weights_file[repetitions].flush();
        weights_file[repetitions].close();*/
        log_file1[repetitions].flush();
        log_file1[repetitions].close();
        //log_file2[repetitions].flush();
        //log_file2[repetitions].close();
        //log_file3[repetitions].flush();
        //log_file3[repetitions].close();
        println("Repeticion " + repetitions + " terminada.");
        repetitions ++;
        generation = 0;
        for(int i = 0; i < nIndiv; i++){
          for(int j = 0; j < population.individuals[i].chromosome_length;j++){
            population.individuals[i].chromosome[j] = random (-1,1);
          }
        }
      }
    }
  }
}

void exit(){
  //loss_file[maxRepetitions-1].flush();
  //loss_file[maxRepetitions-1].close();
  //weights_file[maxRepetitions-1].flush();
  //weights_file[maxRepetitions-1].close();
  log_file1[maxRepetitions-1].flush();
  log_file1[maxRepetitions-1].close();
  //log_file2[maxRepetitions-1].flush();
  //log_file2[maxRepetitions-1].close();
  //log_file3[maxRepetitions-1].flush();
  //log_file3[maxRepetitions-1].close();
  println("Ultima repetición terminada");
  super.exit();//let processing carry with it's regular exit routine
}
