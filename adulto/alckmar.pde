void conteudoAlckmar(){
  Alck_imgs = new PImage [6];
  Alck_imgs[0] = loadImage("alckmar1A.png");
  Alck_imgs[1] = loadImage("alckmar1B.png");
  Alck_imgs[2] = loadImage("alckmar2A.png");
  Alck_imgs[3] = loadImage("alckmar2B.png");
  Alck_imgs[4] = loadImage("alckmar3A.png");
  Alck_imgs[5] = loadImage("alckmar3B.png");
  Alck_palavra = new PImage [3];
  Alck_palavra[0] = loadImage("alckmar1.png");
  Alck_palavra[1] = loadImage("alckmar2.png");
  Alck_palavra[2] = loadImage("alckmar3.png");
  Alck_estados = new int[3];
  for(int i=0;i<3;i++) Alck_estados[i] = 0;
  Alck_audios = new String [6];
  Alck_audios[0] = "alck1.mp3";
  Alck_audios[1] = "alck2.mp3";
  Alck_audios[2] = "alck3.mp3";
  Alck_audios[3] = "alck4.mp3";
  Alck_audios[4] = "alck5.mp3";
  Alck_audios[5] = "alck6.mp3";  
}

void playAlckmar(){
  imageMode(CENTER);
  background(255);
  if(_tabletId != 3){
    if(Alck_estados[_tabletId] == 0){
      image(Alck_imgs[_tabletId*2+Alck_estados[_tabletId]],width/2,height/2-50);
      image(Alck_palavra[_tabletId],width/2,height/2+300);
    }
    else{      
      image(Alck_imgs[_tabletId*2+Alck_estados[_tabletId]],width/2,height/2); 
      image(Alck_palavra[_tabletId],width/2,65);     
    }
  }  
}

void toqueAlckmar(){
  /*
  //println(mouseX+" "+mouseY);
  if(Alck_estados[_tabletId] == 0 && mouseY > 685 && mouseY < 720){
    if(_tabletId != 3){
      player.setMediaFile(Alck_audios[_tabletId*2+Alck_estados[_tabletId]]);
      player.start();
      /println("cur"+//player.getCurrentPosition());
      println("dur"+//player.getDuration());
      if(player.getCurrentPosition() >= player.getDuration())
          Alck_estados[_tabletId] = 1;
    }
  }
  else{
    if(Alck_estados[_tabletId] == 1 && mouseY > 50 && mouseY < 85){
        player.setMediaFile(Alck_audios[_tabletId*2+Alck_estados[_tabletId]]);
        player.start();
        if(//player.getCurrentPosition() >= player.getDuration())
            Alck_estados[_tabletId] = 0;    
    }
  }*/
}
