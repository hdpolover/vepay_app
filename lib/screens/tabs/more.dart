import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/rate_model.dart';

import '../../common/common_shimmer.dart';
import '../../services/rate_service.dart';
import '../home/product_item_widget.dart';

class More extends StatefulWidget {
  More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  List<RateModel>? rates;

  @override
  void initState() {
    getRates();

    super.initState();
  }

  Future<void> getRates() async {
    try {
      rates = await RateService().getRates("top_up");

      rates!.removeWhere((item) => item.name!.toLowerCase() == 'more');

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  buildProductSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ResponsiveGridList(
        minItemsPerRow: 4,
        horizontalGridSpacing: 4,
        verticalGridSpacing: 4,
        listViewBuilderOptions: ListViewBuilderOptions(
            physics: const NeverScrollableScrollPhysics()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Semua Kategori"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: buildProductSection(),
        ),
      ),
    );
  }
}
