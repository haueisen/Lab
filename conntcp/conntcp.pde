JSONTCPClient _client;
 
void setup() { 
  size(200, 200);
  
  _client = new JSONTCPClient("192.168.0.200", 8765);
} 
 
void draw() { 
  if(_client.numMessages() > 0){
    JSONObject j = _client.getNextMessage();
    processMessage(j);
  }
}

void mousePressed(){
  JSONObject j = new JSONObject();
  j.setString("Teste","Alguém ai?");
  _client.sendJSON(j);
}

void processMessage(JSONObject message){

  print(message);
}

