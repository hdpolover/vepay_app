import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';

class WithdrawDetail extends StatefulWidget {
  WithdrawDetail({Key? key}) : super(key: key);

  @override
  State<WithdrawDetail> createState() => _WithdrawDetailState();
}

class _WithdrawDetailState extends State<WithdrawDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Withdraw"),
      body: SingleChildScrollView(
          child: Column(
        children: [],
      )),
    );
  }
}
