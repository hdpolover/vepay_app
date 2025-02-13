import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/screens/home/product_buy_detail.dart';
import 'package:vepay_app/screens/home/product_detail.dart';
import 'package:vepay_app/screens/tabs/more.dart';

import '../../common/common_dialog.dart';

class ProductItemWidget extends StatefulWidget {
  RateModel rateModel;
  ProductItemWidget({required this.rateModel, super.key});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        if (widget.rateModel.categories == "vcc") {
          Map<String, dynamic> data = {
            "akun_tujuan": null,
            "jumlah": 1.toString(),
            "blockchain_id": null,
            "blockchain_name": null,
          };

          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: ProductBuyDetail(
              rateModel: widget.rateModel,
              data: data,
            ),
            withNavBar: false,
          );
        } else if (widget.rateModel.name!.toLowerCase() == "more") {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: More(),
            withNavBar: false,
          );
        } else if (widget.rateModel.name!.toLowerCase() == "jasa bayar") {
          CommonDialog().buildOkWaJasaBayarDialog(context, true,
              "Buka WhatsApp sekarang untuk hubungi Admin mengenai jasa bayar.");
        } else {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: ProductDetail(
              rateModel: widget.rateModel,
            ),
            withNavBar: false,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop ? screenHeight * (ResponsiveBreakpoints.of(context).orientation == Orientation.portrait ? 0.15 : 0.25) : screenHeight * 0.135,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FancyShimmerImage(
                  width: MediaQuery.of(context).size.width * 0.155,
                  height: ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop ? screenHeight * (ResponsiveBreakpoints.of(context).orientation == Orientation.portrait ? 0.1 : 0.2) : screenHeight * 0.075,
                  boxFit: BoxFit.cover,
                  imageUrl: widget.rateModel.image!,
                  errorWidget: Image.network(
                      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.rateModel.name!,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth > 600 ? 16 : 13,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
