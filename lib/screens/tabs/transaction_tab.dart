import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/resources/color_manager.dart';
import 'package:vepay_app/screens/transaction/transaction_item_widget.dart';
import 'package:vepay_app/services/transaction_service.dart';
import 'package:vepay_app/widgets/empty_widget.dart';

import '../../common/common_shimmer.dart';
import '../../models/rate_model.dart';
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
  DateTime? startDate, endDate;
  String? startDateValue, endDateValue;

  TextEditingController? startDateController = TextEditingController();
  TextEditingController? endDateController = TextEditingController();

  var _result;

  List<RateModel> itemRates = [];
  List<RateModel> selectedItemRates = [];

  String selectedChoice = 'top_up';

  bool isFiltered = false;

  @override
  void initState() {
    getTrans();
    getRates();
    super.initState();
  }

  Future<void> getRates() async {
    try {
      List<RateModel> tempRates = await RateService().getRates("top_up");

      tempRates
          .removeWhere((item) => item.name!.toLowerCase().contains("more"));

      tempRates
          .removeWhere((item) => item.name!.toLowerCase().contains("jasa"));

      itemRates = tempRates;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTrans() async {
    setState(() {
      transactionList = null;
    });

    try {
      transactionList = await TransactionService().getTransactionHistory();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  doFilter(Map<String, dynamic> data, Map<String, dynamic> prods) async {
    Navigator.of(context).pop();

    setState(() {
      transactionList = null;
      isFiltered = true;
    });

    try {
      List<TransactionModel> temps =
          await TransactionService().filter(data, prods);

      setState(() {
        transactionList = temps;
      });
    } catch (e) {
      print('w');
    }
  }

  int? selectedIndex;

  void _showFilterPopup() {
    showBarModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      context: context,
      barrierColor: Colors.black45,
      bounce: false,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: NestedScrollView(
                controller: ScrollController(),
                physics: const ScrollPhysics(parent: PageScrollPhysics()),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Filter Transaksi",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white, // background
                                      foregroundColor:
                                          ColorManager.primary, // foreground
                                    ),
                                    child: const Text('Reset'),
                                    onPressed: () async {
                                      setState(() {
                                        selectedItemRates = [];
                                        startDate = null;
                                        endDate = null;
                                        startDateController!.clear();
                                        endDateController!.clear();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20),
                        ],
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    controller: ModalScrollController.of(context),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Filter Berdasarkan",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ChoiceButton(
                                title: 'Top up',
                                isSelected: selectedChoice == 'top_up',
                                onTap: () {
                                  setState(() {
                                    selectedChoice = 'top_up';
                                  });

                                  print(selectedChoice);
                                },
                              ),
                              const SizedBox(width: 10),
                              ChoiceButton(
                                title: 'Withdraw',
                                isSelected: selectedChoice == 'withdraw',
                                onTap: () {
                                  setState(() {
                                    selectedChoice = 'withdraw';
                                  });

                                  print(selectedChoice);
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20),
                          Text(
                            "Tanggal",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: startDateController,
                                  readOnly: true,
                                  onTap: () {
                                    displayDatePicker(1);
                                  },
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Mulai',
                                    suffixIcon:
                                        const Icon(Icons.calendar_month),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("s/d"),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: endDateController,
                                  readOnly: true,
                                  onTap: () {
                                    displayDatePicker(2);
                                  },
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Akhir',
                                    suffixIcon:
                                        const Icon(Icons.calendar_month),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20),
                          Text(
                            "Produk",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 20),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: ListView.builder(
                              itemCount: itemRates.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                  title: Text(itemRates[index].name!),
                                  value: selectedItemRates
                                      .contains(itemRates[index]),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        selectedItemRates.add(itemRates[index]);
                                      } else {
                                        selectedItemRates
                                            .remove(itemRates[index]);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 30),
                          Center(
                            child: SizedBox(
                              width: 276,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.primary, // background
                                  foregroundColor: Colors.white, // foreground
                                ),
                                child: const Text('Terapkan'),
                                onPressed: () async {
                                  if (startDate == null || endDate == null) {
                                    CommonDialog.buildOkDialog(context, false,
                                        "Harap tentukan rentang tanggal transaksi untuk difilter.");
                                  } else {
                                    if (startDate!.isAfter(endDate!)) {
                                      CommonDialog.buildOkDialog(context, false,
                                          "Tanngal awal tidak bisa lebih dari tanggal akhir. Coba lagi.");
                                    } else {
                                      if (selectedItemRates.isEmpty) {
                                        CommonDialog.buildOkDialog(
                                            context,
                                            false,
                                            "Harap pilih minimal 1 produk transaksi untuk difilter.");
                                      } else {
                                        Map<String, dynamic> prods = {};
                                        for (int i = 0;
                                            i < selectedItemRates.length;
                                            i++) {
                                          prods['prod$i'] = selectedItemRates[i]
                                              .name!
                                              .toLowerCase();
                                        }

                                        String start = DateFormat('dd-MM-yyyy')
                                            .format(startDate!);
                                        String end = DateFormat('dd-MM-yyyy')
                                            .format(endDate!);

                                        Map<String, dynamic> data = {
                                          'start_date': start,
                                          'end_date': end,
                                          'type': selectedChoice,
                                        };

                                        doFilter(data, prods);
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  displayDatePicker(int type) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1, 1),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              //Header background color
              primaryColor: ColorManager.primary,
              //Background color
              scaffoldBackgroundColor: Colors.grey[50],
              //Divider color
              dividerColor: Colors.grey,
              //Non selected days of the month color
              textTheme: const TextTheme(
                bodyText2: TextStyle(color: Colors.black),
              ),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                //Selected dates background color
                primary: ColorManager.primary,
                //Month title and week days color
                onSurface: Colors.black,
                //Header elements and selected dates text color
                //onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        }).then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }

      setState(() {
        // using state so that the UI will be rerendered when date is picked
        if (type == 1) {
          startDate = pickedDate;
          startDateController!.text =
              DateFormat.yMMMMd('id').format(startDate!);

          startDateValue = DateFormat('dd-MM-yyyy').format(startDate!);
        } else {
          endDate = pickedDate;
          endDateController!.text = DateFormat.yMMMMd('id').format(endDate!);

          endDateValue = DateFormat('dd-MM-yyyy').format(endDate!);
        }
      });
    });
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
                          isFiltered
                              ? EmptyWidget(
                                  emptyTitle: "Transaksi tidak ditemukan",
                                  emptyDesc:
                                      "Coba atur ulang filter untuk melihat transaksi lain.")
                              : EmptyWidget(
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
                                  setState(() {
                                    isFiltered = false;
                                  });
                                  getTrans();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      //padding: const EdgeInsets.symmetric(vertical: 10),
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

class ChoiceButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ChoiceButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.lightPrimary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? ColorManager.primary
                : Colors.black, // Set the border color here
            width: 1, // Set the border width if needed
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? ColorManager.primary : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class ChoiceButtonGroup extends StatefulWidget {
  @override
  _ChoiceButtonGroupState createState() => _ChoiceButtonGroupState();
}

class _ChoiceButtonGroupState extends State<ChoiceButtonGroup> {
  String selectedChoice = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceButton(
          title: 'Top up',
          isSelected: selectedChoice == 'Top up',
          onTap: () {
            setState(() {
              selectedChoice = 'Top up';
            });
          },
        ),
        const SizedBox(width: 10),
        ChoiceButton(
          title: 'Withdraw',
          isSelected: selectedChoice == 'Withdraw',
          onTap: () {
            setState(() {
              selectedChoice = 'Withdraw';
            });
          },
        ),
      ],
    );
  }
}
