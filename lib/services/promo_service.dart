import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_constants.dart';
import '../models/promo_model.dart';

class PromoService {
  Future<List<PromoModel>> getPromos() async {
    String url = "${AppConstants.apiUrl}get_all_promo";

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

        List<PromoModel> promos = [];

        for (var item in data) {
          promos.add(PromoModel.fromJson(item));
        }

        return promos;
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
