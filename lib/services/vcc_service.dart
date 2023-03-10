import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/models/vcc_model.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';

class VccService {
  Future<List<VccModel>> getVccs() async {
    var prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("user_id");

    String url = "${AppConstants.apiUrl}get_all_vcc?user_id=$userId";

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

        List<VccModel> vcc = [];

        for (var item in data) {
          vcc.add(VccModel.fromJson(item));
        }

        return vcc;
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
