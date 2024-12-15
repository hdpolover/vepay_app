import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../models/pay_transaction_model.dart';

class CommonMethods {
  static String formatCompleteCurrency(double price) {
    return NumberFormat.simpleCurrency(locale: "id_ID").format(price);
  }

  final numberFormatter = NumberFormat('#,##0', 'id_ID');
  final decimalFormatter = NumberFormat('#,##0.00', 'id_ID');
  final flexibleFormatter = NumberFormat('#,##0.##', 'id_ID');

  launchWhatsAppUri(String message) async {
    final link = WhatsAppUnilink(
      phoneNumber: '+6288296973558',
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
      String password, bool loginStatus, bool isGoogle, String fcmToken) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", id);
    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("password", password);
    prefs.setBool("loginStatus", loginStatus);
    prefs.setBool("isGoogle", isGoogle);
    prefs.setString("fcmToken", fcmToken);
  }

  String getWithdrawFieldName(String productName) {
    String name = productName.toLowerCase();
    String value = "";

    switch (name) {
      case "paypal":
      case "skrill":
      case "perfect money":
      case "neteller":
        value = "Nama Pengirim";

        break;
      case "payeer":
        value = "ID Pengirim";

        break;
      case "usdt":
      case "busd":
        value = "Hash";

        break;
      case "sol":
        value = "Hash Transaksi";

        break;
      case "airtm":
        value = "Nama Pengirim";

        break;

      case "ton":
        value = "Hash Transaksi";

        break;
      case "usdc":
        value = "Hash Transaksi";

        break;
    }

    return value;
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

      case "neteller":
        value = "Email Neteller";

        break;

      case "sol":
        value = "Address";

        break;

      case "ton":
        value = "Address";

        break;

      case "fdusd":
        value = "Address";

        break;
    }

    return value;
  }

  num parseWithComma(String value) {
    // String normalized = value.replaceAll('.', '')  // Remove thousand separators
    //                         .replaceAll(',', '.'); // Convert decimal comma to point
    return num.parse(value);
  }

  num parsePreservingTypeWithComma(String value) {
    if (value.contains('.')) {
      return parseWithComma(value);
    }
    return double.parse(value); // Remove thousand separators for integers
  }

  String formatCurrencyNum(String? rateName, num nominal,
      [bool rupiah = false]) {
    if (nominal is int) {
      return numberFormatter.format(nominal);
    } else {
      // For double, preserve original decimal places
      String original = nominal.toString();
      int decimalPlaces = original.split('.')[1].length;
      var customFormatter =
          NumberFormat('#,##0.${'#' * decimalPlaces}', 'id_ID');
      if (rateName == "SOL" || rateName == "TON") {
        return "${NumberFormat.simpleCurrency(name: "").format(nominal)} $rateName";
      } else {
        return "${rupiah ? "Rp" : "\$"}${customFormatter.format(nominal).replaceAll(".", ",")}";
      }
    }
  }

  String formatRupiahNum(num nominal) {
    if (nominal is int) {
      return "Rp${numberFormatter.format(nominal)}";
    } else {
      String original = nominal.toStringAsFixed(2);
      String numReturn =
          "Rp${NumberFormat('#,##0.00', 'id_ID').format(double.parse(original)).replaceAll(".", ",")}";
      return numReturn;
    }
  }

  String formatRupiahNumString(String nominal) {
    return formatRupiahNum(parsePreservingTypeWithComma(nominal));
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

  bool isEmail(String string) {
    // Null or empty string is invalid
    if (string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  void sendEmail(PayTransactionModel transactionModel, dynamic jumlah) async {
    String currency = '';
    String saldoYangDiterima = '';
    if (transactionModel.type!.toLowerCase() == 'withdraw') {
      currency = "\$";
      saldoYangDiterima = CommonMethods.formatCompleteCurrency(
          double.parse(transactionModel.subTotal!));
    } else {
      currency = "Rp.";
      saldoYangDiterima = "\$$jumlah";
    }

    String subject = 'Transaksi Baru #${transactionModel.kodeTransaksi}';

    // print pay transaction model detail in a loop
    for (var item in transactionModel.toJson().entries) {
      print("${item.key} : ${item.value}");
    }

    String body = "";
    if (transactionModel.product!.toLowerCase() == "vcc") {
      body =
          "Transaksi Baru #${transactionModel.kodeTransaksi}\n\nSilakan proses pesanan dengan detail sebagai berikut:\n\n${transactionModel.type}\n\nKode Transaksi: ${transactionModel.kodeTransaksi}\nProduk: ${transactionModel.product}\nNama Pengguna: ${transactionModel.name}\nTotal: $currency${double.parse(transactionModel.total!).toStringAsFixed(2)} \n\nPastikan untuk membuka website admin untuk melihat detail transaksi.";
    } else {
      body =
          "Transaksi Baru #${transactionModel.kodeTransaksi}\n\nSilakan proses pesanan dengan detail sebagai berikut:\n\n${transactionModel.type}\n\nKode Transaksi: ${transactionModel.kodeTransaksi}\nProduk: ${transactionModel.product}\nNama Pengguna: ${transactionModel.name}\nTotal: $currency${double.parse(transactionModel.total!).toStringAsFixed(2)}\nSaldo yang akan diterima: $saldoYangDiterima \n\nPastikan untuk membuka website admin untuk melihat detail transaksi.";
    }

    print(body);

    String username = 'sent@vepay.id';
    String password = 'asemjawa123';

    final smtpServer = SmtpServer('mail.vepay.id',
        allowInsecure: true, username: username, password: password);
    //final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Vepay Multipayment')
      ..recipients.add('order@vepay.id')
      //..ccRecipients.addAll(['destCc1@example.com',])
      //..bccRecipients.add(Address('hendrapolover@gmail.com'))
      ..subject = subject
      ..text = body;
    //..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.$e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
