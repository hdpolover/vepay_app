import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vepay_app/app_constants.dart';
import 'package:vepay_app/common/global_values.dart';
import 'package:vepay_app/models/my_referral_model.dart';
import 'package:vepay_app/models/referral_history_model.dart';
import 'package:vepay_app/models/referral_info_model.dart';
import 'package:vepay_app/models/referred_friend_model.dart';
import 'package:vepay_app/models/withdraw_cashback_model.dart';

class ReferralService {
  Future<List<ReferredFriendModel>> getFriends() async {
    String url =
        "${AppConstants.apiUrl}referral-friends/${currentMemberGlobal.value.userId}";

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

        List<ReferredFriendModel> friends = [];

        for (var item in data) {
          friends.add(ReferredFriendModel.fromJson(item));
        }

        return friends;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<ReferralHistoryModel>> getRiwayat() async {
    String url =
        "${AppConstants.apiUrl}referral-transaction/${currentMemberGlobal.value.userId}";
    //String url = "${AppConstants.apiUrl}referral-transaction/USR-FBRY-fffdf7";

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

        List<ReferralHistoryModel> history = [];

        for (var item in data) {
          history.add(ReferralHistoryModel.fromJson(item));
        }

        return history;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ReferralInfoModel> getReferralInfo() async {
    String url = "${AppConstants.apiUrl}referral-information";

    print(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        return ReferralInfoModel.fromJson(result);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<MyReferralModel> getMyReferral() async {
    String url =
        "${AppConstants.apiUrl}referral/${currentMemberGlobal.value.userId}";

    print(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        return MyReferralModel.fromJson(result);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> setReferral(String kode) async {
    String url =
        "${AppConstants.apiUrl}set-referral/${currentMemberGlobal.value.userId}";

    print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'kode_referral': kode,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        return result;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> updateKode(String kode) async {
    String url =
        "${AppConstants.apiUrl}kode_referral/${currentMemberGlobal.value.userId}";

    print(url);

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'kode_referral': kode,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['status'];
        return result;
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<WithdrawCashbackModel> withdraw(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}referral/";

    print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': currentMemberGlobal.value.userId,
          'rekening_tujuan': data['rekening_tujuan'],
          'atas_nama': data['atas_nama'],
          'nominal': data['nominal'],
          'metode': data['metode'],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        return WithdrawCashbackModel.fromJson(result);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
