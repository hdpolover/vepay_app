// To parse this JSON data, do
//
//     final blockchainModel = blockchainModelFromJson(jsonString);

import 'dart:convert';

BlockchainModel blockchainModelFromJson(String str) =>
    BlockchainModel.fromJson(json.decode(str));

String blockchainModelToJson(BlockchainModel data) =>
    json.encode(data.toJson());

class BlockchainModel {
  BlockchainModel({
    this.id,
    this.blockchain,
    this.description,
    this.fee,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
  });

  String? id;
  String? blockchain;
  String? description;
  String? fee;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;

  factory BlockchainModel.fromJson(Map<String, dynamic> json) =>
      BlockchainModel(
        id: json["id"],
        blockchain: json["blockchain"],
        description: json["description"],
        fee: json["fee"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blockchain": blockchain,
        "description": description,
        "fee": fee,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
      };
}
