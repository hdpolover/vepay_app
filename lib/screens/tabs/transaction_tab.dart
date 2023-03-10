import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/transaction/transaction_item_widget.dart';
import 'package:vepay_app/services/transaction_service.dart';
import 'package:vepay_app/widgets/empty_widget.dart';

import '../../common/common_shimmer.dart';
import '../../models/transaction_model.dart';
import '../../services/rate_service.dart';

class TransactionTab extends StatefulWidget {
  TransactionTab({Key? key}) : super(key: key);

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab>
    with AutomaticKeepAliveClientMixin {
  List<TransactionModel>? transactionList;

  @override
  void initState() {
    getTrans();
    super.initState();
  }

  Future<void> getTrans() async {
    transactionList = null;

    try {
      transactionList = await TransactionService().getTransactionHistory();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _showFilterPopup() {
    showMaterialModalBottomSheet(
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      // ),
      context: context,
      barrierColor: Colors.black45,
      bounce: false,
      builder: (builder) {
        //return FilterBottomSheet();
        return NestedScrollView(
          controller: ScrollController(),
          physics: const ScrollPhysics(parent: PageScrollPhysics()),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Filter",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // _priceValues = const SfRangeValues(0, 100);
                              });
                            },
                            child: const Icon(
                              Icons.refresh_rounded,
                              size: 23,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 20),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ];
          },
          body: ListView(
            controller: ModalScrollController.of(context),
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 20),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 20),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            "Services",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 15),
                      ],
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width, height: 30),
                    Center(
                      child: SizedBox(
                        width: 276,
                        height: 55,
                        child: OutlinedButton(
                          child: const Text('Apply'),
                          onPressed: () {
                            //applyFilter();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
          InkWell(
            onTap: _showFilterPopup,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: FaIcon(
                Icons.filter_list,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getTrans,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: transactionList == null
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: 5,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CommonShimmer().buildRateItemShimmer(context);
                  },
                )
              : transactionList!.isEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          EmptyWidget(
                              emptyTitle: "Kamu belum memiliki transaksi",
                              emptyDesc:
                                  "Buat transaksi sekarang untuk melihatnya di halaman ini."),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.primary, // background
                                  foregroundColor: Colors.white, // foreground
                                ),
                                child: const Text('Muat ulang'),
                                onPressed: () async {
                                  getTrans();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      itemCount: transactionList!.length,
                      itemBuilder: (context, index) {
                        return TransactionItemWidget(
                            transaction: transactionList![index]);
                      },
                    ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
