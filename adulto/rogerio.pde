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
  Rog_conector1 = new IMGAnimation("rog_amor_#.png", 11, 1);
  Rog_conector2 = new IMGAnimation("rog_tempo_#.png", 14, 1);
  Rog_conector3 = new IMGAnimation("rog_morte_#.png", 16, 1);
  Rog_conector4 = new IMGAnimation("rog_divide_#.png", 32, 1);
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

void playRogerio(){
  //mostra imagens dos conectores
  imageMode(CENTER);
  switch(_tabletId){
    case 0:
      image(Rog_conector1.getFrame(Rog_fundo),displayWidth/2-Rog_conector1.getFrame(Rog_fundo).width/6,displayHeight/2); 
      break;
    case 1:
      image(Rog_conector2.getFrame(Rog_fundo),displayWidth/2-Rog_conector1.getFrame(Rog_fundo).width/6,displayHeight/2); 
      break;
    case 2:
      image(Rog_conector3.getFrame(Rog_fundo),displayWidth/2-Rog_conector1.getFrame(Rog_fundo).width/6,displayHeight/2); 
      break;
    case 3:
      image(Rog_conector4.getFrame(Rog_fundo),displayWidth/2-Rog_conector1.getFrame(Rog_fundo).width/6,displayHeight/2); 
      break;        
  }
  //display 4 versos por tablet  
  int shift = displayHeight/4;
  switch (_tabletId){
    case 0:     
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

void toqueRogerio(){
  if(mouseX >250 && mouseX < 400 && mouseY > 210 && mouseY < 250){ //tocou no 1º sujeito
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
    if(mouseX >250 && mouseX < 400 && mouseY > 310 && mouseY < 350){ //tocou no 2º sujeito
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
      if(mouseX >250 && mouseX < 400 && mouseY > 410 && mouseY < 450){ //tocou no 3º sujeito
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
        if(mouseX >250 && mouseX < 400 && mouseY > 510 && mouseY < 550){ //tocou no 4º sujeito
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
          if(mouseX >900 && mouseX < 1050 && mouseY > 210 && mouseY < 250){ //tocou no 1º predicado
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
            if(mouseX >900 && mouseX < 1050 && mouseY > 310 && mouseY < 350){ //tocou no 2º predicado
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
              if(mouseX >900 && mouseX < 1050 && mouseY > 410 && mouseY < 450){ //tocou no 3º predicado
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
                if(mouseX >900 && mouseX < 1050 && mouseY > 510 && mouseY < 550){ //tocou no 4º predicado
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
                  if(mouseX >500 && mouseX < 800 && mouseY > 200 && mouseY < 500){ //tocou no conector "que"
                    Rog_local = 0;
                  }
                  else
                    Rog_local = -1;
  
  //dispara áudio
  /*
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
    println("que");
    player.setMediaFile("rogque1.mp3");
    player.start();
  }     
  */
}
