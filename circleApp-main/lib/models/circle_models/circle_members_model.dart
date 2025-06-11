import 'dart:convert';

import '../../controller/utils/global_variables.dart';

CircleMembersModel circleMembersModelFromJson(String str) => CircleMembersModel.fromJson(json.decode(str));

String circleMembersModelToJson(CircleMembersModel data) => json.encode(data.toJson());

class CircleMembersModel {
  bool success;
  String message;
  List<Member> members;

  CircleMembersModel({
    required this.success,
    required this.message,
    required this.members,
  });

  CircleMembersModel copyWith({
    bool? success,
    String? message,
    List<Member>? members,
  }) =>
      CircleMembersModel(
        success: success ?? this.success,
        message: message ?? this.message,
        members: members ?? this.members,
      );

  factory CircleMembersModel.fromJson(Map<String, dynamic> json) => CircleMembersModel(
    success: json["success"],
    message: json["message"],
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
  };
}

class Member {
  String id;
  String phoneNumber;
  String name;
  String profilePicture;

  Member({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.profilePicture,
  });

  Member copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? profilePicture,
  }) =>
      Member(
        id: id ?? this.id,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["_id"],
    phoneNumber: json["phoneNumber"],
    name: json["name"] ?? "",
    profilePicture: json["profilePicture"] ?? userimagePlaceholder,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "phoneNumber": phoneNumber,
    "name": name,
    "profilePicture": profilePicture,
  };
}
