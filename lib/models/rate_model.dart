// To parse this JSON data, do
//
//     final rateModel = rateModelFromJson(jsonString);

import 'dart:convert';

RateModel rateModelFromJson(String str) => RateModel.fromJson(json.decode(str));

String rateModelToJson(RateModel data) => json.encode(data.toJson());

class RateModel {
  RateModel({
    this.id,
    this.mProductId,
    this.type,
    this.price,
    this.fee,
    this.status,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
    this.mCategoriesId,
    this.name,
    this.image,
    this.description,
    this.isActive,
    this.order,
    this.categories,
  });

  String? id;
  String? mProductId;
  String? type;
  String? price;
  String? fee;
  String? status;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;
  String? mCategoriesId;
  String? name;
  String? image;
  String? description;
  String? isActive;
  String? order;
  String? categories;

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        id: json["id"],
        mProductId: json["m_product_id"],
        type: json["type"],
        price: json["price"],
        fee: json["fee"],
        status: json["status"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
        mCategoriesId: json["m_categories_id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        isActive: json["is_active"],
        order: json["order"],
        categories: json["categories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "m_product_id": mProductId,
        "type": type,
        "price": price,
        "fee": fee,
        "status": status,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
        "m_categories_id": mCategoriesId,
        "name": name,
        "image": image,
        "description": description,
        "is_active": isActive,
        "order": order,
        "categories": categories,
      };
}
