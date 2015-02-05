//Oficina Adultos

//som
import apwidgets.*;
//APMediaplayer player;
//APMediaplayer playerTrilhas;

//servidor
JSONTCPClient _client;
boolean conectado = false;
int _tabletId = 0;

//controle remoto
int alteraTabletIt = -1; //id tablet sendo alterado
int tamanhoTexto = 1; //tamanho da fonte do texto (se houver)
color cor = color(0, 0, 0); //cor da fonte do texto (se houver)
float vel = 1.0; //velocidade de transicao de elementos (se houver)
float x_rotacao = 0.0; //angulo de rotacao no eixo x 
float y_rotacao = 0.0; //angulo de rotacao no eixo y 
float rescale = 1.0; //grau do zoom 

//instalacao atual
int instalacaoAtual = 0;

//Rogério
String [] Rog_sujeito;
String [] Rog_predicado;
IMGAnimation Rog_conector1;
IMGAnimation Rog_conector2;
IMGAnimation Rog_conector3;
IMGAnimation Rog_conector4;
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
  background(255);
  frameRate(100);
  
  //conexão
  _client = new JSONTCPClient("192.168.0.122", 8765);
  
  //sons
  /*
  player = new APMedia//player(this); //create new APMedia //player
  playerTrilhas = new APMedia//player(this); //create new APMedia //player
  player.setVolume(1.0, 1.0);
  playerTrilhas.setVolume(0.1, 0.1);
  playerTrilhas.setLooping(true);
  playerTrilhas.setMediaFile("Rogerio.mp3");
  playerTrilhas.start();
  */ 
  
  //carrega conteúdos
  conteudoRogerio();  
  conteudoAlvaro();
  conteudoCarlos();  
  conteudoAlckmar();    
  conteudoPablo();  
}

void draw(){
  //servidor
  if(!conectado){
    if(_client.isConnected()){
      conectado = true;
      JSONObject hi = new JSONObject();
      hi.setString("ac","hi");
      hi.setInt("numero",_tabletId);
      _client.sendJSON(hi);     
    }
  }  
  //controle remoto
  if(_client.numMessages() > 0){
    JSONObject j = _client.getNextMessage();
    processMessage(j);
  }
  //instalações  
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
}

//toque ou mouse
void mousePressed(){
  switch(instalacaoAtual){
    case 0://rogerio    
      toqueRogerio();      
      break;
    case 1://alvaro
      toqueAlvaro();
      break;
    case 2://carlos
      toqueCarlos(); 
      break;
    case 3://alckmar
      toqueAlckmar();
      break;
    case 4://pablo      
      toquePablo();
      break;
  }  
}

//modo debug no pc
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
    if(instalacaoAtual > 4) instalacaoAtual = 0;
    clear();
    background(255);
    /*
    if(instalacaoAtual == 2) playerTrilhas.setMediaFile("Carlos.mp3");
    if(instalacaoAtual == 3) playerTrilhas.setMediaFile("Alckmar.mp3");
    if(instalacaoAtual == 4) playerTrilhas.setMediaFile("Pablo_Gobira.mp3");*/
  }
  if(key == 't'){
    vel += 1;
  }
  if(key == 'r'){
    vel -= 1;
  }
}

//para resetar player quando termina app
/*
public void onDestroy() {
  super.onDestroy(); //call onDestroy on super class
  if(player!=null) { //must be checked because or else crash when return from landscape mode
    player.release(); //release the player
  }
  if(playerTrilhas!=null) { //must be checked because or else crash when return from landscape mode
    playerTrilhas.release(); //release the player
  }
}*/

//servidor: controle remoto mexendo nas aplicações
void processMessage(JSONObject message){
  println("|"+message.getString("ac")+"|");
  String msg = message.getString("ac");
  if(msg.equals("bang") == true){
      instalacaoAtual+=1;
      if(instalacaoAtual > 4) instalacaoAtual = 0;
      clear();
      background(255);
      if(instalacaoAtual == 0){
        //player.pause();
        //playerTrilhas.setMediaFile("Rogerio.mp3");
      }
      if(instalacaoAtual == 1){
        //player.pause();
        Alv_shift = 0.0;
        Alv_velocidade = 1.0;
        Alv_direcaoDirParaEsq = true; 
        Alv_tocaCapina = false;
        Alv_nasc = 0.0;
      }
      if(instalacaoAtual == 2){
        //player.pause();
        //playerTrilhas.setMediaFile("Carlos.mp3");
      }
      if(instalacaoAtual == 3){
        //player.pause();
        //playerTrilhas.setMediaFile("Alckmar.mp3");
      }
      if(instalacaoAtual == 4){
        //player.pause();
        //playerTrilhas.setMediaFile("Pablo_Gobira.mp3");
        //playerTrilhas.start();
      }
  }  
  if(msg.equals("speed") == true){
    vel = message.getInt("nivel")/10;
  }
  if(msg.equals("color") == true){
    cor = color(random(0,255),random(0,255),random(0,255));
  }
}
