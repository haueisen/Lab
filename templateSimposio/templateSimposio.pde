import android.view.MotionEvent;

import oscP5.*;
import netP5.*;

import ketai.camera.*;
import ketai.net.*;
import ketai.ui.*;
import ketai.sensors.*;
import ketai.data.*;

import apwidgets.*;


OscP5 oscP5tcpClient;
KetaiSensor sensor;
KetaiGesture gesture;
  
String ServerAddress = "192.168.1.101";


void setup(){
  sensor = new KetaiSensor(this);
  sensor.start();
  
  gesture = new KetaiGesture(this);

  
  //size(displayWidth,displayHeight);
  orientation(LANDSCAPE);  

  oscP5tcpClient = new OscP5(this, ServerAddress, 11000, OscP5.TCP);

}

void draw(){
background(200);
}

//eventos
//acelerometro
void onAccelerometerEvent(float x, float y, float z)
{
  oscP5tcpClient.send("/accel",new Object[]{new Float(x),new Float(y),new Float(z)});
}
//gestos

void onDoubleTap(float x, float y)
{
  oscP5tcpClient.send("/dtap",new Object[]{new Float(x),new Float(y)});
}

void onTap(float x, float y)
{
  oscP5tcpClient.send("/tap",new Object[]{new Float(x),new Float(y)});
}

void onLongPress(float x, float y)
{
  oscP5tcpClient.send("/lpress",new Object[]{new Float(x),new Float(y)});
}

//the coordinates of the start of the gesture, 
//     end of gesture and velocity in pixels/sec
void onFlick( float x, float y, float px, float py, float v)
{
  oscP5tcpClient.send("/flick",new Object[]{new Float(x),new Float(y),new Float(px),new Float(py),new Float(v)});
}

void onPinch(float x, float y, float d)
{
  oscP5tcpClient.send("/pinch",new Object[]{new Float(x),new Float(y),new Float(d)});
}

void onRotate(float x, float y, float ang)
{
  oscP5tcpClient.send("/rotate",new Object[]{new Float(x),new Float(y),new Float(ang)});
}

//osc handler
void oscEvent(OscMessage theMessage) {
  
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
}

//surface
public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}
