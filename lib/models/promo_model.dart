// To parse this JSON data, do
//
//     final promoModel = promoModelFromJson(jsonString);

import 'dart:convert';

PromoModel promoModelFromJson(String str) =>
    PromoModel.fromJson(json.decode(str));

String promoModelToJson(PromoModel data) => json.encode(data.toJson());

class PromoModel {
  String? id;
  dynamic kode;
  String? jenisKonten;
  String? nama;
  String? image;
  int? value;
  int? maksimalPromo;
  int? minimumTransaksi;
  String? expired;
  dynamic publish;
  String? quota;
  dynamic jenis;
  dynamic jenisPengguna;
  String? desc;
  String? redirectLink;
  dynamic status;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;
  String? jenisPenggunaTxt;

  PromoModel({
    this.id,
    this.kode,
    this.jenisKonten,
    this.nama,
    this.image,
    this.value,
    this.maksimalPromo,
    this.minimumTransaksi,
    this.expired,
    this.publish,
    this.quota,
    this.jenis,
    this.jenisPengguna,
    this.desc,
    this.redirectLink,
    this.status,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
    this.jenisPenggunaTxt,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        id: json["id"],
        kode: json["kode"],
        jenisKonten: json["jenis_konten"],
        nama: json["nama"],
        image: json["image"],
        value: json["value"],
        maksimalPromo: json["maksimal_promo"],
        minimumTransaksi: json["minimum_transaksi"],
        expired: json["expired"],
        publish: json["publish"],
        quota: json["quota"],
        jenis: json["jenis"],
        jenisPengguna: json["jenis_pengguna"],
        desc: json["desc"],
        redirectLink: json["redirect_link"],
        status: json["status"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
        jenisPenggunaTxt: json["jenis_pengguna_txt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "jenis_konten": jenisKonten,
        "nama": nama,
        "image": image,
        "value": value,
        "maksimal_promo": maksimalPromo,
        "minimum_transaksi": minimumTransaksi,
        "expired": expired,
        "publish": publish,
        "quota": quota,
        "jenis": jenis,
        "jenis_pengguna": jenisPengguna,
        "desc": desc,
        "redirect_link": redirectLink,
        "status": status,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
        "jenis_pengguna_txt": jenisPenggunaTxt,
      };
}
