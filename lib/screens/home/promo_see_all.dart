import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_shimmer.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/screens/home/promo_item_widget.dart';
import 'package:vepay_app/services/promo_service.dart';

class PromoSeeAll extends StatefulWidget {
  List<PromoModel> promos;
  PromoSeeAll({required this.promos, super.key});

  @override
  State<PromoSeeAll> createState() => _PromoSeeAllState();
}

class _PromoSeeAllState extends State<PromoSeeAll> {
  List<PromoModel> promos = [];

  @override
  void initState() {
    super.initState();

    setData();
  }

  void setData() {
    promos = widget.promos;

    setState(() {});
  }

  Future<void> getPromos() async {
    promos.clear();

    await PromoService().getPromos().then((value) async {
      promos = value;
    });

    // remove items with status 0
    promos.removeWhere((element) => element.status == "0");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Promo dan Berita"),
      // list promos from widget.promos
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getPromos,
          child: promos.isEmpty
              ? ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  shrinkWrap: true,
                  itemCount: 3,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CommonShimmer().buildPromoItemShimmer(context,
                          width: double.infinity),
                    );
                  },
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: promos.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return PromoItemWidget(
                      promo: promos[index],
                      source: "all",
                    );
                  },
                ),
        ),
      ),
    );
  }
}
