//Oficina Adultos

import apwidgets.*;
APMediaPlayer player;

int currentInstalation = 2;

//Rogério
String [] Rog_sujeito;
String [] Rog_predicado;
String Rog_conector;

//Álvaro
String [] Alv_poema;
PImage Alv_gif_capina;

//Carlos Augusto

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

//Pablo

void setup(){
  size(1280, 800);
  player = new APMediaPlayer(this); //create new APMediaPlayer
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
 switch(currentInstalation){
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
  
 
}

void playRogerio(){}
void playAlvaro(){
  image(Alv_gif_capina,90, 0); 
}
void playCarlos(){}
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
void playPablo(){}

void conteudoRogerio(){
  Rog_sujeito = new String[16];
  Rog_sujeito[0] = "AMOR";
  Rog_sujeito[1] = "AMOR";
  Rog_sujeito[2] = "AMOR";
  Rog_sujeito[3] = "AMOR";
  Rog_sujeito[4] = "ACONTECIMENTO";
  Rog_sujeito[5] = "TEMPO";
  Rog_sujeito[6] = "VIDA";
  Rog_sujeito[7] = "INSTANTE";
  Rog_sujeito[8] = "IGNORAR";
  Rog_sujeito[9] = "DUVIDAR";
  Rog_sujeito[10] = "ACONTECER";
  Rog_sujeito[11] = "MORRER";
  Rog_sujeito[12] = "DUPLO";
  Rog_sujeito[13] = "FLUIR";
  Rog_sujeito[14] = "LUZ";
  Rog_sujeito[15] = "MUNDO";
  Rog_predicado = new String[16];
  Rog_predicado[0] = "SE REALIZA";
  Rog_predicado[1] = "IGNORA";
  Rog_predicado[2] = "DUVIDA";
  Rog_predicado[3] = "MORRE";
  Rog_predicado[4] = "DURA";
  Rog_predicado[5] = "VOA";
  Rog_predicado[6] = "FENECE";
  Rog_predicado[7] = "FICA";
  Rog_predicado[8] = "VIDA?!";
  Rog_predicado[9] = "MORTE?!";
  Rog_predicado[10] = "INSTANTE?!";
  Rog_predicado[11] = "SORTE?!";
  Rog_predicado[12] = "DIVIDE";
  Rog_predicado[13] = "INTENSIFICA";
  Rog_predicado[14] = "INUNDA";
  Rog_predicado[15] = "SE DESFAZ";
  Rog_conector = "QUE";
}
void conteudoAlvaro(){
  Alv_poema = new String [5];
  Alv_poema[0] = "um";
  Alv_poema[1] = "corta";
  Alv_poema[2] = "capina";
  Alv_poema[3] = "outro";
  Alv_poema[4] = "renova";
  Alv_gif_capina =  loadImage("acapina.gif");
}
void conteudoCarlos(){}
void conteudoAlckmar(){
  Alck_poema1A = loadImage("alckmar1A.png");
  //Alck_poema1A.resize(110, 110);
  Alck_palavra1 = loadImage("alckmar1.png");
  //Alck_palavra1.resize(110, 110);
  Alck_poema1B = loadImage("alckmar1B.png");
  //Alck_poema1B.resize(110, 110);
  Alck_poema2A = loadImage("alckmar2A.png");
  //Alck_poema2A.resize(110, 110);
  Alck_palavra2 = loadImage("alckmar2.png");
  //Alck_palavra2.resize(110, 110);
  Alck_poema2B = loadImage("alckmar2B.png");
  //Alck_poema2B.resize(110, 110);
  Alck_poema3A = loadImage("alckmar3A.png");
  //Alck_poema3A.resize(110, 110);
  Alck_palavra3 = loadImage("alckmar3.png");
  //Alck_palavra3.resize(110, 110);
  Alck_poema3B = loadImage("alckmar3B.png");
  //Alck_poema3B.resize(110, 110);
}
void conteudoPablo(){}
