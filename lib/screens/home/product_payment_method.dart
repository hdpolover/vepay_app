import 'package:flutter/material.dart';
import 'package:vepay_app/models/rate_model.dart';

import '../../common/common_widgets.dart';

class ProductPaymentMethod extends StatefulWidget {
  RateModel rateModel;
  Map<String, dynamic> data;
  ProductPaymentMethod({required this.rateModel, required this.data, Key? key})
      : super(key: key);

  @override
  State<ProductPaymentMethod> createState() => _ProductPaymentMethodState();
}

class _ProductPaymentMethodState extends State<ProductPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Pembayaran"),
      body: Column(),
    );
  }
}
