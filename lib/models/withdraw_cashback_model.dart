// To parse this JSON data, do
//
//     final withdrawCashbackModel = withdrawCashbackModelFromJson(jsonString);

import 'dart:convert';

WithdrawCashbackModel withdrawCashbackModelFromJson(String str) =>
    WithdrawCashbackModel.fromJson(json.decode(str));

String withdrawCashbackModelToJson(WithdrawCashbackModel data) =>
    json.encode(data.toJson());

class WithdrawCashbackModel {
  int? id;
  String? kode;
  String? userId;
  String? name;
  String? rekeningTujuan;
  String? atasNama;
  int? nominal;
  dynamic metode;
  int? status;
  String? createdAt;

  WithdrawCashbackModel({
    this.id,
    this.kode,
    this.userId,
    this.name,
    this.rekeningTujuan,
    this.atasNama,
    this.nominal,
    this.metode,
    this.status,
    this.createdAt,
  });

  factory WithdrawCashbackModel.fromJson(Map<String, dynamic> json) =>
      WithdrawCashbackModel(
        id: json["id"],
        kode: json["kode"],
        userId: json["user_id"],
        name: json["name"],
        rekeningTujuan: json["rekening_tujuan"],
        atasNama: json["atas_nama"],
        nominal: json["nominal"],
        metode: json["metode"],
        status: json["status"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "user_id": userId,
        "name": name,
        "rekening_tujuan": rekeningTujuan,
        "atas_nama": atasNama,
        "nominal": nominal,
        "metode": metode,
        "status": status,
        "created_at": createdAt,
      };
}
