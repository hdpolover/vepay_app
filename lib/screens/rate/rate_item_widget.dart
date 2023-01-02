import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_method.dart';
import 'package:vepay_app/models/rate_model.dart';

class RateItemWidget extends StatefulWidget {
  RateModel rate;
  RateItemWidget({required this.rate, Key? key}) : super(key: key);

  @override
  State<RateItemWidget> createState() => _RateItemWidgetState();
}

class _RateItemWidgetState extends State<RateItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FancyShimmerImage(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.06,
                  boxFit: BoxFit.cover,
                  imageUrl: widget.rate.image!,
                  errorWidget: Image.network(
                      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.rate.name!,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.rate.type!,
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .bodyText2
                    //     ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              CommonMethods.formatCompleteCurrency(
                  double.parse(widget.rate.price!)),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
