import 'dart:math';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vepay_app/models/transaction_model.dart';
import 'package:vepay_app/screens/transaction/transaction_detail.dart';

import '../../common/common_method.dart';
import '../../common/common_widgets.dart';
import '../../resources/color_manager.dart';

class TransactionItemWidget extends StatefulWidget {
  TransactionModel transaction;
  TransactionItemWidget({required this.transaction, super.key});

  @override
  State<TransactionItemWidget> createState() => _TransactionItemWidgetState();
}

class _TransactionItemWidgetState extends State<TransactionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

                      // Define appropriate dimensions for different device types
                      final double width = isTablet ? 120.0 : 60.0;
                      final double height = isTablet ? 80.0 : 60.0;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FancyShimmerImage(
                          // width: MediaQuery.of(context).size.width * 0.15,
                          // height: MediaQuery.of(context).size.height * 0.06,
                          width: width,
                          height: height,
                          boxFit: BoxFit.cover,
                          imageUrl: widget.transaction.imgProduct!,
                          errorWidget: Image.network(
                              'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                        ),
                      );
                    }
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transaction.type!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        CommonMethods()
                            .formatDate(widget.transaction.createdAt!, "s"),
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .bodyText2
                        //     ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                CommonWidgets()
                    .buildStatusChip(int.parse(widget.transaction.status!)),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.product!.toLowerCase() == "vcc"
                        ? "Beli VCC"
                        : "Saldo ${widget.transaction.product}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  widget.transaction.akunTujuan == null
                      ? Container()
                      : const SizedBox(height: 5),
                  widget.transaction.akunTujuan == null
                      ? Container()
                      : Text(widget.transaction.akunTujuan ?? "-"),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Harga"),
                          const SizedBox(height: 5),
                          Text(
                            CommonMethods.formatCompleteCurrency(
                                double.parse(widget.transaction.total!)),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isTablet = ResponsiveBreakpoints.of(context).isTablet;
                          final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                          final screenWidth = MediaQuery.of(context).size.width;

                          final buttonWidth = isTablet
                              ? max(120.0, screenWidth * (isLandscape ? 0.15 : 0.18))
                              : max(80.0, screenWidth * (isLandscape ? 0.20 : 0.25));

                          final buttonHeight = buttonWidth * (isLandscape ? 0.18 : 0.2);
                          return Container(
                            width: buttonWidth,
                            height: buttonHeight,
                            constraints: const BoxConstraints(
                              minWidth: 100.0,
                              minHeight: 36.0,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Detail'),
                              ),
                              onPressed: () async {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: TransactionDetail(
                                    transaction: widget.transaction,
                                  ),
                                  withNavBar: false,
                                );
                              },
                            ),
                          );
                        }
                      )
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   height: MediaQuery.of(context).size.height * 0.04,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.green, // background
                      //       foregroundColor: Colors.white, // foreground
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //     ),
                      //     child: const Text('Detail'),
                      //     onPressed: () async {
                      //       PersistentNavBarNavigator.pushNewScreen(
                      //         context,
                      //         screen: TransactionDetail(
                      //           transaction: widget.transaction,
                      //         ),
                      //         withNavBar: false,
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
