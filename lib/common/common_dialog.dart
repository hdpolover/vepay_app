import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/common/global_values.dart';
import 'package:vepay_app/models/pay_transaction_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/auth/login.dart';

import '../models/referral_info_model.dart';
import '../screens/dashboard.dart';
import '../screens/referral/riwayat_referral.dart';

class CommonDialog {
  static void buildOkUpdateDialog(
      BuildContext context, bool status, String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static void buildOkReferralDialog(
      BuildContext context, bool status, String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(
                              member: currentMemberGlobal.value,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static void buildOkDialog(BuildContext context, bool status, String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static void buildOkWithdrawCashbackDialog(BuildContext context, bool status,
      String message, ReferralInfoModel referralInfoModel) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context, rootNavigator: true).pop();

                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: RiwayatReferral(
                            referralInfoModel: referralInfoModel,
                          ),
                          withNavBar: false,
                        );
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static buildConfirmationDialog(BuildContext context, String message,
      String yesStr, String noStr, dynamic funct) {
    showGeneralDialog<bool>(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.43,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                left: 32,
                right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: funct,
                      child: Text(
                        yesStr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 1.0, color: ColorManager.primary),
                          backgroundColor: Colors.transparent),
                      child: Text(noStr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: ColorManager.primary)),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  buildOkWaJasaBayarDialog(BuildContext context, bool status, String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        CommonMethods().launchWhatsAppUri(
                            "Halo, Admin.\n\nSaya ingin melakukan jasa pembayaran. Mohon bantuannya. \n\nTerima kasih.");
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  buildOkWaDialog(
      BuildContext context,
      bool status,
      String message,
      PayTransactionModel transactionModel,
      dynamic jumlah,
      String withdrawSourceType) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        String currency = '';
                        String saldoYangDiterima = '';
                        if (transactionModel.type!.toLowerCase() ==
                            'withdraw') {
                          currency = "\$";
                          saldoYangDiterima =
                              CommonMethods.formatCompleteCurrency(
                                  double.parse(transactionModel.subTotal!));

                          if (withdrawSourceType == "tab") {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          } else {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        } else {
                          currency = "Rp.";
                          saldoYangDiterima = "\$$jumlah";

                          if (transactionModel.product!.toLowerCase() ==
                              'vcc') {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          } else {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        }

                        String message = '';

                        if (transactionModel.product!.toLowerCase() == 'vcc') {
                          message =
                              "Halo, Admin.\n\nMohon proses pesanan saya dengan detail sebagai berikut:\n\n*${transactionModel.type}*\n\n*Kode Transaksi*: *${transactionModel.kodeTransaksi}*\n*Produk*: ${transactionModel.product}\n*Nama Pengguna*: ${transactionModel.name}\n*Total*: $currency${double.parse(transactionModel.total!).toStringAsFixed(2)} \n\nTerima kasih.";
                        } else {
                          message =
                              "Halo, Admin.\n\nMohon proses pesanan saya dengan detail sebagai berikut:\n\n*${transactionModel.type}*\n\n*Kode Transaksi*: *${transactionModel.kodeTransaksi}*\n*Produk*: ${transactionModel.product}\n*Nama Pengguna*: ${transactionModel.name}\n*Total*: $currency${double.parse(transactionModel.total!).toStringAsFixed(2)}\n*Saldo yang akan diterima*: $saldoYangDiterima \n\nTerima kasih.";
                        }

                        CommonMethods().launchWhatsAppUri(message);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static void buildOkRegister(
      BuildContext context, bool status, String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context, rootNavigator: true).pop();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static void buildWrongWithAuth(
      BuildContext context, bool status, String message) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                status
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: ColorManager.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 213,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: ColorManager.primary),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => Login(),
                          ),
                        );
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showLoading(BuildContext context) {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: ColorManager.primary,
                  ),
                  const SizedBox(height: 15),
                  const Text("Menyambungkan")
                ],
              ),
            ),
          );
        });
  }
}
