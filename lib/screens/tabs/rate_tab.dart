import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/common/fake_data.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/rate/rate_item_widget.dart';
import 'package:vepay_app/services/rate_service.dart';

import '../../common/common_shimmer.dart';
import '../../models/rate_model.dart';

class RateTab extends StatefulWidget {
  RateTab({Key? key}) : super(key: key);

  @override
  State<RateTab> createState() => _RateTabState();
}

class _RateTabState extends State<RateTab> with AutomaticKeepAliveClientMixin {
  List<RateModel>? rates;

  @override
  void initState() {
    super.initState();

    getRates();
  }

  getRates() async {
    try {
      rates = await RateService().getRates("top_up");

      List<RateModel>? withdrawRates;

      withdrawRates = await RateService().getRates("withdraw");

      rates!.addAll(withdrawRates);

      rates!.removeWhere((item) => item.price! == "0");

      rates!.removeWhere((item) => item.categories!.toLowerCase() == "vcc");

      rates!.sort(((a, b) => a.name!.compareTo(b.name!)));

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadRates() async {
    rates == null;

    setState(() {});

    getRates();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: CommonWidgets().buildMenuAppBar("Rate Hari ini"),
      body: RefreshIndicator(
        onRefresh: loadRates,
        color: ColorManager.primary,
        child: rates == null
            ? ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    10, 10, 10, MediaQuery.of(context).size.height * 0.07),
                shrinkWrap: true,
                itemCount: 5,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CommonShimmer().buildRateItemShimmer(context);
                },
              )
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    10, 10, 10, MediaQuery.of(context).size.height * 0.07),
                shrinkWrap: true,
                itemCount: rates!.length,
                itemBuilder: (context, index) {
                  return RateItemWidget(
                    rate: rates![index],
                  );
                },
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
