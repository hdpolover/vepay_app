import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/resources/color_manager.dart';

class TransactionTab extends StatefulWidget {
  TransactionTab({Key? key}) : super(key: key);

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: FaIcon(
              Icons.filter_list,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
