import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:vepay_app/common/common_shimmer.dart';
import 'package:vepay_app/models/member_model.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/home/product_item_widget.dart';

import '../../models/rate_model.dart';
import '../../services/rate_service.dart';

class HomeTab extends StatefulWidget {
  MemberModel member;
  HomeTab({required this.member, Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<RateModel>? rates;

  @override
  void initState() {
    super.initState();

    getRates();
  }

  Future<void> getRates() async {
    try {
      rates = await RateService().getRates();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.055,
              vertical: h * 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                const SizedBox(height: 20),
                buildProductSection(),
                buildPromotionSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildProductSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Expanded(
        child: ResponsiveGridList(
          minItemsPerRow: 4,
          horizontalGridSpacing: 4,
          verticalGridSpacing: 4,
          minItemWidth: MediaQuery.of(context).size.width * 0.25,
          children: rates == null
              ? List.generate(
                  8,
                  (index) => CommonShimmer().buildProductItemShimmer(context),
                  growable: false,
                )
              : List.generate(
                  rates!.length,
                  (index) => buildProductItemWidget(rates![index]),
                  growable: false,
                ),
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
      children: [
        Text(
          "Promosi",
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 18,
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
          backgroundImage: NetworkImage(widget.member.photo ??
              "https://app.vepay.id/asset/images/placeholder.jpg"),
          radius: 40,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo,"),
              Text(
                widget.member.name!,
                style: Theme.of(context).textTheme.bodyText2,
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
