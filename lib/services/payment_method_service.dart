import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vepay_app/app_constants.dart';
import 'package:vepay_app/models/payment_method_model.dart';

class PaymentMethodService {
  Future<List<PaymentMethodModel>> getMethods() async {
    String url = "${AppConstants.apiUrl}get_all_metode";

    print(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<PaymentMethodModel> payments = [];

        for (var item in data) {
          payments.add(PaymentMethodModel.fromJson(item));
        }

        return payments;
      } else {
        print(response.statusCode);
        throw Exception("ehe");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
