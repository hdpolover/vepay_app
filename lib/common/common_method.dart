import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonMethods {
  static String formatCompleteCurrency(double price) {
    return NumberFormat.simpleCurrency(locale: "id_ID").format(price);
  }

  Future saveUserLoginsDetails(String id, String name, String email,
      String password, bool loginStatus) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", id);
    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("password", password);
    prefs.setBool("loginStatus", loginStatus);
  }
}
