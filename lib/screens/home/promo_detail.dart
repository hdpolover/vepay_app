import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/models/promo_model.dart';

class PromoDetail extends StatefulWidget {
  PromoModel promo;
  PromoDetail({required this.promo, Key? key}) : super(key: key);

  @override
  State<PromoDetail> createState() => _PromoDetailState();
}

class _PromoDetailState extends State<PromoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar("Detail Promo"),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FancyShimmerImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            boxFit: BoxFit.cover,
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
                Text(
                  widget.promo.nama!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  "Kode Promo",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.promo.kode!,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Kuota Promo",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.promo.quota!.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Nilai Promo",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.promo.jenis! == "1"
                      ? CommonMethods.formatCompleteCurrency(
                          widget.promo.value!,
                        )
                      : "${widget.promo.value!}%",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Masa Aktif Sampai",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  CommonMethods().formatDate(widget.promo.expired!, "s"),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Keterangan",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.promo.desc!,
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
