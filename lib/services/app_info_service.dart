import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vepay_app/models/app_info_model.dart';

import '../app_constants.dart';
import '../common/global_values.dart';
import 'package:html/parser.dart' show parse;

class AppInfoService {
  Future<List<AppInfoModel>> getAppInfo() async {
    String url = "${AppConstants.apiUrl}get_all_information";

    print(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];

        List<AppInfoModel> info = [];

        for (var item in data) {
          info.add(AppInfoModel.fromJson(item));
        }

        return info;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  dynamic getValueByKey(String key) {
    // Iterate over the appInfoGlobal list
    for (final appInfo in appInfoGlobal.value) {
      // Check if the key matches
      if (appInfo.key == key) {
        return appInfo.value; // Return the value
      }
    }
    return null; // Return null if the key is not found
  }

  String removeHtmlTags(String htmlString) {
    final document = parse(htmlString);
    return document.body!.text;
  }
}
