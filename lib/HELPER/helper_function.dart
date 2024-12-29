import 'package:resume/CONST/string_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  // SAVING THE DATA TO SHARED PREFERENCES
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(USERLOGGEDINKEY, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(USERNAMEKEY, userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(USEREMAILKEY, userEmail);
  }

  // GETTING THE DATA TO SHARED PREFERENCES

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getBool(USERLOGGEDINKEY);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(USERNAMEKEY);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(USEREMAILKEY);
  }
}
