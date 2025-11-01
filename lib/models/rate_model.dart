// To parse this JSON data, do
//
//     final rateModel = rateModelFromJson(jsonString);

import 'dart:convert';

RateModel rateModelFromJson(String str) => RateModel.fromJson(json.decode(str));

String rateModelToJson(RateModel data) => json.encode(data.toJson());

class RateModel {
  String? id;
  String? mProductId;
  String? type;
  String? price;
  String? fee;
  String? kursType;
  String? minimumPembelian;
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
  List<Rule>? rules;
  String? feeType;

  RateModel({
    this.id,
    this.mProductId,
    this.type,
    this.price,
    this.fee,
    this.kursType,
    this.minimumPembelian,
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
    this.rules,
    this.feeType,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
        id: json["id"],
        mProductId: json["m_product_id"],
        type: json["type"],
        price: json["price"],
        fee: json["fee"],
        kursType: json["kurs_type"],
        minimumPembelian: json["minimum_pembelian"],
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
        rules: json["rules"] == null
            ? []
            : List<Rule>.from(json["rules"]!.map((x) => Rule.fromJson(x))),
        feeType: json["fee_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "m_product_id": mProductId,
        "type": type,
        "price": price,
        "fee": fee,
        "kurs_type": kursType,
        "minimum_pembelian": minimumPembelian,
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
        "rules": rules == null
            ? []
            : List<dynamic>.from(rules!.map((x) => x.toJson())),
        "fee_type": feeType,
      };
}

class Rule {
  String? condition;
  String? quantity;
  String? type;
  String? fee;

  Rule({
    this.condition,
    this.quantity,
    this.type,
    this.fee,
  });

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        condition: json["condition"],
        quantity: json["quantity"],
        type: json["type"],
        fee: json["fee"],
      );

  Map<String, dynamic> toJson() => {
        "condition": condition,
        "quantity": quantity,
        "type": type,
        "fee": fee,
      };
}
