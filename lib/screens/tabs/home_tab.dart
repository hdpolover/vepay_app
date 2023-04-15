import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:vepay_app/common/common_shimmer.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/home/product_item_widget.dart';
import 'package:vepay_app/screens/home/promo_item_widget.dart';
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
  HomeTab({required this.member, Key? key}) : super(key: key);

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
      setState(() {});
    } catch (e) {
      CommonDialog.buildOkDialog(context, false, e.toString());
    }

    getRates();
    getPromos();
    getTrans();
  }

  Future<void> getPromos() async {
    try {
      promos = await PromoService().getPromos();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRates() async {
    try {
      List<RateModel> tempRates = await RateService().getRates("top_up");

      rates = tempRates;

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
                buildProductSection(),
                transactionList != null && transactionList!.isEmpty
                    ? Container()
                    : buildTransSection(),
                const SizedBox(height: 10),
                buildPromotionSection(),
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
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         buildProductItemWidget(),
    //         buildProductItemWidget(),
    //         buildProductItemWidget(),
    //         buildProductItemWidget(),
    //       ],
    //     )
    //   ],
    // );
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
        Text(
          "Promosi",
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 18,
              ),
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
                "${member!.name}!",
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
}
