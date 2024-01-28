import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/screens/home/promo_item_widget.dart';

class PromoSeeAll extends StatefulWidget {
  List<PromoModel> promos;
  PromoSeeAll({required this.promos, super.key});

  @override
  State<PromoSeeAll> createState() => _PromoSeeAllState();
}

class _PromoSeeAllState extends State<PromoSeeAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Promo dan Berita"),
      // list promos from widget.promos
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        itemCount: widget.promos.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return PromoItemWidget(
            promo: widget.promos[index],
            source: "all",
          );
        },
      ),
    );
  }
}
