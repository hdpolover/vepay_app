import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CommonMethods {
  static String formatCompleteCurrency(double price) {
    return NumberFormat.simpleCurrency(locale: "id_ID").format(price);
  }

  launchWhatsAppUri(String message) async {
    final link = WhatsAppUnilink(
      phoneNumber: '+6285646637990',
      text: message,
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launchUrl(
      link.asUri(),
      mode: LaunchMode.externalNonBrowserApplication,
    );
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

  String getFieldName(String productName) {
    String name = productName.toLowerCase();
    String value = "";

    switch (name) {
      case "paypal":
        value = "Email PayPal";
        break;

      case "skrill":
        value = "Email Skrill";

        break;
      case "perfect money":
        value = "No. UID";

        break;
      case "payeer":
        value = "ID Payeer";

        break;
      case "usdt":
        value = "Address";

        break;

      case "busd":
        value = "Address";

        break;
    }

    return value;
  }

  String formatDate(String d, String type) {
    String dat = "";

    switch (type) {
      case "s":
        dat = DateFormat.yMMMd("id_ID").format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(d) * 1000,
          ),
        );
        break;
      case "l":
        dat = DateFormat.yMMMMEEEEd("id_ID").format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(d) * 1000,
          ),
        );
        break;
      case "d":
        dat = "${DateFormat.yMMMMd("id_ID").format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(d) * 1000,
          ),
        )} ${DateFormat.Hm("id_ID").format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(d) * 1000,
          ),
        )} WIB";
        break;
    }

    return dat;
  }

  String getStatusLabel(int status) {
    String value = "";
    switch (status) {
      case 1:
        value = "Diproses";
        break;
      case 2:
        value = "Berhasil";
        break;
      case 3:
        value = "Ditolak";
        break;
      case 4:
        value = "Gagal";
        break;
    }

    return value;
  }
}
