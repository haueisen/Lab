public class Circulo extends Objeto{

  public Circulo(int id, float x, float y, float r){
     super(id,x,y,0);
     this.radius = r;
     this.obj = "Circulo";
  } 

  public void processa(){
    //processamento do objeto
    this.x += 1;
  }  
  
  
  public void desenha(){
    //desenha objeto na tela
    fill(0,200,200);
    stroke(0);
    strokeWeight(2);
    ellipseMode(RADIUS);
    ellipse(x,y,radius,radius);  
  }
}
