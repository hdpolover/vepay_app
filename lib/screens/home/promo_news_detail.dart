import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/promo_model.dart';

class PromoNewsDetail extends StatefulWidget {
  PromoModel promo;
  PromoNewsDetail({required this.promo, Key? key}) : super(key: key);

  @override
  State<PromoNewsDetail> createState() => _PromoNewsDetailState();
}

class _PromoNewsDetailState extends State<PromoNewsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Detail Berita"),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FancyShimmerImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            boxFit: BoxFit.fill,
            imageUrl: widget.promo.image!,
            errorWidget: Image.network(
                'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.promo.desc!,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
