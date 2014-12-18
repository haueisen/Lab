import netP5.*;

/**
 * JSONTCPClient creates a TCP client based on netp5/oscp5 library to exchange data formatted as JSON-encoded strings.
 * @author Lucas Junqueira <lucas@ciclope.art.br>
 * @version 2014-12-10
 */
public class JSONTCPClient {
  
  /**
   * The server address.
   */
  private String _server;
  
  /**
   * The server port.
   */
  private int _port;
  
  /**
   * The received messages waiting to be processed (JSONObject array).
   */
  private ArrayList<JSONObject> _messages = new ArrayList<JSONObject>();
  
  /**
   * The netp5-based tcp client.
   */
  private TcpClient _client;
  
  /**
   * JSONTCPClient constructor.
   * @param server The server address.
   * @param port The server port for connection.
   */
  public JSONTCPClient(String server, int port) {
    // get start values
    this._server = server;
    this._port = port;
    // try to connect
    this._client = new TcpClient(this, this._server, this._port);
  }
  
  /**
   * Is the server connected?
   * @return True if the object is connected to a server, false otherwise.
   */
  public boolean isConnected() {
    if (this._client != null) {
     if (this._client.socket() == null) {
        return (false);
      } else {
        return (true);
      }
    } else {
      return (false);
    }
  }
  
  /**
   * Assign a different server for connection.
   * @param server The server address.
   * @param port The server port for connection.
   */
  public void setServer(String server, int port) {
    if (this._client != null) {
      this._client.dispose();
      this._client = null;
    }
    this._server = server;
    this._port = port;
    this._client = new TcpClient(this, this._server, this._port);
  }
  
  /**
   * Retry server connection.
   */
  public void reconnect() {
    if (this._client != null) {
     if (this._client.socket() == null) {
        this._client.reconnect();
      }
    } else {
      this._client = new TcpClient(this, this._server, this._port);
    }
  }
  
  /**
   * Get the number of available messages to be processed.
   * @return The number of messages waiting to be processed.
   */
  public int numMessages() {
    return (this._messages.size());
  }
  
  /**
   * Clear the received messages array.
   */
  public void clearMessages() {
    this._messages.clear();
  }
  
  /**
   * Get the next available message for processing and remove it from the messages array.
   * @return A message to be processed or null if there is none at the list.
   */
  public JSONObject getNextMessage() {
    if (this._messages.size() > 0) {
      JSONObject ret = this._messages.get(0);
      this._messages.remove(0);
      return (ret);

    } else {
      return (null);
    }
  }
  
  /**
   * Send a single string to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, String value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setString(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a single int to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, int value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setInt(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a single float to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, float value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setFloat(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a single boolean to the server (automatically prepares a JSON object with a single variable).
   * @param name The variable name to send.
   * @param value The variable value to send.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendSingle(String name, boolean value) {
    if (this.isConnected()) {
      JSONObject json = new JSONObject();
      json.setBoolean(name, value);
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Send a full JSON object to the server.
   * @param json The JSON object.
   * @return True if the server is connected, false otherwise.
   */
  public boolean sendJSON(JSONObject json) {
    if (this.isConnected()) {
      this._client.send(json.toString());
      return (true);
    } else {
      return (false);
    }
  }
  
  /**
   * Release object resources.
   */
  public void dispose() {
    this._server = null;
    this._messages.clear();
    this._messages = null;
    if (this._client != null) {
      this._client.dispose();
    }
    this._client = null;
  }
  
  /**
   * A string representation of the object.
   * @return The string representation.
   */
  public String toString() {
    if (this.isConnected()) {
      return("JSONTCPClient: " + this._server + ":" + this._port + "; messages: " + this._messages.size());
    } else {
      return("JSONTCPClient not connected. Waiting for " + this._server + ":" + this._port + ".");
    }
  }
  
  /**
   * Event automatically called when a message is received from server.
   * @param theMessage The received message.
   */
  private void netEvent(NetMessage theMessage) {
    JSONObject incoming = JSONObject.parse(theMessage.getString());
    if (incoming != null) {
      this._messages.add(incoming);
    }
  }
  
}
