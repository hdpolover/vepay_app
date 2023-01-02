// To parse this JSON data, do
//
//     final promoModel = promoModelFromJson(jsonString);

import 'dart:convert';

PromoModel promoModelFromJson(String str) =>
    PromoModel.fromJson(json.decode(str));

String promoModelToJson(PromoModel data) => json.encode(data.toJson());

class PromoModel {
  PromoModel({
    this.id,
    this.kode,
    this.nama,
    this.image,
    this.value,
    this.expired,
    this.quota,
    this.jenis,
    this.status,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
  });

  String? id;
  String? kode;
  String? nama;
  String? image;
  String? value;
  String? expired;
  String? quota;
  String? jenis;
  String? status;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        id: json["id"],
        kode: json["kode"],
        nama: json["nama"],
        image: json["image"],
        value: json["value"],
        expired: json["expired"],
        quota: json["quota"],
        jenis: json["jenis"],
        status: json["status"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "nama": nama,
        "image": image,
        "value": value,
        "expired": expired,
        "quota": quota,
        "jenis": jenis,
        "status": status,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
      };
}
