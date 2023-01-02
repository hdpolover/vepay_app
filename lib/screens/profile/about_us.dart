import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: CommonWidgets().buildFloatingWaButton(),
      appBar: CommonWidgets().buildCommonAppBar("Tentang Kami"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Image(
                        width: MediaQuery.of(context).size.width * 0.3,
                        image: const AssetImage('assets/vepay_logo.png'),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Vepay",
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "v 0.0.1",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "Vepay.id merupakan platform penyedia jasa jual dan beli saldo meliputi Skrill, Perfect Money, Paypal, Payeer, USDT, BUSD. Vepay.id menjual Virtual Credit Card dan juga melayani jasa pembayaran melalui Paypal, Perfect Money, Skrill, Kartu Kredit dan Crypto.\n\nVepay.id berkomitmen untuk memberikan pelayanan terbaik kepada setiap klien yang menggunakan jasanya. Anda memiliki kendala dalam transaksi? Memiliki pertanyaan terkait transaksi? Tim Vepay.id siap melayani anda selama 24 JAM!\nVepay.id telah dipercaya lebih dari 1000 klien dengan tingkat kepuasan mencapai 4,9/5. Dengan pengalaman selama 10 tahun dan bersama tim terbaik, Vepay.id memberikan pelayanan terbaik dan melayani customer seperti RAJA!\n\nJadi, tunggu apa lagi? Yuk mulai bertransaksi dan percayakan urusan jual beli mu kepada Vepay.id!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
