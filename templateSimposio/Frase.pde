/*          Class Dandelion
 *  Creates particle animation
 *  Created by 
 */

class Frase {

  PVector pos;
  PVector vel;
  PVector acc;
  PImage myImage;
  float rot;

  //Constructor
  Frase() {
    pos = new PVector(0, 2000);   // Inicial Position
    vel = new PVector(random(-0.3, 0.3), -6);    // Velocity
    acc = new PVector(0, 0.1);  // Acceleration
    rot = random(-1, 1);
  }

  //PUBLIC METHODS

  void setMyImage(PImage i) {
    myImage = i;
  }

  void inicialPosition(float x, float y) {
    pos.x = x;
    pos.y = y;
  }

  void update() {

    
      pos.x = pos.x + vel.x;
      pos.y = pos.y + vel.y;
      vel.x = vel.x +  acc.x;
      vel.y = vel.y +  acc.y;
      pushMatrix();
      resetMatrix();
      imageMode(CENTER);
      translate(pos.x, pos.y);
      rotate(rot*PI/16);
      image(myImage, 0, 0);
      //text("Alguma coisa!!!", 0, 0);
      popMatrix();
  }
}

