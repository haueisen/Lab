public class Vagalume extends Objeto{
  
  float ax, ay;
  
  public Vagalume(int id, float r){
     super(id,random(0,sizeX),random(0,sizeY),0);
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
    
    if((x > sizeX*0.95) || (x < sizeX*0.05)){
      x = x + vx;
      y = y + vy;
    }else{    
      //atualiza pos
      vx = vx + ax;
      vy = vy + ay;
  
      x = x + vx;
      y = y + vy;
  
      ax = ax*0.5;
      ay = ay*0.5;
  
      vx = vx * 0.98;
      vy = vy * 0.98;
  
      vx = vx + random(-1,1)*noise(x/1000);
      vy = vy + random(-1,1)*noise(y/1000);
      
      //voa grupo
      atrator();
      atrator(sizeX/2,sizeY/2);        
    }
  }  
  
  void atrator(float x, float y) {
    ax = ax + (x - this.x)/10000.0;
    ay = ay + (y - this.y)/10000.0;
  }
  
  void atrator() {  
    atrator(map(accelX,-5,5,0,sizeX), random(0,sizeY));
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
    rotate(random(-0.5,0.5));
    ellipse(12,0, 8,8);
    rotate(random(-0.5,0.5));
    ellipse(-12,0, 8,8);
    popMatrix();    
  }
}
