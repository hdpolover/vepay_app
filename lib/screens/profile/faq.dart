import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_shimmer.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/faq_model.dart';
import 'package:vepay_app/services/app_info_service.dart';
import 'package:vepay_app/services/faq_service.dart';
import 'dart:math' as math;

class FaqItem {
  FaqItem({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String? expandedValue;
  String? headerValue;
  bool isExpanded;
}

class Faq extends StatefulWidget {
  Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List<FaqModel>? faqs;
  List<FaqItem> exp = [];

  List<FaqItem> generateItems(int numberOfItems) {
    return List.generate(numberOfItems, (int index) {
      return FaqItem(
        headerValue: faqs![index].judul!,
        expandedValue: faqs![index].deskripsi!,
      );
    });
  }

  getFaq() async {
    try {
      faqs = await FaqService().getFaqs();

      faqs!.sort(((a, b) => int.parse(a.id!).compareTo(int.parse(b.id!))));

      exp = generateItems(faqs!.length);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getFaq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonWidgets().buildCommonAppBar("FAQ"),
        body: faqs == null
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
                itemCount: faqs!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ExpansionPanelList(
                      elevation: 1,
                      expansionCallback: (int item, bool status) {
                        setState(() {
                          exp[index].isExpanded = !exp[index].isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              title: Text(
                                faqs![index].judul!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                          body: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            title: Text(
                              AppInfoService()
                                  .removeHtmlTags(faqs![index].deskripsi!),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          isExpanded: exp[index].isExpanded,
                          canTapOnHeader: true,
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
