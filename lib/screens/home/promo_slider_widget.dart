import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:vepay_app/models/promo_model.dart';
import 'package:vepay_app/screens/home/promo_item_widget.dart';

class PromoSliderWidget extends StatelessWidget {
  final List<PromoModel> promos;
  final String source;

  const PromoSliderWidget({
    required this.promos,
    required this.source,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (promos.isEmpty) { //jika promo kosong.
      return const SizedBox.shrink();
    }

    return CarouselSlider.builder(
      itemCount: promos.length,
      itemBuilder: (context, index, realIndex) {
        return PromoItemWidget(
          promo: promos[index],
          source: source,
        );
      },
      options: CarouselOptions(
        //ukuran kotak promo widget
        aspectRatio: 3.15 / 1.5,
        autoPlay: true, //otomatis nge slide ke kanan. kalau di "false" gabisa slide otomatis
        autoPlayInterval: const Duration(seconds: 3), //durasi slide. bisa diubah
        autoPlayAnimationDuration: const Duration(milliseconds: 800), //durasi slide saat tampil
        autoPlayCurve: Curves.fastOutSlowIn, //animasi bergerak nya
        enlargeCenterPage: true,
        viewportFraction: 1,
      ),
    );
  }
}




