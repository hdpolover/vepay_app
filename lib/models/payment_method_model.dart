// To parse this JSON data, do
//
//     final paymentMethodModel = paymentMethodModelFromJson(jsonString);

import 'dart:convert';

PaymentMethodModel? paymentMethodModelFromJson(String str) =>
    PaymentMethodModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentMethodModel? data) =>
    json.encode(data!.toJson());

class PaymentMethodModel {
  PaymentMethodModel({
    this.id,
    this.metode,
    this.image,
    this.description,
    this.noRekening,
    this.atasNama,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
  });

  String? id;
  String? metode;
  String? image;
  String? description;
  String? noRekening;
  String? atasNama;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: json["id"],
        metode: json["metode"],
        image: json["image"],
        description: json["description"],
        noRekening: json["no_rekening"],
        atasNama: json["atas_nama"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "metode": metode,
        "image": image,
        "description": description,
        "no_rekening": noRekening,
        "atas_nama": atasNama,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
      };
}
