public class Circulo extends Objeto{

  ArrayList<PImage> quadros;//trocar para array
  int nextFrame;
    
  public Circulo(int id, float x, float y, float r){
     super(id,x,y,0);
     this.radius = r;
     this.obj = "Circulo";
     
     quadros = new ArrayList<PImage>();
     nextFrame = 0;
  } 

  public void processa(){
    //processamento do objeto
    if(portrait){
      this.y += 1;
    }else{
      this.x += 1;      
    }  
  }  
  
  
  public void desenha(){
    //desenha objeto na tela
    if(quadros.size() > 0){
      //desenha quadro
      PImage frame = quadros.get(nextFrame); 
      image(frame,x - frame.width/2,y - frame.height/2); 
    }else{
      fill(0,200,200);
      stroke(0);
      strokeWeight(2);
      ellipseMode(RADIUS);
      ellipse(x,y,radius,radius);
    }      
  }
}
