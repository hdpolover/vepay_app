import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vepay_app/common/common_widgets.dart';
import 'package:vepay_app/resources/color_manager.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    setState(() {});
  }

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
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 2),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)), //here
                        color: ColorManager.primary,
                      ),
                      child: Image(
                        width: MediaQuery.of(context).size.width * 0.3,
                        image: const AssetImage('assets/logo_white.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          appName == null ? "-" : appName!,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          version == null ? "v -" : "v $version",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Vepay.id merupakan platform penyedia jasa jual dan beli saldo meliputi Skrill, Perfect Money, Paypal, Payeer, USDT, BUSD. Vepay.id menjual Virtual Credit Card dan juga melayani jasa pembayaran melalui Paypal, Perfect Money, Skrill, Kartu Kredit dan Crypto.\n\nVepay.id berkomitmen untuk memberikan pelayanan terbaik kepada setiap klien yang menggunakan jasanya. Anda memiliki kendala dalam transaksi? Memiliki pertanyaan terkait transaksi? Tim Vepay.id siap melayani anda selama 24 JAM!\n\nVepay.id telah dipercaya lebih dari 1000 klien dengan tingkat kepuasan mencapai 4,9/5. Dengan pengalaman selama 10 tahun dan bersama tim terbaik, Vepay.id memberikan pelayanan terbaik dan melayani customer seperti RAJA!\n\nJadi, tunggu apa lagi? Yuk mulai bertransaksi dan percayakan urusan jual beli mu kepada Vepay.id!",
                  textAlign: TextAlign.justify,
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
