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

  void desenhaCatavento() {
    pushMatrix();
    resetMatrix();
    imageMode(CENTER);
    translate(x, y);
    rotate(-rot);
    image(catavento, 0, 0);
    popMatrix();
  }

  void cinematicaCatavento( float vRot ) {

    rot = rot+ PI/vRot*atrito;
  }

  void setaAtritoCatavento(float t, float div) {
    atrito = t/div;
  }
}

