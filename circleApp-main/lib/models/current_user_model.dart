import 'dart:convert';
import '../controller/utils/global_variables.dart';

CurrentUserModel userModelFromJson(String str) => CurrentUserModel.fromJson(json.decode(str));

String userModelToJson(CurrentUserModel data) => json.encode(data.toJson());

class CurrentUserModel {
  bool success;
  Data data;

  CurrentUserModel({
    required this.success,
    required this.data,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) => CurrentUserModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String phoneNumber;
  String name;
  String email;
  String profilePicture;

  Data({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        phoneNumber: json["phoneNumber"],
        name: json["name"],
        email: json["email"],
        profilePicture: json["profilePicture"] ?? userimagePlaceholder,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phoneNumber": phoneNumber,
        "name": name,
        "email": email,
        "profilePicture": profilePicture,
      };
}
