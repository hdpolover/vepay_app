// To parse this JSON data, do
//
//     final withdrawModel = withdrawModelFromJson(jsonString);

import 'dart:convert';

WithdrawModel withdrawModelFromJson(String str) =>
    WithdrawModel.fromJson(json.decode(str));

String withdrawModelToJson(WithdrawModel data) => json.encode(data.toJson());

class WithdrawModel {
  String? id;
  String? withdraw;
  String? image;
  String? description;
  String? noRekening;
  String? atasNama;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;

  WithdrawModel({
    this.id,
    this.withdraw,
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

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => WithdrawModel(
        id: json["id"],
        withdraw: json["withdraw"],
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
        "withdraw": withdraw,
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
