import 'package:flutter/material.dart';

class WithdrawTab extends StatefulWidget {
  WithdrawTab({Key? key}) : super(key: key);

  @override
  State<WithdrawTab> createState() => _WithdrawTabState();
}

class _WithdrawTabState extends State<WithdrawTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
