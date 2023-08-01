import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/models/referral_history_model.dart';
import 'package:vepay_app/models/referred_friend_model.dart';

class ReferralHistoryItemWidget extends StatefulWidget {
  ReferralHistoryModel referralHistoryModel;
  ReferralHistoryItemWidget({required this.referralHistoryModel, Key? key})
      : super(key: key);

  @override
  State<ReferralHistoryItemWidget> createState() =>
      _ReferralHistoryItemWidgetState();
}

class _ReferralHistoryItemWidgetState extends State<ReferralHistoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80, // Adjust the size of the container as needed
              height: 80, // Adjust the size of the container as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const FaIcon(FontAwesomeIcons.moneyBillTransfer),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.referralHistoryModel.message!,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
