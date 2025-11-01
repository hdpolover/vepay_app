// To parse this JSON data, do
//
//     final referralInfoModel = referralInfoModelFromJson(jsonString);

import 'dart:convert';

ReferralInfoModel referralInfoModelFromJson(String str) =>
    ReferralInfoModel.fromJson(json.decode(str));

String referralInfoModelToJson(ReferralInfoModel data) =>
    json.encode(data.toJson());

class ReferralInfoModel {
  Interest? interest;
  String? penggunaan;
  String? image;
  String? title;
  String? description;
  String? titleReferralIntro;
  String? descReferralIntro;
  String? referralDescInfo;
  int? referralWithdrawMinimum;

  ReferralInfoModel({
    this.interest,
    this.penggunaan,
    this.image,
    this.title,
    this.description,
    this.titleReferralIntro,
    this.descReferralIntro,
    this.referralDescInfo,
    this.referralWithdrawMinimum,
  });

  factory ReferralInfoModel.fromJson(Map<String, dynamic> json) =>
      ReferralInfoModel(
        interest: json["interest"] == null
            ? null
            : Interest.fromJson(json["interest"]),
        penggunaan: json["penggunaan"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        titleReferralIntro: json["title_referral_intro"],
        descReferralIntro: json["desc_referral_intro"],
        referralDescInfo: json["referral_desc_info"],
        referralWithdrawMinimum: json["referral_withdraw_minimum"],
      );

  Map<String, dynamic> toJson() => {
        "interest": interest?.toJson(),
        "penggunaan": penggunaan,
        "image": image,
        "title": title,
        "description": description,
        "title_referral_intro": titleReferralIntro,
        "desc_referral_intro": descReferralIntro,
        "referral_desc_info": referralDescInfo,
        "referral_withdraw_minimum": referralWithdrawMinimum,
      };
}

class Interest {
  String? interestQuantity;
  String? interestCashback;
  String? interestMinimal;

  Interest({
    this.interestQuantity,
    this.interestCashback,
    this.interestMinimal,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        interestQuantity: json["interest_quantity"],
        interestCashback: json["interest_cashback"],
        interestMinimal: json["interest_minimal"],
      );

  Map<String, dynamic> toJson() => {
        "interest_quantity": interestQuantity,
        "interest_cashback": interestCashback,
        "interest_minimal": interestMinimal,
      };
}
