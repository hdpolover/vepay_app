// To parse this JSON data, do
//
//     final payTransactionModel = payTransactionModelFromJson(jsonString);

import 'dart:convert';

PayTransactionModel payTransactionModelFromJson(String str) =>
    PayTransactionModel.fromJson(json.decode(str));

String payTransactionModelToJson(PayTransactionModel data) =>
    json.encode(data.toJson());

class PayTransactionModel {
  String? id;
  String? kodeTransaksi;
  String? akunTujuan;
  dynamic noTujuan;
  String? noRek;
  dynamic jenisTransaksiVcc;
  String? userId;
  String? total;
  String? subTotal;
  String? status;
  String? bukti;
  dynamic buktiVerif;
  String? name;
  String? phone;
  String? email;
  dynamic metode;
  String? imgMethod;
  dynamic noRekening;
  dynamic atasNama;
  String? type;
  String? fee;
  String? product;
  String? imgProduct;
  dynamic mBlockchainId;
  dynamic blockchain;
  String? createdAt;
  String? modifiedAt;
  String? waAdmin;

  PayTransactionModel({
    this.id,
    this.kodeTransaksi,
    this.akunTujuan,
    this.noTujuan,
    this.noRek,
    this.jenisTransaksiVcc,
    this.userId,
    this.total,
    this.subTotal,
    this.status,
    this.bukti,
    this.buktiVerif,
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
    this.imgProduct,
    this.mBlockchainId,
    this.blockchain,
    this.createdAt,
    this.modifiedAt,
    this.waAdmin,
  });

  factory PayTransactionModel.fromJson(Map<String, dynamic> json) =>
      PayTransactionModel(
        id: json["id"],
        kodeTransaksi: json["kode_transaksi"],
        akunTujuan: json["akun_tujuan"],
        noTujuan: json["no_tujuan"],
        noRek: json["no_rek"],
        jenisTransaksiVcc: json["jenis_transaksi_vcc"],
        userId: json["user_id"],
        total: json["total"],
        subTotal: json["sub_total"],
        status: json["status"],
        bukti: json["bukti"],
        buktiVerif: json["bukti_verif"],
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
        imgProduct: json["img_product"],
        mBlockchainId: json["m_blockchain_id"],
        blockchain: json["blockchain"],
        createdAt: json["created_at"],
        modifiedAt: json["modified_at"],
        waAdmin: json["wa_admin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_transaksi": kodeTransaksi,
        "akun_tujuan": akunTujuan,
        "no_tujuan": noTujuan,
        "no_rek": noRek,
        "jenis_transaksi_vcc": jenisTransaksiVcc,
        "user_id": userId,
        "total": total,
        "sub_total": subTotal,
        "status": status,
        "bukti": bukti,
        "bukti_verif": buktiVerif,
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
        "img_product": imgProduct,
        "m_blockchain_id": mBlockchainId,
        "blockchain": blockchain,
        "created_at": createdAt,
        "modified_at": modifiedAt,
        "wa_admin": waAdmin,
      };
}
