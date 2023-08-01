// To parse this JSON data, do
//
//     final referredFriendModel = referredFriendModelFromJson(jsonString);

import 'dart:convert';

ReferredFriendModel referredFriendModelFromJson(String str) =>
    ReferredFriendModel.fromJson(json.decode(str));

String referredFriendModelToJson(ReferredFriendModel data) =>
    json.encode(data.toJson());

class ReferredFriendModel {
  String? userId;
  String? email;
  String? name;
  String? photo;
  String? joinedAt;

  ReferredFriendModel({
    this.userId,
    this.email,
    this.name,
    this.photo,
    this.joinedAt,
  });

  factory ReferredFriendModel.fromJson(Map<String, dynamic> json) =>
      ReferredFriendModel(
        userId: json["user_id"],
        email: json["email"],
        name: json["name"],
        photo: json["photo"],
        joinedAt: json["joined_at"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "name": name,
        "photo": photo,
        "joined_at": joinedAt,
      };
}
