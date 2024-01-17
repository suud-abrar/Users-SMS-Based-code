String place;
String typeofcement;
String branch;
String typeoffactory;
String amount;
String price="";
int Tprice;
String date= month()+"/"+(day()+7)+"/"+year();
String transaction="s";
String  data[] ;
int indexphone;
String lastState;
int tolalamount;
int monthlyamount;
String TP;
import static  javax.swing.JOptionPane.*;
import org.apache.commons.lang3.RandomStringUtils;
import java.time.LocalDate;
String todayStr = year () + "-" + (month () < 10? 0 + "" + month () : month ()) + "-" + (day () < 10? 0 + "" + day () : day ());
LocalDate today = LocalDate.parse (todayStr);
String path1="C:/Users/Win 10 Pro/Documents/Processing/factory.csv";
String path2="C:/Users/Win 10 Pro/Documents/Processing/factory2.csv";
String path3="C:/Users/Win 10 Pro/Documents/Processing/factorydata.csv";
String userpath="C:/Users/Win 10 Pro/Documents/Processing/Usersdata.csv";
String regpath="C:/Users/Win 10 Pro/Documents/Processing/reg.csv";
String snspath="C:/Users/Win 10 Pro/Documents/Processing/snstin.csv";
Table table1;
Table table2;
Table table3;
Table tableuserdata;
Table tablereg;
Table tableorder;
String STATE_PLACE ="Place";
String STATE_TYPE_OF_CEMENT= "Type of cement";
String STATE_TYPE_OF_FACTORY = "Type of factory";
String STATE_AMOUNT ="Amount";
String STATE_TRANSACTION_NUMBER="Transaction Number";
String STATE_TRANSACTION_NUMBER2="Transaction Number2";
String STATE_BRANCH="branch";
void processUserInput(String input, String phone) {
  data = getHeaders (path3);
  tableuserdata=loadTable(userpath, "header");
  indexphone=tableuserdata.findRowIndex(phone, 0);
  table1=loadTable(path1, "header");
  table2=loadTable(path2, "header");
  table3=loadTable(path3, "header");
  tablereg=loadTable(regpath, "header");
  Table tablesns=loadTable(snspath, "header");
  Table tablereg=loadTable(regpath, "header");
  int indexreg=tablereg.findRowIndex(phone, 0);
  println ("indexReg: ", indexreg);
  String laststated="";
  if (!(indexreg==-1)) {
    laststated= tablereg.getString(indexreg, "state");
  }
  if (indexreg==-1) {
    //showMessageDialog(null, "1.register");
    sendMessage(phone, "1.register");
    sendSMS (phone, "1.register");
    println ("Registering phone number");
    tablereg.setString(tablereg.getRowCount(), "state", "reg");
    tablereg.setString(tablereg.getRowCount()-1, "phone", phone);
    tablereg.setString(tablereg.getRowCount()-1, "balance", str(0));
    saveTable(tablereg, regpath);
    indexreg=tablereg.findRowIndex(phone, 0);
  } else if (laststated.equals("reg")) {
    if (input.equals("1")) {
      //showMessageDialog(null, "enter your name");
      sendMessage(phone, "enter your name");
      sendSMS (phone, "enter your name");
      tablereg.setString(indexreg, "state", "name");
      saveTable(tablereg, regpath);
    } else {
      sendSMS (phone, "1.register");
    }
  } else if (laststated.equals("name")) {
    tablereg.setString(indexreg, "name", input);
    // showMessageDialog(null, "enter your TIN number");
    sendMessage(phone, "enter your TIN number");
    sendSMS (phone, "enter your TIN number");
    tablereg.setString(indexreg, "state", "tin");
    saveTable(tablereg, regpath);
  } else if (laststated.equals("tin")) {
    String tinnumber;
    String tin=input;
    for (int n=0; n<tablesns.getRowCount(); n++) {
      tinnumber=tablesns.getString(n, "Tin Numbers"); 
      if (input.equals(tinnumber)) {
        String typejob=tablesns.getString(n, "Type");
        if (typejob.equals("contracter")||typejob.equals("supplier")) {
          tablereg.setString(indexreg, "job", typejob);
          tablereg.setString(indexreg, "phone", phone);
          saveTable(tablereg, regpath);
          String  code = RandomStringUtils.randomAlphanumeric (10).toUpperCase ();
          tablereg.setString(indexreg, "code", code);
          String phoneN=tablesns.getString(n, "phone");
          String subphoneN=phoneN.substring(1, phoneN.length());
          saveTable(tablereg, regpath);
          sendMessage(phoneN, "verification code "+code);
          sendSMS (phoneN, "Verification code "+code);
          sendMessage(phone, "send as the verification code we have sent you");
          sendSMS (phone, "Send as the verification code we have sent you");
          tablereg.setString(indexreg, "state", "verification");
          saveTable(tablereg, regpath);
          break;
        } else {
          // showMessageDialog(null, "your profasion is missmatched with this system");
          sendMessage(phone, "your profasion is missmatched with this system");
          sendSMS (phone, "Your profasion is missmatched with this system,you can't use the system");
          break;
        }
      } else if (n==tablesns.getRowCount()-1) {
        if (!(tin.equals(tablesns.getString(tablesns.getRowCount()-1, "Tin Numbers")))) {
          // showMessageDialog(null, "the TIN that you entered does not exesite");
          sendSMS (phone, "The TIN that you entered does not existe,Please send again");
        }
      }
    }
  } else if (laststated.equals("verification")) {         
    // showMessageDialog(null, "thank you for your registration");
    String  code= tablereg.getString(indexreg, "code");
    print(input.equals(code));
    if (input.equals(code)) {
      sendMessage(phone, "thank you for your registration");
      sendSMS (phone, "Thank you for your registration");
      tablereg.setString(indexreg, "state", "finished");
      saveTable(tablereg, regpath);
      sendMessage(phone, "to purchase enter ok");
      sendSMS (phone, "To purchase enter ok");
    } else {
      sendSMS (phone, "Invalid verification code,please send us gain");
    }
  }             
  lastState = indexphone == -1? "" : tableuserdata.getString(tableuserdata.getRowCount()-1, "State");
  if (!(indexreg==-1)&&laststated.equals("finished")&&(indexphone==-1||lastState.equals(STATE_TRANSACTION_NUMBER))) {
    newuser(phone);
  } else if (lastState.equals(STATE_TRANSACTION_NUMBER2)) {
    place(input);
  } else if (lastState.equals(STATE_PLACE)) {
    typeofcementorbranch(input);
  } else if (lastState.equals(STATE_BRANCH)) {
    typeofcement(input);
  } else if (lastState.equals(STATE_TYPE_OF_CEMENT)) {
    typeoffactory(input);
  } else if (lastState.equals(STATE_TYPE_OF_FACTORY)) {
    amount(input);
  }
}

void newuser(String phone) {
  tableuserdata.setString(tableuserdata.getRowCount(), "phone", phone);
  print("hi"+phone);
  saveTable(tableuserdata, userpath);
  indexphone=tableuserdata.getRowCount()-1;
  //showMessageDialog(null, "Please select the place from where you want to take the cement\n1.Factory\n2.Suppliers");
  sendMessage(phone, "Please select the place from where you want to take the cement\n1.Factory\n2.Suppliers");
  sendSMS (phone, "Please select the place from where you want to take the cement\n1.Factory\n2.Suppliers");
  saveState (STATE_TRANSACTION_NUMBER2);
}
void place(String inputs) {
  String getrows[]=getrowheader(table1);
  indexphone=tableuserdata.getRowCount()-1;
  place=inputs;
  if (place.equals("1")) {
    tableuserdata.setString(indexphone, "Factoryp", "factory");
    saveTable(tableuserdata, userpath);
    saveState ( STATE_PLACE);
    // showMessageDialog(null, "please select the type of cement\n1.PPC\n2.OPC\n#.Back to the first page");
    sendMessage(phone, "please select the type of cement\n1.PPC\n2.OPC\n#.Back to the first page");
    sendSMS (phone, "please select the type of cement\n1.PPC\n2.OPC\n#.Back to the first page");
  } else  if (place.equals("2")) {
    tableuserdata.setString(indexphone, "Factoryp", "supplier");
    saveTable(tableuserdata, userpath);
    saveState ( STATE_PLACE);
    // showMessageDialog(null, getrows+"\n#.Back to the first page");
    sendMessage(phone, "Please select the branch\n"+join(getrows, "\n")+"\n#.Back to the first page");
    sendSMS (phone, "Please select the branch\n"+join(getrows, "\n")+"\n#.Back to the first page");
  }
}  
void typeofcementorbranch(String inputs) {
  indexphone=tableuserdata.getRowCount()-1;
  if (tableuserdata.getString(indexphone, "Factoryp").equals( "factory")) {
    typeofcement=inputs;
    if (lastState.equals(STATE_PLACE)) {
      if (typeofcement.equals("1")) {
        tableuserdata.setString(indexphone, "Type of cement", "ppc");
        saveTable(tableuserdata, userpath);
        //tableorder.setString();
        saveState(STATE_TYPE_OF_CEMENT );
        //  showMessageDialog(frame, data);
        sendMessage(phone, join ( data, "\n")+"\n#.Back to the first page");
        sendSMS (phone,  "Please select the type of the factory"+join ( data, "\n")+"\n#.Back to the first page");
      } else if (typeofcement.equals("2")) {
        tableuserdata.setString(indexphone, "Type of cement", "opc");
        saveTable(tableuserdata, userpath);
        saveState(STATE_TYPE_OF_CEMENT );
        // showMessageDialog(frame, data+"\n#.Back to the first page");
        sendMessage(phone, join( data, "\n")+"\n#.Back to the first page");
        sendSMS (phone,  "Please select the type of the factory"+ join ( data, "\n")+"\n#.Back to the first page");
      }
      if (typeofcement.equals("#")) {
        saveState(STATE_TRANSACTION_NUMBER);
      }
    }
  } else if (tableuserdata.getString(indexphone, "Factoryp").equals( "supplier")) {
    branch=inputs;
    if (int(branch)>=1&&int(branch)<=table1.getRowCount()) {
      tableuserdata.setString(indexphone, "supplierp", table1.getString(int(branch)-1, "PPC"));
      saveTable(tableuserdata, userpath);
      saveState(STATE_BRANCH);
      //   showMessageDialog(null, "please select the type of cement\n1.PPC\n2.OPC\n#.Back to the first page");
      sendMessage(phone, "please select the type of cement\n1.PPC\n2.OPC\n#.Back to the first page");
      sendSMS (phone, "please select the type of cement\n1.PPC\n2.OPC\n#.Back to the first page");
    }
    if (branch.equals("#")) {
      saveState(STATE_TRANSACTION_NUMBER);
    }
  }
}
void typeofcement(String inputs) {
  indexphone=tableuserdata.getRowCount()-1;
  typeofcement=inputs;
  if (typeofcement.equals("1")) {
    tableuserdata.setString(indexphone, "Type of cement", "ppc");
    saveTable(tableuserdata, userpath);
    saveState(STATE_TYPE_OF_CEMENT );
    // showMessageDialog(null, data+"\n#.Back to the first page");
    sendMessage(phone, join( data, "\n")+"\n#.Back to the first page");
    sendSMS (phone,  "Please select the type of the factory"+ join( data, "\n")+"\n#.Back to the first page");
  } else if (typeofcement.equals("2")) {
    tableuserdata.setString(indexphone, "Type of cement", "opc");
    saveTable(tableuserdata, userpath);
    saveState(STATE_TYPE_OF_CEMENT );
    // showMessageDialog(null, data+"\n#.Back to the first page");
    sendMessage(phone, join( data, "\n")+"\n#.Back to the first page");
    sendSMS (phone,  "Please select the type of the factory"+ join( data, "\n")+"\n#.Back to the first page");
  }
  if (typeofcement.equals("#")) {
    saveState(STATE_TRANSACTION_NUMBER);
  }
}
void typeoffactory(String inputs) {
  indexphone=tableuserdata.getRowCount()-1;
  typeoffactory =inputs;
  String contents[]=loadStrings(path3);
  String a=contents[0];
  String places[]=split(a, ",");
  if (int(typeoffactory)>=1&&int(typeoffactory)<places.length) {
    saveState( STATE_TYPE_OF_FACTORY);
    tableuserdata.setString(indexphone, "Type of factory", places[int(typeoffactory)]);
    saveTable(tableuserdata, userpath);
    // showMessageDialog(null, "Enter the amount of Cement you want (in quintal).\n You can only enter 100-1000 (quintal)\n#.Back to the first page");
    sendMessage(phone, "Enter the amount of Cement you want (in quintal).\n You can only enter 100-1000 (quintal)\n#.Back to the first page");
    sendSMS (phone, "Enter the amount of Cement you want (in quintal).\n You can only enter 100-1000 (quintal)\n#.Back to the first page");
  }
  if (typeoffactory.equals("#")) {
    saveState(STATE_TRANSACTION_NUMBER);
  }
}
void amount(String inputs) {
  amount=inputs;
  tableuserdata.setString(indexphone, "Time", time());
  tableuserdata.setString(indexphone, "date", date());
  saveTable(tableuserdata, userpath);
  String times =day()+"/"+month()+"/"+year();
  String last30Days [] = new String [0];
  last30Days=append(last30Days, times);
  int index=0;
  for (int x=0; x<30; x++) {
    today = today.minusDays (1);
    last30Days = append (last30Days, today.getDayOfMonth() + "/" + today.getMonthValue () + "/" + today.getYear ());
  }
  for (int x=last30Days.length-1; x>=0; x--) {
    if (!(tableuserdata.findRowIndex( last30Days[x], "date")==-1)&&tableuserdata.getString(tableuserdata.findRowIndex( last30Days[x], "date"), "phone").equals(phone)) {
      index=tableuserdata.findRowIndex( last30Days[x], "date");
      break;
    }
  }
  for (int x=index; x<tableuserdata.getRowCount(); x++) {
    if (tableuserdata.getString(x, "phone").equals(phone)) {
      String prevamount=tableuserdata.getString(x, "Amount");
      monthlyamount+=int(prevamount);
    }
  }
  monthlyamount+=int(amount);
  indexphone=tableuserdata.getRowCount()-1;
  if (monthlyamount<10000&&int(amount)>100) {
    int indexofreg=tablereg.findRowIndex(phone, "phone");
    println ("Phone:", phone);
    String storebalance=tablereg.getString(indexofreg, "balance");
    tableuserdata.setString(indexphone, "Amount", amount);  
    saveTable(tableuserdata, userpath);
    Tprice = prices(amount);
    if (int(storebalance)>=Tprice) {
      Tprice = prices(amount); 
      tableuserdata.setString(indexphone, "Total price", str(Tprice));
      saveTable(tableuserdata, userpath);
      TP=tableuserdata.getString(indexphone, "Total price");
      String AMOUNT=tableuserdata.getString(indexphone, "Amount");
      storebalance=tablereg.getString(indexofreg, "balance");
      int remainingstore=int(storebalance)-int(TP);
      tablereg.setString(indexofreg, "balance", str(remainingstore));
      saveTable(tablereg, regpath);
      // showMessageDialog(frame, "Dear customer you have succesfully paied "+TP+" for "+AMOUNT+" amount to our acount.\n"+"We will notify you when your requirement is ready!\n Thank you for Using Ethio-Digital-Cement system.");
      // showMessageDialog(frame, "You can take the cement from its factory using "+code+" code on "+date+" Thank you for Using Ethio-Digital-Cement system.");
      sendMessage(phone, "Dear customer you have succesfully paied "+TP+" for "+AMOUNT+" amount to our acount.\n"+"We will notify you when your requirement is ready!\n Thank you for Using Ethio-Digital-Cement system.");
      sendSMS (phone, "Dear customer you have succesfully paied "+TP+" for "+AMOUNT+" amount to our acount.\n"+"We will notify you when your requirement is ready!\n Thank you for Using Ethio-Digital-Cement system.");
      // sendMessage(phone, "You can take the cement from its factory using "+code+" code on "+date+" Thank you for Using Ethio-Digital-Cement system.");
      saveState(STATE_TRANSACTION_NUMBER);
      sendMessage(phone, "to purchase again enter ok");
      sendSMS (phone, "to purchase again enter ok");
      typeoffactory=tableuserdata.getString(indexphone, "Type of factory");
      String orderpath="C:/Users/Win 10 Pro/Documents/Processing/orders/"+typeoffactory+".csv";
      tableorder=loadTable(orderpath, "header");

      Table temp=new Table();
      TableRow newRow=temp.addRow();
      newRow.setString(0, "type");
      newRow.setString(1, "amount");
      newRow.setString(2, "time");
      newRow.setString(3, "state");
      newRow.setString(4, "code");
      newRow.setString(5, "date");
      newRow.setString(6, "phone");
      newRow=temp.addRow();
      typeofcement= tableuserdata.getString(indexphone, "Type of cement");
      amount= tableuserdata.getString(indexphone, "Amount");
      String  code = RandomStringUtils.randomAlphanumeric (10).toUpperCase ();
      tableuserdata.setString(indexphone, "code", code);
      newRow.setString(0, typeofcement);
      newRow.setString(1, amount);
      newRow.setString(2, time()+","+date());
      newRow.setString(3, "Waiting");
      newRow.setString(4, code);
      newRow.setString(5, date());
      newRow.setString(6, "_"+phone);
      print(phone);
      for (int x=0; x<tableorder.getRowCount(); x++) {
        newRow=temp.addRow();
        newRow.setString(0, tableorder.getString(x, "type"));
        newRow.setString(1, tableorder.getString(x, "amount"));
        newRow.setString(2, tableorder.getString(x, "time"));
        newRow.setString(3, tableorder.getString(x, "state"));
        newRow.setString(4, tableorder.getString(x, "code"));
        newRow.setString(5, tableorder.getString(x, "date"));
        newRow.setString(6, tableorder.getString(x, "phone"));
      }

      tableorder=temp; 
      saveTable(tableorder, orderpath);
    } else {  
      int remainebalance=Tprice-int(storebalance);
      String AMOUNT=tableuserdata.getString(indexphone, "Amount");
      storebalance=tablereg.getString(indexofreg, "balance");
      // showMessageDialog(null, "the total price for "+AMOUNT+" amount of cement is "+str(Tprice)+ " you can not purchase, your total balance is "+storebalance+" please charge the remain ("+remainebalance+") balance");
      sendMessage(phone, "the total price for "+AMOUNT+" amount of cement is "+str(Tprice)+ " you can not purchase, your total balance is "+storebalance+" please charge the remain ("+remainebalance+") balance by using 094784 and send again the amount");
      sendSMS (phone, "the total price for "+AMOUNT+" amount of cement is "+str(Tprice)+ " you can not purchase, your total balance is "+storebalance+" please charge the remain ("+remainebalance+") balance by using 0947853943 and send again the amount");
    }
  } else if (int(amount)>=1000||int(amount)<=100||monthlyamount>=1000) {
    // showMessageDialog(null, "you can not purchase this amount at this time\nplease enter the right amount\n or it is beyond the permitted amount\n#.Back to the first page");
    sendMessage(phone, "you can not purchase this amount at this time\nplease enter the right amount\n or it is beyond the permitted amount\n#.Back to the first page");
    sendSMS (phone, "you can not purchase this amount at this time\nplease enter the right amount\n or it is beyond the permitted amount\n#.Back to the first page");
    tableuserdata.setString(indexphone, "Time", time());
    tableuserdata.setString(indexphone, "date", date());
    saveTable(tableuserdata, userpath);
  }
}

void saveState (String states) {
  tableuserdata.setString(indexphone, "State", states);
  saveTable(tableuserdata, userpath);
  lastState=states;
}
String [] getHeaders (String paths) {
  String headers [] = new String [0];

  String contents[]=loadStrings(paths);
  String a=contents[0];
  String places[]=split(a, ",");
  for (int x=1; x<places.length; x++) {
    String head=str(x)+"."+places[x];
    headers=append(headers, head);
  }
  return headers;
}
String []getrowheader(Table table) {
  String rowheader[]=new String [0];
  for (int x=0; x<table.getRowCount(); x++) {
    String dat=str(x+1)+"."+table1.getString(x, "PPC");
    rowheader=append(rowheader, dat);
  }    
  return rowheader;
}
int prices(String amount) {
  int indexof_f= table3.getColumnIndex( tableuserdata.getString(indexphone, "Type of factory"));
  if (tableuserdata.getString(indexphone, "Factoryp").equals("factory")&& tableuserdata.getString(indexphone, "Type of cement").equals( "ppc")) {
    price=table3.getString(0, indexof_f);
    Tprice=int(price)*int(tableuserdata.getString(indexphone, "Amount"));
  } else if (tableuserdata.getString(indexphone, "Factoryp").equals("factory")&& tableuserdata.getString(indexphone, "Type of cement").equals( "opc")) {
    price=table3.getString(1, indexof_f);
    Tprice=int(price)*int(tableuserdata.getString(indexphone, "Amount"));
  } else if (tableuserdata.getString(indexphone, "Factoryp").equals("supplier")&&tableuserdata.getString(indexphone, "Type of cement").equals( "ppc")) {
    int indexof_b=table1.findRowIndex(tableuserdata.getString(indexphone, "supplierp"), 0);
    price=table1.getString(indexof_b, tableuserdata.getString(indexphone, "Type of factory"));
    Tprice=int(price)*int(tableuserdata.getString(indexphone, "Amount"));
  } else if (tableuserdata.getString(indexphone, "Factoryp").equals("supplier")&&tableuserdata.getString(indexphone, "Type of cement").equals( "opc")) {

    int indexof_b=table2.findRowIndex( tableuserdata.getString(indexphone, "supplierp"), 0);
    price=table2.getString(indexof_b, tableuserdata.getString(indexphone, "Type of factory"));
    Tprice=int(price)*int(tableuserdata.getString(indexphone, "Amount"));
  }
  return Tprice;
}
String  time() {
  String times=hour()+":"+minute()+":"+second();
  return times;
}
String date() {
  String times =day()+"-"+month()+"-"+year();
  return times;
}
