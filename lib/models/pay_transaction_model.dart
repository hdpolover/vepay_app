// To parse this JSON data, do
//
//     final payTransactionModel = payTransactionModelFromJson(jsonString);

import 'dart:convert';

PayTransactionModel? payTransactionModelFromJson(String str) =>
    PayTransactionModel.fromJson(json.decode(str));

String payTransactionModelToJson(PayTransactionModel? data) =>
    json.encode(data!.toJson());

class PayTransactionModel {
  PayTransactionModel({
    this.id,
    this.kodeTransaksi,
    this.total,
    this.subTotal,
    this.bukti,
    this.userId,
    this.name,
    this.phone,
    this.email,
    this.metode,
    this.imgMethod,
    this.noRekening,
    this.atasNama,
    this.type,
    this.fee,
    this.product,
    this.waAdmin,
  });

  String? id;
  String? kodeTransaksi;
  String? total;
  String? subTotal;
  String? bukti;
  String? userId;
  String? name;
  String? phone;
  String? email;
  String? metode;
  String? imgMethod;
  String? noRekening;
  String? atasNama;
  String? type;
  String? fee;
  String? product;
  String? waAdmin;

  factory PayTransactionModel.fromJson(Map<String, dynamic> json) =>
      PayTransactionModel(
        id: json["id"],
        kodeTransaksi: json["kode_transaksi"],
        total: json["total"],
        subTotal: json["sub_total"],
        bukti: json["bukti"],
        userId: json["user_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        metode: json["metode"],
        imgMethod: json["img_method"],
        noRekening: json["no_rekening"],
        atasNama: json["atas_nama"],
        type: json["type"],
        fee: json["fee"],
        product: json["product"],
        waAdmin: json["wa_admin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_transaksi": kodeTransaksi,
        "total": total,
        "sub_total": subTotal,
        "bukti": bukti,
        "user_id": userId,
        "name": name,
        "phone": phone,
        "email": email,
        "metode": metode,
        "img_method": imgMethod,
        "no_rekening": noRekening,
        "atas_nama": atasNama,
        "type": type,
        "fee": fee,
        "product": product,
        "wa_admin": waAdmin,
      };
}
