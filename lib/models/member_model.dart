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
    this.username,
    this.email,
    this.password,
    this.role,
    this.status,
    this.online,
    this.isGoogle,
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
  dynamic username;
  String? email;
  String? password;
  String? role;
  String? status;
  String? online;
  String? isGoogle;
  String? device;
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
        username: json["username"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        status: json["status"],
        online: json["online"],
        isGoogle: json["is_google"],
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
        "username": username,
        "email": email,
        "password": password,
        "role": role,
        "status": status,
        "online": online,
        "is_google": isGoogle,
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
