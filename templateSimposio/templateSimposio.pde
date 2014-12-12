import java.util.*;
import android.view.MotionEvent;

import ketai.camera.*;
import ketai.net.*;
import ketai.ui.*;
import ketai.sensors.*;
import ketai.data.*;

import apwidgets.*;

JSONTCPClient _client;

KetaiSensor sensor;
KetaiGesture gesture;

int id;
float sizeX;
float sizeY;
float originX;
float originY;
boolean portrait = false;
boolean sync;

PFont font;

ArrayList<Objeto> objetos;
ArrayList<Objeto> replicados;
ArrayList<Objeto> esperandoID;

int nextId;

Vagalume vagalume;

float accelX;

void setup(){
  sync = true;
  
  sensor = new KetaiSensor(this);   
  gesture = new KetaiGesture(this);
  
  //size(displayWidth,displayHeight);
  if(portrait)
    orientation(PORTRAIT);   
  else
    orientation(LANDSCAPE);   
  
  id = 0;
  sizeX = displayWidth;
  sizeY = displayHeight;
  //println(sizeX);
  //println(sizeY);
  originX = 0;
  originY = 0;
  
  objetos = new ArrayList<Objeto>();
  replicados = new ArrayList<Objeto>();
  esperandoID = new ArrayList<Objeto>();
  nextId = 0;  
  
}

void draw(){
 // print(sync);
  if(sync){
    //protocolo para numerar os celulares
    
    //botao no meio da tela para conectar
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(3);
    fill(255);
    if(sizeX < sizeY){
      ellipse(sizeX/2, sizeY/2, sizeX*0.8, sizeX*0.8);
    }else{
      ellipse(sizeX/2, sizeY/2, sizeY*0.8, sizeY*0.8);
    }
    font = createFont("Arial", 72);
    textFont(font);
    textAlign(CENTER, CENTER);
    fill(0);
    text(id, sizeX/2, sizeY/2);
    
    //botoes pra alterar id
      //+
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(3);
    fill(255);
    font = createFont("Arial", 72);
    textFont(font);
    textAlign(CENTER, CENTER);
    if(sizeX < sizeY){
      ellipse(sizeX*0.8, sizeX*0.2, sizeX*0.1, sizeX*0.1);
      fill(0);
      text("+", sizeX*0.8, sizeX*0.195);
    }else{
      ellipse(sizeX*0.8, sizeY*0.2, sizeY*0.1, sizeY*0.1);
      fill(0);
      text("+", sizeX*0.8, sizeY*0.195);
    }
      //-
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(3);
    fill(255);
    font = createFont("Arial", 72);
    textFont(font);
    textAlign(CENTER, CENTER);
    if(sizeX < sizeY){
      ellipse(sizeX*0.2, sizeX*0.2, sizeX*0.1, sizeX*0.1);
      fill(0);
      text("-", sizeX*0.2, sizeX*0.195);
    }else{
      ellipse(sizeY*0.2, sizeY*0.2, sizeY*0.1, sizeY*0.1);
      fill(0);
      text("-", sizeY*0.2, sizeY*0.195);
    }
    
  }else{
    background(200);    
  
    while(_client.numMessages() > 0){
      //print(_client.numMessages());
      JSONObject j = _client.getNextMessage();
      processMessage(j);
    }
    ArrayList<Integer> remove = new ArrayList<Integer>();//AQUI bug multiplicacao
    for(Objeto o : objetos){
      o.processa();
      //se objeto perto da borda replica em outro dispositvo
      if((o.x + o.radius) >= sizeX){
        if(o.replicado == false){
          o.replicado = true;
          if(o.obj == "Circulo"){
            replicados.add(new Circulo(o.id,o.x - sizeX,o.y,o.radius));
          }else if(o.obj == "Vagalume"){
            replicados.add(new Vagalume(o.id,o.x - sizeX,o.y,o.vx,o.vy,o.radius));
          }         
        } 
      }else if((o.x - o.radius) <= 0){
        if(o.replicado == false){
          o.replicado = true;
          if(o.obj == "Circulo"){
            replicados.add(new Circulo(o.id,o.x + sizeX,o.y,o.radius));
          }else if(o.obj == "Vagalume"){
            replicados.add(new Vagalume(o.id,o.x + sizeX,o.y,o.vx,o.vy,o.radius));
          }         
        } 
      }
      if(((o.x - o.radius) >= sizeX)||((o.x + o.radius) <= 0)){
        remove.add(0,objetos.indexOf(o));
      }else{      
        o.desenha();
      }
    }
    for(Integer i : remove){
      objetos.remove(i);
    }
    remove.clear();
    for(Objeto r : replicados){
      if(_client.isConnected()){
        JSONObject j = new JSONObject();
        j.setString("ac","objeto");
        if(r.obj == "Circulo"){
          j.setString("Objeto","Circulo");
          if(r.x < sizeX/2){
            j.setInt("para",(id - 1) % 2);
          }else{
            j.setInt("para",(id + 1) % 2);
          }
          j.setInt("ID",r.id);
          j.setFloat("x",r.x);
          j.setFloat("y",r.y);
          j.setFloat("raio",r.radius);
        }else if(r.obj == "Vagalume"){
          j.setString("Objeto","Vagalume");
          if(r.x < sizeX/2){
            j.setInt("para",(id - 1) % 2);
          }else{
            j.setInt("para",(id + 1) % 2);
          }
          j.setInt("ID",r.id);
          j.setFloat("x",r.x);          
          j.setFloat("y",r.y);
          j.setFloat("vx",r.vx);
          j.setFloat("vy",r.vy);
          j.setFloat("raio",r.radius);
        }
        _client.sendJSON(j);
      }
    }
    replicados.clear();
    vagalume.processa();
    vagalume.desenha();    
  }
}

//eventos
//acelerometro
void onAccelerometerEvent(float x, float y, float z)
{
  accelX = x;
}

//gestos
void onTap(float x, float y)
{ 
  
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{ 
  
}


void connect(){
  _client = new JSONTCPClient("192.168.0.104", 8765);       
            
  if(_client.isConnected()){
    print("connected");
    JSONObject j = new JSONObject();
    j.setString("ac","hi");
    j.setInt("numero",id);
    _client.sendJSON(j);
    sync = false;
    sensor.start();
    
    vagalume = new Vagalume(nextId,40);
    nextId++;
    objetos.add(vagalume);
    
  }else{
    print("not connected");
  }
}

//pointer local
void mousePressed(){
  //
  if(sync){
    if(sizeX < sizeY){
        //-
        if((mouseX > (sizeX*0.2 - sizeX*0.1))&&
          (mouseX < (sizeX*0.2 + sizeX*0.1))&&
          (mouseY > (sizeX*0.2 - sizeX*0.1))&&
          (mouseY < (sizeX*0.2 + sizeX*0.1))){
        
          if(id > 0) id--;
        //+  
        }else if((mouseX > (sizeX*0.8 - sizeX*0.1))&&
                 (mouseX < (sizeX*0.8 + sizeX*0.1))&&
                 (mouseY > (sizeX*0.2 - sizeX*0.1))&&
                 (mouseY < (sizeX*0.2 + sizeX*0.1))){
            
          if(id < 3) id++;
        //rede  
        }else if((mouseX > (sizeX/2 - sizeX*0.8))&&
                 (mouseX < (sizeX/2 + sizeX*0.8))&&
                 (mouseY > (sizeY/2 - sizeX*0.8))&&
                 (mouseY < (sizeY/2 + sizeX*0.8))){
          connect();      

        }      
      }else{
        //-
        if((mouseX > (sizeY*0.2 - sizeY*0.1))&&
          (mouseX < (sizeY*0.2 + sizeY*0.1))&&
          (mouseY > (sizeY*0.2 - sizeY*0.1))&&
          (mouseY < (sizeY*0.2 + sizeY*0.1))){
        
          if(id > 0) id--;
        //+  
        }else if((mouseX > (sizeX*0.8 - sizeY*0.1))&&
                 (mouseX < (sizeX*0.8 + sizeY*0.1))&&
                 (mouseY > (sizeY*0.2 - sizeY*0.1))&&
                 (mouseY < (sizeY*0.2 + sizeY*0.1))){
            
          if(id < 3) id++;
        //rede 
        }else if((mouseX > (sizeX/2 - sizeY*0.8))&&
                 (mouseX < (sizeX/2 + sizeY*0.8))&&
                 (mouseY > (sizeY/2 - sizeY*0.8))&&
                 (mouseY < (sizeY/2 + sizeY*0.8))){
          
         connect();
        }
      }
  }else{
    
    objetos.add(new Circulo(nextId,mouseX,mouseY,25));
    nextId++;
    /*
    esperandoID.add(new Circulo(0,mouseX,mouseY,25));    
    JSONObject j = new JSONObject();
    j.setString("ac","newid");    
    _client.sendJSON(j);
    println("requested id");
    */
  }
}

//json handler
void processMessage(JSONObject msg){
  
  //println(msg);
  String ac = msg.getString("ac");
  if(ac.equals("objeto")){
    String objeto = msg.getString("Objeto");
    if(objeto.equals("Circulo")){
      int id = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float r = msg.getFloat("raio");
      objetos.add(new Circulo(id,x,y,r));
    }else if(objeto.equals("Vagalume")){
      int id = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float vx = msg.getFloat("vx");
      float vy = msg.getFloat("vy");
      float r = msg.getFloat("raio");
      objetos.add(new Vagalume(id,x,y,vx,vy,r));
    }
  }else if(ac.equals("objid")){
    if(esperandoID.size() > 0){
      Objeto o = esperandoID.get(0);
      o.id = msg.getInt("numero");      
      objetos.add(o);
      esperandoID.remove(0);      
    }
  } 
}

//surface
public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}

//fecha app qdo qlqr dos botoes (home, back, multitask) eh apertado
@Override
void onPause(){
  super.onPause();
  this.finish();
}
