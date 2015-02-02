public class Abelha extends Objeto {

  float ax, ay;
  color ligad = color(0, 255, 0);
  color desligado = color(0, 0, 0);
  boolean ligado = false;

  PImage[] quadros = new PImage[3];

  int quadro = 0;

  
  public Abelha(int id, float x, float y, float vx, float vy, float r) {
    super(id, x, y, 0);

    //println("Abelha: "+id+" "+x+" "+y);

    this.vx = vx;
    this.vy = vy;

    this.obj = "Abelha";
    this.radius = r;
    
    quadros[0] = loadImage("abelha1.png");
    quadros[1] = loadImage("abelha2.png");
    quadros[2] = loadImage("abelha3.png");
  }

  public void processa() {
    //processamento do objeto
    // println(x+" "+y);
    this.x += vx;
    quadro = (quadro + 1) % 3;
  } 

  public void desenha() {
    //desenha objeto na tela

    
   // pushMatrix();
   // resetMatrix();
   // translate(x, y);
    imageMode(CENTER);
    //stroke(0);
    image(quadros[0], x, y,2*radius,2*radius);    
   // popMatrix();
  }
}

