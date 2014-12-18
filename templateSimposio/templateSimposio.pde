import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

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
ArrayList<Integer> remove;

int nextId;

Vagalume vagalume;

float accelX;
float accelY;

Box2DProcessing box2d;
Spring spring;
ArrayList<Mandala> pairs;

ArrayList<Boundary> boundaries;

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
  //esperandoID = new ArrayList<Objeto>();
  remove = new ArrayList<Integer>();
  boundaries = new ArrayList<Boundary>();
  nextId = 0;

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  pairs = new ArrayList<Mandala>();
  spring = new Spring();
  
  boundaries.add(new Boundary(displayWidth/2,0,1.5*displayWidth,10));
  boundaries.add(new Boundary(0,displayHeight/2,10,1.5*displayHeight));
  boundaries.add(new Boundary(displayWidth,displayHeight/2,10,1.5*displayHeight));
}

void draw() {
  // print(sync);
  // println(frameRate+" "+objetos.size());
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
    box2d.step();
    spring.update(mouseX, mouseY);
    for (int i = 0; i < pairs.size (); i++) {  
      Mandala p = pairs.get(i);
      p.display();
    }
    for (Objeto o : objetos) {
      o.processa();
      if (o.obj == "Circulo") {
        //AQUI estourar bolha
        //ao estourar bolha criar mandala
        //se ja houver mandala, nao cria
      }      
      //println(objetos.size()+" "+o.id+" "+o.replicado+" "+o.recebido);
      //se objeto perto da borda replica em outro dispositvo
      if ((portrait&&((o.y + o.radius) >= sizeY))|| 
        (!portrait&&((o.x + o.radius) >= sizeX))) {
        if (o.replicado == false) {
          o.replicado = true;
          if (o.obj == "Circulo") {
            if (portrait) replicados.add(new Circulo(o.id, o.x, o.y - sizeY, o.radius));
            else replicados.add(new Circulo(o.id, o.x - sizeX, o.y, o.radius));
          } else if (o.obj == "Vagalume") {
            if (portrait) replicados.add(new Vagalume(o.id, o.x, o.y - sizeY, o.vx, o.vy, o.radius));
            else replicados.add(new Vagalume(o.id, o.x - sizeX, o.y, o.vx, o.vy, o.radius));
          }
        }
      } else if ((portrait&&((o.y - o.radius) <= 0))||
        (!portrait&&((o.x - o.radius) <= 0))) {
        if (o.replicado == false) {
          o.replicado = true;
          if (o.obj == "Circulo") {
            if (portrait) replicados.add(new Circulo(o.id, o.x, o.y + sizeY, o.radius));
            else replicados.add(new Circulo(o.id, o.x + sizeX, o.y, o.radius));
          } else if (o.obj == "Vagalume") {
            if (portrait) replicados.add(new Vagalume(o.id, o.x, o.y + sizeY, o.vx, o.vy, o.radius));
            else replicados.add(new Vagalume(o.id, o.x + sizeX, o.y, o.vx, o.vy, o.radius));
          }
        }
      }
      if ((portrait&&(((o.y + o.radius) < sizeY)&&((o.y - o.radius) > 0)))||
        (!portrait&&(((o.x + o.radius) < sizeX)&&((o.x - o.radius) > 0)))) {
        //objeto recebido, removendo o status de replicado
        if (o.recebido) {
          o.replicado = false;
        }
        o.recebido = false;
      }
      //objeto fora da tela
      if ((portrait&&(((o.y - o.radius) >= sizeY)||((o.y + o.radius) <= 0)))||
        (!portrait&&(((o.x - o.radius) >= sizeX)||((o.x + o.radius) <= 0)))) {        
        if (!o.recebido) {
          //println("remove");
          remove.add(0, objetos.indexOf(o));
        }
      } else {
        if (!o.obj.equals("Vagalume")) {    
          o.desenha();
        } else {
          vagalume = (Vagalume) o;
        }
      }
    }
    if (vagalume.ligado) {
      noStroke();
      fill(50, 50, 50, 200);
      rect(0, 0, sizeX, sizeY);
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
          if (vagalume != null)j.setBoolean("ligado", vagalume.ligado);          
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

    if (mousePressed) {

      // objetos.add(new Circulo(nextId, mouseX, mouseY, 25));
      // nextId++;
    }
  }
}

//eventos
//acelerometro
void onAccelerometerEvent(float x, float y, float z)
{
  accelX = -x;
  accelY = y;
}

//gestos
void onTap(float x, float y)
{
  if (vagalume != null) {
    if ((x < vagalume.x + vagalume.radius)&&
      (x > vagalume.x - vagalume.radius)&&
      (y < vagalume.y + vagalume.radius)&&
      (y > vagalume.y - vagalume.radius)) {

      vagalume.ligado = !vagalume.ligado;
    }
  }
}

void onDoubleTap(float x, float y) {

  if (!sync&&( y <= (displayHeight/3.0))) {  
    Mandala p = new Mandala(x, y, max(40, y));
    pairs.add(p);
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

    nextId = (id+1) * 1000;

    if (id == 0) {
      vagalume = new Vagalume(0, 40);
      // nextId++;
      //AQUI mandar msg para pegar ID

      objetos.add(vagalume);
      //      esperandoID.add(vagalume);
      //      JSONObject v = new JSONObject();
      //      v.setString("ac","newid");    
      //      _client.sendJSON(v);
    }
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
  } else {

    for (int i = 0; i < pairs.size (); i++) {
      // Check to see if the mouse was clicked on the box
      Particle p = pairs.get(i).movel;    
      if (p.contains(mouseX, mouseY)) {
        // And if so, bind the mouse location to the box with a spring
        spring.bind(mouseX, mouseY, p);
      }
    }
  }
}

void mouseReleased() {
  spring.destroy();
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
    //println("objid"); 
    //println(msg.getInt("numero"));
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

