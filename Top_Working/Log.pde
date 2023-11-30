import java.io.*;

class Log {
  FileWriter fichero = null;
  private PrintWriter output;  //Permite la creacion de archivos
  private String fileName;  //Variable para el nombre del archivo
  
  //Constructor de la clase
  Log(String fileName) {
    this.fileName=fileName;  //Asigamos nombre del archivo
    try{
      fichero= new FileWriter(this.fileName,true); //Si no existe, se crea sin renombrar
      output= new PrintWriter(fichero);}
    catch(IOException r){
    println("Fallo no se va a escribir");}
  }

  //Escribe datos nuevos
  public void write(String data) {
    try{
      output.print(data+"\n");  //Concatena los datos nuevos y asigna fin de linea
      println("Guardado Datos "+ data);}
    catch (Exception e) {
      e.printStackTrace();} 
    }
    
  //Cierra el archivo, para que sea utilizable
  public void close() {
    output.flush();  //Vaciamos buffer de escritura
    output.close();  //Cerramos el archivo
  }
}
