import 'package:shared_preferences/shared_preferences.dart';

class SHP {
  static String userloggedinkey = "USERLOGGEDIN";
  static String usernamekey = "USERNAMEKEY";
  static String emailkey = "USEREMAILKEY";

  // saving data to shared prefs
  static Future<bool?> saveusernameSP(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(usernamekey, username);
  }

  static Future<bool?> saveEmailSP(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(emailkey, userEmail);
  }

  static Future<bool?> saveUserLoggedinStatusSP(bool? loggedin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userloggedinkey, loggedin!);
  }



  //-----------------------getting data from shared prefs--------------------------------------------------------
  
  static Future<bool?> getUserLoggedinStatusSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(userloggedinkey);
  }

  static Future<String?> getUserEmailSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailkey);
  }

  static Future<String?> getUserNameSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernamekey);
  }
}
