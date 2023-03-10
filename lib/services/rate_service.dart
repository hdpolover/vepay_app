import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vepay_app/app_constants.dart';
import 'package:vepay_app/models/rate_model.dart';

class RateService {
  Future<List<RateModel>> getRates(String type) async {
    String url = "${AppConstants.apiUrl}get_all_rate?type=$type";

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

        List<RateModel> rates = [];

        for (var item in data) {
          rates.add(RateModel.fromJson(item));
        }

        return rates;
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
