// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

MemberModel memberModelFromJson(String str) =>
    MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel data) => json.encode(data.toJson());

class MemberModel {
  MemberModel({
    this.userId,
    this.email,
    this.password,
    this.role,
    this.status,
    this.online,
    this.device,
    this.logTime,
    this.createdAt,
    this.isDeleted,
    this.name,
    this.photo,
    this.gender,
    this.birthdate,
    this.address,
    this.phone,
  });

  String? userId;
  String? email;
  String? password;
  String? role;
  String? status;
  String? online;
  dynamic device;
  String? logTime;
  String? createdAt;
  String? isDeleted;
  String? name;
  dynamic photo;
  dynamic gender;
  dynamic birthdate;
  dynamic address;
  String? phone;

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        userId: json["user_id"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        status: json["status"],
        online: json["online"],
        device: json["device"],
        logTime: json["log_time"],
        createdAt: json["created_at"],
        isDeleted: json["is_deleted"],
        name: json["name"],
        photo: json["photo"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        address: json["address"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "password": password,
        "role": role,
        "status": status,
        "online": online,
        "device": device,
        "log_time": logTime,
        "created_at": createdAt,
        "is_deleted": isDeleted,
        "name": name,
        "photo": photo,
        "gender": gender,
        "birthdate": birthdate,
        "address": address,
        "phone": phone,
      };
}
