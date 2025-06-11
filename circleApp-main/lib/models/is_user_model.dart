import 'dart:convert';

List<IsUserModel> isUserModelFromJson(String str) => List<IsUserModel>.from(json.decode(str).map((x) => IsUserModel.fromJson(x)));

String isUserModelToJson(List<IsUserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IsUserModel {
  String phoneNumber;
  String userId;
  bool isUser;

  IsUserModel({
    required this.phoneNumber,
    required this.userId,
    required this.isUser,
  });

  factory IsUserModel.fromJson(Map<String, dynamic> json) => IsUserModel(
        phoneNumber: json["phoneNumber"],
        userId: json["userId"] ?? "",
        isUser: json["isUser"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "userId": userId,
        "isUser": isUser,
      };
}
