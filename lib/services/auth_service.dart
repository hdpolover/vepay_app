import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vepay_app/app_constants.dart';
import 'package:vepay_app/models/member_model.dart';

class AuthService {
  Future<MemberModel> register(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}register";

    print(url);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nama': data['name'],
          'email': data['email'],
          'phone': data['phone'],
          'password': data['password'],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        print(result);
        return MemberModel.fromJson(result);
      } else {
        print(jsonDecode(response.body));
        return null!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<MemberModel> login(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}login";

    print(url);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': data['email'],
          'password': data['password'],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        return MemberModel.fromJson(result);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
