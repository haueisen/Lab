package processing.test.templatesimposio;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
  esperandoID = new ArrayList<Objeto>();
  remove = new ArrayList<Integer>();
  nextId = 0;
}

public void draw() {
  // print(sync);
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
    background(200);    

    while (_client.numMessages () > 0) {
      //print(_client.numMessages());
      JSONObject j = _client.getNextMessage();
      processMessage(j);
    }
    //AQUI bug multiplicacao
    for (Objeto o : objetos) {
      o.processa();      
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
      if (((o.y + o.radius) < sizeY)||((o.y - o.radius) > 0)) {
        //objeto recebido, removendo o status de replicado
        if(o.recebido) o.replicado = false;
        o.recebido = false;        
      }
      //objeto fora da tela
      if (((o.y - o.radius) >= sizeY)||((o.y + o.radius) <= 0)) {        
        if (!o.recebido) {
          //println("remove");
          remove.add(0, objetos.indexOf(o));
        }
      } else {      
        o.desenha();
      }
    }
    for (Objeto r : replicados) {      
      if (_client.isConnected()) {
        JSONObject j = new JSONObject();
        j.setString("ac", "objeto");
        if (r.obj == "Circulo") {
          j.setString("Objeto", "Circulo");
          if (r.y < sizeY/2) {
            //j.setInt("para", (id - 1) % 2);
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
          if (r.y < sizeY/2) {
            //j.setInt("para", (id - 1) % 2);
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
          j.setFloat("raio", r.radius);
        }
        _client.sendJSON(j);
      }
    }
    replicados.clear();
    
    for (Integer i : remove) {
      objetos.remove(i.intValue());
    }

    remove.clear();
  }
}

//eventos
//acelerometro
public void onAccelerometerEvent(float x, float y, float z)
{
  accelX = x;
  accelY = y;
}

//gestos
public void onTap(float x, float y)
{
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
public void onFlick( float x, float y, float px, float py, float v)
{
}


public void connect() {
  _client = new JSONTCPClient("192.168.0.122", 8765);       

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

//json handler
public void processMessage(JSONObject msg) {

  // println(msg);
  String ac = msg.getString("ac");
  if (ac.equals("objeto")) {
    String objeto = msg.getString("Objeto");
    if (objeto.equals("Circulo")) {
      int id = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float r = msg.getFloat("raio");
      objetos.add(new Circulo(id, x, y, r));
    } else if (objeto.equals("Vagalume")) {
      int id = msg.getInt("ID");
      float x = msg.getFloat("x");
      float y = msg.getFloat("y");
      float vx = msg.getFloat("vx");
      float vy = msg.getFloat("vy");
      float r = msg.getFloat("raio");
      objetos.add(new Vagalume(id, x, y, vx, vy, r));
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
public @Override
void onPause() {
  super.onPause();
  this.finish();
}

public class Circulo extends Objeto{

  public Circulo(int id, float x, float y, float r){
     super(id,x,y,0);
     this.radius = r;
     this.obj = "Circulo";
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
    fill(0,200,200);
    stroke(0);
    strokeWeight(2);
    ellipseMode(RADIUS);
    ellipse(x,y,radius,radius);  
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
public class Vagalume extends Objeto{
  
  float ax, ay;
  
  public Vagalume(int id, float r){
     super(id,random(sizeX*0.1f,sizeX*0.9f),random(sizeY*0.1f,sizeY*0.9f),0);
     this.radius = r;
     
     vx = random(-3,3);
     vy = random(-3,3);
     
     this.obj = "Vagalume";
  } 
  
  public Vagalume(int id, float x, float y, float vx, float vy, float r){
    super(id,x,y,0);
    this.radius = r;
     
    this.vx = vx;
    this.vy = vy;
     
    this.obj = "Vagalume";
  }

  public void processa(){
    //processamento do objeto
    
    if((y > sizeY*0.95f) || (y < sizeY*0.05f)){
      x = x + vx;
      y = y + vy;
    }else{    
      //atualiza pos
      vx = vx + ax;
      vy = vy + ay;
  
      x = x + vx;
      y = y + vy;
  
      ax = ax*0.5f;
      ay = ay*0.5f;
  
      vx = vx * 0.98f;
      vy = vy * 0.98f;
  
      vx = vx + random(-1,1)*noise(x/1000);
      vy = vy + random(-1,1)*noise(y/1000);
      
      //voa grupo
      atrator();
      atrator(sizeX/2,sizeY/2);        
    }
  }  
  
  public void atrator(float x, float y) {
    ax = ax + (x - this.x)/10000.0f;
    ay = ay + (y - this.y)/10000.0f;
  }
  
  public void atrator() {  
    atrator(random(0,sizeX),map(accelY,-4,4,0,sizeY));
  }
  
  
  public void desenha(){
    //desenha objeto na tela
    
    ellipseMode(CENTER);
    pushMatrix();
    resetMatrix();
    translate(x,y);
    fill(0,0,0);
    ellipse(0, 0, 20,20);       
    fill(255,255,255);
    rotate(random(-0.5f,0.5f));
    ellipse(12,0, 8,8);
    rotate(random(-0.5f,0.5f));
    ellipse(-12,0, 8,8);
    popMatrix();    
  }
}

}
