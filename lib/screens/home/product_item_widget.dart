import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:vepay_app/models/rate_model.dart';
import 'package:vepay_app/screens/home/product_detail.dart';

class ProductItemWidget extends StatefulWidget {
  RateModel rateModel;
  ProductItemWidget({required this.rateModel, Key? key}) : super(key: key);

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ProductDetail(
            rateModel: widget.rateModel,
          ),
          withNavBar: false,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FancyShimmerImage(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.06,
                  boxFit: BoxFit.cover,
                  imageUrl: widget.rateModel.image!,
                  errorWidget: Image.network(
                      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.rateModel.name!,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 15,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
