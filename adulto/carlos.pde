void conteudoCarlos(){
  Carl_estados = new int[4];
  for(int i=0;i<4;i++) Carl_estados[i] = 0;
  Carl_audios = new String [12];
  Carl_audios [0] = "carlos1onde.mp3";
  Carl_audios [1] = "carlos1ondesele1.mp3";
  Carl_audios [2] = "carlos1poem1.mp3";
  Carl_audios [3] = "carlos2ele.mp3";
  Carl_audios [4] = "carlos2ondesele2.mp3";
  Carl_audios [5] = "carlos2poem2.mp3";
  Carl_audios [6] = "carlos3tudo.mp3";
  Carl_audios [7] = "carlos3ondesele3.mp3";
  Carl_audios [8] = "carlos3poem3.mp3";
  Carl_audios [9] = "carlos4nada.mp3";
  Carl_audios [10] = "carlos4ondesele4.mp3";
  Carl_audios [11] = "carlos4poem4.mp3";
  Carl_imgs = new PImage [16];
  Carl_imgs[0] = loadImage("carlos11.png");//?
  Carl_imgs[1] = loadImage("carlos12.png");//onde
  Carl_imgs[2] = loadImage("carlos13.png");//onde se lê
  Carl_imgs[3] = loadImage("carlos14.png");//P
  Carl_imgs[4] = loadImage("carlos21.png");//:
  Carl_imgs[5] = loadImage("carlos22.png");//se lê
  Carl_imgs[6] = loadImage("carlos23.png");//onde se lê:
  Carl_imgs[7] = loadImage("carlos24.png");//O
  Carl_imgs[8] = loadImage("carlos31.png");//!
  Carl_imgs[9] = loadImage("carlos32.png");//tudo
  Carl_imgs[10] = loadImage("carlos33.png");//onde se lê!
  Carl_imgs[11] = loadImage("carlos34.png");//E
  Carl_imgs[12] = loadImage("carlos41.png");//...
  Carl_imgs[13] = loadImage("carlos42.png");//nada
  Carl_imgs[14] = loadImage("carlos43.png");//onde se lê...
  Carl_imgs[15] = loadImage("carlos44.png");//M
}

void playCarlos(){  
  imageMode(CENTER);
  image(Carl_imgs[_tabletId*4+Carl_estados[_tabletId]],width/2,height/2);   
}

void toqueCarlos(){
  //dispara áudio
  /*
  if(Carl_estados[_tabletId] != 0){
    player.setMediaFile(Carl_audios[_tabletId*3+Carl_estados[_tabletId]-1]);
    player.start();
  }
  */
  Carl_estados[_tabletId]+=1;
  if(Carl_estados[_tabletId] > 3)
    Carl_estados[_tabletId] = 0;   
}
