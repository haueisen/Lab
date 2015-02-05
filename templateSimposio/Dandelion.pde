/*          Class Dandelion
 *  Creates a dandelion flower 
 *  PUBLIC METHODS: Born, isAlive, isGrowing, isColliding, choosenPoem, rendFlower
 *  Created by Marilia Bergamo (UFMG-MG)
 *  Ilustrations: Mariângela Haddad (Artista-BH)
 */

class Dandelion { 

  // Private properties
  private float xpos, ypos, angle, jitter, transitions; 
  private boolean alive, dying, growing;
  private PImage myStalk, myTop;
  private PImage[] stalk, top;
  private int raffle, myStalkH, myStalkW, myTopH, myTopW, stageH, stageW, localFramerate, topAjust, collisionRadio, chosenPoem;

  private Frase[] frases;
  private int verseNumber=10;

  // Public properties
  public int NumberOfPoems;
  public boolean poemChosed;
  public float myTopXCenter, myTopYCenter;

  // Constructor 
  Dandelion() {  

    //Ajust top and stalk
    this.topAjust = 5;

    // Collision Radio value em pixels
    this.collisionRadio = 60; 

    frases = new Frase[40];
    for (int i = 0; i<40; i++)
    {
      frases[i]= new Frase();
    }

    //Load Images
    this.loadImages();
  } 

  //PUBLIC METHODS

  void born(int h, int w, int b, int f, int n) {

    //h: stage height
    //w: stage width
    //b: stage border
    //f: stage framerate
    //n: number of poems
    this.xpos = int(random(b, w-b));
    this.raffle = int(random(0, 4));
    this.stageH = h;
    this.stageW = w;  
    this.transitions = f;
    this.localFramerate = f;
    this.NumberOfPoems = n;

    //Redefine Flower
    this.alive = true; 
    this.dying = false;
    this.growing = true;
    this.poemChosed = false;

    //Choose stalk
    this.myStalk = this.stalk[raffle];

    //Choose top
    this.myTop = this.top[raffle];

    // Define Height and Width of Stalk
    this.myStalkH = this.myStalk.height;
    this.myStalkW = this.myTop.width;
    // Define Height and Width of Top
    this.myTopH = this.myTop.height;
    this.myTopW = this.myTop.width;

    // Define y position based on the end of a stalk
    this.ypos = int(this.stageH-this.myStalkH);

    //Top center
    this.myTopXCenter = this.xpos+this.myTopW/2;
    this.myTopYCenter = this.ypos+this.myTopH/this.topAjust;
  } 

  boolean isAlive() {
    return this.alive;
  }

  boolean isGrowing() {
    return this.growing;
  }

  boolean isColliding(int x, int y) {
    int topCenterXCollisionHigh =  int((this.xpos+this.myTopW/2)+this.collisionRadio);
    int topCenterXCollisionLow = int((this.xpos+this.myTopW/2)-this.collisionRadio);
    int topCenterYCollisionHigh =  int(this.ypos+this.myTopH/this.topAjust+this.collisionRadio);
    int topCenterYCollisionLow =  int(this.ypos+this.myTopH/this.topAjust-this.collisionRadio);
    // Check Collision
    if ((x <= topCenterXCollisionHigh)&&(x >= topCenterXCollisionLow)&&(y >= topCenterYCollisionLow)&&(y <= topCenterYCollisionHigh)) {
      // ellipse(this.xpos+this.myTopW/2, this.ypos+this.myTopH/this.topAjust, this.collisionRadio, this.collisionRadio); // Uncomment to debug collisionRadio
      if (!dying)
      {
        chosenPoem = (int)floor(random(0, 5));
        if (chosenPoem == 0)
        {
          for (int i = 0; i<poemA.length; i++)
          {
            verseNumber = poemA.length;
            frases[i] = new Frase();
            frases[i].setMyImage(poemA[i]);
            frases[i].inicialPosition(xpos+myTop.width/2, ypos+myTop.height/2);
            frases[i].acc = new PVector(0, 0.01+(0.001*(poemA.length-i)));
          }
        } else if (chosenPoem == 1)
        {
          verseNumber = poemB.length;
          for (int i = 0; i<poemB.length; i++)
          {
            verseNumber = poemB.length;
            frases[i] = new Frase();
            frases[i].setMyImage(poemB[i]);
            frases[i].inicialPosition(xpos+myTop.width/2, ypos+myTop.height/2);
            frases[i].acc = new PVector(0, 0.01+(0.001*(poemB.length-i)));
          }
        } else if (chosenPoem == 2)
        {
          verseNumber = poemC.length;
          for (int i = 0; i<poemC.length; i++)
          {
            verseNumber = poemC.length;
            frases[i] = new Frase();
            frases[i].setMyImage(poemC[i]);
            frases[i].inicialPosition(xpos+myTop.width/2, ypos+myTop.height/2);
            frases[i].acc = new PVector(0, 0.01+(0.001*(poemC.length-i)));
          }
        } else if (chosenPoem == 3)
        {

          verseNumber = poemD.length;
          for (int i = 0; i<poemD.length; i++)
          {
            verseNumber = poemD.length;
            frases[i] = new Frase();
            frases[i].setMyImage(poemD[i]);
            frases[i].inicialPosition(xpos+myTop.width/2, ypos+myTop.height/2);
            frases[i].acc = new PVector(0, 0.01+(0.001*(poemD.length-i)));
          }
        } else if (chosenPoem == 4)
        {
          verseNumber = poemE.length;
          for (int i = 0; i<poemE.length; i++)
          {
            verseNumber = poemE.length;
            frases[i] = new Frase();
            frases[i].setMyImage(poemE[i]);
            frases[i].inicialPosition(xpos+myTop.width/2, ypos+myTop.height/2);
            frases[i].acc = new PVector(0, 0.01+(0.001*(poemE.length-i)));
          }
        } else if (chosenPoem == 5)
        {
          verseNumber = poemF.length;
          for (int i = 0; i<poemF.length; i++)
          {
            verseNumber = poemF.length;
            frases[i] = new Frase();
            frases[i].setMyImage(poemF[i]);
            frases[i].inicialPosition(xpos+myTop.width/2, ypos+myTop.height/2);
            frases[i].acc = new PVector(0, 0.01+(0.001*(poemF.length-i)));
          }
        }
      }


      this.dying = true;
      return true;
    } else {
      return false;
    }
  }

  int poemChosen() {
    return this.chosenPoem;
  }


  void rendPoem()
  {
    for (int i = 0; i<frases.length; i++)
    {
      if (frases[i].pos.y<=height-30)
        frases[i].update();
    }
  }

  void rendFlower() {
    imageMode(CORNER);
    int pSH = int(this.myStalkH/this.localFramerate); // stalk proportion Height
    int pSW = int(this.myStalkW/this.localFramerate); // stalk proportion Width
    int pTH = int(this.myTopH/this.localFramerate);  // top proportion Height 
    int pTW = int(this.myTopW/this.localFramerate);  // top proportion Width 
    int pAlpha = int(255/this.localFramerate);  // alpha proportion 

    //Check state
    if (this.growing) { 
      if (this.transitions > 0) {
        image(this.myStalk, this.xpos, (this.ypos+(this.transitions*pSH)), this.myStalkW-(this.transitions*pSW), this.myStalkH-(this.transitions*pSH)); 
        image(this.myTop, this.xpos, (this.ypos+(this.transitions*pSH))-(this.myTopH/this.topAjust)+this.topAjust, this.myTopW-(this.transitions*pTW), this. myTopH-(this.transitions*pTH));
        this.transitions -= 2; // Animation speed
      } else {
        this.growing = false;
        this.shakeTop();
        this.transitions = this.localFramerate;
      }
    } else if (!this.dying) {
      this.shakeTop();
    } else {
        die();
    }
  }

  //PRIVATE METHODS

  private void die() {
    this.alive = false;
    this.poemChosed = false;
  }

  private void choosePoem(int a) {
    //no final transforma dying em true
    this.chosenPoem = int(random(0, a)); // Random choose one of the poems
  }

  private void shakeTop() {
    image(this.myStalk, this.xpos, this.ypos);
    int topXCenter = int(this.xpos+this.myTopW/2);
    int topYCenter = int(this.ypos+this.myTopH/this.topAjust);
    if (second() % 1 == 0) {  
      jitter = random(-0.1, 0.1);
    }
    this.angle = this.angle + this.jitter;
    float c = cos(this.angle);
    pushMatrix();
    translate(topXCenter, topYCenter);
    rotate(c);
    translate(-this.myTopW/2, -this.myTopH/2);
    image(this.myTop, 0, 0);
    popMatrix();
  }

  private void loadImages() {
    //Array of stalks
    this.stalk = new PImage[4];
    this.stalk[0] = loadImage("caule1.PNG");
    this.stalk[1] = loadImage("caule2.PNG");
    this.stalk[2] = loadImage("caule3.PNG");
    this.stalk[3] = loadImage("caule4.PNG");

    //Array of Tops
    this.top = new PImage[4];
    this.top[0] = loadImage("topo1.PNG");
    this.top[1] = loadImage("topo2.PNG");
    this.top[2] = loadImage("topo3.PNG");
    this.top[3] = loadImage("topo4.PNG");
  }
} 

