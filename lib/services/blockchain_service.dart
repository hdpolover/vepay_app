import 'dart:convert';

import 'package:vepay_app/models/blockchain_model.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';

class BlockchainService {
  Future<List<BlockchainModel>> getChains() async {
    String url = "${AppConstants.apiUrl}get_all_blockchain";

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

        List<BlockchainModel> chains = [];

        for (var item in data) {
          chains.add(BlockchainModel.fromJson(item));
        }

        return chains;
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
