import 'dart:convert';

import '../../../controller/utils/global_variables.dart';

TodoDetailsModel todoDetailsModelFromJson(String str) => TodoDetailsModel.fromJson(json.decode(str));

String todoDetailsModelToJson(TodoDetailsModel data) => json.encode(data.toJson());

class TodoDetailsModel {
  bool success;
  String message;
  Todo todo;

  TodoDetailsModel({
    required this.success,
    required this.message,
    required this.todo,
  });

  TodoDetailsModel copyWith({
    bool? success,
    String? message,
    Todo? todo,
  }) =>
      TodoDetailsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        todo: todo ?? this.todo,
      );

  factory TodoDetailsModel.fromJson(Map<String, dynamic> json) => TodoDetailsModel(
    success: json["success"],
    message: json["message"],
    todo: Todo.fromJson(json["todo"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "todo": todo.toJson(),
  };
}

class Todo {
  String title;
  String description;
  List<String> images;
  List<Member> members;

  Todo({
    required this.title,
    required this.description,
    required this.images,
    required this.members,
  });

  Todo copyWith({
    String? title,
    String? description,
    List<String>? images,
    List<Member>? members,
  }) =>
      Todo(
        title: title ?? this.title,
        description: description ?? this.description,
        images: images ?? this.images,
        members: members ?? this.members,
      );

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    title: json["title"],
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "images": List<dynamic>.from(images.map((x) => x)),
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
  };
}

class Member {
  String memberId;
  String name;
  String profilePicture;

  Member({
    required this.memberId,
    required this.name,
    required this.profilePicture,
  });

  Member copyWith({
    String? memberId,
    String? name,
    String? profilePicture,
  }) =>
      Member(
        memberId: memberId ?? this.memberId,
        name: name ?? this.name,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberId: json["memberId"],
    name: json["name"] ?? "",
    profilePicture: json["profilePicture"] ?? userimagePlaceholder,
  );

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "name": name,
    "profilePicture": profilePicture,
  };
}
