import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/referred_friend_model.dart';
import 'package:vepay_app/screens/referral/referred_friend_item_widget.dart';

import '../../models/referral_info_model.dart';

class DaftarTeman extends StatefulWidget {
  List<ReferredFriendModel> friends;
  ReferralInfoModel? referralInfoModel;
  DaftarTeman(
      {required this.friends, required this.referralInfoModel, Key? key})
      : super(key: key);

  @override
  State<DaftarTeman> createState() => _DaftarTemanState();
}

class _DaftarTemanState extends State<DaftarTeman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Daftar Teman"),
      body: widget.friends.isEmpty
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
                      "Ajak temanmu untuk bergabung dengan Vepay",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Dapatkan cashback untuk setiap transaksi (top up atau withdraw) yang dilakukan oleh teman kamu",
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
              itemCount: widget.friends.length,
              itemBuilder: (context, index) {
                return ReferredFriendItemWidget(
                  referredFriendModel: widget.friends[index],
                );
              },
            ),
    );
  }
}
