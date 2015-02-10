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

//Dentes de leao
int NUM = 6;            //Number of poems
int NUMFLOWERS = 4;     //Max number of flowers

PImage[] poemA, poemB, poemC, poemD, poemE, poemF; //Array of Images, poems are array of sentences of images
Dandelion[] dentesDeLeao;


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
  box2d.listenForCollisions();
  box2d.setScaleFactor(100f);
  
  pairs = new ArrayList<Mandala>();
  spring = new Spring();

  boundaries.add(new Boundary(displayWidth/2, 0, 1.5*displayWidth, 10));
  boundaries.add(new Boundary(0, displayHeight/2, 10, 1.5*displayHeight));
  boundaries.add(new Boundary(displayWidth, displayHeight/2, 10, 1.5*displayHeight));

  mic = new KetaiAudioInput(this);
  catavento = new Catavento(150, height/2);
  tempo = 0.5;
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
  
  dentesDeLeao = new Dandelion[NUMFLOWERS]; 
  for (int i=0; i<dentesDeLeao.length; i++) {
    dentesDeLeao[i] = new Dandelion();
  }

  loadPoemImages();  
  
  //frameRate(24);
}

void draw() {
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
      objetos.add(new Bolha(nextId, 150, random(height/2-100, height/2+100), random(30, 120), random(120, 173), random(0, 10)*random(0, 1), 0, int(random(0, 11)) ));
      //int(random(0,11))
    }
    for (Objeto o : objetos) {
      if (o.obj.equals("Bolha")) {
        Bolha b = (Bolha) o; 
       // if (millis() - tempoVida > b.tempoVida()*1000) {
         if(b.tempoVida() || b.die){
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
      if(p.tempoVida()){
        p.fixa.killBody();        
      }
      if(box2d.getBodyPixelCoord(p.movel.body).y > 1000){
        remove.add(0,new Integer(i));
      }
      //print(box2d.getBodyPixelCoord(p.movel.body).y);     
      //p.display();
    }
    
    for (Integer i : remove) {
      pairs.remove(i.intValue());
    }
    remove.clear();
    
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
    for (int i=0; i<dentesDeLeao.length; i++) {
      if (dentesDeLeao[i].isAlive()) {
        dentesDeLeao[i].rendFlower();
        if (!dentesDeLeao[i].isGrowing()) {
          dentesDeLeao[i].isColliding(mouseX, mouseY);
        }
      }
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
    
     for (int i=0; i<dentesDeLeao.length; i++) {
      dentesDeLeao[i].rendPoem();
    }
    
    print(pairs.size());
    //if (mousePressed) {

    // objetos.add(new Circulo(nextId, mouseX, mouseY, 25));
    // nextId++;
    //}
  }
}

//eventos
//acelerometro
void onAccelerometerEvent(float x, float y, float z)
{
  if (abs(accelX - x) > 0.25)accelX = -x;  
  if (abs(accelY - y) > 0.25)accelY = y;
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

   if (mouseY>2*height/3)
  {
    for (int i=0; i<dentesDeLeao.length; i++) {
      if (!dentesDeLeao[i].isAlive()) {
        dentesDeLeao[i].born(height, width, 124, 30, NUM);
      }
    }
  }


  //criacao mandalas
  qualBolha = testaClique(x, y);
  
  //println(qualBolha);
  if (qualBolha != null) {
    if (!sync&&( y <= (displayHeight/2.0))) {
      if ((id == 0) && (x < displayWidth*0.2)) return;
     
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
        Mandala p = new Mandala(x, y, max(40, y));
        pairs.add(p);
      }      
    }
    qualBolha.die = true;  
  }   
}

void onDoubleTap(float x, float y) {

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
void onFlick( float x, float y, float px, float py, float v)
{
}


void connect() {
  _client = new JSONTCPClient("150.164.112.71", 8765);       

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
        spring.destroy();
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
    float alt = altura / 100.0;
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

@Override
void onPause() {
  super.onPause();
  this.finish();
}


// Collision event functions!
void beginContact(Contact cp) {
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
void endContact(Contact cp) {

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


void onAudioEvent(short[] _data)
{
  data= _data;
}

Bolha testaClique (float x, float y) {
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

void loadPoemImages() {
  // Poem A
  this.poemA = new PImage[38];
  this.poemA[0] = loadImage("Al_A0.png");
  this.poemA[1] = loadImage("Al_A1.png");
  this.poemA[2] = loadImage("Al_A2.png");
  this.poemA[3] = loadImage("Al_A3.png");
  this.poemA[4] = loadImage("pausa.png");
  this.poemA[5] = loadImage("Al_B0.png");
  this.poemA[6] = loadImage("Al_B1.png");
  this.poemA[7] = loadImage("Al_B2.png");
  this.poemA[8] = loadImage("Al_B3.png");
  this.poemA[9] = loadImage("Al_B4.png");
  this.poemA[10] = loadImage("pausa.png");
  this.poemA[11] = loadImage("Al_C0.png");
  this.poemA[12] = loadImage("Al_C1.png");
  this.poemA[13] = loadImage("Al_C2.png");
  this.poemA[14] = loadImage("Al_C3.png");
  this.poemA[15] = loadImage("pausa.png");
  this.poemA[16] = loadImage("Al_D0.png");
  this.poemA[17] = loadImage("Al_D1.png");
  this.poemA[18] = loadImage("Al_D2.png");
  this.poemA[19] = loadImage("Al_D3.png");
  this.poemA[20] = loadImage("pausa.png");
  this.poemA[21] = loadImage("Al_E0.png");
  this.poemA[22] = loadImage("Al_E1.png");
  this.poemA[23] = loadImage("Al_E2.png");
  this.poemA[24] = loadImage("Al_E3.png");
  this.poemA[25] = loadImage("pausa.png");
  this.poemA[26] = loadImage("Al_F0.png");
  this.poemA[27] = loadImage("Al_F1.png");
  this.poemA[28] = loadImage("Al_F2.png");
  this.poemA[29] = loadImage("pausa.png");
  this.poemA[30] = loadImage("Al_G0.png");
  this.poemA[31] = loadImage("Al_G1.png");
  this.poemA[32] = loadImage("pausa.png");
  this.poemA[33] = loadImage("Al_H0.png");
  this.poemA[34] = loadImage("Al_H1.png");
  this.poemA[35] = loadImage("Al_H2.png");
  this.poemA[36] = loadImage("Al_H3.png");
  this.poemA[37] = loadImage("Al_H4.png");

  // Poem b
  this.poemB = new PImage[12];
  this.poemB[0] = loadImage("RO1_A0.png");
  this.poemB[1] = loadImage("pausa.png");
  this.poemB[2] = loadImage("RO1_B0.png");
  this.poemB[3] = loadImage("RO1_B1.png");
  this.poemB[4] = loadImage("RO1_B2.png");
  this.poemB[5] = loadImage("pausa.png");
  this.poemB[6] = loadImage("RO1_C0.png");
  this.poemB[7] = loadImage("RO1_C1.png");
  this.poemB[8] = loadImage("RO1_C2.png");
  this.poemB[9] = loadImage("pausa.png");
  this.poemB[10] = loadImage("RO1_D0.png");
  this.poemB[11] = loadImage("RO1_D1.png");

  // Poem C
  this.poemC = new PImage[14];
  this.poemC[0] = loadImage("RO2_A0.png");
  this.poemC[1] = loadImage("pausa.png");
  this.poemC[2] = loadImage("RO2_B0.png");
  this.poemC[3] = loadImage("RO2_B1.png");
  this.poemC[4] = loadImage("RO2_B2.png");
  this.poemC[5] = loadImage("pausa.png");
  this.poemC[6] = loadImage("RO2_C0.png");
  this.poemC[7] = loadImage("RO2_C1.png");
  this.poemC[8] = loadImage("RO2_C2.png");
  this.poemC[9] = loadImage("RO2_C3.png");
  this.poemC[10] = loadImage("pausa.png");
  this.poemC[11] = loadImage("RO2_D0.png");
  this.poemC[12] = loadImage("RO2_D1.png");
  this.poemC[13] = loadImage("RO2_D2.png");

  // Poem D
  this.poemD = new PImage[9];
  this.poemD[0] = loadImage("RO3_A0.png");
  this.poemD[1] = loadImage("pausa.png");
  this.poemD[2] = loadImage("RO3_B0.png");
  this.poemD[3] = loadImage("RO3_B1.png");
  this.poemD[4] = loadImage("RO3_B2.png");
  this.poemD[5] = loadImage("RO3_B3.png");
  this.poemD[6] = loadImage("RO3_B4.png");
  this.poemD[7] = loadImage("RO3_B5.png");
  this.poemD[8] = loadImage("RO3_B6.png");

  // Poem E
  this.poemE = new PImage[8];
  this.poemE[0] = loadImage("RO4_A0.png");
  this.poemE[1] = loadImage("pausa.png");
  this.poemE[2] = loadImage("RO4_B0.png");
  this.poemE[3] = loadImage("RO4_B1.png");
  this.poemE[4] = loadImage("RO4_B2.png");
  this.poemE[5] = loadImage("RO4_B3.png");
  this.poemE[6] = loadImage("RO4_B4.png");
  this.poemE[7] = loadImage("RO4_B5.png");

  // Poem F
  this.poemF = new PImage[9];
  this.poemF[0] = loadImage("pausa.png");
  this.poemF[1] = loadImage("pausa.png");
  this.poemF[2] = loadImage("pausa.png");
  this.poemF[3] = loadImage("pausa.png");
  this.poemF[4] = loadImage("pausa.png");
  this.poemF[5] = loadImage("pausa.png");
  this.poemF[6] = loadImage("pausa.png");
  this.poemF[7] = loadImage("pausa.png");
  this.poemF[8] = loadImage("pausa.png");
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

