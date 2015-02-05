void conteudoAlvaro(){
  Alv_poema = new String [5];
  Alv_poema[0] = "um";
  Alv_poema[1] = "corta";
  Alv_poema[2] = "capina";
  Alv_poema[3] = "renova";
  Alv_poema[4] = "outro";
  Alv_gif_capina= new IMGAnimation("capina#.png", 8, 1,false);  
}

void playAlvaro(){
  switch (_tabletId){
    case 0:      
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_tocaCapina && Alv_poema[0] == "capina"){
        imageMode(CENTER);
        image(Alv_gif_capina.getFrame(255),width/2+Alv_shift+Alv_nasc,height/2);
      }
      else{        
        text(Alv_poema[0],width/2+Alv_shift+Alv_nasc,height/2);
        textAlign(CENTER, CENTER);
        fill(cor);
      }
      break;
    case 1:
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_tocaCapina && Alv_poema[1] == "capina"){
        imageMode(CENTER);
        image(Alv_gif_capina.getFrame(255),width/2+Alv_shift+Alv_nasc,height/2);             
      }
      else{
        text(Alv_poema[1],width/2+Alv_shift+Alv_nasc,height/2);        
        textAlign(CENTER, CENTER);
        fill(cor);
      }
      break;
    case 2:
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_tocaCapina && Alv_poema[2] == "capina"){
        imageMode(CENTER);
        image(Alv_gif_capina.getFrame(255),width/2+Alv_shift+Alv_nasc,height/2);            
      }
      else{
        text(Alv_poema[2],width/2+Alv_shift+Alv_nasc,height/2);        
        textAlign(CENTER, CENTER);
        fill(cor);
      }
      break;
    case 3:
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_tocaCapina && Alv_poema[3] == "capina"){
        imageMode(CENTER);
        image(Alv_gif_capina.getFrame(255),width/2+Alv_shift+Alv_nasc,height/2);        
      }
      else{
        text(Alv_poema[3],width/2+Alv_shift+Alv_nasc,height/2);        
        textAlign(CENTER, CENTER);
        fill(cor);
      }
      break;      
  }
  if(Alv_direcaoDirParaEsq){    
    Alv_shift -= Alv_velocidade*vel;    
  }
  else{
    Alv_shift += Alv_velocidade*vel;    
  }  
  if(Alv_shift < -1280-Alv_nasc){
    Alv_shift = 0;
    Alv_nasc = +1000;
    String prim = Alv_poema[0];
    Alv_poema[0] = Alv_poema[1];
    Alv_poema[1] = Alv_poema[2];
    Alv_poema[2] = Alv_poema[3];
    Alv_poema[3] = Alv_poema[4];
    Alv_poema[4] = prim;    
  }
  if(Alv_shift > 1280-Alv_nasc){
    Alv_shift = 0;
    Alv_nasc = -1000;
    String prim = Alv_poema[4];
    Alv_poema[4] = Alv_poema[3];
    Alv_poema[3] = Alv_poema[2];
    Alv_poema[2] = Alv_poema[1];
    Alv_poema[1] = Alv_poema[0];
    Alv_poema[0] = prim;
  }
  if(Alv_tocaCapina && Alv_gif_capina.currentFrame() == 7){
    Alv_tocaCapina = false;
    Alv_gif_capina.setCurrentFrame(0);
  }
}

void toqueAlvaro(){
  if(Alv_poema[_tabletId] == "um"){
    for(int i=0; i<5;i++){
      if(Alv_poema[i] == "outro"){
        Alv_poema[_tabletId] = "outro";
        Alv_poema[i] = "um";
        break;
      }
    }        
    //player.setMediaFile("alv1_um.mp3");
    //player.start();   
  }
  else{
    if(Alv_poema[_tabletId] == "corta"){
      for(int i=0; i<5;i++){
        if(Alv_poema[i] == "renova"){
          Alv_poema[_tabletId] = "renova";
          Alv_poema[i] = "corta";
          break;
        }
      }
      //player.setMediaFile("alv2_corta.mp3");
      //player.start();   
    }
    else{
      if(Alv_poema[_tabletId] == "capina"){
        Alv_tocaCapina = true;  
        //player.setMediaFile("alv3_capina.mp3");
        //player.start();          
      }
      else{              
        if(Alv_poema[_tabletId] == "renova"){
          for(int i=0; i<5;i++){
            if(Alv_poema[i] == "corta"){
              Alv_poema[_tabletId] = "corta";
              Alv_poema[i] = "renova";
              break;
            }
          }
          //player.setMediaFile("alv4_renova.mp3");
          //player.start();   
        }
        else{
          if(Alv_poema[_tabletId] == "outro"){
            for(int i=0; i<5;i++){
              if(Alv_poema[i] == "um"){
                Alv_poema[_tabletId] = "um";
                Alv_poema[i] = "outro";
                break;
              }
            }
            //player.setMediaFile("alv5_outro.mp3");
            //player.start();   
          }
        }
      }
    }
  }
  if(Alv_direcaoDirParaEsq)   Alv_direcaoDirParaEsq = false;
  else Alv_direcaoDirParaEsq = true;
}

