import 'package:flutter/material.dart';
import 'package:vepay_app/models/vcc_model.dart';

import '../../common/common_widgets.dart';

class WithdrawVcc extends StatefulWidget {
  VccModel vccModel;
  WithdrawVcc({required this.vccModel, Key? key}) : super(key: key);

  @override
  State<WithdrawVcc> createState() => _WithdrawVccState();
}

class _WithdrawVccState extends State<WithdrawVcc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Withdraw VCC"),
    );
  }
}
