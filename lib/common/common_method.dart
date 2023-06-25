import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../models/pay_transaction_model.dart';

class CommonMethods {
  static String formatCompleteCurrency(double price) {
    return NumberFormat.simpleCurrency(locale: "id_ID").format(price);
  }

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
      String password, bool loginStatus, bool isGoogle) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", id);
    prefs.setString("name", name);
    prefs.setString("email", email);
    prefs.setString("password", password);
    prefs.setBool("loginStatus", loginStatus);
    prefs.setBool("isGoogle", isGoogle);
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

  bool isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
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

    String body =
        "Transaksi Baru #${transactionModel.kodeTransaksi}\n\nSilakan proses pesanan dengan detail sebagai berikut:\n\n${transactionModel.type}\n\nKode Transaksi: ${transactionModel.kodeTransaksi}\nProduk: ${transactionModel.product}\nNama Pengguna: ${transactionModel.name}\nTotal: $currency${double.parse(transactionModel.total!).toStringAsFixed(2)}\nSaldo yang akan diterima: $saldoYangDiterima \n\nPastikan untuk membuka website admin untuk melihat detail transaksi.";

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
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
