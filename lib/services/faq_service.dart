import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_constants.dart';
import '../models/faq_model.dart';

class FaqService {
  Future<List<FaqModel>> getFaqs() async {
    String url = "${AppConstants.apiUrl}faq";

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

        List<FaqModel> faq = [];

        for (var item in data) {
          faq.add(FaqModel.fromJson(item));
        }

        return faq;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
