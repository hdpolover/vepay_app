import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:vepay_app/common/common_shimmer.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/models/profile_request_model.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/home/product_item_widget.dart';
import 'package:vepay_app/screens/home/promo_item_widget.dart';
import 'package:vepay_app/screens/home/promo_see_all.dart';
import 'package:vepay_app/services/promo_service.dart';

import '../../common/common_dialog.dart';
import '../../models/rate_model.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../services/rate_service.dart';
import '../../services/transaction_service.dart';
import '../transaction/transaction_item_widget.dart';

class HomeTab extends StatefulWidget {
  MemberModel member;
  HomeTab({required this.member, super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<RateModel> rates = [];
  List<PromoModel>? promos;
  List<TransactionModel>? transactionList;

  MemberModel? member;

  @override
  void initState() {
    setMember();
    _getAllData();

    super.initState();
  }

  setMember() {
    setState(() {
      member = widget.member;
    });
  }

  Future<void> _getAllData() async {
    try {
      member = await AuthService().getMemberDetail();

      log(member!.toJson().toString(), name: 'TEST');

      // * handle user ketika nomor hp null atau kosong
      if (member!.phone!.isEmpty ||
          member?.phone == null ||
          member!.phone!.length < 10 ||
          member!.name!.isEmpty ||
          member?.name == null) {
        TextEditingController? nameController = TextEditingController();
        TextEditingController? phoneController = TextEditingController();

        _showMyDialog(
          userId: member?.userId ?? '',
          phoneController: phoneController,
          nameController: nameController,
          isShowName: (member!.name!.isEmpty || member?.name == null),
          isShowPhone: (member!.phone!.isEmpty ||
              member?.phone == null ||
              member!.phone!.length < 10),
          nameField: member?.name,
          phoneField: member?.phone,
        );
        setState(() {});
        return;
      }
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());
    }

    getRates();
    getPromos();
    getTrans();
  }

  Future<void> getPromos() async {
    await PromoService().getPromos().then((value) async {
      promos = value;

      await PromoService().getBerita().then((value) async {
        promos!.addAll(value);

        await PromoService().getIklan().then((value) {
          promos!.addAll(value);
        });
      });
    });

    setState(() {});
  }

  Future<void> getRates() async {
    try {
      List<RateModel> tempRates = await RateService().getRates("top_up");

      if (tempRates.length <= 9) {
        tempRates
            .removeWhere((element) => element.name!.toLowerCase() == "more");

        rates = tempRates;
      } else {
        rates = tempRates;
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTrans() async {
    try {
      transactionList = await TransactionService().getTransactionHistory();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _getAllData,
          color: ColorManager.primary,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.055,
              vertical: h * 0.04,
            ),
            child: ListView(
              children: [
                buildHeader(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Top up/Beli",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                buildProductSection(),
                transactionList != null && transactionList!.isEmpty
                    ? Container()
                    : buildTransSection(),
                const SizedBox(height: 10),
                promos != null && promos!.isEmpty
                    ? Container()
                    : buildPromotionSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildTransSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Transaksi Terbaru",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
              ),
        ),
        transactionList == null
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CommonShimmer().buildPromoItemShimmer(context);
                  },
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: transactionList!.length > 1 ? 2 : 1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return TransactionItemWidget(
                      transaction: transactionList![index]);
                },
              ),
      ],
    );
  }

  buildProductSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: ResponsiveGridList(
        minItemsPerRow: 4,
        horizontalGridSpacing: 4,
        verticalGridSpacing: 4,
        listViewBuilderOptions: ListViewBuilderOptions(
            physics: const NeverScrollableScrollPhysics()),
        minItemWidth: MediaQuery.of(context).size.width * 0.25,
        children: rates.isEmpty
            ? List.generate(
                8,
                (index) => CommonShimmer().buildProductItemShimmer(context),
                growable: false,
              )
            : List.generate(
                rates.length,
                (index) => buildProductItemWidget(rates[index]),
                growable: false,
              ),
      ),
    );
  }

  buildProductItemWidget(RateModel rateModel) {
    return ProductItemWidget(
      rateModel: rateModel,
    );
  }

  buildPromotionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Promo dan Berita",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PromoSeeAll(
                      promos: promos!,
                    ),
                    withNavBar: false,
                  );
                },
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: ColorManager.primary,
                  ),
                ))
          ],
        ),
        promos == null
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CommonShimmer().buildPromoItemShimmer(context);
                  },
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.21,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: promos!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return PromoItemWidget(
                      promo: promos![index],
                      source: "home",
                    );
                  },
                ),
              ),
      ],
    );
  }

  buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(member!.photo ??
              "https://vectorified.com/images/user-icon-1.png"),
          radius: 30,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo,"),
              const SizedBox(height: 3),
              Text(
                (member!.name!.isEmpty || member?.name == null)
                    ? "${member!.email}!"
                    : "${member!.name}!",
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Image(
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.height * 0.04,
              image: const AssetImage('assets/vepay_logo.png'),
            ),
            Image(
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.05,
              image: const AssetImage('assets/vepay_text.png'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showMyDialog({
    required TextEditingController phoneController,
    required TextEditingController nameController,
    required bool isShowName,
    required bool isShowPhone,
    required String userId,
    String? nameField,
    String? phoneField,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text('Silahkan Lengkapi Data Anda'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: isShowPhone,
                  child: TextFormField(
                    controller: phoneController,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Harap masukan nomor telepon'),
                      MinLengthValidator(9,
                          errorText:
                              "Panjang nomor telepon minimal 10 karakter"),
                      MaxLengthValidator(15,
                          errorText:
                              "Panjang nomor telepon maksimal 15 karakter"),
                    ]),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Nomor Telepon (WhatsApp)',
                      prefix: const Text("+62",
                          style: TextStyle(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isShowName,
                  child: TextFormField(
                    controller: nameController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Harap masukan nama'),
                    ]),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Nama',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Do something with the entered data
                  String phone = phoneController.text;
                  String name = nameController.text;

                  var data = ProfileRequestModel(
                    userId: userId,
                    name: name.isEmpty ? nameField : name,
                    phone: phone.isEmpty ? phoneField : phone,
                  );

                  try {
                    CommonDialog.showLoading(context);

                    bool res = await AuthService().updateDetailProfile(data);

                    Navigator.of(context).pop();

                    if (res) {
                      CommonDialog.buildOkUpdateDialog(
                          context, true, "Berhasil memperbarui profil.");
                    } else {
                      CommonDialog.buildOkDialog(
                          context, false, "Terjadi kesalahan. Coba lagi.");
                    }
                  } catch (e) {
                    CommonDialog.buildOkDialog(context, false, e.toString());
                  }

                  phoneController.dispose();
                  nameController.dispose();

                  _getAllData();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
