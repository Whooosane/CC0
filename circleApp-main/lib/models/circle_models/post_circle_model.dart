import 'dart:convert';

PostCircleModel circleModelFromJson(String str) => PostCircleModel.fromJson(json.decode(str));

String circleModelToJson(PostCircleModel data) => json.encode(data.toJson());

class PostCircleModel {
  String circleName;
  String circleImage;
  String description;
  String type;
  String interest;
  List<String> members;
  String owner;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  PostCircleModel({
    required this.circleName,
    required this.circleImage,
    required this.description,
    required this.type,
    required this.interest,
    required this.members,
    required this.owner,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PostCircleModel.fromJson(Map<String, dynamic> json) => PostCircleModel(
        circleName: json["circleName"],
        circleImage: json["circleImage"],
        description: json["description"],
        type: json["type"],
        interest: json["interest"],
        members: List<String>.from(json["members"].map((x) => x)),
        owner: json["owner"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "circleName": circleName,
        "circleImage": circleImage,
        "description": description,
        "type": type,
        "interest": interest,
        "members": List<dynamic>.from(members.map((x) => x)),
        "owner": owner,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
