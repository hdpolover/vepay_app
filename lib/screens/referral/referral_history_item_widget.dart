import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vepay_app/models/referral_history_model.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50, // Adjust the size of the container as needed
              height: 50, // Adjust the size of the container as needed
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.moneyBillTransfer,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(widget.referralHistoryModel.message!),
                  // Text(
                  //   widget.referralHistoryModel.message!,
                  //   softWrap: true,
                  // ),
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
