public abstract class Objeto{

  float x;
  float y;
  float rot; // in degrees 

  Object obj; //objeto: imagem, video, som, texto, etc

  public Objeto(float x, float y, float r){
  
    this.x = x;
    this.y = y;
    this.rot = r;    
    
  } 

  public void processa(){
    //processamento do objeto
  }  
  
  
  public void desenha(){
    //desenha objeto na tela  
  }
}
