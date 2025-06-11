import 'dart:convert';

import '../controller/utils/global_variables.dart';

class AllUsersModel {
  bool success;
  List<Datum> data;

  AllUsersModel({
    required this.success,
    required this.data,
  });

  factory AllUsersModel.fromRawJson(String str) => AllUsersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllUsersModel.fromJson(Map<String, dynamic> json) => AllUsersModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String phoneNumber;
  String name;
  String email;
  String? profilePicture;

  Datum({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.email,
    this.profilePicture,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    phoneNumber: json["phoneNumber"],
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    profilePicture: json["profilePicture"] ?? circleImagePlaceholder,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "phoneNumber": phoneNumber,
    "name": name,
    "email": email,
    "profilePicture": profilePicture,
  };
}
