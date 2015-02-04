

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  color col;
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
        if(p < 0.7){
          img = int(random(0,6));
        }else{
          img = int(random(7,27));
        }        
        break;
      case 1://azul
        if(p < 0.7){
          img = int(random(7,13));
        }else{
          if(random(0,1) < 0.66)
            img = int(random(14,27));
          else
             img = int(random(0,6));
        }
        break;          
      case 2://verde
        if(p < 0.7){
          img = int(random(14,20));
        }else{
          if(random(0,1) < 0.66)
            img = int(random(0,13));
          else
            img = int(random(21,27));
        }
        break;
      case 3://vermelho
        if(p < 0.7){
          img = int(random(21,27));
        }else{
          img = int(random(0,20));
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
    fd.density = 0.9;
    fd.friction = 0.01;
    fd.restitution = 0.5;

    // Attach fixture to body
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setUserData(this);
    col = color(175);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
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
      image(mandalas[img], 0, 0);  
      //fill(col);
      //stroke(0);
      //strokeWeight(1);
      //ellipse(0,0,r*2,r*2);
      // Let's add a line so we can see the rotation
      //line(0,0,r,0);
      popMatrix();
    }
  }


  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  void beginCol() {
    col = color(255, 0, 0);
  }

  void endCol() {
    col = color(175);
  }
}

