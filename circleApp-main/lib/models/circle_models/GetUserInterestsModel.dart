import 'dart:convert';

GetUserInterestsModel getUserInterestsModelFromJson(String str) => GetUserInterestsModel.fromJson(json.decode(str));

String getUserInterestsModelToJson(GetUserInterestsModel data) => json.encode(data.toJson());

class GetUserInterestsModel {
  bool success;
  List<String> interests;

  GetUserInterestsModel({
    required this.success,
    required this.interests,
  });

  GetUserInterestsModel copyWith({
    bool? success,
    List<String>? interests,
  }) =>
      GetUserInterestsModel(
        success: success ?? this.success,
        interests: interests ?? this.interests,
      );

  factory GetUserInterestsModel.fromJson(Map<String, dynamic> json) => GetUserInterestsModel(
    success: json["success"],
    interests: List<String>.from(json["interests"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "interests": List<dynamic>.from(interests.map((x) => x)),
  };
}
