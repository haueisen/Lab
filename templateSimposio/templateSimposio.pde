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
boolean portrait = true;
boolean sync;

PFont font;

ArrayList<Objeto> objetos;
ArrayList<Objeto> replicados;
ArrayList<Objeto> esperandoID;
ArrayList<Integer> remove;

int nextId;

Vagalume vagalume;

float accelX;
float accelY;

void setup() {
  sync = true;

  sensor = new KetaiSensor(this);   
  gesture = new KetaiGesture(this);

  //size(displayWidth,displayHeight);
  if (portrait)
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
  remove = new ArrayList<Integer>();
  nextId = 0;
}

void draw() {
  // print(sync);
  println(frameRate+" "+objetos.size());
  //
  if (sync) {
    //protocolo para numerar os celulares
    //botao no meio da tela para conectar
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(3);
    fill(255);
    if (sizeX < sizeY) {
      ellipse(sizeX/2, sizeY/2, sizeX*0.8, sizeX*0.8);
    } else {
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
    if (sizeX < sizeY) {
      ellipse(sizeX*0.8, sizeX*0.2, sizeX*0.1, sizeX*0.1);
      fill(0);
      text("+", sizeX*0.8, sizeX*0.195);
    } else {
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
    if (sizeX < sizeY) {
      ellipse(sizeX*0.2, sizeX*0.2, sizeX*0.1, sizeX*0.1);
      fill(0);
      text("-", sizeX*0.2, sizeX*0.195);
    } else {
      ellipse(sizeY*0.2, sizeY*0.2, sizeY*0.1, sizeY*0.1);
      fill(0);
      text("-", sizeY*0.2, sizeY*0.195);
    }
  } else {
    background(200);    

    while (_client.numMessages () > 0) {
      //print(_client.numMessages());
      JSONObject j = _client.getNextMessage();
      processMessage(j);
    }    
    for (Objeto o : objetos) {
      o.processa();
      if (o.obj == "Circulo") {
        //AQUI estourar bolha
        
      }      
      //println(objetos.size()+" "+o.id+" "+o.replicado+" "+o.recebido);
      //se objeto perto da borda replica em outro dispositvo
      if ((o.y + o.radius) >= sizeY) {
        if (o.replicado == false) {
          o.replicado = true;
          if (o.obj == "Circulo") {
            replicados.add(new Circulo(o.id, o.x, o.y - sizeY, o.radius));
          } else if (o.obj == "Vagalume") {
            replicados.add(new Vagalume(o.id, o.x, o.y - sizeY, o.vx, o.vy, o.radius));
          }
        }
      } else if ((o.y - o.radius) <= 0) {
        if (o.replicado == false) {
          o.replicado = true;
          if (o.obj == "Circulo") {
            replicados.add(new Circulo(o.id, o.x, o.y + sizeY, o.radius));
          } else if (o.obj == "Vagalume") {
            replicados.add(new Vagalume(o.id, o.x, o.y + sizeY, o.vx, o.vy, o.radius));
          }
        }
      }
      if (((o.y + o.radius) < sizeY)&&((o.y - o.radius) > 0)) {
        //objeto recebido, removendo o status de replicado
        if (o.recebido) {
          o.replicado = false;
        }
        o.recebido = false;
      }
      //objeto fora da tela
      if (((o.y - o.radius) >= sizeY)||((o.y + o.radius) <= 0)) {        
        if (!o.recebido) {
          //println("remove");
          remove.add(0, objetos.indexOf(o));
        }
      } else {
        if(!o.obj.equals("Vagalume")){    
          o.desenha();
        }else{
          vagalume = (Vagalume) o;          
        }
      }
    }
    if(vagalume.ligado){
      noStroke();
      fill(50,50,50,200);
      rect(0,0,sizeX,sizeY);
    }
    vagalume.desenha();    
    //println(replicados.size());
    for (Objeto r : replicados) {      
      if (_client.isConnected()) {
        JSONObject j = new JSONObject();
        j.setString("ac", "objeto");
        if (r.obj == "Circulo") {
          j.setString("Objeto", "Circulo");
          if (r.y > sizeY/2) {
            //j.setInt("para", ((id - 1)+2) % 2);
            j.setInt("para", id);
          } else {
            //j.setInt("para", (id + 1) % 2);
            j.setInt("para", id);
          }
          j.setInt("ID", r.id);
          j.setFloat("x", r.x);
          j.setFloat("y", r.y);
          j.setFloat("raio", r.radius);
        } else if (r.obj == "Vagalume") {
          j.setString("Objeto", "Vagalume");
          if (r.y > sizeY/2) {
            //j.setInt("para", ((id - 1)+2) % 2);
            j.setInt("para", id);
          } else {
            //j.setInt("para", (id + 1) % 2);
            j.setInt("para", id);
          }
          j.setInt("ID", r.id);
          j.setFloat("x", r.x);          
          j.setFloat("y", r.y);
          j.setFloat("vx", r.vx);
          j.setFloat("vy", r.vy);
          if(vagalume != null)j.setBoolean("ligado",vagalume.ligado);          
          j.setFloat("raio", r.radius);
        }
        _client.sendJSON(j);
        //println(j);
      }
    }
    replicados.clear();

    for (Integer i : remove) {
      objetos.remove(i.intValue());
    }

    remove.clear();
    
    if(mousePressed) {

      objetos.add(new Circulo(nextId, mouseX, mouseY, 25));
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
}

//eventos
//acelerometro
void onAccelerometerEvent(float x, float y, float z)
{
  accelX = x;
  accelY = y;
}

//gestos
void onTap(float x, float y)
{
  if(vagalume != null){
    if((x < vagalume.x + vagalume.radius)&&
      (x > vagalume.x - vagalume.radius)&&
      (y < vagalume.y + vagalume.radius)&&
      (y > vagalume.y - vagalume.radius)){
    
      vagalume.ligado = !vagalume.ligado;
      
    }
  }
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{
}


void connect() {
  _client = new JSONTCPClient("192.168.0.100", 8765);       

  if (_client.isConnected()) {
    print("connected");
    JSONObject j = new JSONObject();
    j.setString("ac", "hi");
    j.setInt("numero", id);
    _client.sendJSON(j);
    sync = false;
    sensor.start();

    if (id == 0) {
      vagalume = new Vagalume(nextId, 40);
      nextId++;
      //AQUI mandar msg para pegar ID
      objetos.add(vagalume);
    }

    JSONObject j1 = new JSONObject();
    j1.setString("ac", "newid");
    _client.sendJSON(j1);
  } else {
    print("not connected");
  }
}

//pointer local
void mousePressed() {
  //
  if (sync) {
    if (sizeX < sizeY) {
      //-
      if ((mouseX > (sizeX*0.2 - sizeX*0.1))&&
        (mouseX < (sizeX*0.2 + sizeX*0.1))&&
        (mouseY > (sizeX*0.2 - sizeX*0.1))&&
        (mouseY < (sizeX*0.2 + sizeX*0.1))) {

        if (id > 0) id--;
        //+
      } else if ((mouseX > (sizeX*0.8 - sizeX*0.1))&&
        (mouseX < (sizeX*0.8 + sizeX*0.1))&&
        (mouseY > (sizeX*0.2 - sizeX*0.1))&&
        (mouseY < (sizeX*0.2 + sizeX*0.1))) {

        if (id < 3) id++;
        //rede
      } else if ((mouseX > (sizeX/2 - sizeX*0.8))&&
        (mouseX < (sizeX/2 + sizeX*0.8))&&
        (mouseY > (sizeY/2 - sizeX*0.8))&&
        (mouseY < (sizeY/2 + sizeX*0.8))) {
        connect();
      }
    } else {
      //-
      if ((mouseX > (sizeY*0.2 - sizeY*0.1))&&
        (mouseX < (sizeY*0.2 + sizeY*0.1))&&
        (mouseY > (sizeY*0.2 - sizeY*0.1))&&
        (mouseY < (sizeY*0.2 + sizeY*0.1))) {

        if (id > 0) id--;
        //+
      } else if ((mouseX > (sizeX*0.8 - sizeY*0.1))&&
        (mouseX < (sizeX*0.8 + sizeY*0.1))&&
        (mouseY > (sizeY*0.2 - sizeY*0.1))&&
        (mouseY < (sizeY*0.2 + sizeY*0.1))) {

        if (id < 3) id++;
        //rede
      } else if ((mouseX > (sizeX/2 - sizeY*0.8))&&
        (mouseX < (sizeX/2 + sizeY*0.8))&&
        (mouseY > (sizeY/2 - sizeY*0.8))&&
        (mouseY < (sizeY/2 + sizeY*0.8))) {

        connect();
      }
    }
  } 
}

//json handler
void processMessage(JSONObject msg) {

  // println(msg);
  String ac = msg.getString("ac");
  if (ac.equals("objeto")) {
    String objeto = msg.getString("Objeto");
    if (objeto.equals("Circulo")) {
      int ID = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float r = msg.getFloat("raio");
      
      objetos.add(new Circulo(ID, x, y, r));
    } else if (objeto.equals("Vagalume")) {
      int ID = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float vx = msg.getFloat("vx");
      float vy = msg.getFloat("vy");
      float r = msg.getFloat("raio");
      boolean l = msg.getBoolean("ligado");
      Vagalume v = new Vagalume(ID, x, y, vx, vy, r);
      v.ligado = l; 
      objetos.add(v);      
    }
    objetos.get(objetos.size()-1).recebido = true;
    objetos.get(objetos.size()-1).replicado = true;
  } else if (ac.equals("objid")) {
    println("objid"); 
    println(msg.getInt("numero"));
    if (esperandoID.size() > 0) {
      Objeto o = esperandoID.get(0);
      o.id = msg.getInt("numero");      
      objetos.add(o);
      esperandoID.remove(0);
    }
  } else if (ac.equals("erro")) {
    println(msg);
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
void onPause() {
  super.onPause();
  this.finish();
}

