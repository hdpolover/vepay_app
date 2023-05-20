// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    this.id,
    this.kodeTransaksi,
    this.akunTujuan,
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
  });

  String? id;
  String? kodeTransaksi;
  String? akunTujuan;
  String? userId;
  String? total;
  String? subTotal;
  String? status;
  String? bukti;
  String? buktiVerif;
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
  String? imgProduct;
  dynamic mBlockchainId;
  dynamic blockchain;
  String? createdAt;
  String? modifiedAt;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        kodeTransaksi: json["kode_transaksi"],
        akunTujuan: json["akun_tujuan"],
        userId: json["user_id"],
        total: json["total"],
        subTotal: json["sub_total"],
        status: json["status"],
        bukti: json["bukti"],
        buktiVerif: json["bukti_verif"] == null ? "" : json["bukti_verif"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_transaksi": kodeTransaksi,
        "akun_tujuan": akunTujuan,
        "user_id": userId,
        "total": total,
        "sub_total": subTotal,
        "status": status,
        "bukti": bukti,
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
      };
}
