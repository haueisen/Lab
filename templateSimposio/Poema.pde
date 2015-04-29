class Poema{

  private Frase[] frases;
  float ka = 0.0025; //acceleration constant multiplier
  float kv = 0.03;
  boolean dead;
  boolean dying;
  float x;
  float y;
  
  public Poema(PImage[] poem, float x, float y){
    
    this.x = x;
    this.y = y;
   
    dead = false; 
    dying = false;   
    frases = new Frase[poem.length];
    for (int i = 0; i<poem.length; i++)
    {
      frases[i]= new Frase();      
      frases[i].setMyImage(poem,i);
      frases[i].inicialPosition(x, y);
     // frases[i].vel = new PVector(0,-5 + (kv*(poem.length-i)));
     // frases[i].acc = new PVector(0, 0.01);
      frases[i].vel = new PVector(0,-1.5);
      frases[i].acc = new PVector(0, 0);
    }
  }
  
  void update(){
  for (int i = 0; i<frases.length; i++)
    {
      boolean d = true;
      if (frases[i].pos.y >= 0){
          if(i == 0 || frases[i-1].pos.y < y-20){
            //println(frases[i].pos.y +" "+ y);
            frases[i].update();
            frases[i].desenha();
            //if(i+1 == frases.length) dying = true;          
          }
        d = false;
      }
      this.dead = d;
      this.dying = d;
    }
  }
  
}
