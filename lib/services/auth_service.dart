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
          'is_google': data['is_google'].toString(),
          'nama': data['nama'],
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
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<MemberModel> login(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}login";

    print(url);

    print(data['is_google']);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'is_google': data['is_google'].toString(),
          'email': data['email'],
          'password': data['password'],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        print(result['is_google']);
        return MemberModel.fromJson(result);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> resetPassword(String email) async {
    String url = "${AppConstants.apiUrl}forgot_password";

    print(url);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body)['status'];
        return result;
      } else {
        return jsonDecode(response.body)['status'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> updateDetail(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}update_detail_member";

    print(url);

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_id": data['user_id'],
          "name": data['name'],
          "gender": data['gender'],
          "birthdate": data['birthdate'],
          "phone": data['phone'],
          "address": data['address'],
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        var result = json.decode(response.body)['status'];
        return result;
      } else {
        print(response.body);

        return jsonDecode(response.body)['status'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> updateFoto(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}update_photo_member";

    print(url);

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_id": data['user_id'],
          "photo": data['photo'],
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        var result = json.decode(response.body)['status'];
        return result;
      } else {
        print(response.body);

        return jsonDecode(response.body)['status'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
