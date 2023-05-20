import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vepay_app/app_constants.dart';
import 'package:vepay_app/models/pay_transaction_model.dart';

import '../models/transaction_model.dart';

class TransactionService {
  Future<List<TransactionModel>> getTransactionHistory() async {
    var prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("user_id");

    String url = "${AppConstants.apiUrl}get_all_transaction?user_id=$userId";

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

        List<TransactionModel> transactions = [];

        for (var item in data) {
          transactions.add(TransactionModel.fromJson(item));
        }

        return transactions;
      } else {
        List<TransactionModel> transactions = [];

        return transactions;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<TransactionModel>> filter(
      Map<String, dynamic> data, Map<String, dynamic> selectedProducts) async {
    var prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("user_id");

    String tempString = "[";

    selectedProducts.values.forEach((value) {
      tempString += '"$value", ';
    });

    if (tempString.endsWith(", ")) {
      tempString = tempString.substring(0, tempString.length - 2);
    }

    tempString += "]";

    String url =
        "${AppConstants.apiUrl}get_all_transaction?user_id=$userId&product=$tempString&start_date=${data['start_date']}&end_date=${data['end_date']}&type=${data['type']}";

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

        List<TransactionModel> transactions = [];

        for (var item in data) {
          transactions.add(TransactionModel.fromJson(item));
        }

        return transactions;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<TransactionModel> createTransaction(Map<String, dynamic> data) async {
    String url = "${AppConstants.apiUrl}create_transaction";

    var prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("user_id");

    print(url);

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'm_metode_id': data['m_metode_id'],
          'm_rate_id': data['m_rate_id'],
          'jumlah': data['jumlah'],
          'total_bayar': data['total_bayar'],
          'sub_total': data['sub_total'],
          "akun_tujuan": data['akun_tujuan'],
          "no_rek": data['no_rek'],
          "blockchain": data['blockchain'],
          "no_tujuan": data['no_tujuan'],
          "id_vcc": data['id_vcc'],
          "m_promo_id": data['promo_id'],
          "jenis_transaksi_vcc": data['jenis_transaksi_vcc'],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        print(result);
        return TransactionModel.fromJson(result);
      } else {
        print(jsonDecode(response.body));
        return null!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> delete(int id) async {
    String url = "${AppConstants.apiUrl}delete_transaction/$id";

    print(url);

    try {
      final http.Response response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print(result);
        return true;
      } else {
        print(jsonDecode(response.body));
        return false;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<PayTransactionModel> pay(Map<String, dynamic> data) async {
    var prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString("user_id");

    String url = "${AppConstants.apiUrl}bayar_transaction";

    print(url);

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': data['id'],
          'bukti': data['bukti'],
          'user_id': userId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var result = json.decode(response.body)['data'];
        print(result);
        print(response.body);
        return PayTransactionModel.fromJson(result);
      } else {
        print(response.statusCode);

        print(jsonDecode(response.body));
        return null!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
