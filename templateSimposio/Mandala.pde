class Mandala {

  Particle fixa;
  Particle movel;

  float len;
  // Chain constructor
  Mandala(float x, float y, float l) {
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
    djd.dampingRatio = 0.7; // Ranges between 0 and 1

    // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
    // We might need to someday, but for now it's ok
    DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
  }



  // Draw the bridge
  void display() {
    Vec2 pos1 = box2d.getBodyPixelCoord(fixa.body);
    Vec2 pos2 = box2d.getBodyPixelCoord(movel.body);
    stroke(0);
    line(pos1.x,pos1.y,pos2.x,pos2.y);

  //  fixa.display();
    movel.display();
  }
}

