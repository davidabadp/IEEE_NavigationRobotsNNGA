class Control_Sensores extends Thread{
  int id;
  float angle, angle_dir, dist2obs;
  float dist_sensor [];
  Control_Sensores(int ident, float angle, float angle_dir, float [] dist_sensor, float dist2obs){
    id = ident;
    this.angle = angle;
    this.angle_dir = angle_dir;
    this.dist_sensor = dist_sensor;
    this.dist2obs = dist2obs;
  }
  
  public void run (){
    if(angle > (angle_dir-PI+HALF_PI*id) && angle < (angle_dir-PI+HALF_PI*(id+1))){
      try{
          if (dist_sensor[id] > dist2obs){
            dist_sensor[id] = dist2obs;
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
