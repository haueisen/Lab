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

void playPablo(){
  //playerTrilhas.setMediaFile("Pablo_Gobira.mp3");
  //playerTrilhas.start();
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

void toquePablo(){
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
