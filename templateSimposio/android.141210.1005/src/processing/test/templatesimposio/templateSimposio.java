package processing.test.templatesimposio;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.view.MotionEvent; 
import oscP5.*; 
import netP5.*; 
import ketai.camera.*; 
import ketai.net.*; 
import ketai.ui.*; 
import ketai.sensors.*; 
import ketai.data.*; 
import apwidgets.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class templateSimposio extends PApplet {















OscP5 oscP5tcpClient;
KetaiSensor sensor;
KetaiGesture gesture;
  
String ServerAddress = "192.168.1.101";


int id;
float sizeX;
float sizeY;
float originX;
float originY;
boolean portrait = true;;
boolean sync;

PFont font;

public void setup(){
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
  originX = 0;
  originY = 0;
}

public void draw(){
  if(sync){
    //protocolo para numerar os celulares
    
    //botao no meio da tela para conectar
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(3);
    fill(255);
    if(sizeX < sizeY){
      ellipse(sizeX/2, sizeY/2, sizeX*0.8f, sizeX*0.8f);
    }else{
      ellipse(sizeX/2, sizeY/2, sizeX*0.8f, sizeX*0.8f);
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
      ellipse(sizeX*0.8f, sizeX*0.2f, sizeX*0.1f, sizeX*0.1f);
      fill(0);
      text("+", sizeX*0.8f, sizeX*0.195f);
    }else{
      ellipse(sizeY*0.8f, sizeY*0.2f, sizeY*0.1f, sizeY*0.1f);
      fill(0);
      text("+", sizeY*0.8f, sizeY*0.195f);
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
      ellipse(sizeX*0.2f, sizeX*0.2f, sizeX*0.1f, sizeX*0.1f);
      fill(0);
      text("-", sizeX*0.2f, sizeX*0.195f);
    }else{
      ellipse(sizeY*0.2f, sizeY*0.2f, sizeY*0.1f, sizeY*0.1f);
      fill(0);
      text("-", sizeY*0.2f, sizeY*0.195f);
    }
    
    
    // ao clicar faz a conexao e o  servidor devolve o id
    // o id \u00e9 atribuido sequencialmente
    //oscP5tcpClient = new OscP5(this, ServerAddress, 11000, OscP5.TCP);
    //se sync acabou
    //sensor.start();
  }else{
  background(200);
  
  }
}

//eventos
//acelerometro
public void onAccelerometerEvent(float x, float y, float z)
{
  if(oscP5tcpClient != null){
  oscP5tcpClient.send("/accel",new Object[]{new Float(x),new Float(y),new Float(z)});
  }
}

//gestos
public void onDoubleTap(float x, float y)
{
  oscP5tcpClient.send("/dtap",new Object[]{new Float(x),new Float(y)});
}

public void onTap(float x, float y)
{
  oscP5tcpClient.send("/tap",new Object[]{new Float(x),new Float(y)});
}

public void onLongPress(float x, float y)
{
  oscP5tcpClient.send("/lpress",new Object[]{new Float(x),new Float(y)});
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
public void onFlick( float x, float y, float px, float py, float v)
{
  oscP5tcpClient.send("/flick",new Object[]{new Float(x),new Float(y),new Float(px),new Float(py),new Float(v)});
}

public void onPinch(float x, float y, float d)
{
  oscP5tcpClient.send("/pinch",new Object[]{new Float(x),new Float(y),new Float(d)});
}

public void onRotate(float x, float y, float ang)
{
  oscP5tcpClient.send("/rotate",new Object[]{new Float(x),new Float(y),new Float(ang)});
}

//pointer local
public void mousePressed(){
  //
  if(sync){
    if(sizeX < sizeY){
        //-
        if((mouseX > (sizeX*0.2f - sizeX*0.1f))&&
          (mouseX < (sizeX*0.2f + sizeX*0.1f))&&
          (mouseY > (sizeX*0.2f - sizeX*0.1f))&&
          (mouseY < (sizeX*0.2f + sizeX*0.1f))){
        
          if(id > 0) id--;
        //+  
        }else if((mouseX > (sizeX*0.8f - sizeX*0.1f))&&
                 (mouseX < (sizeX*0.8f + sizeX*0.1f))&&
                 (mouseY > (sizeX*0.2f - sizeX*0.1f))&&
                 (mouseY < (sizeX*0.2f + sizeX*0.1f))){
            
          if(id < 250) id++;
        //osc  
        }else if((mouseX > (sizeX/2 - sizeX*0.8f))&&
                 (mouseX < (sizeX/2 + sizeX*0.8f))&&
                 (mouseY > (sizeY/2 - sizeX*0.8f))&&
                 (mouseY < (sizeY/2 + sizeX*0.8f))){
          
                 
          oscP5tcpClient = new OscP5(this, ServerAddress, 11000, OscP5.TCP);         
          delay(1);
          oscP5tcpClient.send("/start", new Object[]{new Integer(id),new Float(sizeX),new Float(sizeY),
                                                      new Float(originX),new Float(originY), new Boolean(portrait)});
          
        }      
      }else{
        //-
        if((mouseX > (sizeY*0.2f - sizeY*0.1f))&&
          (mouseX < (sizeY*0.2f + sizeY*0.1f))&&
          (mouseY > (sizeY*0.2f - sizeY*0.1f))&&
          (mouseY < (sizeY*0.2f + sizeY*0.1f))){
        
          if(id > 0) id--;
        //+  
        }else if((mouseX > (sizeY*0.8f - sizeY*0.1f))&&
                 (mouseX < (sizeY*0.8f + sizeY*0.1f))&&
                 (mouseY > (sizeY*0.2f - sizeY*0.1f))&&
                 (mouseY < (sizeY*0.2f + sizeY*0.1f))){
            
          if(id < 250) id++;
        //osc  
        }else if((mouseX > (sizeX/2 - sizeY*0.8f))&&
                 (mouseX < (sizeX/2 - sizeY*0.8f))&&
                 (mouseY > (sizeY/2 - sizeY*0.8f))&&
                 (mouseY < (sizeY/2 - sizeY*0.8f))){
                   
          oscP5tcpClient = new OscP5(this, ServerAddress, 11000, OscP5.TCP);
          oscP5tcpClient.send("/start", new Object[]{new Integer(id),new Float(sizeX),new Float(sizeY),
                                                      new Float(originX),new Float(originY), new Boolean(portrait)});
        }
      }
  }
}

//osc handler
public void oscEvent(OscMessage theMessage) {
  
 // System.out.println("### got a message " + theMessage);
  if(theMessage.checkAddrPattern("/accel")) {    
    
  }
  else if(theMessage.checkAddrPattern("/dtap")) {    
    
  }
  else if(theMessage.checkAddrPattern("/tap")) {    
    
  }
  else if(theMessage.checkAddrPattern("/lpress")) {    
    
  }
  else if(theMessage.checkAddrPattern("/flick")) {    
    
  }
  else if(theMessage.checkAddrPattern("/pinch")) {    
    
  }
  else if(theMessage.checkAddrPattern("/rotate")) {    
    
  }
  else if(theMessage.checkAddrPattern("/start")) {    
    //msg recebida do servidor, indicando que est\u00e1 conectado
    println("connected");
    sync = false;
    sensor.start();
  }

}

//surface
public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}
//cada celular deve guardar seus vizinhos 
// para que os ojetos possam ser 'tranferidos'

class Celular{

int id;
float sizeX;
float sizeY;
float originX;
float originY;
boolean portrait;


}
public abstract class Objeto{

  float x;
  float y;
  float rot; // in degrees 

  Object obj; //objeto: imagem, video, som, texto, etc

  public Objeto(float x, float y, float r){
  
    this.x = x;
    this.y = y;
    this.rot = r;    
    
  } 

  public void processa(){
    //processamento do objeto
  }  
  
  
  public void desenha(){
    //desenha objeto na tela  
  }
}

}
