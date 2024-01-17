void processetelemessage(String phone, String balance) {

  int indexofphone=tableregs.findRowIndex(phone, "phone");

  print("Phone: ", phone + " Input:"+balance);

  if ((indexofphone==-1)) {
    tableregs.setString(tableregs.getRowCount(), "phone", phone);
    tableregs.setString(tableregs.getRowCount()-1, "balance", balance);
    saveTable(tableregs, regspath);
    sendMessages("you have successfully paid "+balance+" price for ethio cemx system thank you for your payment.");
    sendSMS(phone, "you have successfully paid "+balance+" price for ethio cemx system thank you for your payment.");
  } else {
    String prebalance=tableregs.getString(indexofphone, "balance");
    int totalbalance=int(prebalance)+int(balance);
    println ("PBT: ", prebalance, balance, totalbalance);
    tableregs.setString(indexofphone, "balance", str(totalbalance));

    saveTable(tableregs, regspath);
    sendMessages("you have successfully paid "+balance+" price for ethio cem-x system and your total balance is "+str(totalbalance)+" thank you for your payment.");
    sendSMS(phone, "you have successfully paid "+balance+" price for ethio cem-x system and your total balance is "+str(totalbalance)+" thank you for your payment.");
  }
}
