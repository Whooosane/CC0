import 'dart:convert';

GetCircleModel getCircleModelFromJson(String str) => GetCircleModel.fromJson(json.decode(str));

String getCircleModelToJson(GetCircleModel data) => json.encode(data.toJson());

class GetCircleModel {
  bool success;
  String message;
  List<Circle> circles;

  GetCircleModel({
    required this.success,
    required this.message,
    required this.circles,
  });

  factory GetCircleModel.fromJson(Map<String, dynamic> json) => GetCircleModel(
    success: json["success"],
    message: json["message"],
    circles: List<Circle>.from(
        (json["circleWithLastMessage"] ?? []).map((x) => Circle.fromJson(x))
    ),
  );


  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "circles": List<dynamic>.from(circles.map((x) => x.toJson())),
      };
}

class Circle {
  String id;
  String circleName;
  String circleImage;
  String description;
  String lastMessage;
  String lastMessageTime;

  Circle({
    required this.id,
    required this.circleName,
    required this.circleImage,
    required this.description,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Circle.fromJson(Map<String, dynamic> json) => Circle(
        id: json["_id"],
        circleName: json["circleName"]??"",
        circleImage: json["circleImage"]??"",
        description: json["description"]??"",
        lastMessage: json["lastMessage"]??"",
        lastMessageTime: json["lastMessageTime"]??"",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "circleName": circleName,
        "circleImage": circleImage,
        "description": description,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
      };
}
