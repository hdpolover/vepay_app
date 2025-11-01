// To parse this JSON data, do
//
//     final vccModel = vccModelFromJson(jsonString);

import 'dart:convert';

VccModel vccModelFromJson(String str) => VccModel.fromJson(json.decode(str));

String vccModelToJson(VccModel data) => json.encode(data.toJson());

class VccModel {
  VccModel({
    this.id,
    this.userId,
    this.number,
    this.holder,
    this.validDate,
    this.securityCode,
    this.jenisVcc,
    this.saldo,
    this.status,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
    this.name,
    this.photo,
    this.gender,
    this.birthdate,
    this.address,
    this.phone,
    this.email,
  });

  String? id;
  String? userId;
  String? number;
  String? holder;
  String? validDate;
  String? securityCode;
  String? jenisVcc;
  String? saldo;
  String? status;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;
  String? name;
  String? photo;
  dynamic gender;
  dynamic birthdate;
  dynamic address;
  String? phone;
  String? email;

  factory VccModel.fromJson(Map<String, dynamic> json) => VccModel(
        id: json["id"],
        userId: json["user_id"],
        number: json["number"],
        holder: json["holder"],
        validDate: json["valid_date"],
        securityCode: json["security_code"],
        jenisVcc: json["jenis_vcc"],
        saldo: json["saldo"],
        status: json["status"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
        name: json["name"],
        photo: json["photo"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "number": number,
        "holder": holder,
        "valid_date": validDate,
        "security_code": securityCode,
        "jenis_vcc": jenisVcc,
        "saldo": saldo,
        "status": status,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
        "name": name,
        "photo": photo,
        "gender": gender,
        "birthdate": birthdate,
        "address": address,
        "phone": phone,
        "email": email,
      };
}
