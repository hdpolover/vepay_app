import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:vepay_app/models/referred_friend_model.dart';

class ReferredFriendItemWidget extends StatefulWidget {
  ReferredFriendModel referredFriendModel;
  ReferredFriendItemWidget({required this.referredFriendModel, Key? key})
      : super(key: key);

  @override
  State<ReferredFriendItemWidget> createState() =>
      _ReferredFriendItemWidgetState();
}

class _ReferredFriendItemWidgetState extends State<ReferredFriendItemWidget> {
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FancyShimmerImage(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.06,
                  boxFit: BoxFit.cover,
                  imageUrl: widget.referredFriendModel.photo!,
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
                    widget.referredFriendModel.name!,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Bergabung pada ${widget.referredFriendModel.joinedAt!}",
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .bodyText2
                    //     ?.copyWith(color: Colors.grey),
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
