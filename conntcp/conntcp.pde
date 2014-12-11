import netP5.*;

TcpClient myClient; 
int dataIn;
JSONObject json;

JSONTCPClient _client;
 
void setup() { 
  size(200, 200);
  
  _client = new JSONTCPClient("127.0.0.1", 8765);
  
  
  println("client: " + _client.toString());
  
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  //myClient = new TcpClient(this, "127.0.0.1", 8765);
 //json = new JSONObject();
 //json.setInt("id", 0);
  //json.setString("species", "Panthera leo");
  //json.setString("name", "Lion");
  //println("start");
} 
 
void draw() { 
  //if (mousePressed) {
   // myClient.send(json.toString());
  //}
}

void onMessage() {
  println("onMessage");
}

void netEvent(NetMessage theMessage) {
  //JSONObject myjson = JSONObject.parse(theMessage.getString());
  //println(myjson.toString());
}


