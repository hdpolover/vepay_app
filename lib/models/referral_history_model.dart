// To parse this JSON data, do
//
//     final referralHistoryModel = referralHistoryModelFromJson(jsonString);

import 'dart:convert';

ReferralHistoryModel referralHistoryModelFromJson(String str) =>
    ReferralHistoryModel.fromJson(json.decode(str));

String referralHistoryModelToJson(ReferralHistoryModel data) =>
    json.encode(data.toJson());

class ReferralHistoryModel {
  String? id;
  String? kode;
  String? type;
  String? rekeningTujuan;
  String? atasNama;
  String? metode;
  String? nominal;
  String? status;
  String? createdAt;
  String? name;
  String? message;

  ReferralHistoryModel({
    this.id,
    this.kode,
    this.type,
    this.rekeningTujuan,
    this.atasNama,
    this.metode,
    this.nominal,
    this.status,
    this.createdAt,
    this.name,
    this.message,
  });

  factory ReferralHistoryModel.fromJson(Map<String, dynamic> json) =>
      ReferralHistoryModel(
        id: json["id"],
        kode: json["kode"],
        type: json["type"],
        rekeningTujuan: json["rekening_tujuan"],
        atasNama: json["atas_nama"],
        metode: json["metode"],
        nominal: json["nominal"],
        status: json["status"],
        createdAt: json["created_at"],
        name: json["name"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "type": type,
        "rekening_tujuan": rekeningTujuan,
        "atas_nama": atasNama,
        "metode": metode,
        "nominal": nominal,
        "status": status,
        "created_at": createdAt,
        "name": name,
        "message": message,
      };
}
