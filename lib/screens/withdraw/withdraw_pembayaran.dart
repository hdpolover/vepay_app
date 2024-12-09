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
import 'package:vepay_app/models/withdraw_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/resources/text_style_manager.dart';
import 'package:vepay_app/resources/widget_manager.dart';
import 'package:vepay_app/services/transaction_service.dart';

import '../../common/common_method.dart';

class WithdrawPayment extends StatefulWidget {
  Map<String, dynamic> trData;
  TransactionModel transactionModel;
  WithdrawModel withdrawModel;
  String wdSource;

  WithdrawPayment(
      {required this.trData,
      required this.transactionModel,
      required this.withdrawModel,
      required this.wdSource,
      Key? key})
      : super(key: key);

  @override
  State<WithdrawPayment> createState() => _WithdrawPaymentState();
}

class _WithdrawPaymentState extends State<WithdrawPayment> {
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  XFile? _imageFile;

  TextEditingController fieldController = TextEditingController();

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  buildTopSection() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      imageUrl: widget.withdrawModel.image!,
                      errorWidget: Image.network(
                          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.withdrawModel.withdraw!,
                    style: TextStyleManager.instance.body3.copyWith(
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
            WidgetManager().buildTextItem(
                "ID Pembayaran", widget.transactionModel.kodeTransaksi!),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem(
              "Tanggal",
              CommonMethods()
                  .formatDate(widget.transactionModel.createdAt!, "l"),
            ),
          ],
        ),
      ),
    );
  }

  buildDetailSection() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Pembayaran",
              style: TextStyleManager.instance.heading3,
            ),
            const SizedBox(height: 20),
            WidgetManager().buildTextItem2(
                "Subtotal Tagihan",
                CommonMethods().formatCurrencyNum(widget.withdrawModel.withdraw,
                    widget.trData['sub_total_usd'])),
            const SizedBox(height: 10),
            WidgetManager().buildTextItem2(
                "Biaya Transaksi",
                CommonMethods().formatCurrencyNum(
                    widget.withdrawModel.withdraw, widget.trData['fee'])),
            const SizedBox(height: 15),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            const SizedBox(height: 15),
            WidgetManager().buildTextItem2(
                "Total",
                CommonMethods().formatCurrencyNum(
                    widget.withdrawModel.withdraw, widget.trData['total'])),
          ],
        ),
      ),
    );
  }

  buildTransferDetailSection() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Silakan Transfer ke",
              style: TextStyleManager.instance.heading3,
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
                      imageUrl: widget.withdrawModel.image!,
                      errorWidget: Image.network(
                          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.withdrawModel.withdraw!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 17,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            WidgetManager().buildTextItemToCopy("Nomor Rekening",
                widget.withdrawModel.noRekening!, true, context),
            const SizedBox(height: 10),
            WidgetManager().buildTextItemToCopy(
                "Atas Nama", widget.withdrawModel.atasNama!, false, context),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: ColorManager.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                "Transfer total pembayaran sesuai dengan rincian di atas ke nomor rekening atas nama ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: widget.withdrawModel.atasNama,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ". \n\nBiaya transfer ditanggung pengguna. Lalu upload bukti transfer pada fitur di bawah ini.",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //     "Transfer total pembayaran sesuai dengan rincian di atas ke nomor rekening atas nama ${widget.withdrawModel.atasNama}. \n\nBiaya transfer ditanggung pengguna. Lalu upload bukti transfer pada fitur di bawah ini."),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${CommonMethods().getWithdrawFieldName(widget.transactionModel.product!.toLowerCase())} ${widget.transactionModel.product!}",
              style: TextStyleManager.instance.heading3,
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
        ),
      ),
    );
  }

  buildBuktiBayarSection() {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Bukti Pembayaran",
              style: TextStyleManager.instance.heading3,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                showPickImageDialog(context);
              },
              child: _imageFile == null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: ColorManager.primary.withOpacity(0.2),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text("Format Gambar: JPG, JPEG, PNG"),
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
          mainAxisSize: MainAxisSize.min,
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
                              if (fieldController.text.trim().isEmpty) {
                                CommonDialog.buildOkDialog(context, false,
                                    "Harap isi ${CommonMethods().getWithdrawFieldName(widget.transactionModel.product!.toLowerCase()).toLowerCase()} ${widget.transactionModel.product!}");
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
                                        .updateTransaction(
                                            widget.trData,
                                            int.parse(
                                                widget.transactionModel.id!));

                                    setState(() {
                                      isLoading = false;
                                    });

                                    CommonMethods()
                                        .sendEmail(p, widget.trData['jumlah']);

                                    CommonDialog().buildOkWaDialog(
                                      context,
                                      true,
                                      "Pembuatan Pesanan berhasil. Buka WhatsApp sekarang untuk hubungi Admin.",
                                      p,
                                      widget.trData,
                                      widget.wdSource,
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
                            }
                          },
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
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
