// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.mCategoriesId,
    this.name,
    this.image,
    this.fee,
    this.description,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
    this.categories,
  });

  String? id;
  String? mCategoriesId;
  String? name;
  String? image;
  String? fee;
  String? description;
  String? createdAt;
  String? createdBy;
  String? modifiedAt;
  String? modifiedBy;
  String? isDeleted;
  String? categories;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        mCategoriesId: json["m_categories_id"],
        name: json["name"],
        image: json["image"],
        fee: json["fee"],
        description: json["description"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        modifiedAt: json["modified_at"],
        modifiedBy: json["modified_by"],
        isDeleted: json["is_deleted"],
        categories: json["categories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "m_categories_id": mCategoriesId,
        "name": name,
        "image": image,
        "fee": fee,
        "description": description,
        "created_at": createdAt,
        "created_by": createdBy,
        "modified_at": modifiedAt,
        "modified_by": modifiedBy,
        "is_deleted": isDeleted,
        "categories": categories,
      };
}
