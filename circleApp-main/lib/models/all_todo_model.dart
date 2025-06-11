import 'dart:convert';

import '../controller/utils/global_variables.dart';

AllTodoModel allTodoModelFromJson(String str) => AllTodoModel.fromJson(json.decode(str));

String allTodoModelToJson(AllTodoModel data) => json.encode(data.toJson());

class AllTodoModel {
  bool success;
  String message;
  List<Todo> todos;
  Pagination pagination;

  AllTodoModel({
    required this.success,
    required this.message,
    required this.todos,
    required this.pagination,
  });

  AllTodoModel copyWith({
    bool? success,
    String? message,
    List<Todo>? todos,
    Pagination? pagination,
  }) =>
      AllTodoModel(
        success: success ?? this.success,
        message: message ?? this.message,
        todos: todos ?? this.todos,
        pagination: pagination ?? this.pagination,
      );

  factory AllTodoModel.fromJson(Map<String, dynamic> json) => AllTodoModel(
    success: json["success"],
    message: json["message"],
    todos: List<Todo>.from(json["todos"].map((x) => Todo.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  int total;
  int page;
  int limit;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
  });

  Pagination copyWith({
    int? total,
    int? page,
    int? limit,
  }) =>
      Pagination(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
  };
}

class Todo {
  String id;
  String title;
  String billStatus;
  int totalBill;
  List<Member> members;

  Todo({
    required this.id,
    required this.title,
    required this.billStatus,
    required this.totalBill,
    required this.members,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? billStatus,
    int? totalBill,
    List<Member>? members,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        billStatus: billStatus ?? this.billStatus,
        totalBill: totalBill ?? this.totalBill,
        members: members ?? this.members,
      );

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"],
    title: json["title"],
    billStatus: json["billStatus"],
    totalBill: json["totalBill"],
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "billStatus": billStatus,
    "totalBill": totalBill,
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
    name: json["name"],
    profilePicture: json["profilePicture"] ?? userimagePlaceholder,
  );

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "name": name,
    "profilePicture": profilePicture,
  };
}
