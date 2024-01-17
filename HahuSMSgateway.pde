import java.net.URL;
import java.net.URLEncoder;
import java.net.HttpURLConnection;

void sendSMS (String phoneNumber, String message) {
  String mode = "devices";
  String SIM = "1";
  String priority = "1";
  String url = "";

  try {
    url = "https://hahu.io/api/send/sms?"
      + "&secret=" + APIkey
      + "&mode=" + mode
      + "&phone=" + phoneNumber
      + "&device=" + deviceID
      + "&sim=" + SIM
      + "&priority=" + priority
      + "&message=" + URLEncoder.encode(message, "UTF-8");
  } 
  catch (Exception e) {
    println (e);
    return;
  }
  
  println (url);

  try {
    URL obj = new URL(url);
    HttpURLConnection con = (HttpURLConnection) obj.openConnection();
    con.setRequestMethod("GET");
    con.setRequestProperty("User-Agent", "Mozilla/5.0");

    int responseCode = con.getResponseCode();

    println (responseCode);
  } 
  catch (Exception e) {
    println (e);
  }
}
