import 'dart:convert';
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/pay_transaction_model.dart';
import 'package:vepay_app/models/transaction_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/services/transaction_service.dart';

import '../../common/common_method.dart';

class PaymentDetail extends StatefulWidget {
  Map<String, dynamic> trData;
  TransactionModel transactionModel;
  PaymentDetail(
      {required this.trData, required this.transactionModel, Key? key})
      : super(key: key);

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  bool isLoading = false;

  TextEditingController fieldController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  XFile? _imageFile;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  buildTextItem(String title, String value, bool isToCopy) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Text(title)),
        Expanded(
            child: Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.bold),
        )),
        isToCopy
            ? InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Berhasil menyalin text ke clipboard")));
                  });
                },
                child: Icon(
                  Icons.copy,
                  size: 17,
                  color: ColorManager.primary,
                ),
              )
            : Container()
      ],
    );
  }

  buildTopSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FancyShimmerImage(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.06,
                        boxFit: BoxFit.cover,
                        imageUrl: widget.transactionModel.imgMethod!,
                        errorWidget: Image.network(
                            'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.transactionModel.metode!,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 17,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              const SizedBox(height: 10),
              buildTextItem("ID Pembayaran",
                  widget.transactionModel.kodeTransaksi!, false),
              const SizedBox(height: 10),
              buildTextItem(
                  "Tanggal",
                  CommonMethods()
                      .formatDate(widget.transactionModel.createdAt!, "l"),
                  false),
            ],
          ),
        ),
      ),
    );
  }

  buildDetailSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.24,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detail Pembayaran",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              buildTextItem2(
                "Subtotal Tagihan",
                CommonMethods.formatCompleteCurrency(
                  double.parse(widget.transactionModel.subTotal!),
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem2(
                "Potongan Promosi",
                CommonMethods.formatCompleteCurrency(
                  widget.trData['total_promo'],
                ),
              ),
              const SizedBox(height: 10),
              buildTextItem2(
                "Biaya Transaksi",
                CommonMethods.formatCompleteCurrency(
                  (double.parse(widget.transactionModel.fee!) *
                          double.parse(widget.transactionModel.subTotal!)) /
                      100,
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              const SizedBox(height: 15),
              buildTextItem2(
                "Total",
                CommonMethods.formatCompleteCurrency(
                  double.parse(widget.transactionModel.total!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTransferDetailSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: widget.transactionModel.type!.toLowerCase() == "withdraw"
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.38,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Silakan Transfer ke",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FancyShimmerImage(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.06,
                        boxFit: BoxFit.cover,
                        imageUrl: widget.transactionModel.imgMethod!,
                        errorWidget: Image.network(
                            'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.transactionModel.metode!,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 17,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildTextItem(
                  "Nomor Rekening", widget.transactionModel.noRekening!, true),
              const SizedBox(height: 10),
              buildTextItem(
                  "Atas Nama", widget.transactionModel.atasNama!, false),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.14,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: ColorManager.primary.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Text(
                      "Transfer total pembayaran sesuai dengan rincian diatas ke nomor rekening atas nama ${widget.transactionModel.atasNama}. Biaya transfer ditanggung pengguna. Lalu upload bukti transfer pada fitur dibawah ini."),
                ),
              ),
              widget.transactionModel.type!.toLowerCase() == "withdraw"
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "${CommonMethods().getWithdrawFieldName(widget.transactionModel.product!.toLowerCase())} ${widget.transactionModel.product!}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: fieldController,
                          // validator: _akunValidator,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: CommonMethods().getWithdrawFieldName(
                                widget.transactionModel.product!.toLowerCase()),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: ColorManager.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  buildBuktiBayarSection() {
    return Card(
      margin: EdgeInsets.zero,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(15),
      //   ),
      // ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.37,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Bukti Pembayaran",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  showPickImageDialog(context);
                },
                child: _imageFile == null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: ColorManager.primary.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              const Text("Format Gambar: JPG, JPEG, PNG"),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildTextItem2(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title)),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = CommonDialog.buildConfirmationDialog(
            context, "Yakin ingin kembali?", "Kembali", "Tidak", () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context, rootNavigator: true).pop();

          TransactionService().delete(int.parse(widget.transactionModel.id!));
        });

        return shouldPop!;
      },
      child: Scaffold(
        appBar: CommonWidgets().buildCommonAppBar("Detail Pembayaran"),
        body: SingleChildScrollView(
            child: Column(
          children: [
            buildTopSection(),
            const SizedBox(height: 10),
            buildDetailSection(),
            const SizedBox(height: 10),
            buildTransferDetailSection(),
            const SizedBox(height: 10),
            buildBuktiBayarSection(),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary, // background
                            foregroundColor: Colors.white, // foreground
                          ),
                          child: const Text('Buat Pesanan'),
                          onPressed: () async {
                            if (_imageFile == null) {
                              CommonDialog.buildOkDialog(context, false,
                                  "Harap pilih bukti pembayaran Anda");
                            } else {
                              if (widget.transactionModel.type!.toLowerCase() ==
                                  "withdraw") {
                                if (fieldController.text.trim().isEmpty) {
                                  CommonDialog.buildOkDialog(
                                      context, false, "Harap isi field ini");
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  final bytes =
                                      File(_imageFile!.path).readAsBytesSync();

                                  String img64 = base64Encode(bytes);

                                  print(img64);

                                  Map<String, dynamic> data = {
                                    'id': widget.transactionModel.id,
                                    'bukti': "data:image/jpeg;base64,$img64",
                                  };

                                  try {
                                    PayTransactionModel p =
                                        await TransactionService().pay(data);

                                    try {
                                      widget.trData['akun_tujuan'] =
                                          fieldController.text.trim();

                                      await TransactionService()
                                          .updateTransaction(widget.trData);

                                      setState(() {
                                        isLoading = false;
                                      });

                                      sendEmail(p, widget.trData['jumlah']);

                                      CommonDialog().buildOkWaDialog(
                                        context,
                                        true,
                                        "Pembuatan Pesanan berhasil. Buka WhatsApp sekarang untuk hubungi Admin.",
                                        p,
                                        widget.trData['jumlah'],
                                      );
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        isLoading = false;
                                      });
                                      CommonDialog.buildOkDialog(context, false,
                                          "Terjadi kesalahan saat upload bukti. Coba lagi.");
                                    }
                                  } catch (e) {
                                    print(e);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    CommonDialog.buildOkDialog(context, false,
                                        "Terjadi kesalahan saat upload bukti. Coba lagi.");
                                  }
                                }
                              } else {
                                setState(() {
                                  isLoading = true;
                                });

                                final bytes =
                                    File(_imageFile!.path).readAsBytesSync();

                                String img64 = base64Encode(bytes);

                                print(img64);

                                Map<String, dynamic> data = {
                                  'id': widget.transactionModel.id,
                                  'bukti': "data:image/jpeg;base64,$img64",
                                };

                                try {
                                  PayTransactionModel p =
                                      await TransactionService().pay(data);

                                  setState(() {
                                    isLoading = false;
                                  });

                                  sendEmail(p, widget.trData['jumlah']);

                                  CommonDialog().buildOkWaDialog(
                                    context,
                                    true,
                                    "Pembuatan Pesanan berhasil. Buka WhatsApp sekarang untuk hubungi Admin.",
                                    p,
                                    widget.trData['jumlah'],
                                  );
                                } catch (e) {
                                  print(e);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  CommonDialog.buildOkDialog(context, false,
                                      "Terjadi kesalahan saat upload bukti. Coba lagi.");
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ),
            ),
          ],
        )),
      ),
    );
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

    String body =
        "Transaksi Baru #${transactionModel.kodeTransaksi}\n\nSilakan proses pesanan dengan detail sebagai berikut:\n\n*${transactionModel.type}*\n\n*Kode Transaksi*: *${transactionModel.kodeTransaksi}*\n*Produk*: ${transactionModel.product}\n*Nama Pengguna*: ${transactionModel.name}\n*Total*: $currency${double.parse(transactionModel.total!).toStringAsFixed(2)}\n*Saldo yang akan diterima: $saldoYangDiterima \n\nPastikan untuk membuka website admin untuk melihat detail transaksi.";

    final Uri params = Uri(
      scheme: 'mailto',
      path: 'order@vepay.id',
      query:
          'subject=Transaksi Baru #${transactionModel.kodeTransaksi}&body=$body',
    );

    final String url = params.toString();

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void showPickImageDialog(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Pilih gambar dari",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);

                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const FaIcon(
                                    FontAwesomeIcons.camera,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('Kamera',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);

                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const FaIcon(
                                    FontAwesomeIcons.image,
                                    size: 35,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Galeri',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
