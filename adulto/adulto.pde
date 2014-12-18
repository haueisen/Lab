//Oficina Adultos

import apwidgets.*;
//APMediaplayer [] players;
APMediaPlayer player;
APMediaPlayer playerTrilhas;

int instalacaoAtual = 0;
int _tabletId = 0;

//controle remoto
//id tablet sendo alterado
int alteraTabletIt = -1;
//tamanho da fonte do texto (se houver)
int tamanhoTexto = 1;
//cor da fonte do texto (se houver)
color cor = color(0, 0, 0);
//velocidade de transicao de elementos (se houver)
float vel = 1.0;
//angulo de rotacao no eixo x 
float x_rotacao = 0.0;
//angulo de rotacao no eixo y 
float y_rotacao = 0.0;
//grau do zoom 
float rescale = 1.0;

//Rogério
String [] Rog_sujeito;
String [] Rog_predicado;
IMGAnimation Rog_conector1;
IMGAnimation Rog_conector2;
PImage Rog_fundo;
StringList Rog_misturaSuj;
StringList Rog_misturaPred;
StringList  Rog_audios;
int Rog_local = -1; //0=que, 1=suj, 2=pred
String Rog_save;

//Álvaro
String [] Alv_poema;
IMGAnimation Alv_gif_capina;
//Gif Alv_gif_capina;
//String [] Alv_audios;
float Alv_shift = 0.0;
float Alv_velocidade = 1.0;
boolean Alv_direcaoDirParaEsq = true; 
boolean Alv_tocaCapina = false;
float Alv_nasc = 0.0;

//Carlos Augusto
int [] Carl_estados;
PImage [] Carl_imgs;
String [] Carl_audios;

//Alckmar
PImage [] Alck_imgs;
PImage [] Alck_palavra;
int [] Alck_estados;
String [] Alck_audios;

//Pablo
String [] Pabl_versos;
int [] Pabl_ordem;
float Pabl_apagar = 255;
float Pabl_tamVerso6 = 1;
float Pabl_shiftBolha = 0;
float Pabl_shiftBolha2 = 0;
float Pabl_shiftBolha3 = 0;
float Pabl_shiftAnda = 0;
boolean Pabl_paraDireita = true;
float Pabl_shiftAnda2 = 0;
boolean Pabl_paraCima = true;

void setup(){
  size(1280, 800);
  //size(displayWidth, displayHeight);  
  background(255);
  frameRate(100);
  player = new APMediaPlayer(this); //create new APMedia player
  playerTrilhas = new APMediaPlayer(this); //create new APMedia player
  player.setVolume(1.0, 1.0);
  playerTrilhas.setVolume(0.1, 0.1);
  playerTrilhas.setLooping(true);
  //carrega conteúdos
  conteudoRogerio();  
  conteudoAlvaro();
  conteudoCarlos();  
  conteudoAlckmar();    
  conteudoPablo();
  playerTrilhas.setMediaFile("Rogerio.mp3");
  playerTrilhas.start(); 
}

void draw(){
  //inicialização da parte do servidor
  //manda "hi" pra ele com id
  //supondo ids inteiros de 0-3
  // temporizador ou voz acima de threshold troca conteúdo
  switch(instalacaoAtual){
    case 0://rogerio     
      playRogerio();
      break;
    case 1://alvaro
      playAlvaro();
      break;
    case 2://carlos      
      playCarlos();
      break;
    case 3://alckmar
      playAlckmar();
      break;
    case 4://pablo
      playPablo();
      break;   
  } 
  //print(instalacaoAtual);
}

void mousePressed(){
  switch(instalacaoAtual){
    case 0://rogerio    
      if(mouseX >250 && mouseX < 400 && mouseY > 210 && mouseY < 250){
        Rog_local = 1;
        Rog_save = Rog_sujeito[_tabletId*4];
        Rog_sujeito[_tabletId*4] = "0";
        for(int i=0; i<16; i++){
          Rog_misturaSuj.append(Rog_sujeito[i]);          
          Rog_misturaPred.append(Rog_predicado[i]);          
        }
        Rog_misturaSuj.shuffle();
        Rog_misturaPred.shuffle();
        for(int i=0;i<16;i++){
          Rog_sujeito[i] = Rog_misturaSuj.get(i);
          Rog_predicado[i] = Rog_misturaPred.get(i);
        }
        Rog_misturaSuj.clear();
        Rog_misturaPred.clear();
        for(int i=0;i<16;i++){
          if( Rog_sujeito[i] == "0"){
            Rog_sujeito[i] = Rog_sujeito[_tabletId*4];
            Rog_sujeito[_tabletId*4] = Rog_save;
            break;
          }
        }             
      }
      else
        if(mouseX >250 && mouseX < 400 && mouseY > 310 && mouseY < 350){
          Rog_local = 1;
          Rog_save = Rog_sujeito[_tabletId*4+1];
          Rog_sujeito[_tabletId*4+1] = "0";
          for(int i=0; i<16; i++){
            Rog_misturaSuj.append(Rog_sujeito[i]);          
            Rog_misturaPred.append(Rog_predicado[i]);          
          }
          Rog_misturaSuj.shuffle();
          Rog_misturaPred.shuffle();
          for(int i=0;i<16;i++){
            Rog_sujeito[i] = Rog_misturaSuj.get(i);
            Rog_predicado[i] = Rog_misturaPred.get(i);
          }
          Rog_misturaSuj.clear();
          Rog_misturaPred.clear();
          for(int i=0;i<16;i++){
            if( Rog_sujeito[i] == "0"){
              Rog_sujeito[i] = Rog_sujeito[_tabletId*4+1];
              Rog_sujeito[_tabletId*4+1] = Rog_save;
              break;
            }
          }
        }
        else
          if(mouseX >250 && mouseX < 400 && mouseY > 410 && mouseY < 450){
            Rog_local = 1;
            Rog_save = Rog_sujeito[_tabletId*4+2];
            Rog_sujeito[_tabletId*4+2] = "0";
            for(int i=0; i<16; i++){
              Rog_misturaSuj.append(Rog_sujeito[i]);          
              Rog_misturaPred.append(Rog_predicado[i]);          
            }
            Rog_misturaSuj.shuffle();
            Rog_misturaPred.shuffle();
            for(int i=0;i<16;i++){
              Rog_sujeito[i] = Rog_misturaSuj.get(i);
              Rog_predicado[i] = Rog_misturaPred.get(i);
            }
            Rog_misturaSuj.clear();
            Rog_misturaPred.clear();
            for(int i=0;i<16;i++){
              if( Rog_sujeito[i] == "0"){
                Rog_sujeito[i] = Rog_sujeito[_tabletId*4+2];
                Rog_sujeito[_tabletId*4+2] = Rog_save;
                break;
              }
            }     
          }
          else
            if(mouseX >250 && mouseX < 400 && mouseY > 510 && mouseY < 550){
              Rog_local = 1;
              Rog_save = Rog_sujeito[_tabletId*4+3];
              Rog_sujeito[_tabletId*4+3] = "0";
              for(int i=0; i<16; i++){
                Rog_misturaSuj.append(Rog_sujeito[i]);          
                Rog_misturaPred.append(Rog_predicado[i]);          
              }
              Rog_misturaSuj.shuffle();
              Rog_misturaPred.shuffle();
              for(int i=0;i<16;i++){
                Rog_sujeito[i] = Rog_misturaSuj.get(i);
                Rog_predicado[i] = Rog_misturaPred.get(i);
              }
              Rog_misturaSuj.clear();
              Rog_misturaPred.clear();
              for(int i=0;i<16;i++){
                if( Rog_sujeito[i] == "0"){
                  Rog_sujeito[i] = Rog_sujeito[_tabletId*4+3];
                  Rog_sujeito[_tabletId*4+3] = Rog_save;
                  break;
                }
              }      
            }
            else
              if(mouseX >900 && mouseX < 1050 && mouseY > 210 && mouseY < 250){
                Rog_local = 2;
                Rog_save = Rog_predicado[_tabletId*4];
                Rog_predicado[_tabletId*4] = "0";
                for(int i=0; i<16; i++){
                  Rog_misturaSuj.append(Rog_sujeito[i]);          
                  Rog_misturaPred.append(Rog_predicado[i]);          
                }
                Rog_misturaSuj.shuffle();
                Rog_misturaPred.shuffle();
                for(int i=0;i<16;i++){
                  Rog_sujeito[i] = Rog_misturaSuj.get(i);
                  Rog_predicado[i] = Rog_misturaPred.get(i);
                }
                Rog_misturaSuj.clear();
                Rog_misturaPred.clear();
                for(int i=0;i<16;i++){
                  if( Rog_predicado[i] == "0"){
                    Rog_predicado[i] = Rog_predicado[_tabletId*4];
                    Rog_predicado[_tabletId*4] = Rog_save;
                    break;
                  }
                }
              }
              else
                if(mouseX >900 && mouseX < 1050 && mouseY > 310 && mouseY < 350){
                  Rog_local = 2;
                  Rog_save = Rog_predicado[_tabletId*4+1];
                  Rog_predicado[_tabletId*4+1] = "0";
                  for(int i=0; i<16; i++){
                    Rog_misturaSuj.append(Rog_sujeito[i]);          
                    Rog_misturaPred.append(Rog_predicado[i]);          
                  }
                  Rog_misturaSuj.shuffle();
                  Rog_misturaPred.shuffle();
                  for(int i=0;i<16;i++){
                    Rog_sujeito[i] = Rog_misturaSuj.get(i);
                    Rog_predicado[i] = Rog_misturaPred.get(i);
                  }
                  Rog_misturaSuj.clear();
                  Rog_misturaPred.clear();
                  for(int i=0;i<16;i++){
                    if( Rog_predicado[i] == "0"){
                      Rog_predicado[i] = Rog_predicado[_tabletId*4+1];
                      Rog_predicado[_tabletId*4+1] = Rog_save;
                      break;
                    }
                  }
                }
                else
                  if(mouseX >900 && mouseX < 1050 && mouseY > 410 && mouseY < 450){
                    Rog_local = 2;
                    Rog_save = Rog_predicado[_tabletId*4+2];
                    Rog_predicado[_tabletId*4+2] = "0";
                    for(int i=0; i<16; i++){
                      Rog_misturaSuj.append(Rog_sujeito[i]);          
                      Rog_misturaPred.append(Rog_predicado[i]);          
                    }
                    Rog_misturaSuj.shuffle();
                    Rog_misturaPred.shuffle();
                    for(int i=0;i<16;i++){
                      Rog_sujeito[i] = Rog_misturaSuj.get(i);
                      Rog_predicado[i] = Rog_misturaPred.get(i);
                    }
                    Rog_misturaSuj.clear();
                    Rog_misturaPred.clear();
                    for(int i=0;i<16;i++){
                      if( Rog_predicado[i] == "0"){
                        Rog_predicado[i] = Rog_predicado[_tabletId*4+2];
                        Rog_predicado[_tabletId*4+2] = Rog_save;
                        break;
                      }
                    }
                  }
                  else
                    if(mouseX >900 && mouseX < 1050 && mouseY > 510 && mouseY < 550){
                      Rog_local = 2;
                      Rog_save = Rog_predicado[_tabletId*4+3];
                      Rog_predicado[_tabletId*4+3] = "0";
                      for(int i=0; i<16; i++){
                        Rog_misturaSuj.append(Rog_sujeito[i]);          
                        Rog_misturaPred.append(Rog_predicado[i]);          
                      }
                      Rog_misturaSuj.shuffle();
                      Rog_misturaPred.shuffle();
                      for(int i=0;i<16;i++){
                        Rog_sujeito[i] = Rog_misturaSuj.get(i);
                        Rog_predicado[i] = Rog_misturaPred.get(i);
                      }
                      Rog_misturaSuj.clear();
                      Rog_misturaPred.clear();
                      for(int i=0;i<16;i++){
                        if( Rog_predicado[i] == "0"){
                          Rog_predicado[i] = Rog_predicado[_tabletId*4+3];
                          Rog_predicado[_tabletId*4+3] = Rog_save;
                          break;
                        }
                      } 
                    }
                    else
                      if(mouseX >500 && mouseX < 800 && mouseY > 200 && mouseY < 500){
                        Rog_local = 0;
                      }
                      else
                        Rog_local = -1;
      
      if(Rog_local == 1 || Rog_local == 2){  
        if(Rog_save == "se desfaz") Rog_save = "sedesfaz";
        if(Rog_save == "se realiza") Rog_save = "serealiza";
        if(Rog_save == "morte?!") Rog_save = "morte";
        if(Rog_save == "instante?!") Rog_save = "instante";
        if(Rog_save == "sorte?!") Rog_save = "sorte";
        
        String Rog_audio = "rog"+Rog_local+Rog_save+".mp3";
        if(Rog_audios.hasValue(Rog_audio)){
          player.setMediaFile(Rog_audio);
          player.start();
        }
      }
      if(Rog_local == 0){
        player.setMediaFile("rogque1.mp3");
        player.start();
      }
     
      break;
    case 1://alvaro
      //println("inst"+instalacaoAtual+"id"+_tabletId);
      //for(int i=0; i<5; i++) println(i+" '"+Alv_poema[i]+"'"); 
      if(Alv_poema[_tabletId] == "um"){
        for(int i=0; i<5;i++){
          if(Alv_poema[i] == "outro"){
            Alv_poema[_tabletId] = "outro";
            Alv_poema[i] = "um";
            break;
          }
        }        
        player.setMediaFile("alv1_um.mp3");
        player.start();   
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
          player.setMediaFile("alv2_corta.mp3");
          player.start();   
        }
        else{
          if(Alv_poema[_tabletId] == "capina"){
            Alv_tocaCapina = true;  
            player.setMediaFile("alv3_capina.mp3");
            player.start();          
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
              player.setMediaFile("alv4_renova.mp3");
              player.start();   
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
                player.setMediaFile("alv5_outro.mp3");
                player.start();   
              }
            }
          }
        }
      }
      if(Alv_direcaoDirParaEsq)   Alv_direcaoDirParaEsq = false;
      else Alv_direcaoDirParaEsq = true;
      break;
    case 2://carlos
      if(Carl_estados[_tabletId] != 0){
        player.setMediaFile(Carl_audios[_tabletId*3+Carl_estados[_tabletId]-1]);
        player.start();
      }
      Carl_estados[_tabletId]+=1;
      if(Carl_estados[_tabletId] > 3)
        Carl_estados[_tabletId] = 0;      
      break;
    case 3://alckmar
      println(mouseX+" "+mouseY);
      if(Alck_estados[_tabletId] == 0 && mouseY > 685 && mouseY < 720){
        if(_tabletId != 3){
          player.setMediaFile(Alck_audios[_tabletId*2+Alck_estados[_tabletId]]);
          player.start();
          println("cur"+player.getCurrentPosition());
          println("dur"+player.getDuration());
          if(player.getCurrentPosition() >= player.getDuration())
              Alck_estados[_tabletId] = 1;
        }
      }
      else{
        if(Alck_estados[_tabletId] == 1 && mouseY > 50 && mouseY < 85){
            player.setMediaFile(Alck_audios[_tabletId*2+Alck_estados[_tabletId]]);
            player.start();
            if(player.getCurrentPosition() >= player.getDuration())
                Alck_estados[_tabletId] = 0;    
        }
      }
      break;
    case 4://pablo      
      switch(Pabl_ordem[_tabletId]){
        case 0:
          Pabl_shiftAnda = 0;
          Pabl_paraDireita = true;
          Pabl_shiftAnda2 = 0;
          Pabl_paraCima = true;
          break;
        case 2:
          Pabl_apagar = 255;
          break;
        case 4:
          Pabl_shiftBolha = 0;
          Pabl_shiftBolha2 = 0;
          Pabl_shiftBolha3 = 0;
          break;
        case 5:
          Pabl_tamVerso6 = 1;
          break;
      }
      int rand = int(random(10));
      int save = Pabl_ordem[_tabletId];
      if(rand%2 == 0){//pega elemento 4 do array
        Pabl_ordem[_tabletId] = Pabl_ordem[4];
        Pabl_ordem[4] = save;        
      }
      else{
        Pabl_ordem[_tabletId] = Pabl_ordem[5];
        Pabl_ordem[5] = save;
      }
  }  
}

void keyPressed(){
  if(key == '0'){    
    clear();
    background(255);
    _tabletId = -1;
  }
  if(key == '1'){
    clear();
    background(255);
    _tabletId = 0;
  }
  if(key == '2'){
    clear();
    background(255);
    _tabletId = 1;
  }
  if(key == '3'){
    clear();
    background(255);
    _tabletId = 2;
  }
  if(key == '4'){
    clear();
    background(255);
    _tabletId = 3;
  }
  if(key == ENTER){
    instalacaoAtual += 1;
    if(instalacaoAtual > 5) instalacaoAtual = 0;
    clear();
    background(255);
    if(instalacaoAtual == 2) playerTrilhas.setMediaFile("Carlos.mp3");
    if(instalacaoAtual == 3) playerTrilhas.setMediaFile("Alckmar.mp3");
    if(instalacaoAtual == 4) playerTrilhas.setMediaFile("Pablo_Gobira.mp3");
  }
  if(key == 't'){
    vel += 1;
  }
  if(key == 'r'){
    vel -= 1;
  }
}

void playRogerio(){    
  //println("rog "+Rog_local);
  if(Rog_local == 0){
    image(Rog_conector2.getFrame(Rog_fundo),displayWidth/2,displayHeight/2);
    if(Rog_conector2.currentFrame() == 33){ 
      Rog_local = -1;      
      Rog_conector2.setCurrentFrame(0);
    }
    //else println(Rog_conector2.currentFrame());
  }
  else
    image(Rog_conector1.getFrame(Rog_fundo),displayWidth/2,displayHeight/2);
  imageMode(CENTER);
  
  //display 4 versos por tablet
  //get id tablet
  //_tabletId = get servidor;
  int shift = displayHeight/4;
  switch (_tabletId){
    case 0:
      //image(Rog_conector,displayWidth/2,displayHeight/2);
      //imageMode(CENTER);
      textSize(32*tamanhoTexto);
      for(int i=0; i<4; i++){
        text(Rog_sujeito[i],width/4,shift+30);
        text(Rog_predicado[i], 3*width/4,shift+30);
        textAlign(CENTER, CENTER);
        fill(cor);
        shift += displayHeight/8;
      } 
      break;
    case 1:
      //image(Rog_conector,displayWidth/2,displayHeight/2);
      //imageMode(CENTER);
      textSize(32*tamanhoTexto);
      for(int i=4; i<8; i++){
        text(Rog_sujeito[i],width/4,shift+30);
        text(Rog_predicado[i], 3*width/4,shift+30);
        textAlign(CENTER, CENTER);
        fill(cor);
        shift += displayHeight/8;
      }
      break;
    case 2:
      //image(Rog_conector,displayWidth/2,displayHeight/2);
      //imageMode(CENTER);
      textSize(32*tamanhoTexto);
      for(int i=8; i<12; i++){
        text(Rog_sujeito[i],width/4,shift+30);
        text(Rog_predicado[i], 3*width/4,shift+30);
        textAlign(CENTER, CENTER);
        fill(cor);
        shift += displayHeight/8;
      }
      break;
    case 3:
      //image(Rog_conector,displayWidth/2,displayHeight/2);
      //imageMode(CENTER);
      textSize(32*tamanhoTexto);
      for(int i=12; i<16; i++){
        text(Rog_sujeito[i],width/4,shift+30);
        text(Rog_predicado[i], 3*width/4,shift+30);
        textAlign(CENTER, CENTER);
        fill(cor);
        shift += displayHeight/8;
      }
      break;
  }  
}

void playAlvaro(){
  switch (_tabletId){
    case 0:      
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_tocaCapina && Alv_poema[0] == "capina"){
        imageMode(CENTER);
        image(Alv_gif_capina.getFrame(255),width/2+Alv_shift+Alv_nasc,height/2);
        /*if(Alv_direcaoDirParaEsq)
          image(Alv_gif_capina.getFrame(255),(displayWidth+500)+Alv_shift,height/2);
        else
          image(Alv_gif_capina.getFrame(255),(-500)+Alv_shift,height/2);*/
        
      }
      else{        
        //if(Alv_direcaoDirParaEsq)
        text(Alv_poema[0],width/2+Alv_shift+Alv_nasc,height/2);
          //text(Alv_poema[0],(displayWidth+500)+Alv_shift,height/2);
        //else
          //text(Alv_poema[0],(-500)+Alv_shift,height/2);
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
        /*if(Alv_direcaoDirParaEsq)
          image(Alv_gif_capina.getFrame(255),(displayWidth+500)+Alv_shift,height/2);
        else
          image(Alv_gif_capina.getFrame(255),(-500)+Alv_shift,height/2);*/        
      }
      else{
        text(Alv_poema[1],width/2+Alv_shift+Alv_nasc,height/2);
        /*if(Alv_direcaoDirParaEsq)
          text(Alv_poema[1],(displayWidth+500)+Alv_shift,height/2);
        else
          text(Alv_poema[1],(-400)+Alv_shift,height/2);*/
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
        /*if(Alv_direcaoDirParaEsq)
          image(Alv_gif_capina.getFrame(255),(displayWidth+500)+Alv_shift,height/2);
        else
          image(Alv_gif_capina.getFrame(255),(-500)+Alv_shift,height/2);*/        
      }
      else{
        text(Alv_poema[2],width/2+Alv_shift+Alv_nasc,height/2);
        /*if(Alv_direcaoDirParaEsq)
          text(Alv_poema[2],(displayWidth+500)+Alv_shift,height/2);
        else
          text(Alv_poema[2],(-500)+Alv_shift,height/2);*/  
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
        /*if(Alv_direcaoDirParaEsq)
          image(Alv_gif_capina.getFrame(255),(displayWidth+500)+Alv_shift,height/2);
        else
          image(Alv_gif_capina.getFrame(255),(-500)+Alv_shift,height/2);      */  
      }
      else{
        text(Alv_poema[3],width/2+Alv_shift+Alv_nasc,height/2);
        /*
        if(Alv_direcaoDirParaEsq)
          text(Alv_poema[3],(displayWidth+500)+Alv_shift,height/2);
        else
          text(Alv_poema[3],(-500)+Alv_shift,height/2);  */
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
  //println(Alv_shift);
  //println("0"+Alv_poema[0]);
  //println("1"+Alv_poema[1]);
  //println("2"+Alv_poema[2]);
  //println("3"+Alv_poema[3]);
  //println("4"+Alv_poema[4]);
  println("pos "+int(width/2+Alv_shift+Alv_nasc));  
  println("sh "+Alv_shift);
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

void playCarlos(){  
  imageMode(CENTER);
  image(Carl_imgs[_tabletId*4+Carl_estados[_tabletId]],width/2,height/2);   
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

void playPablo(){
  playerTrilhas.setMediaFile("Pablo_Gobira.mp3");
  playerTrilhas.start();
  int mostra = Pabl_ordem[_tabletId];
  switch(mostra){
    case 0: //alterar tamanho da fonte de acordo com acelerômetro
      background(255);
      noStroke();
      rect(0,0,width,height/2-32);
      rect(0,height/2+32,width,height/2-32); 
      rect(0,height/2-32,width/4,height/2);
      rect(3*width/4,height/2-32,width/4,height/2);      
      fill(0);
      textSize(32*tamanhoTexto);
      textAlign(CENTER, CENTER);
      text(Pabl_versos[0],width/2+Pabl_shiftAnda,height/2+Pabl_shiftAnda2);      
      fill(cor);      
      if(int(random(10))%2 == 0){
        if(Pabl_paraDireita){        
          Pabl_shiftAnda+=0.5;
          if(Pabl_shiftAnda > 20)
            Pabl_paraDireita = false;
        }
        else{
          Pabl_shiftAnda-=0.5;
          if(Pabl_shiftAnda < -20)
            Pabl_paraDireita = true;
        }
      }
      else{
        if(Pabl_paraCima){        
          Pabl_shiftAnda2+=0.5;
          if(Pabl_shiftAnda2 > 10)
            Pabl_paraCima = false;
        }
        else{
          Pabl_shiftAnda2-=0.5;
          if(Pabl_shiftAnda2 < -20)
            Pabl_paraCima = true;
        }
      }
      break;
    case 1: //espelhamento
      background(255);
      textSize(50*tamanhoTexto);
      fill(cor); 
      text(Pabl_versos[1],width/2,height/2-25);      
      color nova = color(red(cor),green(cor),blue(cor),128); 
      fill(nova);
      pushMatrix();
        scale(1, -1);
        text(Pabl_versos[1],width/2, -height/2-25);
      popMatrix();
      
      textAlign(CENTER, CENTER); 
      break;
    case 2: //com o tempo, derreter ou apagar fonte
      background(255);
      smooth();
      textSize(50*tamanhoTexto);
      textAlign(CENTER, CENTER);
      text(Pabl_versos[2],width/2,height/2); 
      color newColor = color(red(cor),green(cor),blue(cor),Pabl_apagar); 
      fill(newColor);
      //println(apagar);      
      if(Pabl_apagar > 1) Pabl_apagar -= 0.5;  
      break;
    case 3: //estrofe bem apagada, com letras e palavras bem juntas
      background(255);
      textSize(50*tamanhoTexto);
      textAlign(CENTER, CENTER);
      textLeading(50);       
      color newColor2 = color(red(cor),green(cor),blue(cor),25);
      fill(newColor2);
      text(Pabl_versos[3],width/2,height/2);
      break;
    case 4: //versos da estrofe caindo em um lago e criando ondas. //Interator pode tocar e gerar mais ondas no lago, surgindo palavras
      background(255);
      textSize(50*tamanhoTexto);
      smooth();
      textAlign(CENTER, CENTER);
      fill(cor);
      text(Pabl_versos[4],width/2,height/2);
      noFill();
      stroke(128,128,128);
      ellipse(width/2,height/2,10*Pabl_shiftBolha,5*Pabl_shiftBolha);  
      ellipse(width/2,height/2,20*Pabl_shiftBolha,10*Pabl_shiftBolha);
      ellipse(width/2,height/2,30*Pabl_shiftBolha,15*Pabl_shiftBolha); 
      ellipse(width/2,height/2,40*Pabl_shiftBolha,20*Pabl_shiftBolha); 
      ellipse(width/2,height/2,50*Pabl_shiftBolha,25*Pabl_shiftBolha);      
      Pabl_shiftBolha+=0.01;
      ellipse(width/2,height/2,10*Pabl_shiftBolha2,5*Pabl_shiftBolha2);  
      ellipse(width/2,height/2,20*Pabl_shiftBolha2,10*Pabl_shiftBolha2);
      ellipse(width/2,height/2,30*Pabl_shiftBolha2,15*Pabl_shiftBolha2); 
      ellipse(width/2,height/2,40*Pabl_shiftBolha2,20*Pabl_shiftBolha2); 
      ellipse(width/2,height/2,50*Pabl_shiftBolha2,25*Pabl_shiftBolha2);
      Pabl_shiftBolha2+=0.05;
      ellipse(width/2,height/2,10*Pabl_shiftBolha3,5*Pabl_shiftBolha3);  
      ellipse(width/2,height/2,20*Pabl_shiftBolha3,10*Pabl_shiftBolha3);
      ellipse(width/2,height/2,30*Pabl_shiftBolha3,15*Pabl_shiftBolha3); 
      ellipse(width/2,height/2,40*Pabl_shiftBolha3,20*Pabl_shiftBolha3); 
      ellipse(width/2,height/2,50*Pabl_shiftBolha3,25*Pabl_shiftBolha3);      
      Pabl_shiftBolha3+=0.1;
      if(Pabl_shiftBolha > 100){
        Pabl_shiftBolha = 0;
      }
      if(Pabl_shiftBolha2 > 100){
        Pabl_shiftBolha2 = 0;
      }
      if(Pabl_shiftBolha3 > 100){
        Pabl_shiftBolha3 = 0;
      }
      break;
    case 5: //estrofe se distancia aos poucos, ao final palavras se desfazem em tiras
      background(255);
      smooth();
      float tam = (50+Pabl_tamVerso6)*tamanhoTexto;
      textSize(tam);
      textAlign(CENTER, CENTER);
      fill(cor);
      text(Pabl_versos[5],width/2,height/2);
      if(50+Pabl_tamVerso6 > 1) Pabl_tamVerso6-=0.05;
      else tam = 0;
      
      break;
  }
}

void conteudoRogerio(){
  
  Rog_sujeito = new String[16];
  Rog_sujeito[0] = "amor";
  Rog_sujeito[1] = "amor";
  Rog_sujeito[2] = "amor";
  Rog_sujeito[3] = "amor";
  Rog_sujeito[4] = "acontecimento";
  Rog_sujeito[5] = "tempo";
  Rog_sujeito[6] = "vida";
  Rog_sujeito[7] = "instante";
  Rog_sujeito[8] = "ignorar";
  Rog_sujeito[9] = "duvidar";
  Rog_sujeito[10] = "acontecer";
  Rog_sujeito[11] = "morrer";
  Rog_sujeito[12] = "duplo";
  Rog_sujeito[13] = "fluir";
  Rog_sujeito[14] = "luz";
  Rog_sujeito[15] = "mundo";
  Rog_predicado = new String[16];
  Rog_predicado[0] = "se realiza";
  Rog_predicado[1] = "ignora";
  Rog_predicado[2] = "duvida";
  Rog_predicado[3] = "morre";
  Rog_predicado[4] = "dura";
  Rog_predicado[5] = "voa";
  Rog_predicado[6] = "fenece";
  Rog_predicado[7] = "fica";
  Rog_predicado[8] = "vida?!";
  Rog_predicado[9] = "morte?!";
  Rog_predicado[10] = "instante?!";//???
  Rog_predicado[11] = "sorte?!";
  Rog_predicado[12] = "divide";
  Rog_predicado[13] = "intensifica";
  Rog_predicado[14] = "inunda";
  Rog_predicado[15] = "se desfaz";  
  Rog_conector1 = new IMGAnimation("rog_tempo_#.png", 15, 1);
  Rog_conector2 = new IMGAnimation("rog_divide_#.png", 34, 1);
  Rog_fundo = loadImage("rog_fundo.png"); 
  Rog_audios = new StringList();
  Rog_audios.append("rog1amor.mp3");
  Rog_audios.append("rog1acontecimento.mp3");
  Rog_audios.append("rog1tempo.mp3");
  Rog_audios.append("rog1vida.mp3");
  Rog_audios.append("rog1instante.mp3");
  Rog_audios.append("rog1ignorar.mp3");
  Rog_audios.append("rog1duvidar.mp3");
  Rog_audios.append("rog1acontecer.mp3");
  Rog_audios.append("rog1morrer.mp3");
  Rog_audios.append("rog1duplo.mp3");
  Rog_audios.append("rog1fluir.mp3");
  Rog_audios.append("rog1luz.mp3");
  Rog_audios.append("rog1mundo.mp3");
  Rog_audios.append("rog2serealiza.mp3");
  Rog_audios.append("rog2ignora.mp3");
  Rog_audios.append("rog2duvida.mp3");
  Rog_audios.append("rog2morre.mp3");
  Rog_audios.append("rog2dura.mp3");
  Rog_audios.append("rog2voa.mp3");
  Rog_audios.append("rog2fenece.mp3");
  Rog_audios.append("rog2fica.mp3");
  Rog_audios.append("rog2vida.mp3");
  Rog_audios.append("rog2morte.mp3");
  Rog_audios.append("rog2instante.mp3");
  Rog_audios.append("rog2sorte.mp3");
  Rog_audios.append("rog2divide.mp3");
  Rog_audios.append("rog2intensifica.mp3");
  Rog_audios.append("rog2inunda.mp3");
  Rog_audios.append("rog2sedesfaz.mp3");
  Rog_misturaSuj = new StringList();
  Rog_misturaPred = new StringList();
}
void conteudoAlvaro(){
  Alv_poema = new String [5];
  Alv_poema[0] = "um";
  Alv_poema[1] = "corta";
  Alv_poema[2] = "capina";
  Alv_poema[3] = "renova";
  Alv_poema[4] = "outro";
  Alv_gif_capina= new IMGAnimation("capina#.png", 8, 1,false);  
}

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

void conteudoPablo(){
  Pabl_ordem = new int [6];
  for(int i=0;i<6;i++) Pabl_ordem[i] = i;
  Pabl_versos = new String [6];
  Pabl_versos[0] = "Estou sem espaço aqui, mas continuo.";
  Pabl_versos[1] = "Estou no meio de uma reflexão e continuo.";
  Pabl_versos[2] = "Vivo no lodo e perpetuo a busca inconclusa.";
  Pabl_versos[3] = "Voltaemeiadoumaisumpasso.\nAvidaécomodesatarereatarumlaço.\nManusearumabotaquenãomaisseusa.";
  Pabl_versos[4] = "Sou um organismo desorganizado.\nUma pedra em um lago.\nEstou em mim e no vizinho da casa ao lado.";
  Pabl_versos[5] = "Repetir o passo a passo solitariamente.\nRemendar os trapos sorridente.\nAcenar com a mão e o braço um adeus demorado.";
}


public void onDestroy() {

  super.onDestroy(); //call onDestroy on super class
  if(player!=null) { //must be checked because or else crash when return from landscape mode
    player.release(); //release the player

  }
  if(playerTrilhas!=null) { //must be checked because or else crash when return from landscape mode
    playerTrilhas.release(); //release the player
  }
}
