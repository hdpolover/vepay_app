import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/app_constants.dart';
import 'package:vepay_app/models/member_model.dart';

class AuthService {
  Future<MemberModel> register(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}register";

    print(url);

    bool isGoogle = data['is_google'];

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: isGoogle
            ? jsonEncode(<String, dynamic>{
                'is_google': data['is_google'],
                'email': data['email'],
                'nama': data['nama'],
              })
            : jsonEncode(<String, dynamic>{
                'is_google': data['is_google'],
                'nama': data['nama'],
                'email': data['email'],
                'phone': data['phone'],
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
      throw Exception(e);
    }
  }

  Future<MemberModel> login(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}login";

    print(url);

    bool isGoogle = data['is_google'];

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: isGoogle
            ? jsonEncode(<String, dynamic>{
                'is_google': isGoogle,
                'email': data['email'],
              })
            : jsonEncode(<String, dynamic>{
                'is_google': isGoogle,
                'email': data['email'],
                'password': data['password'],
              }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        return MemberModel.fromJson(result);
      } else {
        throw jsonDecode(response.body)['data'];
      }
    } catch (e) {
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

  Future<MemberModel> getMemberDetail() async {
    var prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("user_id");

    String url = "${AppConstants.apiUrl}get_detail_member?user_id=$userId";

    print(url);

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
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
