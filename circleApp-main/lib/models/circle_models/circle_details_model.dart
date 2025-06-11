import 'dart:convert';

import '../../controller/utils/global_variables.dart';

CircleDetailsModel circleDetailsModelFromJson(String str) => CircleDetailsModel.fromJson(json.decode(str));
String circleDetailsModelToJson(CircleDetailsModel data) => json.encode(data.toJson());

class CircleDetailsModel {
  bool success;
  String message;
  Circle circle;

  CircleDetailsModel({
    required this.success,
    required this.message,
    required this.circle,
  });

  CircleDetailsModel copyWith({
    bool? success,
    String? message,
    Circle? circle,
  }) =>
      CircleDetailsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        circle: circle ?? this.circle,
      );

  factory CircleDetailsModel.fromJson(Map<String, dynamic> json) => CircleDetailsModel(
    success: json["success"],
    message: json["message"],
    circle: Circle.fromJson(json["circle"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "circle": circle.toJson(),
  };
}

class Circle {
  String id;
  String circleName;
  String circleImage;
  String description;
  String type;
  String interest;
  List<Owner> members;
  Owner owner;
  List<String> todos;
  List<String> events;
  String convos;
  DateTime createdAt;
  DateTime updatedAt;

  Circle({
    required this.id,
    required this.circleName,
    required this.circleImage,
    required this.description,
    required this.type,
    required this.interest,
    required this.members,
    required this.owner,
    required this.todos,
    required this.events,
    required this.convos,
    required this.createdAt,
    required this.updatedAt,
  });

  Circle copyWith({
    String? id,
    String? circleName,
    String? circleImage,
    String? description,
    String? type,
    String? interest,
    List<Owner>? members,
    Owner? owner,
    List<String>? todos,
    List<String>? events,
    String? convos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Circle(
        id: id ?? this.id,
        circleName: circleName ?? this.circleName,
        circleImage: circleImage ?? this.circleImage,
        description: description ?? this.description,
        type: type ?? this.type,
        interest: interest ?? this.interest,
        members: members ?? this.members,
        owner: owner ?? this.owner,
        todos: todos ?? this.todos,
        events: events ?? this.events,
        convos: convos ?? this.convos,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Circle.fromJson(Map<String, dynamic> json) => Circle(
    id: json["_id"],
    circleName: json["circleName"] ?? "Circle Name",
    circleImage: json["circleImage"] ?? circleImagePlaceholder,
    description: json["description"],
    type: json["type"],
    interest: json["interest"] ?? "",
    members: List<Owner>.from(json["members"].map((x) => Owner.fromJson(x))),
    owner: Owner.fromJson(json["owner"]),
    todos: List<String>.from(json["todos"].map((x) => x)),
    events: List<String>.from(json["events"].map((x) => x)),
    convos: json["convos"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "circleName": circleName,
    "circleImage": circleImage,
    "description": description,
    "type": type,
    "interest": interest,
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
    "owner": owner.toJson(),
    "todos": List<dynamic>.from(todos.map((x) => x)),
    "events": List<dynamic>.from(events.map((x) => x)),
    "convos": convos,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Owner {
  String id;
  String name;
  String profilePicture;

  Owner({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  Owner copyWith({
    String? id,
    String? name,
    String? profilePicture,
  }) =>
      Owner(
        id: id ?? this.id,
        name: name ?? this.name,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["_id"],
    name: json["name"] ?? "",
    profilePicture: json["profilePicture"] ?? userimagePlaceholder,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profilePicture": profilePicture,
  };
}
