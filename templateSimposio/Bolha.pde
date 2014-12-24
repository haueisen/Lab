public class Bolha extends Objeto {

  
  
  Bolha(int id, float posX, float posY, float raio, float _hue, float _vx, float _vy, int _qualImagem) {
    super(id, posX, posY, 0);
    this.obj = "Bolha";    
    this.vx = _vx;
    this.vy = _vy;
    this.radius = raio;    
    gravidade= -0.002;
    qualImagem = _qualImagem;
    hue = _hue;
  }

  public void processa() {
    //processamento do objeto
    x =x + vx;
    y =y + vy;
    vx = vx +vento;
    vy =vy+ gravidade;
  }  


  public void desenha() {
    colorMode(HSB);
    strokeWeight(2);
    fill(hue, 255, 255, 40);
    stroke(255);
    imageMode(CENTER);
    //println(imagemLinha);
    image(imagemLinha[qualImagem], x, y, radius, radius);
    ellipse(x, y, radius, radius);
    imageMode(CORNER);
  }

  float tempoVida() {
    float vida;
    vida = random(5, 40); 
    return vida;
  }

  void movimento(float _vento) {
    x =x+vx;
    y =y +vy;
    vx = vx +vento;
    vy =vy+ gravidade;
  }
}
