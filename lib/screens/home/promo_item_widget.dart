import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vepay_app/common/common_dialog.dart';
import 'package:vepay_app/screens/home/promo_detail.dart';
import 'package:vepay_app/screens/home/promo_news_detail.dart';

import '../../models/promo_model.dart';

class PromoItemWidget extends StatefulWidget {
  PromoModel promo;
  String source;
  PromoItemWidget({required this.promo, required this.source, super.key});

  @override
  State<PromoItemWidget> createState() => _PromoItemWidgetState();
}

class _PromoItemWidgetState extends State<PromoItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.source == "all"
          ? const EdgeInsets.symmetric(horizontal: 5, vertical: 5)
          : const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () async {
          if (widget.promo.jenisKonten == "1") {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: PromoDetail(
                promo: widget.promo,
              ),
              withNavBar: false,
            );
          } else if (widget.promo.jenisKonten == "2") {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: PromoNewsDetail(
                promo: widget.promo,
              ),
              withNavBar: false,
            );
          } else if (widget.promo.jenisKonten == "3") {
            final url = Uri.parse(widget.promo.redirectLink!);

            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              CommonDialog.buildOkDialog(
                  context, false, "Terjadi kesalahan. Silahkan coba lagi.");
            }
          }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.18,
          width: widget.source == "all"
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FancyShimmerImage(
                  width: widget.source == "all"
                      ? double.infinity
                      : MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.18,
                  boxFit: BoxFit.cover,
                  imageUrl: widget.promo.image!,
                  errorWidget: Image.network(
                      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
