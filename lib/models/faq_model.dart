// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  String? id;
  String? judul;
  String? deskripsi;
  String? order;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;

  FaqModel({
    this.id,
    this.judul,
    this.deskripsi,
    this.order,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        id: json["id"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        order: json["order"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "deskripsi": deskripsi,
        "order": order,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
      };
}
