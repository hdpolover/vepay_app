// To parse this JSON data, do
//
//     final myReferralModel = myReferralModelFromJson(jsonString);

import 'dart:convert';

MyReferralModel myReferralModelFromJson(String str) =>
    MyReferralModel.fromJson(json.decode(str));

String myReferralModelToJson(MyReferralModel data) =>
    json.encode(data.toJson());

class MyReferralModel {
  String? userId;
  String? name;
  String? email;
  dynamic phone;
  String? kodeReferral;
  int? saldoReferral;
  String? caraPenggunaan;
  String? status;

  MyReferralModel({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.kodeReferral,
    this.saldoReferral,
    this.caraPenggunaan,
    this.status,
  });

  factory MyReferralModel.fromJson(Map<String, dynamic> json) =>
      MyReferralModel(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        kodeReferral: json["kode_referral"],
        saldoReferral: json["saldo_referral"],
        caraPenggunaan: json["cara_penggunaan"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "kode_referral": kodeReferral,
        "saldo_referral": saldoReferral,
        "cara_penggunaan": caraPenggunaan,
        "status": status,
      };
}
