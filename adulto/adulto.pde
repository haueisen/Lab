//Oficina Adultos

import apwidgets.*;
APMediaPlayer player;

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
String [] Alv_audios;
float Alv_shift = 0.0;
float Alv_velocidade = 1.0;
boolean Alv_direcaoDirParaEsq = false; //direita para esquerda - 

//Carlos Augusto
PImage Carl_tablet1_estado1;//?
PImage Carl_tablet1_estado2;//onde
PImage Carl_tablet1_estado3;//onde se lê
PImage Carl_tablet1_estado4;//P
PImage Carl_tablet2_estado1;//:
PImage Carl_tablet2_estado2;//se lê
PImage Carl_tablet2_estado3;//onde se lê:
PImage Carl_tablet2_estado4;//O
PImage Carl_tablet3_estado1;//!
PImage Carl_tablet3_estado2;//tudo
PImage Carl_tablet3_estado3;//onde se lê!
PImage Carl_tablet3_estado4;//E
PImage Carl_tablet4_estado1;//...
PImage Carl_tablet4_estado2;//nada
PImage Carl_tablet4_estado3;//onde se lê...
PImage Carl_tablet4_estado4;//M
String [] Carl_audios;

//Alckmar
PImage Alck_poema1A;
PImage Alck_poema1B;
PImage Alck_palavra1;
PImage Alck_poema2A;
PImage Alck_poema2B;
PImage Alck_palavra2;
PImage Alck_poema3A;
PImage Alck_poema3B;
PImage Alck_palavra3;
String [] Alck_audios;

//Pablo
String [] Pabl_versos;

void setup(){
  size(1280, 800);
  //size(displayWidth, displayHeight);  
  background(255);
  frameRate(100);
  player = new APMediaPlayer(this); //create new APMediaPlayer
  player.setVolume(1.0, 1.0);
  //carrega conteúdos
  conteudoRogerio();  
  conteudoAlvaro();
  conteudoCarlos();  
  conteudoAlckmar();    
  conteudoPablo(); 
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
      println(mouseX+" "+mouseY);
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
      switch(_tabletId){
        case 0:
          if(Alv_poema[0] == "um"){
            Alv_poema[0] = "outro";
            Alv_poema[4] = "um";
          }
          if(Alv_poema[0] == "corta"){
            Alv_poema[0] = "renova";
            Alv_poema[2] = "corta";
          }
          if(Alv_poema[0] == "capina"){
            
          }
          if(Alv_poema[0] == "renova"){
            Alv_poema[0] = "corta";
            Alv_poema[3] = "renova";
          }
          if(Alv_poema[0] == "outro"){
            Alv_poema[0] = "um";
            Alv_poema[1] = "outro";
          }
          break;
        case 1:
          if(Alv_poema[1] == "um"){
            Alv_poema[1] = "outro";
            Alv_poema[3] = "um";
          }
          if(Alv_poema[1] == "corta"){
            Alv_poema[1] = "renova";
            Alv_poema[3] = "corta";
          }
          if(Alv_poema[1] == "capina"){            
          }
          if(Alv_poema[1] == "outro"){
            Alv_poema[1] = "um";
            Alv_poema[3] = "outro";
          }          
          if(Alv_poema[1] == "renova"){
            Alv_poema[1] = "corta";
            Alv_poema[3] = "renova";
          }
          break;
        case 2:
          if(Alv_poema[2] == "um"){
            Alv_poema[2] = "outro";
            Alv_poema[] = "um";
          }
          if(Alv_poema[1] == "corta"){
            Alv_poema[1] = "renova";
            Alv_poema[4] = "corta";
          }
          if(Alv_poema[1] == "capina"){            
          }
          if(Alv_poema[1] == "outro"){
            Alv_poema[1] = "um";
            Alv_poema[4] = "outro";
          }          
          if(Alv_poema[1] == "renova"){
            Alv_poema[1] = "corta";
            Alv_poema[4] = "renova";
          }
          break;
      }
      break;
    case 2://carlos
 
      break;
    case 3://alckmar
 
      break;
    case 4://pablo
      break;   
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
      if(Alv_direcaoDirParaEsq)
        text(Alv_poema[0],(displayWidth+500)+Alv_shift,height/2);
      else
        text(Alv_poema[0],(-500)+Alv_shift,height/2);
      textAlign(CENTER, CENTER);
      fill(cor);
      break;
    case 1:
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_direcaoDirParaEsq)
        text(Alv_poema[1],(displayWidth+500)+Alv_shift,height/2);
      else
        text(Alv_poema[1],(-400)+Alv_shift,height/2);
      textAlign(CENTER, CENTER);
      fill(cor);
      break;
    case 2:
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_direcaoDirParaEsq)
        text(Alv_poema[2],(displayWidth+500)+Alv_shift,height/2);
      else
        text(Alv_poema[2],(-500)+Alv_shift,height/2);  
      textAlign(CENTER, CENTER);
      fill(cor);
      break;
    case 3:
      background(255);
      textSize(200*tamanhoTexto);
      if(Alv_direcaoDirParaEsq)
        text(Alv_poema[3],(displayWidth+500)+Alv_shift,height/2);
      else
        text(Alv_poema[3],(-500)+Alv_shift,height/2);  
      textAlign(CENTER, CENTER);
      fill(cor);
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
  
  if(Alv_shift < -displayWidth*2){
    Alv_shift = 0;
    String prim = Alv_poema[0];
    Alv_poema[0] = Alv_poema[1];
    Alv_poema[1] = Alv_poema[2];
    Alv_poema[2] = Alv_poema[3];
    Alv_poema[3] = Alv_poema[4];
    Alv_poema[4] = prim;    
  }
  if(Alv_shift > displayWidth*2){
    Alv_shift = 0;
    String prim = Alv_poema[4];
    Alv_poema[4] = Alv_poema[3];
    Alv_poema[3] = Alv_poema[2];
    Alv_poema[2] = Alv_poema[1];
    Alv_poema[1] = Alv_poema[0];
    Alv_poema[0] = prim;
  }  
}

void playCarlos(){
  
}

void playAlckmar(){
  image(Alck_poema1A, 0, 0);
  image(Alck_poema1B, 10, 0);
  image(Alck_palavra1, 20, 0);
  image(Alck_poema2A, 30, 0);
  image(Alck_poema2B, 40, 0);
  image(Alck_palavra2, 50, 0);
  image(Alck_poema3A, 60, 0);
  image(Alck_poema3B, 70, 0);
  image(Alck_palavra3,80, 0); 
}

void playPablo(){
  
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
  Alv_poema[3] = "outro";
  Alv_poema[4] = "renova";
  Alv_gif_capina= new IMGAnimation("capina#.png", 8, 1);
  Alv_audios = new String [5];
  Alv_audios [0] = "alv1_um.mp3";
  Alv_audios [1] = "alv1_corta.mp3";
  Alv_audios [2] = "alv1_capina.mp3";
  Alv_audios [3] = "alv1_renova.mp3";
  Alv_audios [4] = "alv1_outro.mp3";
}

void conteudoCarlos(){
  //Carl_gif_capina = loadImage("capina.gif");
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
}

void conteudoAlckmar(){
  Alck_poema1A = loadImage("alckmar1A.png");
  Alck_palavra1 = loadImage("alckmar1.png");
  Alck_poema1B = loadImage("alckmar1B.png");
  Alck_poema2A = loadImage("alckmar2A.png");
  Alck_palavra2 = loadImage("alckmar2.png");
  Alck_poema2B = loadImage("alckmar2B.png");
  Alck_poema3A = loadImage("alckmar3A.png");
  Alck_palavra3 = loadImage("alckmar3.png");
  Alck_poema3B = loadImage("alckmar3B.png");
  Alck_audios = new String [6];
  Alck_audios[0] = "alck1.mp3";
  Alck_audios[1] = "alck2.mp3";
  Alck_audios[2] = "alck3.mp3";
  Alck_audios[3] = "alck4.mp3";
  Alck_audios[4] = "alck5.mp3";
  Alck_audios[5] = "alck6.mp3";  
}

void conteudoPablo(){
  Pabl_versos = new String [6];
  Pabl_versos[0] = "Estou sem espaço aqui, mas continuo.";
  Pabl_versos[1] = "Estou no meio de uma reflexão e continuo.";
  Pabl_versos[2] = "Vivo no lodo e perpetuo a busca inconclusa.";
  Pabl_versos[3] = "Volta e meia dou mais um passo.\nA vida é como desatar e reatar um laço.\nManusear uma bota que não mais se usa.";
  Pabl_versos[4] = "Sou um organismo desorganizado.\nUma pedra em um lago.\nEstou em mim e no vizinho da casa ao lado.";
  Pabl_versos[5] = "Repetir o passo a passo solitariamente.\nRemendar os trapos sorridente.\nAcenar com a mão e o braço um adeus demorado.";
}
