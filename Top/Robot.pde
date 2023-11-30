import NeuralNetwork.*;

class Robot{
  float size = 10;
  color rgb_color = color(0,0,255);
  float maxAcel = 1;
  float maxVel = 1;
  
  float avoidance_gain = 1; //0.02
  float target_gain = 0.45;
  float dist_goal = 30.0;
  boolean has_arrived = false;
  boolean flag_obs = false;
  String work_type;
  
  float tempo = 100;
  float time = 0.0;
  float dist_objetivo;
  float distance = 0.0;
  float energy = 0.0;
  float loss_extra = 0.0;
  
  float radio_sensor = 100.0;
  float stop_dist = this.size/8;
  float dist_sensor [];
  int nSensors = 4;
  
  //Estado anterior
  float px_past = 0.0;
  float py_past = 0.0;
  float tx_past = 0.0;
  float ty_past = 0.0;
  float dist_sensor_past [];
  
  Vector2D pos;
  Vector2D vel;
  Vector2D acel;
  Vector2D pos_in;
  
  Vector2D newPos;
  Vector2D newVel;
  Vector2D newAcel;
  
  NN_Model model;
  InputLayer in;
  HiddenLayer lay1, lay2;
  OutputLayer out;
  int [] neu;
  int nParameters = 0;
  
  Robot(PApplet parent, String mood){
    pos = new Vector2D();
    vel = new Vector2D();
    acel = new Vector2D();
    pos_in = new Vector2D();
    
    newPos = new Vector2D();
    newVel = new Vector2D();
    newAcel = new Vector2D();
    
    work_type = mood;
    has_arrived = false;
    flag_obs = false;
    
    dist_sensor = new float [nSensors];
    dist_sensor_past = new float [nSensors];
    
    if(mood == "neural_networks"){
      model = new NN_Model(parent);
      //neu = new int [3];
      neu = new int [3];
      //neu[0] = 12;
      neu[0] = 8;
      neu[1] = 4;
      neu[2] = 2;
  
      in = new InputLayer(parent, neu[0]);
      lay1 = new HiddenLayer(parent, neu[1], in, "tanh");
      out = new OutputLayer(parent, neu[2], lay1, "tanh");
  
      for(int i = 0; i < (neu.length-1); i++){
        nParameters += neu[i]*neu[i+1];
      }
  
      model.addLayer(in);
      model.addLayer(lay1);
      model.addLayer(out);
      //model.setLoss("mse");
    }
  }
  
  void compute_work(Meta target, ArrayList<Obstaculo> obs, float tiempo){
    if (work_type == "potential_fields"){
      potential_fields(target, obs, tiempo);
    }
    else if (work_type == "neural_networks"){
      emulate_sensors(obs);
      run_neuralNetwork(target.pos);
      run_simulation(target, obs, tiempo);
    }
    else{
      println("ERROR: Work_type missmatch");
    }
  }
  
  void setWork(String work_type){
    this.work_type = work_type;
  }
  
  int getnParameters(){
    return nParameters;
  }
  
  int [] getNeu(){
    return neu;
  }
    
  
  void potential_fields(Meta target, ArrayList<Obstaculo> obs, float tiempo){
    Vector2D obstAvoid = new Vector2D (obstacleDir(obs));
    Vector2D target_heading = new Vector2D (targetDir(target));
    
    dist_objetivo = distancia(target.pos,this.pos) - size/2 - target.radio/2;
    if (dist_objetivo < stop_dist){
      has_arrived = true;
    }
    else{
      distance += this.getVelocidad();
      energy += 0.5*this.getVelocidad()*this.getVelocidad();
      time = tiempo;
    }

    newAcel.set(0,0);
    newAcel.add(obstAvoid);
    newAcel.add(target_heading);
    newAcel.limit(maxAcel); 
    
    newVel.add(newAcel);
    newVel.limit(maxVel);
    newPos.add(newVel);
    
    acel.set(newAcel);
    vel.set(newVel);
    pos.add(vel);
    
  }
  
  void emulate_sensors(ArrayList<Obstaculo> obs){
    for (int i = 0; i < nSensors; i++){
      dist_sensor[i] = radio_sensor;
    }
    
    for(int i=0; i < obs.size(); i++){
      float dist2obs = distancia(obs.get(i).pos, this.pos) - this.size/2 - obs.get(i).radio;
      if (dist2obs < radio_sensor){
        //angle from robot
        int sensor_id = 0;
        /*for(int j = 0; j < nSensors; j++){
          Vector2D dpos = substract(obs.get(i).pos, this.pos);
          float angle = atan2(dpos.y, dpos.x);
          float angle_dir = atan2(newVel.y, newVel.x);
          new Control_Sensores(j, angle, angle_dir, dist_sensor, dist2obs).start();
        }*/
        for(int j = 0; j < nSensors; j++){
          Vector2D dpos = substract(obs.get(i).pos, this.pos);
          float angle = atan2(dpos.y, dpos.x);
          float angle_dir = atan2(newVel.y, newVel.x);
          if(angle > (angle_dir-PI+HALF_PI*j) && angle < (angle_dir-PI+HALF_PI*(j+1))){
            sensor_id = j;
          }
        }
        /*Vector2D dpos = substract(obs.get(i).pos, this.pos);
        float angle = atan2(dpos.y, dpos.x) + PI;  // + PI elimina valores negativos
        int sensor_id = int(angle/(PI/2));
        //println ("ANGLE: " + angle);
        //println ("SENSOR_ID: " + sensor_id);*/
        
        
        try{
          if (dist_sensor[sensor_id] > dist2obs){
            dist_sensor[sensor_id] = dist2obs;
          }
        }
        catch(ArrayIndexOutOfBoundsException e){
          e.printStackTrace();
          if (dist_sensor[0] > dist2obs){
            dist_sensor[0] = dist2obs;
          }
        }
      }
    }
  }
  
  void run_neuralNetwork(Vector2D target){
    //float [] entry = {robots.get(i).pos.x, robots.get(i).pos.y, target.pos.x, target.pos.y};
    //float [] entry = {pos.x, pos.y, target.x, target.y, dist_sensor[0], dist_sensor[1], dist_sensor[2], dist_sensor[3]};
    
    //Normalizado
    float px = pos.x / float(width);
    float py = pos.y / float(height);
    float tx = target.x / float(width);
    float ty = target.y / float(height);
    
    float dist_sens_norm [] = new float [nSensors];;
    for (int i = 0; i < nSensors; i++){
      dist_sens_norm[i] = dist_sensor[i] / radio_sensor;
    }
    //float [] entry = {pos.x, pos.y, target.x , target.y , dist_sensor[0], dist_sensor[1], dist_sensor[2], dist_sensor[3]};
    float [] entry = {px, py, tx, ty, dist_sens_norm[0], dist_sens_norm[1], dist_sens_norm[2], dist_sens_norm[3]};
    //float [] entry = {px, py, tx, ty, dist_sens_norm[0], dist_sens_norm[1], dist_sens_norm[2], dist_sens_norm[3], dist_sens_norm[4], dist_sens_norm[5], dist_sens_norm[6], dist_sens_norm[7]};
    //px_past, py_past, tx_past, ty_past, dist_sensor_past[0]/radio_sensor, dist_sensor_past[1]/radio_sensor, dist_sensor_past[2]/radio_sensor, dist_sensor_past[3]/radio_sensor};
    
    /*px_past = px; 
    py_past = py; 
    tx_past = tx; 
    ty_past = ty; 
    dist_sensor_past = dist_sensor;*/
    /*px_past = pos.x; 
    py_past = pos.y; 
    tx_past = target.x; 
    ty_past = target.y; 
    dist_sensor_past =dist_sensor;*/
    
    in.setNeurons(entry);
    model.forward_prop();
    newAcel.set(out.neurons[0], out.neurons[1]);
  }
  
  void run_simulation(Meta target, ArrayList<Obstaculo> obs, float tiempo){
    //float dt = 1/60.0;
    if(!has_arrived){
      newAcel.limit(maxAcel);
      newVel.add(newAcel);
      newVel.limit(maxVel);
      //newPos.add(newVel);
    
      for(int i=0; i < obs.size(); i++){
        float obs_dist = distancia(obs.get(i).pos, this.pos) - this.size/2 - obs.get(i).radio/2;
        if (obs_dist < 0){
          flag_obs = true;
          loss_extra = 1000.0;
          
          Vector2D dpos = substract(obs.get(i).pos, this.pos);
          float angle = atan2(dpos.y, dpos.x); 
          float angle_dir = atan2(newVel.y, newVel.x);
          float d_angle = angle - angle_dir;
          if (d_angle < -PI){d_angle += 2*PI;}  // Corriegen la discontinuidad en +-360 deg
          if (d_angle > PI){d_angle -= 2*PI;}
          // si d_angle > 90 puede moverse
          if (abs(d_angle) < PI/2){
            newVel.set(0,0);
          }
        }
      }
      
      dist_objetivo = distancia(target.pos, this.pos) - size/2 - target.radio/2;
      if (dist_objetivo < stop_dist){
        has_arrived = true;
      }
      
      //Update new position and vel
      vel.set(newVel);
      vel.limit(maxVel);
      pos.add(vel);
      
      //Compute metrics
      if(flag_obs == false){
        distance += this.getVelocidad();
        energy += 0.5*this.getVelocidad()*this.getVelocidad();
        time = tiempo;
      }
     
    }
  }
  
  void draw(){
    fill(rgb_color);
    stroke(1);
    ellipse(pos.x, pos.y, size, size);
    line(pos.x, pos.y, pos.x + vel.x*(size/2), pos.y + vel.y*(size/2));
  }
  
  void draw_sensors(){
    for (int i = 0; i < nSensors; i++){
      fill(color(35*i,0,35*i));
      //float angle_dir = atan2(newVel.y, newVel.x);
      //arc(pos.x, pos.y, dist_sensor[i]*2, dist_sensor[i]*2, -PI+HALF_PI*i + angle_dir, -2.0/4.0*PI+HALF_PI*i + angle_dir);
      arc(pos.x, pos.y, dist_sensor[i]*2, dist_sensor[i]*2, -PI+HALF_PI*i, -2.0/4.0*PI+HALF_PI*i);
    }
  }
  
  Vector2D targetDir(Meta target){
    Vector2D force = new Vector2D();
    //Compute distances
    Vector2D dist = new Vector2D();
    dist.set(substract(target.pos, this.pos));
    float distancia = distancia(this.pos,target.pos) - size/2 - target.radio/2;
    if (distancia < 0){
      distancia *= -1;
    }
    
    if(distancia < dist_goal){
      force= dist;
      force.multiply_by(target_gain);
    }
    else{
      force=dist;
      force.multiply_by((target_gain*dist_goal)/distancia);
    }
    return(force);
  }
  
  Vector2D obstacleDir(ArrayList <Obstaculo> obs){
    Vector2D force = new Vector2D();
    //Compute distances
     for(int i=0; i<obs.size(); i++){
      Vector2D dist = new Vector2D();
      //Vector2D dir = new Vector2D();
      //Vector2D obsQ = new Vector2D(3.0+obs.get(i).pos.x+ obs.get(i).radio,3.0+obs.get(i).pos.y+ obs.get(i).radio);
      //float distQ = obsQ.getModule();
      dist.set(substract(this.pos,obs.get(i).pos));
      //dir.set(0,0);
      float distancia = (dist.getModule() - size/2 - obs.get(i).radio/2) - 3*size;
      if (distancia < 0){
        distancia *= -1;
      }
      //if(distancia < distQ){
       // float dirX = ((1/obsQ.x - 1/dist.x) * (1/dist.x*dist.x));
       // float dirY = ((1/obsQ.y - 1/dist.y) * (1/dist.y*dist.y));
       // dir.set(dirX,dirY);
        //dir.multiply_by(avoidance_gain);
      //}
      distancia = distancia/size; //Scale
      distancia = 1/distancia;
      dist.setMagnitude(distancia);
      dist.multiply_by(avoidance_gain);
      force.add(dist);
    }
    return(force);
  }
  
  float getVelocidad (){
    return vel.getModule();
  }
}
