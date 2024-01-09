class ProfileRequestModel {
  String? userId;
  String? name;
  String? gender;
  String? birthdate;
  String? phone;
  String? address;

  ProfileRequestModel({
    this.userId,
    this.name,
    this.gender,
    this.birthdate,
    this.phone,
    this.address,
  });

  factory ProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      ProfileRequestModel(
        userId: json["user_id"],
        name: json["name"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "gender": gender,
        "birthdate": birthdate,
        "phone": phone,
        "address": address,
      };
}
