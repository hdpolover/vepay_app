// To parse this JSON data, do
//
//     final appInfoModel = appInfoModelFromJson(jsonString);

import 'dart:convert';

AppInfoModel appInfoModelFromJson(String str) =>
    AppInfoModel.fromJson(json.decode(str));

String appInfoModelToJson(AppInfoModel data) => json.encode(data.toJson());

class AppInfoModel {
  String? key;
  String? value;
  dynamic desc;

  AppInfoModel({
    this.key,
    this.value,
    this.desc,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) => AppInfoModel(
        key: json["key"],
        value: json["value"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "desc": desc,
      };
}
