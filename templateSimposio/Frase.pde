
class Frase {

  PVector pos;
  PVector vel;
  PVector acc;
  PImage myImage;
  int imageIndex;
  //int poem;
  PImage[] poem;
  float rot;
  float maxFallVelocity = 1;
  
  //Constructor
  Frase() {
    pos = new PVector(0, 0);   // Inicial Position
    vel = new PVector(0, -6.3);    // Velocity
    acc = new PVector(0, 0);  // Acceleration
    rot = random(-0.2, 0.2);
  }

  //PUBLIC METHODS

  void setMyImage(PImage i) {
    this.myImage = i;
  }
  void setMyImage(PImage[] poema, int image) {
    imageIndex = image;
    poem = poema;
  }

  void inicialPosition(float x, float y) {
    pos.x = x;
    pos.y = y;
  }

  void update() {
    
      pos.x = pos.x + vel.x;
      pos.y = pos.y + vel.y;
      if(vel.y < maxFallVelocity){
        vel.x = vel.x +  acc.x;
        vel.y = vel.y +  acc.y;
      }     
 
  }
  
  void desenha(){       
      pushMatrix();
      resetMatrix();
      imageMode(CENTER);
      translate(pos.x, pos.y);
      rotate(rot*PI/16);
      if (vagalume != null) {
        if (!vagalume.ligado)
          tint(0);
        else
          noTint();
      }else{
       tint(0);
      }
      image(poem[imageIndex],0,0);
      noTint();
      //text("Alguma coisa!!!", 0, 0);
      popMatrix();
  }
}

