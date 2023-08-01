import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/models/referral_history_model.dart';
import 'package:vepay_app/screens/referral/referral_history_item_widget.dart';

import '../../common/common_shimmer.dart';
import '../../common/common_widgets.dart';
import '../../models/referral_info_model.dart';
import '../../services/referral_service.dart';

class RiwayatReferral extends StatefulWidget {
  ReferralInfoModel? referralInfoModel;

  RiwayatReferral({required this.referralInfoModel, Key? key})
      : super(key: key);

  @override
  State<RiwayatReferral> createState() => _RiwayatReferralState();
}

class _RiwayatReferralState extends State<RiwayatReferral> {
  List<ReferralHistoryModel>? history;
  getHistory() async {
    try {
      history = await ReferralService().getRiwayat();

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Riwayat Transaksi Referral"),
      body: history == null
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
          : history!.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FancyShimmerImage(
                          boxFit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.5,
                          imageUrl: widget.referralInfoModel!.image!,
                          errorWidget: Image.network(
                              'https://vectorified.com/images/user-icon-1.png'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Belum ada riwayat transaksi referral",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Dapatkan cashback untuk setiap teman yang kamu ajak bergabung dengan kode referrralmu",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      10, 10, 10, MediaQuery.of(context).size.height * 0.07),
                  shrinkWrap: true,
                  itemCount: history!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ReferralHistoryItemWidget(
                        referralHistoryModel: history![index]);
                  },
                ),
    );
  }
}
