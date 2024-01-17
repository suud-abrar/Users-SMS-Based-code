import static  javax.swing.JOptionPane.*;
String userdatapath="C:/Users/Win 10 Pro/Documents/Processing/Messages/Received SMS.txt";
String userdatapath2="C:/Users/Win 10 Pro/Documents/Processing/userdata2.txt";
String regspath="C:/Users/Win 10 Pro/Documents/Processing/reg.csv";
String telepath="C:/Users/Win 10 Pro/Documents/Processing/Messages/Telebirr Transaction Details.txt";
String telepath2="C:/Users/Win 10 Pro/Documents/Processing/teledata2.txt";
Table tableregs;
StringList processedMessage;
StringList noprocesseMessage;
StringList storedMessages;
StringList nonstoredMessages;
String phone;
Periodically checkNewMessagePeriod;
String APIkey = "b5cd43c2f8936c2a2de43580c45eacbf3d3e8ed8";
String deviceID = "00000000-0000-0000-dfe3-341b2fc781fc";
void setup () {
  checkNewMessagePeriod = new Periodically (1000);
  handleUsersInputs ();
  teleUsersInputs ();
}


void draw () {
  if (checkNewMessagePeriod.itsTime ()) {
    handleUsersInputs ();
    teleUsersInputs ();

    print ("*");
  }
}

void sendMessage(String phone, String message) {
  println(phone, message);
}
void sendMessages(String messages) {
  println( messages);
}
void handleUsersInputs () {
  storedMessages = new StringList ();
  String oldM [] = loadStrings (userdatapath2);  
  for (int x=0; x<oldM.length; x++) {
    storedMessages.append (oldM [x]);
  }

  nonstoredMessages = new StringList ();
  String newM [] = loadStrings (userdatapath);
  for (int i=0; i<newM.length; i++) {
    nonstoredMessages.append (newM[i]);
  }

  for (int a = 0; a < nonstoredMessages.size (); a ++) {
    String nonstoredMessage = nonstoredMessages.get(a);
    if (!(storedMessages.hasValue (nonstoredMessage))) {
      oldM = append (oldM, nonstoredMessage);
      String []Message=split(nonstoredMessage, ",");
      printArray(Message);
      phone=Message[1];
      String input=Message[2];
      println("Phone: ", phone, " Input: "+input);
      processUserInput (input, phone);
    }
  }
  saveStrings (userdatapath2, oldM);
}
void   teleUsersInputs () {

  tableregs=loadTable(regspath, "header");

  processedMessage = new StringList ();
  String oldM [] = loadStrings (telepath2);  
  for (int x=0; x<oldM.length; x++) {
    processedMessage.append (oldM [x]);
  }

  noprocesseMessage = new StringList ();
  String newM [] = loadStrings (telepath);
  for (int i=0; i<newM.length; i++) {
    noprocesseMessage.append (newM[i]);
  }

  for (int a = 0; a < noprocesseMessage.size (); a ++) {
    String  noprocesseMessaged = noprocesseMessage.get(a);
    if (!(processedMessage.hasValue (noprocesseMessaged))) {
      oldM = append (oldM, noprocesseMessaged);
      String []Message=split(noprocesseMessaged, ",");
      String phone=Message[1];
      String balance=Message[3];
      processetelemessage(phone, balance);
    }
  }
  saveStrings (telepath2, oldM);
}
