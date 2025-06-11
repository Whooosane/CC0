import 'dart:convert';

import '../controller/utils/global_variables.dart';

StoriesModel storiesModelFromJson(String str) => StoriesModel.fromJson(json.decode(str));

String storiesModelToJson(StoriesModel data) => json.encode(data.toJson());

class StoriesModel {
  String message;
  List<Datum> data;

  StoriesModel({
    required this.message,
    required this.data,
  });

  factory StoriesModel.fromJson(Map<String, dynamic> json) => StoriesModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  User user;
  List<Story> stories;

  Datum({
    required this.user,
    required this.stories,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        user: User.fromJson(json["user"]),
        stories: List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "stories": List<dynamic>.from(stories.map((x) => x.toJson())),
      };
}

class Story {
  String id;
  String mediaUrl;
  String mediaType;
  String text;
  DateTime createdAt;

  Story({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
    required this.text,
    required this.createdAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json["id"],
        mediaUrl: json["mediaUrl"],
        mediaType: json["mediaType"],
        text: json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mediaUrl": mediaUrl,
        "mediaType": mediaType,
        "text": text,
        "createdAt": createdAt.toIso8601String(),
      };
}

class User {
  String id;
  String name;
  String profilePicture;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profilePicture"] ?? userimagePlaceholder,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profilePicture": profilePicture,
      };
}
