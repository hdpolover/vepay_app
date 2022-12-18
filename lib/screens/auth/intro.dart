import 'package:flutter/material.dart';

import '../../resources/color_manager.dart';

class Intro extends StatefulWidget {
  Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    double? h = MediaQuery.of(context).size.height;
    double? w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 2 * 0.1, vertical: h * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    width: w * 0.6,
                    image: const AssetImage('assets/intro_img.png'),
                  ),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                    child: Text(
                      "Jasa Top Up Paling Terpercaya!",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                    child: Text(
                      "Top Up Saldo Skrill, PayPal, Perfect Money, Payeer, USDT & BUSD Murah hanya di Vepay!",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  SizedBox(
                    height: h * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      child: const Text('Daftar'),
                      onPressed: () async {
                        // if (_formKey.currentState!.validate()) {
                        //   setState(() {
                        //     isLoading = true;
                        //   });

                        //   loginUser();
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
