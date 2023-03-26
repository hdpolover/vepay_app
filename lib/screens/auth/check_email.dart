import 'package:flutter/material.dart';
import 'package:vepay_app/screens/auth/login.dart';

import '../../resources/color_manager.dart';

class CheckEmail extends StatefulWidget {
  String email;
  CheckEmail({required this.email, Key? key}) : super(key: key);

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Image(
              width: MediaQuery.of(context).size.width * 0.7,
              image: const AssetImage('assets/email_sent.png'),
            ),
          ),
          Text(
            "Email telah terkirim!",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Center(
              child: Text(
                "Lakukan pengecekan pada email Anda ${widget.email} dan lakukan instruksi yang tertera untuk mengganti password.",
                textAlign: TextAlign.center,
                // style: Theme.of(context)
                //     .textTheme
                //     .bodyText1
                //     ?.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary, // background
                  foregroundColor: Colors.white, // foreground
                ),
                child: const Text('Kembali'),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
