package processing.test.templatesimposio;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class templateSimposio extends PApplet {





















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
Abelha abelha;

float accelX = 0;
float accelY = 0;

Box2DProcessing box2d;
Spring spring;
ArrayList<Mandala> pairs;

ArrayList<Boundary> boundaries;

PImage bgAtual;
PImage bg [] = new PImage [4];

PImage mandalas[] = new PImage [28];

Catavento catavento;
KetaiAudioInput mic;
boolean voou, criaBolha;
boolean rodou;
float forcaSopro;
float tempo;
float sopro;
short[] data;
ArrayList<Bolha> arrayBolhas;
PImage [] imagemLinha = new PImage [12];
Bolha qualBolha;
float t0;
float tempoVida;

public void setup() {
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
  box2d.listenForCollisions();

  pairs = new ArrayList<Mandala>();
  spring = new Spring();

  boundaries.add(new Boundary(displayWidth/2, 0, 1.5f*displayWidth, 10));
  boundaries.add(new Boundary(0, displayHeight/2, 10, 1.5f*displayHeight));
  boundaries.add(new Boundary(displayWidth, displayHeight/2, 10, 1.5f*displayHeight));

  mic = new KetaiAudioInput(this);
  catavento = new Catavento(150, height/2);
  tempo = 0.5f;
  voou = false;
  for (int i = 0; i<12; i++) {
    imagemLinha[i]  = loadImage("bolha"+(i+1)+".png");
  }
  arrayBolhas = new ArrayList<Bolha>();

  bg[0] = loadImage("fundo amarelo.png");
  bg[1] = loadImage("fundo azul.png");
  bg[2] = loadImage("fundo verde.png");
  bg[3] = loadImage("fundo vermelho.png");
  bgAtual = bg[0];

  //amarelo
  mandalas[0] = loadImage("amarelo1.png");
  mandalas[1] = loadImage("amarelo2.png");
  mandalas[2] = loadImage("amarelo3.png");
  mandalas[3] = loadImage("amarelo4.png");
  mandalas[4] = loadImage("amarelo5.png");
  mandalas[5] = loadImage("amarelo6.png");
  mandalas[6] = loadImage("amarelo7.png");
  //azul
  mandalas[7] = loadImage("azul1.png");
  mandalas[8] = loadImage("azul2.png");
  mandalas[9] = loadImage("azul3.png");
  mandalas[10] = loadImage("azul4.png");
  mandalas[11] = loadImage("azul5.png");
  mandalas[12] = loadImage("azul6.png");
  mandalas[13] = loadImage("azul7.png");
  //verde
  mandalas[14] = loadImage("verde1.png");
  mandalas[15] = loadImage("verde2.png");
  mandalas[16] = loadImage("verde3.png");
  mandalas[17] = loadImage("verde4.png");
  mandalas[18] = loadImage("verde5.png");
  mandalas[19] = loadImage("verde6.png");
  mandalas[20] = loadImage("verde7.png");
  //vermelho
  mandalas[21] = loadImage("vermelho1.png");
  mandalas[22] = loadImage("vermelho2.png");
  mandalas[23] = loadImage("vermelho3.png");
  mandalas[24] = loadImage("vermelho4.png");
  mandalas[25] = loadImage("vermelho5.png");
  mandalas[26] = loadImage("vermelho6.png");
  mandalas[27] = loadImage("vermelho7.png");
  //frameRate(24);
}

public void draw() {
  //print(frameRate);
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
      ellipse(sizeX/2, sizeY/2, sizeX*0.8f, sizeX*0.8f);
    } else {
      ellipse(sizeX/2, sizeY/2, sizeY*0.8f, sizeY*0.8f);
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
      ellipse(sizeX*0.8f, sizeX*0.2f, sizeX*0.1f, sizeX*0.1f);
      fill(0);
      text("+", sizeX*0.8f, sizeX*0.195f);
    } else {
      ellipse(sizeX*0.8f, sizeY*0.2f, sizeY*0.1f, sizeY*0.1f);
      fill(0);
      text("+", sizeX*0.8f, sizeY*0.195f);
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
      ellipse(sizeX*0.2f, sizeX*0.2f, sizeX*0.1f, sizeX*0.1f);
      fill(0);
      text("-", sizeX*0.2f, sizeX*0.195f);
    } else {
      ellipse(sizeY*0.2f, sizeY*0.2f, sizeY*0.1f, sizeY*0.1f);
      fill(0);
      text("-", sizeY*0.2f, sizeY*0.195f);
    }
  } else {
    //background(200);    
    if (id ==0) {
      background(bg[0]);
    } else if (id ==1) {
      background(bg[1]);
    } else if (id ==2) {
      background(bg[2]);
    } else if (id ==3) {
      background(bg[3]);
    }
    while (_client.numMessages () > 0) {
      //print(_client.numMessages());
      JSONObject j = _client.getNextMessage();
      processMessage(j);
    } 
    box2d.step();
    spring.update(mouseX, mouseY);    
    if (rodou) {  
      catavento.cinematicaCatavento(10);
    }
    if (data != null)
    {  
      // println(sopro);
      for (int i = 0; i < data.length; i++)
      {
        if (i != data.length-1)
          sopro = map(data[i], -32768, 32767, 0, 100);
      }
    }
    if (sopro > 53) {
      rodou = true;
      //catavento.setaAtritoCatavento(tempo, 10);
      t0 = millis();
      voou = true;

      //forcaSopro = sopro/2;
      criaBolha = true;
      if (arrayBolhas.size()>6) {
        criaBolha = false;
      }
      forcaSopro = sopro/100;
    }

    if (millis() - t0 > tempo*1000) {
      //catavento.setaAtritoCatavento(tempo, 100);
      rodou = false;
      criaBolha = false;
      //println("parou de rodar");
    } 

    //    if (mic.isActive())
    //      text("READING MIC", width/2, height/2);
    //    else
    //      text("NOT READING MIC", width/2, height/2);
    if (criaBolha) {
      tempoVida = millis();
      //int(random(0,11))
      //arrayBolhas.add(new Bolha(nextId, 150, random(height/2-100, height/2+100), random(30, 120), random(120, 173), random(0, 10)*forcaSopro, 0*forcaSopro, int(random(0, 11)) ));
      objetos.add(new Bolha(nextId, 150, random(height/2-100, height/2+100), random(30, 120), random(120, 173), random(0, 10)*random(0, 1), 0, PApplet.parseInt(random(0, 11)) ));
      //int(random(0,11))
    }
    for (Objeto o : objetos) {
      if (o.obj.equals("Bolha")) {
        Bolha b = (Bolha) o; 
       // if (millis() - tempoVida > b.tempoVida()*1000) {
         if(b.tempoVida()){
          //arrayBolhas.remove(b);
          remove.add (0, objetos.indexOf(b));
        }
      }
    }
    for (Integer i : remove) {
      objetos.remove(i.intValue());
    }
    remove.clear();


    //  
    for (int i = 0; i < pairs.size (); i++) {  
      Mandala p = pairs.get(i);
      p.display();
    }
    for (Objeto o : objetos) {
      o.processa();
      //println(objetos.size());
      //println(objetos.size()+" "+o.obj+" "+o.replicado+" "+o.recebido);
      
      //se objeto perto da borda replica em outro dispositvo
      if ((portrait&&((o.y + o.radius) >= sizeY))|| 
        (!portrait&&((o.x + o.radius) >= sizeX))) {
        if (o.replicado == false) {
          o.replicado = true;
          if (o.obj == "Bolha") {
            if (portrait) replicados.add(new Bolha(o.id, o.x - sizeX, o.y, o.radius, o.hue, o.vx, o.vy, o.qualImagem));
            else replicados.add(new Bolha(o.id, o.x - sizeX, o.y, o.radius, o.hue, o.vx, o.vy, o.qualImagem));
          } else if (o.obj == "Vagalume") {
            if (portrait) replicados.add(new Vagalume(o.id, o.x, o.y - sizeY, o.vx, o.vy, o.radius));
            else replicados.add(new Vagalume(o.id, o.x - sizeX, o.y, o.vx, o.vy, o.radius));
          } else if (o.obj == "Abelha") {            
            if (portrait) replicados.add(new Abelha(o.id, o.x, o.y - sizeY, o.vx, o.vy, o.radius));
            else replicados.add(new Abelha(o.id, o.x - sizeX, o.y, o.vx, o.vy, o.radius));
          }
        }
      } else if ((portrait&&((o.y - o.radius) <= 0))||
        (!portrait&&((o.x - o.radius) <= 0))) {
        if (o.replicado == false) {
          o.replicado = true;
          if (o.obj == "Bolha") {
            if (portrait) replicados.add(new Bolha(o.id, o.x, o.y + sizeY, o.radius, o.hue, o.vx, o.vy, o.qualImagem));
            else replicados.add(new Bolha(o.id, o.x, o.y + sizeY, o.radius, o.hue, o.vx, o.vy, o.qualImagem));
          } else if (o.obj == "Vagalume") {
            if (portrait) replicados.add(new Vagalume(o.id, o.x, o.y + sizeY, o.vx, o.vy, o.radius));
            else replicados.add(new Vagalume(o.id, o.x + sizeX, o.y, o.vx, o.vy, o.radius));
          } else if (o.obj == "Abelha") {
            if (portrait) replicados.add(new Abelha(o.id, o.x, o.y + sizeY, o.vx, o.vy, o.radius));
            else replicados.add(new Abelha(o.id, o.x + sizeX, o.y, o.vx, o.vy, o.radius));
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
          //println(o.x+" "+o.y);
        }
      }
    }
    if (id == 0) {
      catavento.desenhaCatavento();
    }
    if (vagalume != null) {
      if (vagalume.ligado) {
        noStroke();
        fill(50, 50, 50, 200);
        rect(0, 0, sizeX, sizeY);
      }
      vagalume.desenha();
    }else{
    //TODO
    }

    //println(replicados.size());
    for (Objeto r : replicados) {      
      if (_client.isConnected()) {
        JSONObject j = new JSONObject();
        j.setString("ac", "objeto");
        if (r.obj == "Bolha") {
          //print("bolha");
          j.setString("Objeto", "Bolha");
          if (r.y > sizeY/2) {
            j.setInt("para", ((id - 1)+2) % 2);
            //j.setInt("para", id);
          } else {
            j.setInt("para", (id + 1) % 2);
            //j.setInt("para", id);
          }
          j.setInt("ID", r.id);
          j.setFloat("x", r.x);
          j.setFloat("y", r.y);
          j.setFloat("vx", r.vx);
          j.setFloat("vy", r.vy);
          j.setFloat("hue", r.hue);
          j.setFloat("raio", r.radius);
          j.setInt("img", r.qualImagem);
        } else if (r.obj == "Vagalume") {
          j.setString("Objeto", "Vagalume");
          if (r.y > sizeY/2) {
            j.setInt("para", ((id - 1)+2) % 2);
            //j.setInt("para", id);
          } else {
            j.setInt("para", (id + 1) % 2);
            //j.setInt("para", id);
          }
          j.setInt("ID", r.id);
          j.setFloat("x", r.x);          
          j.setFloat("y", r.y);
          j.setFloat("vx", r.vx);
          j.setFloat("vy", r.vy);
          if (vagalume != null)j.setBoolean("ligado", vagalume.ligado);          
          j.setFloat("raio", r.radius);
        } else if (r.obj == "Abelha") {
          j.setString("Objeto", "Abelha");
          if (r.y > sizeY/2) {
            j.setInt("para", ((id - 1)+2) % 2);
            //j.setInt("para", id);
          } else {
            j.setInt("para", (id + 1) % 2);
            //j.setInt("para", id);
          }
          j.setInt("ID", r.id);
          j.setFloat("x", r.x);          
          j.setFloat("y", r.y);
          j.setFloat("vx", r.vx);
          j.setFloat("vy", r.vy);        
          j.setFloat("raio", r.radius);
        }
        _client.sendJSON(j);
        //println(j);
      }
    }
    replicados.clear();

    for (Integer i : remove) {
     // print(objetos.get(i.intValue()).obj);
      if(objetos.get(i.intValue()).obj.equals("Vagalume")){
        vagalume = null;
      }      
      objetos.remove(i.intValue());
    }

    remove.clear();

    //if (mousePressed) {

    // objetos.add(new Circulo(nextId, mouseX, mouseY, 25));
    // nextId++;
    //}
  }
}

//eventos
//acelerometro
public void onAccelerometerEvent(float x, float y, float z)
{
  if (abs(accelX - x) > 0.25f)accelX = -x;  
  if (abs(accelY - y) > 0.25f)accelY = y;
}

//gestos
public void onTap(float x, float y)
{
  if (vagalume != null) {
    if ((x < vagalume.x + vagalume.radius)&&
      (x > vagalume.x - vagalume.radius)&&
      (y < vagalume.y + vagalume.radius)&&
      (y > vagalume.y - vagalume.radius)) {

      vagalume.ligado = !vagalume.ligado;
    }
  }
  if ((dist(mouseX, mouseY, 150, height/2) < 100) && (id == 0)){
    
    rodou = true;
    t0 = millis();
    voou = true;
    criaBolha = true;
    int qtd;
    qtd = 0;
    for (Objeto o : objetos) {
      if (o.obj.equals("Bolha"))qtd++;
    }
    if (qtd >6) {
      criaBolha = false;
    }
    forcaSopro = sopro/ 100;
  }


  //criacao mandalas
  qualBolha = testaClique(x, y);
  
  //println(qualBolha);
  if (qualBolha != null) {
    if (!sync&&( y <= (displayHeight/2.0f))) {
      if ((id == 0) && (x < displayWidth*0.2f)) return;
     
      boolean lugarOcupado = false;
      for (Mandala mand : pairs) {
        float r = mand.movel.r;
        float px = mand.x;
        float py = mand.y;
        float l = mand.len;

        float dist = dist(x, y, px, l);

        if (dist < 2*r) lugarOcupado = true;
      }
      if (!lugarOcupado) {
        remove.add(0,objetos.indexOf(qualBolha));
        Mandala p = new Mandala(x, y, max(40, y));
        pairs.add(p);
      }
    }
  }
}

public void onDoubleTap(float x, float y) {

  //  if (!sync&&( y <= (displayHeight/2.0))) {
  //   if((id == 0) && (x < displayWidth*0.2)) return;
  //   
  //    boolean lugarOcupado = false;
  //    for (Mandala mand : pairs) {
  //      float r = mand.movel.r;
  //      float px = mand.x;
  //      float py = mand.y;
  //      float l = mand.len;
  //
  //      float dist = dist(x, y, px, l);
  //
  //      if (dist < 2*r) lugarOcupado = true;
  //    }
  //    if (!lugarOcupado) {
  //      Mandala p = new Mandala(x, y, max(40, y));
  //      pairs.add(p);
  //    }
  //  }
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
public void onFlick( float x, float y, float px, float py, float v)
{
}


public void connect() {
  _client = new JSONTCPClient("150.164.112.73", 8765);       

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
      //mic.start();
      vagalume = new Vagalume(0, 50);      
      objetos.add(vagalume);
      
      abelha = new Abelha(1001,-100,(height/2),10,0,50);
      abelha.replicado = true;
      abelha.recebido = true;
      objetos.add(abelha);      
     // println(objetos.size());
    }
  } else {
    print("not connected");
  }
}

//pointer local
public void mousePressed() {
  //
  if (sync) {
    if (sizeX < sizeY) {
      //-
      if ((mouseX > (sizeX*0.2f - sizeX*0.1f))&&
        (mouseX < (sizeX*0.2f + sizeX*0.1f))&&
        (mouseY > (sizeX*0.2f - sizeX*0.1f))&&
        (mouseY < (sizeX*0.2f + sizeX*0.1f))) {

        if (id > 0) id--;
        //+
      } else if ((mouseX > (sizeX*0.8f - sizeX*0.1f))&&
        (mouseX < (sizeX*0.8f + sizeX*0.1f))&&
        (mouseY > (sizeX*0.2f - sizeX*0.1f))&&
        (mouseY < (sizeX*0.2f + sizeX*0.1f))) {

        if (id < 3) id++;
        //rede
      } else if ((mouseX > (sizeX/2 - sizeX*0.8f))&&
        (mouseX < (sizeX/2 + sizeX*0.8f))&&
        (mouseY > (sizeY/2 - sizeX*0.8f))&&
        (mouseY < (sizeY/2 + sizeX*0.8f))) {
        connect();
      }
    } else {
      //-
      if ((mouseX > (sizeY*0.2f - sizeY*0.1f))&&
        (mouseX < (sizeY*0.2f + sizeY*0.1f))&&
        (mouseY > (sizeY*0.2f - sizeY*0.1f))&&
        (mouseY < (sizeY*0.2f + sizeY*0.1f))) {

        if (id > 0) id--;
        //+
      } else if ((mouseX > (sizeX*0.8f - sizeY*0.1f))&&
        (mouseX < (sizeX*0.8f + sizeY*0.1f))&&
        (mouseY > (sizeY*0.2f - sizeY*0.1f))&&
        (mouseY < (sizeY*0.2f + sizeY*0.1f))) {

        if (id < 3) id++;
        //rede
      } else if ((mouseX > (sizeX/2 - sizeY*0.8f))&&
        (mouseX < (sizeX/2 + sizeY*0.8f))&&
        (mouseY > (sizeY/2 - sizeY*0.8f))&&
        (mouseY < (sizeY/2 + sizeY*0.8f))) {

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

public void mouseReleased() {
  spring.destroy();
}

//json handler
public void processMessage(JSONObject msg) {

  // println(msg);
  String ac = msg.getString("ac");
  if (ac.equals("objeto")) {
    String objeto = msg.getString("Objeto");
    //print(objeto);
    if (objeto.equals("Bolha")) {
      int ID = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");      
      float vx = msg.getFloat("vx");
      float vy = msg.getFloat("vy");
      float hue = msg.getFloat("hue");
      float r = msg.getFloat("raio");
      int nimg = msg.getInt("img");
      //print(msg);
      objetos.add(new Bolha(ID, x, y, r, hue, vx, vy, nimg));
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
    } else if (objeto.equals("Abelha")) {
      int ID = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float vx = msg.getFloat("vx");
      float vy = msg.getFloat("vy");
      float r = msg.getFloat("raio");

      Abelha abe = new Abelha(ID, x, y, vx, vy, r);
      objetos.add(abe);
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
  } else if (ac.equals("abelha")) {
    //int ID = msg.getInt("ID");
    int altura = msg.getInt("altura");
    float alt = altura / 100.0f;
   // println(msg);
    Abelha abe = new Abelha(666, -100, displayHeight*alt, 10, 0, 50);
    objetos.add(abe);

    objetos.get(objetos.size()-1).recebido = true;
    objetos.get(objetos.size()-1).replicado = true;
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

public @Override
void onPause() {
  super.onPause();
  this.finish();
}


// Collision event functions!
public void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
    Particle p1 = (Particle) o1;
    p1.beginCol();
    Particle p2 = (Particle) o2;
    p2.beginCol();
  }
}

// Objects stop touching each other
public void endContact(Contact cp) {

  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
    Particle p1 = (Particle) o1;
    p1.endCol();
    Particle p2 = (Particle) o2;
    p2.endCol();
  }
}


public void onAudioEvent(short[] _data)
{
  data= _data;
}

public Bolha testaClique (float x, float y) {
  for (Objeto o : objetos) {
    if (o.obj.equals("Bolha")) {
      Bolha b = (Bolha) o;

      if ( dist(x, y, b.x, b.y)<  b.radius) {
        return b;
      }
    }
  }
  return null;
}

//void keyPressed() {
//
//  if (key == CODED) {
//    if (keyCode == MENU) {
//      println("apertou menu tablet");
//      if (mic.isActive())
//        mic.stop(); 
//      else
//        mic.start();
//    }
//  }
//}

public class Abelha extends Objeto {

  float ax, ay;
  int ligad = color(0, 255, 0);
  int desligado = color(0, 0, 0);
  boolean ligado = false;

  PImage[] quadros = new PImage[3];

  int quadro = 0;

  
  public Abelha(int id, float x, float y, float vx, float vy, float r) {
    super(id, x, y, 0);

    //println("Abelha: "+id+" "+x+" "+y);

    this.vx = vx;
    this.vy = vy;

    this.obj = "Abelha";
    this.radius = r;
    
    quadros[0] = loadImage("abelha1.png");
    quadros[1] = loadImage("abelha2.png");
    quadros[2] = loadImage("abelha3.png");
  }

  public void processa() {
    //processamento do objeto
    // println(x+" "+y);
    this.x += vx;
    quadro = (quadro + 1) % 3;
  } 

  public void desenha() {
    //desenha objeto na tela

    
   // pushMatrix();
   // resetMatrix();
   // translate(x, y);
    imageMode(CENTER);
    //stroke(0);
    image(quadros[0], x, y,2*radius,2*radius);    
   // popMatrix();
  }
}

public class Bolha extends Objeto {

  float tempoVida;  
  float createTime;
  
  Bolha(int id, float posX, float posY, float raio, float _hue, float _vx, float _vy, int _qualImagem) {
    super(id, posX, posY, 0);
    this.obj = "Bolha";    
    this.vx = _vx;
    this.vy = _vy;
    this.radius = raio;    
    gravidade= -0.002f;
    qualImagem = _qualImagem;
    hue = _hue;
    tempoVida = random(5, 20) * 1000;
    createTime = millis();
  }

  public void processa() {
    //processamento do objeto
    x =x + vx;
    y =y + vy;
    vx = vx +vento;
    vy =vy+ gravidade;   
  }  


  public void desenha() {
    colorMode(HSB);
    strokeWeight(2);
    fill(hue, 255, 255, 40);
    stroke(255);
    imageMode(CENTER);
    //println(imagemLinha);
    image(imagemLinha[qualImagem], x, y, radius, radius);
    ellipse(x, y, radius, radius);
    imageMode(CORNER);
  }

  //float tempoVida() {
    public boolean tempoVida(){
    //float vida;
    //vida = random(5, 40); 
    return ((millis() - createTime)  > tempoVida);
  }

  public void movimento(float _vento) {
    x =x+vx;
    y =y +vy;
    vx = vx +vento;
    vy =vy+ gravidade;
  }
}

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
    
    b.setUserData(this);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  public void display() {
    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(x,y,w,h);
  }
}
class Catavento {

  PImage catavento;
  float x, y, vRot, rot, t0, atrito, tempo;
  boolean rodou;

  Catavento(float _x, float _y) {

    x= _x;
    y = _y;
    rot = 0;
    //vRot = 0.5;

    t0 = millis();
    tempo = 2;
    catavento = loadImage("CATAVENTO_crop.png");
    atrito = 1;
  } 

  public void desenhaCatavento() {
    pushMatrix();
    resetMatrix();
    imageMode(CENTER);
    translate(x, y);
    rotate(-rot);
    image(catavento, 0, 0);
    popMatrix();
  }

  public void cinematicaCatavento( float vRot ) {

    rot = rot+ PI/vRot*atrito;
  }

  public void setaAtritoCatavento(float t, float div) {
    atrito = t/div;
  }
}

public class Circulo extends Objeto{

  ArrayList<PImage> quadros;//trocar para array
  int nextFrame;
    
  public Circulo(int id, float x, float y, float r){
     super(id,x,y,0);
     this.radius = r;
     this.obj = "Circulo";
     
     quadros = new ArrayList<PImage>();
     nextFrame = 0;
  } 

  public void processa(){
    //processamento do objeto
    if(portrait){
      this.y += 1;
    }else{
      this.x += 1;      
    }  
  }  
  
  
  public void desenha(){
    //desenha objeto na tela
    if(quadros.size() > 0){
      //desenha quadro
      PImage frame = quadros.get(nextFrame); 
      image(frame,x - frame.width/2,y - frame.height/2); 
    }else{
      fill(0,200,200);
      stroke(0);
      strokeWeight(2);
      ellipseMode(RADIUS);
      ellipse(x,y,radius,radius);
    }      
  }
}
//cada celular deve guardar seus vizinhos 
// para que os ojetos possam ser 'tranferidos'

class Dispositivo{

int id;
float sizeX;
float sizeY;
float originX;
float originY;
boolean portrait;


}


/**
 * JSONTCPClient creates a TCP client based on netp5/oscp5 library to exchange data formatted as JSON-encoded strings.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 * @version 2014-12-10
 */
public class JSONTCPClient {
  
  /**
   * The server address.
   */
  private String _server;
  
  /**
   * The server port.
   */
  private int _port;
  
  /**
   * The received messages waiting to be processed (JSONObject array).
   */
  private ArrayList<JSONObject> _messages = new ArrayList<JSONObject>();
  
  /**
   * The netp5-based tcp client.
   */
  private TcpClient _client;
  
  /**
   * JSONTCPClient constructor.
   * @param server The server address.
   * @param port The server port for connection.
   */
  public JSONTCPClient(String server, int port) {
    // get start values
    this._server = server;
    this._port = port;
    // try to connect
    this._client = new TcpClient(this, this._server, this._port);
  }
  
  /**
   * Is the server connected?
   * @return True if the object is connected to a server, false otherwise.
   */
  public boolean isConnected() {
    if (this._client != null) {
     if (this._client.socket() == null) {
        return (false);
      } else {
        return (true);
      }
    } else {
      return (false);
    }
  }
  
  /**
   * Assign a different server for connection.
   * @param server The server address.
   * @param port The server port for connection.
   */
  public void setServer(String server, int port) {
    if (this._client != null) {
      this._client.dispose();
      this._client = null;
    }
    this._server = server;
    this._port = port;
    this._client = new TcpClient(this, this._server, this._port);
  }
  
  /**
   * Retry server connection.
   */
  public void reconnect() {
    if (this._client != null) {
     if (this._client.socket() == null) {
        this._client.reconnect();
      }
    } else {
      this._client = new TcpClient(this, this._server, this._port);
    }
  }
  
  /**
   * Get the number of available messages to be processed.
   * @return The number of messages waiting to be processed.
   */
  public int numMessages() {
    return (this._messages.size());
  }
  
  /**
   * Clear the received messages array.
   */
  public void clearMessages() {
    this._messages.clear();
  }
  
  /**
   * Get the next available message for processing and remove it from the messages array.
   * @return A message to be processed or null if there is none at the list.
   */
  public JSONObject getNextMessage() {
    if (this._messages.size() > 0) {
      JSONObject ret = this._messages.get(0);
      this._messages.remove(0);
      return (ret);

    } else {
      return (null);
    }
  }
  
  /**
   * Send a single string to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, String value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setString(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a single int to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, int value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setInt(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a single float to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, float value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setFloat(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a single boolean to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, boolean value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setBoolean(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a full JSON object to the server.
   * @param json The JSON object.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendJSON(JSONObject json) {
    if (this.isConnected()) {
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Release object resources.
   */
  public void dispose() {
    this._server = null;
    this._messages.clear();
    this._messages = null;
    if (this._client != null) {
      this._client.dispose();
    }
    this._client = null;
  }
  
  /**
   * A string representation of the object.
   * @return The string representation.
   */
  public String toString() {
    if (this.isConnected()) {
      return("JSONTCPClient: " + this._server + ":" + this._port + "; messages: " + this._messages.size());
    } else {
      return("JSONTCPClient not connected. Waiting for " + this._server + ":" + this._port + ".");
    }
  }
  
  /**
   * Event automatically called when a message is received from server.
   * @param theMessage The received message.
   */
  private void netEvent(NetMessage theMessage) {
    JSONObject incoming = JSONObject.parse(theMessage.getString());
    if (incoming != null) {
      this._messages.add(incoming);
    }
  }
  
}
class Mandala {

  Particle fixa;
  Particle movel;

  float len;
  float x;
  float y;  
 
  // Chain constructor
  Mandala(float x, float y, float l) {
    this.x = x;
    this.y = y;
    //len = 100;
    len = l;

    
    fixa = new Particle(x,0,true);
    movel = new Particle(x+50*random(-1,1),y,false);


    DistanceJointDef djd = new DistanceJointDef();
    // Connection between previous particle and this one
    djd.bodyA = fixa.body;
    djd.bodyB = movel.body;
    // Equilibrium length
    djd.length = box2d.scalarPixelsToWorld(len);
    
    // These properties affect how springy the joint is 
    djd.frequencyHz = 0;  // Try a value less than 5 (0 for no elasticity)
    djd.dampingRatio = 0.1f; // Ranges between 0 and 1

    // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
    // We might need to someday, but for now it's ok
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
  }



  // Draw the bridge
  public void display() {
    Vec2 pos1 = box2d.getBodyPixelCoord(fixa.body);
    Vec2 pos2 = box2d.getBodyPixelCoord(movel.body);
    strokeWeight(3);
    stroke(100,150,100);
    line(pos1.x,pos1.y,pos2.x,pos2.y);

  //  fixa.display();
    movel.display();
  }
}

public abstract class Objeto{

  int id;
  float x;
  float y;
  float vx;
  float vy;
  float rot; // in degrees 
  float radius; //circle boundary 
  boolean replicado;
  boolean recebido;
  
  int qualImagem;
  float gravidade, vento;
  float hue;
  
  
  String obj;
  
  public Objeto(int id ,float x, float y, float r){
  
    this.id = id;
    this.x = x;
    this.y = y;
    this.rot = r;    
    replicado = false;
    recebido = false;
  } 

  public void processa(){
    //processamento do objeto
  }  
  
  
  public void desenha(){
    //desenha objeto na tela  
  }
}


// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  int col;
  int img = 0;

  boolean locked;
  Particle(float x, float y, boolean lock) {

    r = 40;
    if (lock) {
      r = 1;
    } else {

      float p = random(0, 1);   

      switch(id) {    
      case 0://amarelo
        if(p < 0.7f){
          img = PApplet.parseInt(random(0,6));
        }else{
          img = PApplet.parseInt(random(7,27));
        }        
        break;
      case 1://azul
        if(p < 0.7f){
          img = PApplet.parseInt(random(7,13));
        }else{
          if(random(0,1) < 0.66f)
            img = PApplet.parseInt(random(14,27));
          else
             img = PApplet.parseInt(random(0,6));
        }
        break;          
      case 2://verde
        if(p < 0.7f){
          img = PApplet.parseInt(random(14,20));
        }else{
          if(random(0,1) < 0.66f)
            img = PApplet.parseInt(random(0,13));
          else
            img = PApplet.parseInt(random(21,27));
        }
        break;
      case 3://vermelho
        if(p < 0.7f){
          img = PApplet.parseInt(random(21,27));
        }else{
          img = PApplet.parseInt(random(0,20));
        }
        break;
      }
    }
    locked = lock;
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    if (lock) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0.9f;
    fd.friction = 0.01f;
    fd.restitution = 0.5f;

    // Attach fixture to body
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setUserData(this);
    col = color(175);
  }

  // This function removes the particle from the box2d world
  public void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  public boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  public void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    if (locked) {
      pushMatrix();
      resetMatrix();
      translate(pos.x, pos.y);
      rotate(a);
      fill(col);
      stroke(0);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      // Let's add a line so we can see the rotation
      line(0, 0, r, 0);
      popMatrix();
    } else {
      //imagem
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(a/3);
      imageMode(CENTER);
      image(mandalas[img], 0, 0,2*r,2*r);  
      //fill(col);
      //stroke(0);
      //strokeWeight(1);
      //ellipse(0,0,r*2,r*2);
      // Let's add a line so we can see the rotation
      //line(0,0,r,0);
      popMatrix();
    }
  }


  public boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  public void beginCol() {
    col = color(255, 0, 0);
  }

  public void endCol() {
    col = color(175);
  }
}


// Class to describe the spring joint (displayed as a line)

class Spring {

  // This is the box2d object we need to create
  MouseJoint mouseJoint;

  Spring() {
    // At first it doesn't exist
    mouseJoint = null;
  }

  // If it exists we set its target to the mouse location 
  public void update(float x, float y) {
    if (mouseJoint != null) {
      // Always convert to world coordinates!
      Vec2 mouseWorld = box2d.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }

  public void display() {
    if (mouseJoint != null) {
      // We can get the two anchor points
      Vec2 v1 = new Vec2(0,0);
      mouseJoint.getAnchorA(v1);
      Vec2 v2 = new Vec2(0,0);
      mouseJoint.getAnchorB(v2);
      // Convert them to screen coordinates
      v1 = box2d.coordWorldToPixels(v1);
      v2 = box2d.coordWorldToPixels(v2);
      // And just draw a line
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }


  // This is the key function where
  // we attach the spring to an x,y location
  // and the Box object's location
  public void bind(float x, float y, Particle p) {
    // Define the joint
    MouseJointDef md = new MouseJointDef();
    // Body A is just a fake ground body for simplicity (there isn't anything at the mouse)
    md.bodyA = box2d.getGroundBody();
    // Body 2 is the box's boxy
    md.bodyB = p.body;
    // Get the mouse location in world coordinates
    Vec2 mp = box2d.coordPixelsToWorld(x,y);
    // And that's the target
    md.target.set(mp);
    // Some stuff about how strong and bouncy the spring should be
    md.maxForce = 100.0f * p.body.m_mass;
    md.frequencyHz = 3.0f;
    md.dampingRatio = 0.9f;

    // Make the joint!
    mouseJoint = (MouseJoint) box2d.world.createJoint(md);
  }

  public void destroy() {
    // We can get rid of the joint when the mouse is released
    if (mouseJoint != null) {
      box2d.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }
}


public class Vagalume extends Objeto {

  float ax, ay;
  int ligad = color(0, 255, 0);
  int desligado = color(0, 0, 0);
  boolean ligado = false;

  PImage qOn1;
  PImage qOn2;
  PImage qOff1;
  PImage qOff2;

  int quadro = 1;

  public Vagalume(int id, float r) {
    super(id, random(sizeX*0.1f, sizeX*0.9f), random(sizeY*0.1f, sizeY*0.9f), 0);
    this.radius = r;

    vx = random(-3, 3);
    vy = random(-3, 3);

    this.obj = "Vagalume";
    
    qOn1 = loadImage("chicoaceso1.png");
    qOn2 = loadImage("chicoaceso2.png");
    qOff1 = loadImage("chicoapagado1.png");
    qOff2 = loadImage("chicoapagado2.png");
  } 

  public Vagalume(int id, float x, float y, float vx, float vy, float r) {
    super(id, x, y, 0);
    this.radius = r;

    this.vx = vx;
    this.vy = vy;

    this.obj = "Vagalume";
    
    qOn1 = loadImage("chicoaceso1.png");
    qOn2 = loadImage("chicoaceso2.png");
    qOff1 = loadImage("chicoapagado1.png");
    qOff2 = loadImage("chicoapagado2.png");
  }

  public void processa() {
    //processamento do objeto

    if ((portrait && ((y > sizeY*0.95f) || (y < sizeY*0.05f)))||
        (!portrait && ((x > sizeX*0.95f) || (x < sizeX*0.05f)))) {
      x = x + vx;
      y = y + vy;
    } else {    
      //atualiza pos
      vx = vx + ax;
      vy = vy + ay;

      x = x + vx;
      y = y + vy;

      ax = ax*0.5f;
      ay = ay*0.5f;

      vx = vx * 0.98f;
      vy = vy * 0.98f;

      vx = vx + random(-1, 1)*noise(x/1000);
      vy = vy + random(-1, 1)*noise(y/1000);

      //voa grupo
      atrator();
      atrator(sizeX/2, sizeY/2);     
    }
    quadro = (quadro + 1) % 2;
  }  

  public void atrator(float x, float y) {
    ax = ax + (x - this.x)/10000.0f;
    ay = ay + (y - this.y)/10000.0f;
  }

  public void atrator() {  
    if (portrait)
      atrator(random(0, sizeX), map(accelY, -4, 4, 0, sizeY));
    else
      atrator(map(accelX, -5, 5, 0, sizeX),random(0, sizeY));
  }


  public void desenha() {
    //desenha objeto na tela

    ellipseMode(CENTER);
    pushMatrix();
    resetMatrix();
    translate(x, y);
    imageMode(CENTER);
    if(ax < 0)
      scale(-1,1);
    else if(ax > 0)
      scale(1,1);
    //stroke(0);
    if (ligado) {
      //fill(ligad);
      if(quadro == 1)
        image(qOn1,0,0);
      else
        image(qOn2,0,0);
    } else {
      //fill(desligado);
      if(quadro == 1)
        image(qOff1,0,0);
      else
        image(qOff2,0,0);
    }
    
    /*
    ellipse(0, 0, 20, 20); 
    fill(255, 255, 255);
    rotate(random(-0.5, 0.5));
    ellipse(12, 0, 8, 8);
    rotate(random(-0.5, 0.5));
    ellipse(-12, 0, 8, 8);
    popMatrix();
    */
  }
}


}
